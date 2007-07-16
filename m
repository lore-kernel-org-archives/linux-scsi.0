From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/33] swiotlb: sg chaining support
Date: Mon, 16 Jul 2007 11:47:22 +0200
Message-ID: <11845792683072-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9298 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759402AbXGPJsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:36 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, ak@suse.de

Cc: ak@suse.de
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 lib/swiotlb.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 10c13ad..1f658e4 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -673,16 +673,17 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
  * same here.
  */
 int
-swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nelems,
+swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	       int dir)
 {
+	struct scatterlist *sg;
 	void *addr;
 	dma_addr_t dev_addr;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
-	for (i = 0; i < nelems; i++, sg++) {
+	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		dev_addr = virt_to_bus(addr);
 		if (swiotlb_force || address_needs_mapping(hwdev, dev_addr)) {
@@ -692,7 +693,7 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nelems,
 				   to do proper error handling. */
 				swiotlb_full(hwdev, sg->length, dir, 0);
 				swiotlb_unmap_sg(hwdev, sg - i, i, dir);
-				sg[0].dma_length = 0;
+				sgl[0].dma_length = 0;
 				return 0;
 			}
 			sg->dma_address = virt_to_bus(map);
@@ -708,19 +709,21 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nelems,
  * concerning calls here are the same as for swiotlb_unmap_single() above.
  */
 void
-swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nelems,
+swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		 int dir)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
-	for (i = 0; i < nelems; i++, sg++)
+	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
 			unmap_single(hwdev, bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+	}
 }
 
 /*
@@ -731,19 +734,21 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nelems,
  * and usage.
  */
 static void
-swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sg,
+swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 		int nelems, int dir, int target)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
-	for (i = 0; i < nelems; i++, sg++)
+	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
 			sync_single(hwdev, bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+	}
 }
 
 void
-- 
1.5.3.rc0.90.gbaa79

