From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: lockdep complains on possible circular locking dependency when
 deleting an iscsi device
Date: Tue, 7 Jul 2015 11:58:40 +0300
Message-ID: <559B94C0.7020208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35578 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbbGGI62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 04:58:28 -0400
Received: by wgjx7 with SMTP id x7so161504117wgj.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2015 01:58:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Oren Duer <oren@mellanox.com>, Ariel Nahum <arieln@mellanox.com>

Hi,

I recently came across a lockdep complaint on a possible deadlock that
I don't understand yet (log output below).

Has anyone seen this? Any insights on why exactly is lockdep complaining?

The reproducer is very easy (reproduced both with tcp and iser):
- login to a target with one or more devices
- logout from the target
- login to the target again
- echo 1 > /sys/class/block/<iscsi_dev>/device/delete

Note that the device removal completes successfully.

log output:
[   66.189019] ======================================================
[   66.189019] [ INFO: possible circular locking dependency detected ]
[   66.189019] 4.1.0-rc7-dbg-vm-for-upstream-dbg-vm-2015-06-09_18-32-18 
#1 Not tainted
[   66.189019] -------------------------------------------------------
[   66.189019] sh/2102 is trying to acquire lock:
[   66.189019]  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff8149622d>] 
scsi_remove_device+0x2d/0x50
[   66.189019]
but task is already holding lock:
[   66.189019]  (s_active#126){++++.+}, at: [<ffffffff8127c0a2>] 
kernfs_remove_self+0xf2/0x160
[   66.189019]
which lock already depends on the new lock.

[   66.189019]
the existing dependency chain (in reverse order) is:
[   66.189019]
-> #1 (s_active#126){++++.+}:
[   66.189019]        [<ffffffff810bd8ff>] validate_chain+0x64f/0x810
[   66.189019]        [<ffffffff810bdee7>] __lock_acquire+0x427/0x600
[   66.189019]        [<ffffffff810be184>] lock_acquire+0xc4/0x220
[   66.189019]        [<ffffffff8127af73>] kernfs_drain+0x153/0x1d0
[   66.189019]        [<ffffffff8127ba9e>] __kernfs_remove+0x15e/0x210
[   66.189019]        [<ffffffff8127bba0>] 
kernfs_remove_by_name_ns+0x50/0xc0
[   66.189019]        [<ffffffff8127ed09>] remove_files+0x39/0x80
[   66.189019]        [<ffffffff8127eeb8>] sysfs_remove_group+0x48/0xa0
[   66.189019]        [<ffffffff8127ef4b>] sysfs_remove_groups+0x3b/0x60
[   66.189019]        [<ffffffff81453c1e>] device_remove_attrs+0x5e/0x90
[   66.189019]        [<ffffffff81453d75>] device_del+0x125/0x220
[   66.189019]        [<ffffffff814961ed>] __scsi_remove_device+0xcd/0xe0
[   66.189019]        [<ffffffff81496235>] scsi_remove_device+0x35/0x50
[   66.189019]        [<ffffffff81496340>] __scsi_remove_target+0xb0/0xf0
[   66.189019]        [<ffffffff81496778>] scsi_remove_target+0xd8/0x180
[   66.189019]        [<ffffffffa0564366>] 
__iscsi_unbind_session+0xb6/0x180 [scsi_transport_iscsi]
[   66.189019]        [<ffffffff810806da>] process_one_work+0x1ea/0x740
[   66.189019]        [<ffffffff81080d4f>] worker_thread+0x11f/0x3e0
[   66.189019]        [<ffffffff810874d6>] kthread+0xf6/0x120
[   66.189019]        [<ffffffff8169b992>] ret_from_fork+0x42/0x70
[   66.189019]
-> #0 (&shost->scan_mutex){+.+.+.}:
[   66.189019]        [<ffffffff810bd277>] check_prev_add+0x597/0x5d0
[   66.189019]        [<ffffffff810bd8ff>] validate_chain+0x64f/0x810
[   66.189019]        [<ffffffff810bdee7>] __lock_acquire+0x427/0x600
[   66.189019]        [<ffffffff810be184>] lock_acquire+0xc4/0x220
[   66.189019]        [<ffffffff81696935>] mutex_lock_nested+0x75/0x3e0
[   66.189019]        [<ffffffff8149622d>] scsi_remove_device+0x2d/0x50
[   66.189019]        [<ffffffff81496281>] sdev_store_delete+0x31/0x40
[   66.189019]        [<ffffffff81452920>] dev_attr_store+0x20/0x30
[   66.189019]        [<ffffffff8127e23f>] sysfs_kf_write+0x4f/0x70
[   66.189019]        [<ffffffff8127d647>] kernfs_fop_write+0x147/0x170
[   66.189019]        [<ffffffff811f6c34>] __vfs_write+0x34/0x100
[   66.189019]        [<ffffffff811f6f93>] vfs_write+0xb3/0x120
[   66.189019]        [<ffffffff811f7b19>] SyS_write+0x59/0xd0
[   66.189019]        [<ffffffff8169b597>] system_call_fastpath+0x12/0x6f
[   66.189019]
other info that might help us debug this:

[   66.189019]  Possible unsafe locking scenario:

[   66.189019]        CPU0                    CPU1
[   66.189019]        ----                    ----
[   66.189019]   lock(s_active#126);
[   66.189019]                                lock(&shost->scan_mutex);
[   66.189019]                                lock(s_active#126);
[   66.189019]   lock(&shost->scan_mutex);
[   66.189019]
  *** DEADLOCK ***

[   66.189019] 3 locks held by sh/2102:
[   66.189019]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811f6913>] 
file_start_write+0x33/0x40
[   66.189019]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8127d591>] 
kernfs_fop_write+0x91/0x170
[   66.189019]  #2:  (s_active#126){++++.+}, at: [<ffffffff8127c0a2>] 
kernfs_remove_self+0xf2/0x160
[   66.189019]
stack backtrace:
[   66.189019] CPU: 0 PID: 2102 Comm: sh Not tainted 
4.1.0-rc7-dbg-vm-for-upstream-dbg-vm-2015-06-09_18-32-18 #1
[   66.189019] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[   66.189019]  ffff8800710b0d18 ffff8800383aba28 ffffffff816942d0 
0000000000000001
[   66.189019]  0000000000000000 ffff8800383aba78 ffffffff810bb889 
ffff8800383aba98
[   66.189019]  ffff8800383aba98 ffff8800383aba78 ffff8800710b0ce0 
ffff8800710b0d18
[   66.189019] Call Trace:
[   66.189019]  [<ffffffff816942d0>] dump_stack+0x4f/0x6f
[   66.189019]  [<ffffffff810bb889>] print_circular_bug+0x109/0x110
[   66.189019]  [<ffffffff810bd277>] check_prev_add+0x597/0x5d0
[   66.189019]  [<ffffffff810bd8ff>] validate_chain+0x64f/0x810
[   66.189019]  [<ffffffff8109d1f5>] ? sched_clock_local+0x25/0x90
[   66.189019]  [<ffffffff810bdee7>] __lock_acquire+0x427/0x600
[   66.189019]  [<ffffffff810be184>] lock_acquire+0xc4/0x220
[   66.189019]  [<ffffffff8149622d>] ? scsi_remove_device+0x2d/0x50
[   66.189019]  [<ffffffff81696935>] mutex_lock_nested+0x75/0x3e0
[   66.189019]  [<ffffffff8149622d>] ? scsi_remove_device+0x2d/0x50
[   66.189019]  [<ffffffff8149622d>] ? scsi_remove_device+0x2d/0x50
[   66.189019]  [<ffffffff8127c0ae>] ? kernfs_remove_self+0xfe/0x160
[   66.189019]  [<ffffffff816968be>] ? mutex_unlock+0xe/0x10
[   66.189019]  [<ffffffff8149622d>] scsi_remove_device+0x2d/0x50
[   66.189019]  [<ffffffff81496281>] sdev_store_delete+0x31/0x40
[   66.189019]  [<ffffffff81452920>] dev_attr_store+0x20/0x30
[   66.189019]  [<ffffffff8127e23f>] sysfs_kf_write+0x4f/0x70
[   66.189019]  [<ffffffff8127d647>] kernfs_fop_write+0x147/0x170
[   66.189019]  [<ffffffff811f6c34>] __vfs_write+0x34/0x100
[   66.189019]  [<ffffffff811f6913>] ? file_start_write+0x33/0x40
[   66.189019]  [<ffffffff810f4a55>] ? current_kernel_time+0xa5/0xc0
[   66.189019]  [<ffffffff812a8053>] ? security_file_permission+0x23/0x90
[   66.189019]  [<ffffffff811f6f93>] vfs_write+0xb3/0x120
[   66.189019]  [<ffffffff811f7b19>] SyS_write+0x59/0xd0
[   66.189019]  [<ffffffff8113068c>] ? __audit_syscall_entry+0xac/0x110
[   66.189019]  [<ffffffff8169b597>] system_call_fastpath+0x12/0x6f

Thanks,
Sagi.
