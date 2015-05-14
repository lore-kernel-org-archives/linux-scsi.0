From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC/PATCH] powerpc/iommu: Support "hybrid" iommu/direct DMA ops
 for coherent_mask < dma_mask
Date: Thu, 14 May 2015 17:43:13 +1000
Message-ID: <1431589393.4160.47.camel@kernel.crashing.org>
References: <555279A8.6060906@linux.vnet.ibm.com>
	 <2214146.EzgWBA6g23@wuerfel> <5553505D.50102@linux.vnet.ibm.com>
	 <10045033.4fV0qQU90u@wuerfel> <55535BDF.6020502@linux.vnet.ibm.com>
	 <CAK=zhgoXx4HJfpTuNAP0tAPnsU8BLmM7X3qGsFCzJfHOx55YCQ@mail.gmail.com>
	 <1431550613.20218.88.camel@kernel.crashing.org>
	 <5553C428.5090806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:47553 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbbENHnn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2015 03:43:43 -0400
In-Reply-To: <5553C428.5090806@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org, Daniel Kreling <kreling@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

This patch adds the ability to the DMA direct ops to fallback to the IOMMU
ops for coherent alloc/free if the coherent mask of the device isn't
suitable for accessing the direct DMA space and the device also happens
to have an active IOMMU table.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 9f1371b..9ce2199 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -10,6 +10,7 @@ struct dma_map_ops;
 struct device_node;
 #ifdef CONFIG_PPC64
 struct pci_dn;
+struct iommu_table;
 #endif
 
 /*
@@ -23,13 +24,15 @@ struct dev_archdata {
 	struct dma_map_ops	*dma_ops;
 
 	/*
-	 * When an iommu is in use, dma_data is used as a ptr to the base of the
-	 * iommu_table.  Otherwise, it is a simple numerical offset.
+	 * These two used to be a union. However, with the hybrid ops we need
+	 * both so here we store both a DMA offset for direct mappings and
+	 * an iommu_table for remapped DMA.
 	 */
-	union {
-		dma_addr_t	dma_offset;
-		void		*iommu_table_base;
-	} dma_data;
+	dma_addr_t		dma_offset;
+
+#ifdef CONFIG_PPC64
+	struct iommu_table	*iommu_table_base;
+#endif
 
 #ifdef CONFIG_IOMMU_API
 	void			*iommu_domain;
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 894d538..2e12366 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -21,12 +21,12 @@
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
 
 /* Some dma direct funcs must be visible for use in other dma_ops */
-extern void *dma_direct_alloc_coherent(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag,
+extern void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
+					 dma_addr_t *dma_handle, gfp_t flag,
+					 struct dma_attrs *attrs);
+extern void __dma_direct_free_coherent(struct device *dev, size_t size,
+				       void *vaddr, dma_addr_t dma_handle,
 				       struct dma_attrs *attrs);
