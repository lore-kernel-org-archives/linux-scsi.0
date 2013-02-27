From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: ipr_test_msi() fails when running with msi-x enabled adapter
Date: Wed, 27 Feb 2013 12:37:45 -0600
Message-ID: <20130227184347.437115470@linux.vnet.ibm.com>
References: <20130227183744.430469620@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:21599 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1759862Ab3B0SqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2013 13:46:12 -0500
Content-Disposition: inline; filename=test_msi_fail
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Loading ipr modules failed(-22) with msi-x enabled adapter. In ipr_test_msi(),
We need to pass the first vector of msix vectors instead of using pdev->irq 
to request_irq() when adapter enables msix feature.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-02-26 20:13:42.000000000 -0600
+++ b/drivers/scsi/ipr.c	2013-02-27 12:02:32.578032480 -0600
@@ -9349,7 +9349,10 @@ static int ipr_test_msi(struct ipr_ioa_c
 	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
+	if (ioa_cfg->intr_flag == IPR_USE_MSIX)
+		rc = request_irq(ioa_cfg->vectors_info[0].vec, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
+	else
+		rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
 	if (rc) {
 		dev_err(&pdev->dev, "Can not assign irq %d\n", pdev->irq);
 		return rc;
@@ -9371,7 +9374,10 @@ static int ipr_test_msi(struct ipr_ioa_c
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	free_irq(pdev->irq, ioa_cfg);
+	if (ioa_cfg->intr_flag == IPR_USE_MSIX)
+		free_irq(ioa_cfg->vectors_info[0].vec, ioa_cfg);
+	else
+		free_irq(pdev->irq, ioa_cfg);
 
 	LEAVE;
 

-- 
