From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: improve interrupt service routine performance
Date: Tue, 12 Apr 2011 10:29:02 -0700
Message-ID: <4DA48BDE.4000003@linux.vnet.ibm.com>
References: <20110407202324.649117389@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53452 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1DLR3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2011 13:29:08 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3CHD6JY005790
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2011 11:13:06 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3CHT6P9059680
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2011 11:29:06 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3CHT3eo009846
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2011 11:29:05 -0600
In-Reply-To: <20110407202324.649117389@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

During performance testing on P7 machines it was observed that the interrupt
service routine was doing unnecessary MMIO operations.

This patch rearranges the logic of the routine and moves some of the code out
of the main routine.  The result is that there are now fewer MMIO operations in
the performance path of the code.

As a result of the above change, an existing condition was exposed where the
driver could get an "unexpected" hrrq interrupt.  The original code would flag
the interrupt as unexpected and then reset the adapter.  After further analysis
it was confirmed that this condition can occasionally occur and that the 
interrupt can safely be ignored.  Additional code in this patch detects this
condition, clears the interrupt and allows the driver to continue without 
resetting the adapter.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   68 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-04-07 12:08:00.519593071 -0700
+++ b/drivers/scsi/ipr.c	2011-04-07 12:46:35.289623710 -0700
@@ -4956,6 +4956,32 @@ static irqreturn_t ipr_handle_other_inte
 					      u32 int_reg)
 {
 	irqreturn_t rc = IRQ_HANDLED;
+	u32 int_mask_reg;
+
+	int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg32);
+	int_reg &= ~int_mask_reg;
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
@@ -4968,6 +4994,13 @@ static irqreturn_t ipr_handle_other_inte
 		list_del(&ioa_cfg->reset_cmd->queue);
 		del_timer(&ioa_cfg->reset_cmd->timer);
 		ipr_reset_ioa_job(ioa_cfg->reset_cmd);
+	} else if ((int_reg & IPR_PCII_HRRQ_UPDATED) == int_reg) {
+		if (ipr_debug && printk_ratelimit())
+			dev_err(&ioa_cfg->pdev->dev,
+				"Spurious interrupt detected. 0x%08X\n", int_reg);
+		writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
+		int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
+		return IRQ_NONE;
 	} else {
 		if (int_reg & IPR_PCII_IOA_UNIT_CHECKED)
 			ioa_cfg->ioa_unit_checked = 1;
@@ -5016,10 +5049,11 @@ static irqreturn_t ipr_isr(int irq, void
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
 	unsigned long lock_flags = 0;
-	u32 int_reg, int_mask_reg;
+	u32 int_reg = 0;
 	u32 ioasc;
 	u16 cmd_index;
 	int num_hrrq = 0;
+	int irq_none = 0;
 	struct ipr_cmnd *ipr_cmd;
 	irqreturn_t rc = IRQ_NONE;

@@ -5031,33 +5065,6 @@ static irqreturn_t ipr_isr(int irq, void
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

@@ -5097,7 +5104,7 @@ static irqreturn_t ipr_isr(int irq, void
 			/* Clear the PCI interrupt */
 			do {
 				writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
-				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
+				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
 			} while (int_reg & IPR_PCII_HRRQ_UPDATED &&
 					num_hrrq++ < IPR_MAX_HRRQ_RETRIES);

@@ -5107,6 +5114,9 @@ static irqreturn_t ipr_isr(int irq, void
 				return IRQ_HANDLED;
 			}

+		} else if (rc == IRQ_NONE && irq_none == 0) {
+			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
+			irq_none++;
 		} else
 			break;
 	}