-extern void dma_direct_free_coherent(struct device *dev, size_t size,
-				     void *vaddr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs);
 extern int dma_direct_mmap_coherent(struct device *dev,
 				    struct vm_area_struct *vma,
 				    void *cpu_addr, dma_addr_t handle,
@@ -106,7 +106,7 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 static inline dma_addr_t get_dma_offset(struct device *dev)
 {
 	if (dev)
-		return dev->archdata.dma_data.dma_offset;
+		return dev->archdata.dma_offset;
 
 	return PCI_DRAM_OFFSET;
 }
@@ -114,7 +114,7 @@ static inline dma_addr_t get_dma_offset(struct device *dev)
 static inline void set_dma_offset(struct device *dev, dma_addr_t off)
 {
 	if (dev)
-		dev->archdata.dma_data.dma_offset = off;
+		dev->archdata.dma_offset = off;
 }
 
 /* this will be removed soon */
diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index e2abbe8..157cfdd 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -2,17 +2,17 @@
  * Copyright (C) 2001 Mike Corrigan & Dave Engebretsen, IBM Corporation
  * Rewrite, cleanup:
  * Copyright (C) 2004 Olof Johansson <olof@lixom.net>, IBM Corporation
- * 
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- * 
+ *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- * 
+ *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
@@ -93,14 +93,17 @@ int get_iommu_order(unsigned long size, struct iommu_table *tbl)
 
 struct scatterlist;
 
-static inline void set_iommu_table_base(struct device *dev, void *base)
+#ifdef CONFIG_PPC64
+
+static inline void set_iommu_table_base(struct device *dev,
+					struct iommu_table *base)
 {
-	dev->archdata.dma_data.iommu_table_base = base;
+	dev->archdata.iommu_table_base = base;
 }
 
 static inline void *get_iommu_table_base(struct device *dev)
 {
-	return dev->archdata.dma_data.iommu_table_base;
+	return dev->archdata.iommu_table_base;
 }
 
 /* Frees table for an individual device node */
@@ -146,6 +149,15 @@ static inline void set_iommu_table_base_and_group(struct device *dev,
 	iommu_add_device(dev);
 }
 
+#else
+
+static inline void *get_iommu_table_base(struct device *dev)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_PPC64 */
+
 extern int ppc_iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 			    struct scatterlist *sglist, int nelems,
 			    unsigned long mask,
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index 7359797..81b81cd 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -47,8 +47,8 @@ static u64 swiotlb_powerpc_get_required(struct device *dev)
  * for everything else.
  */
 struct dma_map_ops swiotlb_dma_ops = {
-	.alloc = dma_direct_alloc_coherent,
-	.free = dma_direct_free_coherent,
+	.alloc = __dma_direct_alloc_coherent,
+	.free = __dma_direct_free_coherent,
 	.mmap = dma_direct_mmap_coherent,
 	.map_sg = swiotlb_map_sg_attrs,
 	.unmap_sg = swiotlb_unmap_sg_attrs,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 484b2d4..08b0724 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -16,6 +16,7 @@
 #include <asm/bug.h>
 #include <asm/machdep.h>
 #include <asm/swiotlb.h>
+#include <asm/iommu.h>
 
 /*
  * Generic direct DMA implementation
@@ -39,9 +40,31 @@ static u64 __maybe_unused get_pfn_limit(struct device *dev)
 	return pfn;
 }
 
-void *dma_direct_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag,
-				struct dma_attrs *attrs)
+static int dma_direct_dma_supported(struct device *dev, u64 mask)
+{
+#ifdef CONFIG_PPC64
+	u64 limit = get_dma_offset(dev) + (memblock_end_of_DRAM() - 1);
+
+	/* Limit fits in the mask, we are good */
+	if (mask >= limit)
+		return 1;
+
+#ifdef CONFIG_FSL_SOC
+	/* Freescale gets another chance via ZONE_DMA/ZONE_DMA32, however
+	 * that will have to be refined if/when they support iommus
+	 */
+	return 1;
+#endif
+	/* Sorry ... */
+	return 0;
+#else
+	return 1;
+#endif
+}
+
+void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
+				  dma_addr_t *dma_handle, gfp_t flag,
+				  struct dma_attrs *attrs)
 {
 	void *ret;
 #ifdef CONFIG_NOT_COHERENT_CACHE
@@ -96,9 +119,9 @@ void *dma_direct_alloc_coherent(struct device *dev, size_t size,
 #endif
 }
 
-void dma_direct_free_coherent(struct device *dev, size_t size,
-			      void *vaddr, dma_addr_t dma_handle,
-			      struct dma_attrs *attrs)
+void __dma_direct_free_coherent(struct device *dev, size_t size,
+				void *vaddr, dma_addr_t dma_handle,
+				struct dma_attrs *attrs)
 {
 #ifdef CONFIG_NOT_COHERENT_CACHE
 	__dma_free_coherent(size, vaddr);
@@ -107,6 +130,51 @@ void dma_direct_free_coherent(struct device *dev, size_t size,
 #endif
 }
 
+static void *dma_direct_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag,
+				       struct dma_attrs *attrs)
+{
+	struct iommu_table *iommu;
+
+	/* The coherent mask may be smaller than the real mask, check if
+	 * we can really use the direct ops
+	 */
+	if (dma_direct_dma_supported(dev, dev->coherent_dma_mask))
+		return __dma_direct_alloc_coherent(dev, size, dma_handle,
+						   flag, attrs);
+
+	/* Ok we can't ... do we have an iommu ? If not, fail */
+	iommu = get_iommu_table_base(dev);
+	if (!iommu)
+		return NULL;
+
+	/* Try to use the iommu */
+	return iommu_alloc_coherent(dev, iommu, size, dma_handle,
+				    dev->coherent_dma_mask, flag,
+				    dev_to_node(dev));
+}
+
+static void dma_direct_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t dma_handle,
+				     struct dma_attrs *attrs)
+{
+	struct iommu_table *iommu;
+
+	/* See comments in dma_direct_alloc_coherent() */
+	if (dma_direct_dma_supported(dev, dev->coherent_dma_mask))
+		return __dma_direct_free_coherent(dev, size, vaddr, dma_handle,
+						  attrs);
+	/* Maybe we used an iommu ... */
+	iommu = get_iommu_table_base(dev);
+
+	/* If we hit that we should have never allocated in the first
+	 * place so how come we are freeing ?
+	 */
+	if (WARN_ON(!iommu))
+		return;
+	iommu_free_coherent(iommu, size, vaddr, dma_handle);
+}
+
 int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
 			     void *cpu_addr, dma_addr_t handle, size_t size,
 			     struct dma_attrs *attrs)
