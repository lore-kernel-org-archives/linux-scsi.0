From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: lpfc: fix calls to dma_set_mask_and_coherent()
Date: Mon, 11 Feb 2019 10:05:02 -0500
Message-ID: <20190211150502.9999-1-emilne@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: stable@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com, martin.petersen@oracle.com, jejb@linux.ibm.com
List-Id: linux-scsi@vger.kernel.org

The change to use dma_set_mask_and_coherent() incorrectly made a second
call with the 32 bit DMA mask value when the call with the 64 bit DMA
mask value succeeded.  This resulted in NVMe/FC connections failing due
to corrupted data buffers, and various other SCSI/FCP I/O errors.

Fixes: f30e1bfd6154 ("scsi: lpfc: use dma_set_mask_and_coherent")
Cc: <stable@vger.kernel.org>
Suggested-by: Don Dutile <ddutile@redhat.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index bede11e..60c178d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7367,9 +7367,9 @@ struct lpfc_rpi_hdr *
 		return error;
 
 	/* Set the device DMA mask size */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
-		return error;
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0)
+		if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0)
+			return error;
 
 	/* Get the bus address of Bar0 and Bar2 and the number of bytes
 	 * required by each mapping.
@@ -9745,9 +9745,9 @@ struct lpfc_cq_event *
 		return error;
 
 	/* Set the device DMA mask size */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) ||
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
-		return error;
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0)
+		if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0)
+			return error;
 
 	/*
 	 * The BARs and register set definitions and offset locations are
-- 
1.8.3.1
