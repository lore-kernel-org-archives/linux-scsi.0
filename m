From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/2] SG: Move functions to lib/scatterlist.c and add sg
	chaining allocator helpers
Date: Wed, 14 Nov 2007 12:47:09 +0100
Message-ID: <20071114114709.GB5064@kernel.dk>
References: <20071114114620.GA5064@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbXKNLsN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 06:48:13 -0500
Received: from nelson.home.kernel.dk (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTP id 3C2A525718E
	for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2007 12:48:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20071114114620.GA5064@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


>From 26dcdd893e845180cc822640d36521d7cb18ce38 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 14 Nov 2007 12:35:10 +0100
Subject: [PATCH] SG: Move functions to lib/scatterlist.c and add sg chaining allocator helpers

Manually doing chained sg lists is not trivial, so add some helpers
to make sure that drivers get it right.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |  126 +++++------------------
 lib/Makefile                |    2 +-
 lib/scatterlist.c           |  240 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 267 insertions(+), 101 deletions(-)
 create mode 100644 lib/scatterlist.c

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2597350..0fad621 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -7,6 +7,12 @@
 #include <linux/string.h>
 #include <asm/io.h>
 
+struct sg_table {
+	struct scatterlist *sgl;	/* the list */
+	unsigned int nents;		/* number of mapped entries */
+	unsigned int orig_nents;	/* original size of list */
+};
+
 /*
  * Notes on SG table design.
  *
@@ -98,31 +104,6 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 #define sg_chain_ptr(sg)	\
 	((struct scatterlist *) ((sg)->page_link & ~0x03))
 
-/**
- * sg_next - return the next scatterlist entry in a list
- * @sg:		The current sg entry
- *
- * Description:
- *   Usually the next entry will be @sg@ + 1, but if this sg element is part
- *   of a chained scatterlist, it could jump to the start of a new
- *   scatterlist array.
- *
- **/
-static inline struct scatterlist *sg_next(struct scatterlist *sg)
-{
-#ifdef CONFIG_DEBUG_SG
-	BUG_ON(sg->sg_magic != SG_MAGIC);
-#endif
-	if (sg_is_last(sg))
-		return NULL;
-
-	sg++;
-	if (unlikely(sg_is_chain(sg)))
-		sg = sg_chain_ptr(sg);
-
-	return sg;
-}
-
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
  */
@@ -130,40 +111,6 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
 	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
 
 /**
- * sg_last - return the last scatterlist entry in a list
- * @sgl:	First entry in the scatterlist
- * @nents:	Number of entries in the scatterlist
- *
- * Description:
- *   Should only be used casually, it (currently) scan the entire list
- *   to get the last entry.
- *
- *   Note that the @sgl@ pointer passed in need not be the first one,
- *   the important bit is that @nents@ denotes the number of entries that
- *   exist from @sgl@.
- *
- **/
-static inline struct scatterlist *sg_last(struct scatterlist *sgl,
-					  unsigned int nents)
-{
-#ifndef ARCH_HAS_SG_CHAIN
-	struct scatterlist *ret = &sgl[nents - 1];
-#else
-	struct scatterlist *sg, *ret = NULL;
-	unsigned int i;
-
-	for_each_sg(sgl, sg, nents, i)
-		ret = sg;
-
-#endif
-#ifdef CONFIG_DEBUG_SG
-	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
-	BUG_ON(!sg_is_last(ret));
-#endif
-	return ret;
-}
-
-/**
  * sg_chain - Chain two sglists together
  * @prv:	First scatterlist
  * @prv_nents:	Number of entries in prv
@@ -208,47 +155,6 @@ static inline void sg_mark_end(struct scatterlist *sg)
 }
 
 /**
- * sg_init_table - Initialize SG table
- * @sgl:	   The SG table
- * @nents:	   Number of entries in table
- *
- * Notes:
- *   If this is part of a chained sg table, sg_mark_end() should be
- *   used only on the last table part.
- *
- **/
-static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
-{
-	memset(sgl, 0, sizeof(*sgl) * nents);
-#ifdef CONFIG_DEBUG_SG
-	{
-		unsigned int i;
-		for (i = 0; i < nents; i++)
-			sgl[i].sg_magic = SG_MAGIC;
-	}
-#endif
-	sg_mark_end(&sgl[nents - 1]);
-}
-
-/**
- * sg_init_one - Initialize a single entry sg list
- * @sg:		 SG entry
- * @buf:	 Virtual address for IO
- * @buflen:	 IO length
- *
- * Notes:
- *   This should not be used on a single entry that is part of a larger
- *   table. Use sg_init_table() for that.
- *
- **/
-static inline void sg_init_one(struct scatterlist *sg, const void *buf,
-			       unsigned int buflen)
-{
-	sg_init_table(sg, 1);
-	sg_set_buf(sg, buf, buflen);
-}
-
-/**
  * sg_phys - Return physical address of an sg entry
  * @sg:	     SG entry
  *
@@ -278,4 +184,24 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+struct scatterlist *sg_next(struct scatterlist *);
+struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
+void sg_init_table(struct scatterlist *, unsigned int);
+void sg_init_one(struct scatterlist *, const void *, unsigned int);
+
+typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
+typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
+
+void __sg_free_table(struct sg_table *, sg_free_fn *);
+void sg_free_table(struct sg_table *);
+int __sg_alloc_table(struct sg_table *, unsigned int, gfp_t, sg_alloc_fn *,
+			sg_free_fn *);
+int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
+
+/*
+ * Maximum number of entries that will be allocated in one piece, if
+ * a list larger than this is required then chaining will be utilized.
+ */
+#define SG_MAX_SINGLE_ALLOC		128
+
 #endif /* _LINUX_SCATTERLIST_H */
diff --git a/lib/Makefile b/lib/Makefile
index 3a0983b..a3e2947 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o
+	 proportions.o prio_heap.o scatterlist.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
new file mode 100644
index 0000000..2175b3c
--- /dev/null
+++ b/lib/scatterlist.c
@@ -0,0 +1,240 @@
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+
+/**
+ * sg_next - return the next scatterlist entry in a list
+ * @sg:		The current sg entry
+ *
+ * Description:
+ *   Usually the next entry will be @sg + 1, but if this sg element is part
+ *   of a chained scatterlist, it could jump to the start of a new
+ *   scatterlist array.
+ *
+ **/
+struct scatterlist *sg_next(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	if (sg_is_last(sg))
+		return NULL;
+
+	sg++;
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
+EXPORT_SYMBOL(sg_next);
+
+/**
+ * sg_last - return the last scatterlist entry in a list
+ * @sgl:	First entry in the scatterlist
+ * @nents:	Number of entries in the scatterlist
+ *
+ * Description:
+ *   Should only be used casually, it (currently) scan the entire list
+ *   to get the last entry.
+ *
+ *   Note that the @sgl@ pointer passed in need not be the first one,
+ *   the important bit is that @nents@ denotes the number of entries that
+ *   exist from @sgl@.
+ *
+ **/
+struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
+{
+#ifndef ARCH_HAS_SG_CHAIN
+	struct scatterlist *ret = &sgl[nents - 1];
+#else
+	struct scatterlist *sg, *ret = NULL;
+	unsigned int i;
+
+	for_each_sg(sgl, sg, nents, i)
+		ret = sg;
+
+#endif
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
+	BUG_ON(!sg_is_last(ret));
+#endif
+	return ret;
+}
+EXPORT_SYMBOL(sg_last);
+
+/**
+ * sg_init_table - Initialize SG table
+ * @sgl:	   The SG table
+ * @nents:	   Number of entries in table
+ *
+ * Notes:
+ *   If this is part of a chained sg table, sg_mark_end() should be
+ *   used only on the last table part.
+ *
+ **/
+void sg_init_table(struct scatterlist *sgl, unsigned int nents)
+{
+	memset(sgl, 0, sizeof(*sgl) * nents);
+#ifdef CONFIG_DEBUG_SG
+	{
+		unsigned int i;
+		for (i = 0; i < nents; i++)
+			sgl[i].sg_magic = SG_MAGIC;
+	}
+#endif
+	sg_mark_end(&sgl[nents - 1]);
+}
+EXPORT_SYMBOL(sg_init_table);
+
+/**
+ * sg_init_one - Initialize a single entry sg list
+ * @sg:		 SG entry
+ * @buf:	 Virtual address for IO
+ * @buflen:	 IO length
+ *
+ * Notes:
+ *   This should not be used on a single entry that is part of a larger
+ *   table. Use sg_init_table() for that.
+ *
+ **/
+void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
+{
+	sg_init_table(sg, 1);
+	sg_set_buf(sg, buf, buflen);
+}
+EXPORT_SYMBOL(sg_init_one);
+
+static struct scatterlist *sg_kmalloc(unsigned int nents, gfp_t gfp_mask)
+{
+	return kmalloc(nents * sizeof(struct scatterlist), gfp_mask);
+}
+
+static void sg_kfree(struct scatterlist *sg, unsigned int nents)
+{
+	kfree(sg);
+}
+
+/**
+ * __sg_free_table - Free a previously mapped sg table
+ * @table:	The sg table header to use
+ * @free_fn:	Free function
+ *
+ **/
+void __sg_free_table(struct sg_table *table, sg_free_fn *free_fn)
+{
+	struct scatterlist *sgl = table->sgl;
+
+	if (table->orig_nents > SG_MAX_SINGLE_ALLOC) {
+		unsigned int alloc_size, sg_size, total;
+		struct scatterlist *next;
+
+		total = table->orig_nents - SG_MAX_SINGLE_ALLOC;
+		next = sg_chain_ptr(&sgl[SG_MAX_SINGLE_ALLOC - 1]);
+		while (total && next) {
+			sgl = next;
+			alloc_size = total;
+			if (alloc_size > SG_MAX_SINGLE_ALLOC) {
+				alloc_size = SG_MAX_SINGLE_ALLOC;
+				sg_size = alloc_size - 1;
+			} else
+				sg_size = alloc_size;
+
+			total -= sg_size;
+			table->orig_nents -= sg_size;
+			if (total)
+				next = sg_chain_ptr(&sgl[alloc_size - 1]);
+
+			free_fn(sgl, alloc_size);
+		}
+	}
+
+	free_fn(table->sgl, table->orig_nents);
+	table->sgl = NULL;
+}
+
+/**
+ * sg_free_table - Free a previously allocated sg table
+ * @table:	The mapped sg table header
+ *
+ **/
+void sg_free_table(struct sg_table *table)
+{
+	__sg_free_table(table, sg_kfree);
+}
+EXPORT_SYMBOL(sg_free_table);
+
+/**
+ * __sg_alloc_table - Allocate and initialize an sg table with given allocator
+ * @table:	The sg table header to use
+ * @nents:	Number of entries in sg list
+ * @gfp_mask:	GFP allocation mask
+ * @alloc_fn:	Allocator to use
+ * @free_fn:	Free function
+ *
+ **/
+int __sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask,
+		     sg_alloc_fn *alloc_fn, sg_free_fn *free_fn)
+{
+	struct scatterlist *sg, *prv;
+	unsigned int left;
+
+	memset(table, 0, sizeof(*table));
+
+	left = nents;
+	prv = NULL;
+	do {
+		unsigned int sg_size, alloc_size = left;
+
+		if (alloc_size > SG_MAX_SINGLE_ALLOC) {
+			alloc_size = SG_MAX_SINGLE_ALLOC;
+			sg_size = alloc_size - 1;
+		} else
+			sg_size = alloc_size;
+
+		left -= sg_size;
+
+		sg = alloc_fn(alloc_size, gfp_mask);
+		if (unlikely(!sg))
+			goto enomem;
+
+		sg_init_table(sg, alloc_size);
+		table->nents = table->orig_nents += sg_size;
+
+		/*
+		 * If this is the first mapping, assign the sg table header.
+		 * If this is not the first mapping, chain previous part.
+		 */
+		if (prv)
+			sg_chain(prv, SG_MAX_SINGLE_ALLOC, sg);
+		else
+			table->sgl = sg;
+
+		/*
+		 * If no more entries after this one, mark the end
+		 */
+		if (!left)
+			sg_mark_end(&sg[sg_size - 1]);
+
+		gfp_mask &= ~__GFP_WAIT;
+		gfp_mask |= __GFP_HIGH;
+		prv = sg;
+	} while (left);
+
+	return 0;
+enomem:
+	__sg_free_table(table, free_fn);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(__sg_alloc_table);
+
+/**
+ * sg_alloc_table - Allocate and initialize an sg table
+ * @table:	The sg table header to use
+ * @nents:	Number of entries in sg list
+ * @gfp_mask:	GFP allocation mask
+ *
+ **/
+int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
+{
+	return __sg_alloc_table(table, nents, gfp_mask, sg_kmalloc, sg_kfree);
+}
+EXPORT_SYMBOL(sg_alloc_table);
-- 
1.5.3.GIT

-- 
Jens Axboe

