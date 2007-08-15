From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ppc sg chaining support fixes
Date: Thu, 16 Aug 2007 08:15:57 +0900
Message-ID: <20070816081557R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:39785 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbXHOXQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 19:16:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, paulus@samba.org

This is for the sglist branch in Jens' block git tree.

---
>From 445923d1a8ff272293af3aadb6e58f82e6439e98 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 16 Aug 2007 02:25:32 +0900
Subject: [PATCH] ppc sg chaining support fixes

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/kernel/iommu.c       |    5 +++--
 include/asm-powerpc/dma-mapping.h |   15 +++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index a146856..324bbc1 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -342,7 +342,8 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			if (novmerge || (dma_addr != dma_next)) {
 				/* Can't merge: create a new segment */
 				segstart = s;
-				outcount++; outs++;
+				outcount++;
+				outs = sg_next(outs);
 				DBG("    can't merge, new segment.\n");
 			} else {
 				outs->dma_length += s->length;
@@ -375,7 +376,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 	 * next entry of the sglist if we didn't fill the list completely
 	 */
 	if (outcount < incount) {
-		outs++;
+		outs = sg_next(outs);
 		outs->dma_address = DMA_ERROR_CODE;
 		outs->dma_length = 0;
 	}
diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 8e57c18..8ffc759 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -268,14 +268,15 @@ dma_map_page(struct device *dev, struct page *page,
 #define dma_unmap_page(dev, handle, size, dir)	((void)0)
 
 static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 	   enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(direction == DMA_NONE);
 
-	for (i = 0; i < nents; i++, sg++) {
+	for_each_sg(sgl, sg, nents, i) {
 		BUG_ON(!sg->page);
 		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
 		sg->dma_address = page_to_bus(sg->page) + sg->offset;
@@ -306,26 +307,28 @@ static inline void dma_sync_single_for_device(struct device *dev,
 }
 
 static inline void dma_sync_sg_for_cpu(struct device *dev,
-		struct scatterlist *sg, int nents,
+		struct scatterlist *sgl, int nents,
 		enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(direction == DMA_NONE);
 
-	for (i = 0; i < nents; i++, sg++)
+	for_each_sg(sgl, sg, nents, i)
 		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
 }
 
 static inline void dma_sync_sg_for_device(struct device *dev,
-		struct scatterlist *sg, int nents,
+		struct scatterlist *sgl, int nents,
 		enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(direction == DMA_NONE);
 
-	for (i = 0; i < nents; i++, sg++)
+	for_each_sg(sgl, sg, nents, i)
 		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
 }
 
-- 
1.5.2.4

