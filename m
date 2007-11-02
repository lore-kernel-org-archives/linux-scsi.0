From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/3] POWERPC: convert the IOMMU to use iova
Date: Sat, 3 Nov 2007 02:05:44 +0900
Message-ID: <20071103020723Y.tomof@acm.org>
References: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:32801 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759234AbXKBRIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Nov 2007 13:08:09 -0400
In-Reply-To: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, muli@il.ibm.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp

This converts the PPC64 IOMMU to use iova for free area management.

TODO: we might need to modify iova to use the tricks like avoiding
cacheline bouncing. Performance tests are necessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/kernel/iommu.c            |  169 ++++++--------------------------
 arch/powerpc/platforms/Kconfig.cputype |    1 +
 arch/powerpc/platforms/cell/iommu.c    |    3 +-
 arch/powerpc/sysdev/dart_iommu.c       |    4 +-
 include/asm-powerpc/iommu.h            |    6 +-
 5 files changed, 36 insertions(+), 147 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 2d0c9ef..34dcfd3 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -31,6 +31,7 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/bitops.h>
+#include <linux/iova.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -82,106 +83,18 @@ __setup("protect4gb=", setup_protect4gb);
 __setup("iommu=", setup_iommu);
 
 static unsigned long iommu_range_alloc(struct iommu_table *tbl,
-                                       unsigned long npages,
-                                       unsigned long *handle,
-                                       unsigned long mask,
-                                       unsigned int align_order)
-{ 
-	unsigned long n, end, i, start;
-	unsigned long limit;
-	int largealloc = npages > 15;
-	int pass = 0;
-	unsigned long align_mask;
-
-	align_mask = 0xffffffffffffffffl >> (64 - align_order);
-
-	/* This allocator was derived from x86_64's bit string search */
-
-	/* Sanity check */
-	if (unlikely(npages == 0)) {
-		if (printk_ratelimit())
-			WARN_ON(1);
-		return DMA_ERROR_CODE;
-	}
-
-	if (handle && *handle)
-		start = *handle;
-	else
-		start = largealloc ? tbl->it_largehint : tbl->it_hint;
-
-	/* Use only half of the table for small allocs (15 pages or less) */
-	limit = largealloc ? tbl->it_size : tbl->it_halfpoint;
-
-	if (largealloc && start < tbl->it_halfpoint)
-		start = tbl->it_halfpoint;
-
-	/* The case below can happen if we have a small segment appended
-	 * to a large, or when the previous alloc was at the very end of
-	 * the available space. If so, go back to the initial start.
-	 */
-	if (start >= limit)
-		start = largealloc ? tbl->it_largehint : tbl->it_hint;
-
- again:
-
-	if (limit + tbl->it_offset > mask) {
-		limit = mask - tbl->it_offset + 1;
-		/* If we're constrained on address range, first try
-		 * at the masked hint to avoid O(n) search complexity,
-		 * but on second pass, start at 0.
-		 */
-		if ((start & mask) >= limit || pass > 0)
-			start = 0;
-		else
-			start &= mask;
-	}
-
-	n = find_next_zero_bit(tbl->it_map, limit, start);
-
-	/* Align allocation */
-	n = (n + align_mask) & ~align_mask;
-
-	end = n + npages;
-
-	if (unlikely(end >= limit)) {
-		if (likely(pass < 2)) {
-			/* First failure, just rescan the half of the table.
-			 * Second failure, rescan the other half of the table.
-			 */
-			start = (largealloc ^ pass) ? tbl->it_halfpoint : 0;
-			limit = pass ? tbl->it_size : limit;
-			pass++;
-			goto again;
-		} else {
-			/* Third failure, give up */
-			return DMA_ERROR_CODE;
-		}
-	}
-
-	for (i = n; i < end; i++)
-		if (test_bit(i, tbl->it_map)) {
-			start = i+1;
-			goto again;
-		}
-
-	for (i = n; i < end; i++)
-		__set_bit(i, tbl->it_map);
-
-	/* Bump the hint to a new block for small allocs. */
-	if (largealloc) {
-		/* Don't bump to new block to avoid fragmentation */
-		tbl->it_largehint = end;
-	} else {
-		/* Overflow will be taken care of at the next allocation */
-		tbl->it_hint = (end + tbl->it_blocksize - 1) &
-		                ~(tbl->it_blocksize - 1);
-	}
+				      unsigned long npages,
+				      unsigned long mask,
+				      unsigned int align_order)
+{
+	unsigned long end;
+	struct iova *iova;
 
-	/* Update handle for SG allocations */
-	if (handle)
-		*handle = end;
+	end = min_t(unsigned long, DMA_32BIT_MASK >> IOMMU_PAGE_SHIFT,
+		    tbl->it_size - 1);
+	iova = alloc_iova(&tbl->iovad, npages, end, 1);
 
-	return n;
+	return iova ? iova->pfn_lo : DMA_ERROR_CODE;
 }
 
 static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *page,
