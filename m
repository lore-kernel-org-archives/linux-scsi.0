From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/3] move iova from drivers/pci/ to lib/
Date: Sat, 3 Nov 2007 02:05:41 +0900
Message-ID: <20071103020236A.tomof@acm.org>
References: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:33007 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764AbXKBRKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Nov 2007 13:10:45 -0400
In-Reply-To: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, muli@il.ibm.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp

iova could be used by several IOMMUs. This patch just moves iova from
drivers/pci/ to lib/ and fixes the appropriate Makefile and Kconfig
files.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/Kconfig.x86_64   |    1 +
 drivers/pci/Makefile      |    2 +-
 drivers/pci/intel-iommu.c |    1 -
 drivers/pci/intel-iommu.h |    2 +-
 drivers/pci/iova.c        |  394 ---------------------------------------------
 drivers/pci/iova.h        |   51 ------
 include/linux/iova.h      |   51 ++++++
 lib/Kconfig               |    3 +
 lib/Makefile              |    2 +
 lib/iova.c                |  394 +++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 453 insertions(+), 448 deletions(-)
 delete mode 100644 drivers/pci/iova.c
 delete mode 100644 drivers/pci/iova.h
 create mode 100644 include/linux/iova.h
 create mode 100644 lib/iova.c

diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index cc468ea..c10d3f0 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -749,6 +749,7 @@ config PCI_DOMAINS
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
+	select IOVA
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 5550556..00c3428 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -21,7 +21,7 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
 # Build Intel IOMMU support
-obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
+obj-$(CONFIG_DMAR) += dmar.o intel-iommu.o
 
 #
 # Some architectures use the generic PCI setup functions
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index dc1edbd..1a23b4c 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -30,7 +30,6 @@
 #include <linux/dmar.h>
 #include <linux/dma-mapping.h>
 #include <linux/mempool.h>
-#include "iova.h"
 #include "intel-iommu.h"
 #include <asm/proto.h> /* force_iommu in this header in x86-64*/
 #include <asm/cacheflush.h>
diff --git a/drivers/pci/intel-iommu.h b/drivers/pci/intel-iommu.h
index f54efd1..750e1b5 100644
--- a/drivers/pci/intel-iommu.h
+++ b/drivers/pci/intel-iommu.h
@@ -23,7 +23,7 @@
 
 #include <linux/types.h>
 #include <linux/msi.h>
