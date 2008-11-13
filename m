From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] New: scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 10:30:22 -0800 (PST)
Message-ID: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbYKMSax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 13:30:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mADIUMAq002779
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 10:30:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020

           Summary: scsi_times_out NULL pointer dereference
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.28-git20081113
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: bs@q-leap.de


Latest working kernel version: 2.6.27
Earliest failing kernel version: 2.6.28-rc4
Hardware Environment: Infortrend G2430 connected to LSI22320R
Problem Description:

Hello,

first in 2.6.28-rc{1,2,3} the error handler was entirely broken - it
deadlocked. In rc4 this is fixed, but now I already two times got a Null
pointer dereference while doing some error handler tests. All of that looks
like due to the scsi timeout commits.

Steps to reproduce: E.g. reset devices connected to LSI 53C1030 devices using
lsiutil. Can be reproduced on about 20% eh activations.

(gdb) l *(scsi_times_out+0x15)
0xffffffff80460f1e is in scsi_times_out (drivers/scsi/scsi_error.c:176).
171             enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
172             enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
173
174             scsi_log_completion(scmd, TIMEOUT_ERROR);
175
176             if (scmd->device->host->transportt->eh_timed_out)
177                     eh_timed_out =
scmd->device->host->transportt->eh_timed_out;
178             else if (scmd->device->host->hostt->eh_timed_out)
179                     eh_timed_out = scmd->device->host->hostt->eh_timed_out;
180             else

[  143.804672] BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
[  143.808507] IP: [<ffffffff80460f1e>] scsi_times_out+0x15/0x71
[  143.816020] PGD f9381067 PUD f9360067 PMD 0
[  143.824018] Oops: 0000 [#1] SMP
[  143.824018] last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[  143.832016] Dumping ftrace buffer:
[  143.832016]    (ftrace buffer empty)
[  143.832016] CPU 1
[  143.832016] Modules linked in: mptctl ib_ipoib inet_lro ib_umad rdma_ucm
rdma_cm ib_cm iw_cm ib_sa ib_addr ib_uvee
[  143.832016] Pid: 246, comm: pdflush Not tainted 2.6.28-rc4-bs1 #10
[  143.832016] RIP: 0010:[<ffffffff80460f1e>]  [<ffffffff80460f1e>]
scsi_times_out+0x15/0x71
[  143.832016] RSP: 0018:ffff88007f6a3df0  EFLAGS: 00010086
[  143.832016] RAX: ffff88007ebf5330 RBX: 0000000000000000 RCX:
ffff8800f93804b8
[  143.832016] RDX: ffff88007ebf5948 RSI: 0000000000000246 RDI:
ffff8800f9380378
[  143.832016] RBP: ffff88007f6a3e00 R08: 0000000000000000 R09:
0000000000000000
[  143.832016] R10: ffff8800f9144680 R11: ffff88007eeac240 R12:
ffff88007ebf5330
[  143.832016] R13: ffff88007ebf5808 R14: ffffffff80380461 R15:
0000000000000000
[  143.832016] FS:  0000000000733860(0000) GS:ffff8800fb29ab40(0000)
knlGS:0000000000000000
[  143.832016] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  143.832016] CR2: 0000000000000000 CR3: 00000000e80ec000 CR4:
00000000000006e0
[  143.832016] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  143.832016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  143.832016] Process pdflush (pid: 246, threadinfo ffff88007ed12000, task
ffff88007ed11890)
[  143.832016] Stack:
[  143.832016]  ffff88007f6a3e00 ffff8800f9380378 ffff88007f6a3e20
ffffffff80380426
[  143.832016]  ffff88007ebf5330 ffff8800f9380378 ffff88007f6a3e70
ffffffff803804f9
[  143.832016]  ffff88007eea0000 ffff88007ebf5668 0000000000000246
ffff88007ebf5330
[  143.832016] Call Trace:
[  143.832016]  <IRQ> <0> [<ffffffff80380426>] blk_rq_timed_out+0x1b/0x56
[  143.832016]  [<ffffffff803804f9>] blk_rq_timed_out_timer+0x98/0x118
[  143.832016]  [<ffffffff80380461>] ? blk_rq_timed_out_timer+0x0/0x118
[  143.832016]  [<ffffffff802464e2>] run_timer_softirq+0x14c/0x1cc
[  143.832016]  [<ffffffff80242392>] __do_softirq+0x83/0x128
[  143.832016]  [<ffffffff8020d03c>] call_softirq+0x1c/0x28
[  143.832016]  [<ffffffff8020ea39>] do_softirq+0x49/0x90
[  143.832016]  [<ffffffff802422aa>] irq_exit+0x44/0x46
[  143.832016]  [<ffffffff8020e88b>] do_IRQ+0xba/0xcf


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
