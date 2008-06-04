From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Wed, 4 Jun 2008 23:47:01 +0900
Message-ID: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44496 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbYFDOrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2008 10:47:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, mgross@linux.intel.com
Cc: linux-scsi@vger.kernel.org

I resumed the work to make the IOMMU respect drivers' DMA alignment
(since I got a desktop box having VT-d). In short, some IOMMUs
allocate memory areas spanning driver's segment boundary limit (DMA
alignment). It forces drivers to have a workaround to split up scatter
entries into smaller chunks again. To remove such work around in
drivers, I modified several IOMMUs, X86_64 (Calgary and Gart), Alpha,
POWER, PARISC, IA64, SPARC64, and swiotlb.

Now I try to fix Intel IOMMU code, the free space management
algorithm.

The major difference between Intel IOMMU code and the others is Intel
IOMMU code uses Red Black tree to manage free space while the others
use bitmap (swiotlb is the only exception).

The Red Black tree method consumes less memory than the bitmap method,
but it incurs more overheads (the RB tree method needs to walk through
the tree, allocates a new item, and insert it every time it maps an
I/O address). Intel IOMMU (and IOMMUs for virtualization) needs
multiple IOMMU address spaces. That's why the Red Black tree method is
chosen, I guess.

Half a year ago, I tried to convert POWER IOMMU code to use the Red
Black method and saw performance drop:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg00650.html

So I tried to convert Intel IOMMU code to use the bitmap method to see
how much I can get.

I didn't see noticable performance differences with 1GbE. So I tried
the modified driver of a SCSI HBA that just does memory accesses to
emulate the performances of SSD disk drives, 10GbE, Infiniband, etc.

I got the following results with one thread issuing 1KB I/Os:

                    IOPS (I/O per second)
IOMMU disabled         145253.1 (1.000)
RB tree (mainline)     118313.0 (0.814)
Bitmap                 128954.1 (0.887)


I've attached the patch to modify Intel IOMMU code to use the bitmap
method but I have no intention of arguing that Intel IOMMU code
consumes more memory for better performance. :) I want to do more
performance tests with 10GbE (probably, I have to wait for a server
box having VT-d, which is not available on the market now).

As I said, what I want to do now is to make Intel IOMMU code respect
drivers' DMA alignment. Well, it's easier to do that if Intel IOMMU
uses the bitmap method since I can simply convert the IOMMU code to
use lib/iommu-helper but I can modify the RB tree method too.

I'm just interested in other people's opinions on IOMMU
implementations, performances, possible future changes for performance
improvement, etc.

For further information:

LSF'08 "Storage Track" summary by Grant Grundler:
http://iou.parisc-linux.org/lsf2008/SUMMARY-Storage.txt

My LSF'08 slides:
http://iou.parisc-linux.org/lsf2008/IO-DMA_Representations-fujita_tomonori.pdf


