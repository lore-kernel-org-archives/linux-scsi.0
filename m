From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v3 5/5] lib: scatterlist: move SG pool code from SCSI driver to
 lib/sg_pool.c
Date: Mon, 04 Apr 2016 14:48:11 -0700
Message-ID: <1459806491-16428-6-git-send-email-mlin@kernel.org>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

Now it's ready to move the mempool based SG chained allocator code from
SCSI driver to lib/sg_pool.c, which will be compiled only based on a Kconfig
symbol CONFIG_SG_POOL.

SCSI selects CONFIG_SG_POOL.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/scsi/Kconfig        |   1 +
 drivers/scsi/scsi_lib.c     | 137 -----------------------------------
 include/linux/scatterlist.h |  25 +++++++
 include/scsi/scsi.h         |  19 -----
 lib/Kconfig                 |   7 ++
 lib/Makefile                |   1 +
 lib/sg_pool.c               | 172 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 206 insertions(+), 156 deletions(-)
 create mode 100644 lib/sg_pool.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 0950567..98e5d51 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -17,6 +17,7 @@ config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
 	select SCSI_DMA if HAS_DMA
+	select SG_POOL
 	---help---
 	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
 	  any other SCSI device under Linux, say Y and make sure that you know
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8f776f1..b920c5d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -14,8 +14,6 @@
 #include <linux/completion.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
-#include <linux/mempool.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
@@ -40,39 +38,6 @@
 #include "scsi_logging.h"
 
 
-#define SG_MEMPOOL_NR		ARRAY_SIZE(sg_pools)
-#define SG_MEMPOOL_SIZE		2
-
-struct sg_pool {
-	size_t		size;
-	char		*name;
-	struct kmem_cache	*slab;
-	mempool_t	*pool;
-};
-
-#define SP(x) { .size = x, "sgpool-" __stringify(x) }
-#if (SG_CHUNK_SIZE < 32)
-#error SG_CHUNK_SIZE is too small (must be 32 or greater)
-#endif
-static struct sg_pool sg_pools[] = {
-	SP(8),
-	SP(16),
-#if (SG_CHUNK_SIZE > 32)
-	SP(32),
-#if (SG_CHUNK_SIZE > 64)
-	SP(64),
-#if (SG_CHUNK_SIZE > 128)
-	SP(128),
-#if (SG_CHUNK_SIZE > 256)
-#error SG_CHUNK_SIZE is too large (256 MAX)
-#endif
-#endif
-#endif
-#endif
-	SP(SG_CHUNK_SIZE)
-};
-#undef SP
-
 struct kmem_cache *scsi_sdb_cache;
 
 /*
@@ -553,65 +518,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static inline unsigned int sg_pool_index(unsigned short nents)
-{
-	unsigned int index;
-
-	BUG_ON(nents > SG_CHUNK_SIZE);
-
-	if (nents <= 8)
-		index = 0;
-	else
-		index = get_count_order(nents) - 3;
-
-	return index;
-}
-
-static void sg_pool_free(struct scatterlist *sgl, unsigned int nents)
-{
-	struct sg_pool *sgp;
-
-	sgp = sg_pools + sg_pool_index(nents);
-	mempool_free(sgl, sgp->pool);
-}
-
-static struct scatterlist *sg_pool_alloc(unsigned int nents, gfp_t gfp_mask)
-{
-	struct sg_pool *sgp;
-
-	sgp = sg_pools + sg_pool_index(nents);
-	return mempool_alloc(sgp->pool, gfp_mask);
-}
-
-static void sg_free_table_chained(struct sg_table *table, bool first_chunk)
-{
-	if (first_chunk && table->orig_nents <= SG_CHUNK_SIZE)
-		return;
-	__sg_free_table(table, SG_CHUNK_SIZE, first_chunk, sg_pool_free);
-}
-
-static int sg_alloc_table_chained(struct sg_table *table, int nents,
-		struct scatterlist *first_chunk)
-{
-	int ret;
-
-	BUG_ON(!nents);
-
-	if (first_chunk) {
-		if (nents <= SG_CHUNK_SIZE) {
-			table->nents = table->orig_nents = nents;
-			sg_init_table(table->sgl, nents);
-			return 0;
-		}
-	}
-
-	ret = __sg_alloc_table(table, nents, SG_CHUNK_SIZE,
-			       first_chunk, GFP_ATOMIC, sg_pool_alloc);
-	if (unlikely(ret))
-		sg_free_table_chained(table, (bool)first_chunk);
-	return ret;
-}
-
 static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 {
 	if (cmd->request->cmd_type == REQ_TYPE_FS) {
@@ -2269,8 +2175,6 @@ EXPORT_SYMBOL(scsi_unblock_requests);
 
 int __init scsi_init_queue(void)
 {
-	int i;
-
 	scsi_sdb_cache = kmem_cache_create("scsi_data_buffer",
 					   sizeof(struct scsi_data_buffer),
 					   0, 0, NULL);
@@ -2279,53 +2183,12 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct sg_pool *sgp = sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
-
-		sgp->slab = kmem_cache_create(sgp->name, size, 0,
-				SLAB_HWCACHE_ALIGN, NULL);
-		if (!sgp->slab) {
-			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
-					sgp->name);
-			goto cleanup_sdb;
-		}
-
-		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
-						     sgp->slab);
-		if (!sgp->pool) {
-			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
-					sgp->name);
-			goto cleanup_sdb;
-		}
-	}
-
 	return 0;
-
-cleanup_sdb:
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct sg_pool *sgp = sg_pools + i;
-		if (sgp->pool)
-			mempool_destroy(sgp->pool);
-		if (sgp->slab)
-			kmem_cache_destroy(sgp->slab);
-	}
-	kmem_cache_destroy(scsi_sdb_cache);
-
-	return -ENOMEM;
 }
 
 void scsi_exit_queue(void)
 {
-	int i;
-
 	kmem_cache_destroy(scsi_sdb_cache);
-
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct sg_pool *sgp = sg_pools + i;
-		mempool_destroy(sgp->pool);
-		kmem_cache_destroy(sgp->slab);
-	}
 }
 
 /**
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..cb3c8fe 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -286,6 +286,31 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
 /*
+ * The maximum number of SG segments that we will put inside a
+ * scatterlist (unless chaining is used). Should ideally fit inside a
+ * single page, to avoid a higher order allocation.  We could define this
+ * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
+ * minimum value is 32
+ */
+#define SG_CHUNK_SIZE	128
+
+/*
+ * Like SG_CHUNK_SIZE, but for archs that have sg chaining. This limit
+ * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
+ */
+#ifdef CONFIG_ARCH_HAS_SG_CHAIN
+#define SG_MAX_SEGMENTS	2048
+#else
+#define SG_MAX_SEGMENTS	SG_CHUNK_SIZE
+#endif
+
+#ifdef CONFIG_SG_POOL
+void sg_free_table_chained(struct sg_table *table, bool first_chunk);
+int sg_alloc_table_chained(struct sg_table *table, int nents,
+			   struct scatterlist *first_chunk);
+#endif
+
+/*
  * sg page iterator
  *
  * Iterates over sg entries page-by-page.  On each successful iteration,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 74dafa7..8ec7c30 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -18,25 +18,6 @@ enum scsi_timeouts {
 };
 
 /*
- * The maximum number of SG segments that we will put inside a
- * scatterlist (unless chaining is used). Should ideally fit inside a
- * single page, to avoid a higher order allocation.  We could define this
- * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
- * minimum value is 32
- */
-#define SG_CHUNK_SIZE	128
-
-/*
- * Like SG_CHUNK_SIZE, but for archs that have sg chaining. This limit
- * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
- */
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-#define SG_MAX_SEGMENTS	2048
-#else
-#define SG_MAX_SEGMENTS	SG_CHUNK_SIZE
-#endif
-
-/*
  * DIX-capable adapters effectively support infinite chaining for the
  * protection information scatterlist
  */
