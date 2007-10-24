From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 07/11] sparc64: make iommu respect the segment size
 limits
Date: Wed, 24 Oct 2007 19:48:23 +0900
Message-ID: <20071024172026D.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37718 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXJXKsu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:48:50 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp

This patch makes iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc64/kernel/iommu.c        |    2 +-
 arch/sparc64/kernel/iommu_common.c |    8 ++++++--
 arch/sparc64/kernel/iommu_common.h |    3 ++-
 arch/sparc64/kernel/pci_sun4v.c    |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index 070a484..4b9115a 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -580,7 +580,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 
 	/* Step 1: Prepare scatter list. */
 
-	npages = prepare_sg(sglist, nelems);
+	npages = prepare_sg(dev, sglist, nelems);
 
 	/* Step 2: Allocate a cluster and context, if necessary. */
 
diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index b70324e..62c3218 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -4,6 +4,7 @@
  * Copyright (C) 1999 David S. Miller (davem@redhat.com)
  */
 
+#include <linux/dma-mapping.h>
 #include "iommu_common.h"
 
 /* You are _strongly_ advised to enable the following debugging code
@@ -201,21 +202,24 @@ void verify_sglist(struct scatterlist *sglist, int nents, iopte_t *iopte, int np
 }
 #endif
 
-unsigned long prepare_sg(struct scatterlist *sg, int nents)
+unsigned long prepare_sg(struct device *dev, struct scatterlist *sg, int nents)
 {
 	struct scatterlist *dma_sg = sg;
 	unsigned long prev;
 	u32 dent_addr, dent_len;
+	unsigned int max_seg_size;
 
 	prev  = (unsigned long) sg_virt(sg);
 	prev += (unsigned long) (dent_len = sg->length);
 	dent_addr = (u32) ((unsigned long)(sg_virt(sg)) & (IO_PAGE_SIZE - 1UL));
+	max_seg_size = dma_get_max_seg_size(dev);
 	while (--nents) {
 		unsigned long addr;
 
 		sg = sg_next(sg);
 		addr = (unsigned long) sg_virt(sg);
-		if (! VCONTIG(prev, addr)) {
+		if (! VCONTIG(prev, addr) ||
+			dent_len + sg->length > max_seg_size) {
 			dma_sg->dma_address = dent_addr;
 			dma_sg->dma_length = dent_len;
 			dma_sg = sg_next(dma_sg);
diff --git a/arch/sparc64/kernel/iommu_common.h b/arch/sparc64/kernel/iommu_common.h
index 75b5a58..a90d046 100644
--- a/arch/sparc64/kernel/iommu_common.h
+++ b/arch/sparc64/kernel/iommu_common.h
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/device.h>
 
 #include <asm/iommu.h>
 #include <asm/scatterlist.h>
@@ -46,4 +47,4 @@ extern void verify_sglist(struct scatterlist *sg, int nents, iopte_t *iopte, int
 #define VCONTIG(__X, __Y)	(((__X) == (__Y)) || \
 				 (((__X) | (__Y)) << (64UL - PAGE_SHIFT)) == 0UL)
 
-extern unsigned long prepare_sg(struct scatterlist *sg, int nents);
+extern unsigned long prepare_sg(struct device *dev, struct scatterlist *sg, int nents);
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 8c4875b..cc03021 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -490,7 +490,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 		goto bad;
 
 	/* Step 1: Prepare scatter list. */
-	npages = prepare_sg(sglist, nelems);
+	npages = prepare_sg(dev, sglist, nelems);
 
 	/* Step 2: Allocate a cluster and context, if necessary. */
 	spin_lock_irqsave(&iommu->lock, flags);
-- 
1.5.2.4

