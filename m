From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg helpers
Date: Mon, 16 Jul 2007 11:47:23 +0200
Message-ID: <11845792681830-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420AbXGPJsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:36 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, ak@suse.de

This prepares x86-64 for sg chaining support.

Additional improvements/fixups for pci-gart from
Benny Halevy <bhalevy@panasas.com>

Cc: ak@suse.de
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
 arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
 arch/x86_64/kernel/pci-nommu.c   |    5 ++-
 3 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 5bd20b5..c472b14 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -35,6 +35,7 @@
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/scatterlist.h>
 #include <asm/proto.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -341,17 +342,19 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 static void __calgary_unmap_sg(struct iommu_table *tbl,
 	struct scatterlist *sglist, int nelems, int direction)
 {
-	while (nelems--) {
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sglist, s, nelems, i) {
 		unsigned int npages;
-		dma_addr_t dma = sglist->dma_address;
-		unsigned int dmalen = sglist->dma_length;
+		dma_addr_t dma = s->dma_address;
+		unsigned int dmalen = s->dma_length;
 
 		if (dmalen == 0)
 			break;
 
 		npages = num_dma_pages(dma, dmalen);
 		__iommu_free(tbl, dma, npages);
-		sglist++;
 	}
 }
 
@@ -374,10 +377,10 @@ void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
 static int calgary_nontranslate_map_sg(struct device* dev,
 	struct scatterlist *sg, int nelems, int direction)
 {
+	struct scatterlist *s;
 	int i;
 
- 	for (i = 0; i < nelems; i++ ) {
-		struct scatterlist *s = &sg[i];
+	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!s->page);
 		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
 		s->dma_length = s->length;
@@ -389,6 +392,7 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct scatterlist *s;
 	unsigned long flags;
 	unsigned long vaddr;
 	unsigned int npages;
@@ -400,8 +404,7 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	for (i = 0; i < nelems; i++ ) {
-		struct scatterlist *s = &sg[i];
+	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!s->page);
 
 		vaddr = (unsigned long)page_address(s->page) + s->offset;
@@ -428,9 +431,9 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	return nelems;
 error:
 	__calgary_unmap_sg(tbl, sg, nelems, direction);
-	for (i = 0; i < nelems; i++) {
-		sg[i].dma_address = bad_dma_address;
-		sg[i].dma_length = 0;
+	for_each_sg(sg, s, nelems, i) {
+		s->dma_address = bad_dma_address;
+		s->dma_length = 0;
 	}
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 	return 0;
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index ae091cd..b16384f 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/kdebug.h>
+#include <linux/scatterlist.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -277,10 +278,10 @@ void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
  */
 void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 {
+	struct scatterlist *s;
 	int i;
 
-	for (i = 0; i < nents; i++) {
-		struct scatterlist *s = &sg[i];
+	for_each_sg(sg, s, nents, i) {
 		if (!s->dma_length || !s->length)
 			break;
 		gart_unmap_single(dev, s->dma_address, s->dma_length, dir);
@@ -291,14 +292,14 @@ void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int di
 static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 			       int nents, int dir)
 {
+	struct scatterlist *s;
 	int i;
 
 #ifdef CONFIG_IOMMU_DEBUG
 	printk(KERN_DEBUG "dma_map_sg overflow\n");
 #endif
 
- 	for (i = 0; i < nents; i++ ) {
-		struct scatterlist *s = &sg[i];
+	for_each_sg(sg, s, nents, i) {
 		unsigned long addr = page_to_phys(s->page) + s->offset; 
 		if (nonforced_iommu(dev, addr, s->length)) { 
 			addr = dma_map_area(dev, addr, s->length, dir);
@@ -318,23 +319,23 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 }
 
 /* Map multiple scatterlist entries continuous into the first. */
-static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
+static int __dma_map_cont(struct scatterlist *start, int nelems,
 		      struct scatterlist *sout, unsigned long pages)
 {
 	unsigned long iommu_start = alloc_iommu(pages);
 	unsigned long iommu_page = iommu_start; 
+	struct scatterlist *s;
 	int i;
 
 	if (iommu_start == -1)
 		return -1;
-	
-	for (i = start; i < stopat; i++) {
-		struct scatterlist *s = &sg[i];
+
+	for_each_sg(start, s, nelems, i) {
 		unsigned long pages, addr;
 		unsigned long phys_addr = s->dma_address;
 		
-		BUG_ON(i > start && s->offset);
-		if (i == start) {
+		BUG_ON(s != start && s->offset);
+		if (s == start) {
 			*sout = *s; 
 			sout->dma_address = iommu_bus_base;
 			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
@@ -356,17 +357,17 @@ static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
 	return 0;
 }
 
-static inline int dma_map_cont(struct scatterlist *sg, int start, int stopat,
+static inline int dma_map_cont(struct scatterlist *start, int nelems,
 		      struct scatterlist *sout,
 		      unsigned long pages, int need)
 {
-	if (!need) { 
-		BUG_ON(stopat - start != 1);
-		*sout = sg[start]; 
-		sout->dma_length = sg[start].length; 
+	if (!need) {
+		BUG_ON(nelems != 1);
+		*sout = *start;
+		sout->dma_length = start->length;
 		return 0;
-	} 
-	return __dma_map_cont(sg, start, stopat, sout, pages);
+	}
+	return __dma_map_cont(start, nelems, sout, pages);
 }
 		
 /*
@@ -380,6 +381,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 	int start;
 	unsigned long pages = 0;
 	int need = 0, nextneed;
+	struct scatterlist *s, *ps, *start_sg, *sgmap;
 
 	if (nents == 0) 
 		return 0;
@@ -389,8 +391,9 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 	out = 0;
 	start = 0;
-	for (i = 0; i < nents; i++) {
-		struct scatterlist *s = &sg[i];
+	start_sg = sgmap = sg;
+	ps = NULL; /* shut up gcc */
+	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = page_to_phys(s->page) + s->offset;
 		s->dma_address = addr;
 		BUG_ON(s->length == 0); 
@@ -399,29 +402,31 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 		/* Handle the previous not yet processed entries */
 		if (i > start) {
-			struct scatterlist *ps = &sg[i-1];
 			/* Can only merge when the last chunk ends on a page 
 			   boundary and the new one doesn't have an offset. */
 			if (!iommu_merge || !nextneed || !need || s->offset ||
-			    (ps->offset + ps->length) % PAGE_SIZE) { 
-				if (dma_map_cont(sg, start, i, sg+out, pages,
-						 need) < 0)
+			    (ps->offset + ps->length) % PAGE_SIZE) {
+				if (dma_map_cont(start_sg, i - start, sgmap,
+						  pages, need) < 0)
 					goto error;
 				out++;
+				sgmap = sg_next(sgmap);
 				pages = 0;
-				start = i;	
+				start = i;
+				start_sg = s;
 			}
 		}
 
 		need = nextneed;
 		pages += to_pages(s->offset, s->length);
+		ps = s;
 	}
-	if (dma_map_cont(sg, start, i, sg+out, pages, need) < 0)
+	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
 		goto error;
 	out++;
 	flush_gart();
-	if (out < nents) 
-		sg[out].dma_length = 0; 
+	if (out < nents)
+		ps->dma_length = 0;
 	return out;
 
 error:
@@ -436,8 +441,8 @@ error:
 	if (panic_on_overflow)
 		panic("dma_map_sg: overflow on %lu pages\n", pages);
 	iommu_full(dev, pages << PAGE_SHIFT, dir);
-	for (i = 0; i < nents; i++)
-		sg[i].dma_address = bad_dma_address;
+	for_each_sg(sg, s, nents, i)
+		s->dma_address = bad_dma_address;
 	return 0;
 } 
 
diff --git a/arch/x86_64/kernel/pci-nommu.c b/arch/x86_64/kernel/pci-nommu.c
index 6dade0c..24c9faf 100644
--- a/arch/x86_64/kernel/pci-nommu.c
+++ b/arch/x86_64/kernel/pci-nommu.c
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
 
 #include <asm/proto.h>
 #include <asm/processor.h>
@@ -57,10 +58,10 @@ void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
 int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	       int nents, int direction)
 {
+	struct scatterlist *s;
 	int i;
 
- 	for (i = 0; i < nents; i++ ) {
-		struct scatterlist *s = &sg[i];
+	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!s->page);
 		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
-- 
1.5.3.rc0.90.gbaa79

