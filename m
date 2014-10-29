From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 22:50:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295934C1FA@G9W0745.americas.hpqcorp.net>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
 <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee>
 <545102FE.3010003@kernel.dk>
 <alpine.LRH.2.11.1410291738190.12885@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13143 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbaJ2WxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 18:53:14 -0400
In-Reply-To: <alpine.LRH.2.11.1410291738190.12885@adalberg.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Meelis Roos
> Sent: Wednesday, 29 October, 2014 10:38 AM
> To: Jens Axboe
> Cc: linux-scsi@vger.kernel.org; Christoph Hellwig
> Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
> 
> > On 2014-10-29 05:46, Meelis Roos wrote:
> > > > I tried 3.18-rc2 with blk-mq default on on HP ProLiant DL380 G3
> (with HP
> > > > CCISS RAID controller). It fails late in the bootup with "task
> > > > scsi_eh_1:720 blocked for more than 120 seconds." messages.
> > > >
> > > > Booting with scsi_mod.use_blk_mq=0 fixes the problem.
> > >
> > > Another test server with MPT SCSI RAID has similar problem,
> > > scsi_mode.use_blk_mq=0 cures it but I can not get good trace (no
> > serail
> > > console). 3.18.0-rc2-00043-gf7e87a4 was tested there.
> >
> > The first issue looks like scsi cdrom and error handling, it must
> > be leaking
> > requests hence we hang on allocation of a new one. cciss doesn't
> > use blk_mq
> > regardless of the scsi setting. Does the mpt box also have a libata
> > driven cdrom?
> 
> Yes, it does.
> 
> --
> Meelis Roos (mroos@linux.ee)

In the log, the first soft lockup for scsi_eh_1 means the thread 
for host1, which is a pata controller:

...
[   15.069114] scsi host1: pata_serverworks
[   15.173491] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   15.184512] scsi host2: pata_serverworks
[   15.184673] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[   15.184675] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[   15.460452] ata1.00: ATAPI: COMPAQ  CD-ROM SN-124, N104, max PIO4
[   15.476445] ata1.00: configured for PIO4
[   15.477110] scsi 1:0:0:0: CD-ROM            COMPAQ   CD-ROM SN-124    N104 PQ: 0 ANSI: 5 
...
[  240.704040] INFO: task scsi_eh_1:720 blocked for more than 120 seconds.
[  240.783198]       Not tainted 3.18.0-rc2-dirty #22
[  240.840485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.934172] scsi_eh_1       D c1264d7f     0   720      2 0x00000000
[  241.010385]  f5bdbe54 00000046 f5bdbde0 c1264d7f f5bdbe00 00001412 00000000 2be89db4
[  241.103850]  00000004 2be8b1c6 00000004 c1534000 f63bca10 c10892f5 6f223d9e 00000132
[  241.197335]  ffffffff 066087ce f5bdbe50 c10892f5 6f22478a 00000132 ffffffff 066087ce
[  241.290803] Call Trace:
[  241.320039]  [<c1264d7f>] ? put_device+0xf/0x20
[  241.374205]  [<c10892f5>] ? ktime_get+0x45/0x110
[  241.429416]  [<c10892f5>] ? ktime_get+0x45/0x110
[  241.484631]  [<c137d8ee>] schedule+0x1e/0x60
[  241.535679]  [<c137dae7>] io_schedule+0x77/0xc0
[  241.589854]  [<c11c4cd3>] bt_get+0xc3/0x140
[  241.639867]  [<c106b5c0>] ? __wake_up_sync+0x20/0x20
[  241.699240]  [<c11c51fe>] blk_mq_get_tag+0x9e/0xc0
...


