From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/33] IA64: sg chaining support
Date: Mon, 16 Jul 2007 11:47:25 +0200
Message-ID: <11845792683994-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9295 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759635AbXGPJsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:37 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, tony.luck@intel.com

This updates the ia64 iommu/pci dma mappers to sg chaining.

Cc: tony.luck@intel.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/ia64/hp/common/sba_iommu.c |   14 +++++++-------
 arch/ia64/sn/pci/pci_dma.c      |   11 ++++++-----
 include/asm-ia64/dma-mapping.h  |    1 +
 include/asm-ia64/scatterlist.h  |    2 ++
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index c1dca22..f6d15cf 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -393,7 +393,7 @@ sba_dump_sg( struct ioc *ioc, struct scatterlist *startsg, int nents)
 		printk(KERN_DEBUG " %d : DMA %08lx/%05x CPU %p\n", nents,
 		       startsg->dma_address, startsg->dma_length,
 		       sba_sg_address(startsg));
-		startsg++;
+		startsg = sg_next(startsg);
 	}
 }
 
@@ -406,7 +406,7 @@ sba_check_sg( struct ioc *ioc, struct scatterlist *startsg, int nents)
 	while (the_nents-- > 0) {
 		if (sba_sg_address(the_sg) == 0x0UL)
 			sba_dump_sg(NULL, startsg, nents);
-		the_sg++;
+		the_sg = sg_next(the_sg);
 	}
 }
 
@@ -1198,7 +1198,7 @@ sba_fill_pdir(
 			u32 pide = startsg->dma_address & ~PIDE_FLAG;
 			dma_offset = (unsigned long) pide & ~iovp_mask;
 			startsg->dma_address = 0;
-			dma_sg++;
+			dma_sg = sg_next(dma_sg);
 			dma_sg->dma_address = pide | ioc->ibase;
 			pdirp = &(ioc->pdir_base[pide >> iovp_shift]);
 			n_mappings++;
@@ -1225,7 +1225,7 @@ sba_fill_pdir(
 				pdirp++;
 			} while (cnt > 0);
 		}
-		startsg++;
+		startsg = sg_next(startsg);
 	}
 	/* force pdir update */
 	wmb();
@@ -1294,7 +1294,7 @@ sba_coalesce_chunks( struct ioc *ioc,
 		while (--nents > 0) {
 			unsigned long vaddr;	/* tmp */
 
-			startsg++;
+			startsg = sg_next(startsg);
 
 			/* PARANOID */
 			startsg->dma_address = startsg->dma_length = 0;
@@ -1404,7 +1404,7 @@ int sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents, int di
 #ifdef ALLOW_IOV_BYPASS_SG
 	ASSERT(to_pci_dev(dev)->dma_mask);
 	if (likely((ioc->dma_mask & ~to_pci_dev(dev)->dma_mask) == 0)) {
-		for (sg = sglist ; filled < nents ; filled++, sg++){
+		for_each_sg(sglist, sg, nents, filled) {
 			sg->dma_length = sg->length;
 			sg->dma_address = virt_to_phys(sba_sg_address(sg));
 		}
@@ -1498,7 +1498,7 @@ void sba_unmap_sg (struct device *dev, struct scatterlist *sglist, int nents, in
 	while (nents && sglist->dma_length) {
 
 		sba_unmap_single(dev, sglist->dma_address, sglist->dma_length, dir);
-		sglist++;
+		sglist = sg_next(sglist);
 		nents--;
 	}
 
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index d79ddac..ecd8a52 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -218,16 +218,17 @@ EXPORT_SYMBOL(sn_dma_unmap_single);
  *
  * Unmap a set of streaming mode DMA translations.
  */
-void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 		     int nhwentries, int direction)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	struct scatterlist *sg;
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
-	for (i = 0; i < nhwentries; i++, sg++) {
+	for_each_sg(sgl, sg, nhwentries, i) {
 		provider->dma_unmap(pdev, sg->dma_address, direction);
 		sg->dma_address = (dma_addr_t) NULL;
 		sg->dma_length = 0;
@@ -244,11 +245,11 @@ EXPORT_SYMBOL(sn_dma_unmap_sg);
  *
  * Maps each entry of @sg for DMA.
  */
-int sn_dma_map_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
 		  int direction)
 {
 	unsigned long phys_addr;
-	struct scatterlist *saved_sg = sg;
+	struct scatterlist *saved_sg = sgl, *sg;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	int i;
@@ -258,7 +259,7 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	/*
 	 * Setup a DMA address for each entry in the scatterlist.
 	 */
-	for (i = 0; i < nhwentries; i++, sg++) {
+	for_each_sg(sgl, sg, nhwentries, i) {
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
 		sg->dma_address = provider->dma_map(pdev,
 						    phys_addr, sg->length,
diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
index 6299b51..aeba8da 100644
--- a/include/asm-ia64/dma-mapping.h
+++ b/include/asm-ia64/dma-mapping.h
@@ -5,6 +5,7 @@
  * Copyright (C) 2003-2004 Hewlett-Packard Co
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
+#include <linux/scatterlist.h>
 #include <asm/machvec.h>
 
 #define dma_alloc_coherent	platform_dma_alloc_coherent
diff --git a/include/asm-ia64/scatterlist.h b/include/asm-ia64/scatterlist.h
index a452ea2..7d5234d 100644
--- a/include/asm-ia64/scatterlist.h
+++ b/include/asm-ia64/scatterlist.h
@@ -30,4 +30,6 @@ struct scatterlist {
 #define sg_dma_len(sg)		((sg)->dma_length)
 #define sg_dma_address(sg)	((sg)->dma_address)
 
+#define	ARCH_HAS_SG_CHAIN
+
 #endif /* _ASM_IA64_SCATTERLIST_H */
-- 
1.5.3.rc0.90.gbaa79