-#include "iova.h"
+#include <linux/iova.h>
 #include <linux/io.h>
 
 /*
diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
deleted file mode 100644
index 8de7ab6..0000000
--- a/drivers/pci/iova.c
+++ /dev/null
@@ -1,394 +0,0 @@
-/*
- * Copyright (c) 2006, Intel Corporation.
- *
- * This file is released under the GPLv2.
- *
- * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
- */
-
-#include "iova.h"
-
-void
-init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit)
-{
-	spin_lock_init(&iovad->iova_alloc_lock);
-	spin_lock_init(&iovad->iova_rbtree_lock);
-	iovad->rbroot = RB_ROOT;
-	iovad->cached32_node = NULL;
-	iovad->dma_32bit_pfn = pfn_32bit;
-}
-
-static struct rb_node *
-__get_cached_rbnode(struct iova_domain *iovad, unsigned long *limit_pfn)
-{
-	if ((*limit_pfn != iovad->dma_32bit_pfn) ||
-		(iovad->cached32_node == NULL))
-		return rb_last(&iovad->rbroot);
-	else {
-		struct rb_node *prev_node = rb_prev(iovad->cached32_node);
-		struct iova *curr_iova =
-			container_of(iovad->cached32_node, struct iova, node);
-		*limit_pfn = curr_iova->pfn_lo - 1;
-		return prev_node;
-	}
-}
-
-static void
-__cached_rbnode_insert_update(struct iova_domain *iovad,
-	unsigned long limit_pfn, struct iova *new)
-{
-	if (limit_pfn != iovad->dma_32bit_pfn)
-		return;
-	iovad->cached32_node = &new->node;
-}
-
-static void
-__cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
-{
-	struct iova *cached_iova;
-	struct rb_node *curr;
-
-	if (!iovad->cached32_node)
-		return;
-	curr = iovad->cached32_node;
-	cached_iova = container_of(curr, struct iova, node);
-
-	if (free->pfn_lo >= cached_iova->pfn_lo)
-		iovad->cached32_node = rb_next(&free->node);
-}
-
-/* Computes the padding size required, to make the
- * the start address naturally aligned on its size
- */
-static int
-iova_get_pad_size(int size, unsigned int limit_pfn)
-{
-	unsigned int pad_size = 0;
-	unsigned int order = ilog2(size);
-
-	if (order)
-		pad_size = (limit_pfn + 1) % (1 << order);
-
-	return pad_size;
-}
-
-static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
-		unsigned long limit_pfn, struct iova *new, bool size_aligned)
-{
-	struct rb_node *curr = NULL;
-	unsigned long flags;
-	unsigned long saved_pfn;
-	unsigned int pad_size = 0;
-
-	/* Walk the tree backwards */
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-	saved_pfn = limit_pfn;
-	curr = __get_cached_rbnode(iovad, &limit_pfn);
-	while (curr) {
-		struct iova *curr_iova = container_of(curr, struct iova, node);
-		if (limit_pfn < curr_iova->pfn_lo)
-			goto move_left;
-		else if (limit_pfn < curr_iova->pfn_hi)
-			goto adjust_limit_pfn;
-		else {
-			if (size_aligned)
-				pad_size = iova_get_pad_size(size, limit_pfn);
-			if ((curr_iova->pfn_hi + size + pad_size) <= limit_pfn)
-				break;	/* found a free slot */
-		}
-adjust_limit_pfn:
-		limit_pfn = curr_iova->pfn_lo - 1;
-move_left:
-		curr = rb_prev(curr);
-	}
-
-	if (!curr) {
-		if (size_aligned)
-			pad_size = iova_get_pad_size(size, limit_pfn);
-		if ((IOVA_START_PFN + size + pad_size) > limit_pfn) {
-			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-			return -ENOMEM;
-		}
-	}
-
-	/* pfn_lo will point to size aligned address if size_aligned is set */
-	new->pfn_lo = limit_pfn - (size + pad_size) + 1;
-	new->pfn_hi = new->pfn_lo + size - 1;
-
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-	return 0;
-}
-
-static void
-iova_insert_rbtree(struct rb_root *root, struct iova *iova)
-{
-	struct rb_node **new = &(root->rb_node), *parent = NULL;
-	/* Figure out where to put new node */
-	while (*new) {
-		struct iova *this = container_of(*new, struct iova, node);
-		parent = *new;
-
-		if (iova->pfn_lo < this->pfn_lo)
-			new = &((*new)->rb_left);
-		else if (iova->pfn_lo > this->pfn_lo)
-			new = &((*new)->rb_right);
-		else
-			BUG(); /* this should not happen */
-	}
-	/* Add new node and rebalance tree. */
-	rb_link_node(&iova->node, parent, new);
-	rb_insert_color(&iova->node, root);
-}
-
-/**
- * alloc_iova - allocates an iova
- * @iovad - iova domain in question
- * @size - size of page frames to allocate
- * @limit_pfn - max limit address
- * @size_aligned - set if size_aligned address range is required
- * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
- * looking from limit_pfn instead from IOVA_START_PFN. If the size_aligned
- * flag is set then the allocated address iova->pfn_lo will be naturally
- * aligned on roundup_power_of_two(size).
- */
-struct iova *
-alloc_iova(struct iova_domain *iovad, unsigned long size,
-	unsigned long limit_pfn,
-	bool size_aligned)
-{
-	unsigned long flags;
-	struct iova *new_iova;
-	int ret;
-
-	new_iova = alloc_iova_mem();
-	if (!new_iova)
-		return NULL;
-
-	/* If size aligned is set then round the size to
-	 * to next power of two.
-	 */
-	if (size_aligned)
-		size = __roundup_pow_of_two(size);
-
-	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
-	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova,
-			size_aligned);
-
-	if (ret) {
-		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
-		free_iova_mem(new_iova);
-		return NULL;
-	}
-
-	/* Insert the new_iova into domain rbtree by holding writer lock */
-	spin_lock(&iovad->iova_rbtree_lock);
-	iova_insert_rbtree(&iovad->rbroot, new_iova);
-	__cached_rbnode_insert_update(iovad, limit_pfn, new_iova);
-	spin_unlock(&iovad->iova_rbtree_lock);
-
-	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
-
-	return new_iova;
-}
-
-/**
- * find_iova - find's an iova for a given pfn
- * @iovad - iova domain in question.
- * pfn - page frame number
- * This function finds and returns an iova belonging to the
- * given doamin which matches the given pfn.
- */
-struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
-{
-	unsigned long flags;
-	struct rb_node *node;
-
-	/* Take the lock so that no other thread is manipulating the rbtree */
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-	node = iovad->rbroot.rb_node;
-	while (node) {
-		struct iova *iova = container_of(node, struct iova, node);
-
-		/* If pfn falls within iova's range, return iova */
-		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
-			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-			/* We are not holding the lock while this iova
-			 * is referenced by the caller as the same thread
-			 * which called this function also calls __free_iova()
-			 * and it is by desing that only one thread can possibly
-			 * reference a particular iova and hence no conflict.
-			 */
-			return iova;
-		}
-
-		if (pfn < iova->pfn_lo)
-			node = node->rb_left;
-		else if (pfn > iova->pfn_lo)
-			node = node->rb_right;
-	}
-
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-	return NULL;
-}
-
-/**
- * __free_iova - frees the given iova
- * @iovad: iova domain in question.
- * @iova: iova in question.
- * Frees the given iova belonging to the giving domain
- */
-void
-__free_iova(struct iova_domain *iovad, struct iova *iova)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-	__cached_rbnode_delete_update(iovad, iova);
-	rb_erase(&iova->node, &iovad->rbroot);
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-	free_iova_mem(iova);
-}
-
-/**
- * free_iova - finds and frees the iova for a given pfn
- * @iovad: - iova domain in question.
- * @pfn: - pfn that is allocated previously
- * This functions finds an iova for a given pfn and then
- * frees the iova from that domain.
- */
-void
-free_iova(struct iova_domain *iovad, unsigned long pfn)
-{
-	struct iova *iova = find_iova(iovad, pfn);
-	if (iova)
-		__free_iova(iovad, iova);
-
-}
-
-/**
- * put_iova_domain - destroys the iova doamin
- * @iovad: - iova domain in question.
- * All the iova's in that domain are destroyed.
- */
-void put_iova_domain(struct iova_domain *iovad)
-{
-	struct rb_node *node;
-	unsigned long flags;
-
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-	node = rb_first(&iovad->rbroot);
-	while (node) {
-		struct iova *iova = container_of(node, struct iova, node);
-		rb_erase(node, &iovad->rbroot);
-		free_iova_mem(iova);
-		node = rb_first(&iovad->rbroot);
-	}
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-}
-
-static int
-__is_range_overlap(struct rb_node *node,
-	unsigned long pfn_lo, unsigned long pfn_hi)
-{
-	struct iova *iova = container_of(node, struct iova, node);
-
-	if ((pfn_lo <= iova->pfn_hi) && (pfn_hi >= iova->pfn_lo))
-		return 1;
-	return 0;
-}
-
-static struct iova *
-__insert_new_range(struct iova_domain *iovad,
-	unsigned long pfn_lo, unsigned long pfn_hi)
-{
-	struct iova *iova;
-
-	iova = alloc_iova_mem();
-	if (!iova)
-		return iova;
-
-	iova->pfn_hi = pfn_hi;
-	iova->pfn_lo = pfn_lo;
-	iova_insert_rbtree(&iovad->rbroot, iova);
-	return iova;
-}
-
-static void
-__adjust_overlap_range(struct iova *iova,
-	unsigned long *pfn_lo, unsigned long *pfn_hi)
-{
-	if (*pfn_lo < iova->pfn_lo)
-		iova->pfn_lo = *pfn_lo;
-	if (*pfn_hi > iova->pfn_hi)
-		*pfn_lo = iova->pfn_hi + 1;
-}
-
-/**
- * reserve_iova - reserves an iova in the given range
- * @iovad: - iova domain pointer
- * @pfn_lo: - lower page frame address
- * @pfn_hi:- higher pfn adderss
- * This function allocates reserves the address range from pfn_lo to pfn_hi so
- * that this address is not dished out as part of alloc_iova.
- */
-struct iova *
-reserve_iova(struct iova_domain *iovad,
-	unsigned long pfn_lo, unsigned long pfn_hi)
-{
-	struct rb_node *node;
-	unsigned long flags;
-	struct iova *iova;
-	unsigned int overlap = 0;
-
-	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
-	spin_lock(&iovad->iova_rbtree_lock);
-	for (node = rb_first(&iovad->rbroot); node; node = rb_next(node)) {
-		if (__is_range_overlap(node, pfn_lo, pfn_hi)) {
-			iova = container_of(node, struct iova, node);
-			__adjust_overlap_range(iova, &pfn_lo, &pfn_hi);
-			if ((pfn_lo >= iova->pfn_lo) &&
-				(pfn_hi <= iova->pfn_hi))
-				goto finish;
-			overlap = 1;
-
-		} else if (overlap)
-				break;
-	}
-
-	/* We are here either becasue this is the first reserver node
-	 * or need to insert remaining non overlap addr range
-	 */
-	iova = __insert_new_range(iovad, pfn_lo, pfn_hi);
-finish:
-
-	spin_unlock(&iovad->iova_rbtree_lock);
-	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
-	return iova;
-}
-
-/**
- * copy_reserved_iova - copies the reserved between domains
- * @from: - source doamin from where to copy
- * @to: - destination domin where to copy
- * This function copies reserved iova's from one doamin to
- * other.
- */
-void
-copy_reserved_iova(struct iova_domain *from, struct iova_domain *to)
-{
-	unsigned long flags;
-	struct rb_node *node;
-
-	spin_lock_irqsave(&from->iova_alloc_lock, flags);
-	spin_lock(&from->iova_rbtree_lock);
-	for (node = rb_first(&from->rbroot); node; node = rb_next(node)) {
-		struct iova *iova = container_of(node, struct iova, node);
-		struct iova *new_iova;
-		new_iova = reserve_iova(to, iova->pfn_lo, iova->pfn_hi);
-		if (!new_iova)
-			printk(KERN_ERR "Reserve iova range %lx@%lx failed\n",
-				iova->pfn_lo, iova->pfn_lo);
-	}
-	spin_unlock(&from->iova_rbtree_lock);
-	spin_unlock_irqrestore(&from->iova_alloc_lock, flags);
-}
diff --git a/drivers/pci/iova.h b/drivers/pci/iova.h
deleted file mode 100644
index d521b5b..0000000
--- a/drivers/pci/iova.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright (c) 2006, Intel Corporation.
- *
- * This file is released under the GPLv2.
- *
- * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
- *
- */
-
-#ifndef _IOVA_H_
-#define _IOVA_H_
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/rbtree.h>
-#include <linux/dma-mapping.h>
-
-/* IO virtual address start page frame number */
-#define IOVA_START_PFN		(1)
-
-/* iova structure */
-struct iova {
-	struct rb_node	node;
-	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
-	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
-};
-
-/* holds all the iova translations for a domain */
-struct iova_domain {
-	spinlock_t	iova_alloc_lock;/* Lock to protect iova  allocation */
-	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
-	struct rb_root	rbroot;		/* iova domain rbtree root */
-	struct rb_node	*cached32_node; /* Save last alloced node */
-	unsigned long	dma_32bit_pfn;
-};
-
-struct iova *alloc_iova_mem(void);
-void free_iova_mem(struct iova *iova);
-void free_iova(struct iova_domain *iovad, unsigned long pfn);
-void __free_iova(struct iova_domain *iovad, struct iova *iova);
-struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
-	unsigned long limit_pfn,
-	bool size_aligned);
-struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
-	unsigned long pfn_hi);
-void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
-void init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit);
-struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
-void put_iova_domain(struct iova_domain *iovad);
-
-#endif
diff --git a/include/linux/iova.h b/include/linux/iova.h
new file mode 100644
index 0000000..d521b5b
--- /dev/null
+++ b/include/linux/iova.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ *
+ */
+
+#ifndef _IOVA_H_
+#define _IOVA_H_
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/rbtree.h>
+#include <linux/dma-mapping.h>
+
+/* IO virtual address start page frame number */
+#define IOVA_START_PFN		(1)
+
+/* iova structure */
+struct iova {
+	struct rb_node	node;
+	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
+	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
+};
+
+/* holds all the iova translations for a domain */
+struct iova_domain {
+	spinlock_t	iova_alloc_lock;/* Lock to protect iova  allocation */
+	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
+	struct rb_root	rbroot;		/* iova domain rbtree root */
+	struct rb_node	*cached32_node; /* Save last alloced node */
+	unsigned long	dma_32bit_pfn;
+};
+
+struct iova *alloc_iova_mem(void);
+void free_iova_mem(struct iova *iova);
+void free_iova(struct iova_domain *iovad, unsigned long pfn);
+void __free_iova(struct iova_domain *iovad, struct iova *iova);
+struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
+	unsigned long limit_pfn,
+	bool size_aligned);
+struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
+	unsigned long pfn_hi);
+void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
+void init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit);
+struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
+void put_iova_domain(struct iova_domain *iovad);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index ba3d104..4107547 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -141,4 +141,7 @@ config HAS_DMA
 config CHECK_SIGNATURE
 	bool
 
