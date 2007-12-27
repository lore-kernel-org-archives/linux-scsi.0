From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
Date: Thu, 27 Dec 2007 12:11:08 +0900
Message-ID: <20071227121108L.fujita.tomonori@lab.ntt.co.jp>
References: <20071224044850.GA11449@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:40618 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXL0DNR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Dec 2007 22:13:17 -0500
In-Reply-To: <20071224044850.GA11449@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 24 Dec 2007 10:18:50 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Hi,
> 
> I've just seen this on my dmesg, this is new, never seen this before on
> this box and it happens only with this version of the kernel.
> 
> In this configuration, the page size is set to 64K and I've enabled fake
> NUMA nodes on PowerPC.
> 
> tce_buildmulti_pSeriesLP: plpar_tce_put failed. rc=-4
>         index   = 0x4000002
>         npages  = 0x0
>         tce[0] val = 0x15ad0001
> Call Trace:
> [c00000000ffe74f0] [c0000000000491a4]
> .tce_buildmulti_pSeriesLP+0x26c/0x2ac (unreliable)
> [c00000000ffe75c0] [c0000000000295e4] .iommu_map_sg+0x1d4/0x418
> [c00000000ffe76d0] [c000000000028664] .dma_iommu_map_sg+0x3c/0x50
> [c00000000ffe7750] [c0000000003b6c30] .scsi_dma_map+0x70/0x94
> [c00000000ffe77d0] [c0000000003dedbc] .ipr_queuecommand+0x300/0x500
> [c00000000ffe7880] [c0000000003ae964] .scsi_dispatch_cmd+0x21c/0x2b8
> [c00000000ffe7920] [c0000000003b67a0] .scsi_request_fn+0x310/0x460
> [c00000000ffe79d0] [c00000000024ab90] .blk_run_queue+0x94/0xec
> [c00000000ffe7a70] [c0000000003b3b08] .scsi_run_queue+0x24c/0x27c
> [c00000000ffe7b20] [c0000000003b4424] .scsi_next_command+0x48/0x70
> [c00000000ffe7bc0] [c0000000003b4b48] .scsi_end_request+0xbc/0xe4
> [c00000000ffe7c60] [c0000000003b5294] .scsi_io_completion+0x170/0x3e8
> [c00000000ffe7d40] [c0000000003ae0e4] .scsi_finish_command+0xb4/0xd4
> [c00000000ffe7dd0] [c0000000003b584c] .scsi_softirq_done+0x114/0x138
> [c00000000ffe7e60] [c00000000024af70] .blk_done_softirq+0xa0/0xd0
> [c00000000ffe7ef0] [c00000000007a2a0] .__do_softirq+0xa8/0x164
> [c00000000ffe7f90] [c000000000027edc] .call_do_softirq+0x14/0x24
> [c00000003e183950] [c00000000000bdcc] .do_softirq+0x74/0xc0
> [c00000003e1839e0] [c00000000007a450] .irq_exit+0x5c/0xac
> [c00000003e183a60] [c00000000000c414] .do_IRQ+0x17c/0x1f4
> [c00000003e183b00] [c000000000004c24] hardware_interrupt_entry+0x24/0x28
> --- Exception: 501 at .ppc64_runlatch_off+0x28/0x60
>     LR = .pseries_dedicated_idle_sleep+0xd8/0x1a4
> [c00000003e183df0] [c000000000048494]
> .pseries_dedicated_idle_sleep+0x78/0x1a4 (unreliable)
> [c00000003e183e80] [c00000000001110c] .cpu_idle+0x10c/0x1e8
> [c00000003e183f00] [c00000000002b5b0] .start_secondary+0x1b4/0x1d8
> [c00000003e183f90] [c0000000000083c4] .start_secondary_prolog+0xc/0x10