Tis patch is against the latst git tree (note that it just converts
Intel IOMMU code to use the bitmap. It doesn't make it respect
drivers' DMA alignment yet).

=
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcbec34..06d92d0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1553,6 +1553,9 @@ config DMAR
 	  and include PCI device scope covered by these DMA
 	  remapping devices.
 
+config IOMMU_HELPER
+	def_bool DMAR
+
 config DMAR_GFX_WA
 	def_bool y
 	prompt "Support for Graphics workaround"
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 4d1ce2e..675beb6 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
 # Build Intel IOMMU support
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
+obj-$(CONFIG_DMAR) += dmar.o intel-iommu.o
 
 #
 # Some architectures use the generic PCI setup functions
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index f941f60..41ad545 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -26,7 +26,6 @@
 
 #include <linux/pci.h>
 #include <linux/dmar.h>
-#include "iova.h"
 #include "intel-iommu.h"
 
 #undef PREFIX
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 66c0fd2..839363a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -32,8 +32,7 @@
 #include <linux/dmar.h>
 #include <linux/dma-mapping.h>
 #include <linux/mempool.h>
-#include <linux/timer.h>
-#include "iova.h"
+#include <linux/iommu-helper.h>
 #include "intel-iommu.h"
 #include <asm/proto.h> /* force_iommu in this header in x86-64*/
 #include <asm/cacheflush.h>
@@ -51,33 +50,15 @@
 
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
 
-#define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
-
-
-static void flush_unmaps_timeout(unsigned long data);
+#define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
-DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
+#define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
 static struct intel_iommu *g_iommus;
 
-#define HIGH_WATER_MARK 250
-struct deferred_flush_tables {
-	int next;
-	struct iova *iova[HIGH_WATER_MARK];
-	struct dmar_domain *domain[HIGH_WATER_MARK];
-};
-
-static struct deferred_flush_tables *deferred_flush;
-
 /* bitmap for indexing intel_iommus */
 static int g_num_of_iommus;
 
-static DEFINE_SPINLOCK(async_umap_flush_lock);
-static LIST_HEAD(unmaps_to_do);
-
-static int timer_on;
-static long list_size;
-
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
 static int dmar_disabled;
@@ -121,7 +102,6 @@ __setup("intel_iommu=", intel_iommu_setup);
 
 static struct kmem_cache *iommu_domain_cache;
 static struct kmem_cache *iommu_devinfo_cache;
-static struct kmem_cache *iommu_iova_cache;
 
 static inline void *iommu_kmem_cache_alloc(struct kmem_cache *cachep)
 {
@@ -175,16 +155,6 @@ static inline void free_devinfo_mem(void *vaddr)
 	kmem_cache_free(iommu_devinfo_cache, vaddr);
 }
 
-struct iova *alloc_iova_mem(void)
-{
-	return iommu_kmem_cache_alloc(iommu_iova_cache);
-}
-
-void free_iova_mem(struct iova *iova)
-{
-	kmem_cache_free(iommu_iova_cache, iova);
-}
-
 static inline void __iommu_flush_cache(
 	struct intel_iommu *iommu, void *addr, int size)
 {
@@ -1124,29 +1094,39 @@ static void iommu_free_domain(struct dmar_domain *domain)
 	spin_unlock_irqrestore(&domain->iommu->lock, flags);
 }
 
-static struct iova_domain reserved_iova_list;
+static unsigned long *reserved_it_map;
+static unsigned long reserved_it_size;
 static struct lock_class_key reserved_alloc_key;
 static struct lock_class_key reserved_rbtree_key;
 
+static void reserve_area(unsigned long *map, unsigned long start, unsigned long end)
+{
+	while (start <= end) {
+		__set_bit(start, map);
+		start++;
+	}
+}
+
 static void dmar_init_reserved_ranges(void)
 {
 	struct pci_dev *pdev = NULL;
-	struct iova *iova;
 	int i;
 	u64 addr, size;
 
-	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
+	reserved_it_size = 1UL << (32 - PAGE_SHIFT_4K);
+	reserved_it_map = kzalloc(reserved_it_size / BITS_PER_BYTE, GFP_ATOMIC);
+	BUG_ON(!reserved_it_map);
 
 	lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
 		&reserved_alloc_key);
 	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
 		&reserved_rbtree_key);
 
+	reserve_area(reserved_it_map, 0, IOVA_PFN(IOVA_START_ADDR));
+
 	/* IOAPIC ranges shouldn't be accessed by DMA */
-	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
-		IOVA_PFN(IOAPIC_RANGE_END));
-	if (!iova)
-		printk(KERN_ERR "Reserve IOAPIC range failed\n");
+	reserve_area(reserved_it_map, IOVA_PFN(IOAPIC_RANGE_START),
+		     IOVA_PFN(IOAPIC_RANGE_END));
 
 	/* Reserve all PCI MMIO to avoid peer-to-peer access */
 	for_each_pci_dev(pdev) {
@@ -1160,18 +1140,10 @@ static void dmar_init_reserved_ranges(void)
 			addr &= PAGE_MASK_4K;
 			size = r->end - addr;
 			size = PAGE_ALIGN_4K(size);
-			iova = reserve_iova(&reserved_iova_list, IOVA_PFN(addr),
-				IOVA_PFN(size + addr) - 1);
-			if (!iova)
-				printk(KERN_ERR "Reserve iova failed\n");
+			reserve_area(reserved_it_map, IOVA_PFN(addr),
+				     IOVA_PFN(size + addr) - 1);
 		}
 	}
-
-}
-
-static void domain_reserve_special_ranges(struct dmar_domain *domain)
-{
-	copy_reserved_iova(&reserved_iova_list, &domain->iovad);
 }
 
 static inline int guestwidth_to_adjustwidth(int gaw)
