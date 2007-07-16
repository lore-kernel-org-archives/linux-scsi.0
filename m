From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/33] SPARC: sg chaining support
Date: Mon, 16 Jul 2007 11:47:27 +0200
Message-ID: <118457926823-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9332 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbXGPJsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:37 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, davem@davemloft.net

This updates the sparc iommu/pci dma mappers to sg chaining.

Cc: davem@davemloft.net
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/sparc/kernel/ioport.c      |   25 +++++++++++++------------
 arch/sparc/mm/io-unit.c         |   12 +++++++-----
 arch/sparc/mm/iommu.c           |   10 +++++-----
 arch/sparc/mm/sun4c.c           |   10 ++++++----
 include/asm-sparc/scatterlist.h |    2 ++
 5 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 62182d2..9c3ed88 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>		/* struct pci_dev */
 #include <linux/proc_fs.h>
+#include <linux/scatterlist.h>
 
 #include <asm/io.h>
 #include <asm/vaddrs.h>
@@ -717,19 +718,19 @@ void pci_unmap_page(struct pci_dev *hwdev,
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nents,
+int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
     int direction)
 {
+	struct scatterlist *sg;
 	int n;
 
 	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
-	for (n = 0; n < nents; n++) {
+	for_each_sg(sgl, sg, nents, n) {
 		BUG_ON(page_address(sg->page) == NULL);
 		sg->dvma_address =
 			virt_to_phys(page_address(sg->page)) + sg->offset;
 		sg->dvma_length = sg->length;
-		sg++;
 	}
 	return nents;
 }
@@ -738,19 +739,19 @@ int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nents,
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nents,
+void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
     int direction)
 {
+	struct scatterlist *sg;
 	int n;
 
 	BUG_ON(direction == PCI_DMA_NONE);
 	if (direction != PCI_DMA_TODEVICE) {
-		for (n = 0; n < nents; n++) {
+		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg->page) == NULL);
 			mmu_inval_dma_area(
 			    (unsigned long) page_address(sg->page),
 			    (sg->length + PAGE_SIZE-1) & PAGE_MASK);
-			sg++;
 		}
 	}
 }
@@ -789,34 +790,34 @@ void pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t ba, size_t
  * The same as pci_dma_sync_single_* but for a scatter-gather list,
  * same rules and usage.
  */
-void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg, int nents, int direction)
+void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int nents, int direction)
 {
+	struct scatterlist *sg;
 	int n;
 
 	BUG_ON(direction == PCI_DMA_NONE);
 	if (direction != PCI_DMA_TODEVICE) {
-		for (n = 0; n < nents; n++) {
+		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg->page) == NULL);
 			mmu_inval_dma_area(
 			    (unsigned long) page_address(sg->page),
 			    (sg->length + PAGE_SIZE-1) & PAGE_MASK);
-			sg++;
 		}
 	}
 }
 
-void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg, int nents, int direction)
+void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl, int nents, int direction)
 {
+	struct scatterlist *sg;
 	int n;
 
 	BUG_ON(direction == PCI_DMA_NONE);
 	if (direction != PCI_DMA_TODEVICE) {
-		for (n = 0; n < nents; n++) {
+		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg->page) == NULL);
 			mmu_inval_dma_area(
 			    (unsigned long) page_address(sg->page),
 			    (sg->length + PAGE_SIZE-1) & PAGE_MASK);
-			sg++;
 		}
 	}
 }
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index 4ccda77..71442fe 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -11,8 +11,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>	/* pte_offset_map => kmap_atomic */
 #include <linux/bitops.h>
+#include <linux/scatterlist.h>
 
-#include <asm/scatterlist.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/sbus.h>
@@ -144,8 +144,9 @@ static void iounit_get_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_bus
 	spin_lock_irqsave(&iounit->lock, flags);
 	while (sz != 0) {
 		--sz;
-		sg[sz].dvma_address = iounit_get_area(iounit, (unsigned long)page_address(sg[sz].page) + sg[sz].offset, sg[sz].length);
-		sg[sz].dvma_length = sg[sz].length;
+		sg->dvma_address = iounit_get_area(iounit, (unsigned long)page_address(sg->page) + sg->offset, sg->length);
+		sg->dvma_length = sg->length;
+		sg = sg_next(sg);
 	}
 	spin_unlock_irqrestore(&iounit->lock, flags);
 }
