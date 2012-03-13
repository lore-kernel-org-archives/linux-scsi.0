From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42918] New: fcoe: Enabling VN2VN mode triggers a circular
 locking complaint
Date: Tue, 13 Mar 2012 12:16:57 GMT
Message-ID: <bug-42918-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:50949 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2CMMQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 08:16:58 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2DCGvcg014492
	for <linux-scsi@vger.kernel.org>; Tue, 13 Mar 2012 12:16:57 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42918

               URL: http://comments.gmane.org/gmane.linux.scsi.open-fcoe.d
                    evel/11451?set_lines=100000
           Summary: fcoe: Enabling VN2VN mode triggers a circular locking
                    complaint
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.3.0-rc7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: bvanassche@acm.org
        Regression: No


Kernel version: 3.3.0-rc7

How to reproduce:

# modprobe fcoe
# echo eth0 >/sys/module/libfcoe/parameters/create_vn2vn

Result:

# dmesg
device eth0 entered promiscuous mode
scsi3 : FCoE Driver
host3: libfc: Link up on port (000000)

======================================================
[ INFO: possible circular locking dependency detected ]
3.3.0-rc7-scst-debug+ #1 Not tainted
-------------------------------------------------------
kworker/2:0/14 is trying to acquire lock:
 (rtnl_mutex){+.+.+.}, at: [<c13a10c4>] rtnl_lock+0x14/0x20

but task is already holding lock:
 (&fip->ctlr_mutex){+.+...}, at: [<f89713e7>] fcoe_ctlr_timer_work+0x3e7/0xb60
[libfcoe]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&fip->ctlr_mutex){+.+...}:
       [<c1091f70>] lock_acquire+0x80/0x1b0
       [<c147655d>] mutex_lock_nested+0x6d/0x340
       [<f8970c32>] fcoe_ctlr_link_up+0x22/0x180 [libfcoe]
       [<f894620e>] fcoe_create+0x47e/0x6e0 [fcoe]
       [<f8973dd3>] fcoe_transport_create+0x143/0x250 [libfcoe]
       [<c10527e0>] param_attr_store+0x30/0x60
       [<c1052696>] module_attr_store+0x26/0x40
       [<c11a201e>] sysfs_write_file+0xae/0x100
       [<c11449df>] vfs_write+0x8f/0x160
       [<c1144cbd>] sys_write+0x3d/0x70
       [<c147a0c4>] syscall_call+0x7/0xb

-> #0 (rtnl_mutex){+.+.+.}:
       [<c109164b>] __lock_acquire+0x140b/0x1720
       [<c1091f70>] lock_acquire+0x80/0x1b0
       [<c147655d>] mutex_lock_nested+0x6d/0x340
       [<c13a10c4>] rtnl_lock+0x14/0x20
       [<f89445ac>] fcoe_update_src_mac+0x2c/0xb0 [fcoe]
       [<f8971712>] fcoe_ctlr_timer_work+0x712/0xb60 [libfcoe]
       [<c104fb69>] process_one_work+0x179/0x5d0
       [<c10502f1>] worker_thread+0x121/0x2d0
       [<c10550ed>] kthread+0x7d/0x90
       [<c1481a82>] kernel_thread_helper+0x6/0x10

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&fip->ctlr_mutex);
                               lock(rtnl_mutex);
                               lock(&fip->ctlr_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***

3 locks held by kworker/2:0/14:
 #0:  (events){.+.+.+}, at: [<c104faf5>] process_one_work+0x105/0x5d0
 #1:  ((&fip->timer_work)){+.+...}, at: [<c104faf5>]
process_one_work+0x105/0x5d0
 #2:  (&fip->ctlr_mutex){+.+...}, at: [<f89713e7>]
fcoe_ctlr_timer_work+0x3e7/0xb60 [libfcoe]

stack backtrace:
Pid: 14, comm: kworker/2:0 Not tainted 3.3.0-rc7 #1
Call Trace:
 [<c14714a6>] ? printk+0x1d/0x1f
 [<c1471d4f>] print_circular_bug+0x1b4/0x1be
 [<c109164b>] __lock_acquire+0x140b/0x1720
 [<c1091f70>] lock_acquire+0x80/0x1b0
 [<c13a10c4>] ? rtnl_lock+0x14/0x20
 [<c147655d>] mutex_lock_nested+0x6d/0x340
 [<c13a10c4>] ? rtnl_lock+0x14/0x20
 [<c13a10c4>] ? rtnl_lock+0x14/0x20
 [<f89713e7>] ? fcoe_ctlr_timer_work+0x3e7/0xb60 [libfcoe]
 [<c13a10c4>] rtnl_lock+0x14/0x20
 [<f89445ac>] fcoe_update_src_mac+0x2c/0xb0 [fcoe]
 [<f8971712>] fcoe_ctlr_timer_work+0x712/0xb60 [libfcoe]
 [<c106a2c5>] ? local_clock+0x65/0x70
 [<c104faf5>] ? process_one_work+0x105/0x5d0
 [<c10928e4>] ? trace_hardirqs_on_caller+0xf4/0x180
 [<c104fb69>] process_one_work+0x179/0x5d0
 [<c104faf5>] ? process_one_work+0x105/0x5d0
 [<f8971000>] ? fcoe_ctlr_vn_send_claim+0x40/0x40 [libfcoe]
 [<c10502f1>] worker_thread+0x121/0x2d0
 [<c10501d0>] ? rescuer_thread+0x1d0/0x1d0
 [<c10550ed>] kthread+0x7d/0x90
 [<c1055070>] ? __init_kthread_worker+0x60/0x60
 [<c1481a82>] kernel_thread_helper+0x6/0x10
host3: Assigned Port ID 0092b5

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
