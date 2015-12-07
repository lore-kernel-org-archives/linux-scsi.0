From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] irq_poll: fold irq_poll_sched_prep into irq_poll_sched
Date: Mon,  7 Dec 2015 12:51:42 -0800
Message-ID: <1449521512-22921-4-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is no good reason to keep them apart, and this makes using the API
a bit simpler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/be2iscsi/be_main.c |  6 ++----
 drivers/scsi/ipr.c              |  3 +--
 include/linux/irq_poll.h        | 13 -------------
 lib/irq_poll.c                  | 10 +++++++---
 4 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 471e2b9..cb9072a8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -910,8 +910,7 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 	num_eq_processed = 0;
 	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
 				& EQE_VALID_MASK) {
-		if (!irq_poll_sched_prep(&pbe_eq->iopoll))
-			irq_poll_sched(&pbe_eq->iopoll);
+		irq_poll_sched(&pbe_eq->iopoll);
 
 		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
 		queue_tail_inc(eq);
@@ -972,8 +971,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			spin_unlock_irqrestore(&phba->isr_lock, flags);
 			num_mcceq_processed++;
 		} else {
-			if (!irq_poll_sched_prep(&pbe_eq->iopoll))
-				irq_poll_sched(&pbe_eq->iopoll);
+			irq_poll_sched(&pbe_eq->iopoll);
 			num_ioeq_processed++;
 		}
 		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 402e4ca..82031e0 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5692,8 +5692,7 @@ static irqreturn_t ipr_isr_mhrrq(int irq, void *devp)
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		if ((be32_to_cpu(*hrrq->hrrq_curr) & IPR_HRRQ_TOGGLE_BIT) ==
 		       hrrq->toggle_bit) {
-			if (!irq_poll_sched_prep(&hrrq->iopoll))
-				irq_poll_sched(&hrrq->iopoll);
+			irq_poll_sched(&hrrq->iopoll);
 			spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 			return IRQ_HANDLED;
 		}
diff --git a/include/linux/irq_poll.h b/include/linux/irq_poll.h
index 0cf7c26..73d7c20 100644
--- a/include/linux/irq_poll.h
+++ b/include/linux/irq_poll.h
@@ -18,19 +18,6 @@ enum {
 	IRQ_POLL_F_DISABLE	= 1,
 };
 
-/*
- * Returns 0 if we successfully set the IRQ_POLL_F_SCHED bit, indicating
- * that we were the first to acquire this iop for scheduling. If this iop
- * is currently disabled, return "failure".
- */
-static inline int irq_poll_sched_prep(struct irq_poll *iop)
-{
-	if (!test_bit(IRQ_POLL_F_DISABLE, &iop->state))
-		return test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state);
-
-	return 1;
-}
-
 static inline int irq_poll_disable_pending(struct irq_poll *iop)
 {
 	return test_bit(IRQ_POLL_F_DISABLE, &iop->state);
diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 88af879..13cb149 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -21,13 +21,17 @@ static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
  *
  * Description:
  *     Add this irq_poll structure to the pending poll list and trigger the
- *     raise of the blk iopoll softirq. The driver must already have gotten a
- *     successful return from irq_poll_sched_prep() before calling this.
+ *     raise of the blk iopoll softirq.
  **/
 void irq_poll_sched(struct irq_poll *iop)
 {
 	unsigned long flags;
 
+	if (test_bit(IRQ_POLL_F_DISABLE, &iop->state))
+		return;
+	if (!test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
+		return;
+
 	local_irq_save(flags);
 	list_add_tail(&iop->list, this_cpu_ptr(&blk_cpu_iopoll));
 	__raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);
@@ -58,7 +62,7 @@ EXPORT_SYMBOL(__irq_poll_complete);
  * Description:
  *     If a driver consumes less than the assigned budget in its run of the
  *     iopoll handler, it'll end the polled mode by calling this function. The
- *     iopoll handler will not be invoked again before irq_poll_sched_prep()
+ *     iopoll handler will not be invoked again before irq_poll_schedp()
  *     is called.
  **/
 void irq_poll_complete(struct irq_poll *iop)
-- 
1.9.1
