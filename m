From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47701] New: When too many disks fall out at the same time, RCU
 hangs
Date: Tue, 18 Sep 2012 23:13:09 +0000 (UTC)
Message-ID: <bug-47701-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45573 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2IRXNP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 19:13:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 73C3820282
	for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2012 23:13:14 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6AD6A20254
	for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2012 23:13:12 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47701

           Summary: When too many disks fall out at the same time, RCU
                    hangs
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.5.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: sgunderson@bigfoot.com
        Regression: No


Hi,

For whatever reason, I lost all of my disks at the same time (I guess a SAS
cable fell out; I'll know tomorrow). As was expected, I/O on the machine was
not so happy afterwards; what was not so expected, was the following output on
the serial console a minute or so after:

[292657.601264] INFO: rcu_sched self-detected stall on CPU[292657.602441] INFO:
rcu_sched detected stalls on CPUs/tasks: { 6} (detected by 4, t=60002 jiffies)
[292657.602444] INFO: Stall ended before state dump start

[292657.620982]  {[292657.622964]  6}  (t=60024 jiffies)
Pid: 7800, comm: kworker/u:9 Not tainted 3.5.4 #1
[292657.631337] Call Trace:
[292657.634069]  <IRQ>  [<ffffffff8108ecaf>] __rcu_pending+0xbd/0x417
[292657.640471]  [<ffffffff8108f0de>] rcu_check_callbacks+0xd5/0x138
[292657.646765]  [<ffffffff81041b73>] update_process_times+0x3c/0x73
[292657.653050]  [<ffffffff81072076>] tick_sched_timer+0x6a/0x93
[292657.658999]  [<ffffffff8105301e>] __run_hrtimer+0xb3/0x13e
[292657.664763]  [<ffffffff8107200c>] ? tick_nohz_handler+0xd3/0xd3
[292657.670972]  [<ffffffff8103b7a3>] ? __do_softirq+0x16c/0x182
[292657.676916]  [<ffffffff810533d5>] hrtimer_interrupt+0xce/0x1b0
[292657.683030]  [<ffffffff8101ad3d>] smp_apic_timer_interrupt+0x81/0x94
[292657.689676]  [<ffffffff81377447>] apic_timer_interrupt+0x67/0x70
[292657.695965]  <EOI>  [<ffffffff813703dd>] ?
_raw_spin_unlock_irqrestore+0x9/0xb
[292657.703695]  [<ffffffff8123daaa>] scsi_remove_target+0x137/0x153
[292657.709985]  [<ffffffff812425dc>] sas_rphy_remove+0x25/0x4e
[292657.715841]  [<ffffffff81242616>] sas_rphy_delete+0x11/0x1e
[292657.721699]  [<ffffffff81242648>] sas_port_delete+0x25/0x11a
[292657.727644]  [<ffffffff8136de53>] ? mutex_unlock+0x9/0xb
[292657.733254]  [<ffffffffa0020fd5>] mpt2sas_transport_port_remove+0x16f/0x190
[mpt2sas]
[292657.741576]  [<ffffffffa001a70b>] _scsih_remove_device+0x58/0x84 [mpt2sas]
[292657.748731]  [<ffffffffa001a7f4>] _scsih_device_remove_by_handle+0xbd/0xc6
[mpt2sas]
[292657.756960]  [<ffffffffa001c5bb>]
_scsih_sas_topology_change_event+0x422/0x46d [mpt2sas]
[292657.765531]  [<ffffffff81064556>] ? idle_balance+0xde/0x10c
[292657.771395]  [<ffffffffa001e098>] ? _scsih_abort+0x1c1/0x1c1 [mpt2sas]
[292657.778212]  [<ffffffffa001e38d>] _firmware_event_work+0x2f5/0x920
[mpt2sas]
[292657.785547]  [<ffffffff81042089>] ? add_timer+0x17/0x1a
[292657.791058]  [<ffffffff8104bc64>] ? queue_delayed_work_on+0xda/0xe8
[292657.797607]  [<ffffffffa001e098>] ? _scsih_abort+0x1c1/0x1c1 [mpt2sas]
[292657.804418]  [<ffffffff8104c641>] process_one_work+0x253/0x3c5
[292657.810534]  [<ffffffff8104cbb7>] worker_thread+0x1d4/0x34d
[292657.816394]  [<ffffffff8104c9e3>] ? rescuer_thread+0x230/0x230
[292657.822511]  [<ffffffff810500bb>] kthread+0x84/0x8c
[292657.827675]  [<ffffffff81377c94>] kernel_thread_helper+0x4/0x10
[292657.833875]  [<ffffffff81050037>] ? kthread_freezable_should_stop+0x58/0x58
[292657.841117]  [<ffffffff81377c90>] ? gs_change+0xb/0xb

I'm reporting this primarily because it could cause problems in some other
context (say, when only one or two disks disappear); of course, for me in this
case, it wouldn't matter if I/O was "properly" rejected or the entire machine
hanged, it's useless anyway.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
