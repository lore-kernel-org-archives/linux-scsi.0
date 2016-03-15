From: Ming Lin <mlin@kernel.org>
Subject: [PATCH RFC 2/2] scsi: use the new chained SG api
Date: Tue, 15 Mar 2016 15:39:29 -0700
Message-ID: <1458081569-30953-3-git-send-email-mlin@kernel.org>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

This removes the old code and uses the new chained SG alloc/free api.

Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/scsi/scsi_lib.c | 129 +++---------------------------------------------
 1 file changed, 7 insertions(+), 122 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8c6e318..97e283c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -39,40 +39,6 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-
-#define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
-#define SG_MEMPOOL_SIZE		2
-
-struct scsi_host_sg_pool {
-	size_t		size;
-	char		*name;
-	struct kmem_cache	*slab;
-	mempool_t	*pool;
-};
-
-#define SP(x) { .size = x, "sgpool-" __stringify(x) }
-#if (SCSI_MAX_SG_SEGMENTS < 32)
-#error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
-#endif
-static struct scsi_host_sg_pool scsi_sg_pools[] = {
-	SP(8),
-	SP(16),
-#if (SCSI_MAX_SG_SEGMENTS > 32)
-	SP(32),
-#if (SCSI_MAX_SG_SEGMENTS > 64)
-	SP(64),
-#if (SCSI_MAX_SG_SEGMENTS > 128)
-	SP(128),
-#if (SCSI_MAX_SG_SEGMENTS > 256)
-#error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
-#endif
-#endif
-#endif
-#endif
-	SP(SCSI_MAX_SG_SEGMENTS)
-};
-#undef SP
-
 struct kmem_cache *scsi_sdb_cache;
 
 /*
@@ -553,61 +519,23 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static inline unsigned int scsi_sgtable_index(unsigned short nents)
-{
-	unsigned int index;
-
-	BUG_ON(nents > SCSI_MAX_SG_SEGMENTS);
-
-	if (nents <= 8)
-		index = 0;
-	else
-		index = get_count_order(nents) - 3;
-
-	return index;
-}
-
-static void scsi_sg_free(struct scatterlist *sgl, unsigned int nents)
-{
-	struct scsi_host_sg_pool *sgp;
-
-	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
-	mempool_free(sgl, sgp->pool);
-}
-
-static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
-{
-	struct scsi_host_sg_pool *sgp;
-
-	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
-	return mempool_alloc(sgp->pool, gfp_mask);
-}
-
 static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 {
-	if (mq && sdb->table.orig_nents <= SCSI_MAX_SG_SEGMENTS)
-		return;
-	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
+	sg_free_chained(&sdb->table, mq);
 }
 
 static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 {
-	struct scatterlist *first_chunk = NULL;
+	struct scatterlist *first_chunk;
 	int ret;
 
-	BUG_ON(!nents);
-
-	if (mq) {
-		if (nents <= SCSI_MAX_SG_SEGMENTS) {
-			sdb->table.nents = sdb->table.orig_nents = nents;
-			sg_init_table(sdb->table.sgl, nents);
-			return 0;
-		}
+	if (mq)
 		first_chunk = sdb->table.sgl;
-	}
+	else
+		first_chunk = NULL;
+
+	ret = sg_alloc_chained(&sdb->table, nents, first_chunk, GFP_ATOMIC);
 
-	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
-			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
 	if (unlikely(ret))
 		scsi_free_sgtable(sdb, mq);
 	return ret;
@@ -2264,8 +2192,6 @@ EXPORT_SYMBOL(scsi_unblock_requests);
 
 int __init scsi_init_queue(void)
 {
-	int i;
-
 	scsi_sdb_cache = kmem_cache_create("scsi_data_buffer",
 					   sizeof(struct scsi_data_buffer),
 					   0, 0, NULL);
@@ -2274,53 +2200,12 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
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
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
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
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		mempool_destroy(sgp->pool);
-		kmem_cache_destroy(sgp->slab);
-	}
 }
 
 /**
-- 
1.9.1
