From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Wed, 01 Dec 2010 18:06:51 +0100
Message-ID: <1291223211.2814.72.camel@larosa>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
	 <alpine.LNX.2.00.1011301813460.9731@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:36593 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab0LARGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2010 12:06:54 -0500
In-Reply-To: <alpine.LNX.2.00.1011301813460.9731@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>

Am Dienstag, den 30.11.2010, 18:20 +0200 schrieb Kai Makisara:

Hi, in reply to your earlier mail:

> On Tue, 30 Nov 2010, Lukas Kolbe wrote:
> 
> > On Mon, 2010-11-29 at 19:09 +0200, Kai Makisara wrote:
> > 
> > Hi,
> > 
> > > > On our backup system (2 LTO4 drives/Tandberg library via LSISAS1068E,
> > > > Kernel 2.6.36 with the stock Fusion MPT SAS Host driver 3.04.17 on
> > > > debian/squeeze), we see reproducible tape read and write failures after
> > > > the system was under memory pressure:
> > > > 
> > > > [342567.297152] st0: Can't allocate 2097152 byte tape buffer.
> > > > [342569.316099] st0: Can't allocate 2097152 byte tape buffer.
> > > > [342570.805164] st0: Can't allocate 2097152 byte tape buffer.
> > > > [342571.958331] st0: Can't allocate 2097152 byte tape buffer.
> > > > [342572.704264] st0: Can't allocate 2097152 byte tape buffer.
> > > > [342873.737130] st: from_buffer offset overflow.
> > > > 
> ...
> > > When this fails, the driver tries to allocate a kernel buffer so that 
> > > there larger than 4 kB physically contiguous segments. Let's assume that 
> > > it can find 128 16 kB segments. In this case the maximum block size is 
> > > 2048 kB. Memory pressure results in memory fragmentation and the driver 
> > > can't find large enough segments and allocation fails. This is what you 
> > > are seeing.
> > 
> > Reasonable explanation, thanks. What makes me wonder is why it still
> > fails *after* memory pressure was gone - ie free shows more than 4GiB of
> > free memory. I had the output of /proc/meminfo at that time but can't
> > find it anymore :/
> > 
> This is because (AFAIK) the kernel does not defragment the memory. There 
> may be contiguous free pages but the memory management data structures 
> don't show these.
> 
> > > So, one solution is to use 512 kB block size. Another one is to try to 
> > > find out if the 128 segment limit is a physical limitation or just a 
> > > choice. In the latter case the mptsas driver could be modified to support 
> > > larger block size even after memory fragmentation.
> > 
> > Even with 64kb blocksize (dd bs=64k), I was getting I/O errors trying to
> > access the tape drive. I am now trying to upper the max_sg_segs
> > parameter to the st module (modinfo says 256 is the default; I'm trying
> > 1024 now) and see how well this works under memory pressure.
> > 
> This will not help. The final limit is the minimum of the limit of st and 
> the limit of mtpsas. The mptsas limit is 128. This is the limit that 
> should be increased but I don't know if it is possible.
> 
> If you see error with 64 kB block size, I would like to see any messages 
> associated with these errors.

