From: Aniket Kulkarni <aniket@linux.vnet.ibm.com>
Subject: Panic in scsi_dispatch_cmd
Date: Mon, 07 May 2012 16:50:21 -0400
Message-ID: <20120507165021.Horde.CrPjrpir309PqDWNl9J0ceA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42346 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab2EGUvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2012 16:51:33 -0400
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <aniket@linux.vnet.ibm.com>;
	Mon, 7 May 2012 16:51:29 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id F121E38C803A
	for <linux-scsi@vger.kernel.org>; Mon,  7 May 2012 16:50:23 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q47KoNdR16580674
	for <linux-scsi@vger.kernel.org>; Mon, 7 May 2012 16:50:23 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47KoNB9008525
	for <linux-scsi@vger.kernel.org>; Mon, 7 May 2012 16:50:23 -0400
Received: from imap.linux.ibm.com (maier.raleigh.ibm.com [9.37.253.158])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id q47KoMgH008439
	for <linux-scsi@vger.kernel.org>; Mon, 7 May 2012 16:50:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have a setup with a 12 daisy chained EXP2524 enclosures connected to
a server such that each of the disks are accessible via two paths
through multiple sas expanders. The server has 2 dual ported HBAs. I'm
running 2.6.32 kernel variant based on RHEL 6.0. I have seen this on =20
2.6.31 as well.

I see panics like this frequently when there are some path failures;
the panics seem to be caused by someone (HBA driver?) freeing up a
Scsi_Host even when there is some deferred work outstanding -

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81354aab>] _spin_lock_irqsave+0x1b/0x40
PGD 2075380067 PUD 2075381067 PMD 2075f64067 PTE 0
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/nisoc/fpga/1/errors/seu_multi_bit
CPU 0
Modules linked in: nzds disklog nztmpfs ext3 jbd dm_round_robin
dm_multipath dm_mod linear raid0 raid10 raid1 md_mod mptctl mptbase sg
sd_mod ipmi_devintf mpt2sas scsi_transport_sas raid_clas
s scsi_mod i2c_i801 i2c_core ipmi_si ipmi_msghandler nisoc bonding
bnx2x crc32c libcrc32c crypto_hash crypto_algapi crypto mdio

Modules linked in: nzds disklog nztmpfs ext3 jbd dm_round_robin
dm_multipath dm_mod linear raid0 raid10 raid1 md_mod mptctl mptbase sg
sd_mod ipmi_devintf mpt2sas scsi_transport_sas raid_class scsi_mod
i2c_i801 i2c_core ipmi_si ipmi_msghandler nisoc bonding bnx2x crc32c
libcrc32c crypto_hash crypto_algapi crypto mdio
Pid: 255, comm: kblockd/0 Not tainted 2.6.32-71.29.88.nps1_0.x86_64 #1
BladeCenter Hx5 -[7872AC1]-
RIP: 0010:[<ffffffff81354aab>]  [<ffffffff81354aab>]
_spin_lock_irqsave+0x1b/0x40
RSP: 0000:ffff881079483ba0  EFLAGS: 00010003
RAX: 0000000000000287 RBX: ffff881079464800 RCX: 0000000000000000
RDX: 0000000000010000 RSI: 000000000000000a RDI: 0000000000000000
RBP: ffff881079483ba0 R08: ffff881079482000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff881079464b00
R13: 0000000000000000 R14: ffff881079464800 R15: ffff880fe634fdc8
=46S:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000002075fb4000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kblockd/0 (pid: 255, threadinfo ffff881079482000, task
ffff881079479820)
Stack:
   ffff881079483bd0 ffffffffa00dc53a ffff880ff1d28800 ffff880ff1d1b3f0
