module vibe

fn write_resp(data &char, size usize, nmemb usize, mut userdata Response) usize {
	n := size * nmemb
	userdata.pos += n
	unsafe {
		userdata.body += data.vstring()
	}
	return n
}

fn write_resp_header(data &char, size usize, nmemb usize, mut userdata Response) usize {
	n := size * nmemb
	userdata.pos += n
	unsafe {
		userdata.header += data.vstring()
	}
	return n
}

fn write_resp_slice(data &char, size usize, nmemb usize, mut userdata Response) usize {
	n := size * nmemb
	userdata.pos += n

	if userdata.pos > userdata.slice.start {
		unsafe {
			userdata.body += data.vstring()
		}
		if userdata.slice.end != userdata.slice.start && userdata.pos > userdata.slice.end {
			userdata.slice.finished = true
			return 0
		}
	}

	return n
}
