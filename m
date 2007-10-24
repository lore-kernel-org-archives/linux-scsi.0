From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 04/11] ppc: make iommu respect the segment size limits
Date: Wed, 24 Oct 2007 19:48:13 +0900
Message-ID: <20071024171642A.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59507 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbXJXKxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:53:24 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, paulus@samba.org, fujita.tomonori@lab.ntt.co.jp

This patch makes iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/kernel/dma_64.c |    2 +-
 arch/powerpc/kernel/iommu.c  |    8 ++++++--
 include/asm-powerpc/iommu.h  |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/dma_64.c b/arch/powerpc/kernel/dma_64.c
index 14206e3..1806d96 100644
--- a/arch/powerpc/kernel/dma_64.c
+++ b/arch/powerpc/kernel/dma_64.c
@@ -68,7 +68,7 @@ static void dma_iommu_unmap_single(struct device *dev, dma_addr_t dma_handle,
 static int dma_iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction)
 {
-	return iommu_map_sg(dev->archdata.dma_data, sglist, nelems,
+	return iommu_map_sg(dev, sglist, nelems,
 			    device_to_mask(dev), direction);
 }
 
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 2d0c9ef..7a5d247 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -270,15 +270,17 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	spin_unlock_irqrestore(&(tbl->it_lock), flags);
 }
 
-int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
+int iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 		 int nelems, unsigned long mask,
 		 enum dma_data_direction direction)
 {
+	struct iommu_table *tbl = dev->archdata.dma_data;
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned long flags;
 	struct scatterlist *s, *outs, *segstart;
 	int outcount, incount, i;
 	unsigned long handle;
+	unsigned int max_seg_size;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -297,6 +299,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
+	max_seg_size = dma_get_max_seg_size(dev);
 	for_each_sg(sglist, s, nelems, i) {
 		unsigned long vaddr, npages, entry, slen;
 
@@ -338,7 +341,8 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			/* We cannot merge if:
 			 * - allocated dma_addr isn't contiguous to previous allocation
 			 */
-			if (novmerge || (dma_addr != dma_next)) {
+			if (novmerge || (dma_addr != dma_next) ||
+			    (outs->dma_length + s->length > max_seg_size)) {
 				/* Can't merge: create a new segment */
 				segstart = s;
 				outcount++;
diff --git a/include/asm-powerpc/iommu.h b/include/asm-powerpc/iommu.h
index 4a82fdc..5225f05 100644
--- a/include/asm-powerpc/iommu.h
+++ b/include/asm-powerpc/iommu.h
@@ -80,7 +80,7 @@ extern void iommu_free_table(struct device_node *dn);
 extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 					    int nid);
 
-extern int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
+extern int iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 			int nelems, unsigned long mask,
 			enum dma_data_direction direction);
 extern void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
-- 
1.5.2.4

