From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv4 00/23] asynchronous ALUA device handler
Date: Thu, 24 Sep 2015 09:25:19 -0700
Message-ID: <560423EF.9030403@sandisk.com>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0098.outbound.protection.outlook.com ([207.46.100.98]:37629
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752285AbbIXQZa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2015 12:25:30 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/27/2015 05:41 AM, Hannes Reinecke wrote:
> here is an update to the ALUA device handler. 

Hello Hannes,

Has this patch series been tested on an initiator system with
kernel debugging enabled ? The message below appears if I boot
a kernel on which this patch series has been applied. Sorry that
I had not found the time before to test this patch series.

=================================
[ INFO: inconsistent lock state ]
sd 23:0:0:66: Attached scsi generic sg55 type 0
4.2.0-rc8-debug+ #1 Not tainted
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
ksoftirqd/1/13 [HC1[1]:SC1[1]:HE0:SE0] takes:
 (&(&pg->rtpg_lock)->rlock){?.+...}, at: [<ffffffffa040b78c>] alua_rtpg_queue+0x4c/0x160 [scsi_dh_alua]
{HARDIRQ-ON-W} state was registered at:
  [<ffffffff810be862>] __lock_acquire+0xae2/0x1c70
  [<ffffffff810c027b>] lock_acquire+0xcb/0x290
  [<ffffffff815070e8>] _raw_spin_lock+0x38/0x50
  [<ffffffffa040c5da>] alua_check_vpd+0x7da/0x860 [scsi_dh_alua]
  [<ffffffffa040cfee>] alua_initialize+0xfe/0x340 [scsi_dh_alua]
  [<ffffffffa040d2de>] alua_bus_attach+0x8e/0xc0 [scsi_dh_alua]
  [<ffffffffa0026261>] scsi_dh_handler_attach+0x31/0x90 [scsi_mod]
  [<ffffffffa0026683>] scsi_dh_attach+0x93/0xa0 [scsi_mod]
  [<ffffffffa01298d2>] multipath_ctr+0x8e2/0xaec [dm_multipath]
  [<ffffffffa041a324>] dm_table_add_target+0x124/0x370 [dm_mod]
  [<ffffffffa041d681>] table_load+0x121/0x350 [dm_mod]
  [<ffffffffa041e259>] ctl_ioctl+0x299/0x520 [dm_mod]
  [<ffffffffa041e4f3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
  [<ffffffff811d1d8d>] do_vfs_ioctl+0x30d/0x580
  [<ffffffff811d2041>] SyS_ioctl+0x41/0x70
  [<ffffffff81507cf2>] entry_SYSCALL_64_fastpath+0x16/0x7a
irq event stamp: 940607
hardirqs last  enabled at (940606): [<ffffffff81507366>] _raw_spin_unlock_irqrestore+0x36/0x60
hardirqs last disabled at (940607): [<ffffffff815088ab>] common_interrupt+0x6b/0x70
softirqs last  enabled at (940536): [<ffffffff8107a035>] __do_softirq+0x345/0x5d0
softirqs last disabled at (940541): [<ffffffff8107a2e5>] run_ksoftirqd+0x25/0x70

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&pg->rtpg_lock)->rlock);
  <Interrupt>
    lock(&(&pg->rtpg_lock)->rlock);

 *** DEADLOCK ***

1 lock held by ksoftirqd/1/13:
 #0:  (rcu_callback){......}, at: [<ffffffff810d6716>] rcu_process_callbacks+0x2b6/0xa50

stack backtrace:
CPU: 1 PID: 13 Comm: ksoftirqd/1 Not tainted 4.2.0-rc8-debug+ #1
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
 ffffffff824a0c90 ffff88047fc43918 ffffffff814ff6c4 0000000000000000
 ffff88045c66ac80 ffff88047fc43978 ffffffff814fc5a0 0000000000000001
 ffff880400000000 ffff880400000000 ffffffff8102bf6f 0000000000000000
