From: Roland Stigge <stigge@debian.org>
Subject: Kernel hang w/ aacraid on supermicro X8SIE
Date: Sun, 22 Jan 2012 13:05:42 +0100
Message-ID: <4F1BFB96.3090905@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from antcom.de ([188.40.178.216]:35788 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2AVMLl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2012 07:11:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com, JBottomley@parallels.com

Hi,

I'm experiencing serious temporary kernel hangs on a Supermicro X8SIE
machine with an aacraid controller. I'm suspecting the latter one since
the issue looks similar to:

=========================================================================
commit cf16123c9c8e346ed1dd171295a678d77648d7f8
Author: Vasily Averin <vvs@parallels.com>
Date:   Fri Nov 11 13:42:16 2011 +0400

    [SCSI] aacraid: controller hangs if kernel uses non-default ASPM policy
=========================================================================

The problem is triggered by regular nightly backup rsyncs and is
reproducible: The below kernel traces happen _once_ around the first
nightly rsync after booting. During following days, no further traces
are written, but the machine feels generally slow. I/O during the rsync
runs leading to load values >30.

Both the AAC RAID and the Supermicro board have already been replaced
(with same models) but the problem is still there.

=========================================================================
[29040.293627] INFO: task flush-8:0:1074 blocked for more than 120 seconds.
[29040.293676] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[29040.293727] flush-8:0       D ffff880131ffcfc0     0  1074      2
0x00000000
[29040.293730]  ffff880131ffcfc0 0000000000000046 ffff880100000000
ffff880134f480c0
[29040.293733]  0000000000013440 ffff8801319f9fd8 ffff8801319f9fd8
0000000000013440
[29040.293735]  ffff880131ffcfc0 ffff8801319f8010 ffff8801319f9810
00000001319f9810
[29040.293738] Call Trace:
[29040.293746]  [<ffffffff8134b6dc>] ? io_schedule+0x84/0xc3
[29040.293750]  [<ffffffff811a16f1>] ? get_request_wait+0x104/0x199
[29040.293753]  [<ffffffff81061b25>] ? wake_up_bit+0x20/0x20
[29040.293756]  [<ffffffff811a1bc8>] ? blk_queue_bio+0x17a/0x2ce
[29040.293759]  [<ffffffff81129076>] ? T.1020+0x17/0x17
[29040.293761]  [<ffffffff811a106e>] ? generic_make_request+0x8e/0xcd
[29040.293763]  [<ffffffff811a1186>] ? submit_bio+0xd9/0xf7
[29040.293765]  [<ffffffff81129076>] ? T.1020+0x17/0x17
[29040.293767]  [<ffffffff8112be2d>] ? bio_alloc_bioset+0x44/0xb3
[29040.293770]  [<ffffffff81127cd1>] ? submit_bh+0xe5/0x105
[29040.293772]  [<ffffffff8112a360>] ? __block_write_full_page+0x1dd/0x2b5
[29040.293774]  [<ffffffff8112c354>] ? I_BDEV+0x8/0x8
[29040.293778]  [<ffffffff810c31e2>] ? __writepage+0xa/0x21
[29040.293781]  [<ffffffff810c42d5>] ? write_cache_pages+0x226/0x31e
[29040.293783]  [<ffffffff810c31d8>] ? set_page_dirty+0x61/0x61
[29040.293785]  [<ffffffff810c440b>] ? generic_writepages+0x3e/0x55
[29040.293790]  [<ffffffff81122b15>] ? writeback_single_inode+0x178/0x35e
[29040.293792]  [<ffffffff81123015>] ? writeback_sb_inodes+0x169/0x1ff
[29040.293794]  [<ffffffff81123118>] ? __writeback_inodes_wb+0x6d/0xab
[29040.293796]  [<ffffffff8112333f>] ? wb_writeback+0x128/0x222
[29040.293798]  [<ffffffff8134b36d>] ? __schedule+0x5a0/0x5cd
[29040.293800]  [<ffffffff811235b2>] ? wb_do_writeback+0x179/0x1de
[29040.293805]  [<ffffffff81053dcb>] ? del_timer_sync+0x34/0x3e
[29040.293807]  [<ffffffff811236da>] ? bdi_writeback_thread+0xc3/0x1fe
[29040.293809]  [<ffffffff81123617>] ? wb_do_writeback+0x1de/0x1de
[29040.293811]  [<ffffffff81123617>] ? wb_do_writeback+0x1de/0x1de
[29040.293813]  [<ffffffff810616e9>] ? kthread+0x7a/0x82
[29040.293816]  [<ffffffff81354eb4>] ? kernel_thread_helper+0x4/0x10
[29040.293818]  [<ffffffff8106166f>] ? kthread_worker_fn+0x147/0x147
[29040.293820]  [<ffffffff81354eb0>] ? gs_change+0x13/0x13
=========================================================================

See also full kernel log at
http://antcom.de/linux-aacraid-supermicro-X8SIE.dmesg

Please redirect me if you suspect the problem elsewhere.

Thanks in advance,

Roland
