From: Marc Thomas <marc@dragonfly.plus.com>
Subject: [st] "mt-st tell" fails in 2.6.10-rc1
Date: Tue, 2 Nov 2004 12:47:05 +0000 (GMT)
Message-ID: <Pine.LNX.4.60.0411020927280.2947@wrench.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ptb-relay01.plus.net ([212.159.14.212]:7955 "EHLO
	ptb-relay01.plus.net") by vger.kernel.org with ESMTP
	id S261575AbUKBMrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 07:47:04 -0500
Received: from [212.159.71.156] (helo=wrench.lan)
	 by ptb-relay01.plus.net with esmtp (Exim) id 1COy3v-000ICj-MC
	for linux-scsi@vger.kernel.org; Tue, 02 Nov 2004 12:46:59 +0000
Received: from localhost (localhost [127.0.0.1])
	by wrench.lan (8.12.11/8.12.10) with ESMTP id iA2Cl5Yr003119
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2004 12:47:05 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi All,

I've noticed that in 2.6.10-rc1 the "mt tell" command (from mt-st) fails 
to report SCSI tape position, returning "No such device". Other tape 
(read) operations appear to be ok. It worked fine in 2.6.9-rc4.

I'm using the "advansys" SCSI driver, which is marked broken since 2.6.8, 
but despite some warnings it compiles & appears to work for me. The only 
change in advansys.c between 2.6.9-rc4 & 2.6.10-rc1 is
"#include <scsi/scsi_tcq.h>"

There appear to be several changes in st.c in 2.6.10-rc4, which are also 
in the -mm tree. (st.c in 2.6.9-rc4-mm1 & 2.6.10-rc1 are the same).

Unfortunately this is about as far as I can go with my limited C 
programming knowledge. I'll happily try any patches or do any testing as 
required.

Any suggestions anyone?

I've included an "strace" of the mt commands working (2.6.9-rc4) and 
failing (2.6.10-rc1) below, incase its of any use.

Kind Regards,
Marc

FAILING:
=======
root@wrench:/tmp# uname -a
Linux wrench 2.6.10-rc1n #2 Fri Oct 29 10:58:54 BST 2004 i686 unknown unknown GNU/Linux

root@wrench:/tmp# mt -f /dev/nst0 status
SCSI 2 tape drive:
File number=1, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x25 (DDS-3).
Soft error count since last status=0
General status bits on (85010000):
  EOF WR_PROT ONLINE IM_REP_EN

root@wrench:/tmp# mt -f /dev/nst0 tell
/dev/nst0: No such device

root@wrench:/tmp# strace mt -f /dev/nst0 tell
execve("/bin/mt", ["mt", "-f", "/dev/nst0", "tell"], [/* 30 vars */]) = 0
brk(0)                                  = 0x804c000
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40015000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=96504, ...}) = 0
old_mmap(NULL, 96504, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40016000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\360Y\1"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1250840, ...}) = 0
old_mmap(NULL, 1237892, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4002e000
mprotect(0x40156000, 25476, PROT_NONE)  = 0
old_mmap(0x40156000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x128000) = 0x40156000
old_mmap(0x4015a000, 9092, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4015a000
close(3)                                = 0
munmap(0x40016000, 96504)               = 0
open("/dev/nst0", O_RDONLY)             = 3
ioctl(3, MGSL_IOCGTXIDLE or MTIOCPOS, 0xbffff754) = -1 ENODEV (No such device)
dup(2)                                  = 4
fcntl64(4, F_GETFL)                     = 0x2 (flags O_RDWR)
brk(0)                                  = 0x804c000
brk(0x804d000)                          = 0x804d000
brk(0)                                  = 0x804d000
fstat64(4, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 16), ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40016000
_llseek(4, 0, 0xbffff580, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
write(4, "/dev/nst0: No such device\n", 26/dev/nst0: No such device
) = 26
close(4)                                = 0
munmap(0x40016000, 4096)                = 0
ioctl(3, MGSL_IOCSTXIDLE or MTIOCGET or SNDCTL_MIDI_MPUCMD, 0xbffff73c) = 0
close(3)                                = 0
exit_group(2)                           = ?

WORKING:
=======
root@wrench:/tmp# uname -a
Linux wrench 2.6.9-rc4n #2 Tue Nov 2 11:49:53 GMT 2004 i686 unknown unknown GNU/Linux

root@wrench:/tmp# mt -f /dev/nst0 status
SCSI 2 tape drive:
File number=1, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x25 (DDS-3).
Soft error count since last status=0
General status bits on (85010000):
  EOF WR_PROT ONLINE IM_REP_EN

root@wrench:/tmp# mt -f /dev/nst0 tell
At block 147554.

root@wrench:/tmp# strace mt -f /dev/nst0 tell
execve("/bin/mt", ["mt", "-f", "/dev/nst0", "tell"], [/* 31 vars */]) = 0
brk(0)                                  = 0x804c000
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7feb000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=96504, ...}) = 0
old_mmap(NULL, 96504, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fd3000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\360Y\1"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1250840, ...}) = 0
old_mmap(NULL, 1237892, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb7ea4000
mprotect(0xb7fcc000, 25476, PROT_NONE)  = 0
old_mmap(0xb7fcc000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x128000) = 0xb7fcc000
old_mmap(0xb7fd0000, 9092, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7fd0000
close(3)                                = 0
munmap(0xb7fd3000, 96504)               = 0
open("/dev/nst0", O_RDONLY)             = 3
ioctl(3, MGSL_IOCGTXIDLE or MTIOCPOS, 0xbffff744) = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fea000
write(1, "At block 147554.\n", 17At block 147554.
)      = 17
close(3)                                = 0
munmap(0xb7fea000, 4096)                = 0
exit_group(0)                           = ?
