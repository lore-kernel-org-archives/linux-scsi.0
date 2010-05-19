From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: improve interrupt service routine performance
Date: Wed, 19 May 2010 11:56:13 -0700
Message-ID: <4BF4344D.6070109@linux.vnet.ibm.com>
References: <20100519184827.824039221@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:46481 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0ESS41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2010 14:56:27 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o4JIldhc021583
	for <linux-scsi@vger.kernel.org>; Wed, 19 May 2010 12:47:39 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o4JIuHK7236210
	for <linux-scsi@vger.kernel.org>; Wed, 19 May 2010 12:56:21 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4JIx9RN023745
	for <linux-scsi@vger.kernel.org>; Wed, 19 May 2010 12:59:09 -0600
In-Reply-To: <20100519184827.824039221@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

During performance testing on P7 machines it was observed that the interrupt
service routine was doing unnecessary MMIO operations.

This patch rearranges the logic of the routine and moves some of the code out
of the main routine.  The result is that there are now fewer MMIO operations in
the performance path of the code.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   63 +++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-05-18 09:17:00.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-05-19 11:44:18.000000000 -0700
@@ -4815,15 +4815,39 @@ static int ipr_eh_abort(struct scsi_cmnd
 /**
  * ipr_handle_other_interrupt - Handle "other" interrupts
  * @ioa_cfg:	ioa config struct
- * @int_reg:	interrupt register
  *
  * Return value:
  * 	IRQ_NONE / IRQ_HANDLED
  **/
-static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg,
-					      volatile u32 int_reg)
+static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg)
 {
 	irqreturn_t rc = IRQ_HANDLED;
+	volatile u32 int_reg, int_mask_reg;
+
+	int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg32);
+	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
+
+	/* If an interrupt on the adapter did not occur, ignore it.
+	 * Or in the case of SIS 64, check for a stage change interrupt.
+	 */
+	if ((int_reg & IPR_PCII_OPER_INTERRUPTS) == 0) {
+		if (ioa_cfg->sis64) {
+			int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
+			if (int_reg & IPR_PCII_IPL_STAGE_CHANGE) {
+
+				/* clear stage change */
+				writel(IPR_PCII_IPL_STAGE_CHANGE, ioa_cfg->regs.clr_interrupt_reg);
+				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
+				list_del(&ioa_cfg->reset_cmd->queue);
+				del_timer(&ioa_cfg->reset_cmd->timer);
+				ipr_reset_ioa_job(ioa_cfg->reset_cmd);
+				return IRQ_HANDLED;
+			}
+		}
+
+		return IRQ_NONE;
+	}

 	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
 		/* Mask the interrupt */
@@ -4884,7 +4908,7 @@ static irqreturn_t ipr_isr(int irq, void
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
 	unsigned long lock_flags = 0;
-	volatile u32 int_reg, int_mask_reg;
+	volatile u32 int_reg;
 	u32 ioasc;
 	u16 cmd_index;
 	int num_hrrq = 0;
@@ -4899,33 +4923,6 @@ static irqreturn_t ipr_isr(int irq, void
 		return IRQ_NONE;
 	}

-	int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
-
-	/* If an interrupt on the adapter did not occur, ignore it.
-	 * Or in the case of SIS 64, check for a stage change interrupt.
-	 */
-	if (unlikely((int_reg & IPR_PCII_OPER_INTERRUPTS) == 0)) {
-		if (ioa_cfg->sis64) {
-			int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
-			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
-			if (int_reg & IPR_PCII_IPL_STAGE_CHANGE) {
-
-				/* clear stage change */
-				writel(IPR_PCII_IPL_STAGE_CHANGE, ioa_cfg->regs.clr_interrupt_reg);
-				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
-				list_del(&ioa_cfg->reset_cmd->queue);
-				del_timer(&ioa_cfg->reset_cmd->timer);
-				ipr_reset_ioa_job(ioa_cfg->reset_cmd);
-				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-				return IRQ_HANDLED;
-			}
-		}
-
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		return IRQ_NONE;
-	}
-
 	while (1) {
 		ipr_cmd = NULL;

@@ -4965,7 +4962,7 @@ static irqreturn_t ipr_isr(int irq, void
 			/* Clear the PCI interrupt */
 			do {
 				writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
-				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
+				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
 			} while (int_reg & IPR_PCII_HRRQ_UPDATED &&
 					num_hrrq++ < IPR_MAX_HRRQ_RETRIES);

@@ -4980,7 +4977,7 @@ static irqreturn_t ipr_isr(int irq, void
 	}

 	if (unlikely(rc == IRQ_NONE))
-		rc = ipr_handle_other_interrupt(ioa_cfg, int_reg);
+		rc = ipr_handle_other_interrupt(ioa_cfg);

 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return rc;

