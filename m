From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] scsi-mq: fix potential deadlock in scsi_internal_device_unblock()
Date: Thu, 05 Feb 2015 14:50:27 -0500
Message-ID: <54D3C983.4010806@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:58653 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbBETub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:50:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>

A process context may acquire struct blk_mq_hw_ctx::lock without
disabling IRQs.  A deadlock may result if the process context holding
the spinlock is interrupted by an IRQ that calls
scsi_internal_device_unblock(), which may also try to acquire the same
spinlock.  Pass 'async = true' to blk_mq_start_stopped_hw_queues() to
prevent the deadlock.

This fixes a lockdep warning triggered by unplugging a SAS cable using
mpt2sas:

=================================
[ INFO: inconsistent lock state ]
3.19.0-rc7 #2 Not tainted
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/2/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&(&hctx->lock)->rlock){?.+...}, at: [<ffffffff803e3523>] __blk_mq_run_hw_queue+0x183/0x3f0
{HARDIRQ-ON-W} state was registered at:
  [<ffffffff802a13d1>] __lock_acquire+0x721/0xc10
  [<ffffffff802a191a>] lock_acquire+0x5a/0x70
  [<ffffffff80680913>] _raw_spin_lock+0x33/0x50
  [<ffffffff803e35ef>] __blk_mq_run_hw_queue+0x24f/0x3f0
  [<ffffffff803e39c8>] blk_mq_run_hw_queue+0x88/0xc0
  [<ffffffff803e3d6f>] blk_sq_make_request+0x15f/0x240
  [<ffffffff803d8820>] generic_make_request+0xc0/0x100
  [<ffffffff803d88b8>] submit_bio+0x58/0x100
  [<ffffffff8035f157>] _submit_bh+0x117/0x150
  [<ffffffff8035f19b>] submit_bh+0xb/0x10
  [<ffffffff80362538>] block_read_full_page+0x268/0x370
  [<ffffffff803640e3>] blkdev_readpage+0x13/0x20
  [<ffffffff802e786b>] generic_file_read_iter+0x20b/0x640
  [<ffffffff803637b2>] blkdev_read_iter+0x32/0x40
  [<ffffffff8032bcfa>] new_sync_read+0x8a/0xc0
  [<ffffffff8032bdd3>] __vfs_read+0x13/0x60
  [<ffffffff8032d7f8>] vfs_read+0xa8/0x110
  [<ffffffff8032d944>] SyS_read+0x54/0xc0
  [<ffffffff80681552>] system_call_fastpath+0x12/0x17
irq event stamp: 396654
hardirqs last  enabled at (396651): [<ffffffff805a42b1>] cpuidle_enter_state+0x51/0xd0
hardirqs last disabled at (396652): [<ffffffff806820e7>] common_interrupt+0x67/0x6c
softirqs last  enabled at (396654): [<ffffffff8026414c>] _local_bh_enable+0x1c/0x50
softirqs last disabled at (396653): [<ffffffff80264310>] irq_enter+0x50/0x80

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&hctx->lock)->rlock);
  <Interrupt>
    lock(&(&hctx->lock)->rlock);

 *** DEADLOCK ***

no locks held by swapper/2/0.

stack backtrace:
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.19.0-rc7 #2
Hardware name: Supermicro X8DTH-i/6/iF/6F/X8DTH, BIOS 2.1b       05/04/12  
 ffffffff80fbf8b0 ffff88033e4439c8 ffffffff8067b708 0000000000000001
 ffff88032fe9a1c0 ffff88033e443a18 ffffffff8029d40f 0000000000000000
 ffffffff00000000 ffff880300000001 ffffffff80fbf8e8 ffff88032fe9a858
Call Trace:
 <IRQ>  [<ffffffff8067b708>] dump_stack+0x4f/0x6f
 [<ffffffff8029d40f>] print_usage_bug+0x23f/0x300
 [<ffffffff8029daed>] mark_lock+0x61d/0x690
 [<ffffffff802a141d>] __lock_acquire+0x76d/0xc10
 [<ffffffff802938dc>] ? enqueue_task_fair+0x1fc/0x890
 [<ffffffff80283d79>] ? resched_curr+0x89/0xc0
 [<ffffffff802a191a>] lock_acquire+0x5a/0x70
 [<ffffffff803e3523>] ? __blk_mq_run_hw_queue+0x183/0x3f0
 [<ffffffff80680913>] _raw_spin_lock+0x33/0x50
 [<ffffffff803e3523>] ? __blk_mq_run_hw_queue+0x183/0x3f0
 [<ffffffff803e3523>] __blk_mq_run_hw_queue+0x183/0x3f0
 [<ffffffff803e39c8>] blk_mq_run_hw_queue+0x88/0xc0
 [<ffffffff803e4250>] blk_mq_start_stopped_hw_queues+0x60/0x80
 [<ffffffff804e4686>] scsi_internal_device_unblock+0x46/0xb0
 [<ffffffffa005039f>] _scsih_ublock_io_device+0x7f/0xd0 [mpt2sas]
 [<ffffffffa0050582>] _scsih_tm_tr_send+0x192/0x320 [mpt2sas]
 [<ffffffffa0054073>] mpt2sas_scsih_event_callback+0x3b3/0x7b0 [mpt2sas]
 [<ffffffffa0045900>] _base_interrupt+0x340/0x9d0 [mpt2sas]
 [<ffffffff802a11bc>] ? __lock_acquire+0x50c/0xc10
 [<ffffffff802a9df3>] handle_irq_event_percpu+0x43/0x120
 [<ffffffff802a9f13>] handle_irq_event+0x43/0x70
 [<ffffffff802ad5ed>] handle_edge_irq+0x9d/0x100
 [<ffffffff80204b74>] handle_irq+0x54/0x130
 [<ffffffff80280671>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff80203ff7>] do_IRQ+0x57/0x100
 [<ffffffff806820ec>] common_interrupt+0x6c/0x6c
 <EOI>  [<ffffffff805a42bc>] ? cpuidle_enter_state+0x5c/0xd0
 [<ffffffff805a42b1>] ? cpuidle_enter_state+0x51/0xd0
 [<ffffffff805a4342>] cpuidle_enter+0x12/0x20
 [<ffffffff80299c3f>] cpu_startup_entry+0x25f/0x300
 [<ffffffff80230a5f>] start_secondary+0x13f/0x170

Cc: <stable@vger.kernel.org> # 3.17+
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

Note that this patch does *not* fix the deadlock with mptsas that I
reported yesterday; that is a completely different issue that still
needs to be addressed.

--- linux-3.19-rc7/drivers/scsi/scsi_lib.c.orig	2015-02-01 23:07:21.000000000 -0500
+++ linux-3.19-rc7/drivers/scsi/scsi_lib.c	2015-02-05 13:28:12.000000000 -0500
@@ -3005,7 +3005,7 @@ scsi_internal_device_unblock(struct scsi
 		return -EINVAL;
 
 	if (q->mq_ops) {
-		blk_mq_start_stopped_hw_queues(q, false);
+		blk_mq_start_stopped_hw_queues(q, true);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_start_queue(q);

