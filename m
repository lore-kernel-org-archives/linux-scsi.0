From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Media autochanger driver changed behavior.
Date: Wed, 10 Sep 2008 13:37:56 +0200
Message-ID: <48C7B194.1050607@krogh.cc>
References: <487524B9.7000203@krogh.cc>	 <1215640274.3444.42.camel@localhost.localdomain>	 <4875342B.5060702@krogh.cc>	 <1215641850.3444.52.camel@localhost.localdomain>	 <4875A53E.4030909@krogh.cc> <1215698421.3353.15.camel@localhost.localdomain> <4877B146.3090503@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:46598 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbYIJLiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 07:38:09 -0400
In-Reply-To: <4877B146.3090503@krogh.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

> I'll get it done and report but, but we're a bit behind on the 
> backup-schedules. So when the system has catched up I'll do some testing.

On 2.6.26.1 I also get quite strange behavior .. sometimes the changer 
id discovered as a "sgX" device and sometimes it is discovered as a 
"schX".. the schX doesnt work:


$ lsscsi
[0:0:0:0]    cd/dvd  AMI      Virtual CDROM    1.00  /dev/scd0
[1:0:0:0]    disk    AMI      Virtual Floppy   1.00  /dev/sda
[2:0:0:0]    disk    HITACHI  H101414SCSUN146G SA23  -
[2:0:1:0]    disk    HITACHI  H101414SCSUN146G SA23  -
[2:0:2:0]    disk    FUJITSU  MBB2147RCSUN146G 0505  -
[2:0:3:0]    disk    FUJITSU  MBB2147RCSUN146G 0505  -
[2:1:0:0]    disk    LSILOGIC Logical Volume   3000  /dev/sdc
[2:1:2:0]    disk    LSILOGIC Logical Volume   3000  /dev/sdb
[3:0:0:0]    mediumx QUANTUM  PX500            002A  /dev/sch0
[3:0:3:0]    tape    HP       Ultrium 3-SCSI   G39Z  /dev/st0

When it works.. I dont have any device put onto the mediumx-thing in 
this list. And none of the sgX devices actually works. Rebooting the 
system "might" bring it correcly up.

Full dmesg: http://krogh.cc/~jesper/dmesg-broken.txt

/dev/changer is made by this udev rule:

/etc/udev/rules.d/60-symlinks.rules:SYSFS{vendor}=="QUANTUM", 
SYSFS{model}=="PX500"         SYMLINK+="changer"

jk@bacula:~$ sudo mtx -f /dev/sch0 status
/dev/sch0 is not an sg device, or old sg driver

$ sudo strace mtx -f /dev/sch0 status
execve("/usr/sbin/mtx", ["mtx", "-f", "/dev/sch0", "status"], [/* 16 
vars */]) = 0
brk(0)                                  = 0x60b000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7f049f174000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or 
directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7f049f172000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=38937, ...}) = 0
mmap(NULL, 38937, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f049f168000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or 
directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\342"..., 
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1436976, ...}) = 0
mmap(NULL, 3543672, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 
0) = 0x7f049ebf6000
mprotect(0x7f049ed4e000, 2097152, PROT_NONE) = 0
mmap(0x7f049ef4e000, 20480, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x158000) = 0x7f049ef4e000
mmap(0x7f049ef53000, 17016, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f049ef53000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7f049f167000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7f049f166000
arch_prctl(ARCH_SET_FS, 0x7f049f1666e0) = 0
mprotect(0x7f049ef4e000, 12288, PROT_READ) = 0
munmap(0x7f049f168000, 38937)           = 0
open("/dev/sch0", O_RDWR)               = 3
ioctl(3, SG_GET_VERSION_NUM, 0x7fffa7175b30) = -1 EINVAL (Invalid argument)
write(2, "/dev/sch0 is not an sg device, o"..., 48/dev/sch0 is not an sg 
device, or old sg driver
) = 48
exit_group(1)                           = ?
Process 8139 detached
jk@bacula:~$

-- 
Jesper