I might break the IOMMU code. Can you reproduce it easily? If so,
reverting my IOMMU patches (I've attached a patch to revert them) fix
the problem?

Thanks,

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ff2a62d..59899b2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -244,9 +244,6 @@ config IOMMU_VMERGE
 
 	  Most drivers don't have this problem; it is safe to say Y here.
 
-config IOMMU_HELPER
-	def_bool PPC64
-
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
 	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)
diff --git a/arch/powerpc/kernel/dma_64.c b/arch/powerpc/kernel/dma_64.c
index 6fcb7cb..1806d96 100644
--- a/arch/powerpc/kernel/dma_64.c
+++ b/arch/powerpc/kernel/dma_64.c
@@ -31,8 +31,8 @@ static inline unsigned long device_to_mask(struct device *dev)
 static void *dma_iommu_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag)
 {
-	return iommu_alloc_coherent(dev, dev->archdata.dma_data, size,
-				    dma_handle, device_to_mask(dev), flag,
+	return iommu_alloc_coherent(dev->archdata.dma_data, size, dma_handle,
+				    device_to_mask(dev), flag,
 				    dev->archdata.numa_node);
 }
 
@@ -52,7 +52,7 @@ static dma_addr_t dma_iommu_map_single(struct device *dev, void *vaddr,
 				       size_t size,
 				       enum dma_data_direction direction)
 {
-	return iommu_map_single(dev, dev->archdata.dma_data, vaddr, size,
+	return iommu_map_single(dev->archdata.dma_data, vaddr, size,
 			        device_to_mask(dev), direction);
 }
 
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 18e8860..050e9ac 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -31,7 +31,6 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/bitops.h>
-#include <linux/iommu-helper.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -82,19 +81,17 @@ static int __init setup_iommu(char *str)
 __setup("protect4gb=", setup_protect4gb);
 __setup("iommu=", setup_iommu);
 
-static unsigned long iommu_range_alloc(struct device *dev,
-				       struct iommu_table *tbl,
+static unsigned long iommu_range_alloc(struct iommu_table *tbl,
                                        unsigned long npages,
                                        unsigned long *handle,
                                        unsigned long mask,
                                        unsigned int align_order)
 { 
-	unsigned long n, end, start;
+	unsigned long n, end, i, start;
 	unsigned long limit;
 	int largealloc = npages > 15;
 	int pass = 0;
 	unsigned long align_mask;
-	unsigned long boundary_size;
 
 	align_mask = 0xffffffffffffffffl >> (64 - align_order);
 
@@ -139,17 +136,14 @@ static unsigned long iommu_range_alloc(struct device *dev,
 			start &= mask;
 	}
 
-	if (dev)
-		boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
-				      1 << IOMMU_PAGE_SHIFT);
-	else
-		boundary_size = ALIGN(1UL << 32, 1 << IOMMU_PAGE_SHIFT);
-	/* 4GB boundary for iseries_hv_alloc and iseries_hv_map */
+	n = find_next_zero_bit(tbl->it_map, limit, start);
+
+	/* Align allocation */
+	n = (n + align_mask) & ~align_mask;
+
+	end = n + npages;
 
-	n = iommu_area_alloc(tbl->it_map, limit, start, npages,
-			     tbl->it_offset, boundary_size >> IOMMU_PAGE_SHIFT,
-			     align_mask);
-	if (n == -1) {
+	if (unlikely(end >= limit)) {
 		if (likely(pass < 2)) {
 			/* First failure, just rescan the half of the table.
 			 * Second failure, rescan the other half of the table.
@@ -164,7 +158,14 @@ static unsigned long iommu_range_alloc(struct device *dev,
 		}
 	}
 
-	end = n + npages;
+	for (i = n; i < end; i++)
+		if (test_bit(i, tbl->it_map)) {
+			start = i+1;
+			goto again;
+		}
+
+	for (i = n; i < end; i++)
+		__set_bit(i, tbl->it_map);
 
 	/* Bump the hint to a new block for small allocs. */
 	if (largealloc) {
@@ -183,17 +184,16 @@ static unsigned long iommu_range_alloc(struct device *dev,
 	return n;
 }
 
-static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
-			      void *page, unsigned int npages,
-			      enum dma_data_direction direction,
-			      unsigned long mask, unsigned int align_order)
+static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *page,
+		       unsigned int npages, enum dma_data_direction direction,
+		       unsigned long mask, unsigned int align_order)
 {
 	unsigned long entry, flags;
 	dma_addr_t ret = DMA_ERROR_CODE;
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
-	entry = iommu_range_alloc(dev, tbl, npages, NULL, mask, align_order);
+	entry = iommu_range_alloc(tbl, npages, NULL, mask, align_order);
 
 	if (unlikely(entry == DMA_ERROR_CODE)) {
 		spin_unlock_irqrestore(&(tbl->it_lock), flags);
@@ -224,6 +224,7 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 			 unsigned int npages)
 {
 	unsigned long entry, free_entry;
+	unsigned long i;
 
 	entry = dma_addr >> IOMMU_PAGE_SHIFT;
 	free_entry = entry - tbl->it_offset;
@@ -245,7 +246,9 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	}
 
 	ppc_md.tce_free(tbl, entry, npages);
-	iommu_area_free(tbl->it_map, free_entry, npages);
+	
+	for (i = 0; i < npages; i++)
+		__clear_bit(free_entry+i, tbl->it_map);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
@@ -309,8 +312,7 @@ int iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
 		npages = iommu_num_pages(vaddr, slen);
-		entry = iommu_range_alloc(dev, tbl, npages, &handle,
-					  mask >> IOMMU_PAGE_SHIFT, 0);
+		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
 
 		DBG("  - vaddr: %lx, size: %lx\n", vaddr, slen);
 
@@ -448,6 +450,9 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 {
 	unsigned long sz;
+	unsigned long start_index, end_index;
+	unsigned long entries_per_4g;
+	unsigned long index;
 	static int welcomed = 0;
 	struct page *page;
 
@@ -469,7 +474,6 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 
 #ifdef CONFIG_CRASH_DUMP
 	if (ppc_md.tce_get) {
-		unsigned long index;
 		unsigned long tceval;
 		unsigned long tcecount = 0;
 
@@ -500,6 +504,23 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	ppc_md.tce_free(tbl, tbl->it_offset, tbl->it_size);
 #endif
 
+	/*
+	 * DMA cannot cross 4 GB boundary.  Mark last entry of each 4
+	 * GB chunk as reserved.
+	 */
+	if (protect4gb) {
+		entries_per_4g = 0x100000000l >> IOMMU_PAGE_SHIFT;
+
+		/* Mark the last bit before a 4GB boundary as used */
+		start_index = tbl->it_offset | (entries_per_4g - 1);
+		start_index -= tbl->it_offset;
+
+		end_index = tbl->it_size;
+
+		for (index = start_index; index < end_index - 1; index += entries_per_4g)
+			__set_bit(index, tbl->it_map);
+	}
+
 	if (!welcomed) {
 		printk(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
 		       novmerge ? "disabled" : "enabled");
@@ -547,9 +568,9 @@ void iommu_free_table(struct iommu_table *tbl, const char *node_name)
  * need not be page aligned, the dma_addr_t returned will point to the same
  * byte within the page as vaddr.
  */
-dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
-			    void *vaddr, size_t size, unsigned long mask,
-			    enum dma_data_direction direction)
+dma_addr_t iommu_map_single(struct iommu_table *tbl, void *vaddr,
+		size_t size, unsigned long mask,
+		enum dma_data_direction direction)
 {
 	dma_addr_t dma_handle = DMA_ERROR_CODE;
 	unsigned long uaddr;
@@ -561,7 +582,7 @@ dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
 	npages = iommu_num_pages(uaddr, size);
 
 	if (tbl) {
-		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction,
+		dma_handle = iommu_alloc(tbl, vaddr, npages, direction,
 					 mask >> IOMMU_PAGE_SHIFT, 0);
 		if (dma_handle == DMA_ERROR_CODE) {
 			if (printk_ratelimit())  {
@@ -593,9 +614,8 @@ void iommu_unmap_single(struct iommu_table *tbl, dma_addr_t dma_handle,
  * Returns the virtual address of the buffer and sets dma_handle
  * to the dma address (mapping) of the first page.
  */
-void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
-			   size_t size,	dma_addr_t *dma_handle,
-			   unsigned long mask, gfp_t flag, int node)
+void *iommu_alloc_coherent(struct iommu_table *tbl, size_t size,
+		dma_addr_t *dma_handle, unsigned long mask, gfp_t flag, int node)
 {
 	void *ret = NULL;
 	dma_addr_t mapping;
@@ -629,7 +649,7 @@ void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
 	/* Set up tces to cover the allocated range */
 	nio_pages = size >> IOMMU_PAGE_SHIFT;
 	io_order = get_iommu_order(size);
-	mapping = iommu_alloc(dev, tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
+	mapping = iommu_alloc(tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
 			      mask >> IOMMU_PAGE_SHIFT, io_order);
 	if (mapping == DMA_ERROR_CODE) {
 		free_pages((unsigned long)ret, order);
diff --git a/arch/powerpc/platforms/iseries/iommu.c b/arch/powerpc/platforms/iseries/iommu.c
index 11fa3c7..6a0c6f6 100644
--- a/arch/powerpc/platforms/iseries/iommu.c
+++ b/arch/powerpc/platforms/iseries/iommu.c
@@ -199,7 +199,7 @@ static struct iommu_table vio_iommu_table;
 
 void *iseries_hv_alloc(size_t size, dma_addr_t *dma_handle, gfp_t flag)
 {
-	return iommu_alloc_coherent(NULL, &vio_iommu_table, size, dma_handle,
+	return iommu_alloc_coherent(&vio_iommu_table, size, dma_handle,
 				DMA_32BIT_MASK, flag, -1);
 }
 EXPORT_SYMBOL_GPL(iseries_hv_alloc);
@@ -213,7 +213,7 @@ EXPORT_SYMBOL_GPL(iseries_hv_free);
 dma_addr_t iseries_hv_map(void *vaddr, size_t size,
 			enum dma_data_direction direction)
 {
-	return iommu_map_single(NULL, &vio_iommu_table, vaddr, size,
+	return iommu_map_single(&vio_iommu_table, vaddr, size,
 				DMA_32BIT_MASK, direction);
 }
 
diff --git a/include/asm-powerpc/iommu.h b/include/asm-powerpc/iommu.h
index 852e15f..a07a67c 100644
--- a/include/asm-powerpc/iommu.h
+++ b/include/asm-powerpc/iommu.h
@@ -85,13 +85,13 @@ extern int iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 extern void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			   int nelems, enum dma_data_direction direction);
 
-extern void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
-				  size_t size, dma_addr_t *dma_handle,
-				  unsigned long mask, gfp_t flag, int node);
+extern void *iommu_alloc_coherent(struct iommu_table *tbl, size_t size,
+				  dma_addr_t *dma_handle, unsigned long mask,
+				  gfp_t flag, int node);
 extern void iommu_free_coherent(struct iommu_table *tbl, size_t size,
 				void *vaddr, dma_addr_t dma_handle);
-extern dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
-				   void *vaddr, size_t size, unsigned long mask,
+extern dma_addr_t iommu_map_single(struct iommu_table *tbl, void *vaddr,
+				   size_t size, unsigned long mask,
 				   enum dma_data_direction direction);
 extern void iommu_unmap_single(struct iommu_table *tbl, dma_addr_t dma_handle,
 			       size_t size, enum dma_data_direction direction);
