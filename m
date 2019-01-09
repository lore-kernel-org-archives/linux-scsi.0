From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Subject: [PATCH] scsi: qla1280: set 64bit coherent mask
Date: Wed,  9 Jan 2019 15:09:02 +0100
Message-ID: <20190109140902.21638-1-tbogendoerfer@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After Commit 54aed4dd3526 ("MIPS: IP27: use dma_direct_ops") qla1280 driver
failed on SGI IP27 machines with

qla1280: QLA1040 found on PCI bus 0, dev 0
qla1280 0000:00:00.0: enabling device (0006 -> 0007)
qla1280: Failed to get request memory
qla1280: probe of 0000:00:00.0 failed with error -12

Reason is that SGI IP27 always generates 64bit DMA addresses and has
no fallback mode for 32bit DMA addresses implemented. QLA1280
supports 64bit addressing for all DMA accesses so setting coherent mask
to 64bit fixes the issue.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index a414f51302b7..6856dfdfa473 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4248,7 +4248,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(64))) {
+	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
 		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
-- 
2.13.7
