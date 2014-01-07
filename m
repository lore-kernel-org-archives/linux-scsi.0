From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 2/7] ipr: Use new interfaces for MSI/MSI-X enablement
Date: Tue,  7 Jan 2014 19:05:37 +0100
Message-ID: <8601f823c9e71fbe65a5612dd83d079d93991025.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1389103215.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/ipr.c |   47 ++++++++++++++++++-----------------------------
 1 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fb57e21..3841298 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9245,47 +9245,36 @@ ipr_get_chip_info(const struct pci_device_id *dev_id)
 static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct msix_entry entries[IPR_MAX_MSIX_VECTORS];
-	int i, err, vectors;
+	int i, vectors;
 
 	for (i = 0; i < ARRAY_SIZE(entries); ++i)
 		entries[i].entry = i;
 
-	vectors = ipr_number_of_msix;
+	vectors = pci_enable_msix_range(ioa_cfg->pdev, entries,
+					1, ipr_number_of_msix);
+	if (vectors < 0)
+		return vectors;
 
-	while ((err = pci_enable_msix(ioa_cfg->pdev, entries, vectors)) > 0)
-			vectors = err;
+	for (i = 0; i < vectors; i++)
+		ioa_cfg->vectors_info[i].vec = entries[i].vector;
+	ioa_cfg->nvectors = vectors;
 
-	if (err < 0)
-		return err;
-
-	if (!err) {
-		for (i = 0; i < vectors; i++)
-			ioa_cfg->vectors_info[i].vec = entries[i].vector;
-		ioa_cfg->nvectors = vectors;
-	}
-
-	return err;
+	return 0;
 }
 
 static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int i, err, vectors;
+	int i, vectors;
 
-	vectors = ipr_number_of_msix;
+	vectors = pci_enable_msi_range(ioa_cfg->pdev, 1, ipr_number_of_msix);
+	if (vectors < 0)
+		return vectors;
 
-	while ((err = pci_enable_msi_block(ioa_cfg->pdev, vectors)) > 0)
-			vectors = err;
+	for (i = 0; i < vectors; i++)
+		ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
+	ioa_cfg->nvectors = vectors;
 
-	if (err < 0)
-		return err;
-
-	if (!err) {
-		for (i = 0; i < vectors; i++)
-			ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
-		ioa_cfg->nvectors = vectors;
-	}
-
-	return err;
+	return 0;
 }
 
 static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
@@ -9350,7 +9339,7 @@ static irqreturn_t ipr_test_intr(int irq, void *devp)
  * ipr_test_msi - Test for Message Signaled Interrupt (MSI) support.
  * @pdev:		PCI device struct
  *
- * Description: The return value from pci_enable_msi() can not always be
+ * Description: The return value from pci_enable_msi_range() can not always be
  * trusted.  This routine sets up and initiates a test interrupt to determine
  * if the interrupt is received via the ipr_test_intr() service routine.
  * If the tests fails, the driver will fall back to LSI.
-- 
1.7.7.6