+config IOVA
+	boolean
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 3a0983b..7de33cc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -66,6 +66,8 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
+obj-$(CONFIG_IOVA) += iova.o
+
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 hostprogs-y	:= gen_crc32table
diff --git a/lib/iova.c b/lib/iova.c
new file mode 100644
index 0000000..6e14a3f
--- /dev/null
+++ b/lib/iova.c
@@ -0,0 +1,394 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ */
+
+#include <linux/iova.h>
+
+void
+init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit)
+{
+	spin_lock_init(&iovad->iova_alloc_lock);
+	spin_lock_init(&iovad->iova_rbtree_lock);
+	iovad->rbroot = RB_ROOT;
+	iovad->cached32_node = NULL;
+	iovad->dma_32bit_pfn = pfn_32bit;
+}
+
+static struct rb_node *
+__get_cached_rbnode(struct iova_domain *iovad, unsigned long *limit_pfn)
+{
+	if ((*limit_pfn != iovad->dma_32bit_pfn) ||
+		(iovad->cached32_node == NULL))
+		return rb_last(&iovad->rbroot);
+	else {
+		struct rb_node *prev_node = rb_prev(iovad->cached32_node);
+		struct iova *curr_iova =
+			container_of(iovad->cached32_node, struct iova, node);
+		*limit_pfn = curr_iova->pfn_lo - 1;
+		return prev_node;
+	}
+}
+
+static void
+__cached_rbnode_insert_update(struct iova_domain *iovad,
+	unsigned long limit_pfn, struct iova *new)
+{
+	if (limit_pfn != iovad->dma_32bit_pfn)
+		return;
+	iovad->cached32_node = &new->node;
+}
+
+static void
+__cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
+{
+	struct iova *cached_iova;
+	struct rb_node *curr;
+
+	if (!iovad->cached32_node)
+		return;
+	curr = iovad->cached32_node;
+	cached_iova = container_of(curr, struct iova, node);
+
+	if (free->pfn_lo >= cached_iova->pfn_lo)
+		iovad->cached32_node = rb_next(&free->node);
+}
+
+/* Computes the padding size required, to make the
+ * the start address naturally aligned on its size
+ */
+static int
+iova_get_pad_size(int size, unsigned int limit_pfn)
+{
+	unsigned int pad_size = 0;
+	unsigned int order = ilog2(size);
+
+	if (order)
+		pad_size = (limit_pfn + 1) % (1 << order);
+
+	return pad_size;
+}
+
+static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
+		unsigned long limit_pfn, struct iova *new, bool size_aligned)
+{
+	struct rb_node *curr = NULL;
+	unsigned long flags;
+	unsigned long saved_pfn;
+	unsigned int pad_size = 0;
+
+	/* Walk the tree backwards */
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	saved_pfn = limit_pfn;
+	curr = __get_cached_rbnode(iovad, &limit_pfn);
+	while (curr) {
+		struct iova *curr_iova = container_of(curr, struct iova, node);
+		if (limit_pfn < curr_iova->pfn_lo)
+			goto move_left;
+		else if (limit_pfn < curr_iova->pfn_hi)
+			goto adjust_limit_pfn;
+		else {
+			if (size_aligned)
+				pad_size = iova_get_pad_size(size, limit_pfn);
+			if ((curr_iova->pfn_hi + size + pad_size) <= limit_pfn)
+				break;	/* found a free slot */
+		}
+adjust_limit_pfn:
+		limit_pfn = curr_iova->pfn_lo - 1;
+move_left:
+		curr = rb_prev(curr);
+	}
+
+	if (!curr) {
+		if (size_aligned)
+			pad_size = iova_get_pad_size(size, limit_pfn);
+		if ((IOVA_START_PFN + size + pad_size) > limit_pfn) {
+			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			return -ENOMEM;
+		}
+	}
+
+	/* pfn_lo will point to size aligned address if size_aligned is set */
+	new->pfn_lo = limit_pfn - (size + pad_size) + 1;
+	new->pfn_hi = new->pfn_lo + size - 1;
+
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	return 0;
+}
+
+static void
+iova_insert_rbtree(struct rb_root *root, struct iova *iova)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	/* Figure out where to put new node */
+	while (*new) {
+		struct iova *this = container_of(*new, struct iova, node);
+		parent = *new;
+
+		if (iova->pfn_lo < this->pfn_lo)
+			new = &((*new)->rb_left);
+		else if (iova->pfn_lo > this->pfn_lo)
+			new = &((*new)->rb_right);
+		else
+			BUG(); /* this should not happen */
+	}
+	/* Add new node and rebalance tree. */
+	rb_link_node(&iova->node, parent, new);
+	rb_insert_color(&iova->node, root);
+}
+
+/**
+ * alloc_iova - allocates an iova
+ * @iovad - iova domain in question
+ * @size - size of page frames to allocate
+ * @limit_pfn - max limit address
+ * @size_aligned - set if size_aligned address range is required
+ * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
+ * looking from limit_pfn instead from IOVA_START_PFN. If the size_aligned
+ * flag is set then the allocated address iova->pfn_lo will be naturally
+ * aligned on roundup_power_of_two(size).
+ */
+struct iova *
+alloc_iova(struct iova_domain *iovad, unsigned long size,
+	unsigned long limit_pfn,
+	bool size_aligned)
+{
+	unsigned long flags;
+	struct iova *new_iova;
+	int ret;
+
+	new_iova = alloc_iova_mem();
+	if (!new_iova)
+		return NULL;
+
+	/* If size aligned is set then round the size to
+	 * to next power of two.
+	 */
+	if (size_aligned)
+		size = __roundup_pow_of_two(size);
+
+	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
+	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova,
+			size_aligned);
+
+	if (ret) {
+		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
+		free_iova_mem(new_iova);
+		return NULL;
+	}
+
+	/* Insert the new_iova into domain rbtree by holding writer lock */
+	spin_lock(&iovad->iova_rbtree_lock);
+	iova_insert_rbtree(&iovad->rbroot, new_iova);
+	__cached_rbnode_insert_update(iovad, limit_pfn, new_iova);
+	spin_unlock(&iovad->iova_rbtree_lock);
+
+	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
+
+	return new_iova;
+}
+
+/**
+ * find_iova - find's an iova for a given pfn
+ * @iovad - iova domain in question.
+ * pfn - page frame number
+ * This function finds and returns an iova belonging to the
+ * given doamin which matches the given pfn.
+ */
+struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
+{
+	unsigned long flags;
+	struct rb_node *node;
+
+	/* Take the lock so that no other thread is manipulating the rbtree */
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	node = iovad->rbroot.rb_node;
+	while (node) {
+		struct iova *iova = container_of(node, struct iova, node);
+
+		/* If pfn falls within iova's range, return iova */
+		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
+			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			/* We are not holding the lock while this iova
+			 * is referenced by the caller as the same thread
+			 * which called this function also calls __free_iova()
+			 * and it is by desing that only one thread can possibly
+			 * reference a particular iova and hence no conflict.
+			 */
+			return iova;
+		}
+
+		if (pfn < iova->pfn_lo)
+			node = node->rb_left;
+		else if (pfn > iova->pfn_lo)
+			node = node->rb_right;
+	}
+
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	return NULL;
+}
+
+/**
+ * __free_iova - frees the given iova
+ * @iovad: iova domain in question.
+ * @iova: iova in question.
+ * Frees the given iova belonging to the giving domain
+ */
+void
+__free_iova(struct iova_domain *iovad, struct iova *iova)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	__cached_rbnode_delete_update(iovad, iova);
+	rb_erase(&iova->node, &iovad->rbroot);
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	free_iova_mem(iova);
+}
+
+/**
+ * free_iova - finds and frees the iova for a given pfn
+ * @iovad: - iova domain in question.
+ * @pfn: - pfn that is allocated previously
+ * This functions finds an iova for a given pfn and then
+ * frees the iova from that domain.
+ */
+void
+free_iova(struct iova_domain *iovad, unsigned long pfn)
+{
+	struct iova *iova = find_iova(iovad, pfn);
+	if (iova)
+		__free_iova(iovad, iova);
+
+}
+
+/**
+ * put_iova_domain - destroys the iova doamin
+ * @iovad: - iova domain in question.
+ * All the iova's in that domain are destroyed.
+ */
+void put_iova_domain(struct iova_domain *iovad)
+{
+	struct rb_node *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	node = rb_first(&iovad->rbroot);
+	while (node) {
+		struct iova *iova = container_of(node, struct iova, node);
+		rb_erase(node, &iovad->rbroot);
+		free_iova_mem(iova);
+		node = rb_first(&iovad->rbroot);
+	}
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+}
+
+static int
+__is_range_overlap(struct rb_node *node,
+	unsigned long pfn_lo, unsigned long pfn_hi)
+{
+	struct iova *iova = container_of(node, struct iova, node);
+
+	if ((pfn_lo <= iova->pfn_hi) && (pfn_hi >= iova->pfn_lo))
+		return 1;
+	return 0;
+}
+
+static struct iova *
+__insert_new_range(struct iova_domain *iovad,
+	unsigned long pfn_lo, unsigned long pfn_hi)
+{
+	struct iova *iova;
+
+	iova = alloc_iova_mem();
+	if (!iova)
+		return iova;
+
+	iova->pfn_hi = pfn_hi;
+	iova->pfn_lo = pfn_lo;
+	iova_insert_rbtree(&iovad->rbroot, iova);
+	return iova;
+}
+
+static void
+__adjust_overlap_range(struct iova *iova,
+	unsigned long *pfn_lo, unsigned long *pfn_hi)
+{
+	if (*pfn_lo < iova->pfn_lo)
+		iova->pfn_lo = *pfn_lo;
+	if (*pfn_hi > iova->pfn_hi)
+		*pfn_lo = iova->pfn_hi + 1;
+}
+
+/**
+ * reserve_iova - reserves an iova in the given range
+ * @iovad: - iova domain pointer
+ * @pfn_lo: - lower page frame address
+ * @pfn_hi:- higher pfn adderss
+ * This function allocates reserves the address range from pfn_lo to pfn_hi so
+ * that this address is not dished out as part of alloc_iova.
+ */
+struct iova *
+reserve_iova(struct iova_domain *iovad,
+	unsigned long pfn_lo, unsigned long pfn_hi)
+{
+	struct rb_node *node;
+	unsigned long flags;
+	struct iova *iova;
+	unsigned int overlap = 0;
+
+	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
+	spin_lock(&iovad->iova_rbtree_lock);
+	for (node = rb_first(&iovad->rbroot); node; node = rb_next(node)) {
+		if (__is_range_overlap(node, pfn_lo, pfn_hi)) {
+			iova = container_of(node, struct iova, node);
+			__adjust_overlap_range(iova, &pfn_lo, &pfn_hi);
+			if ((pfn_lo >= iova->pfn_lo) &&
+				(pfn_hi <= iova->pfn_hi))
+				goto finish;
+			overlap = 1;
+
+		} else if (overlap)
+				break;
+	}
+
+	/* We are here either becasue this is the first reserver node
+	 * or need to insert remaining non overlap addr range
+	 */
+	iova = __insert_new_range(iovad, pfn_lo, pfn_hi);
+finish:
+
+	spin_unlock(&iovad->iova_rbtree_lock);
+	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
+	return iova;
+}
+
+/**
+ * copy_reserved_iova - copies the reserved between domains
+ * @from: - source doamin from where to copy
+ * @to: - destination domin where to copy
+ * This function copies reserved iova's from one doamin to
+ * other.
+ */
+void
+copy_reserved_iova(struct iova_domain *from, struct iova_domain *to)
+{
+	unsigned long flags;
+	struct rb_node *node;
+
+	spin_lock_irqsave(&from->iova_alloc_lock, flags);
+	spin_lock(&from->iova_rbtree_lock);
+	for (node = rb_first(&from->rbroot); node; node = rb_next(node)) {
+		struct iova *iova = container_of(node, struct iova, node);
+		struct iova *new_iova;
+		new_iova = reserve_iova(to, iova->pfn_lo, iova->pfn_hi);
+		if (!new_iova)
+			printk(KERN_ERR "Reserve iova range %lx@%lx failed\n",
+				iova->pfn_lo, iova->pfn_lo);
+	}
+	spin_unlock(&from->iova_rbtree_lock);
+	spin_unlock_irqrestore(&from->iova_alloc_lock, flags);
+}
-- 
1.5.2.4

