From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10979] New: INFO: possible recursive locking detected
Date: Wed, 25 Jun 2008 02:02:48 -0700 (PDT)
Message-ID: <bug-10979-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbYFYJDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 05:03:20 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5P92ndx011584
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 02:02:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10979

           Summary: INFO: possible recursive locking detected
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: zdenek.kabelac@gmail.com


Latest working kernel version:
Earliest failing kernel version:
Distribution: fedora rawhide
Hardware Environment: T61 2G C2D
Software Environment:
Problem Description:

While checking message logs for error traces - I've noticed an older INFO:
trace. I'm not sure if it's still applicable to -rc8 - but the scenario in this
case was, that I've tried to attach 3.5" hdd via USB and usually I've to
restart/reattach device several times to get it usable/visible in the system.
It's interesting that with another older laptop Toshiba I do not usually see
this problem. Anyway during one of failed USB attachement this appeared in the
log:

----
scsi 7:0:0:0: Device offlined - not ready after error recovery
scsi 7:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 344
Buffer I/O error on device sdb, logical block 43
Buffer I/O error on device sdb, logical block 44
Buffer I/O error on device sdb, logical block 45
Buffer I/O error on device sdb, logical block 46
Buffer I/O error on device sdb, logical block 47
Buffer I/O error on device sdb, logical block 48
Buffer I/O error on device sdb, logical block 49
Buffer I/O error on device sdb, logical block 50
Buffer I/O error on device sdb, logical block 51
Buffer I/O error on device sdb, logical block 52
scsi 7:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 512

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc5 #34
---------------------------------------------
kblockd/1/58 is trying to acquire lock:
 (&q->unplug_work){--..}, at: [<ffffffff8104eb62>]
__cancel_work_timer+0x72/0x230

but task is already holding lock:
 (&q->unplug_work){--..}, at: [<ffffffff8104e22a>] run_workqueue+0xaa/0x240

other info that might help us debug this:
2 locks held by kblockd/1/58:
 #0:  (kblockd){--..}, at: [<ffffffff8104e22a>] run_workqueue+0xaa/0x240
 #1:  (&q->unplug_work){--..}, at: [<ffffffff8104e22a>]
run_workqueue+0xaa/0x240

stack backtrace:
Pid: 58, comm: kblockd/1 Not tainted 2.6.26-rc5 #34

Call Trace:
 [<ffffffff81063521>] __lock_acquire+0xae1/0x11d0
 [<ffffffff810133d8>] ? native_sched_clock+0x78/0x80
 [<ffffffff81062da4>] ? __lock_acquire+0x364/0x11d0
 [<ffffffff810133d8>] ? native_sched_clock+0x78/0x80
 [<ffffffff8104eb62>] ? __cancel_work_timer+0x72/0x230
 [<ffffffff81063ca6>] lock_acquire+0x96/0xe0
 [<ffffffff8104eb62>] ? __cancel_work_timer+0x72/0x230
 [<ffffffff8104eb92>] __cancel_work_timer+0xa2/0x230
 [<ffffffff810620fd>] ? mark_held_locks+0x4d/0x90
 [<ffffffff812f5f85>] ? _spin_unlock_irqrestore+0x65/0x90
 [<ffffffff81062321>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff812f5f65>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff810466a6>] ? try_to_del_timer_sync+0x76/0x90
 [<ffffffff8104ed3b>] cancel_work_sync+0xb/0x10
 [<ffffffff81168587>] blk_sync_queue+0x27/0x30
 [<ffffffff8116a313>] blk_release_queue+0x23/0x70
 [<ffffffff8117821a>] kobject_release+0x4a/0xa0
 [<ffffffff811781d0>] ? kobject_release+0x0/0xa0
 [<ffffffff81179267>] kref_put+0x37/0x70
 [<ffffffff811780d7>] kobject_put+0x27/0x60
 [<ffffffff8116854b>] blk_cleanup_queue+0x5b/0x70
 [<ffffffff81213ce9>] scsi_free_queue+0x9/0x10
 [<ffffffff8121955b>] scsi_device_dev_release_usercontext+0xeb/0x140
 [<ffffffff81219470>] ? scsi_device_dev_release_usercontext+0x0/0x140
 [<ffffffff8104f1d6>] execute_in_process_context+0x86/0x90
 [<ffffffff81219467>] scsi_device_dev_release+0x17/0x20
 [<ffffffff812044a9>] device_release+0x19/0x80
 [<ffffffff8117821a>] kobject_release+0x4a/0xa0
 [<ffffffff811781d0>] ? kobject_release+0x0/0xa0
 [<ffffffff81179267>] kref_put+0x37/0x70
 [<ffffffff811780d7>] kobject_put+0x27/0x60
 [<ffffffff81203d35>] put_device+0x15/0x20
 [<ffffffff81213e8f>] scsi_request_fn+0x9f/0x450
 [<ffffffff811669e0>] ? blk_unplug_work+0x0/0x20
 [<ffffffff811686d7>] __generic_unplug_device+0x27/0x30
 [<ffffffff811687e9>] generic_unplug_device+0x29/0x40
 [<ffffffff811669f4>] blk_unplug_work+0x14/0x20
 [<ffffffff8104e275>] run_workqueue+0xf5/0x240
 [<ffffffff8104e467>] worker_thread+0xa7/0x120
 [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8104e3c0>] ? worker_thread+0x0/0x120
 [<ffffffff81052639>] kthread+0x49/0x90
 [<ffffffff8100d478>] child_rip+0xa/0x12
 [<ffffffff8100cb63>] ? restore_args+0x0/0x30
 [<ffffffff810525f0>] ? kthread+0x0/0x90
 [<ffffffff8100d46e>] ? child_rip+0x0/0x12



Steps to reproduce:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
