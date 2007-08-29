From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wed, 29 Aug 2007 15:15:58 +0200
Message-ID: <200708291515.59105.arekm@maven.pl>
References: <200708291241.52473.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:25538 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbXH2NQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2007 09:16:07 -0400
Received: from [83.238.65.58] (helo=[192.168.1.157] ident=matrix157)
	by main.carme.maven.pl with esmtpa (Exim 4.67)
	(envelope-from <arekm@maven.pl>)
	id 1IQNOv-00084z-Ly
	for linux-scsi@vger.kernel.org; Wed, 29 Aug 2007 15:16:05 +0200
In-Reply-To: <200708291241.52473.arekm@maven.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wednesday 29 of August 2007, Arkadiusz Miskiewicz wrote:
> Hello,
>
> I'm trying to get stable kernel for Promise SuperTrak
> X16350 hardware. So far 2.6.20, 2.6.21 and 2.6.22 oopsed
> like this (while doing rsync):

With anticipatory:

berta login: ------------[ cut here ]------------
kernel BUG at block/as-iosched.c:1084!
invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: softdog sch_sfq forcedeth ext3 jbd mbcache dm_mod xf=
s scsi_wait_scan sd_mod stex scsi_mod
Pid: 32:#0, comm: kblockd/1 Not tainted 2.6.22.5-0.2 #1
RIP: 0010:[<ffffffff80349028>]  [<ffffffff80349028>] as_dispatch_reques=
t+0x438/0x460
RSP: 0018:ffff81007d1fddc0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81007c765a00 RCX: 00000000ffffffff
RDX: ffff81007c765a28 RSI: 0000000000000000 RDI: ffff81007c54ad08
RBP: 0000000000000000 R08: ffffffffffffffff R09: ffff81006a289d80
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: ffff81007cf85048
=46S:  00002ba4421e8b00(0000) GS:ffff81007d0a5b40(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ba46298f000 CR3: 0000000050951000 CR4: 00000000000006e0
Process kblockd/1 (pid: 32[#0], threadinfo ffff81007d1fc000, task ffff8=
1007d1db040)
Stack:  ffff81007c54ad08 ffff81007cf85000 ffff81007cf7e000 ffff81007d1f=
de00
 ffff81006a289cc0 ffffffff8033f11f 0000000000000287 ffffffff88000fa8
 ffff81001646a6f8 0000000000000000 ffff81007cf85000 ffff81007cf7e000
Call Trace:
 [<ffffffff8033f11f>] elv_next_request+0x3f/0x150
 [<ffffffff88000fa8>] :scsi_mod:scsi_dispatch_cmd+0x1c8/0x310
 [<ffffffff88007329>] :scsi_mod:scsi_request_fn+0x69/0x3d0
 [<ffffffff80347b30>] as_work_handler+0x0/0x50
 [<ffffffff80347b5c>] as_work_handler+0x2c/0x50
 [<ffffffff8024b94c>] run_workqueue+0xcc/0x170
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024c443>] worker_thread+0xa3/0x110
 [<ffffffff8024fe10>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024fa3b>] kthread+0x4b/0x80
 [<ffffffff8020b0a8>] child_rip+0xa/0x12
 [<ffffffff8024f9f0>] kthread+0x0/0x80
 [<ffffffff8020b09e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 0f 0b eb fe 31 ed c7 83 b8 00 00 00 01 00 00 00
RIP  [<ffffffff80349028>] as_dispatch_request+0x438/0x460
 RSP <ffff81007d1fddc0>

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
