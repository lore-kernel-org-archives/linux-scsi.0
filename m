From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 04:10:04 -0700 (PDT)
Message-ID: <20071017.041004.21594558.davem@davemloft.net>
References: <20071017.035441.74746708.davem@davemloft.net>
	<20071017105840.GT5043@kernel.dk>
	<20071017110142.GU5043@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47332
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761587AbXJQLJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 07:09:50 -0400
In-Reply-To: <20071017110142.GU5043@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 13:01:42 +0200

> Actually, just clearing AFTER sg_next() would be fine, since we know
> that is not a link entry. Duh...

Yes and I'm running a kernel successfully with this fix.

Jens, please also add the following on top of Fujita-san's most recent
sparc64 patch and we should be good to go.

>From 0f6e2c3085ec57df78b249a8722323692f33a1b2 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@sunset.davemloft.net>
Date: Wed, 17 Oct 2007 04:08:48 -0700
Subject: [PATCH] [SPARC64]: Fix loop terminating conditions in fill_sg().

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/iommu.c     |   12 +++++++-----
 arch/sparc64/kernel/pci_sun4v.c |   15 ++++++++-------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index 5d4e96d..29af777 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -475,12 +475,11 @@ static void dma_4u_unmap_single(struct device *dev, dma_addr_t bus_addr,
 #define SG_ENT_PHYS_ADDRESS(SG)	\
 	(__pa(page_address((SG)->page)) + (SG)->offset)
 
-static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
-			   int nused, int nelems,
-			   unsigned long iopte_protection)
+static void fill_sg(iopte_t *iopte, struct scatterlist *sg,
+		    int nused, int nelems,
+		    unsigned long iopte_protection)
 {
 	struct scatterlist *dma_sg = sg;
-	struct scatterlist *sg_end = sg_last(sg, nelems);
 	int i;
 
 	for (i = 0; i < nused; i++) {
@@ -516,6 +515,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 					break;
 				}
 				sg = sg_next(sg);
+				nelems--;
 			}
 
 			pteval = iopte_protection | (pteval & IOPTE_PAGE);
@@ -529,18 +529,20 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 
 			pteval = (pteval & IOPTE_PAGE) + len;
 			sg = sg_next(sg);
+			nelems--;
 
 			/* Skip over any tail mappings we've fully mapped,
 			 * adjusting pteval along the way.  Stop when we
 			 * detect a page crossing event.
 			 */
-			while (sg != sg_end &&
+			while (nelems &&
 			       (pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
 			       (pteval == SG_ENT_PHYS_ADDRESS(sg)) &&
 			       ((pteval ^
 				 (SG_ENT_PHYS_ADDRESS(sg) + sg->length - 1UL)) >> IO_PAGE_SHIFT) == 0UL) {
 				pteval += sg->length;
 				sg = sg_next(sg);
+				nelems--;
 			}
 			if ((pteval << (64 - IO_PAGE_SHIFT)) == 0UL)
 				pteval = ~0UL;
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 119f8ef..fe46ace 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -368,12 +368,11 @@ static void dma_4v_unmap_single(struct device *dev, dma_addr_t bus_addr,
 #define SG_ENT_PHYS_ADDRESS(SG)	\
 	(__pa(page_address((SG)->page)) + (SG)->offset)
 
-static inline long fill_sg(long entry, struct device *dev,
-			   struct scatterlist *sg,
-			   int nused, int nelems, unsigned long prot)
+static long fill_sg(long entry, struct device *dev,
+		    struct scatterlist *sg,
+		    int nused, int nelems, unsigned long prot)
 {
 	struct scatterlist *dma_sg = sg;
-	struct scatterlist *sg_end = sg_last(sg, nelems);
 	unsigned long flags;
 	int i;
 
@@ -414,6 +413,7 @@ static inline long fill_sg(long entry, struct device *dev,
 					break;
 				}
 				sg = sg_next(sg);
+				nelems--;
 			}
 
 			pteval = (pteval & IOPTE_PAGE);
@@ -432,19 +432,20 @@ static inline long fill_sg(long entry, struct device *dev,
 
 			pteval = (pteval & IOPTE_PAGE) + len;
 			sg = sg_next(sg);
+			nelems--;
 
 			/* Skip over any tail mappings we've fully mapped,
 			 * adjusting pteval along the way.  Stop when we
 			 * detect a page crossing event.
 			 */
-			while ((pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
+			while (nelems &&
+			       (pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
 			       (pteval == SG_ENT_PHYS_ADDRESS(sg)) &&
 			       ((pteval ^
 				 (SG_ENT_PHYS_ADDRESS(sg) + sg->length - 1UL)) >> IO_PAGE_SHIFT) == 0UL) {
 				pteval += sg->length;
-				if (sg == sg_end)
-					break;
 				sg = sg_next(sg);
+				nelems--;
 			}
 			if ((pteval << (64 - IO_PAGE_SHIFT)) == 0UL)
 				pteval = ~0UL;
-- 
1.5.3.4