@@ -147,18 +215,6 @@ static void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sg,
 {
 }
 
-static int dma_direct_dma_supported(struct device *dev, u64 mask)
-{
-#ifdef CONFIG_PPC64
-	/* Could be improved so platforms can set the limit in case
-	 * they have limited DMA windows
-	 */
-	return mask >= get_dma_offset(dev) + (memblock_end_of_DRAM() - 1);
-#else
-	return 1;
-#endif
-}
-
 static u64 dma_direct_get_required_mask(struct device *dev)
 {
 	u64 end, mask;
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 5ac7c60..fcff6fa 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1625,7 +1625,6 @@ static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,
 	} else {
 		dev_info(&pdev->dev, "Using 32-bit DMA via iommu\n");
 		set_dma_ops(&pdev->dev, &dma_iommu_ops);
-		set_iommu_table_base(&pdev->dev, pe->tce32_table);
 	}
 	*pdev->dev.dma_mask = dma_mask;
 	return 0;
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 7803a19..0acab86 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1161,11 +1161,10 @@ static int dma_set_mask_pSeriesLP(struct device *dev, u64 dma_mask)
 		}
 	}
 
-	/* fall back on iommu ops, restore table pointer with ops */
+	/* fall back on iommu ops */
 	if (!ddw_enabled && get_dma_ops(dev) != &dma_iommu_ops) {
 		dev_info(dev, "Restoring 32-bit DMA via iommu\n");
 		set_dma_ops(dev, &dma_iommu_ops);
-		pci_dma_dev_setup_pSeriesLP(pdev);
 	}
 
 check_mask:
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index 9e5353f..6cf033d 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -306,20 +306,11 @@ static void iommu_table_dart_setup(void)
 	set_bit(iommu_table_dart.it_size - 1, iommu_table_dart.it_map);
 }
 
-static void dma_dev_setup_dart(struct device *dev)
-{
-	/* We only have one iommu table on the mac for now, which makes
-	 * things simple. Setup all PCI devices to point to this table
-	 */
-	if (get_dma_ops(dev) == &dma_direct_ops)
-		set_dma_offset(dev, DART_U4_BYPASS_BASE);
-	else
-		set_iommu_table_base(dev, &iommu_table_dart);
-}
-
 static void pci_dma_dev_setup_dart(struct pci_dev *dev)
 {
-	dma_dev_setup_dart(&dev->dev);
+	if (dart_is_u4)
+		set_dma_offset(&dev->dev, DART_U4_BYPASS_BASE);
+	set_iommu_table_base(&dev->dev, &iommu_table_dart);
 }
 
 static void pci_dma_bus_setup_dart(struct pci_bus *bus)
@@ -363,7 +354,6 @@ static int dart_dma_set_mask(struct device *dev, u64 dma_mask)
 		dev_info(dev, "Using 32-bit DMA via iommu\n");
 		set_dma_ops(dev, &dma_iommu_ops);
 	}
-	dma_dev_setup_dart(dev);
 
 	*dev->dma_mask = dma_mask;
 	return 0;


