From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 2/2] ipr: Use pci_enable_msi_range() and
 pci_enable_msix_range()
Date: Thu, 30 Jan 2014 15:10:32 +0100
Message-ID: <20140130141031.GC32349@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
 <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
 <52E7CCAD.5070008@linux.vnet.ibm.com>
 <20140129132651.GA27764@dhcp-26-207.brq.redhat.com>
 <20140130140630.GA32349@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140130140630.GA32349@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
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
index 48d0cfc..70f40ca 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9317,51 +9317,40 @@ static void ipr_wait_for_pci_err_recovery(struct ipr_ioa_cfg *ioa_cfg)
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
@@ -9426,7 +9415,7 @@ static irqreturn_t ipr_test_intr(int irq, void *devp)
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

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
