From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: udev hangs USB-storage (HP r707 camera)
Date: Sat, 19 Jan 2008 19:28:29 -0700
Message-ID: <20080120022829.GG11553@colo.lackof.org>
References: <20080119174556.GE11553@colo.lackof.org> <47929B9F.8080607@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:41571 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYATC2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jan 2008 21:28:48 -0500
Content-Disposition: inline
In-Reply-To: <47929B9F.8080607@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jan 20, 2008 at 01:53:51AM +0100, Stefan Richter wrote:
> Grant Grundler wrote:
> >     https://bugs.launchpad.net/ubuntu/+source/hal/+bug/180472
> ...
> > I have a usbmon trace for 2.6.23.13 (appended) along with dmesg output.
> > What I need is someone to interpret this trace, tell me what happened,
> > then I can work on tracking down "vol_id"'s role in this mess.
> 
> You can also enable SCSI command logging.  Perhaps userspace sends a
> specific command which offends the device (because The Other OS wouldn't
> send that command in this order of sequence).

Thanks for reminding me...I had collected strace output of udev and all
it's children a few days ago (probably with 2.6.22-14-generic (Ubuntu
kernel). I've appended everything for PID 17972 (which is only 12k, full
output is 559KB). Key bit is this:
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3,  <unfinished ...>
17972 <... read resumed> 0x804dc80, 512) = -1 EIO (Input/output error)

given the device reports "60801 512-byte hardware sectors (31 MB)"
and "31129600/512 == 60800"...it's obvious vol_id is trying to read
the last sector on the disk (I assume it's to verify the size).
ISTR "reading the last sector" caused problems else where.
I'll try to hunt that down.

If someone could fish more details out of the usbmon trace about
reading the last sector, that would be helpful.

> # echo 9216 > /sys/module/scsi_mod/parameters/scsi_logging_level
> That's what I wrote down on a piece of paper a long time ago; don't ask
> me what it means in detail.  :-)

Thanks - I can sort that out later. I don't think I need it right now.

cheers,
grant


