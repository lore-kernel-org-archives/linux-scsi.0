From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] csiostor: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 08:34:24 +0100
Message-ID: <20190218073426.111853-7-hare@suse.de>
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

Fixes: c22b332d811b ("scsi: csiostor: switch to generic DMA API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/csiostor/csio_init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 460e4ee1c8fe..a6dd704d7f2d 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -206,8 +206,11 @@ csio_pci_init(struct pci_dev *pdev, int *bars)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	rv = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rv)
+		rv = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (rv) {
+		rv = -ENODEV;
 		dev_err(&pdev->dev, "No suitable DMA available.\n");
 		goto err_release_regions;
 	}
-- 
2.16.4