@@ -1191,38 +1163,52 @@ static inline int guestwidth_to_adjustwidth(int gaw)
 static int domain_init(struct dmar_domain *domain, int guest_width)
 {
 	struct intel_iommu *iommu;
-	int adjust_width, agaw;
+	int ret, adjust_width, agaw;
 	unsigned long sagaw;
 
-	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
 	spin_lock_init(&domain->mapping_lock);
 
-	domain_reserve_special_ranges(domain);
-
 	/* calculate AGAW */
 	iommu = domain->iommu;
+
 	if (guest_width > cap_mgaw(iommu->cap))
 		guest_width = cap_mgaw(iommu->cap);
 	domain->gaw = guest_width;
 	adjust_width = guestwidth_to_adjustwidth(guest_width);
 	agaw = width_to_agaw(adjust_width);
 	sagaw = cap_sagaw(iommu->cap);
+
+/* 	domain->it_size = 1UL << (guest_width - PAGE_SHIFT_4K); */
+	domain->it_size = 1UL << (32 - PAGE_SHIFT_4K);
+	domain->it_map = kzalloc(domain->it_size / BITS_PER_BYTE, GFP_ATOMIC);
+	if (!domain->it_map)
+		return -ENOMEM;
+
+	memcpy(domain->it_map, reserved_it_map, reserved_it_size / BITS_PER_BYTE);
+
 	if (!test_bit(agaw, &sagaw)) {
 		/* hardware doesn't support it, choose a bigger one */
 		pr_debug("IOMMU: hardware doesn't support agaw %d\n", agaw);
 		agaw = find_next_bit(&sagaw, 5, agaw);
-		if (agaw >= 5)
-			return -ENODEV;
+		if (agaw >= 5) {
+			ret = -ENODEV;
+			goto free_map;
+		}
 	}
 	domain->agaw = agaw;
 	INIT_LIST_HEAD(&domain->devices);
 
 	/* always allocate the top pgd */
 	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
-	if (!domain->pgd)
-		return -ENOMEM;
+	if (!domain->pgd) {
+		ret = -ENOMEM;
+		goto free_map;
+	}
 	__iommu_flush_cache(iommu, domain->pgd, PAGE_SIZE_4K);
 	return 0;
+free_map:
+	kfree(domain->it_map);
+	return ret;
 }
 
 static void domain_exit(struct dmar_domain *domain)
@@ -1234,8 +1220,7 @@ static void domain_exit(struct dmar_domain *domain)
 		return;
 
 	domain_remove_dev_info(domain);
-	/* destroy iovas */
-	put_iova_domain(&domain->iovad);
+	kfree(domain->it_map);
 	end = DOMAIN_MAX_ADDR(domain->gaw);
 	end = end & (~PAGE_MASK_4K);
 
@@ -1597,12 +1582,9 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev, u64 start, u64 end)
 	base = start & PAGE_MASK_4K;
 	size = end - base;
 	size = PAGE_ALIGN_4K(size);
-	if (!reserve_iova(&domain->iovad, IOVA_PFN(base),
-			IOVA_PFN(base + size) - 1)) {
-		printk(KERN_ERR "IOMMU: reserve iova failed\n");
-		ret = -ENOMEM;
-		goto error;
-	}
+
+	reserve_area(domain->it_map, IOVA_PFN(base),
+		     IOVA_PFN(base + size) - 1);
 
 	pr_debug("Mapping reserved region %lx@%llx for %s\n",
 		size, base, pci_name(pdev));
@@ -1722,14 +1704,6 @@ int __init init_dmars(void)
 		goto error;
 	}
 
-	deferred_flush = kzalloc(g_num_of_iommus *
-		sizeof(struct deferred_flush_tables), GFP_KERNEL);
-	if (!deferred_flush) {
-		kfree(g_iommus);
-		ret = -ENOMEM;
-		goto error;
-	}
-
 	i = 0;
 	for_each_drhd_unit(drhd) {
 		if (drhd->ignored)
@@ -1834,49 +1808,6 @@ static inline u64 aligned_size(u64 host_addr, size_t size)
 	return PAGE_ALIGN_4K(addr);
 }
 
