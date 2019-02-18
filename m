From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/8] 3w-9xxx: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 08:34:20 +0100
Message-ID: <20190218073426.111853-3-hare@suse.de>
References: <20190218073426.111853-1-hare@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190218073426.111853-1-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

The change to use dma_set_mask_and_coherent() incorrectly made a second
call with the 32 bit DMA mask value when the call with the 64 bit DMA
mask value succeeded.

Fixes: b000bced5739 ("scsi: 3w-9xxx: fully convert to the generic DMA API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/3w-9xxx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a3c20e3a8b7c..3337b1e80412 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2009,7 +2009,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
 	unsigned long mem_addr, mem_len;
-	int retval = -ENODEV;
+	int retval;
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
@@ -2020,8 +2020,10 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
 		retval = -ENODEV;
 		goto out_disable_device;
@@ -2240,8 +2242,10 @@ static int twa_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x40, "Failed to set dma mask during resume");
 		retval = -ENODEV;
 		goto out_disable_device;
-- 
2.16.4
