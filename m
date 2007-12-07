From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 5/6] x86: convert gart IOMMU to use the IOMMU helper
Date: Fri, 7 Dec 2007 23:56:43 +0900
Message-ID: <20071207235723P.tomof@acm.org>
References: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50247 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbXLGO5i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 09:57:38 -0500
In-Reply-To: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp

This patch converts gart IOMMU to use the IOMMU helper functions. The
IOMMU doesn't allocate a memory area spanning LLD's segment boundary
anymore.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/Kconfig              |    2 +-
 arch/x86/kernel/pci-gart_64.c |   41 +++++++++++++++++++++++++----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df22fe7..34519c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -434,7 +434,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  If unsure, say Y.
 
 config IOMMU_HELPER
-	def_bool CALGARY_IOMMU
+	def_bool (CALGARY_IOMMU || GART_IOMMU)
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index b8595d6..d0b9033 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -25,6 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -82,17 +83,24 @@ AGPEXTERN __u32 *agp_gatt_table;
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
 static int need_flush;		/* global flush state. set for each gart wrap */
 
-static unsigned long alloc_iommu(int size)
+static unsigned long alloc_iommu(struct device *dev, int size)
 {
 	unsigned long offset, flags;
+	unsigned long boundary_size;
+	unsigned long base_index;
+
+	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
+			   PAGE_SIZE) >> PAGE_SHIFT;
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-	offset = find_next_zero_string(iommu_gart_bitmap, next_bit,
-					iommu_pages, size);
+	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
+				  size, base_index, boundary_size, 0);
 	if (offset == -1) {
 		need_flush = 1;
-		offset = find_next_zero_string(iommu_gart_bitmap, 0,
-						iommu_pages, size);
+		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
+					  size, base_index, boundary_size, 0);
 	}
 	if (offset != -1) {
 		set_bit_string(iommu_gart_bitmap, offset, size);
@@ -114,7 +122,7 @@ static void free_iommu(unsigned long offset, int size)
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-	__clear_bit_string(iommu_gart_bitmap, offset, size);
+	iommu_area_free(iommu_gart_bitmap, offset, size);
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 }
 
@@ -235,7 +243,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir)
 {
 	unsigned long npages = to_pages(phys_mem, size);
-	unsigned long iommu_page = alloc_iommu(npages);
+	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
 	if (iommu_page == -1) {
@@ -355,10 +363,11 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 }
 
 /* Map multiple scatterlist entries continuous into the first. */
-static int __dma_map_cont(struct scatterlist *start, int nelems,
-			  struct scatterlist *sout, unsigned long pages)
+static int __dma_map_cont(struct device *dev, struct scatterlist *start,
+			  int nelems, struct scatterlist *sout,
+			  unsigned long pages)
 {
-	unsigned long iommu_start = alloc_iommu(pages);
+	unsigned long iommu_start = alloc_iommu(dev, pages);
 	unsigned long iommu_page = iommu_start;
 	struct scatterlist *s;
 	int i;
@@ -394,8 +403,8 @@ static int __dma_map_cont(struct scatterlist *start, int nelems,
 }
 
 static inline int
-dma_map_cont(struct scatterlist *start, int nelems, struct scatterlist *sout,
-	     unsigned long pages, int need)
+dma_map_cont(struct device *dev, struct scatterlist *start, int nelems,
+	     struct scatterlist *sout, unsigned long pages, int need)
 {
 	if (!need) {
 		BUG_ON(nelems != 1);
@@ -403,7 +412,7 @@ dma_map_cont(struct scatterlist *start, int nelems, struct scatterlist *sout,
 		sout->dma_length = start->length;
 		return 0;
 	}
-	return __dma_map_cont(start, nelems, sout, pages);
+	return __dma_map_cont(dev, start, nelems, sout, pages);
 }
 		
 /*
@@ -452,8 +461,8 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			if (!iommu_merge || !nextneed || !need || s->offset ||
 			    (s->length + seg_size > max_seg_size) ||
 			    (ps->offset + ps->length) % PAGE_SIZE) {
-				if (dma_map_cont(start_sg, i - start, sgmap,
-						  pages, need) < 0)
+				if (dma_map_cont(dev, start_sg, i - start,
+						 sgmap, pages, need) < 0)
 					goto error;
 				out++;
 				seg_size = 0;
@@ -469,7 +478,7 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		pages += to_pages(s->offset, s->length);
 		ps = s;
 	}
-	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
+	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
 		goto error;
 	out++;
 	flush_gart();
-- 
1.5.3.4

