From: Joe Eykholt <jeykholt@cisco.com>
Subject: sd_ref_mutex and cpu_add_remove_lock deadlock
Date: Wed, 24 Jun 2009 21:06:44 -0700
Message-ID: <4A42F7D4.8070102@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:31652 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZFYEGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2009 00:06:42 -0400
Received: from sj-core-2.cisco.com (sj-core-2.cisco.com [171.71.177.254])
	by sj-dkim-1.cisco.com (8.12.11/8.12.11) with ESMTP id n5P46jsi026444
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2009 21:06:45 -0700
Received: from airfoil.local ([10.200.1.69])
	by sj-core-2.cisco.com (8.13.8/8.14.3) with ESMTP id n5P46i8m029865
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2009 04:06:45 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Has anyone seen this?

I'm getting a hang due to three threads in a deadly
embrace involving two mutexes.

A user process doing a close on /dev/sdx has the sd_ref_mutex
and is trying to get cpu_add_remove_lock.

Another process is doing a /sys write to destroy an fcoe
instance.  It is in destroy_workqueue() which holds the
cpu_add_remove_lock() waiting for a work item to complete.

The third thread is running the work item, and waiting on
the sd_ref_mutex.

To summarize:
	Worker thread wants sd_ref_mutex
	Close thread has sd_ref_mutex and wants cpu_add_remove_lock
	Destroy thread has cpu_add_remove_lock and waits
		for worker_thread to exit.

The stacks are shown below.

I'm not sure what the best solution would be or which
locking rule is being broken here.

Also, it seems to me there's a possible deadlock where
sd_remove() has the sd_ref_mutex locked and is doing a
put_device().  The release function for this device is
scsi_disc_release(), which also takes the sd_ref_mutex().
Maybe it's known that this can't be the last put_device().

This is based on the open-fcoe.org fcoe-next.git tree, which is
fairly up-to-date.

This first process may not be involved, but

# cat /proc/3727/stack
[<ffffffff812a5830>] scsi_disk_get_from_dev+0x1a/0x49
	wants sd_ref_mutex
[<ffffffff812a5d15>] sd_shutdown+0x12/0x117
[<ffffffff812a5f47>] sd_remove+0x51/0x8a
[<ffffffff8128d2da>] __device_release_driver+0x80/0xc9
[<ffffffff8128d3ee>] device_release_driver+0x1e/0x2b
[<ffffffff8128c993>] bus_remove_device+0xa8/0xc9
[<ffffffff8128b092>] device_del+0x138/0x1a1
[<ffffffff812a0790>] __scsi_remove_device+0x44/0x81
[<ffffffff812a07f3>] scsi_remove_device+0x26/0x33
[<ffffffff812a08a5>] __scsi_remove_target+0x93/0xd7
[<ffffffff812a094f>] __remove_child+0x1e/0x25
[<ffffffff8128a8ee>] device_for_each_child+0x38/0x6f
[<ffffffff812a0924>] scsi_remove_target+0x3b/0x48
[<ffffffffa0048e14>] fc_starget_delete+0x21/0x25 [scsi_transport_fc]
[<ffffffffa0048f0e>] fc_rport_final_delete+0xf6/0x188 [scsi_transport_fc]
[<ffffffff81052588>] worker_thread+0x1fa/0x30a
[<ffffffff810569c1>] kthread+0x88/0x90
[<ffffffff8100cbfa>] child_rip+0xa/0x20
[<ffffffffffffffff>] 0xffffffffffffffff


# cat /proc/4230/stack
[<ffffffff81042a6a>] cpu_maps_update_begin+0x12/0x14
	wants cpu_add_remove_lock
[<ffffffff81052c7c>] destroy_workqueue+0x2b/0x9e
[<ffffffff81297d5b>] scsi_host_dev_release+0x5a/0xbd
[<ffffffff8128a80d>] device_release+0x49/0x75
[<ffffffff811d03b8>] kobject_release+0x51/0x67
[<ffffffff811d1169>] kref_put+0x43/0x4f
[<ffffffff811d02c1>] kobject_put+0x47/0x4b
[<ffffffff8128a1be>] put_device+0x12/0x14
[<ffffffffa004726b>] fc_rport_dev_release+0x18/0x24 [scsi_transport_fc]
[<ffffffff8128a80d>] device_release+0x49/0x75
[<ffffffff811d03b8>] kobject_release+0x51/0x67
[<ffffffff811d1169>] kref_put+0x43/0x4f
[<ffffffff811d02c1>] kobject_put+0x47/0x4b
[<ffffffff8128a1be>] put_device+0x12/0x14
[<ffffffff8129da8c>] scsi_target_dev_release+0x1d/0x21
[<ffffffff8128a80d>] device_release+0x49/0x75
[<ffffffff811d03b8>] kobject_release+0x51/0x67
[<ffffffff811d1169>] kref_put+0x43/0x4f
[<ffffffff811d02c1>] kobject_put+0x47/0x4b
[<ffffffff8128a1be>] put_device+0x12/0x14
[<ffffffff812a0441>] scsi_device_dev_release_usercontext+0x118/0x124
[<ffffffff81053627>] execute_in_process_context+0x2a/0x70
[<ffffffff812a0327>] scsi_device_dev_release+0x17/0x19
[<ffffffff8128a80d>] device_release+0x49/0x75
[<ffffffff811d03b8>] kobject_release+0x51/0x67
[<ffffffff811d1169>] kref_put+0x43/0x4f
[<ffffffff811d02c1>] kobject_put+0x47/0x4b
[<ffffffff8128a1be>] put_device+0x12/0x14
[<ffffffff81296ded>] scsi_device_put+0x3d/0x42
[<ffffffff812a588f>] scsi_disk_put+0x30/0x41
		has sd_ref_mutex
[<ffffffff812a66fb>] sd_release+0x4d/0x54
[<ffffffff810f916d>] __blkdev_put+0xa7/0x16e
[<ffffffff810f923f>] blkdev_put+0xb/0xd
[<ffffffff810f9278>] blkdev_close+0x37/0x3c
[<ffffffff810d5de6>] __fput+0xdf/0x186
[<ffffffff810d5ea5>] fput+0x18/0x1a
[<ffffffff810d3016>] filp_close+0x59/0x63
[<ffffffff810d30c5>] sys_close+0xa5/0xe4
[<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

# cat /proc/4236/stack
[<ffffffff81052b59>] flush_cpu_workqueue+0x7b/0x87
[<ffffffff81052bcf>] cleanup_workqueue_thread+0x6a/0xb8
[<ffffffff81052cb4>] destroy_workqueue+0x63/0x9e
		has cpu_add_remove_lock
[<ffffffffa0049604>] fc_remove_host+0x148/0x171 [scsi_transport_fc]
[<ffffffffa0073efe>] fcoe_if_destroy+0x183/0x1eb [fcoe]
[<ffffffffa0073f9b>] fcoe_destroy+0x35/0x76 [fcoe]
[<ffffffff81054dc8>] param_attr_store+0x25/0x35
[<ffffffff81054e1d>] module_attr_store+0x21/0x25
[<ffffffff8112461e>] sysfs_write_file+0xe4/0x119
[<ffffffff810d53d8>] vfs_write+0xab/0x105
[<ffffffff810d54f6>] sys_write+0x47/0x6e
[<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


	Thanks,
	Joe



