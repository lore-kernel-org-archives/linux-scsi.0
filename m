From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/8] 3w-sas: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 08:34:21 +0100
Message-ID: <20190218073426.111853-4-hare@suse.de>
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

Fixes: b1fa122930c4 ("scsi: 3w-sas: fully convert to the generic DMA API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/3w-sas.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index e8f5f7c63190..2d15b878bd94 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1572,8 +1572,10 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x18, "Failed to set dma mask");
 		retval = -ENODEV;
 		goto out_disable_device;
@@ -1804,8 +1806,10 @@ static int twl_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (retval)
+		retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x25, "Failed to set dma mask during resume");
 		retval = -ENODEV;
 		goto out_disable_device;
-- 
2.16.4
