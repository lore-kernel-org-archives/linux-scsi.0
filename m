From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ipr: Reduce interrupt lock time
Date: Mon, 16 Jul 2012 15:48:09 -0500
Message-ID: <201207162048.q6GKmACe018141@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:33590 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2GPUsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2012 16:48:38 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 16 Jul 2012 14:48:38 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 953051FF004A
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 20:48:34 +0000 (WET)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6GKmCkZ169026
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 14:48:13 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6GKmBG2018213
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 14:48:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Reduce the amount of time the host lock is held in the interrupt handler
for improved performance.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   60 ++++++++++++++++++++++++++++++++++++++++-------------
 drivers/scsi/ipr.h |    1 
 2 files changed, 47 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_reduce_isr_lock2 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_reduce_isr_lock2	2012-07-13 16:06:16.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2012-07-13 16:06:16.000000000 -0500
@@ -1525,6 +1525,7 @@ struct ipr_cmnd {
 	struct ata_queued_cmd *qc;
 	struct completion completion;
 	struct timer_list timer;
+	void (*fast_done) (struct ipr_cmnd *);
 	void (*done) (struct ipr_cmnd *);
 	int (*job_step) (struct ipr_cmnd *);
 	int (*job_step_failed) (struct ipr_cmnd *);
diff -puN drivers/scsi/ipr.c~ipr_reduce_isr_lock2 drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_reduce_isr_lock2	2012-07-13 16:06:16.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2012-07-13 16:06:16.000000000 -0500
@@ -566,6 +566,23 @@ static void ipr_trc_hook(struct ipr_cmnd
 #endif
 
 /**
+ * ipr_lock_and_done - Acquire lock and complete command
+ * @ipr_cmd:	ipr command struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_lock_and_done(struct ipr_cmnd *ipr_cmd)
+{
+	unsigned long lock_flags = 0;
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	ipr_cmd->done(ipr_cmd);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+}
+
+/**
  * ipr_reinit_ipr_cmnd - Re-initialize an IPR Cmnd block for reuse
  * @ipr_cmd:	ipr command struct
  *
@@ -611,11 +628,13 @@ static void ipr_reinit_ipr_cmnd(struct i
  * Return value:
  * 	none
  **/
-static void ipr_init_ipr_cmnd(struct ipr_cmnd *ipr_cmd)
+static void ipr_init_ipr_cmnd(struct ipr_cmnd *ipr_cmd,
+			      void (*fast_done) (struct ipr_cmnd *))
 {
 	ipr_reinit_ipr_cmnd(ipr_cmd);
 	ipr_cmd->u.scratch = 0;
 	ipr_cmd->sibling = NULL;
+	ipr_cmd->fast_done = fast_done;
 	init_timer(&ipr_cmd->timer);
 }
 
@@ -648,7 +667,7 @@ static
 struct ipr_cmnd *ipr_get_free_ipr_cmnd(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct ipr_cmnd *ipr_cmd = __ipr_get_free_ipr_cmnd(ioa_cfg);
-	ipr_init_ipr_cmnd(ipr_cmd);
+	ipr_init_ipr_cmnd(ipr_cmd, ipr_lock_and_done);
 	return ipr_cmd;
 }
 
@@ -5130,8 +5149,9 @@ static irqreturn_t ipr_isr(int irq, void
 	u16 cmd_index;
 	int num_hrrq = 0;
 	int irq_none = 0;
-	struct ipr_cmnd *ipr_cmd;
+	struct ipr_cmnd *ipr_cmd, *temp;
 	irqreturn_t rc = IRQ_NONE;
+	LIST_HEAD(doneq);
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
@@ -5152,8 +5172,8 @@ static irqreturn_t ipr_isr(int irq, void
 
 			if (unlikely(cmd_index >= IPR_NUM_CMD_BLKS)) {
 				ipr_isr_eh(ioa_cfg, "Invalid response handle from IOA");
-				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-				return IRQ_HANDLED;
+				rc = IRQ_HANDLED;
+				goto unlock_out;
 			}
 
 			ipr_cmd = ioa_cfg->ipr_cmnd_list[cmd_index];
@@ -5162,9 +5182,7 @@ static irqreturn_t ipr_isr(int irq, void
 
 			ipr_trc_hook(ipr_cmd, IPR_TRACE_FINISH, ioasc);
 
-			list_del(&ipr_cmd->queue);
-			del_timer(&ipr_cmd->timer);
-			ipr_cmd->done(ipr_cmd);
+			list_move_tail(&ipr_cmd->queue, &doneq);
 
 			rc = IRQ_HANDLED;
 
@@ -5194,8 +5212,8 @@ static irqreturn_t ipr_isr(int irq, void
 		} else if (num_hrrq == IPR_MAX_HRRQ_RETRIES &&
 			   int_reg & IPR_PCII_HRRQ_UPDATED) {
 			ipr_isr_eh(ioa_cfg, "Error clearing HRRQ");
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			return IRQ_HANDLED;
+			rc = IRQ_HANDLED;
+			goto unlock_out;
 		} else
 			break;
 	}
@@ -5203,7 +5221,14 @@ static irqreturn_t ipr_isr(int irq, void
 	if (unlikely(rc == IRQ_NONE))
 		rc = ipr_handle_other_interrupt(ioa_cfg, int_reg);
 
+unlock_out:
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	list_for_each_entry_safe(ipr_cmd, temp, &doneq, queue) {
+		list_del(&ipr_cmd->queue);
+		del_timer(&ipr_cmd->timer);
+		ipr_cmd->fast_done(ipr_cmd);
+	}
+
 	return rc;
 }
 
@@ -5784,15 +5809,22 @@ static void ipr_scsi_done(struct ipr_cmn
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
+	unsigned long lock_flags = 0;
 
 	scsi_set_resid(scsi_cmd, be32_to_cpu(ipr_cmd->s.ioasa.hdr.residual_data_len));
 
 	if (likely(IPR_IOASC_SENSE_KEY(ioasc) == 0)) {
-		scsi_dma_unmap(ipr_cmd->scsi_cmd);
+		scsi_dma_unmap(scsi_cmd);
+
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 		list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 		scsi_cmd->scsi_done(scsi_cmd);
-	} else
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	} else {
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 		ipr_erp_start(ioa_cfg, ipr_cmd);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	}
 }
 
 /**
@@ -5848,12 +5880,12 @@ static int ipr_queuecommand(struct Scsi_
 	ipr_cmd = __ipr_get_free_ipr_cmnd(ioa_cfg);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
 
-	ipr_init_ipr_cmnd(ipr_cmd);
+	ipr_init_ipr_cmnd(ipr_cmd, ipr_scsi_done);
 	ioarcb = &ipr_cmd->ioarcb;
 
 	memcpy(ioarcb->cmd_pkt.cdb, scsi_cmd->cmnd, scsi_cmd->cmd_len);
 	ipr_cmd->scsi_cmd = scsi_cmd;
-	ipr_cmd->done = ipr_scsi_done;
+	ipr_cmd->done = ipr_scsi_eh_done;
 
 	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
 		if (scsi_cmd->underflow == 0)
_