@@ -193,7 +106,7 @@ static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *page,
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
-	entry = iommu_range_alloc(tbl, npages, NULL, mask, align_order);
+	entry = iommu_range_alloc(tbl, npages, mask, align_order);
 
 	if (unlikely(entry == DMA_ERROR_CODE)) {
 		spin_unlock_irqrestore(&(tbl->it_lock), flags);
@@ -224,7 +137,6 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 			 unsigned int npages)
 {
 	unsigned long entry, free_entry;
-	unsigned long i;
 
 	entry = dma_addr >> IOMMU_PAGE_SHIFT;
 	free_entry = entry - tbl->it_offset;
@@ -246,9 +158,8 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	}
 
 	ppc_md.tce_free(tbl, entry, npages);
-	
-	for (i = 0; i < npages; i++)
-		__clear_bit(free_entry+i, tbl->it_map);
+
+	free_iova(&tbl->iovad, free_entry);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
@@ -309,7 +220,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
 		npages = iommu_num_pages(vaddr, slen);
-		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
+		entry = iommu_range_alloc(tbl, npages, mask >> IOMMU_PAGE_SHIFT, 0);
 
 		DBG("  - vaddr: %lx, size: %lx\n", vaddr, slen);
 
@@ -439,34 +350,28 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&(tbl->it_lock), flags);
 }
 
+static struct kmem_cache *iova_cachep;
+
 /*
  * Build a iommu_table structure.  This contains a bit map which
  * is used to manage allocation of the tce space.
  */
 struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 {
-	unsigned long sz;
 	unsigned long start_index, end_index;
 	unsigned long entries_per_4g;
 	unsigned long index;
 	static int welcomed = 0;
-	struct page *page;
-
-	/* Set aside 1/4 of the table for large allocations. */
-	tbl->it_halfpoint = tbl->it_size * 3 / 4;
 
-	/* number of bytes needed for the bitmap */
-	sz = (tbl->it_size + 7) >> 3;
-
-	page = alloc_pages_node(nid, GFP_ATOMIC, get_order(sz));
-	if (!page)
-		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
-	tbl->it_map = page_address(page);
-	memset(tbl->it_map, 0, sz);
+	if (!iova_cachep) {
+		iova_cachep = KMEM_CACHE(iova, 0);
+		if (!iova_cachep)
+			return NULL;
+	}
 
-	tbl->it_hint = 0;
-	tbl->it_largehint = tbl->it_halfpoint;
 	spin_lock_init(&tbl->it_lock);
+	init_iova_domain(&tbl->iovad, DMA_32BIT_MASK >> IOMMU_PAGE_SHIFT,
+			 iova_cachep);
 
 #ifdef CONFIG_CRASH_DUMP
 	if (ppc_md.tce_get) {
@@ -482,7 +387,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 			 * Freed TCE entry contains 0x7fffffffffffffff on JS20
 			 */
 			if (tceval && (tceval != 0x7fffffffffffffffUL)) {
-				__set_bit(index, tbl->it_map);
+				free_iova(&tbl->iovad, index);
 				tcecount++;
 			}
 		}
@@ -492,7 +397,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 				KDUMP_MIN_TCE_ENTRIES);
 			for (index = tbl->it_size - KDUMP_MIN_TCE_ENTRIES;
 				index < tbl->it_size; index++)
