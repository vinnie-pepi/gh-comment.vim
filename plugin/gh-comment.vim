function! GetSha(blame_output)
  return a:blame_output[0:6]
endfunction

function! GetCommitUrl(sha)
  let l = split(s:SystemGit('config --get remote.origin.url'), ':')
  let repo = l[1][0:-6] " removes the .git and newline
  return 'https://github.com/' . repo .'/commit/' . a:sha
endfunction

function! GitComment()
  let cur_line   = line('.')
  let cur_file   = expand('%:p')
  let git_output = 'blame -L ' . cur_line . ',' . cur_line . ' ' . cur_file
  let blame_output = s:SystemGit(git_output)
  let sha = GetSha(blame_output)
  let url = GetCommitUrl(sha)
  if has('mac') && &shell =~ 'sh$'
    return system('open ' . url)
  else
endfunction

function! s:SystemGit(args)
    " workardound for MacVim, on which shell does not inherit environment
    " variables
    lcd %:p:h
    let cmd = 'git'
    if has('mac') && &shell =~ 'sh$'
        return system('EDITOR="" '. cmd . ' ' . a:args)
    else
        return system(cmd . ' ' . a:args)
    endif
endfunction
command!	GitComment	call GitComment()
command	Gc	GitComment
