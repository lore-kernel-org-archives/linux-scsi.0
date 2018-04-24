From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/5] PCI: remove PCI_DMA_BUS_IS_PHYS
Date: Tue, 24 Apr 2018 20:16:25 +0200
Message-ID: <20180424181625.22410-6-hch@lst.de>
References: <20180424181625.22410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180424181625.22410-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This was used by the ide, scsi and networking code in the past to
determine if they should bounce payloads.  Now that the dma mapping
always have to support dma to all physical memory (thanks to swiotlb
for non-iommu systems) there is no need to this crude hack any more.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 arch/alpha/include/asm/pci.h      |  5 -----
 arch/arc/include/asm/pci.h        |  6 ------
 arch/arm/include/asm/pci.h        |  7 -------
 arch/arm64/include/asm/pci.h      |  5 -----
 arch/h8300/include/asm/pci.h      |  2 --
 arch/hexagon/kernel/dma.c         |  1 -
 arch/ia64/hp/common/sba_iommu.c   |  3 ---
 arch/ia64/include/asm/pci.h       | 17 -----------------
 arch/ia64/kernel/setup.c          | 12 ------------
 arch/ia64/sn/kernel/io_common.c   |  5 -----
 arch/m68k/include/asm/pci.h       |  6 ------
 arch/microblaze/include/asm/pci.h |  6 ------
 arch/mips/include/asm/pci.h       |  7 -------
 arch/parisc/include/asm/pci.h     | 23 -----------------------
 arch/parisc/kernel/setup.c        |  5 -----
 arch/powerpc/include/asm/pci.h    | 18 ------------------
 arch/riscv/include/asm/pci.h      |  3 ---
 arch/s390/include/asm/pci.h       |  2 --
 arch/s390/pci/pci_dma.c           |  2 --
 arch/sh/include/asm/pci.h         |  6 ------
 arch/sh/kernel/dma-nommu.c        |  1 -
 arch/sparc/include/asm/pci_32.h   |  4 ----
 arch/sparc/include/asm/pci_64.h   |  6 ------
 arch/x86/include/asm/pci.h        |  3 ---
 arch/xtensa/include/asm/pci.h     |  2 --
 drivers/parisc/ccio-dma.c         |  2 --
 drivers/parisc/sba_iommu.c        |  2 --
 include/asm-generic/pci.h         |  8 --------
 include/linux/dma-mapping.h       |  1 -
 lib/dma-direct.c                  |  1 -
 tools/virtio/linux/dma-mapping.h  |  2 --
 31 files changed, 173 deletions(-)

diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index b9ec55351924..cf6bc1e64d66 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -56,11 +56,6 @@ struct pci_controller {
 
 /* IOMMU controls.  */
 
-/* The PCI address space does not equal the physical memory address space.
-   The networking and block device layers use this boolean for bounce buffer
-   decisions.  */
-#define PCI_DMA_BUS_IS_PHYS  0
-
 /* TODO: integrate with include/asm-generic/pci.h ? */
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
diff --git a/arch/arc/include/asm/pci.h b/arch/arc/include/asm/pci.h
index ba56c23c1b20..4ff53c041c64 100644
--- a/arch/arc/include/asm/pci.h
+++ b/arch/arc/include/asm/pci.h
@@ -16,12 +16,6 @@
 #define PCIBIOS_MIN_MEM 0x100000
 
 #define pcibios_assign_all_busses()	1
-/*
- * The PCI address space does equal the physical memory address space.
- * The networking and block device layers use this boolean for bounce
- * buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	1
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 1f0de808d111..0abd389cf0ec 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -19,13 +19,6 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
-/*
- * The PCI address space does equal the physical memory address space.
- * The networking and block device layers use this boolean for bounce
- * buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS     (1)
-
 #define HAVE_PCI_MMAP
 #define ARCH_GENERIC_PCI_MMAP_RESOURCE
 
diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
index 8747f7c5e0e7..9e690686e8aa 100644
--- a/arch/arm64/include/asm/pci.h
+++ b/arch/arm64/include/asm/pci.h
@@ -18,11 +18,6 @@
 #define pcibios_assign_all_busses() \
 	(pci_has_flag(PCI_REASSIGN_ALL_BUS))
 
-/*
- * PCI address space differs from physical memory address space
- */
-#define PCI_DMA_BUS_IS_PHYS	(0)
-
 #define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
 
 extern int isa_dma_bridge_buggy;
diff --git a/arch/h8300/include/asm/pci.h b/arch/h8300/include/asm/pci.h
index 7c9e55d62215..d4d345a52092 100644
--- a/arch/h8300/include/asm/pci.h
+++ b/arch/h8300/include/asm/pci.h
@@ -15,6 +15,4 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
 	/* We don't do dynamic PCI IRQ allocation */
 }
 
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
 #endif /* _ASM_H8300_PCI_H */
