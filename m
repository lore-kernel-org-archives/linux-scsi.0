From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Fix scsi-mq lockdep issue
Date: Tue, 1 Aug 2017 10:21:30 -0500
Message-ID: <6d2bbcc8-3f4b-9b41-45b2-160f4817e439@linux.vnet.ibm.com>
References: <87a83qfosu.fsf@concordia.ellerman.id.au>
 <073ed79c-11ce-e86c-a905-91fd28675d47@kernel.dk>
 <1501166846.2516.1.camel@wdc.com>
 <5b85a365-faa1-3987-9b6b-270399c30686@kernel.dk>
 <87lgn9dqx3.fsf@concordia.ellerman.id.au>
 <92379297-9667-ae52-b05c-6c8a0ce4751c@kernel.dk>
 <OF186C0C54.7E077412-ON8625816B.0053C88E-8625816B.00540312@notes.na.collabserv.com>
 <5dcfe3ac-50c7-86a6-e571-fe5a1c1dc316@linux.vnet.ibm.com>
 <87379c6cfh.fsf@concordia.ellerman.id.au>
 <87a83ju6av.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87a83ju6av.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Fixes the following lockdep warning that can occur when scsi-mq is enabled
with ipr due to ipr calling scsi_unblock_requests from irq context. The fix
is to move the call to scsi_unblock_requests to ipr's existing workqueue.

stack backtrace:
CPU: 28 PID: 0 Comm: swapper/28 Not tainted 4.13.0-rc2-gcc6x-gf74c89b #1
Call Trace:
[c000001fffe97550] [c000000000b50818] dump_stack+0xe8/0x160 (unreliable)
[c000001fffe97590] [c0000000001586d0] print_usage_bug+0x2d0/0x390
[c000001fffe97640] [c000000000158f34] mark_lock+0x7a4/0x8e0
[c000001fffe976f0] [c00000000015a000] __lock_acquire+0x6a0/0x1a70
[c000001fffe97860] [c00000000015befc] lock_acquire+0xec/0x2e0
[c000001fffe97930] [c000000000b71514] _raw_spin_lock+0x44/0x70
[c000001fffe97960] [c0000000005b60f4] blk_mq_sched_dispatch_requests+0xa4/0x2a0
[c000001fffe979c0] [c0000000005acac0] __blk_mq_run_hw_queue+0x100/0x2c0
[c000001fffe97a00] [c0000000005ad478] __blk_mq_delay_run_hw_queue+0x118/0x130
[c000001fffe97a40] [c0000000005ad61c] blk_mq_start_hw_queues+0x6c/0xa0
[c000001fffe97a80] [c000000000797aac] scsi_kick_queue+0x2c/0x60
[c000001fffe97aa0] [c000000000797cf0] scsi_run_queue+0x210/0x360
[c000001fffe97b10] [c00000000079b888] scsi_run_host_queues+0x48/0x80
[c000001fffe97b40] [c0000000007b6090] ipr_ioa_bringdown_done+0x70/0x1e0
[c000001fffe97bc0] [c0000000007bc860] ipr_reset_ioa_job+0x80/0xf0
[c000001fffe97bf0] [c0000000007b4d50] ipr_reset_timer_done+0xd0/0x100
[c000001fffe97c30] [c0000000001937bc] call_timer_fn+0xdc/0x4b0
[c000001fffe97cf0] [c000000000193d08] expire_timers+0x178/0x330
[c000001fffe97d60] [c0000000001940c8] run_timer_softirq+0xb8/0x120
[c000001fffe97de0] [c000000000b726a8] __do_softirq+0x168/0x6d8
[c000001fffe97ef0] [c0000000000df2c8] irq_exit+0x108/0x150
[c000001fffe97f10] [c000000000017bf4] __do_irq+0x2a4/0x4a0
[c000001fffe97f90] [c00000000002da50] call_do_irq+0x14/0x24
[c0000007fad93aa0] [c000000000017e8c] do_IRQ+0x9c/0x140
[c0000007fad93af0] [c000000000008b98] hardware_interrupt_common+0x138/0x140

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

Index: linux-2.6.git/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.git.orig/drivers/scsi/ipr.c
+++ linux-2.6.git/drivers/scsi/ipr.c
@@ -3351,6 +3351,16 @@ static void ipr_worker_thread(struct wor
 		return;
 	}
 
+	if (ioa_cfg->scsi_unblock) {
+		ioa_cfg->scsi_unblock = 0;
+		ioa_cfg->scsi_blocked = 0;
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		scsi_unblock_requests(ioa_cfg->host);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		if (ioa_cfg->scsi_blocked)
+			scsi_block_requests(ioa_cfg->host);
+	}
+
 	if (!ioa_cfg->scan_enabled) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return;
@@ -7211,9 +7221,8 @@ static int ipr_ioa_bringdown_done(struct
 	ENTER;
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
 		ipr_trace;
-		spin_unlock_irq(ioa_cfg->host->host_lock);
-		scsi_unblock_requests(ioa_cfg->host);
-		spin_lock_irq(ioa_cfg->host->host_lock);
+		ioa_cfg->scsi_unblock = 1;
+		schedule_work(&ioa_cfg->work_q);
 	}
 
 	ioa_cfg->in_reset_reload = 0;
@@ -7287,13 +7296,7 @@ static int ipr_ioa_reset_done(struct ipr
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
 
-	spin_unlock(ioa_cfg->host->host_lock);
-	scsi_unblock_requests(ioa_cfg->host);
-	spin_lock(ioa_cfg->host->host_lock);
-
-	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds)
-		scsi_block_requests(ioa_cfg->host);
-
+	ioa_cfg->scsi_unblock = 1;
 	schedule_work(&ioa_cfg->work_q);
 	LEAVE;
 	return IPR_RC_JOB_RETURN;
@@ -9249,8 +9252,11 @@ static void _ipr_initiate_ioa_reset(stru
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
 	wmb();
-	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa)
+	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
+		ioa_cfg->scsi_unblock = 0;
+		ioa_cfg->scsi_blocked = 1;
 		scsi_block_requests(ioa_cfg->host);
+	}
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioa_cfg->reset_cmd = ipr_cmd;
@@ -9306,9 +9312,8 @@ static void ipr_initiate_ioa_reset(struc
 			wake_up_all(&ioa_cfg->reset_wait_q);
 
 			if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
-				spin_unlock_irq(ioa_cfg->host->host_lock);
-				scsi_unblock_requests(ioa_cfg->host);
-				spin_lock_irq(ioa_cfg->host->host_lock);
+				ioa_cfg->scsi_unblock = 1;
+				schedule_work(&ioa_cfg->work_q);
 			}
 			return;
 		} else {
Index: linux-2.6.git/drivers/scsi/ipr.h
===================================================================
--- linux-2.6.git.orig/drivers/scsi/ipr.h
+++ linux-2.6.git/drivers/scsi/ipr.h
@@ -1488,6 +1488,8 @@ struct ipr_ioa_cfg {
 	u8 cfg_locked:1;
 	u8 clear_isr:1;
 	u8 probe_done:1;
+	u8 scsi_unblock:1;
+	u8 scsi_blocked:1;
 
 	u8 revid;
 