-struct iova *
-iommu_alloc_iova(struct dmar_domain *domain, size_t size, u64 end)
-{
-	struct iova *piova;
-
-	/* Make sure it's in range */
-	end = min_t(u64, DOMAIN_MAX_ADDR(domain->gaw), end);
-	if (!size || (IOVA_START_ADDR + size > end))
-		return NULL;
-
-	piova = alloc_iova(&domain->iovad,
-			size >> PAGE_SHIFT_4K, IOVA_PFN(end), 1);
-	return piova;
-}
-
-static struct iova *
-__intel_alloc_iova(struct device *dev, struct dmar_domain *domain,
-		size_t size)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct iova *iova = NULL;
-
-	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
-		iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
-	} else  {
-		/*
-		 * First try to allocate an io virtual address in
-		 * DMA_32BIT_MASK and if that fails then try allocating
-		 * from higher range
-		 */
-		iova = iommu_alloc_iova(domain, size, DMA_32BIT_MASK);
-		if (!iova)
-			iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
-	}
-
-	if (!iova) {
-		printk(KERN_ERR"Allocating iova for %s failed", pci_name(pdev));
-		return NULL;
-	}
-
-	return iova;
-}
-
 static struct dmar_domain *
 get_valid_domain_for_dev(struct pci_dev *pdev)
 {
@@ -1905,15 +1836,53 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 	return domain;
 }
 
+static unsigned long intel_iommu_area_alloc(struct dmar_domain *domain,
+					    int pages)
+{
+	unsigned long start;
+	unsigned long flags;
+	int pass = 0;
+	unsigned long index, limit, boundary_size;
+
+	limit = domain->it_size;
+	start = domain->start;
+	boundary_size = 1UL << (32 - PAGE_SHIFT_4K);
+
+	spin_lock_irqsave(&domain->mapping_lock, flags);
+again:
+	index = iommu_area_alloc(domain->it_map, limit, start, pages,
+				 0, boundary_size, 0);
+	if (index == -1) {
+		if (!pass) {
+			if (!intel_iommu_strict)
+				iommu_flush_iotlb_dsi(domain->iommu,
+						      domain->id, 0);
+			start = 0;
+			pass++;
+			goto again;
+		}
+
+		spin_unlock_irqrestore(&domain->mapping_lock, flags);
+		return DMA_ERROR_CODE;
+	}
+
+	domain->start = index + pages;
+
+	spin_unlock_irqrestore(&domain->mapping_lock, flags);
+
+	return index;
+}
+
 static dma_addr_t
 intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
-	unsigned long start_paddr;
-	struct iova *iova;
+	unsigned long start_paddr, index;
 	int prot = 0;
 	int ret;
+	unsigned long flags;
+	int pages;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
@@ -1924,12 +1893,12 @@ intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
 		return 0;
 
 	size = aligned_size((u64)paddr, size);
+	pages = size >> PAGE_SHIFT_4K;
+	index = intel_iommu_area_alloc(domain, pages);
+	if (index == DMA_ERROR_CODE)
+		return 0;
 
-	iova = __intel_alloc_iova(hwdev, domain, size);
-	if (!iova)
-		goto error;
-
-	start_paddr = iova->pfn_lo << PAGE_SHIFT_4K;
+	start_paddr = index << PAGE_SHIFT_4K;
 
 	/*
 	 * Check if DMAR supports zero-length reads on write only
@@ -1957,91 +1926,36 @@ intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
 
 	/* it's a non-present to present mapping */
 	ret = iommu_flush_iotlb_psi(domain->iommu, domain->id,
-			start_paddr, size >> PAGE_SHIFT_4K, 1);
+			start_paddr, pages, 1);
 	if (ret)
 		iommu_flush_write_buffer(domain->iommu);
 
 	return (start_paddr + ((u64)paddr & (~PAGE_MASK_4K)));
 
 error:
-	if (iova)
-		__free_iova(&domain->iovad, iova);
+	spin_lock_irqsave(&domain->mapping_lock, flags);
+	iommu_area_free(domain->it_map, index, pages);
+	spin_unlock_irqrestore(&domain->mapping_lock, flags);
+
 	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
 		pci_name(pdev), size, (u64)paddr, dir);
 	return 0;
 }
 
