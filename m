From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/12] sata_nv: don't use block layer bounce buffers
Date: Mon, 16 Apr 2018 10:50:25 +0200
Message-ID: <20180416085032.7367-6-hch@lst.de>
References: <20180416085032.7367-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180416085032.7367-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

sata_nv sets the block bounce limit to the reduce dma mask for ATAPI
devices, which means that the iommu or swiotlb already take care of
the bounce buffering, and the block bouncing can be removed.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/ata/sata_nv.c | 62 +++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 8c683ddd0f58..b6e9ad6d33c9 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -740,32 +740,16 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 	sdev1 = ap->host->ports[1]->link.device[0].sdev;
 	if ((port0->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
 	    (port1->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
-		/** We have to set the DMA mask to 32-bit if either port is in
-		    ATAPI mode, since they are on the same PCI device which is
-		    used for DMA mapping. If we set the mask we also need to set
-		    the bounce limit on both ports to ensure that the block
-		    layer doesn't feed addresses that cause DMA mapping to
-		    choke. If either SCSI device is not allocated yet, it's OK
-		    since that port will discover its correct setting when it
-		    does get allocated.
-		    Note: Setting 32-bit mask should not fail. */
-		if (sdev0)
-			blk_queue_bounce_limit(sdev0->request_queue,
-					       ATA_DMA_MASK);
-		if (sdev1)
-			blk_queue_bounce_limit(sdev1->request_queue,
-					       ATA_DMA_MASK);
-
-		dma_set_mask(&pdev->dev, ATA_DMA_MASK);
+		/*
+		 * We have to set the DMA mask to 32-bit if either port is in
+		 * ATAPI mode, since they are on the same PCI device which is
+		 * used for DMA mapping.  If either SCSI device is not allocated
+		 * yet, it's OK since that port will discover its correct
+		 * setting when it does get allocated.
+		 */
+		rc = dma_set_mask(&pdev->dev, ATA_DMA_MASK);
 	} else {
-		/** This shouldn't fail as it was set to this value before */
-		dma_set_mask(&pdev->dev, pp->adma_dma_mask);
-		if (sdev0)
-			blk_queue_bounce_limit(sdev0->request_queue,
-					       pp->adma_dma_mask);
-		if (sdev1)
-			blk_queue_bounce_limit(sdev1->request_queue,
-					       pp->adma_dma_mask);
+		rc = dma_set_mask(&pdev->dev, pp->adma_dma_mask);
 	}
 
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
@@ -1131,12 +1115,11 @@ static int nv_adma_port_start(struct ata_port *ap)
 
 	VPRINTK("ENTER\n");
 
-	/* Ensure DMA mask is set to 32-bit before allocating legacy PRD and
-	   pad buffers */
-	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (rc)
-		return rc;
-	rc = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	/*
+	 * Ensure DMA mask is set to 32-bit before allocating legacy PRD and
+	 * pad buffers.
+	 */
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (rc)
 		return rc;
 
@@ -1156,13 +1139,16 @@ static int nv_adma_port_start(struct ata_port *ap)
 	pp->notifier_clear_block = pp->gen_block +
 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
 
-	/* Now that the legacy PRD and padding buffer are allocated we can
-	   safely raise the DMA mask to allocate the CPB/APRD table.
-	   These are allowed to fail since we store the value that ends up
-	   being used to set as the bounce limit in slave_config later if
-	   needed. */
-	dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+	/*
+	 * Now that the legacy PRD and padding buffer are allocated we can
+	 * try to raise the DMA mask to allocate the CPB/APRD table.
+	 */
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rc) {
+		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (rc)
+			return rc;
+	}
 	pp->adma_dma_mask = *dev->dma_mask;
 
 	mem = dmam_alloc_coherent(dev, NV_ADMA_PORT_PRIV_DMA_SZ,
-- 
2.17.0
