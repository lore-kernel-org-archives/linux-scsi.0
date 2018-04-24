From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/5] scsi: reduce use of block bounce buffers
Date: Tue, 24 Apr 2018 20:16:21 +0200
Message-ID: <20180424181625.22410-2-hch@lst.de>
References: <20180424181625.22410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180424181625.22410-1-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

We can rely on the dma-mapping code to handle any DMA limits that is
bigger than the ISA DMA mask for us (either using an iommu or swiotlb),
so remove setting the block layer bounce limit for anything but the
unchecked_isa_dma case, or the bouncing for highmem pages.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/scsi/scsi_lib.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9b4f279d29c..e0b614c0b1e6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2149,27 +2149,6 @@ static int scsi_map_queues(struct blk_mq_tag_set *set)
 	return blk_mq_map_queues(set);
 }
 
-static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
-{
-	struct device *host_dev;
-	u64 bounce_limit = 0xffffffff;
-
-	if (shost->unchecked_isa_dma)
-		return BLK_BOUNCE_ISA;
-	/*
-	 * Platforms with virtual-DMA translation
-	 * hardware have no practical limit.
-	 */
-	if (!PCI_DMA_BUS_IS_PHYS)
-		return BLK_BOUNCE_ANY;
-
-	host_dev = scsi_get_device(shost);
-	if (host_dev && host_dev->dma_mask)
-		bounce_limit = (u64)dma_max_pfn(host_dev) << PAGE_SHIFT;
-
-	return bounce_limit;
-}
-
 void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
@@ -2189,7 +2168,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	}
 
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
-	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
+	if (shost->unchecked_isa_dma)
+		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
-- 
2.17.0
