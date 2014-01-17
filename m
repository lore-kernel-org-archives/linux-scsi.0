From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
Date: Fri, 17 Jan 2014 17:02:18 +0100
Message-ID: <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

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
