From: Joe Eykholt <jeykholt@cisco.com>
Subject: fc_remove_host / scsi_host_dev_release deadlock
Date: Fri, 07 Aug 2009 11:07:18 -0700
Message-ID: <4A7C6D56.6080602@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32179 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZHGSHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 14:07:22 -0400
Received: from sj-core-1.cisco.com (sj-core-1.cisco.com [171.71.177.237])
	by sj-dkim-1.cisco.com (8.12.11/8.12.11) with ESMTP id n77I7N0B029810
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2009 11:07:23 -0700
Received: from jeykholt-mac.nuovasystems.com ([172.30.136.66])
	by sj-core-1.cisco.com (8.13.8/8.14.3) with ESMTP id n77I7Nsq024028
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2009 18:07:23 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is different from the 3-way deadlock I posted on 7/25
http://marc.info/?l=linux-scsi&m=124856078500527&w=2

A user process is closing an sd block dev file.
It holds the sd_ref_mutex and is in scsi_host_dev_release()
doing a destroy_workqueue() which needs the cpu_add_remove_lock.

The process that holds cpu_add_remove_lock is doing
fcoe_destroy (deleting an FCoE instance) which calls
fc_remove_host() which does destroy_workqueue() and waiting in
flush_cpu_workqueue() for a work item to finish.

The stuck work item is doing fc_rport_final_delete(), and
that's in device_release_driver() in sd_remove() which
is waiting for the sd_ref_mutex.

I'd like to hear some discussion about the right approach
to fix this.  There should be some clear rules about how
work items can destroy or flush other workqueues.
I'd like to be able to state the clear rule that's being
violated here.

Perhaps the way cpu_add_remove_lock is used to in
destroy_workqueue() should be changed, or maybe
fc_rport_final_delete and fc_remove_host need to
be better about using workqueues somehow.

I do see a lock dependency warning about this, so that
system works.  I saw this once on a system based
on 2.6.31-rc4 under the current fcoe-next.git tree.

