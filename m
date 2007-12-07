From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 4/6] x86: convert calgary IOMMU to use the IOMMU helper
Date: Fri, 7 Dec 2007 23:56:42 +0900
Message-ID: <20071207235717T.tomof@acm.org>
References: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756437AbXLGPAu@vger.kernel.org>
In-Reply-To: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

This patch converts calgary IOMMU to use the IOMMU helper
functions. The IOMMU doesn't allocate a memory area spanning LLD's
segment boundary anymore.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/Kconfig                 |    3 +++
 arch/x86/kernel/pci-calgary_64.c |   34 ++++++++++++++++++++--------------
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 48d09cb..df22fe7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -433,6 +433,9 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
+config IOMMU_HELPER
+	def_bool CALGARY_IOMMU
+
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 21f34db..f5b47ba 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -35,6 +35,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -260,22 +261,28 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
-static unsigned long iommu_range_alloc(struct iommu_table *tbl,
-	unsigned int npages)
+static unsigned long iommu_range_alloc(struct device *dev,
+				       struct iommu_table *tbl,
+				       unsigned int npages)
 {
 	unsigned long flags;
 	unsigned long offset;
+	unsigned long boundary_size;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	BUG_ON(npages == 0);
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	offset = find_next_zero_string(tbl->it_map, tbl->it_hint,
-				       tbl->it_size, npages);
+	offset = iommu_area_alloc(tbl->it_map, tbl->it_size, tbl->it_hint,
+				  npages, 0, boundary_size, 0);
 	if (offset == ~0UL) {
 		tbl->chip_ops->tce_cache_blast(tbl);
-		offset = find_next_zero_string(tbl->it_map, 0,
-					       tbl->it_size, npages);
+
+		offset = iommu_area_alloc(tbl->it_map, tbl->it_size, 0,
+					  npages, 0, boundary_size, 0);
 		if (offset == ~0UL) {
 			printk(KERN_WARNING "Calgary: IOMMU full.\n");
 			spin_unlock_irqrestore(&tbl->it_lock, flags);
@@ -286,7 +293,6 @@ static unsigned long iommu_range_alloc(struct iommu_table *tbl,
 		}
 	}
 
-	set_bit_string(tbl->it_map, offset, npages);
 	tbl->it_hint = offset + npages;
 	BUG_ON(tbl->it_hint > tbl->it_size);
 
@@ -295,13 +301,13 @@ static unsigned long iommu_range_alloc(struct iommu_table *tbl,
 	return offset;
 }
 
-static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *vaddr,
-	unsigned int npages, int direction)
+static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
+			      void *vaddr, unsigned int npages, int direction)
 {
 	unsigned long entry;
 	dma_addr_t ret = bad_dma_address;
 
-	entry = iommu_range_alloc(tbl, npages);
+	entry = iommu_range_alloc(dev, tbl, npages);
 
 	if (unlikely(entry == bad_dma_address))
 		goto error;
@@ -354,7 +360,7 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 			       badbit, tbl, dma_addr, entry, npages);
 	}
 
-	__clear_bit_string(tbl->it_map, entry, npages);
+	iommu_area_free(tbl->it_map, entry, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
@@ -438,7 +444,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		vaddr = (unsigned long) sg_virt(s);
 		npages = num_dma_pages(vaddr, s->length);
 
-		entry = iommu_range_alloc(tbl, npages);
+		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == bad_dma_address) {
 			/* makes sure unmap knows to stop */
 			s->dma_length = 0;
@@ -476,7 +482,7 @@ static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	npages = num_dma_pages(uaddr, size);
 
 	if (translation_enabled(tbl))
-		dma_handle = iommu_alloc(tbl, vaddr, npages, direction);
+		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction);
 	else
 		dma_handle = virt_to_bus(vaddr);
 
@@ -516,7 +522,7 @@ static void* calgary_alloc_coherent(struct device *dev, size_t size,
 
 	if (translation_enabled(tbl)) {
 		/* set up tces to cover the allocated range */
-		mapping = iommu_alloc(tbl, ret, npages, DMA_BIDIRECTIONAL);
+		mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
 		if (mapping == bad_dma_address)
 			goto free;
 
-- 
1.5.3.4