Call Trace:
 <IRQ>  [<ffffffff814ff6c4>] dump_stack+0x4c/0x65
 [<ffffffff814fc5a0>] print_usage_bug+0x1f2/0x203
 [<ffffffff8102bf6f>] ? save_stack_trace+0x2f/0x50
 [<ffffffff810bcda0>] ? check_usage_backwards+0x110/0x110
 [<ffffffff810bd762>] mark_lock+0x212/0x2a0
 [<ffffffff810be997>] __lock_acquire+0xc17/0x1c70
 [<ffffffff810be29d>] ? __lock_acquire+0x51d/0x1c70
 [<ffffffff810c027b>] lock_acquire+0xcb/0x290
 [<ffffffffa040b78c>] ? alua_rtpg_queue+0x4c/0x160 [scsi_dh_alua]
 [<ffffffff81507a50>] _raw_spin_lock_irqsave+0x50/0x70
 [<ffffffffa040b78c>] ? alua_rtpg_queue+0x4c/0x160 [scsi_dh_alua]
 [<ffffffffa040b78c>] alua_rtpg_queue+0x4c/0x160 [scsi_dh_alua]
 [<ffffffffa040bbed>] alua_check+0xdd/0x270 [scsi_dh_alua]
 [<ffffffffa040bb15>] ? alua_check+0x5/0x270 [scsi_dh_alua]
 [<ffffffffa040bde6>] alua_check_sense+0x66/0x80 [scsi_dh_alua]
 [<ffffffffa0016546>] scsi_check_sense+0x76/0x3e0 [scsi_mod]
 [<ffffffffa0018c4f>] scsi_decide_disposition+0x17f/0x1f0 [scsi_mod]
 [<ffffffffa001cfe7>] scsi_softirq_done+0x57/0x150 [scsi_mod]
 [<ffffffff8127a3ba>] __blk_mq_complete_request+0x8a/0x110
 [<ffffffff8127a456>] blk_mq_complete_request+0x16/0x20
 [<ffffffffa001c048>] scsi_mq_done+0x48/0x1b0 [scsi_mod]
 [<ffffffffa03d10d9>] srp_recv_completion+0x249/0x720 [ib_srp]
 [<ffffffffa02c13b7>] mlx4_ib_cq_comp+0x17/0x20 [mlx4_ib]
 [<ffffffffa00bd8e8>] mlx4_cq_completion+0x38/0x70 [mlx4_core]
 [<ffffffffa00bf1b3>] mlx4_eq_int+0x493/0xcb0 [mlx4_core]
 [<ffffffff810bbbdd>] ? __lock_is_held+0x4d/0x70
 [<ffffffffa00bfa74>] mlx4_msi_x_interrupt+0x14/0x20 [mlx4_core]
 [<ffffffff810cb030>] handle_irq_event_percpu+0x40/0x4b0
 [<ffffffff810cb4e4>] handle_irq_event+0x44/0x70
 [<ffffffff810ce470>] handle_edge_irq+0x90/0x140
 [<ffffffff8101e3d2>] handle_irq+0x22/0x40
 [<ffffffff8150aa11>] do_IRQ+0x51/0xe0
 [<ffffffff811d493c>] ? __d_free+0x1c/0x20
 [<ffffffff815088b0>] common_interrupt+0x70/0x70
 <EOI>  [<ffffffff811ad1d1>] ? set_track+0x61/0x100
 [<ffffffff8150736b>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
 [<ffffffff814fe65d>] __slab_free+0x56/0x1ff
 [<ffffffff811d493c>] ? __d_free+0x1c/0x20
 [<ffffffff811b9987>] ? put_object+0x37/0x60
 [<ffffffff811af9d2>] ? kmem_cache_free+0xb2/0x370
 [<ffffffff811d493c>] ? __d_free+0x1c/0x20
 [<ffffffff811d493c>] ? __d_free+0x1c/0x20
 [<ffffffff811afc7f>] kmem_cache_free+0x35f/0x370
 [<ffffffff811d4920>] ? __d_free_external+0x40/0x40
 [<ffffffff811d493c>] __d_free+0x1c/0x20
 [<ffffffff810d6756>] rcu_process_callbacks+0x2f6/0xa50
 [<ffffffff810d6716>] ? rcu_process_callbacks+0x2b6/0xa50
 [<ffffffff81079dc2>] __do_softirq+0xd2/0x5d0
 [<ffffffff8107a2e5>] run_ksoftirqd+0x25/0x70
 [<ffffffff8109b279>] smpboot_thread_fn+0x139/0x200
 [<ffffffff8109b140>] ? sort_range+0x30/0x30
 [<ffffffff81097878>] kthread+0xf8/0x110
 [<ffffffff81097780>] ? kthread_create_on_node+0x210/0x210
 [<ffffffff8150815f>] ret_from_fork+0x3f/0x70
 [<ffffffff81097780>] ? kthread_create_on_node+0x210/0x210

