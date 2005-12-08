From: "Ian P. Christian" <pookey@pookey.co.uk>
Subject: Re: Strange problems with a Megaraid RAID array on a Dell Poweredge 1850
Date: Thu, 8 Dec 2005 01:21:04 +0000
Message-ID: <200512080121.04953.pookey@pookey.co.uk>
References: <200512080118.17001.pookey@pookey.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xian.ncuk.net ([80.249.110.212]:50656 "EHLO xian.ncuk.net")
	by vger.kernel.org with ESMTP id S932161AbVLHBVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 20:21:07 -0500
In-Reply-To: <200512080118.17001.pookey@pookey.co.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thursday 08 December 2005 01:18, Ian P. Christian wrote:
> # fdisk -l
> Unable to seek on /dev/sda
strace of the fdisk - not sure if it will help at all, but I thought it was 
worth posting:

# strace fdisk /dev/sda
execve("/sbin/fdisk", ["fdisk", "/dev/sda"], [/* 25 vars */]) = 0
uname({sys="Linux", node="bb4", ...})   = 0
brk(0)                                  = 0x8001eb18
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=18962, ...}) = 0
mmap2(NULL, 18962, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fd7000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0yQ\1\000"..., 512) = 
512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1209032, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 
0xb7fd6000
mmap2(NULL, 1141820, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 
0xb7ebf000
mmap2(0xb7fd0000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_DENYWRITE, 3, 0x111) = 0xb7fd0000
mmap2(0xb7fd4000, 7228, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_ANONYMOUS, -1, 0) = 0xb7fd4000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 
0xb7ebe000
mprotect(0xb7fd0000, 4096, PROT_READ)   = 0
mprotect(0x8001a000, 4096, PROT_READ)   = 0
mprotect(0xb7ff2000, 4096, PROT_READ)   = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7ebe6b0, limit:1048575, 
seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, 
seg_not_present:0, useable:1}) = 0
munmap(0xb7fd7000, 18962)               = 0
open("/dev/urandom", O_RDONLY)          = 3
read(3, "\340+\r\304", 4)               = 4
close(3)                                = 0
brk(0)                                  = 0x8001eb18
brk(0x8003fb18)                         = 0x8003fb18
brk(0x80040000)                         = 0x80040000
open("/dev/sda", O_RDWR|O_LARGEFILE)    = 3
read(3, "\353H\220\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 
512
uname({sys="Linux", node="bb4", ...})   = 0
ioctl(3, BLKSSZGET, 0xbfff39dc)         = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 0), ...}) = 0
ioctl(3, 0x301, 0xbfff39d8)             = 0
ioctl(3, BLKGETSIZE, 0xbfff39cc)        = 0
ioctl(3, BLKGETSIZE64, 0xbfff39c0)      = 0
_llseek(0, 0, 0xbfff3968, SEEK_SET)     = -1 ESPIPE (Illegal seek)
write(2, "\n", 1
)                       = 1
write(2, "Unable to seek on /dev/sda\n", 27Unable to seek on /dev/sda
) = 27
exit_group(1)                           = ?


-- 
Ian P. Christian ~ http://pookey.co.uk
