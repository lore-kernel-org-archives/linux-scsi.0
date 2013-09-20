From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61731] New: IRQ error while initializing.
Date: Fri, 20 Sep 2013 09:38:16 +0000
Message-ID: <bug-61731-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43248 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab3ITJiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 05:38:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 13F2B20322
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2013 09:38:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D206120300
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2013 09:38:17 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=61731

            Bug ID: 61731
           Summary: IRQ error while initializing.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.10.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: DC390
          Assignee: linux-scsi@vger.kernel.org
          Reporter: v10lator@myway.de
        Regression: No

Device (lspci) :
04:05.0 SCSI storage controller: Advanced Micro Devices, Inc. [AMD] 53c974
[PCscsi] (rev 10)

Message (dmesg) :
[    6.330158] ------------[ cut here ]------------
[    6.330192] WARNING: at kernel/irq/handle.c:146
handle_irq_event_percpu+0x110
/0x120()
[    6.330213] irq 20 handler do_DC390_Interrupt+0x0/0x954 [tmscsim] enabled
int
errupts
[    6.330226] Modules linked in: tmscsim microcode fglrx(PO) vboxpci(O)
vboxnet
adp(O) vboxnetflt(O) vboxdrv(O)
[    6.330249] CPU: 2 PID: 0 Comm: BFS/2 Tainted: P           O 3.10.10 #7
[    6.330256] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./870 
Extreme3, BIOS P1.60 09/14/2010
[    6.330262]  ffffffff816a4124 ffffffff81074f16 ffff8802296f4400
ffff880237d03
ef8
[    6.330272]  0000000000000000 0000000000000000 0000000000000014
ffffffff81074
f87
[    6.330282]  ffffffff81948f48 ffff880200000028 ffff880237d03f08
ffff880237d03
ec8
[    6.330290] Call Trace:
[    6.330296]  <IRQ>  [<ffffffff816a4124>] ? dump_stack+0xc/0x15
[    6.330314]  [<ffffffff81074f16>] ? warn_slowpath_common+0x56/0x80
[    6.330323]  [<ffffffff81074f87>] ? warn_slowpath_fmt+0x47/0x60
[    6.330332]  [<ffffffff816a976e>] ? _raw_spin_unlock_irq+0xe/0x40
[    6.330345]  [<ffffffffa092990f>] ? do_DC390_Interrupt+0x12f/0x954 [tmscsim]
[    6.330357]  [<ffffffffa09297e0>] ? dc390_MsgIn_0+0x520/0x520 [tmscsim]
[    6.330366]  [<ffffffff810d5690>] ? handle_irq_event_percpu+0x110/0x120
[    6.330380]  [<ffffffff810d56d7>] ? handle_irq_event+0x37/0x60
[    6.330391]  [<ffffffff810d83d0>] ? handle_fasteoi_irq+0x50/0x100
[    6.330401]  [<ffffffff810379f5>] ? handle_irq+0x15/0x20
[    6.330423]  [<ffffffff81037660>] ? do_IRQ+0x40/0xc0
[    6.330436]  [<ffffffff816a9f2a>] ? common_interrupt+0x6a/0x6a
[    6.330441]  <EOI>  [<ffffffff8103e4bd>] ? amd_e400_idle+0x3d/0x100
[    6.330458]  [<ffffffff810ab778>] ? cpu_startup_entry+0x78/0x180
[    6.330466] ---[ end trace 132bff5a0b96a11f ]---

All in all this error seems to be ignorable, the SCSI card is working just
fine.

-- 
You are receiving this mail because:
You are the assignee for the bug.
