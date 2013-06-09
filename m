From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH 2/2] [SCSI] ufs: fix DMA mask setting
Date: Sun,  9 Jun 2013 20:19:59 +0900
Message-ID: <1370776799-12373-2-git-send-email-mita@fixstars.com>
References: <1370776799-12373-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:33484 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3FILYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jun 2013 07:24:04 -0400
In-Reply-To: <1370776799-12373-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

If the controller doesn't support 64-bit addressing mode, it must not
set the DMA mask to 64-bit.  But it's unconditionally trying to set to
64-bit without checking 64-bit addressing support in the controller
capabilities.

It was correctly checked before commit 3b1d05807a9a68c6d0580e9248247a774a4d3be6
("[SCSI] ufs: Segregate PCI Specific Code"), this aims to restores
the correct behaviour.

To achieve this in a generic way, firstly we should push down the DMA
mask setting routine ufshcd_set_dma_mask() from PCI glue driver to core
driver in order to do it for both PCI glue driver and Platform glue
driver.  Secondly, we should change pci_ DMA mapping API to dma_ DMA
mapping API because core driver is independent of glue drivers.

Lastly, we need to relax dma_set_mask(dev, DMA_BIT_MASK(32)) error check
for platform devices on ARM, which do not have a valid dma_mask pointer.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pci.c | 26 --------------------------
 drivers/scsi/ufs/ufshcd.c     | 25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5cb1d75..6835520 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -101,26 +101,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 }
 
 /**
- * ufshcd_set_dma_mask - Set dma mask based on the controller
- *			 addressing capability
- * @pdev: PCI device structure
- *
- * Returns 0 for success, non-zero for failure
- */
-static int ufshcd_set_dma_mask(struct pci_dev *pdev)
-{
-	int err;
-
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
-		&& !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
-		return 0;
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-	return err;
-}
-
-/**
  * ufshcd_pci_probe - probe routine of the driver
  * @pdev: pointer to PCI device handle
  * @id: PCI device id
@@ -156,12 +136,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_release_regions;
 	}
 
-	err = ufshcd_set_dma_mask(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
-	}
-
 	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 492f2b7..7f5399c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1598,6 +1598,25 @@ void ufshcd_remove(struct ufs_hba *hba)
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
 /**
+ * ufshcd_set_dma_mask - Set dma mask based on the controller
+ *			 addressing capability
+ * @hba: per adapter instance
+ *
+ * Returns 0 for success, non-zero for failure
+ */
+static int ufshcd_set_dma_mask(struct ufs_hba *hba)
+{
+	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
+		if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64)) &&
+		    !dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64)))
+			return 0;
+	}
+	dma_set_mask(hba->dev, DMA_BIT_MASK(32));
+
+	return dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
+}
+
+/**
  * ufshcd_init - Driver initialization routine
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
@@ -1645,6 +1664,12 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	/* Get UFS version supported by the controller */
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
 
+	err = ufshcd_set_dma_mask(hba);
+	if (err) {
+		dev_err(hba->dev, "set dma mask failed\n");
+		goto out_disable;
+	}
+
 	/* Allocate memory for host memory space */
 	err = ufshcd_memory_alloc(hba);
 	if (err) {
-- 
1.8.1.4

