From: Thomas Georgiou <tageorgiou@gmail.com>
Subject: QLA2200 causes kernel bug
Date: Thu, 6 Aug 2009 11:28:15 -0400
Message-ID: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44810 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbZHFP2Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 11:28:16 -0400
Received: by gxk9 with SMTP id 9so1185724gxk.13
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2009 08:28:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Whenever I have the qla2xxx module loaded, some kernel problem
eventually occurs.  Sometimes its an oops, a bug, or once, a crash.
The same thing has been seen to happen on 3 different machines all
with qla2200 cards in them.

Here is the latest backtrace:
[42151.610011] kernel BUG at drivers/scsi/scsi_transport_fc.c:3022!
[42151.610011] invalid opcode: 0000 [#1] SMP
[42151.610011] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:0a:01.0/host1/rport-1:0-25/target1:0:25/fc_transport/target1:0:25/port_name
[42151.610011] CPU 3
[42151.610011] Modules linked in: iscsi_scst scst_disk scst_vdisk scst
qla2xxx
[42151.610011] Pid: 4846, comm: fc_dl_1 Not tainted 2.6.30.4dl380 #3
ProLiant DL380 G4
[42151.610011] RIP: 0010:[<ffffffff812e3c1a>]  [<ffffffff812e3c1a>]
fc_timeout_deleted_rport+0x250/0x2df
[42151.610011] RSP: 0018:ffff8801965c7e70  EFLAGS: 00010202
[42151.610011] RAX: ffff8801967cb648 RBX: ffff88019a837ba0 RCX:
ffff8801965c7de0
[42151.610011] RDX: 0000000000000003 RSI: ffff8801968b89c0 RDI:
ffff8801965c7e60
[42152.490635] RBP: ffff8801965c7eb0 R08: ffffffff8185dd50 R09:
ffff8801965c7d70
[42152.490635] R10: ffff8801965c7da0 R11: ffff88019530ea80 R12:
ffff880196dd3400
[42152.490635] R13: ffff880196dd3598 R14: ffff880196cb4000 R15:
ffff88019a890800
[42152.490635] FS:  0000000000000000(0000) GS:ffff88002807f000(0000)
knlGS:0000000000000000
[42152.490635] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[42152.490635] CR2: 0000000001c6b628 CR3: 00000001974af000 CR4:
00000000000006e0
[42152.490635] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[42152.490635] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[42152.490635] Process fc_dl_1 (pid: 4846, threadinfo
ffff8801965c6000, task ffff8801967cb2c0)
[42152.490635] Stack:
[42152.490635]  0000000000000000 0000000000000202 ffff8801975d2000
ffffc20000082b00
[42152.490635]  ffff880196dd3598 ffffc20000082b00 ffff8801967cb2c0
ffffffff812e39ca
[42152.490635]  ffff8801965c7f20 ffffffff8104708c 0000000000000000
ffff8801967cb2c0
[42152.490635] Call Trace:
[42152.490635]  [<ffffffff812e39ca>] ?
fc_timeout_deleted_rport+0x0/0x2df
[42152.490635]  [<ffffffff8104708c>] worker_thread+0x113/0x1ac
[42152.490635]  [<ffffffff81049f58>] ?
autoremove_wake_function+0x0/0x38
[42152.490635]  [<ffffffff81046f79>] ? worker_thread+0x0/0x1ac
[42152.490635]  [<ffffffff81046f79>] ? worker_thread+0x0/0x1ac
[42152.490635]  [<ffffffff81049e05>] kthread+0x56/0x85
[42152.490635]  [<ffffffff8100caba>] child_rip+0xa/0x20
[42152.490635]  [<ffffffff81049daf>] ? kthread+0x0/0x85
[42152.490635]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20
[42152.490635] Code: e0 fb 83 c8 08 41 88 85 b0 fe ff ff 49 8b 7e 58
48 8b 75 c8 e8 e4 86 22 00 4c 89 e7 e8 7c d1 ff ff 41 83 bd 90 fe ff
ff 01 74 04 <0f> 0b eb fe 41 8b 87 d0 02 00 00 83 f8 02 74 16 83 f8 03
74 29
[42152.490635] RIP  [<ffffffff812e3c1a>]
fc_timeout_deleted_rport+0x250/0x2df
[42152.490635]  RSP <ffff8801965c7e70>

and

[43410.037930] qla2xxx 0000:0a:01.0: LIP reset occurred (f7ca).
[43414.941958] qla2xxx 0000:0a:01.0: LOOP DOWN detected (b88f 0 9581).
[43418.341988] qla2xxx 0000:0a:01.0: LIP occurred (f7b1).
[43418.403690] qla2xxx 0000:0a:01.0: LOOP UP detected (1 Gbps).
[43423.541948] qla2xxx 0000:0a:01.0: LIP reset occurred (f5b5).
[43424.584083] qla2xxx 0000:06:02.0: LIP reset occurred (f7f7).
[43425.650042]  rport-0:0-0: blocked FC remote port time out: removing
target and saving binding
[43425.672504] qla2xxx 0000:06:02.0: LIP occurred (f7f7).
[43425.815119] ------------[ cut here ]------------
[43425.825014] kernel BUG at drivers/scsi/scsi_transport_fc.c:3022!
[43425.825014] invalid opcode: 0000 [#2] SMP
[43425.825014] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:0a:01.0/host1/rport-1:0-22/target1:0:22/1:0:22:0/block/sdco/uevent
[43425.825014] CPU 1
[43425.825014] Modules linked in: iscsi_scst scst_disk scst_vdisk scst
qla2xxx
[43425.825014] Pid: 4211, comm: fc_dl_0 Tainted: G      D
2.6.30.4dl380 #3 ProLiant DL380 G4
[43425.825014] RIP: 0010:[<ffffffff812e3c1a>]  [<ffffffff812e3c1a>]
fc_timeout_deleted_rport+0x250/0x2df
[43425.825014] RSP: 0018:ffff88019840be70  EFLAGS: 00010202
[43425.825014] RAX: ffff88019840be60 RBX: ffff880197db9920 RCX:
ffff88019840bde0
[43425.825014] RDX: 0000000000000001 RSI: ffff880196cb9000 RDI:
ffffffffffffff10
[43425.825014] RBP: ffff88019840beb0 R08: ffffffff8185dd50 R09:
ffff88019840bd70
[43425.825014] R10: ffff88019840bda0 R11: ffff88008a7c61a0 R12:
ffff88019a885c00
[43425.825014] R13: ffff88019a885d98 R14: ffff880196cb0000 R15:
ffff88019a894400
[43425.825014] FS:  0000000000000000(0000) GS:ffff88002804d000(0000)
knlGS:0000000000000000
[43425.825014] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[43425.825014] CR2: 00007fe26b7a8098 CR3: 0000000198589000 CR4:
00000000000006e0
[43425.825014] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[43425.825014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[43425.825014] Process fc_dl_0 (pid: 4211, threadinfo
ffff88019840a000, task ffff880198458740)
[43425.825014] Stack:
[43425.825014]  0000000100000000 0000000000000202 ffff8801975d2000
ffffc20000081180
[43425.825014]  ffff88019a885d98 ffffc20000081180 ffff880198458740
ffffffff812e39ca
[43425.825014]  ffff88019840bf20 ffffffff8104708c 0000000000000000
ffff880198458740
[43425.825014] Call Trace:
[43425.825014]  [<ffffffff812e39ca>] ?
fc_timeout_deleted_rport+0x0/0x2df
[43425.825014]  [<ffffffff8104708c>] worker_thread+0x113/0x1ac
[43425.825014]  [<ffffffff81049f58>] ?
autoremove_wake_function+0x0/0x38
[43425.825014]  [<ffffffff81046f79>] ? worker_thread+0x0/0x1ac
[43425.825014]  [<ffffffff81046f79>] ? worker_thread+0x0/0x1ac
[43425.825014]  [<ffffffff81049e05>] kthread+0x56/0x85
[43425.825014]  [<ffffffff8100caba>] child_rip+0xa/0x20
[43425.825014]  [<ffffffff81049daf>] ? kthread+0x0/0x85
[43425.825014]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20
[43425.825014] Code: e0 fb 83 c8 08 41 88 85 b0 fe ff ff 49 8b 7e 58
48 8b 75 c8 e8 e4 86 22 00 4c 89 e7 e8 7c d1 ff ff 41 83 bd 90 fe ff
ff 01 74 04 <0f> 0b eb fe 41 8b 87 d0 02 00 00 83 f8 02 74 16 83 f8 03
74 29
[43425.825014] RIP  [<ffffffff812e3c1a>]
fc_timeout_deleted_rport+0x250/0x2df
[43425.825014]  RSP <ffff88019840be70>
[43425.871192] ---[ end trace dc9543ab95173f0f ]---

The bug has been occuring without scst compiled in as well.

I have filed a bug collecting other backtraces here:
http://bugzilla.kernel.org/show_bug.cgi?id=13873

Any ideas to what might be causing this?