@@ -173,11 +174,12 @@ static void iounit_release_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_
 	spin_lock_irqsave(&iounit->lock, flags);
 	while (sz != 0) {
 		--sz;
-		len = ((sg[sz].dvma_address & ~PAGE_MASK) + sg[sz].length + (PAGE_SIZE-1)) >> PAGE_SHIFT;
-		vaddr = (sg[sz].dvma_address - IOUNIT_DMA_BASE) >> PAGE_SHIFT;
+		len = ((sg->dvma_address & ~PAGE_MASK) + sg->length + (PAGE_SIZE-1)) >> PAGE_SHIFT;
+		vaddr = (sg->dvma_address - IOUNIT_DMA_BASE) >> PAGE_SHIFT;
 		IOD(("iounit_release %08lx-%08lx\n", (long)vaddr, (long)len+vaddr));
 		for (len += vaddr; vaddr < len; vaddr++)
 			clear_bit(vaddr, iounit->bmap);
+		sg = sg_next(sg);
 	}
 	spin_unlock_irqrestore(&iounit->lock, flags);
 }
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index be042ef..0534cd0 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -12,8 +12,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>	/* pte_offset_map => kmap_atomic */
+#include <linux/scatterlist.h>
 
-#include <asm/scatterlist.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/sbus.h>
@@ -240,7 +240,7 @@ static void iommu_get_scsi_sgl_noflush(struct scatterlist *sg, int sz, struct sb
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
 		sg->dvma_address = iommu_get_one(sg->page, n, sbus) + sg->offset;
 		sg->dvma_length = (__u32) sg->length;
-		sg++;
+		sg = sg_next(sg);
 	}
 }
 
@@ -254,7 +254,7 @@ static void iommu_get_scsi_sgl_gflush(struct scatterlist *sg, int sz, struct sbu
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
 		sg->dvma_address = iommu_get_one(sg->page, n, sbus) + sg->offset;
 		sg->dvma_length = (__u32) sg->length;
-		sg++;
+		sg = sg_next(sg);
 	}
 }
 
@@ -285,7 +285,7 @@ static void iommu_get_scsi_sgl_pflush(struct scatterlist *sg, int sz, struct sbu
 
 		sg->dvma_address = iommu_get_one(sg->page, n, sbus) + sg->offset;
 		sg->dvma_length = (__u32) sg->length;
-		sg++;
+		sg = sg_next(sg);
 	}
 }
 
@@ -325,7 +325,7 @@ static void iommu_release_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_b
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
 		iommu_release_one(sg->dvma_address & PAGE_MASK, n, sbus);
 		sg->dvma_address = 0x21212121;
-		sg++;
+		sg = sg_next(sg);
 	}
 }
 
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index 436021c..e5c703b 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -17,8 +17,8 @@
 #include <linux/highmem.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/scatterlist.h>
 
-#include <asm/scatterlist.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -1229,8 +1229,9 @@ static void sun4c_get_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_bus *
 {
 	while (sz != 0) {
 		--sz;
-		sg[sz].dvma_address = (__u32)sun4c_lockarea(page_address(sg[sz].page) + sg[sz].offset, sg[sz].length);
-		sg[sz].dvma_length = sg[sz].length;
+		sg->dvma_address = (__u32)sun4c_lockarea(page_address(sg->page) + sg->offset, sg->length);
+		sg->dvma_length = sg->length;
+		sg = sg_next(sg);
 	}
 }
 
@@ -1245,7 +1246,8 @@ static void sun4c_release_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_b
 {
 	while (sz != 0) {
 		--sz;
-		sun4c_unlockarea((char *)sg[sz].dvma_address, sg[sz].length);
+		sun4c_unlockarea((char *)sg->dvma_address, sg->length);
+		sg = sg_next(sg);
 	}
 }
 
diff --git a/include/asm-sparc/scatterlist.h b/include/asm-sparc/scatterlist.h
index a4fcf9a..4055af9 100644
--- a/include/asm-sparc/scatterlist.h
+++ b/include/asm-sparc/scatterlist.h
@@ -19,4 +19,6 @@ struct scatterlist {
 
 #define ISA_DMA_THRESHOLD (~0UL)
 
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* !(_SPARC_SCATTERLIST_H) */
-- 
1.5.3.rc0.90.gbaa79

