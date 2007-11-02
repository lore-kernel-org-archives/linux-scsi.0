From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/3] move iova cache code to iova.c
Date: Sat, 3 Nov 2007 02:05:43 +0900
Message-ID: <20071103020425T.tomof@acm.org>
References: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60979 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbXKBRHQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Nov 2007 13:07:16 -0400
In-Reply-To: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, muli@il.ibm.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp

This detaches iova cache code from intel-iommu.c to iova.c in order to
enable IOMMUs to use iova code.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/intel-iommu.c |   14 ++------------
 include/linux/iova.h      |    6 +++---
 lib/iova.c                |   34 ++++++++++++++++++++++++++++------
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1a23b4c..0c41d79 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -141,16 +141,6 @@ static inline void free_devinfo_mem(void *vaddr)
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
@@ -1087,7 +1077,7 @@ static void dmar_init_reserved_ranges(void)
 	int i;
 	u64 addr, size;
 
-	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
+	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN, iommu_iova_cache);
 
 	/* IOAPIC ranges shouldn't be accessed by DMA */
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
@@ -1141,7 +1131,7 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 	int adjust_width, agaw;
 	unsigned long sagaw;
 
-	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
+	init_iova_domain(&domain->iovad, DMA_32BIT_PFN, iommu_iova_cache);
 	spin_lock_init(&domain->mapping_lock);
 
 	domain_reserve_special_ranges(domain);
diff --git a/include/linux/iova.h b/include/linux/iova.h
index d521b5b..41f189b 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -32,10 +32,9 @@ struct iova_domain {
 	struct rb_root	rbroot;		/* iova domain rbtree root */
 	struct rb_node	*cached32_node; /* Save last alloced node */
 	unsigned long	dma_32bit_pfn;
+	struct kmem_cache *iova_cachep;
 };
 
-struct iova *alloc_iova_mem(void);
-void free_iova_mem(struct iova *iova);
 void free_iova(struct iova_domain *iovad, unsigned long pfn);
 void __free_iova(struct iova_domain *iovad, struct iova *iova);
 struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
@@ -44,7 +43,8 @@ struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
 struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 	unsigned long pfn_hi);
 void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
-void init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit);
+void init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit,
+		      struct kmem_cache *iova_cachep);
 struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
 void put_iova_domain(struct iova_domain *iovad);
 
diff --git a/lib/iova.c b/lib/iova.c
index 6e14a3f..d2612e5 100644
--- a/lib/iova.c
+++ b/lib/iova.c
@@ -6,16 +6,38 @@
  * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
+#include <linux/sched.h>
 #include <linux/iova.h>
 
+static struct iova *alloc_iova_mem(struct iova_domain *iovad)
+{
+	unsigned int flags;
+	void *vaddr;
+
+	/* trying to avoid low memory issues */
+	flags = current->flags & PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
+	vaddr = kmem_cache_alloc(iovad->iova_cachep, GFP_ATOMIC);
+	current->flags &= (~PF_MEMALLOC | flags);
+
+	return vaddr;
+}
+
+static void free_iova_mem(struct iova_domain *iovad, struct iova *iova)
+{
+	kmem_cache_free(iovad->iova_cachep, iova);
+}
+
 void
-init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit)
+init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit,
+		 struct kmem_cache *iova_cachep)
 {
 	spin_lock_init(&iovad->iova_alloc_lock);
 	spin_lock_init(&iovad->iova_rbtree_lock);
 	iovad->rbroot = RB_ROOT;
 	iovad->cached32_node = NULL;
 	iovad->dma_32bit_pfn = pfn_32bit;
+	iovad->iova_cachep = iova_cachep;
 }
 
 static struct rb_node *
@@ -160,7 +182,7 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
 	struct iova *new_iova;
 	int ret;
 
-	new_iova = alloc_iova_mem();
+	new_iova = alloc_iova_mem(iovad);
 	if (!new_iova)
 		return NULL;
 
@@ -176,7 +198,7 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
 
 	if (ret) {
 		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
-		free_iova_mem(new_iova);
+		free_iova_mem(iovad, new_iova);
 		return NULL;
 	}
 
@@ -246,7 +268,7 @@ __free_iova(struct iova_domain *iovad, struct iova *iova)
 	__cached_rbnode_delete_update(iovad, iova);
 	rb_erase(&iova->node, &iovad->rbroot);
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-	free_iova_mem(iova);
+	free_iova_mem(iovad, iova);
 }
 
 /**
@@ -280,7 +302,7 @@ void put_iova_domain(struct iova_domain *iovad)
 	while (node) {
 		struct iova *iova = container_of(node, struct iova, node);
 		rb_erase(node, &iovad->rbroot);
-		free_iova_mem(iova);
+		free_iova_mem(iovad, iova);
 		node = rb_first(&iovad->rbroot);
 	}
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
@@ -303,7 +325,7 @@ __insert_new_range(struct iova_domain *iovad,
 {
 	struct iova *iova;
 
-	iova = alloc_iova_mem();
+	iova = alloc_iova_mem(iovad);
 	if (!iova)
 		return iova;
 
-- 
1.5.2.4

