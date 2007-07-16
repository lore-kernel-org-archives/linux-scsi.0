From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/33] PPC: sg chaining support
Date: Mon, 16 Jul 2007 11:47:26 +0200
Message-ID: <1184579268981-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9307 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbXGPJsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:36 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, paulus@samba.org

This updates the ppc iommu/pci dma mappers to sg chaining.

Cc: paulus@samba.org
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/powerpc/kernel/dma_64.c            |    5 +++--
 arch/powerpc/kernel/ibmebus.c           |   11 ++++++-----
 arch/powerpc/kernel/iommu.c             |   18 +++++++++++-------
 arch/powerpc/platforms/ps3/system-bus.c |    5 +++--
 include/asm-powerpc/dma-mapping.h       |    2 +-
 include/asm-powerpc/scatterlist.h       |    2 ++
 6 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kernel/dma_64.c b/arch/powerpc/kernel/dma_64.c
index 7b0e754..9001104 100644
--- a/arch/powerpc/kernel/dma_64.c
+++ b/arch/powerpc/kernel/dma_64.c
@@ -154,12 +154,13 @@ static void dma_direct_unmap_single(struct device *dev, dma_addr_t dma_addr,
 {
 }
 
-static int dma_direct_map_sg(struct device *dev, struct scatterlist *sg,
+static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 			     int nents, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < nents; i++, sg++) {
+	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = (page_to_phys(sg->page) + sg->offset) |
 			dma_direct_offset;
 		sg->dma_length = sg->length;
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 9a8c9af..3131c61 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -87,15 +87,16 @@ static void ibmebus_unmap_single(struct device *dev,
 }
 
 static int ibmebus_map_sg(struct device *dev,
-			  struct scatterlist *sg,
+			  struct scatterlist *sgl,
 			  int nents, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < nents; i++) {
-		sg[i].dma_address = (dma_addr_t)page_address(sg[i].page)
-			+ sg[i].offset;
-		sg[i].dma_length = sg[i].length;
+	for_each_sg(sgl, sg, nents, i) {
+		sg->dma_address = (dma_addr_t)page_address(sg->page)
+			+ sg->offset;
+		sg->dma_length = sg->length;
 	}
 
 	return nents;
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c08ceca..a146856 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -278,7 +278,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned long flags;
 	struct scatterlist *s, *outs, *segstart;
-	int outcount, incount;
+	int outcount, incount, i;
 	unsigned long handle;
 
 	BUG_ON(direction == DMA_NONE);
@@ -298,7 +298,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
-	for (s = outs; nelems; nelems--, s++) {
+	for_each_sg(sglist, s, nelems, i) {
 		unsigned long vaddr, npages, entry, slen;
 
 		slen = s->length;
@@ -386,7 +386,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 	return outcount;
 
  failure:
-	for (s = &sglist[0]; s <= outs; s++) {
+	for_each_sg(sglist, s, nelems, i) {
 		if (s->dma_length != 0) {
 			unsigned long vaddr, npages;
 
@@ -396,6 +396,8 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			s->dma_address = DMA_ERROR_CODE;
 			s->dma_length = 0;
 		}
+		if (s == outs)
+			break;
 	}
 	spin_unlock_irqrestore(&(tbl->it_lock), flags);
 	return 0;
@@ -405,6 +407,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 		int nelems, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	unsigned long flags;
 
 	BUG_ON(direction == DMA_NONE);
@@ -414,15 +417,16 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
+	sg = sglist;
 	while (nelems--) {
 		unsigned int npages;
-		dma_addr_t dma_handle = sglist->dma_address;
+		dma_addr_t dma_handle = sg->dma_address;
 
-		if (sglist->dma_length == 0)
+		if (sg->dma_length == 0)
 			break;
-		npages = iommu_num_pages(dma_handle,sglist->dma_length);
+		npages = iommu_num_pages(dma_handle, sg->dma_length);
 		__iommu_free(tbl, dma_handle, npages);
-		sglist++;
+		sg = sg_next(sg);
 	}
 
 	/* Flush/invalidate TLBs if necessary. As for iommu_free(), we
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 6bda510..22aedb6 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -271,7 +271,7 @@ static void ps3_unmap_single(struct device *_dev, dma_addr_t dma_addr,
 	}
 }
 
-static int ps3_map_sg(struct device *_dev, struct scatterlist *sg, int nents,
+static int ps3_map_sg(struct device *_dev, struct scatterlist *sgl, int nents,
 	enum dma_data_direction direction)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
@@ -279,9 +279,10 @@ static int ps3_map_sg(struct device *_dev, struct scatterlist *sg, int nents,
 	return -EPERM;
 #else
 	struct ps3_system_bus_device *dev = to_ps3_system_bus_device(_dev);
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < nents; i++, sg++) {
+	for_each_sg(sgl, sg, nents, i) {
 		int result = ps3_dma_map(dev->d_region,
 			page_to_phys(sg->page) + sg->offset, sg->length,
 			&sg->dma_address);
diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index f6bd804..b712774 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -12,7 +12,7 @@
 #include <linux/cache.h>
 /* need struct page definitions */
 #include <linux/mm.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
diff --git a/include/asm-powerpc/scatterlist.h b/include/asm-powerpc/scatterlist.h
index 8c992d1..b075f61 100644
--- a/include/asm-powerpc/scatterlist.h
+++ b/include/asm-powerpc/scatterlist.h
@@ -41,5 +41,7 @@ struct scatterlist {
 #define ISA_DMA_THRESHOLD	(~0UL)
 #endif
 
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_SCATTERLIST_H */
-- 
1.5.3.rc0.90.gbaa79