diff --git a/arch/hexagon/kernel/dma.c b/arch/hexagon/kernel/dma.c
index ad8347c29dcf..77459df34e2e 100644
--- a/arch/hexagon/kernel/dma.c
+++ b/arch/hexagon/kernel/dma.c
@@ -208,7 +208,6 @@ const struct dma_map_ops hexagon_dma_ops = {
 	.sync_single_for_cpu = hexagon_sync_single_for_cpu,
 	.sync_single_for_device = hexagon_sync_single_for_device,
 	.mapping_error	= hexagon_mapping_error,
-	.is_phys	= 1,
 };
 
 void __init hexagon_dma_init(void)
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index aec4a3354abe..6f05aba9012f 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1845,9 +1845,6 @@ static void ioc_init(unsigned long hpa, struct ioc *ioc)
 	ioc_resource_init(ioc);
 	ioc_sac_init(ioc);
 
-	if ((long) ~iovp_mask > (long) ia64_max_iommu_merge_mask)
-		ia64_max_iommu_merge_mask = ~iovp_mask;
-
 	printk(KERN_INFO PFX
 		"%s %d.%d HPA 0x%lx IOVA space %dMb at 0x%lx\n",
 		ioc->name, (ioc->rev >> 4) & 0xF, ioc->rev & 0xF,
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index b1d04e8bafc8..780e8744ba85 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -30,23 +30,6 @@ struct pci_vector_struct {
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
 
-/*
- * PCI_DMA_BUS_IS_PHYS should be set to 1 if there is _necessarily_ a direct
- * correspondence between device bus addresses and CPU physical addresses.
- * Platforms with a hardware I/O MMU _must_ turn this off to suppress the
- * bounce buffer handling code in the block and network device layers.
- * Platforms with separate bus address spaces _must_ turn this off and provide
- * a device DMA mapping implementation that takes care of the necessary
- * address translation.
- *
- * For now, the ia64 platforms which may have separate/multiple bus address
- * spaces all have I/O MMUs which support the merging of physically
- * discontiguous buffers, so we can use that as the sole factor to determine
- * the setting of PCI_DMA_BUS_IS_PHYS.
- */
-extern unsigned long ia64_max_iommu_merge_mask;
-#define PCI_DMA_BUS_IS_PHYS	(ia64_max_iommu_merge_mask == ~0UL)
-
 #define HAVE_PCI_MMAP
 #define ARCH_GENERIC_PCI_MMAP_RESOURCE
 #define arch_can_pci_mmap_wc()	1
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index dee56bcb993d..ad43cbf70628 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -123,18 +123,6 @@ unsigned long ia64_i_cache_stride_shift = ~0;
 #define	CACHE_STRIDE_SHIFT	5
 unsigned long ia64_cache_stride_shift = ~0;
 
-/*
- * The merge_mask variable needs to be set to (max(iommu_page_size(iommu)) - 1).  This
- * mask specifies a mask of address bits that must be 0 in order for two buffers to be
- * mergeable by the I/O MMU (i.e., the end address of the first buffer and the start
- * address of the second buffer must be aligned to (merge_mask+1) in order to be
- * mergeable).  By default, we assume there is no I/O MMU which can merge physically
- * discontiguous buffers, so we set the merge_mask to ~0UL, which corresponds to a iommu
- * page-size of 2^64.
- */
-unsigned long ia64_max_iommu_merge_mask = ~0UL;
-EXPORT_SYMBOL(ia64_max_iommu_merge_mask);
-
 /*
  * We use a special marker for the end of memory and it uses the extra (+1) slot
  */
diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index 11f2275570fb..8479e9a7ce16 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -480,11 +480,6 @@ sn_io_early_init(void)
 	tioca_init_provider();
 	tioce_init_provider();
 
-	/*
-	 * This is needed to avoid bounce limit checks in the blk layer
-	 */
-	ia64_max_iommu_merge_mask = ~PAGE_MASK;
-
 	sn_irq_lh_init();
 	INIT_LIST_HEAD(&sn_sysdata_list);
 	sn_init_cpei_timer();
diff --git a/arch/m68k/include/asm/pci.h b/arch/m68k/include/asm/pci.h
index ef26fae8cf0b..5a4bc223743b 100644
--- a/arch/m68k/include/asm/pci.h
+++ b/arch/m68k/include/asm/pci.h
@@ -4,12 +4,6 @@
 
 #include <asm-generic/pci.h>
 
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
 #define	pcibios_assign_all_busses()	1
 
 #define	PCIBIOS_MIN_IO		0x00000100
diff --git a/arch/microblaze/include/asm/pci.h b/arch/microblaze/include/asm/pci.h
index 5de871eb4a59..00337861472e 100644
--- a/arch/microblaze/include/asm/pci.h
+++ b/arch/microblaze/include/asm/pci.h
@@ -62,12 +62,6 @@ extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 
 #define HAVE_PCI_LEGACY	1
 
-/* The PCI address space does equal the physical memory
- * address space (no IOMMU).  The IDE and SCSI device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS     (1)
-
 extern void pcibios_claim_one_bus(struct pci_bus *b);
 
 extern void pcibios_finish_adding_to_bus(struct pci_bus *bus);
diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index 2339f42f047a..436099883022 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -121,13 +121,6 @@ extern unsigned long PCIBIOS_MIN_MEM;
 #include <linux/string.h>
 #include <asm/io.h>
 
-/*
- * The PCI address space does equal the physical memory address space.
- * The networking and block device layers use this boolean for bounce
- * buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS     (1)
-
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
 static inline int pci_proc_domain(struct pci_bus *bus)
 {
diff --git a/arch/parisc/include/asm/pci.h b/arch/parisc/include/asm/pci.h
index 96b7deec512d..3328fd17c19d 100644
--- a/arch/parisc/include/asm/pci.h
+++ b/arch/parisc/include/asm/pci.h
@@ -87,29 +87,6 @@ struct pci_hba_data {
 #define PCI_F_EXTEND		0UL
 #endif /* !CONFIG_64BIT */
 
-/*
- * If the PCI device's view of memory is the same as the CPU's view of memory,
- * PCI_DMA_BUS_IS_PHYS is true.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#ifdef CONFIG_PA20
-/* All PA-2.0 machines have an IOMMU. */
-#define PCI_DMA_BUS_IS_PHYS	0
-#define parisc_has_iommu()	do { } while (0)
-#else
-
-#if defined(CONFIG_IOMMU_CCIO) || defined(CONFIG_IOMMU_SBA)
-extern int parisc_bus_is_phys; 	/* in arch/parisc/kernel/setup.c */
-#define PCI_DMA_BUS_IS_PHYS	parisc_bus_is_phys
-#define parisc_has_iommu()	do { parisc_bus_is_phys = 0; } while (0)
-#else
-#define PCI_DMA_BUS_IS_PHYS	1
-#define parisc_has_iommu()	do { } while (0)
-#endif
-
-#endif	/* !CONFIG_PA20 */
-
-
 /*
 ** Most PCI devices (eg Tulip, NCR720) also export the same registers
 ** to both MMIO and I/O port space.  Due to poor performance of I/O Port
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index 0e9675f857a5..8d3a7b80ac42 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -58,11 +58,6 @@ struct proc_dir_entry * proc_runway_root __read_mostly = NULL;
 struct proc_dir_entry * proc_gsc_root __read_mostly = NULL;
 struct proc_dir_entry * proc_mckinley_root __read_mostly = NULL;
 
-#if !defined(CONFIG_PA20) && (defined(CONFIG_IOMMU_CCIO) || defined(CONFIG_IOMMU_SBA))
-int parisc_bus_is_phys __read_mostly = 1;	/* Assume no IOMMU is present */
-EXPORT_SYMBOL(parisc_bus_is_phys);
-#endif
-
 void __init setup_cmdline(char **cmdline_p)
 {
 	extern unsigned int boot_args[];
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index 401c62aad5e4..2af9ded80540 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -92,24 +92,6 @@ extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 
 #define HAVE_PCI_LEGACY	1
 
-#ifdef CONFIG_PPC64
-
-/* The PCI address space does not equal the physical memory address
- * space (we have an IOMMU).  The IDE and SCSI device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(0)
-
-#else /* 32-bit */
-
-/* The PCI address space does equal the physical memory
- * address space (no IOMMU).  The IDE and SCSI device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS     (1)
-
-#endif /* CONFIG_PPC64 */
-
 extern void pcibios_claim_one_bus(struct pci_bus *b);
 
 extern void pcibios_finish_adding_to_bus(struct pci_bus *bus);
diff --git a/arch/riscv/include/asm/pci.h b/arch/riscv/include/asm/pci.h
index 0f2fc9ef20fc..b3638c505728 100644
--- a/arch/riscv/include/asm/pci.h
+++ b/arch/riscv/include/asm/pci.h
@@ -26,9 +26,6 @@
 /* RISC-V shim does not initialize PCI bus */
 #define pcibios_assign_all_busses() 1
 
-/* We do not have an IOMMU */
-#define PCI_DMA_BUS_IS_PHYS 1
-
 extern int isa_dma_bridge_buggy;
 
 #ifdef CONFIG_PCI
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 12fe3591034f..94f8db468c9b 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -2,8 +2,6 @@
 #ifndef __ASM_S390_PCI_H
 #define __ASM_S390_PCI_H
 
-/* must be set before including asm-generic/pci.h */
-#define PCI_DMA_BUS_IS_PHYS (0)
 /* must be set before including pci_clp.h */
 #define PCI_BAR_COUNT	6
 
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 2d15d84c20ed..10abf5ed6187 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -685,8 +685,6 @@ const struct dma_map_ops s390_pci_dma_ops = {
 	.map_page	= s390_dma_map_pages,
 	.unmap_page	= s390_dma_unmap_pages,
 	.mapping_error	= s390_mapping_error,
-	/* if we support direct DMA this must be conditional */
-	.is_phys	= 0,
 	/* dma_supported is unconditionally true without a callback */
 };
 EXPORT_SYMBOL_GPL(s390_pci_dma_ops);
diff --git a/arch/sh/include/asm/pci.h b/arch/sh/include/asm/pci.h
index 0033f0df2b3b..10a36b1cf2ea 100644
--- a/arch/sh/include/asm/pci.h
+++ b/arch/sh/include/asm/pci.h
@@ -71,12 +71,6 @@ extern unsigned long PCIBIOS_MIN_IO, PCIBIOS_MIN_MEM;
  * SuperH has everything mapped statically like x86.
  */
 
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(dma_ops->is_phys)
-
 #ifdef CONFIG_PCI
 /*
  * None of the SH PCI controllers support MWI, it is always treated as a
diff --git a/arch/sh/kernel/dma-nommu.c b/arch/sh/kernel/dma-nommu.c
index 178457d7620c..3e3a32fc676e 100644
--- a/arch/sh/kernel/dma-nommu.c
+++ b/arch/sh/kernel/dma-nommu.c
@@ -78,7 +78,6 @@ const struct dma_map_ops nommu_dma_ops = {
 	.sync_single_for_device	= nommu_sync_single_for_device,
 	.sync_sg_for_device	= nommu_sync_sg_for_device,
 #endif
-	.is_phys		= 1,
 };
 
 void __init no_iommu_init(void)
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index 98917e48727d..cfc0ee9476c6 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -17,10 +17,6 @@
 
 #define PCI_IRQ_NONE		0xffffffff
 
-/* Dynamic DMA mapping stuff.
- */
-#define PCI_DMA_BUS_IS_PHYS	(0)
-
 #endif /* __KERNEL__ */
 
 #ifndef CONFIG_LEON_PCI
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 671274e36cfa..fac77813402c 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -17,12 +17,6 @@
 
 #define PCI_IRQ_NONE		0xffffffff
 
-/* The PCI address space does not equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(0)
-
 /* PCI IOMMU mapping bypass support. */
 
 /* PCI 64-bit addressing works for all slots on all controller
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d32175e30259..662963681ea6 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -117,9 +117,6 @@ void native_restore_msi_irqs(struct pci_dev *dev);
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
 #endif
-
-#define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
-
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
diff --git a/arch/xtensa/include/asm/pci.h b/arch/xtensa/include/asm/pci.h
index d5a82153a7c5..6ddf0a30c60d 100644
--- a/arch/xtensa/include/asm/pci.h
+++ b/arch/xtensa/include/asm/pci.h
@@ -42,8 +42,6 @@ extern struct pci_controller* pcibios_alloc_controller(void);
  * decisions.
  */
 
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
 /* Tell PCI code what kind of PCI resource mappings we support */
 #define HAVE_PCI_MMAP			1
 #define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index acba1f56af3e..2b129d8525d5 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1596,8 +1596,6 @@ static int __init ccio_probe(struct parisc_device *dev)
 	}
 #endif
 	ioc_count++;
-
-	parisc_has_iommu();
 	return 0;
 }
 
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 0a9c762a70fa..a58c586ebd81 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -2017,8 +2017,6 @@ static int __init sba_driver_callback(struct parisc_device *dev)
 	proc_create("sba_iommu", 0, root, &sba_proc_fops);
 	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
 #endif
-
-	parisc_has_iommu();
 	return 0;
 }
 
diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index 830d7659289b..6bb3cd3d695a 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -14,12 +14,4 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 #endif /* HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ */
 
-/*
- * By default, assume that no iommu is in use and that the PCI
- * space is mapped to address physical 0.
- */
-#ifndef PCI_DMA_BUS_IS_PHYS
-#define PCI_DMA_BUS_IS_PHYS	(1)
-#endif
-
 #endif /* _ASM_GENERIC_PCI_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 14269d25498b..25a9a2b04f78 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -133,7 +133,6 @@ struct dma_map_ops {
 #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
 	u64 (*get_required_mask)(struct device *dev);
 #endif
-	int is_phys;
 };
 
 extern const struct dma_map_ops dma_direct_ops;
diff --git a/lib/dma-direct.c b/lib/dma-direct.c
index bbfb229aa067..ebfee14ed2df 100644
--- a/lib/dma-direct.c
+++ b/lib/dma-direct.c
@@ -180,6 +180,5 @@ const struct dma_map_ops dma_direct_ops = {
 	.map_sg			= dma_direct_map_sg,
 	.dma_supported		= dma_direct_supported,
 	.mapping_error		= dma_direct_mapping_error,
-	.is_phys		= 1,
 };
 EXPORT_SYMBOL(dma_direct_ops);
diff --git a/tools/virtio/linux/dma-mapping.h b/tools/virtio/linux/dma-mapping.h
index 1571e24e9494..f91aeb5fe571 100644
--- a/tools/virtio/linux/dma-mapping.h
+++ b/tools/virtio/linux/dma-mapping.h
@@ -6,8 +6,6 @@
 # error Virtio userspace code does not support CONFIG_HAS_DMA
 #endif
 
-#define PCI_DMA_BUS_IS_PHYS 1
-
 enum dma_data_direction {
 	DMA_BIDIRECTIONAL = 0,
 	DMA_TO_DEVICE = 1,
-- 
2.17.0
