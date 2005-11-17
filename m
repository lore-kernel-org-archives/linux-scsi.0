From: brking@us.ibm.com
Subject: [PATCH 1/1] ipr: Driver initialization fix for kexec/kdump
Date: Thu, 17 Nov 2005 09:35:12 -0600
Message-ID: <200511171535.jAHFZDeU010560@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:15342 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750741AbVKQPfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 10:35:17 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jAHFZERV004050
	for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2005 10:35:14 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jAHFZELZ122024
	for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2005 10:35:14 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jAHFZDL7010589
	for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2005 10:35:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, haren@us.ibm.com, brking@us.ibm.com


When kexec booting a kernel when the previous kernel did not
call ipr's shutdown method, the ipr adapter does not get
properly initialized, which can result in the ipr adapter
completing commands issued by the previous kernel. Fix ipr
to detect this scenario by reading the adapter's interrupt
mask register and the microprocessor interrupt register.
If the interrupt mask register indicates that interrupts
are enabled or the reset alert bit is set when the card is
probed, this means the card is in an unknown state and we
hard reset the card.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   17 ++++++++++++++++-
 linux-2.6-bjking1/drivers/scsi/ipr.h |    5 +++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_kexec_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_kexec_fix	2005-11-17 09:29:23.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-17 09:29:23.000000000 -0600
@@ -5887,7 +5887,12 @@ static int __devinit ipr_probe_ioa_part2
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 	dev_dbg(&ioa_cfg->pdev->dev, "ioa_cfg adx: 0x%p\n", ioa_cfg);
-	_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_enable_ioa, IPR_SHUTDOWN_NONE);
+	if (ioa_cfg->needs_hard_reset) {
+		ioa_cfg->needs_hard_reset = 0;
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+	} else
+		_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_enable_ioa,
+					IPR_SHUTDOWN_NONE);
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
@@ -6264,6 +6269,7 @@ static int __devinit ipr_probe_ioa(struc
 	unsigned long ipr_regs_pci;
 	void __iomem *ipr_regs;
 	u32 rc = PCIBIOS_SUCCESSFUL;
+	volatile u32 mask, uproc;
 
 	ENTER;
 
@@ -6356,6 +6362,15 @@ static int __devinit ipr_probe_ioa(struc
 		goto cleanup_nomem;
 	}
 
+	/*
+	 * If HRRQ updated interrupt is not masked, or reset alert is set,
+	 * the card is in an unknown state and needs a hard reset
+	 */
+	mask = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+	uproc = readl(ioa_cfg->regs.sense_uproc_interrupt_reg);
+	if ((mask & IPR_PCII_HRRQ_UPDATED) == 0 || (uproc & IPR_UPROCI_RESET_ALERT))
+		ioa_cfg->needs_hard_reset = 1;
+
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	rc = request_irq(pdev->irq, ipr_isr, SA_SHIRQ, IPR_NAME, ioa_cfg);
 
diff -puN drivers/scsi/ipr.h~ipr_kexec_fix drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_kexec_fix	2005-11-17 09:29:23.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-17 09:29:23.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.1.0"
-#define IPR_DRIVER_DATE "(October 31, 2005)"
+#define IPR_DRIVER_VERSION "2.1.1"
+#define IPR_DRIVER_DATE "(November 15, 2005)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -922,6 +922,7 @@ struct ipr_ioa_cfg {
 	u8 dump_taken:1;
 	u8 allow_cmds:1;
 	u8 allow_ml_add_del:1;
+	u8 needs_hard_reset:1;
 
 	enum ipr_cache_state cache_state;
 	u16 type; /* CCIN of the card */
_
