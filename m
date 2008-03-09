From: Pete Wyckoff <pw@osc.edu>
Subject: [BUG 3/3] bsg mutex hang with iscsi logout
Date: Sun, 9 Mar 2008 12:55:17 -0400
Message-ID: <20080309165517.GC24388@osc.edu>
References: <20080309165359.GA24388@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:54855 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYCIQzW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 12:55:22 -0400
Content-Disposition: inline
In-Reply-To: <20080309165359.GA24388@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Here's an interesting hang.  Mount a target with iscsi, again one that
may be slow in responding.  Send it a command via bsg.  Kill the target
or unplug the network before the response returns.  At this point the
kernel notices and iscsid goes about trying to reconnect.

Hit ctrl-c to try to kill the bsg-using application.  Being the last
user of the device, it hangs during file close waiting for the
outstanding command to complete (even in error), sleeping with bsg_mutex
held.

sgio          D ffff81007c567bc8     0  2916   2846
 ffff81007c567b98 0000000000000046 ffff81007c567b78 ffff810040e16cc8
 ffff81007f721080 ffff81007f71f830 ffff81007f721298 ffffffff80263514
 ffff81007c567b98 0000000000000282 ffff81007c567c28 ffffffff80267238
Call Trace:
 [<ffffffff80263514>] ? __pagevec_free+0x24/0x30
 [<ffffffff80267238>] ? release_pages+0x198/0x1e0
 [<ffffffff80404ce8>] io_schedule+0x28/0x40
 [<ffffffff802f1520>] bsg_release+0x1c0/0x1e0
 [<ffffffff80244ad0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8028ded3>] __fput+0xb3/0x1a0
 [<ffffffff8028e1d6>] fput+0x16/0x20
 [<ffffffff8028afab>] filp_close+0x4b/0x80
 [<ffffffff80232171>] put_files_struct+0xc1/0xd0
 [<ffffffff802321c5>] __exit_files+0x45/0x50
 [<ffffffff80233592>] do_exit+0x1a2/0x7a0
 [<ffffffff80233bc7>] do_group_exit+0x37/0xa0
 [<ffffffff8023ccf8>] get_signal_to_deliver+0x268/0x330
 [<ffffffff8020b614>] ? sysret_signal+0x1c/0x27
 [<ffffffff8020a814>] do_notify_resume+0xd4/0x950
 [<ffffffff80244ba0>] ? finish_wait+0x60/0x80
 [<ffffffff802f112a>] ? bsg_get_done_cmd+0x11a/0x140
 [<ffffffff802f1f8a>] ? bsg_read+0xda/0x180
 [<ffffffff8028d5f4>] ? vfs_read+0xc4/0x150
 [<ffffffff8020b614>] ? sysret_signal+0x1c/0x27
 [<ffffffff8020b8a7>] ptregscall_common+0x67/0xb0

Meanwhile, in another shell, use iscsiadm to logout from the target.  As
scsi removes the device, it tells bsg to unregister the queue that is
going away, and to do that, it needs the bsg_mutex.  You have to be
fairly quick about it to get into this situation.

iscsi_scan_4  D ffffffff804ff688     0  2873      2
 ffff81007c421cd0 0000000000000046 000001a800000002 fffffffffffffffc
 ffff81007c1690c0 ffff81007e4c8830 ffff81007c1692d8 0000000000015d6d
 0000015400000002 fffffffffffffffc 0000000000015e4c 0000016400000002
Call Trace:
 [<ffffffff804052ff>] __mutex_lock_slowpath+0x7f/0xd0
 [<ffffffff804050be>] mutex_lock+0xe/0x10
 [<ffffffff802f1d81>] bsg_unregister_queue+0x31/0xa0
 [<ffffffff8036b300>] __scsi_remove_device+0x40/0xa0
 [<ffffffff8036b38b>] scsi_remove_device+0x2b/0x40
 [<ffffffff8036b43c>] __scsi_remove_target+0x9c/0xe0
 [<ffffffff8036b4e0>] ? __remove_child+0x0/0x30
 [<ffffffff8036b4fe>] __remove_child+0x1e/0x30
 [<ffffffff80355f93>] device_for_each_child+0x33/0x60
 [<ffffffff802fafea>] ? kobject_get+0x1a/0x30
 [<ffffffff8036b4ce>] scsi_remove_target+0x4e/0x60
 [<ffffffff880f1d15>] :scsi_transport_iscsi:__iscsi_unbind_session+0x85/0xa0
 [<ffffffff880f1c90>] ? :scsi_transport_iscsi:__iscsi_unbind_session+0x0/0xa0
 [<ffffffff80240c64>] run_workqueue+0x84/0x110
 [<ffffffff80241713>] worker_thread+0x93/0xd0
 [<ffffffff80244ad0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80241680>] ? worker_thread+0x0/0xd0
 [<ffffffff8024466d>] kthread+0x4d/0x80
 [<ffffffff8020c3b8>] child_rip+0xa/0x12
 [<ffffffff80244620>] ? kthread+0x0/0x80
 [<ffffffff8020c3ae>] ? child_rip+0x0/0x12

Same setup as the bug 1/3.

		-- Pete