-static void flush_unmaps(void)
-{
-	int i, j;
-
-	timer_on = 0;
-
-	/* just flush them all */
-	for (i = 0; i < g_num_of_iommus; i++) {
-		if (deferred_flush[i].next) {
-			iommu_flush_iotlb_global(&g_iommus[i], 0);
-			for (j = 0; j < deferred_flush[i].next; j++) {
-				__free_iova(&deferred_flush[i].domain[j]->iovad,
-						deferred_flush[i].iova[j]);
-			}
-			deferred_flush[i].next = 0;
-		}
-	}
-
-	list_size = 0;
-}
-
-static void flush_unmaps_timeout(unsigned long data)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&async_umap_flush_lock, flags);
-	flush_unmaps();
-	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
-}
-
-static void add_unmap(struct dmar_domain *dom, struct iova *iova)
-{
-	unsigned long flags;
-	int next, iommu_id;
-
-	spin_lock_irqsave(&async_umap_flush_lock, flags);
-	if (list_size == HIGH_WATER_MARK)
-		flush_unmaps();
-
-	iommu_id = dom->iommu - g_iommus;
-	next = deferred_flush[iommu_id].next;
-	deferred_flush[iommu_id].domain[next] = dom;
-	deferred_flush[iommu_id].iova[next] = iova;
-	deferred_flush[iommu_id].next++;
-
-	if (!timer_on) {
-		mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));
-		timer_on = 1;
-	}
-	list_size++;
-	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
-}
-
 static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
 	size_t size, int dir)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
 	unsigned long start_addr;
-	struct iova *iova;
+	unsigned long flags;
 
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
 
-	iova = find_iova(&domain->iovad, IOVA_PFN(dev_addr));
-	if (!iova)
-		return;
-
-	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	start_addr = dev_addr & ~(PAGE_SIZE_4K - 1);
 	size = aligned_size((u64)dev_addr, size);
 
 	pr_debug("Device %s unmapping: %lx@%llx\n",
@@ -2051,19 +1965,16 @@ static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
 	dma_pte_clear_range(domain, start_addr, start_addr + size);
 	/* free page tables */
 	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
-	if (intel_iommu_strict) {
-		if (iommu_flush_iotlb_psi(domain->iommu,
-			domain->id, start_addr, size >> PAGE_SHIFT_4K, 0))
-			iommu_flush_write_buffer(domain->iommu);
-		/* free iova */
-		__free_iova(&domain->iovad, iova);
-	} else {
-		add_unmap(domain, iova);
-		/*
-		 * queue up the release of the unmap to save the 1/6th of the
-		 * cpu used up by the iotlb flush operation...
-		 */
-	}
+
+	if (intel_iommu_strict && iommu_flush_iotlb_psi(domain->iommu,
+							domain->id, start_addr,
+							size >> PAGE_SHIFT_4K, 0))
+		iommu_flush_write_buffer(domain->iommu);
+
+	spin_lock_irqsave(&domain->mapping_lock, flags);
+	iommu_area_free(domain->it_map, start_addr >> PAGE_SHIFT_4K,
+			size >> PAGE_SHIFT_4K);
+	spin_unlock_irqrestore(&domain->mapping_lock, flags);
 }
 
 static void * intel_alloc_coherent(struct device *hwdev, size_t size,
@@ -2108,37 +2019,39 @@ static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
 	unsigned long start_addr;
-	struct iova *iova;
 	size_t size = 0;
 	void *addr;
 	struct scatterlist *sg;
+	unsigned index;
+	unsigned long flags;
 
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
 
-	iova = find_iova(&domain->iovad, IOVA_PFN(sglist[0].dma_address));
-	if (!iova)
-		return;
+	index = IOVA_PFN(sglist[0].dma_address);
+
 	for_each_sg(sglist, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		size += aligned_size((u64)addr, sg->length);
 	}
 
-	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	start_addr = index << PAGE_SHIFT_4K;
 
 	/*  clear the whole page */
 	dma_pte_clear_range(domain, start_addr, start_addr + size);
 	/* free page tables */
 	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
 
-	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
-			size >> PAGE_SHIFT_4K, 0))
+	if (intel_iommu_strict && iommu_flush_iotlb_psi(domain->iommu,
+							domain->id, start_addr,
+							size >> PAGE_SHIFT_4K, 0))
 		iommu_flush_write_buffer(domain->iommu);
 
