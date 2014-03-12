From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH RESEND 5/7] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
Date: Wed, 12 Mar 2014 16:08:50 -0500
Message-ID: <20140312210906.467119132@vmlinux.vnet.ibm.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:17882 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752808AbaCLVML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:12:11 -0400
Content-Disposition: inline; filename=002_msix
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com, Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@linux.vnet.ibm.com>

From: Alexander Gordeev <agordeev@redhat.com>

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-03-11 17:18:06.709957199 -0500
+++ b/drivers/scsi/ipr.c	2014-03-11 17:18:20.169018184 -0500
@@ -9317,51 +9317,40 @@ static void ipr_wait_for_pci_err_recover
 static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct msix_entry entries[IPR_MAX_MSIX_VECTORS];
-	int i, err, vectors;
+	int i, vectors;
 
 	for (i = 0; i < ARRAY_SIZE(entries); ++i)
 		entries[i].entry = i;
 
-	vectors = ipr_number_of_msix;
-
-	while ((err = pci_enable_msix(ioa_cfg->pdev, entries, vectors)) > 0)
-			vectors = err;
-
-	if (err < 0) {
+	vectors = pci_enable_msix_range(ioa_cfg->pdev,
+					entries, 1, ipr_number_of_msix);
+	if (vectors < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		return err;
+		return vectors;
 	}
 
-	if (!err) {
-		for (i = 0; i < vectors; i++)
-			ioa_cfg->vectors_info[i].vec = entries[i].vector;
-		ioa_cfg->nvectors = vectors;
-	}
+	for (i = 0; i < vectors; i++)
+		ioa_cfg->vectors_info[i].vec = entries[i].vector;
+	ioa_cfg->nvectors = vectors;
 
-	return err;
+	return 0;
 }
 
 static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int i, err, vectors;
+	int i, vectors;
 
-	vectors = ipr_number_of_msix;
-
-	while ((err = pci_enable_msi_block(ioa_cfg->pdev, vectors)) > 0)
-			vectors = err;
-
-	if (err < 0) {
+	vectors = pci_enable_msi_range(ioa_cfg->pdev, 1, ipr_number_of_msix);
+	if (vectors < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		return err;
+		return vectors;
 	}
 
-	if (!err) {
-		for (i = 0; i < vectors; i++)
-			ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
-		ioa_cfg->nvectors = vectors;
-	}
+	for (i = 0; i < vectors; i++)
+		ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
+	ioa_cfg->nvectors = vectors;
 
-	return err;
+	return 0;
 }
 
 static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
@@ -9426,7 +9415,7 @@ static irqreturn_t ipr_test_intr(int irq
  * ipr_test_msi - Test for Message Signaled Interrupt (MSI) support.
  * @pdev:		PCI device struct
  *
- * Description: The return value from pci_enable_msi() can not always be
+ * Description: The return value from pci_enable_msi_range() can not always be
  * trusted.  This routine sets up and initiates a test interrupt to determine
  * if the interrupt is received via the ipr_test_intr() service routine.
  * If the tests fails, the driver will fall back to LSI.

-- 