The following are the stacks I collected via /proc/*/stacks
and the lockdep warnings.

	Thanks,
	Joe


Name:   hald-probe-volu
State:  D (disk sleep)
cmd:    /usr/libexec/hald-probe-volume
wchan:  cpu_maps_update_begin

--- waiting cpu_add_remove_lock
--- has sd_ref_mutex in scsi_disk_put

[<ffffffff81042bd2>] cpu_maps_update_begin+0x12/0x14
[<ffffffff81052ee0>] destroy_workqueue+0x2b/0x9e
[<ffffffff8129ef4f>] scsi_host_dev_release+0x5a/0xbd
[<ffffffff81291941>] device_release+0x49/0x75
[<ffffffff811d39d8>] kobject_release+0x51/0x67
[<ffffffff811d4789>] kref_put+0x43/0x4f
[<ffffffff811d38e1>] kobject_put+0x47/0x4b
[<ffffffff812912f2>] put_device+0x12/0x14
[<ffffffffa004826b>] fc_rport_dev_release+0x18/0x24 [scsi_transport_fc]
[<ffffffff81291941>] device_release+0x49/0x75
[<ffffffff811d39d8>] kobject_release+0x51/0x67
[<ffffffff811d4789>] kref_put+0x43/0x4f
[<ffffffff811d38e1>] kobject_put+0x47/0x4b
[<ffffffff812912f2>] put_device+0x12/0x14
[<ffffffff812a4d44>] scsi_target_dev_release+0x1d/0x21
[<ffffffff81291941>] device_release+0x49/0x75
[<ffffffff811d39d8>] kobject_release+0x51/0x67
[<ffffffff811d4789>] kref_put+0x43/0x4f
[<ffffffff811d38e1>] kobject_put+0x47/0x4b
[<ffffffff812912f2>] put_device+0x12/0x14
[<ffffffff812a7709>] scsi_device_dev_release_usercontext+0x118/0x124
[<ffffffff81053894>] execute_in_process_context+0x2a/0x70
[<ffffffff812a75ef>] scsi_device_dev_release+0x17/0x19
[<ffffffff81291941>] device_release+0x49/0x75
[<ffffffff811d39d8>] kobject_release+0x51/0x67
[<ffffffff811d4789>] kref_put+0x43/0x4f
[<ffffffff811d38e1>] kobject_put+0x47/0x4b
[<ffffffff812912f2>] put_device+0x12/0x14
[<ffffffff8129dfd5>] scsi_device_put+0x3d/0x42
[<ffffffff812acb57>] scsi_disk_put+0x30/0x41
[<ffffffff812ad9c3>] sd_release+0x4d/0x54
[<ffffffff810f9ca0>] __blkdev_put+0xa7/0x16e
[<ffffffff810f9d57>] __blkdev_put+0x15e/0x16e
[<ffffffff810f9d72>] blkdev_put+0xb/0xd
[<ffffffff810f9dab>] blkdev_close+0x37/0x3c
[<ffffffff810d6450>] __fput+0x10d/0x1bb
[<ffffffff810d6516>] fput+0x18/0x1a
[<ffffffff810d35b0>] filp_close+0x67/0x72
[<ffffffff810d3660>] sys_close+0xa5/0xe4
[<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


Name:   fcoeadm
State:  D (disk sleep)
cmd:    fcoeadm -d eth4
wchan:  flush_cpu_workqueue

--- waits on cpu work to finish. -- fc_workqueue 28596
--- holds cpu_add_remove_lock

[<ffffffff81052dbd>] flush_cpu_workqueue+0x7b/0x87
[<ffffffff81052e33>] cleanup_workqueue_thread+0x6a/0xb8
[<ffffffff81052f18>] destroy_workqueue+0x63/0x9e
[<ffffffffa004a5a7>] fc_remove_host+0x148/0x171 [scsi_transport_fc]
[<ffffffffa03e48b2>] fcoe_if_destroy+0x1a6/0x1db [fcoe]
[<ffffffffa03e6001>] fcoe_destroy+0x86/0xad [fcoe]
[<ffffffff81055034>] param_attr_store+0x25/0x35
[<ffffffff81055089>] module_attr_store+0x21/0x25
[<ffffffff811279fe>] sysfs_write_file+0xe4/0x119
[<ffffffff810d5a12>] vfs_write+0xab/0x105
[<ffffffff810d5b30>] sys_write+0x47/0x6f
[<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


Name:   fc_wq_137
State:  D (disk sleep)
cmd:
wchan:  scsi_disk_get_from_dev

-- waits on sd_ref_mutex

[<ffffffff812acaf8>] scsi_disk_get_from_dev+0x1a/0x49
[<ffffffff812acfdd>] sd_shutdown+0x12/0x117
[<ffffffff812ad20f>] sd_remove+0x51/0x8a
[<ffffffff8129443e>] __device_release_driver+0x80/0xc9
[<ffffffff81294552>] device_release_driver+0x1e/0x2b
[<ffffffff81293ae6>] bus_remove_device+0xa8/0xc9
[<ffffffff812921d6>] device_del+0x13f/0x1ac
[<ffffffff812a7a58>] __scsi_remove_device+0x44/0x81
[<ffffffff812a7abb>] scsi_remove_device+0x26/0x33
[<ffffffff812a7b6d>] __scsi_remove_target+0x93/0xd7
[<ffffffff812a7c17>] __remove_child+0x1e/0x25
[<ffffffff81291a22>] device_for_each_child+0x38/0x6f
[<ffffffff812a7bec>] scsi_remove_target+0x3b/0x48
[<ffffffffa0049db7>] fc_starget_delete+0x21/0x25 [scsi_transport_fc]
[<ffffffffa0049eb1>] fc_rport_final_delete+0xf6/0x188 [scsi_transport_fc]
[<ffffffff810527ec>] worker_thread+0x1fa/0x30a
[<ffffffff81056c2d>] kthread+0x88/0x90
[<ffffffff8100cbfa>] child_rip+0xa/0x20
[<ffffffffffffffff>] 0xffffffffffffffff

  [ INFO: possible circular locking dependency detected ]
  2.6.31-rc4-rp9 #5
  -------------------------------------------------------
  hald-probe-volu/23829 is trying to acquire lock:
   (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81042bd2>] cpu_maps_update_begin+0x12/0x14

  but task is already holding lock:
   (sd_ref_mutex){+.+.+.}, at: [<ffffffff812acb47>] scsi_disk_put+0x20/0x41

  which lock already depends on the new lock.


  the existing dependency chain (in reverse order) is:

  -> #4 (sd_ref_mutex){+.+.+.}:
         [<ffffffff8106700c>] __lock_acquire+0xa48/0xbd0
         [<ffffffff8106724d>] lock_acquire+0xb9/0xdd
         [<ffffffff8150d536>] __mutex_lock_common+0x48/0x328
         [<ffffffff8150d88c>] mutex_lock_nested+0x24/0x29
         [<ffffffff812acaf8>] scsi_disk_get_from_dev+0x1a/0x49
         [<ffffffff812acfdd>] sd_shutdown+0x12/0x117
         [<ffffffff812ad20f>] sd_remove+0x51/0x8a
         [<ffffffff8129443e>] __device_release_driver+0x80/0xc9
         [<ffffffff81294552>] device_release_driver+0x1e/0x2b
         [<ffffffff81293ae6>] bus_remove_device+0xa8/0xc9
         [<ffffffff812921d6>] device_del+0x13f/0x1ac
         [<ffffffff812a7a58>] __scsi_remove_device+0x44/0x81
         [<ffffffff812a7abb>] scsi_remove_device+0x26/0x33
         [<ffffffff812a7b6d>] __scsi_remove_target+0x93/0xd7
         [<ffffffff812a7c17>] __remove_child+0x1e/0x25
         [<ffffffff81291a22>] device_for_each_child+0x38/0x6f
         [<ffffffff812a7bec>] scsi_remove_target+0x3b/0x48
         [<ffffffffa0049db7>] fc_starget_delete+0x21/0x25 [scsi_transport_fc]
         [<ffffffffa0049eb1>] fc_rport_final_delete+0xf6/0x188 [scsi_transport_fc]
         [<ffffffff810527ec>] worker_thread+0x1fa/0x30a
         [<ffffffff81056c2d>] kthread+0x88/0x90
         [<ffffffff8100cbfa>] child_rip+0xa/0x20
         [<ffffffffffffffff>] 0xffffffffffffffff

  -> #3 (&shost->scan_mutex){+.+.+.}:
         [<ffffffff8106700c>] __lock_acquire+0xa48/0xbd0
         [<ffffffff8106724d>] lock_acquire+0xb9/0xdd
         [<ffffffff8150d536>] __mutex_lock_common+0x48/0x328
         [<ffffffff8150d88c>] mutex_lock_nested+0x24/0x29
         [<ffffffff812a7ab3>] scsi_remove_device+0x1e/0x33
         [<ffffffff812a7b6d>] __scsi_remove_target+0x93/0xd7
         [<ffffffff812a7c17>] __remove_child+0x1e/0x25
         [<ffffffff81291a22>] device_for_each_child+0x38/0x6f
         [<ffffffff812a7bec>] scsi_remove_target+0x3b/0x48
         [<ffffffffa0049db7>] fc_starget_delete+0x21/0x25 [scsi_transport_fc]
         [<ffffffffa0049eb1>] fc_rport_final_delete+0xf6/0x188 [scsi_transport_fc]
         [<ffffffff810527ec>] worker_thread+0x1fa/0x30a
         [<ffffffff81056c2d>] kthread+0x88/0x90
         [<ffffffff8100cbfa>] child_rip+0xa/0x20
         [<ffffffffffffffff>] 0xffffffffffffffff

  -> #2 (&rport->rport_delete_work){+.+.+.}:
         [<ffffffff8106700c>] __lock_acquire+0xa48/0xbd0
         [<ffffffff8106724d>] lock_acquire+0xb9/0xdd
         [<ffffffff810527e3>] worker_thread+0x1f1/0x30a
         [<ffffffff81056c2d>] kthread+0x88/0x90
         [<ffffffff8100cbfa>] child_rip+0xa/0x20
         [<ffffffffffffffff>] 0xffffffffffffffff

  -> #1 ((fc_host->work_q_name)){+.+.+.}:
         [<ffffffff8106700c>] __lock_acquire+0xa48/0xbd0
         [<ffffffff8106724d>] lock_acquire+0xb9/0xdd
         [<ffffffff81052e0e>] cleanup_workqueue_thread+0x45/0xb8
         [<ffffffff81052f18>] destroy_workqueue+0x63/0x9e
         [<ffffffffa004a5a7>] fc_remove_host+0x148/0x171 [scsi_transport_fc]
         [<ffffffffa00738b2>] 0xffffffffa00738b2
         [<ffffffffa0075001>] 0xffffffffa0075001
         [<ffffffff81055034>] param_attr_store+0x25/0x35
         [<ffffffff81055089>] module_attr_store+0x21/0x25
         [<ffffffff811279fe>] sysfs_write_file+0xe4/0x119
         [<ffffffff810d5a12>] vfs_write+0xab/0x105
         [<ffffffff810d5b30>] sys_write+0x47/0x6f
         [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
         [<ffffffffffffffff>] 0xffffffffffffffff

  -> #0 (cpu_add_remove_lock){+.+.+.}:
         [<ffffffff81066f00>] __lock_acquire+0x93c/0xbd0
         [<ffffffff8106724d>] lock_acquire+0xb9/0xdd
         [<ffffffff8150d536>] __mutex_lock_common+0x48/0x328
         [<ffffffff8150d88c>] mutex_lock_nested+0x24/0x29
         [<ffffffff81042bd2>] cpu_maps_update_begin+0x12/0x14
         [<ffffffff81052ee0>] destroy_workqueue+0x2b/0x9e
         [<ffffffff8129ef4f>] scsi_host_dev_release+0x5a/0xbd
         [<ffffffff81291941>] device_release+0x49/0x75
         [<ffffffff811d39d8>] kobject_release+0x51/0x67
         [<ffffffff811d4789>] kref_put+0x43/0x4f
         [<ffffffff811d38e1>] kobject_put+0x47/0x4b
         [<ffffffff812912f2>] put_device+0x12/0x14
         [<ffffffffa004826b>] fc_rport_dev_release+0x18/0x24 [scsi_transport_fc]
         [<ffffffff81291941>] device_release+0x49/0x75
         [<ffffffff811d39d8>] kobject_release+0x51/0x67
         [<ffffffff811d4789>] kref_put+0x43/0x4f
         [<ffffffff811d38e1>] kobject_put+0x47/0x4b
         [<ffffffff812912f2>] put_device+0x12/0x14
         [<ffffffff812a4d44>] scsi_target_dev_release+0x1d/0x21
         [<ffffffff81291941>] device_release+0x49/0x75
         [<ffffffff811d39d8>] kobject_release+0x51/0x67
         [<ffffffff811d4789>] kref_put+0x43/0x4f
         [<ffffffff811d38e1>] kobject_put+0x47/0x4b
         [<ffffffff812912f2>] put_device+0x12/0x14
         [<ffffffff812a7709>] scsi_device_dev_release_usercontext+0x118/0x124
         [<ffffffff81053894>] execute_in_process_context+0x2a/0x70
         [<ffffffff812a75ef>] scsi_device_dev_release+0x17/0x19
         [<ffffffff81291941>] device_release+0x49/0x75
         [<ffffffff811d39d8>] kobject_release+0x51/0x67
         [<ffffffff811d4789>] kref_put+0x43/0x4f
         [<ffffffff811d38e1>] kobject_put+0x47/0x4b
         [<ffffffff812912f2>] put_device+0x12/0x14
         [<ffffffff8129dfd5>] scsi_device_put+0x3d/0x42
         [<ffffffff812acb57>] scsi_disk_put+0x30/0x41
         [<ffffffff812ad9c3>] sd_release+0x4d/0x54
         [<ffffffff810f9ca0>] __blkdev_put+0xa7/0x16e
         [<ffffffff810f9d57>] __blkdev_put+0x15e/0x16e
         [<ffffffff810f9d72>] blkdev_put+0xb/0xd
         [<ffffffff810f9dab>] blkdev_close+0x37/0x3c
         [<ffffffff810d6450>] __fput+0x10d/0x1bb
         [<ffffffff810d6516>] fput+0x18/0x1a
         [<ffffffff810d35b0>] filp_close+0x67/0x72
         [<ffffffff810d3660>] sys_close+0xa5/0xe4
         [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
         [<ffffffffffffffff>] 0xffffffffffffffff

  other info that might help us debug this:

  2 locks held by hald-probe-volu/23829:
   #0:  (&bdev->bd_mutex/1){+.+.+.}, at: [<ffffffff810f9c27>] __blkdev_put+0x2e/0x16e
   #1:  (sd_ref_mutex){+.+.+.}, at: [<ffffffff812acb47>] scsi_disk_put+0x20/0x41

  stack backtrace:
  Pid: 23829, comm: hald-probe-volu Not tainted 2.6.31-rc4-rp9 #5
  Call Trace:
   [<ffffffff8106624e>] print_circular_bug_tail+0x71/0x7c
   [<ffffffff81066f00>] __lock_acquire+0x93c/0xbd0
   [<ffffffff8106724d>] lock_acquire+0xb9/0xdd
   [<ffffffff81042bd2>] ? cpu_maps_update_begin+0x12/0x14
   [<ffffffff8150d536>] __mutex_lock_common+0x48/0x328
   [<ffffffff81042bd2>] ? cpu_maps_update_begin+0x12/0x14
   [<ffffffff81065c1d>] ? trace_hardirqs_on+0xd/0xf
   [<ffffffff8150e64c>] ? _spin_unlock_irq+0x2b/0x30
   [<ffffffff81042bd2>] ? cpu_maps_update_begin+0x12/0x14
   [<ffffffff8150ce9e>] ? wait_for_common+0xf7/0x112
   [<ffffffff8103c93f>] ? default_wake_function+0x0/0xf
   [<ffffffff8150d88c>] mutex_lock_nested+0x24/0x29
   [<ffffffff81042bd2>] cpu_maps_update_begin+0x12/0x14
   [<ffffffff81052ee0>] destroy_workqueue+0x2b/0x9e
   [<ffffffff8129ef4f>] scsi_host_dev_release+0x5a/0xbd
   [<ffffffff81291941>] device_release+0x49/0x75
   [<ffffffff811d39d8>] kobject_release+0x51/0x67
   [<ffffffff811d3987>] ? kobject_release+0x0/0x67
   [<ffffffff811d4789>] kref_put+0x43/0x4f
   [<ffffffff811d38e1>] kobject_put+0x47/0x4b
   [<ffffffff812912f2>] put_device+0x12/0x14
   [<ffffffffa004826b>] fc_rport_dev_release+0x18/0x24 [scsi_transport_fc]
   [<ffffffff81291941>] device_release+0x49/0x75
   [<ffffffff811d39d8>] kobject_release+0x51/0x67
   [<ffffffff811d3987>] ? kobject_release+0x0/0x67
   [<ffffffff811d4789>] kref_put+0x43/0x4f
   [<ffffffff811d38e1>] kobject_put+0x47/0x4b
   [<ffffffff812912f2>] put_device+0x12/0x14
   [<ffffffff812a4d44>] scsi_target_dev_release+0x1d/0x21
   [<ffffffff81291941>] device_release+0x49/0x75
   [<ffffffff811d39d8>] kobject_release+0x51/0x67
   [<ffffffff811d3987>] ? kobject_release+0x0/0x67
   [<ffffffff811d4789>] kref_put+0x43/0x4f
   [<ffffffff811d38e1>] kobject_put+0x47/0x4b
   [<ffffffff812912f2>] put_device+0x12/0x14
   [<ffffffff812a7709>] scsi_device_dev_release_usercontext+0x118/0x124
   [<ffffffff812a75f1>] ? scsi_device_dev_release_usercontext+0x0/0x124
   [<ffffffff81053894>] execute_in_process_context+0x2a/0x70
   [<ffffffff812a75ef>] scsi_device_dev_release+0x17/0x19
   [<ffffffff81291941>] device_release+0x49/0x75
   [<ffffffff811d39d8>] kobject_release+0x51/0x67
   [<ffffffff811d3987>] ? kobject_release+0x0/0x67
   [<ffffffff811d4789>] kref_put+0x43/0x4f
   [<ffffffff811d38e1>] kobject_put+0x47/0x4b
   [<ffffffff812912f2>] put_device+0x12/0x14
   [<ffffffff8129dfd5>] scsi_device_put+0x3d/0x42
   [<ffffffff812acb57>] scsi_disk_put+0x30/0x41
   [<ffffffff812ad9c3>] sd_release+0x4d/0x54
   [<ffffffff810f9ca0>] __blkdev_put+0xa7/0x16e
   [<ffffffff810f9d57>] __blkdev_put+0x15e/0x16e
   [<ffffffff810f9d72>] blkdev_put+0xb/0xd
   [<ffffffff810f9dab>] blkdev_close+0x37/0x3c
   [<ffffffff810d6450>] __fput+0x10d/0x1bb
   [<ffffffff810d6516>] fput+0x18/0x1a
   [<ffffffff810d35b0>] filp_close+0x67/0x72
   [<ffffffff810d3660>] sys_close+0xa5/0xe4
   [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b

-- end
