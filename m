From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/8] lpfc: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 08:34:19 +0100
Message-ID: <20190218073426.111853-2-hare@suse.de>
References: <20190218073426.111853-1-hare@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190218073426.111853-1-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

The change to use dma_set_mask_and_coherent() incorrectly made a second
call with the 32 bit DMA mask value when the call with the 64 bit DMA
mask value succeeded.  This resulted in NVMe/FC connections failing due
to corrupted data buffers, and various other SCSI/FCP I/O errors.

Fixes: f30e1bfd6154 ("scsi: lpfc: use dma_set_mask_and_coherent")
Cc: <stable@vger.kernel.org>
Suggested-by: Don Dutile <ddutile@redhat.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index eef6b929c327..59b098cb5787 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7693,15 +7693,18 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	unsigned long bar0map_len, bar2map_len;
 	int i, hbq_count;
 	void *ptr;
-	int error = -ENODEV;
+	int error;
 
 	if (!pdev)
-		return error;
+		return -ENODEV;
 
 	/* Set the device DMA mask size */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (error)
+		error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (error)
 		return error;
+	error = -ENODEV;
 
 	/* Get the bus address of Bar0 and Bar2 and the number of bytes
 	 * required by each mapping.
@@ -10053,11 +10056,13 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 	uint32_t if_type;
 
 	if (!pdev)
-		return error;
+		return -ENODEV;
 
 	/* Set the device DMA mask size */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (error)
+		error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (error)
 		return error;
 
 	/*
-- 
2.16.4
