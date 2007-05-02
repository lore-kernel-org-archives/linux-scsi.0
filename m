From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Better handle adapter boot time errors
Date: Wed, 02 May 2007 10:44:11 -0500
Message-ID: <13297.3958076493$1178120690@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58882 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXEBPoO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 May 2007 11:44:14 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l42FiDug030966
	for <linux-scsi@vger.kernel.org>; Wed, 2 May 2007 11:44:13 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l42FiDHu534114
	for <linux-scsi@vger.kernel.org>; Wed, 2 May 2007 11:44:13 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l42FiDbL011819
	for <linux-scsi@vger.kernel.org>; Wed, 2 May 2007 11:44:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


If an ipr adapter encounters an adapter error requiring an
adapter reset to recover from prior to driver load time, the
error will be ignored and recovery will not happen until the
initial timeout occurs waiting for the firmware to come ready,
which means a five minute timeout. Fix is to read the interrupt
register before clearing any of the interrupts at probe time. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_boot_errors drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_boot_errors	2007-05-01 13:38:17.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-05-01 13:38:17.000000000 -0500
@@ -7451,7 +7451,7 @@ static int __devinit ipr_probe_ioa(struc
 	unsigned long ipr_regs_pci;
 	void __iomem *ipr_regs;
 	int rc = PCIBIOS_SUCCESSFUL;
-	volatile u32 mask, uproc;
+	volatile u32 mask, uproc, interrupts;
 
 	ENTER;
 
@@ -7558,9 +7558,14 @@ static int __devinit ipr_probe_ioa(struc
 	 * the card is in an unknown state and needs a hard reset
 	 */
 	mask = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+	interrupts = readl(ioa_cfg->regs.sense_interrupt_reg);
 	uproc = readl(ioa_cfg->regs.sense_uproc_interrupt_reg);
 	if ((mask & IPR_PCII_HRRQ_UPDATED) == 0 || (uproc & IPR_UPROCI_RESET_ALERT))
 		ioa_cfg->needs_hard_reset = 1;
+	if (interrupts & IPR_PCII_ERROR_INTERRUPTS)
+		ioa_cfg->needs_hard_reset = 1;
+	if (interrupts & IPR_PCII_IOA_UNIT_CHECKED)
+		ioa_cfg->ioa_unit_checked = 1;
 
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	rc = request_irq(pdev->irq, ipr_isr, IRQF_SHARED, IPR_NAME, ioa_cfg);
_
