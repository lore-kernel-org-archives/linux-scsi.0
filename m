From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13873] QLA2xxx driver causes kernel oops with a qla2200
Date: Sat, 1 Aug 2009 16:49:03 GMT
Message-ID: <200908011649.n71Gn3WD016943@demeter.kernel.org>
References: <bug-13873-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43019 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZHAQtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2009 12:49:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n71Gn3oj016944
	for <linux-scsi@vger.kernel.org>; Sat, 1 Aug 2009 16:49:03 GMT
In-Reply-To: <bug-13873-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13873





--- Comment #1 from Thomas <tageorgiou@gmail.com>  2009-08-01 16:49:01 ---
Here is another backtrace:
[ 5659.770014] qla2xxx 0000:0a:01.0: Loop down - aborting ISP.
[ 5659.770028] qla2xxx 0000:0a:01.0: Performing ISP error recovery - ha=
ffff88007e77e000.
[ 5673.330024] qla2xxx 0000:0a:01.0: LIP reset occurred (f7f7).
[ 5674.940020] qla2xxx 0000:0a:01.0: LOOP UP detected (1 Gbps).
[ 5680.537213] general protection fault: 0000 [#1] SMP
[ 5680.547176] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.0/0000:06:02.0/host0/rport-0:0-29/target0:0:28/0:0:28:0/block/sdac/uevent
[ 5680.547176] CPU 2
[ 5680.547176] Modules linked in: qla2xxx
[ 5680.547176] Pid: 4262, comm: scsi_eh_1 Not tainted 2.6.30.4dl380 #2 ProLiant
DL380 G4
[ 5680.547176] RIP: 0010:[<ffffffffa00006aa>]  [<ffffffffa00006aa>]
qla2x00_eh_wait_for_pending_commands+0x63/0x129 [qla2xxx]
[ 5680.547176] RSP: 0018:ffff88007cbdfc80  EFLAGS: 00010006
[ 5680.547176] RAX: 0000000000000286 RBX: 785c6c6175747269 RCX:
ffff88007ac25100
[ 5680.547176] RDX: 000000000000d7d7 RSI: 0000000000000286 RDI:
ffff88007e77e080
[ 5680.547176] RBP: ffff88007cbdfcc0 R08: 0000000000000000 R09:
0000000000000001
[ 5680.547176] R10: ffff88007cbdfa80 R11: ffffffff81843d28 R12:
0000000000000001
[ 5680.547176] R13: ffff88007e77e080 R14: ffff88007ac25f00 R15:
0000000000000000
[ 5680.547176] FS:  0000000000000000(0000) GS:ffff8800019e0000(0000)
knlGS:0000000000000000
[ 5680.547176] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 5680.547176] CR2: 00007f55a2f178d0 CR3: 0000000001001000 CR4:
00000000000006e0
[ 5680.547176] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 5680.547176] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 5680.547176] Process scsi_eh_1 (pid: 4262, threadinfo ffff88007cbde000, task
ffff88007e1ade40)
[ 5680.547176] Stack:
[ 5680.547176]  ffff88007e77ac18 0000000000000000 ffff88007e77ac08
ffff88007fb2d630
[ 5680.547176]  0000000000000001 ffff88007e77ac08 0000000000002003
0000000000000000
[ 5680.547176]  ffff88007cbdfd10 ffffffffa0002b9c ffff88007d9e2c00
ffff88007ac25100
[ 5680.547176] Call Trace:
[ 5680.547176]  [<ffffffffa0002b9c>] qla2xxx_eh_bus_reset+0x13e/0x151 [qla2xxx]
[ 5680.547176]  [<ffffffff812d3f75>] scsi_try_bus_reset+0x52/0xde
[ 5680.547176]  [<ffffffff812d4883>] scsi_send_eh_cmnd+0x1e4/0x275
[ 5680.547176]  [<ffffffffa000d12b>] ? qla2x00_abort_target+0x0/0x131 [qla2xxx]
[ 5680.547176]  [<ffffffff812d4946>] scsi_eh_tur+0x32/0x88
[ 5680.547176]  [<ffffffff812d4dcb>] scsi_eh_ready_devs+0x42f/0x83d
[ 5680.547176]  [<ffffffff812d5749>] scsi_error_handler+0x388/0x583
[ 5680.547176]  [<ffffffff812d53c1>] ? scsi_error_handler+0x0/0x583
[ 5680.547176]  [<ffffffff812d53c1>] ? scsi_error_handler+0x0/0x583
[ 5680.547176]  [<ffffffff81049cc2>] kthread+0x56/0x83
[ 5680.547176]  [<ffffffff8100caba>] child_rip+0xa/0x20
[ 5680.547176]  [<ffffffff81049c6c>] ? kthread+0x0/0x83
[ 5680.547176]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20
[ 5680.547176] Code: 00 00 4c 89 ef e8 af 18 51 e1 48 89 c6 4d 8b 34 24 41 bc
01 00 00 00 31 db e9 a9 00 00 00 49 8b 5e 50 48 85 db 0f 84 93 00 00 00 <48> 8b
43 08 48 8b 50 10 48 8b 4d d0 8b 81 88 01 00 00 66 3b 82
[ 5680.547176] RIP  [<ffffffffa00006aa>]
qla2x00_eh_wait_for_pending_commands+0x63/0x129 [qla2xxx]
[ 5680.547176]  RSP <ffff88007cbdfc80>
[ 5680.547176] ---[ end trace 2ff13a7dc65d2544 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
