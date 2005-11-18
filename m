From: "Mr. Berkley Shands" <bshands@exegy.com>
Subject: mpt fusion mptspi broken in 2.6.14 2.5MB/Sec I/O rate
Date: Fri, 18 Nov 2005 15:20:10 -0600
Message-ID: <437E458A.10306@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 66.64.135.114.nw.nuvox.net ([66.64.135.114]:46951 "EHLO
	service.eng.exegy.net") by vger.kernel.org with ESMTP
	id S1750956AbVKRVUT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 16:20:19 -0500
Received: from HANAFORD.eng.exegy.net (hanaford.exegy.us [10.19.4.10])
	by service.eng.exegy.net (8.13.1/8.13.1) with ESMTP id jAILKBiF001447
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 15:20:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Under 2.6.14, I see a problem on a newisys 4300 (a.k.a SunFire V40Z) 
when you put
an MPT Fusion SCSI controller (lsi22320-R ucode 10327) in the internal 
66MHZ slot.
That is the one right under the power supply. If you do that, and 
connect two or more drives
to the external "B" channel, then all drives past the first in the 
string run at 2.5MB/Sec.
No errors, nothing in /var/log/messages. The first drive runs at 72MB/Sec.
Notes: only the "B" channel is affected, and only on the 66MHZ bus. the 
other 100 or 133MHz slots
do not show this problem.

the stock redhat kernel 2.6.9-* runs those drives at 72MB/Sec.
Solaris-10 10/05 release runs those drives at 72MB/Sec.
2.6.14 (and 2.6.13) rolls over and dies. 2.6.12 shows no problems.
So the problem appeared with mptspi vs mptscsih.

hardware is setup as 5 drives internal to the box, sda-sde (all hitachi 
146GB 10K RPM)
and an external storcase 4-drive box with seagate 36GB U320 15K RPM drives,
on the "B" channel ("A" is fine).

Any clues or debug flags/#defines I can set to find this bugger?

berkley

***************************************

under solaris...
[root@blizzard /etc]$ dd if=/dev/rdsk/c4t0d0p0 of=/dev/null count=2

2+0 records in
2+0 records out
[root@blizzard /etc]$ time  dd if=/dev/rdsk/c4t0d0p0 of=/dev/null count=1024 bs=64k
1024+0 records in
1024+0 records out
0.00u 0.05s 0:00.92 5.4%
[root@blizzard /etc]$ time dd if=/dev/rdsk/c4t1d0p0 of=/dev/null count=1024 bs=64k
1024+0 records in
1024+0 records out
0.00u 0.04s 0:00.92 4.3%
[root@blizzard /etc]$ time dd if=/dev/rdsk/c4t3d0p0 of=/dev/null count=1024 bs=64k
1024+0 records in
1024+0 records out
0.00u 0.03s 0:00.91 3.2%

under 2.6.14

 time dd if=/dev/sdh of=/dev/null bs=64k count=1024
1024+0 records in
1024+0 records out
0.004u 0.136s 0:26.08 0.4%      0+0k 0+0io 0pf+0w

time dd if=/dev/sdf of=/dev/null bs=64k count=1024
1024+0 records in
1024+0 records out
0.000u 0.096s 0:00.91 9.8%      0+0k 0+0io 0pf+0w

Linux blizzard 2.6.9-11.ELsmp #1 SMP Wed Jun 8 16:59:12 CDT 2005 x86_64 x86_64 x86_64 GNU/Linux
root@blizzard.eng.exegy.net /root> time dd if=/dev/sdg of=/dev/null bs=64k count=1024
1024+0 records in
1024+0 records out
0.000u 0.120s 0:00.90 13.3%     0+0k 0+0io 0pf+0w


Linux blizzard 2.6.14 #1 SMP Thu Nov 3 13:50:13 CST 2005 x86_64 x86_64 x86_64 GNU/Linux

under 2.6.14 with a local utility...
$O/FileNuke -raw 1 -direct -nofpga -list sdf
FileNuke Version 5.1.0 compiled Nov 17 2005 at 13:35:05
Block size is 65536 (0x10000), 8 Buffers per thread
I/O Buffer is 1536 KB
Single File /dev/sdf: 1 GB long
Started 0 on /dev/sdf Size 1 GB, RawDevice 1 GB, Offset 0 KB, Stride 0 KB
Data: Reading, /code/berkley/sources/bin/x86_64//FileNuke 1 GB, Buffer 64 KB, 14123 MS, 72.5058 MB/Sec
Data: Per-Thread Avg time 14117 MS, Delta 6 MS, for 72.5367 MB/Sec Yield 72.5367 MB/Sec
Min time 14117 MS, Device /dev/sdf for 72.5367 MB/Sec
Max time 14117 MS, Device /dev/sdf for 72.5367 MB/Sec

Processed a total of 1 GB in 14123 MS, for 72.5058 MB/Sec
 File Total 1

$O/FileNuke -raw 1 -direct -nofpga -list sdg
FileNuke Version 5.1.0 compiled Nov 17 2005 at 13:35:05
Block size is 65536 (0x10000), 8 Buffers per thread
I/O Buffer is 1536 KB
Single File /dev/sdg: 1 GB long
Started 0 on /dev/sdg Size 1 GB, RawDevice 1 GB, Offset 0 KB, Stride 0 KB
Data: Reading, /code/berkley/sources/bin/x86_64//FileNuke 1 GB, Buffer 64 KB, 408813 MS, 2.50481 MB/Sec
Data: Per-Thread Avg time 408810 MS, Delta 3 MS, for 2.50483 MB/Sec Yield 2.50483 MB/Sec
Min time 408810 MS, Device /dev/sdg for 2.50483 MB/Sec
Max time 408810 MS, Device /dev/sdg for 2.50483 MB/Sec

Processed a total of 1 GB in 408813 MS, for 2.50481 MB/Sec
 File Total 1

so clearly something broke when the internal pci-x is shared between the motherboard
lsi22320 and an HBA version lsi22320-r.

Under 2.6.13 ---

time dd if=/dev/sdg of=/dev/null bs=64k count=1024
1024+0 records in
1024+0 records out
0.004u 0.108s 0:25.64 0.3%      0+0k 0+0io 0pf+0w

Under 2.6.12 ---

time dd if=/dev/sdg of=/dev/null bs=64k count=1024
1024+0 records in
1024+0 records out
0.000u 0.110s 0:00.91 12.0%     0+0k 0+0io 0pf+0w

