From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Thu, 27 Feb 2014 17:47:11 +0000
Message-ID: <bug-71231-11613-T0t1O10oX7@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57069 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaB0RrQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Feb 2014 12:47:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 14D1D20240
	for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2014 17:47:15 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 202DA20251
	for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2014 17:47:12 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #2 from Alex <alexandernaumann@gmx.de> ---
Part of the attached kernel messages:

[  119.504736] Code: 00 48 89 f0 48 c7 06 00 00 00 00 48 89 e5 48 87 07 48 85
c0 75 09 c7 46 08 01 00 00 00 5d c3 48 89 30 8b 46 08 85 c0 75 f4 f3 90 <8b> 46
08 85 c0 74 f7 5d c3 0f 1f 44 00 00 48 8b 16 55 48 89 e5 
[  119.504740] NMI backtrace for cpu 44
[  119.504746] CPU: 44 PID: 21877 Comm: lsscsi Not tainted 3.10.32-64bit #1
[  119.504748] Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 1.0.1
02/19/2010
[  119.504751] task: ffff881063510d60 ti: ffff88106351c000 task.ti:
ffff88106351c000
[  119.504760] RIP: 0010:[<ffffffff8105e505>]  [<ffffffff8105e505>]
mspin_lock+0x35/0x40
[  119.504763] RSP: 0018:ffff88106351db38  EFLAGS: 00000246
[  119.504765] RAX: 0000000000000000 RBX: ffffffff81aa9220 RCX:
0000000000000028
[  119.504768] RDX: ffff88106351dfd8 RSI: ffff88106351db60 RDI:
ffffffff81aa9240
[  119.504770] RBP: ffff88106351db38 R08: 70722f3374736f68 R09:
fefefefefefefeff
[  119.504772] R10: ffff88086ddc5bc0 R11: 8f8dd0cc8b8c9097 R12:
ffff88106351db60
[  119.504774] R13: ffffffff81aa9240 R14: ffff881063510d60 R15:
ffff88106351dca8
[  119.504777] FS:  0000000000000000(0000) GS:ffff88046fd60000(0063)
knlGS:00000000f762f8d0
[  119.504780] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  119.504782] CR2: 00000000f777c000 CR3: 00000010684ea000 CR4:
00000000000007e0
[  119.504785] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  119.504788] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  119.504789] Stack:
[  119.504794]  ffff88106351dba8 ffffffff81766d5d ffff88106351db58
ffff88106351dfd8
[  119.504798]  ffff88106351dba8 ffff881066ebfb90 ffff881000000000
ffffffff00000003
[  119.504803]  ffff88106351db98 ffffffff81aa9220 ffff88106351dc98
ffff88046c3a94d0
[  119.504804] Call Trace:
[  119.504812]  [<ffffffff81766d5d>] __mutex_lock_slowpath+0x5d/0x1d0
[  119.504817]  [<ffffffff817667dd>] mutex_lock+0x1d/0x40
[  119.504823]  [<ffffffff81156ba5>] sysfs_dentry_revalidate+0x35/0x100
[  119.504828]  [<ffffffff810ff389>] lookup_fast+0x299/0x2e0
[  119.504833]  [<ffffffff810ff586>] ? __inode_permission+0x46/0x70
[  119.504838]  [<ffffffff810ff79a>] link_path_walk+0x19a/0x810
[  119.504843]  [<ffffffff810ff994>] link_path_walk+0x394/0x810
[  119.504848]  [<ffffffff810b9b8f>] ? release_pages+0x18f/0x1e0
[  119.504853]  [<ffffffff81103094>] path_openat.isra.72+0x94/0x460
[  119.504859]  [<ffffffff810cbf84>] ? tlb_flush_mmu+0x54/0x90
[  119.504864]  [<ffffffff810d2c79>] ? unmap_region+0xd9/0x120
[  119.504869]  [<ffffffff8110368c>] do_filp_open+0x3c/0x90
[  119.504875]  [<ffffffff8110ee52>] ? __alloc_fd+0x42/0x100
[  119.504882]  [<ffffffff810f3a3f>] do_sys_open+0xef/0x1d0
[  119.504888]  [<ffffffff8113a036>] compat_SyS_open+0x16/0x20
[  119.504893]  [<ffffffff8176b598>] sysenter_dispatch+0x7/0x25
[  119.504938] Code: f0 48 c7 06 00 00 00 00 48 89 e5 48 87 07 48 85 c0 75 09
c7 46 08 01 00 00 00 5d c3 48 89 30 8b 46 08 85 c0 75 f4 f3 90 8b 46 08 <85> c0
74 f7 5d c3 0f 1f 44 00 00 48 8b 16 55 48 89 e5 48 85 d2 
[  119.504942] NMI backtrace for cpu 45
[  119.504946] CPU: 45 PID: 0 Comm: swapper/45 Not tainted 3.10.32-64bit #1
[  119.504949] Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 1.0.1
02/19/2010
[  119.504952] task: ffff88046dcd6b00 ti: ffff88046dcf6000 task.ti:
ffff88046dcf6000
[  119.504960] RIP: 0010:[<ffffffff8102318a>]  [<ffffffff8102318a>]
mwait_idle_with_hints+0x5a/0x70
[  119.504962] RSP: 0018:ffff88046dcf7dd8  EFLAGS: 00000046
[  119.504965] RAX: 0000000000000000 RBX: ffff88106d07d46c RCX:
0000000000000001
[  119.504967] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000000
[  119.504970] RBP: ffff88046dcf7dd8 R08: ffff88046dcf7fd8 R09:
000000000000001c
[  119.504972] R10: 0000000000000166 R11: 00000000016f1e50 R12:
0000000000000001
[  119.504975] R13: ffff88106d07d400 R14: 0000000000000001 R15:
ffffffffa0004830
[  119.504978] FS:  0000000000000000(0000) GS:ffff88086fd60000(0000)
knlGS:0000000000000000
[  119.504981] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  119.504984] CR2: 00000000f7746000 CR3: 000000046cb57000 CR4:
00000000000007e0
[  119.504986] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  119.504989] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  119.504989] Stack:
[  119.504994]  ffff88046dcf7de8 ffffffff810231cd ffff88046dcf7df8
ffffffffa0001515
[  119.504999]  ffff88046dcf7e28 ffffffffa000164a 00000000000000f5
ffff88106c669000
[  119.505003]  ffffffffa00047c0 0000001aaf4aa38f ffff88046dcf7e88
ffffffff8164e83a
[  119.505004] Call Trace:
[  119.505010]  [<ffffffff810231cd>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[  119.505021]  [<ffffffffa0001515>] acpi_idle_do_entry+0x10/0x2b [processor]
[  119.505028]  [<ffffffffa000164a>] acpi_idle_enter_c1+0x5c/0x81 [processor]
[  119.505035]  [<ffffffff8164e83a>] cpuidle_enter_state+0x4a/0xe0
[  119.505041]  [<ffffffff8164e96e>] cpuidle_idle_call+0x9e/0x160
[  119.505046]  [<ffffffff8106092d>] ? __atomic_notifier_call_chain+0xd/0x10
[  119.505052]  [<ffffffff8100af49>] arch_cpu_idle+0x9/0x30
[  119.505057]  [<ffffffff81073241>] cpu_startup_entry+0x91/0x180
[  119.505063]  [<ffffffff81b4be73>] start_secondary+0x1a0/0x1a4

-- 
You are receiving this mail because:
You are the assignee for the bug.
