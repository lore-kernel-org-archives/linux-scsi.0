From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wed, 29 Aug 2007 12:41:52 +0200
Message-ID: <200708291241.52473.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:41652 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXH2KmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2007 06:42:00 -0400
Received: from [83.238.65.58] (helo=[192.168.1.157] ident=matrix157)
	by main.carme.maven.pl with esmtpa (Exim 4.67)
	(envelope-from <arekm@maven.pl>)
	id 1IQKzl-00040w-PG
	for linux-scsi@vger.kernel.org; Wed, 29 Aug 2007 12:41:57 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm trying to get stable kernel for Promise SuperTrak=20
X16350 hardware. So far 2.6.20, 2.6.21 and 2.6.22 oopsed
like this (while doing rsync):

kernel BUG at block/elevator.c:366!
invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: softdog sch_sfq forcedeth ext3 jbd mbcache dm_mod xf=
s scsi_wait_scan sd_mod stex scsi_mod
Pid: 1139:#0, comm: xfsbufd Not tainted 2.6.22.5-0.2 #1
RIP: 0010:[<ffffffff8033f5da>]  [<ffffffff8033f5da>] elv_rb_del+0x3a/0x=
40
RSP: 0000:ffff8100759b1c00  EFLAGS: 00010046
RAX: ffff81000d1f5428 RBX: ffff81000d1f5428 RCX: ffff81007c1a1a00
RDX: 0000000000000000 RSI: ffff81000d1f53b0 RDI: ffff81007c102af0
RBP: ffff81000d1f53b0 R08: ffff81004a9dab50 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff880072c0 R12: ffff81007c102ac0
R13: ffff81007c1a1a00 R14: 0000000000000004 R15: ffff81007c102b18
=46S:  00002ba2cafc9be0(0000) GS:ffff81007d0a5b40(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ba2cab5a158 CR3: 000000003c5ce000 CR4: 00000000000006e0
Process xfsbufd (pid: 1139[#0], threadinfo ffff8100759b0000, task ffff8=
1007cac1040)
Stack:  0000000000000001 ffff81007c102ac0 ffff81000d1f53b0 ffffffff8034=
abe8
 0000000000000246 ffff81000d1f53b0 ffff81007c1a1a00 ffff81007c102ac0
 ffff81007c0f2d08 0000000000000004 ffff81007c102b18 ffffffff8034ad55
Call Trace:
 [<ffffffff8034abe8>] cfq_remove_request+0x78/0x1b0
 [<ffffffff8034ad55>] cfq_dispatch_insert+0x35/0x70
 [<ffffffff8034b61f>] cfq_dispatch_requests+0x1bf/0x3a0
 [<ffffffff8033f11f>] elv_next_request+0x3f/0x150
 [<ffffffff80243b04>] lock_timer_base+0x34/0x70
 [<ffffffff88007329>] :scsi_mod:scsi_request_fn+0x69/0x3d0
 [<ffffffff80343d46>] __make_request+0xe6/0x5d0
 [<ffffffff8034158b>] generic_make_request+0x18b/0x230
 [<ffffffff8034438a>] submit_bio+0x5a/0xf0
 [<ffffffff8808d1e9>] :xfs:_xfs_buf_ioapply+0x199/0x340
 [<ffffffff8808e099>] :xfs:xfs_buf_iorequest+0x29/0x80
 [<ffffffff88092fbb>] :xfs:xfs_bdstrat_cb+0x3b/0x50
 [<ffffffff8808e3c2>] :xfs:xfsbufd+0x92/0x140
 [<ffffffff8808e330>] :xfs:xfsbufd+0x0/0x140
 [<ffffffff8024fa3b>] kthread+0x4b/0x80
 [<ffffffff8020b0a8>] child_rip+0xa/0x12
 [<ffffffff8024f9f0>] kthread+0x0/0x80
 [<ffffffff8020b09e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 66 90 48 83 ec 08 49 89 f8 48 89 f8 31 c9 eb 09
RIP  [<ffffffff8033f5da>] elv_rb_del+0x3a/0x40
 RSP <ffff8100759b1c00>


I can reproduce it without bigger problem.


Here are the same oopses on 2.6.20:
http://paste.stgraber.org/3138

This is 1 x dual core athlon64 on asus m2npv mainboard, 2GB RAM.
There is hw raid on fasttrack 16350 only (no software one).

Has anyone seen this ?

Going to try without cfq.

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