<0> ffff88106be44000 ffff881079464800 ffff881079483c30 ffffffffa00e4284
<0> ffff880d553b3380 ffff880fe634fdb0 ffff880ff1d28938 ffff880ff1d28848
Call Trace:
   [<ffffffffa00dc53a>] scsi_dispatch_cmd+0x13a/0x380 [scsi_mod]
   [<ffffffffa00e4284>] scsi_request_fn+0x414/0x5b0 [scsi_mod]
   [<ffffffff811c3eed>] __blk_run_queue+0x5d/0x160
   [<ffffffff811bcc6f>] elv_insert+0x13f/0x230
   [<ffffffff811bcdc2>] __elv_add_request+0x62/0xc0
   [<ffffffff811c2734>] blk_insert_cloned_request+0x74/0xa0
   [<ffffffffa01d2367>] dm_dispatch_request+0x37/0x50 [dm_mod]
   [<ffffffffa01d2440>] map_request+0xc0/0x140 [dm_mod]
   [<ffffffffa01d3958>] dm_request_fn+0xa8/0x170 [dm_mod]
   [<ffffffff811c421d>] __generic_unplug_device+0x2d/0x40
   [<ffffffff811c4259>] generic_unplug_device+0x29/0x40
   [<ffffffffa01d2668>] dm_unplug_all+0x68/0x70 [dm_mod]
   [<ffffffff811be9a0>] ? blk_unplug_work+0x0/0xa0
   [<ffffffff811be9d3>] blk_unplug_work+0x33/0xa0
   [<ffffffff811be9a0>] ? blk_unplug_work+0x0/0xa0
   [<ffffffff81069b27>] worker_thread+0x197/0x330
   [<ffffffff8106e810>] ? autoremove_wake_function+0x0/0x40
   [<ffffffff81069990>] ? worker_thread+0x0/0x330
   [<ffffffff8106e44e>] kthread+0x8e/0xa0
   [<ffffffff8100ce8a>] child_rip+0xa/0x20
   [<ffffffff8106e3c0>] ? kthread+0x0/0xa0
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81354aab>] _spin_lock_irqsave+0x1b/0x40
PGD 2075380067 PUD 2075381067 PMD 2075f64067 PTE 0
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/nisoc/fpga/1/errors/seu_multi_bit
=2E. snip ..
RIP: 0010:[<ffffffff81354aab>] =A0[<ffffffff81354aab>]
_spin_lock_irqsave+0x1b/0x40
RSP: 0000:ffff881079483ba0 =A0EFLAGS: 00010003
=2E.snip..
Process kblockd/0 (pid: 255, threadinfo ffff881079482000, task
ffff881079479820)
Stack:
=A0ffff881079483bd0 ffffffffa00dc53a ffff880ff1d28800 ffff880ff1d1b3f0
<0> ffff88106be44000 ffff881079464800 ffff881079483c30 ffffffffa00e4284
<0> ffff880d553b3380 ffff880fe634fdb0 ffff880ff1d28938 ffff880ff1d28848
Call Trace:
=A0[<ffffffffa00dc53a>] scsi_dispatch_cmd+0x13a/0x380 [scsi_mod]
=A0[<ffffffffa00e4284>] scsi_request_fn+0x414/0x5b0 [scsi_mod]
=A0[<ffffffff811c3eed>] __blk_run_queue+0x5d/0x160
=A0[<ffffffff811bcc6f>] elv_insert+0x13f/0x230
=A0[<ffffffff811bcdc2>] __elv_add_request+0x62/0xc0
=A0[<ffffffff811c2734>] blk_insert_cloned_request+0x74/0xa0
=A0[<ffffffffa01d2367>] dm_dispatch_request+0x37/0x50 [dm_mod]
=A0[<ffffffffa01d2440>] map_request+0xc0/0x140 [dm_mod]
=A0[<ffffffffa01d3958>] dm_request_fn+0xa8/0x170 [dm_mod]
=A0[<ffffffff811c421d>] __generic_unplug_device+0x2d/0x40
=A0[<ffffffff811c4259>] generic_unplug_device+0x29/0x40
=A0[<ffffffffa01d2668>] dm_unplug_all+0x68/0x70 [dm_mod]
=A0[<ffffffff811be9a0>] ? blk_unplug_work+0x0/0xa0
=A0[<ffffffff811be9d3>] blk_unplug_work+0x33/0xa0
=A0[<ffffffff811be9a0>] ? blk_unplug_work+0x0/0xa0
=A0[<ffffffff81069b27>] worker_thread+0x197/0x330
=A0[<ffffffff8106e810>] ? autoremove_wake_function+0x0/0x40
=A0[<ffffffff81069990>] ? worker_thread+0x0/0x330
=A0[<ffffffff8106e44e>] kthread+0x8e/0xa0
=A0[<ffffffff8100ce8a>] child_rip+0xa/0x20
=A0[<ffffffff8106e3c0>] ? kthread+0x0/0xa0
=A0[<ffffffff8100ce80>] ? child_rip+0x0/0x20
Code: e0 ff ff f0 83 2f 01 79 05 e8 d2 e5 e8 ff c9 c3 55 48 89 e5 9c
58 fa 65 48 8b 14 25 08 b5 00 00 ff 82 44 e0 ff ff ba 00 00 01 00 <f0>
0f c1 17 0f b7 ca c1 ea 10 39 d1 74 0e f3 90 0f b7 0f eb f5
RIP  [<ffffffff81354aab>] _spin_lock_irqsave+0x1b/0x40
   RSP <ffff881079483ba0>
CR2: 0000000000000000

A crash dump analysis shows that the scsi_device in the queue being
flushed has been freed away even though we should've had a ref count
on it.

crash> *scsi_device.vendor 0xffff8810724b2810
=A0=A0vendor =3D 0xffff880ff2170260 "SB24EA0036BPSB24SB24SB24",

crash> p ((struct scsi_device *)0xffff8810724b2810)->sdev_gendev.kobj
$19 =3D {
=A0=A0name =3D 0xffff881063007040 "P)Kr\020\210\377\377\030r",
=A0.. snip ..
=A0=A0sd =3D 0x0,
=A0=A0kref =3D {
=A0=A0 =A0refcount =3D {
=A0=A0 =A0 =A0counter =3D -1609559904
=A0=A0 =A0}
=A0=A0.. snip ..

I was wondering if anyone had encountered this or something similar.
Any comments or pointers to similar patches would be very helpful.

Thanks in advance.
--
aniket

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
