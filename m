From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: reverse the isr optimization changes
Date: Fri, 27 Aug 2010 14:45:07 -0700
Message-ID: <4C7831E3.6060305@linux.vnet.ibm.com>
References: <20100827175133.589741454@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51143 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0H0VpK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2010 17:45:10 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7RLamnq021580
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2010 15:36:48 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7RLj9nZ221374
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2010 15:45:09 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7RLmfC9020814
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2010 15:48:42 -0600
In-Reply-To: <20100827175133.589741454@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

The isr optimization patch that was submitted a few months ago
exposed problems with receiving and handling spurious HRRQ interrutps.

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=64ffdb762241c0a9c0c8fac7ea92aa0ba1529334

That patch is reverted with this one.  A new patch will be submitted
once the issue is better understood and properly handled in the driver.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   63 +++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-08-27 10:36:32.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-08-27 10:36:59.000000000 -0700
@@ -4936,39 +4936,15 @@ static int ipr_eh_abort(struct scsi_cmnd
 /**
  * ipr_handle_other_interrupt - Handle "other" interrupts
  * @ioa_cfg:	ioa config struct
+ * @int_reg:	interrupt register
  *
  * Return value:
  * 	IRQ_NONE / IRQ_HANDLED
  **/
-static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg)
+static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg,
+					      volatile u32 int_reg)
 {
 	irqreturn_t rc = IRQ_HANDLED;
-	volatile u32 int_reg, int_mask_reg;
-
-	int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
-
-	/* If an interrupt on the adapter did not occur, ignore it.
-	 * Or in the case of SIS 64, check for a stage change interrupt.
-	 */
-	if ((int_reg & IPR_PCII_OPER_INTERRUPTS) == 0) {
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
-				return IRQ_HANDLED;
-			}
-		}
-
-		return IRQ_NONE;
-	}

 	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
 		/* Mask the interrupt */
@@ -5029,7 +5005,7 @@ static irqreturn_t ipr_isr(int irq, void
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
 	unsigned long lock_flags = 0;
-	volatile u32 int_reg;
+	volatile u32 int_reg, int_mask_reg;
 	u32 ioasc;
 	u16 cmd_index;
 	int num_hrrq = 0;
@@ -5044,6 +5020,33 @@ static irqreturn_t ipr_isr(int irq, void
 		return IRQ_NONE;
 	}

+	int_mask_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg32);
+	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
+
+	/* If an interrupt on the adapter did not occur, ignore it.
+	 * Or in the case of SIS 64, check for a stage change interrupt.
+	 */
+	if (unlikely((int_reg & IPR_PCII_OPER_INTERRUPTS) == 0)) {
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
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				return IRQ_HANDLED;
+			}
+		}
+
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return IRQ_NONE;
+	}
+
 	while (1) {
 		ipr_cmd = NULL;

@@ -5083,7 +5086,7 @@ static irqreturn_t ipr_isr(int irq, void
 			/* Clear the PCI interrupt */
 			do {
 				writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
-				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
+				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32) & ~int_mask_reg;
 			} while (int_reg & IPR_PCII_HRRQ_UPDATED &&
 					num_hrrq++ < IPR_MAX_HRRQ_RETRIES);

@@ -5098,7 +5101,7 @@ static irqreturn_t ipr_isr(int irq, void
 	}

 	if (unlikely(rc == IRQ_NONE))
-		rc = ipr_handle_other_interrupt(ioa_cfg);
+		rc = ipr_handle_other_interrupt(ioa_cfg, int_reg);

 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return rc;