I have now hit this bug again. Trying to read and write a label from the
tape drive in question results in this (via bacula's btape command):

*readlabel
01-Dec 17:47 btape JobId 0: Error: block.c:1002 Read error on fd=3 at
file:blk 0:0 on device "drv1" (/dev/nst1). ERR=Value too large for
defined data type.
btape: btape.c:525 Volume has no label.

Volume Label:
Id                : **error**VerNo             : 0
VolName           :
PrevVolName       :
VolFile           : 0
LabelType         : Unknown 0
LabelSize         : 0
PoolName          :
MediaType         :
PoolType          :
HostName          :
Date label written: -4712-01-01 at 00:00
*label
Enter Volume Name: AAA543
01-Dec 17:47 btape JobId 0: Error: block.c:577 Write error at 0:0 on
device "drv1" (/dev/nst1). ERR=Input/output error.
01-Dec 17:48 btape JobId 0: Error: Backspace record at EOT failed.
ERR=Input/output error
Wrote Volume label for volume "AAA543".

dmesg says (as expected): 

[158529.011206] st1: Can't allocate 2097152 byte tape buffer.
[158544.348411] st: append_to_buffer offset overflow.
[158544.348416] st: append_to_buffer offset overflow.
[158544.348418] st: append_to_buffer offset overflow.
[158544.348419] st: append_to_buffer offset overflow.

Now a dd with 64kb blocksize behaves really strange:

root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=1
dd: reading `/dev/nst1': Device or resource busy
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.118717 s, 0.0 kB/s

ok, so some process must be using /dev/nst1, right?

root@shepherd:~# lsof  |grep st1

nope, nothing.

Subsequent dd's, only a few seconds later:

root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=1
0+0 records in
0+0 records out
0 bytes (0 B) copied, 4.64747 s, 0.0 kB/s
root@shepherd:~# echo $?
0

Jeha right, we successfully read EOF/EOT

root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=1
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0041229 s, 0.0 kB/s

Possibly another EOT?

root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=1
dd: reading `/dev/nst1': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0128587 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=1
dd: reading `/dev/nst1': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000236144 s, 0.0 kB/s
root@shepherd:~# echo $?
1

Hm, now an I/O error! now dmesg has this to tell me:
[158651.882012] st1: Can't allocate 5085561 byte tape buffer.

Trying to write to the tape looks like below, which seems to match your
earlier description; ie 64/65k works, 128k blocksize works, 256k
blocksize and above don't work anymore. I wasn't able to reproduce not
being able to write with a 64k blocksize at the moment.

root@shepherd:~# lsof  |grep st1
root@shepherd:~# dd if=/dev/zero of=/dev/nst1 bs=65k count=100
100+0 records in
100+0 records out
6656000 bytes (6.7 MB) copied, 2.08872 s, 3.2 MB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst1 bs=64k count=100
100+0 records in
100+0 records out
6553600 bytes (6.6 MB) copied, 1.71815 s, 3.8 MB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst1 bs=512k count=100
dd: writing `/dev/nst1': Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 1.82643 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst1 bs=256k count=100
dd: writing `/dev/nst1': Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 1.71959 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst1 bs=128k count=100
100+0 records in
100+0 records out
13107200 bytes (13 MB) copied, 2.08911 s, 6.3 MB/s
root@shepherd:~# dd if=/dev/zero of=/dev/nst1 bs=64k count=100
100+0 records in
100+0 records out
6553600 bytes (6.6 MB) copied, 1.99401 s, 3.3 MB/s
root@shepherd:~# mt -f /dev/nst1 rewind
root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=100
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00889507 s, 0.0 kB/s
root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=64k count=10^C
root@shepherd:~# lsof  |grep st1
root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=512k count=100
dd: reading `/dev/nst1': Device or resource busy
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000232968 s, 0.0 kB/s
root@shepherd:~# lsof  |grep st1
root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=128k count=100
0+100 records in
0+100 records out
6656000 bytes (6.7 MB) copied, 0.314093 s, 21.2 MB/s
root@shepherd:~# dd if=/dev/nst1 of=/tmp/x bs=256k count=100
dd: reading `/dev/nst1': Device or resource busy
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000367819 s, 0.0 kB/s
root@shepherd:~# lsof  |grep st1
root@shepherd:~# 


Swap is used mainly because of overcommiting RAM to two VMs, but that
memory is rarely accessed.


root@shepherd:~# cat /proc/meminfo 
MemTotal:        8197296 kB
MemFree:           72648 kB
Buffers:           40496 kB
Cached:          1891664 kB
SwapCached:      1131684 kB
Active:          4258136 kB
Inactive:        3452272 kB
Active(anon):    4010488 kB
Inactive(anon):  1767884 kB
Active(file):     247648 kB
Inactive(file):  1684388 kB
Unevictable:         160 kB
Mlocked:             160 kB
SwapTotal:       4194300 kB
SwapFree:        1398976 kB
Dirty:            336920 kB
Writeback:             0 kB
AnonPages:       4648596 kB
Mapped:             4472 kB
Shmem:                12 kB
Slab:             155140 kB
SReclaimable:     109152 kB
SUnreclaim:        45988 kB
KernelStack:        1448 kB
PageTables:        18436 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     8227412 kB
Committed_AS:    7884284 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       59244 kB
VmallocChunk:   34359660812 kB
HardwareCorrupted:     0 kB
HugePages_Total:      64
HugePages_Free:       64
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7488 kB
DirectMap2M:     8380416 kB

I hope this somehow helps,
Lukas


