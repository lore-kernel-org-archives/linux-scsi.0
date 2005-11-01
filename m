From: brking@us.ibm.com
Subject: [PATCH 16/26] ipr: Runtime reset
Date: Tue, 01 Nov 2005 17:01:54 -0600
Message-ID: <200511012301.jA1N1tVJ024175@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:7900 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751412AbVKAXB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:01:56 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1urV026097
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:56 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N1ubn107942
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:56 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1tNo024191
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Some IPR RAID adapter will automatically create single device RAID arrays
for all attached devices when the card is initialized. Setting the
RUNTIME_RESET doorbell bit will prevent this from occurring, since we
only want this behavior the first time the card is initialized and not
each time the card happens to get reset.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    4 +++-
 linux-2.6-bjking1/drivers/scsi/ipr.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_runtime_reset drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_runtime_reset	2005-11-01 16:08:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-01 16:08:05.000000000 -0600
@@ -192,6 +192,7 @@
 #define IPR_SDT_FMT2_EXP_ROM_SEL			0x8
 #define IPR_FMT2_SDT_READY_TO_USE			0xC4D4E3F2
 #define IPR_DOORBELL					0x82800000
+#define IPR_RUNTIME_RESET				0x40000000
 
 #define IPR_PCII_IOA_TRANS_TO_OPER			(0x80000000 >> 0)
 #define IPR_PCII_IOARCB_XFER_FAILED			(0x80000000 >> 3)
@@ -913,6 +914,7 @@ struct ipr_ioa_cfg {
 	u16 reset_retries;
 
 	u32 errors_logged;
+	u32 doorbell;
 
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
diff -puN drivers/scsi/ipr.c~ipr_runtime_reset drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_runtime_reset	2005-11-01 16:08:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-01 16:08:05.000000000 -0600
@@ -4281,6 +4281,7 @@ static int ipr_ioa_reset_done(struct ipr
 	ioa_cfg->in_reset_reload = 0;
 	ioa_cfg->allow_cmds = 1;
 	ioa_cfg->reset_cmd = NULL;
+	ioa_cfg->doorbell |= IPR_RUNTIME_RESET;
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 		if (ioa_cfg->allow_ml_add_del && (res->add_to_ml || res->del_from_ml)) {
@@ -5101,7 +5102,7 @@ static int ipr_reset_enable_ioa(struct i
 	}
 
 	/* Enable destructive diagnostics on IOA */
-	writel(IPR_DOORBELL, ioa_cfg->regs.set_uproc_interrupt_reg);
+	writel(ioa_cfg->doorbell, ioa_cfg->regs.set_uproc_interrupt_reg);
 
 	writel(IPR_PCII_OPER_INTERRUPTS, ioa_cfg->regs.clr_interrupt_mask_reg);
 	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
@@ -5917,6 +5918,7 @@ static void __devinit ipr_init_ioa_cfg(s
 	ioa_cfg->host = host;
 	ioa_cfg->pdev = pdev;
 	ioa_cfg->log_level = ipr_log_level;
+	ioa_cfg->doorbell = IPR_DOORBELL;
 	sprintf(ioa_cfg->eye_catcher, IPR_EYECATCHER);
 	sprintf(ioa_cfg->trace_start, IPR_TRACE_START_LABEL);
 	sprintf(ioa_cfg->ipr_free_label, IPR_FREEQ_LABEL);
_
