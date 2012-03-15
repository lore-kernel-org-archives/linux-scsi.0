From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/6] ipr: Remove unnecessary interrupt clearing on new adapters
Date: Wed, 14 Mar 2012 21:20:08 -0500
Message-ID: <201203150220.q2F2K4qQ002811@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56561 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2COCUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 22:20:32 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 20:20:31 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id C07B419D804E
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:19:59 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F2K5Cx164968
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:05 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F2K5q4002852
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


The latest ipr hardware no longer requires the driver to issue any MMIOs
to clear the interrupt so remove this to optimize performance.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   21 +++++++++++++++------
 drivers/scsi/ipr.h |    2 ++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_skip_interrupt_clear drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_skip_interrupt_clear	2012-03-10 07:31:38.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2012-03-10 07:31:38.000000000 -0600
@@ -1306,6 +1306,7 @@ struct ipr_interrupts {
 struct ipr_chip_cfg_t {
 	u32 mailbox;
 	u8 cache_line_size;
+	u8 clear_isr;
 	struct ipr_interrupt_offsets regs;
 };
 
@@ -1388,6 +1389,7 @@ struct ipr_ioa_cfg {
 	u8 sis64:1;
 	u8 dump_timeout:1;
 	u8 cfg_locked:1;
+	u8 clear_isr:1;
 
 	u8 revid;
 
diff -puN drivers/scsi/ipr.c~ipr_skip_interrupt_clear drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_skip_interrupt_clear	2012-03-10 07:31:38.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2012-03-10 07:31:38.000000000 -0600
@@ -105,6 +105,7 @@ static const struct ipr_chip_cfg_t ipr_c
 	{ /* Gemstone, Citrine, Obsidian, and Obsidian-E */
 		.mailbox = 0x0042C,
 		.cache_line_size = 0x20,
+		.clear_isr = 1,
 		{
 			.set_interrupt_mask_reg = 0x0022C,
 			.clr_interrupt_mask_reg = 0x00230,
@@ -127,6 +128,7 @@ static const struct ipr_chip_cfg_t ipr_c
 	{ /* Snipe and Scamp */
 		.mailbox = 0x0052C,
 		.cache_line_size = 0x20,
+		.clear_isr = 1,
 		{
 			.set_interrupt_mask_reg = 0x00288,
 			.clr_interrupt_mask_reg = 0x0028C,
@@ -149,6 +151,7 @@ static const struct ipr_chip_cfg_t ipr_c
 	{ /* CRoC */
 		.mailbox = 0x00044,
 		.cache_line_size = 0x20,
+		.clear_isr = 0,
 		{
 			.set_interrupt_mask_reg = 0x00010,
 			.clr_interrupt_mask_reg = 0x00018,
@@ -5049,12 +5052,14 @@ static irqreturn_t ipr_handle_other_inte
 		del_timer(&ioa_cfg->reset_cmd->timer);
 		ipr_reset_ioa_job(ioa_cfg->reset_cmd);
 	} else if ((int_reg & IPR_PCII_HRRQ_UPDATED) == int_reg) {
-		if (ipr_debug && printk_ratelimit())
-			dev_err(&ioa_cfg->pdev->dev,
-				"Spurious interrupt detected. 0x%08X\n", int_reg);
-		writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
-		int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
-		return IRQ_NONE;
+		if (ioa_cfg->clear_isr) {
+			if (ipr_debug && printk_ratelimit())
+				dev_err(&ioa_cfg->pdev->dev,
+					"Spurious interrupt detected. 0x%08X\n", int_reg);
+			writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg32);
+			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
+			return IRQ_NONE;
+		}
 	} else {
 		if (int_reg & IPR_PCII_IOA_UNIT_CHECKED)
 			ioa_cfg->ioa_unit_checked = 1;
@@ -5154,6 +5159,9 @@ static irqreturn_t ipr_isr(int irq, void
 			}
 		}
 
+		if (ipr_cmd && !ioa_cfg->clear_isr)
+			break;
+
 		if (ipr_cmd != NULL) {
 			/* Clear the PCI interrupt */
 			num_hrrq = 0;
@@ -8769,6 +8777,7 @@ static int __devinit ipr_probe_ioa(struc
 	/* set SIS 32 or SIS 64 */
 	ioa_cfg->sis64 = ioa_cfg->ipr_chip->sis_type == IPR_SIS64 ? 1 : 0;
 	ioa_cfg->chip_cfg = ioa_cfg->ipr_chip->cfg;
+	ioa_cfg->clear_isr = ioa_cfg->chip_cfg->clear_isr;
 
 	if (ipr_transop_timeout)
 		ioa_cfg->transop_timeout = ipr_transop_timeout;
_

