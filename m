From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/8] 3w-sas: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 08:34:22 +0100
Message-ID: <20190218073426.111853-5-hare@suse.de>
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

Fixes: 3a21986f1a59 ("scsi: aic94xx: fully convert to the generic DMA API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index f83f79b07b50..d41f645e8454 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -769,9 +769,11 @@ static int asd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (err)
 		goto Err_remove;
 
-	err = -ENODEV;
-	if (dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32))) {
+	err = dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(64));
+	if (err)
+		err = dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
+	if (err) {
+		err = -ENODEV;
 		asd_printk("no suitable DMA mask for %s\n", pci_name(dev));
 		goto Err_remove;
 	}
-- 
2.16.4
