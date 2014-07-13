From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH resend] ufs: fix DMA mask setting
Date: Sun, 13 Jul 2014 09:44:31 +0900
Message-ID: <1405212271-4037-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48760 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaGMAoq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jul 2014 20:44:46 -0400
Received: by mail-pa0-f50.google.com with SMTP id bj1so3462219pad.9
        for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 17:44:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

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

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
This patch previously required a additional change which initializes
dev->dma_mask for device-tree probed device.  But it is not required
anymore, because of the commit 0589342c27944e50ebd7a54f5215002b6598b748
("of: set dma_mask to point to coherent_dma_mask").

 drivers/scsi/ufs/ufshcd-pci.c | 26 --------------------------
 drivers/scsi/ufs/ufshcd.c     | 30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 8b95312..c007a7a 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -135,26 +135,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
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
@@ -184,12 +164,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mmio_base = pcim_iomap_table(pdev)[0];
 
-	err = ufshcd_set_dma_mask(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		return err;
-	}
-
 	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c28772..1c4c226 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3110,6 +3110,30 @@ void ufshcd_remove(struct ufs_hba *hba)
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
+	int err;
+
+	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
+		if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64))) {
+			dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64));
+			return 0;
+		}
+	}
+	err = dma_set_mask(hba->dev, DMA_BIT_MASK(32));
+	if (!err)
+		dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
+
+	return err;
+}
+
+/**
  * ufshcd_init - Driver initialization routine
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
@@ -3160,6 +3184,12 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	/* Get Interrupt bit mask per version */
 	hba->intr_mask = ufshcd_get_intr_mask(hba);
 
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
1.9.1

