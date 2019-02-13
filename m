From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] hptiop: fix calls to dma_set_mask_and_coherent()
Date: Wed, 13 Feb 2019 12:42:32 +0100
Message-ID: <20190213114234.67275-3-hare@suse.de>
References: <20190213114234.67275-1-hare@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213114234.67275-1-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

The change to use dma_set_mask_and_coherent() incorrectly made a second
call with the 32 bit DMA mask value when the call with the 64 bit DMA
mask value succeeded.  This resulted in NVMe/FC connections failing due
to corrupted data buffers, and various other SCSI/FCP I/O errors.

Fixes: 453cd3700ca3 ("scsi: hptiop: use dma_set_mask")
Cc: <stable@vger.kernel.org>
Suggested-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hptiop.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 3eedfd4f8f57..251c084a6ff0 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1292,6 +1292,7 @@ static int hptiop_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 	dma_addr_t start_phy;
 	void *start_virt;
 	u32 offset, i, req_size;
+	int rc;
 
 	dprintk("hptiop_probe(%p)\n", pcidev);
 
@@ -1308,9 +1309,12 @@ static int hptiop_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 
 	/* Enable 64bit DMA if possible */
 	iop_ops = (struct hptiop_adapter_ops *)id->driver_data;
-	if (dma_set_mask(&pcidev->dev,
-			 DMA_BIT_MASK(iop_ops->hw_dma_bit_mask)) ||
-	    dma_set_mask(&pcidev->dev, DMA_BIT_MASK(32))) {
+	rc = dma_set_mask(&pcidev->dev,
+			  DMA_BIT_MASK(iop_ops->hw_dma_bit_mask));
+	if (rc)
+		rc = dma_set_mask(&pcidev->dev, DMA_BIT_MASK(32));
+
+	if (rc) {
 		printk(KERN_ERR "hptiop: fail to set dma_mask\n");
 		goto disable_pci_device;
 	}
-- 
2.16.4
