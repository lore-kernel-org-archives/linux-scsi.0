From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 14:07:47 +0900
Message-ID: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756801AbXJQFJG@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 2c941a204070ab32d92d40318a3196a7fb994c00 looks incomplete. The
helper functions like prepare_sg() need to support sg chaining too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc64/kernel/iommu.c        |    1 -
 arch/sparc64/kernel/iommu_common.c |   51 +++++++++++++++++++++---------------
 arch/sparc64/kernel/iommu_common.h |    1 +
 arch/sparc64/kernel/pci_sun4v.c    |    1 -
 4 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index db3ffcf..5d4e96d 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -10,7 +10,6 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
-#include <linux/scatterlist.h>
 
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index 12c93a3..d7ca900 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -12,18 +12,22 @@
  */
 
 #ifdef VERIFY_SG
-static int verify_lengths(struct scatterlist *sg, int nents, int npages)
+static int verify_lengths(struct scatterlist *sglist, int nents, int npages)
 {
 	int sg_len, dma_len;
 	int i, pgcount;
+	struct scatterlist *sg;
 
 	sg_len = 0;
-	for (i = 0; i < nents; i++)
-		sg_len += sg[i].length;
+	for_each_sg(sglist, sg, nents, i)
+		sg_len += sg->length;
 
 	dma_len = 0;
-	for (i = 0; i < nents && sg[i].dma_length; i++)
-		dma_len += sg[i].dma_length;
+	for_each_sg(sglist, sg, nents, i) {
+		if (!sg->dma_length)
+			break;
+		dma_len += sg->dma_length;
+	}
 
 	if (sg_len != dma_len) {
 		printk("verify_lengths: Error, different, sg[%d] dma[%d]\n",
@@ -32,13 +36,16 @@ static int verify_lengths(struct scatterlist *sg, int nents, int npages)
 	}
 
 	pgcount = 0;
-	for (i = 0; i < nents && sg[i].dma_length; i++) {
+	for_each_sg(sglist, sg, nents, i) {
 		unsigned long start, end;
 
-		start = sg[i].dma_address;
+		if (!sg->dma_length)
+			break;
+
+		start = sg->dma_address;
 		start = start & IO_PAGE_MASK;
 
-		end = sg[i].dma_address + sg[i].dma_length;
+		end = sg->dma_address + sg->dma_length;
 		end = (end + (IO_PAGE_SIZE - 1)) & IO_PAGE_MASK;
 
 		pgcount += ((end - start) >> IO_PAGE_SHIFT);
@@ -113,7 +120,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 		if (dlen > 0 && ((daddr & ~IO_PAGE_MASK) == 0))
 			iopte++;
 
-		sg++;
+		sg = sg_next(sg);
 		if (--nents <= 0)
 			break;
 		sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
@@ -147,7 +154,7 @@ static int verify_maps(struct scatterlist *sg, int nents, iopte_t *iopte)
 		nents = verify_one_map(dma_sg, &sg, nents, &iopte);
 		if (nents <= 0)
 			break;
-		dma_sg++;
+		dma_sg = sg_next(dma_sg);
 		if (dma_sg->dma_length == 0)
 			break;
 	}
@@ -169,22 +176,24 @@ static int verify_maps(struct scatterlist *sg, int nents, iopte_t *iopte)
 	return 0;
 }
 
-void verify_sglist(struct scatterlist *sg, int nents, iopte_t *iopte, int npages)
+void verify_sglist(struct scatterlist *sglist, int nents, iopte_t *iopte, int npages)
 {
-	if (verify_lengths(sg, nents, npages) < 0 ||
-	    verify_maps(sg, nents, iopte) < 0) {
+	struct scatterlist *sg;
+
+	if (verify_lengths(sglist, nents, npages) < 0 ||
+	    verify_maps(sglist, nents, iopte) < 0) {
 		int i;
 
 		printk("verify_sglist: Crap, messed up mappings, dumping, iodma at ");
-		printk("%016lx.\n", sg->dma_address & IO_PAGE_MASK);
+		printk("%016lx.\n", sglist->dma_address & IO_PAGE_MASK);
 
-		for (i = 0; i < nents; i++) {
+		for_each_sg(sglist, sg, nents, i) {
 			printk("sg(%d): page_addr(%p) off(%x) length(%x) "
-			       "dma_address[%016lx] dma_length[%016lx]\n",
+			       "dma_address[%016x] dma_length[%016x]\n",
 			       i,
-			       page_address(sg[i].page), sg[i].offset,
-			       sg[i].length,
-			       sg[i].dma_address, sg[i].dma_length);
+			       page_address(sg->page), sg->offset,
+			       sg->length,
+			       sg->dma_address, sg->dma_length);
 		}
 	}
 
@@ -205,12 +214,12 @@ unsigned long prepare_sg(struct scatterlist *sg, int nents)
 	while (--nents) {
 		unsigned long addr;
 
-		sg++;
+		sg = sg_next(sg);
 		addr = (unsigned long) (page_address(sg->page) + sg->offset);
 		if (! VCONTIG(prev, addr)) {
 			dma_sg->dma_address = dent_addr;
 			dma_sg->dma_length = dent_len;
-			dma_sg++;
+			dma_sg = sg_next(dma_sg);
 
 			dent_addr = ((dent_addr +
 				      dent_len +
diff --git a/arch/sparc64/kernel/iommu_common.h b/arch/sparc64/kernel/iommu_common.h
index ad79101..75b5a58 100644
--- a/arch/sparc64/kernel/iommu_common.h
+++ b/arch/sparc64/kernel/iommu_common.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/scatterlist.h>
 
 #include <asm/iommu.h>
 #include <asm/scatterlist.h>
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index cacacfa..119f8ef 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -13,7 +13,6 @@
 #include <linux/irq.h>
 #include <linux/msi.h>
 #include <linux/log2.h>
-#include <linux/scatterlist.h>
 
 #include <asm/iommu.h>
 #include <asm/irq.h>
-- 
1.5.2.4