diff --git a/lib/Kconfig b/lib/Kconfig
index 3cca122..61d55bd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -523,6 +523,13 @@ config SG_SPLIT
 	 a scatterlist. This should be selected by a driver or an API which
 	 whishes to split a scatterlist amongst multiple DMA channels.
 
+config SG_POOL
+	def_bool n
+	help
+	 Provides a helper to allocate chained scatterlists. This should be
+	 selected by a driver or an API which whishes to allocate chained
+	 scatterlist.
+
 #
 # sg chaining option
 #
diff --git a/lib/Makefile b/lib/Makefile
index 7bd6fd4..bf01c26 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -178,6 +178,7 @@ obj-$(CONFIG_GENERIC_STRNLEN_USER) += strnlen_user.o
 obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 
 obj-$(CONFIG_SG_SPLIT) += sg_split.o
+obj-$(CONFIG_SG_POOL) += sg_pool.o
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 obj-$(CONFIG_IRQ_POLL) += irq_poll.o
 
diff --git a/lib/sg_pool.c b/lib/sg_pool.c
new file mode 100644
index 0000000..6dd3061
--- /dev/null
+++ b/lib/sg_pool.c
@@ -0,0 +1,172 @@
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/mempool.h>
+#include <linux/slab.h>
+
+#define SG_MEMPOOL_NR		ARRAY_SIZE(sg_pools)
+#define SG_MEMPOOL_SIZE		2
+
+struct sg_pool {
+	size_t		size;
+	char		*name;
+	struct kmem_cache	*slab;
+	mempool_t	*pool;
+};
+
+#define SP(x) { .size = x, "sgpool-" __stringify(x) }
+#if (SG_CHUNK_SIZE < 32)
+#error SG_CHUNK_SIZE is too small (must be 32 or greater)
+#endif
+static struct sg_pool sg_pools[] = {
+	SP(8),
+	SP(16),
+#if (SG_CHUNK_SIZE > 32)
+	SP(32),
+#if (SG_CHUNK_SIZE > 64)
+	SP(64),
+#if (SG_CHUNK_SIZE > 128)
+	SP(128),
+#if (SG_CHUNK_SIZE > 256)
+#error SG_CHUNK_SIZE is too large (256 MAX)
+#endif
+#endif
+#endif
+#endif
+	SP(SG_CHUNK_SIZE)
+};
+#undef SP
+
+static inline unsigned int sg_pool_index(unsigned short nents)
+{
+	unsigned int index;
+
+	BUG_ON(nents > SG_CHUNK_SIZE);
+
+	if (nents <= 8)
+		index = 0;
+	else
+		index = get_count_order(nents) - 3;
+
+	return index;
+}
+
+static void sg_pool_free(struct scatterlist *sgl, unsigned int nents)
+{
+	struct sg_pool *sgp;
+
+	sgp = sg_pools + sg_pool_index(nents);
+	mempool_free(sgl, sgp->pool);
+}
+
+static struct scatterlist *sg_pool_alloc(unsigned int nents, gfp_t gfp_mask)
+{
+	struct sg_pool *sgp;
+
+	sgp = sg_pools + sg_pool_index(nents);
+	return mempool_alloc(sgp->pool, gfp_mask);
+}
+
+/**
+ * sg_free_table_chained - Free a previously mapped sg table
+ * @table:	The sg table header to use
+ * @first_chunk: was first_chunk not NULL in sg_alloc_table_chained?
+ *
+ *  Description:
+ *    Free an sg table previously allocated and setup with
+ *    sg_alloc_table_chained().
+ *
+ **/
+void sg_free_table_chained(struct sg_table *table, bool first_chunk)
+{
+	if (first_chunk && table->orig_nents <= SG_CHUNK_SIZE)
+		return;
+	__sg_free_table(table, SG_CHUNK_SIZE, first_chunk, sg_pool_free);
+}
+EXPORT_SYMBOL_GPL(sg_free_table_chained);
+
+/**
+ * sg_alloc_table_chained - Allocate and chain SGLs in an sg table
+ * @table:	The sg table header to use
+ * @nents:	Number of entries in sg list
+ * @first_chunk: first SGL
+ *
+ *  Description:
+ *    Allocate and chain SGLs in an sg table. If @nents@ is larger than
+ *    SG_CHUNK_SIZE a chained sg table will be setup.
+ *
+ **/
+int sg_alloc_table_chained(struct sg_table *table, int nents,
+		struct scatterlist *first_chunk)
+{
+	int ret;
+
+	BUG_ON(!nents);
+
+	if (first_chunk) {
+		if (nents <= SG_CHUNK_SIZE) {
+			table->nents = table->orig_nents = nents;
+			sg_init_table(table->sgl, nents);
+			return 0;
+		}
+	}
+
+	ret = __sg_alloc_table(table, nents, SG_CHUNK_SIZE,
+			       first_chunk, GFP_ATOMIC, sg_pool_alloc);
+	if (unlikely(ret))
+		sg_free_table_chained(table, (bool)first_chunk);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sg_alloc_table_chained);
+
+static __init int sg_pool_init(void)
+{
+	int i;
+
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct sg_pool *sgp = sg_pools + i;
+		int size = sgp->size * sizeof(struct scatterlist);
+
+		sgp->slab = kmem_cache_create(sgp->name, size, 0,
+				SLAB_HWCACHE_ALIGN, NULL);
+		if (!sgp->slab) {
+			printk(KERN_ERR "SG_POOL: can't init sg slab %s\n",
+					sgp->name);
+			goto cleanup_sdb;
+		}
+
+		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
+						     sgp->slab);
+		if (!sgp->pool) {
+			printk(KERN_ERR "SG_POOL: can't init sg mempool %s\n",
+					sgp->name);
+			goto cleanup_sdb;
+		}
+	}
+
+	return 0;
+
+cleanup_sdb:
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct sg_pool *sgp = sg_pools + i;
+		if (sgp->pool)
+			mempool_destroy(sgp->pool);
+		if (sgp->slab)
+			kmem_cache_destroy(sgp->slab);
+	}
+
+	return -ENOMEM;
+}
+
+static __exit void sg_pool_exit(void)
+{
+	int i;
+
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct sg_pool *sgp = sg_pools + i;
+		mempool_destroy(sgp->pool);
+		kmem_cache_destroy(sgp->slab);
+	}
+}
+
+module_init(sg_pool_init);
+module_exit(sg_pool_exit);
-- 
1.9.1