17963 clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xb7e00908) = 17972
17972 close(3)                          = 0
17972 open("/dev/null", O_RDWR|O_LARGEFILE) = 3
17972 dup2(3, 0)                        = 0
17972 dup2(3, 2)                        = 2
17972 close(3)                          = 0
17972 dup2(4, 1)                        = 1
17972 close(4)                          = 0
17972 execve("/lib/udev/vol_id", ["/lib/udev/vol_id", "--export", "/dev/.tmp-8-16"], [/* 21 vars */]) = 0
17972 brk(0)                            = 0x804c000
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f52000
17972 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
17972 open("/etc/ld.so.cache", O_RDONLY) = 3
17972 fstat64(3, {st_mode=S_IFREG|0644, st_size=62726, ...}) = 0
17972 mmap2(NULL, 62726, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f42000
17972 close(3)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/libvolume_id.so.0", O_RDONLY) = 3
17972 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\25"..., 512) = 512
17972 fstat64(3, {st_mode=S_IFREG|0644, st_size=27428, ...}) = 0
17972 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f41000
17972 mmap2(NULL, 30296, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f39000
17972 mmap2(0xb7f40000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6) = 0xb7f40000
17972 close(3)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/libselinux.so.1", O_RDONLY) = 3
17972 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 ?\0\000"..., 512) = 512
17972 fstat64(3, {st_mode=S_IFREG|0644, st_size=83516, ...}) = 0
17972 mmap2(NULL, 88980, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f23000
17972 mmap2(0xb7f37000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13) = 0xb7f37000
17972 close(3)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/libsepol.so.1", O_RDONLY) = 3
17972 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@.\0\000"..., 512) = 512
17972 fstat64(3, {st_mode=S_IFREG|0644, st_size=219668, ...}) = 0
17972 mmap2(NULL, 264992, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7ee2000
17972 mmap2(0xb7f18000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x35) = 0xb7f18000
17972 mmap2(0xb7f19000, 39712, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f19000
17972 close(3)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 3
17972 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260a\1"..., 512) = 512
17972 fstat64(3, {st_mode=S_IFREG|0644, st_size=1339816, ...}) = 0
17972 mmap2(NULL, 1349136, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d98000
17972 mmap2(0xb7edc000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x143) = 0xb7edc000
17972 mmap2(0xb7edf000, 9744, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7edf000
17972 close(3)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/tls/i686/cmov/libdl.so.2", O_RDONLY) = 3
17972 read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\n\0\000"..., 512) = 512
17972 fstat64(3, {st_mode=S_IFREG|0644, st_size=9684, ...}) = 0
17972 mmap2(NULL, 12412, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d94000
17972 mmap2(0xb7d96000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7d96000
17972 close(3)                          = 0
17972 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7d93000
17972 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7d92000
17972 set_thread_area({entry_number:-1 -> 6, base_addr:0xb7d93b80, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
17972 mprotect(0xb7edc000, 4096, PROT_READ) = 0
17972 munmap(0xb7f42000, 62726)         = 0
17972 brk(0)                            = 0x804c000
17972 brk(0x806d000)                    = 0x806d000
17972 open("/etc/selinux/config", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
17972 statfs64("/selinux", 84, 0xbfdb1170) = -1 ENOENT (No such file or directory)
17972 open("/proc/mounts", O_RDONLY|O_LARGEFILE) = 3
17972 fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
17972 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f51000
17972 read(3, "rootfs / rootfs rw 0 0\nnone /sys"..., 1024) = 681
17972 read(3, "", 1024)                 = 0
17972 close(3)                          = 0
17972 munmap(0xb7f51000, 4096)          = 0
17972 open("/dev/.tmp-8-16", O_RDONLY|O_LARGEFILE) = 3
17972 ioctl(3, BLKGETSIZE64, 0xbfdb0eb8) = 0
17972 getuid32()                        = 0
17972 socket(PF_FILE, SOCK_STREAM, 0)   = 4
17972 fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK) = 0
17972 connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
17972 close(4)                          = 0
17972 socket(PF_FILE, SOCK_STREAM, 0)   = 4
17972 fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK) = 0
17972 connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
17972 close(4)                          = 0
17972 open("/etc/nsswitch.conf", O_RDONLY) = 4
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=465, ...}) = 0
17972 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f51000
17972 read(4, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) = 465
17972 read(4, "", 4096)                 = 0
17972 close(4)                          = 0
17972 munmap(0xb7f51000, 4096)          = 0
17972 open("/etc/ld.so.cache", O_RDONLY) = 4
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=62726, ...}) = 0
17972 mmap2(NULL, 62726, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7f42000
17972 close(4)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/tls/i686/cmov/libnss_compat.so.2", O_RDONLY) = 4
17972 read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\16\0\000"..., 512) = 512
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=30436, ...}) = 0
17972 mmap2(NULL, 33348, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7d89000
17972 mmap2(0xb7d90000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x6) = 0xb7d90000
17972 close(4)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/tls/i686/cmov/libnsl.so.1", O_RDONLY) = 4
17972 read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p1\0\000"..., 512) = 512
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=83712, ...}) = 0
17972 mmap2(NULL, 96232, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7d71000
17972 mmap2(0xb7d85000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x13) = 0xb7d85000
17972 mmap2(0xb7d87000, 6120, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7d87000
17972 close(4)                          = 0
17972 munmap(0xb7f42000, 62726)         = 0
17972 open("/etc/ld.so.cache", O_RDONLY) = 4
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=62726, ...}) = 0
17972 mmap2(NULL, 62726, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7f42000
17972 close(4)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/tls/i686/cmov/libnss_nis.so.2", O_RDONLY) = 4
17972 read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 \31\0\000"..., 512) = 512
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=34352, ...}) = 0
17972 mmap2(NULL, 37436, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7d67000
17972 mmap2(0xb7d6f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x7) = 0xb7d6f000
17972 close(4)                          = 0
17972 access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
17972 open("/lib/tls/i686/cmov/libnss_files.so.2", O_RDONLY) = 4
17972 read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 \31\0\000"..., 512) = 512
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=38420, ...}) = 0
17972 mmap2(NULL, 41624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7d5c000
17972 mmap2(0xb7d65000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x8) = 0xb7d65000
17972 close(4)                          = 0
17972 munmap(0xb7f42000, 62726)         = 0
17972 open("/etc/passwd", O_RDONLY)     = 4
17972 fcntl64(4, F_GETFD)               = 0
17972 fcntl64(4, F_SETFD, FD_CLOEXEC)   = 0
17972 _llseek(4, 0, [0], SEEK_CUR)      = 0
17972 fstat64(4, {st_mode=S_IFREG|0644, st_size=1713, ...}) = 0
17972 mmap2(NULL, 1713, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f51000
17972 _llseek(4, 1713, [1713], SEEK_SET) = 0
17972 munmap(0xb7f51000, 1713)          = 0
17972 close(4)                          = 0
17972 setgroups32(0, [])                = 0
17972 setgid32(65534)                   = 0
17972 setuid32(65534)                   = 0
17972 _llseek(3, 31064064, [31064064], SEEK_SET) = 0
17972 read(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 2048) = 2048
17972 _llseek(3, 31121408, [31121408], SEEK_SET) = 0
17972 read(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 2048) = 2048
17972 brk(0x808f000)                    = 0x808f000
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048) = 2048
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 6144) = 6144
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3,  <unfinished ...>
17972 <... read resumed> 0x804dc80, 512) = -1 EIO (Input/output error)
17972 _llseek(3, 31129088, [31129088], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31129088, [31129088], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31097856, [31097856], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31124480, [31124480], SEEK_SET) = 0
17972 read(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 512) = 512
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
17972 read(3, 0x804dc80, 512)           = -1 EIO (Input/output error)
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 8192) = 8192
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 16384) = 16384
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 66048) = 20480
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 33280) = 20480
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 33280) = 20480
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 33280) = 20480
17972 _llseek(3, 0, [0], SEEK_SET)      = 0
17972 read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 67584) = 20480
17972 write(2, "/dev/.tmp-8-16: unknown volume t"..., 36) = 36
17972 brk(0x807e000)                    = 0x807e000
17972 brk(0x806e000)                    = 0x806e000
17972 exit_group(4)                     = ?
17963 waitpid(17972, [{WIFEXITED(s) && WEXITSTATUS(s) == 4}], 0) = 17972