-				__clear_bit(index, tbl->it_map);
+				free_iova(&tbl->iovad, index);
 		}
 	}
 #else
@@ -514,7 +419,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 		end_index = tbl->it_size;
 
 		for (index = start_index; index < end_index - 1; index += entries_per_4g)
-			__set_bit(index, tbl->it_map);
+			free_iova(&tbl->iovad, index);
 	}
 
 	if (!welcomed) {
@@ -530,31 +435,15 @@ void iommu_free_table(struct device_node *dn)
 {
 	struct pci_dn *pdn = dn->data;
 	struct iommu_table *tbl = pdn->iommu_table;
-	unsigned long bitmap_sz, i;
-	unsigned int order;
 
-	if (!tbl || !tbl->it_map) {
+	if (!tbl) {
 		printk(KERN_ERR "%s: expected TCE map for %s\n", __FUNCTION__,
 				dn->full_name);
 		return;
 	}
 
 	/* verify that table contains no entries */
-	/* it_size is in entries, and we're examining 64 at a time */
-	for (i = 0; i < (tbl->it_size/64); i++) {
-		if (tbl->it_map[i] != 0) {
-			printk(KERN_WARNING "%s: Unexpected TCEs for %s\n",
-				__FUNCTION__, dn->full_name);
-			break;
-		}
-	}
-
-	/* calculate bitmap size in bytes */
-	bitmap_sz = (tbl->it_size + 7) / 8;
-
-	/* free bitmap */
-	order = get_order(bitmap_sz);
-	free_pages((unsigned long) tbl->it_map, order);
+	put_iova_domain(&tbl->iovad);
 
 	/* free table */
 	kfree(tbl);
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 99684ea..22483e5 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,6 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
+	select IOVA
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index faabc3f..799e8e5 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -471,10 +471,9 @@ cell_iommu_setup_window(struct cbe_iommu *iommu, struct device_node *np,
 	 * This code also assumes that we have a window that starts at 0,
 	 * which is the case on all spider based blades.
 	 */
-	__set_bit(0, window->table.it_map);
+	reserve_iova(&window->table.iovad, 0, 0);
 	tce_build_cell(&window->table, window->table.it_offset, 1,
 		       (unsigned long)iommu->pad_page, DMA_TO_DEVICE);
-	window->table.it_hint = window->table.it_blocksize;
 
 	return window;
 }
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index e0e24b0..6c58ef5 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -37,6 +37,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/suspend.h>
+#include <linux/iova.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -287,7 +288,8 @@ static void iommu_table_dart_setup(void)
 	/* Reserve the last page of the DART to avoid possible prefetch
 	 * past the DART mapped area
 	 */
-	set_bit(iommu_table_dart.it_size - 1, iommu_table_dart.it_map);
+	reserve_iova(&iommu_table_dart.iovad, iommu_table_dart.it_size - 1,
+		     iommu_table_dart.it_size - 1);
 }
 
 static void pci_dma_dev_setup_dart(struct pci_dev *dev)
diff --git a/include/asm-powerpc/iommu.h b/include/asm-powerpc/iommu.h
index 4a82fdc..f497e7e 100644
--- a/include/asm-powerpc/iommu.h
+++ b/include/asm-powerpc/iommu.h
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/bitops.h>
+#include <linux/iova.h>
 #include <asm/machdep.h>
 #include <asm/types.h>
 
@@ -61,11 +62,8 @@ struct iommu_table {
 	unsigned long  it_index;     /* which iommu table this is */
 	unsigned long  it_type;      /* type: PCI or Virtual Bus */
 	unsigned long  it_blocksize; /* Entries in each block (cacheline) */
-	unsigned long  it_hint;      /* Hint for next alloc */
-	unsigned long  it_largehint; /* Hint for large allocs */
-	unsigned long  it_halfpoint; /* Breaking point for small/large allocs */
 	spinlock_t     it_lock;      /* Protects it_map */
-	unsigned long *it_map;       /* A simple allocation bitmap for now */
+	struct iova_domain iovad;
 };
 
 struct scatterlist;
-- 
1.5.2.4

