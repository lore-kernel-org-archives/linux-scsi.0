From: Pete Wyckoff <pw@osc.edu>
Subject: bsg locking patches update
Date: Mon, 26 May 2008 12:53:18 -0400
Message-ID: <20080526165318.GA5466@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:56596 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYEZRCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2008 13:02:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I finally got around to testing the set of lifetime management
fixes you applied.  This is 2.6.26-rc3 with some varlen, bidi,
iser patches, and iovec on bsg, but nothing that should affect
the locking.

I can confirm that the first two of these three old bugs are
no longer reproducable:

    http://marc.info/?l=linux-scsi&m=120508166505141&w=2
    http://marc.info/?l=linux-scsi&m=120508177905365&w=2
    http://marc.info/?l=linux-scsi&m=120508178005376&w=2

Thanks!  The third, however, is a hang that still can happen.  But
it is very obscure and requires a bit of timing to get right.  As a
reminder, here's the setup, and updated traces.

Mount a target with iscsi, one that may be slow in responding.  Send
it a command via bsg.  Kill the target or unplug the network before
the response returns.  At this point the kernel notices and iscsid
goes about trying to reconnect.

Hit ctrl-c to try to kill the bsg-using application.  Being the last
user of the device, it hangs during file close waiting for the
outstanding command to complete, sleeping with bsg_mutex held.

iovec         D ffff810040e147e0     0  5053   4248
 ffff81007acabb78 0000000000000046 0000000000000018 00000000ffffffff
 ffff81007f721810 ffff81007f62c050 ffff81007f721a50 000000010ea8eeb5
 ffff81007acabb78 0000000000000292 ffff81007acabb88 0000000000000286
Call Trace:
 [<ffffffff80410688>] io_schedule+0x28/0x40
 [<ffffffff802f8ded>] bsg_release+0x1cd/0x210
 [<ffffffff80247260>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802aa871>] ? mntput_no_expire+0x31/0x130
 [<ffffffff80293713>] __fput+0xb3/0x1a0
 [<ffffffff80293ab6>] fput+0x16/0x20
 [<ffffffff802906cb>] filp_close+0x4b/0x80
 [<ffffffff80234a61>] put_files_struct+0xc1/0xd0
 [<ffffffff80234ab5>] exit_files+0x45/0x50
 [<ffffffff80235e72>] do_exit+0x1a2/0x790
 [<ffffffff8023649e>] do_group_exit+0x3e/0xa0
 [<ffffffff8023fe57>] get_signal_to_deliver+0x187/0x350
 [<ffffffff8020b694>] ? sysret_signal+0x1c/0x27
 [<ffffffff8020a86c>] do_notify_resume+0xcc/0x940
 [<ffffffff80371e85>] ? scsi_request_fn+0x255/0x3c0
 [<ffffffff80247330>] ? finish_wait+0x60/0x80
 [<ffffffff802f89da>] ? bsg_get_done_cmd+0x11a/0x140
 [<ffffffff802f983a>] ? bsg_read+0xda/0x180
 [<ffffffff80292e14>] ? vfs_read+0xc4/0x150
 [<ffffffff8020b694>] ? sysret_signal+0x1c/0x27
 [<ffffffff8020b917>] ptregscall_common+0x67/0xb0

Meanwhile, in another shell, use iscsiadm to logout from the target.
As scsi removes the device, it tells bsg to unregister the queue
that is going away, and to do that, it needs the bsg_mutex.

iscsi_scan_11 D ffff81000100c7e0     0  5033      2
 ffff810073d3fcd0 0000000000000046 0000000000000000 0000000000000000
 ffff810073d9cc50 ffffffff804fd360 ffff810073d9ce90 000000010ea919f5
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff80410c9f>] __mutex_lock_slowpath+0x7f/0xd0
 [<ffffffff80410a5e>] mutex_lock+0xe/0x10
 [<ffffffff802f9631>] bsg_unregister_queue+0x31/0xa0
 [<ffffffff80375b40>] __scsi_remove_device+0x40/0xa0
 [<ffffffff80375bcb>] scsi_remove_device+0x2b/0x40
 [<ffffffff80375c7c>] __scsi_remove_target+0x9c/0xe0
 [<ffffffff80375d20>] ? __remove_child+0x0/0x30
 [<ffffffff80375d3e>] __remove_child+0x1e/0x30
 [<ffffffff80360c93>] device_for_each_child+0x33/0x60
 [<ffffffff80302b2a>] ? kobject_get+0x1a/0x30
 [<ffffffff80375d0e>] scsi_remove_target+0x4e/0x60
 [<ffffffffa015da88>] :scsi_transport_iscsi:__iscsi_unbind_session+0x88/0xb0
 [<ffffffffa015da00>] ? :scsi_transport_iscsi:__iscsi_unbind_session+0x0/0xb0
 [<ffffffff802433f4>] run_workqueue+0x84/0x110
 [<ffffffff80243e93>] worker_thread+0x93/0xd0
 [<ffffffff80247260>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80243e00>] ? worker_thread+0x0/0xd0
 [<ffffffff80246ded>] kthread+0x4d/0x80
 [<ffffffff8020c428>] child_rip+0xa/0x12
 [<ffffffff80246da0>] ? kthread+0x0/0x80
 [<ffffffff8020c41e>] ? child_rip+0x0/0x12

Maybe it is necessary to split up that bsg_mutex to use multiple
finer-grained locks.

		-- Pete
