From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH -mm 0/3] convert IOMMUs to use iova
Date: Wed, 7 Nov 2007 22:33:44 +0900
Message-ID: <20071107223521D.tomof@acm.org>
References: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
	<20071102171227.GH7975@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50277 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXKGNjE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 08:39:04 -0500
In-Reply-To: <20071102171227.GH7975@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: muli@il.ibm.com
Cc: tomof@acm.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Fri, 2 Nov 2007 19:12:27 +0200
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Sat, Nov 03, 2007 at 02:05:39AM +0900, FUJITA Tomonori wrote:
> 
> > This patchset convert the PPC64 IOMMU to use the iova code for free
> > area management.
> > 
> > The IOMMUs ignores low level drivers' restrictions, the maximum
> > segment size and segment boundary.
> > 
> > I fixed the former:
> > 
> > http://thread.gmane.org/gmane.linux.scsi/35602
> > 
> > The latter makes the free area management complicated. I'd like to
> > convert IOMMUs to use the iova code (that intel-iommu introduced)
> > for free area management and enable iova to handle segment boundary
> > restrictions, rather than fixing all the IOMMUs' free area
> > management,
> 
> In general it sounds like a great idea, but have you looked at what
> impact this has on the performance of the IO path?

I converted swiotlb to use iova and compared it with the original
algorithm (better than the simple bit map one that most of the IOMMUs
use, I think).

I use 'swiotlb=force' boot option and run netperf with "-m 128 -D"
(lead to tons of dma_map_single).

The original produced 281.8 Mb/s and the iova produced 77.2 Mb/s.

Seems that it would be better to generalization the swiotlb algorithm
(at least for small I/O area)? Or my patch might have bugs.

Here's the patch to convert swiotlb to use iova against my iova
patchset:

http://marc.info/?l=linux-kernel&m=119402340801254&w=2

diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index c10d3f0..8735822 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -524,6 +524,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
+	select IOVA
 	help
 	  Support for software bounce buffers used on x86-64 systems
 	  which don't have a hardware IOMMU (e.g. the current generation
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index aa805b1..8507402 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -325,6 +325,9 @@ static int __init pci_iommu_init(void)
 	gart_iommu_init();
 #endif
 
+#ifdef CONFIG_SWIOTLB
+	swiotlb_alloc();
+#endif
 	no_iommu_init();
 	return 0;
 }
diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index f9c5895..f00d20c 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -40,6 +40,7 @@ extern void swiotlb_free_coherent (struct device *hwdev, size_t size,
 				   void *vaddr, dma_addr_t dma_handle);
 extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
 extern void swiotlb_init(void);
+extern void swiotlb_alloc(void);
 
 extern int swiotlb_force;
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1a8050a..54ecb87 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
+#include <linux/iova.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -103,10 +104,7 @@ static unsigned int io_tlb_index;
  */
 static unsigned char **io_tlb_orig_addr;
 
-/*
- * Protect the above data structures in the map and unmap calls
- */
-static DEFINE_SPINLOCK(io_tlb_lock);
+static struct iova_domain swiotlb_iovad;
 
 static int __init
 setup_io_tlb_npages(char *str)
@@ -272,6 +270,19 @@ cleanup1:
 	return -ENOMEM;
 }
 
+static struct kmem_cache *iova_cachep;
+
+void __init
+swiotlb_alloc(void)
+{
+	if (!swiotlb)
+		return;
+
+	iova_cachep = KMEM_CACHE(iova, 0);
+	init_iova_domain(&swiotlb_iovad, DMA_32BIT_MASK >> IO_TLB_SHIFT,
+			 iova_cachep);
+}
+
 static int
 address_needs_mapping(struct device *hwdev, dma_addr_t addr)
 {
@@ -288,70 +299,20 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr)
 static void *
 map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 {
-	unsigned long flags;
 	char *dma_addr;
-	unsigned int nslots, stride, index, wrap;
+	unsigned int nslots, index;
 	int i;
+	struct iova *iova;
 
-	/*
-	 * For mappings greater than a page, we limit the stride (and
-	 * hence alignment) to a page size.
-	 */
 	nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	if (size > PAGE_SIZE)
-		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
-	else
-		stride = 1;
-
 	BUG_ON(!nslots);
 
-	/*
-	 * Find suitable number of IO TLB entries size that will fit this
-	 * request and allocate a buffer from that IO TLB pool.
-	 */
-	spin_lock_irqsave(&io_tlb_lock, flags);
-	{
-		wrap = index = ALIGN(io_tlb_index, stride);
-
-		if (index >= io_tlb_nslabs)
-			wrap = index = 0;
-
-		do {
-			/*
-			 * If we find a slot that indicates we have 'nslots'
-			 * number of contiguous buffers, we allocate the
-			 * buffers from that slot and mark the entries as '0'
-			 * indicating unavailable.
-			 */
-			if (io_tlb_list[index] >= nslots) {
-				int count = 0;
-
-				for (i = index; i < (int) (index + nslots); i++)
-					io_tlb_list[i] = 0;
-				for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
-					io_tlb_list[i] = ++count;
-				dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
-
-				/*
-				 * Update the indices to avoid searching in
-				 * the next round.
-				 */
-				io_tlb_index = ((index + nslots) < io_tlb_nslabs
-						? (index + nslots) : 0);
-
-				goto found;
-			}
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
-		} while (index != wrap);
-
-		spin_unlock_irqrestore(&io_tlb_lock, flags);
+	iova = alloc_iova(&swiotlb_iovad, nslots, io_tlb_nslabs - 1, 1);
+	if (!iova)
 		return NULL;
-	}
-  found:
-	spin_unlock_irqrestore(&io_tlb_lock, flags);
 
+	index = iova->pfn_lo;
+	dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
 	/*
 	 * Save away the mapping from the original address to the DMA address.
 	 * This is needed when we sync the memory.  Then we sync the buffer if
@@ -371,8 +332,6 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 static void
 unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 {
-	unsigned long flags;
-	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	char *buffer = io_tlb_orig_addr[index];
 
@@ -386,30 +345,7 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 		 */
 		memcpy(buffer, dma_addr, size);
 
-	/*
-	 * Return the buffer to the free list by setting the corresponding
-	 * entries to indicate the number of contigous entries available.
-	 * While returning the entries to the free list, we merge the entries
-	 * with slots below and above the pool being returned.
-	 */
-	spin_lock_irqsave(&io_tlb_lock, flags);
-	{
-		count = ((index + nslots) < ALIGN(index + 1, IO_TLB_SEGSIZE) ?
-			 io_tlb_list[index + nslots] : 0);
-		/*
-		 * Step 1: return the slots to the free list, merging the
-		 * slots with superceeding slots
-		 */
-		for (i = index + nslots - 1; i >= index; i--)
-			io_tlb_list[i] = ++count;
-		/*
-		 * Step 2: merge the returned slots with the preceding slots,
-		 * if available (non zero)
-		 */
-		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
-			io_tlb_list[i] = ++count;
-	}
-	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	free_iova(&swiotlb_iovad, index);
 }
 
 static void
-- 
1.5.3.4

