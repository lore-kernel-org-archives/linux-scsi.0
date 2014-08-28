From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 83391] New: Oops  on sd_mod
Date: Thu, 28 Aug 2014 02:32:01 +0000
Message-ID: <bug-83391-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44691 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965219AbaH1CcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 22:32:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E0FD92011E
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 02:32:03 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1620620122
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 02:32:02 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=83391

            Bug ID: 83391
           Summary: Oops  on sd_mod
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: tomsunchen@gmail.com
        Regression: No

Now i met the oops of sd_mod more times, but i don't know the condition that
the oops occured, the info as below.

BUG: unable to handle kernel paging request at ffff88001488c004
IP: [<ffffffffa019d01c>] sd_revalidate_disk+0x107c/0x1900 [sd_mod]
PGD 1a05067 PUD 1a09067 PMD 176067 PTE 0
Oops: 0000 [#1] SMP 
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host/host0/scan

Pid: 31, comm: ata_aux Tainted: G         C ----------------  
2.6.32-220.el6.x86_64 #1 LENOVO QiTianM8250/LENOVO
RIP: e030:[<ffffffffa019d01c>]  [<ffffffffa019d01c>]
sd_revalidate_disk+0x107c/0x1900 [sd_mod]
RSP: e02b:ffff88003eacbc60  EFLAGS: 00010246
RAX: ffff880039948000 RBX: ffff880039971000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003819b420
RBP: ffff88003eacbd40 R08: 0000000000000018 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001488bfe0
R13: 0000000000000200 R14: ffff88003fc00040 R15: 0000000000000200
FS:  00007f92c694c700(0000) GS:ffff880004ff7000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88001488c004 CR3: 00000000379b9000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ata_aux (pid: 31, threadinfo ffff88003eaca000, task ffff88003eac6b00)
Stack:
 ffff880000007530 ffffffff00000005 0000000000000000 ffffffff8139c890
<0> ffff88003eac71a0 0000000000000000 ffff88003eacbcf2 0000000000000000
<0> ffff88003a21aa00 000000002542eab0 ffff880039957800 ffff880039948000
Call Trace:
 [<ffffffff8139c890>] ? ata_scsi_dev_rescan+0x0/0x110
 [<ffffffff8126ffda>] ? kobject_get+0x1a/0x30
 [<ffffffff81260000>] ? blkiocg_file_read_map+0xe0/0x100
 [<ffffffff811b1428>] revalidate_disk+0x38/0x90
 [<ffffffffa01994b7>] sd_rescan+0x27/0x40 [sd_mod]
 [<ffffffff8138b07d>] scsi_rescan_device+0x8d/0xe0
 [<ffffffff813697c9>] ? get_device+0x19/0x20
 [<ffffffff8139c94a>] ata_scsi_dev_rescan+0xba/0x110
 [<ffffffff8139c890>] ? ata_scsi_dev_rescan+0x0/0x110
 [<ffffffff8108c630>] worker_thread+0x170/0x2a0
 [<ffffffff81091fc0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff814daf2c>] ? _spin_unlock_irqrestore+0x1c/0x20
 [<ffffffff8108c4c0>] ? worker_thread+0x0/0x2a0
 [<ffffffff81091c56>] kthread+0x96/0xa0
 [<ffffffff8100d14a>] child_rip+0xa/0x20
 [<ffffffff8100c314>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff8100ca9d>] ? retint_restore_args+0x5/0x6
 [<ffffffff8100d140>] ? child_rip+0x0/0x20

crash> l* sd_revalidate_disk+0x107c
0xffffffffa019d01c is in sd_revalidate_disk
(/usr/src/debug/kernel-2.6.32/linux-2.6.32/arch/x86/include/asm/swab.h:53).
48                  : "=r" (v.s.a), "=r" (v.s.b)
49                  : "0" (v.s.a), "1" (v.s.b));
50      # endif
51              return v.u;
52      #else /* __i386__ */
53              asm("bswapq %0"
54                  : "=r" (val)
55                  : "0" (val));
56              return val;
57      #endif

Would you give me suggestions for this oops? thank you very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
