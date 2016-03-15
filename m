From: Ming Lin <mlin@kernel.org>
Subject: [PATCH RFC 1/2] scatterlist: add mempool based chained SG alloc/free
 api
Date: Tue, 15 Mar 2016 15:39:28 -0700
Message-ID: <1458081569-30953-2-git-send-email-mlin@kernel.org>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

This copied code from scsi_lib.c to scatterlist.c and
modified it a bit.

Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 include/linux/scatterlist.h |  12 ++++
 lib/scatterlist.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..888f2c3 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -266,6 +266,10 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
 
+void sg_free_chained(struct sg_table *table, bool first_chunk);
+int sg_alloc_chained(struct sg_table *table, int nents,
+	struct scatterlist *first_chunk, gfp_t gfp);
+
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 		      size_t buflen, off_t skip, bool to_buffer);
 
@@ -286,6 +290,14 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
 /*
+ * The maximum number of SG segments that we will put inside a
+ * scatterlist.
+ *
+ * XXX: what's the best number?
+ */
+#define SG_MAX_SEGMENTS			128
+
+/*
  * sg page iterator
  *
  * Iterates over sg entries page-by-page.  On each successful iteration,
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 004fc70..f97831e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -11,6 +11,7 @@
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
 #include <linux/kmemleak.h>
+#include <linux/mempool.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -755,3 +756,158 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
 }
 EXPORT_SYMBOL(sg_pcopy_to_buffer);
+
+#define SG_MEMPOOL_NR		ARRAY_SIZE(sg_pools)
+#define SG_MEMPOOL_SIZE		2
+
+struct sg_mempool {
+	size_t		size;
+	char		*name;
+	struct kmem_cache *slab;
+	mempool_t	*pool;
+};
+
+#define SP(x) { .size = x, "sgpool-" __stringify(x) }
+#if (SG_MAX_SEGMENTS < 32)
+#error SG_MAX_SEGMENTS is too small (must be 32 or greater)
+#endif
+static struct sg_mempool sg_pools[] = {
+	SP(8),
+	SP(16),
+#if (SG_MAX_SEGMENTS > 32)
+	SP(32),
+#if (SG_MAX_SEGMENTS > 64)
+	SP(64),
+#if (SG_MAX_SEGMENTS > 128)
+	SP(128),
+#if (SG_MAX_SEGMENTS > 256)
+#error SG_MAX_SEGMENTS is too large (256 MAX)
+#endif
+#endif
+#endif
+#endif
+	SP(SG_MAX_SEGMENTS)
+};
+#undef SP
+
+static inline unsigned int sg_pool_index(unsigned short nents)
+{
+	unsigned int index;
+
+	BUG_ON(nents > SG_MAX_SEGMENTS);
+
+	if (nents <= 8)
+		index = 0;
+	else
+		index = get_count_order(nents) - 3;
+
+	return index;
+}
+
+static void sg_mempoll_free(struct scatterlist *sgl, unsigned int nents)
+{
+	struct sg_mempool *sgp;
+
+	sgp = sg_pools + sg_pool_index(nents);
+	mempool_free(sgl, sgp->pool);
+}
+
+static struct scatterlist *sg_mempool_alloc(unsigned int nents, gfp_t gfp)
+{
+	struct sg_mempool *sgp;
+
+	sgp = sg_pools + sg_pool_index(nents);
+	return mempool_alloc(sgp->pool, gfp);
+}
+
+/**
+ * sg_free_chained - Free a previously mapped sg table
+ * @table:	The sg table header to use
+ * @first_chunk: was first_chunk not NULL in sg_alloc_chained?
+ *
+ *  Description:
+ *    Free an sg table previously allocated and setup with
+ *    sg_alloc_chained().
+ *
+ **/
+void sg_free_chained(struct sg_table *table, bool first_chunk)
+{
+	if (first_chunk && table->orig_nents <= SG_MAX_SEGMENTS)
+		return;
+	__sg_free_table(table, SG_MAX_SEGMENTS, 1, sg_mempoll_free);
+}
+EXPORT_SYMBOL_GPL(sg_free_chained);
+
+/**
+ * sg_alloc_chained - Allocate and chain SGLs in an sg table
+ * @table:	The sg table header to use
+ * @nents:	Number of entries in sg list
+ * @first_chunk: first SGL
+ * @gfp:	GFP allocation mask
+ *
+ *  Description:
+ *    Allocate and chain SGLs in an sg table. If @nents@ is larger than
+ *    SG_MAX_SEGMENTS a chained sg table will be setup.
+ *
+ **/
+int sg_alloc_chained(struct sg_table *table, int nents,
+		struct scatterlist *first_chunk, gfp_t gfp)
+{
+	int ret;
+
+	BUG_ON(!nents);
+
+	if (first_chunk && nents <= SG_MAX_SEGMENTS) {
+		table->nents = table->orig_nents = nents;
+		sg_init_table(first_chunk, nents);
+		return 0;
+	}
+
+	ret = __sg_alloc_table(table, nents, SG_MAX_SEGMENTS,
+				first_chunk, gfp, sg_mempool_alloc);
+	if (unlikely(ret))
+		sg_free_chained(table, (bool)first_chunk);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sg_alloc_chained);
+
+static __init int sg_mempool_init(void)
+{
+	int i;
+
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct sg_mempool *sgp = sg_pools + i;
+		int size = sgp->size * sizeof(struct scatterlist);
+
+		sgp->slab = kmem_cache_create(sgp->name, size, 0,
+				SLAB_HWCACHE_ALIGN, NULL);
+		if (!sgp->slab) {
+			printk(KERN_ERR "NVME: can't init sg slab %s\n",
+					sgp->name);
+			goto cleanup_sgp;
+		}
+
+		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
+						     sgp->slab);
+		if (!sgp->pool) {
+			printk(KERN_ERR "NVME can't init sg mempool %s\n",
+					sgp->name);
+			goto cleanup_sgp;
+		}
+	}
+
+	return 0;
+
+cleanup_sgp:
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct sg_mempool *sgp = sg_pools + i;
+		if (sgp->pool)
+			mempool_destroy(sgp->pool);
+		if (sgp->slab)
+			kmem_cache_destroy(sgp->slab);
+	}
+
+	return -ENOMEM;
+}
+subsys_initcall(sg_mempool_init);
-- 
1.9.1