-	/* free iova */
-	__free_iova(&domain->iovad, iova);
+	spin_lock_irqsave(&domain->mapping_lock, flags);
+	iommu_area_free(domain->it_map, index, size >> PAGE_SHIFT_4K);
+	spin_unlock_irqrestore(&domain->mapping_lock, flags);
 }
 
 static int intel_nontranslate_map_sg(struct device *hddev,
@@ -2165,10 +2078,12 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 	size_t size = 0;
 	int prot = 0;
 	size_t offset = 0;
-	struct iova *iova = NULL;
 	int ret;
 	struct scatterlist *sg;
 	unsigned long start_addr;
+	unsigned long index;
+	unsigned long flags;
+	int pages;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
@@ -2184,8 +2099,9 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 		size += aligned_size((u64)addr, sg->length);
 	}
 
-	iova = __intel_alloc_iova(hwdev, domain, size);
-	if (!iova) {
+	pages = size >> PAGE_SHIFT_4K;
+	index = intel_iommu_area_alloc(domain, pages);
+	if (index == DMA_ERROR_CODE) {
 		sglist->dma_length = 0;
 		return 0;
 	}
@@ -2200,7 +2116,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
 		prot |= DMA_PTE_WRITE;
 
-	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	start_addr = index << PAGE_SHIFT_4K;
 	offset = 0;
 	for_each_sg(sglist, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
@@ -2217,7 +2133,11 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 			dma_pte_free_pagetable(domain, start_addr,
 				  start_addr + offset);
 			/* free iova */
-			__free_iova(&domain->iovad, iova);
+			spin_lock_irqsave(&domain->mapping_lock, flags);
+
+			iommu_area_free(domain->it_map, index, pages);
+
+			spin_unlock_irqrestore(&domain->mapping_lock, flags);
 			return 0;
 		}
 		sg->dma_address = start_addr + offset +
@@ -2278,52 +2198,27 @@ static inline int iommu_devinfo_cache_init(void)
 	return ret;
 }
 
-static inline int iommu_iova_cache_init(void)
-{
-	int ret = 0;
-
-	iommu_iova_cache = kmem_cache_create("iommu_iova",
-					 sizeof(struct iova),
-					 0,
-					 SLAB_HWCACHE_ALIGN,
-
-					 NULL);
-	if (!iommu_iova_cache) {
-		printk(KERN_ERR "Couldn't create iova cache\n");
-		ret = -ENOMEM;
-	}
-
-	return ret;
-}
-
 static int __init iommu_init_mempool(void)
 {
 	int ret;
-	ret = iommu_iova_cache_init();
-	if (ret)
-		return ret;
 
 	ret = iommu_domain_cache_init();
 	if (ret)
-		goto domain_error;
+		return -ENOMEM;
 
 	ret = iommu_devinfo_cache_init();
-	if (!ret)
-		return ret;
-
-	kmem_cache_destroy(iommu_domain_cache);
-domain_error:
-	kmem_cache_destroy(iommu_iova_cache);
+	if (ret) {
+		kmem_cache_destroy(iommu_domain_cache);
+		return -ENOMEM;
+	}
 
-	return -ENOMEM;
+	return 0;
 }
 
 static void __init iommu_exit_mempool(void)
 {
 	kmem_cache_destroy(iommu_devinfo_cache);
 	kmem_cache_destroy(iommu_domain_cache);
-	kmem_cache_destroy(iommu_iova_cache);
-
 }
 
 void __init detect_intel_iommu(void)
@@ -2395,16 +2290,14 @@ int __init intel_iommu_init(void)
 	ret = init_dmars();
 	if (ret) {
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
-		put_iova_domain(&reserved_iova_list);
+		kfree(reserved_it_map);
 		iommu_exit_mempool();
 		return ret;
 	}
 	printk(KERN_INFO
-	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
+	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O (bitmap)\n");
 
-	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
 	return 0;
 }
-
diff --git a/drivers/pci/intel-iommu.h b/drivers/pci/intel-iommu.h
index afc0ad9..6102cfb 100644
--- a/drivers/pci/intel-iommu.h
+++ b/drivers/pci/intel-iommu.h
@@ -291,7 +291,10 @@ struct dmar_domain {
 	struct intel_iommu *iommu;	/* back pointer to owning iommu */
 
 	struct list_head devices; 	/* all devices' list */
-	struct iova_domain iovad;	/* iova's that belong to this domain */
+
+	unsigned long it_size;
+	unsigned long *it_map;
+	unsigned long start;
 
 	struct dma_pte	*pgd;		/* virtual address */
 	spinlock_t	mapping_lock;	/* page table lock */
