From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 20 Nov 2008 07:12:24 -0800 (PST)
Message-ID: <20081120151224.EB880108042@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906AbYKTPNR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2008 10:13:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAKFCP0x022343
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 07:12:26 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #6 from git.user@gmail.com  2008-11-20 07:12 -------
looks very similar

[  316.336654] BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
[  316.339972] IP: [<ffffffff803f84d3>] scsi_times_out+0x10/0x72
[  316.339972] PGD 3e627067 PUD 3de0b067 PMD 0
[  316.339972] Oops: 0000 [#1] PREEMPT SMP
[  316.339972] last sysfs file:
/sys/devices/virtual/block/md0/md/metadata_version
[  316.339972] Dumping ftrace buffer:
[  316.339972]    (ftrace buffer empty)
[  316.339972] CPU 1
[  316.339972] Modules linked in: floppy sg
[  316.339972] Pid: 0, comm: swapper Not tainted 2.6.28-rc5 #1
[  316.339972] RIP: 0010:[<ffffffff803f84d3>]  [<ffffffff803f84d3>]
scsi_times_out+0x10/0x72
[  316.339972] RSP: 0018:ffff88003fb53e20  EFLAGS: 00010082
[  316.339972] RAX: ffff88003ef60000 RBX: 0000000000000000 RCX:
ffff88003ef60308
[  316.339972] RDX: ffff88003ef60308 RSI: 0000000000006cb2 RDI:
ffff880033dae5c0
[  316.339972] RBP: ffff88003fb53e30 R08: ffff880001019180 R09:
0000000000000010
[  316.339972] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff88003ef601c8
[  316.339972] R13: ffff88003ef60308 R14: 0000000000000102 R15:
0000000000000000
[  316.339972] FS:  0000000000000000(0000) GS:ffff88003fb23b00(0000)
knlGS:0000000000000000
[  316.339972] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  316.339972] CR2: 0000000000000000 CR3: 000000003e7e8000 CR4:
00000000000006e0
[  316.339972] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  316.339972] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  316.339972] Process swapper (pid: 0, threadinfo ffff88003fb4e000, task
ffff88003f863500)
[  316.339972] Stack:
[  316.339972]  ffff88000101f900 ffff880033dae5c0 ffff88003fb53e50
ffffffff803544ca
[  316.339972]  ffff88003ef60000 ffff880033dae5c0 ffff88003fb53ea0
ffffffff803545d8
[  316.339972]  ffff88003fb53ea0 ffff88003ef60000 0000000000000286
ffff88003ef60000
[  316.339972] Call Trace:
[  316.339972]  <IRQ> <0> [<ffffffff803544ca>] blk_rq_timed_out+0x16/0x5c
[  316.339972]  [<ffffffff803545d8>] blk_rq_timed_out_timer+0xc8/0x138
[  316.339972]  [<ffffffff80354510>] ? blk_rq_timed_out_timer+0x0/0x138
[  316.339972]  [<ffffffff8023f8b7>] run_timer_softirq+0x183/0x1ec
[  316.339972]  [<ffffffff80254c0c>] ? tick_dev_program_event+0x6c/0xa4
[  316.339972]  [<ffffffff8023b326>] __do_softirq+0x72/0x128
[  316.339972]  [<ffffffff8020c8cc>] call_softirq+0x1c/0x30
[  316.339972]  [<ffffffff8020df2d>] do_softirq+0x3d/0x78
[  316.339972]  [<ffffffff8023b249>] irq_exit+0x8f/0x98
[  316.339972]  [<ffffffff8021d8e4>] smp_apic_timer_interrupt+0x8a/0xd6
[  316.339972]  [<ffffffff8020c31b>] apic_timer_interrupt+0x6b/0x70
[  316.339972]  <EOI> <0> [<ffffffff80212f22>] ? mwait_idle+0x45/0x4a
[  316.339972]  [<ffffffff80209deb>] ? enter_idle+0x22/0x24
[  316.339972]  [<ffffffff8020a386>] ? cpu_idle+0x41/0x80
[  316.339972] Code: cb ff ff 85 c0 74 a0 45 31 e4 eb d2 45 31 e4 44 89 e0 5b
41 5c 41 5d 41 5e 5d c3 55 48 89 e5 53 48 83 ec 08 48 8b 9f e0 00 00 00 <48> 8b
03 48 8b 10 48 8b 82 b8 00 00 00 48 8b 80 60 01 00 00 48
[  316.339972] RIP  [<ffffffff803f84d3>] scsi_times_out+0x10/0x72
[  316.339972]  RSP <ffff88003fb53e20>
[  316.339972] CR2: 0000000000000000
[  316.339972] Kernel panic - not syncing: Fatal exception in interrupt

in my case easily be triggered by disk activity (i.g. rsync) 
on rebuilding raid

On Thu, 2008-11-13 at 13:03 -0600, James Bottomley wrote:
> Actually, I think the trace is slightly off.  I suspect this is the
> problem:
> 
>       struct scsi_cmnd *scmd = req->special;
> 
> I bet req->special is NULL because the command timed out even before it
> was prepared by the subsystem.
> 
> Does this fix it?

In my case it doesn't 'fix', but proof of concept.
With your patch [i just printk-ing the comment] 
system remains locked printk-ing from time to time: 
"nasty: command timed out before the mid layer 
even prepared it"

> The fix is more of a bandaid than anything ... we can't really have
> commands timing out in the mid-layer because we expect we have full
> control of them.  With this patch, if we run out of resets, block will
> complete a command we're still processing.

here is a dmesg:
http://sysadminday.org.ru/2.6.28-rc5-git3/scsi_times_out-NULL_pointer_dereference_dmesg


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
