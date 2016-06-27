From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Clear interrupt on croc/crocodile when running with LSI
Date: Mon, 27 Jun 2016 09:09:40 -0500
Message-ID: <20160627140941.BC090AE04B@b01ledav005.gho.pok.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org, benh@kernel.crashing.org
List-Id: linux-scsi@vger.kernel.org


If we fall back to using LSI on the Croc or Crocodile chip we need
to clear the interrupt so we don't hang the system.

Cc: stable<stable@vger.kernel.org>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_clear_isr drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_clear_isr	2016-06-24 17:37:24.265197867 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-06-24 17:38:39.640943642 -0500
@@ -10097,6 +10097,7 @@ static int ipr_probe_ioa(struct pci_dev
 		ioa_cfg->intr_flag = IPR_USE_MSI;
 	else {
 		ioa_cfg->intr_flag = IPR_USE_LSI;
+		ioa_cfg->clear_isr = 1;
 		ioa_cfg->nvectors = 1;
 		dev_info(&pdev->dev, "Cannot enable MSI.\n");
 	}
_
