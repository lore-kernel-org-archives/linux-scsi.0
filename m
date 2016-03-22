From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v2 3/5] scsi: rename SG related struct and functions
Date: Tue, 22 Mar 2016 15:03:14 -0700
Message-ID: <1458684196-15923-4-git-send-email-mlin@kernel.org>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1458684196-15923-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

Rename SCSI specific struct and functions to more genenic names.

Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/scsi/scsi_lib.c | 52 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ab3dd09..5fd9dd7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -40,10 +40,10 @@
 #include "scsi_logging.h"
 
 
-#define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
+#define SG_MEMPOOL_NR		ARRAY_SIZE(sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
-struct scsi_host_sg_pool {
+struct sg_pool {
 	size_t		size;
 	char		*name;
 	struct kmem_cache	*slab;
@@ -54,7 +54,7 @@ struct scsi_host_sg_pool {
 #if (SCSI_MAX_SG_SEGMENTS < 32)
 #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
 #endif
-static struct scsi_host_sg_pool scsi_sg_pools[] = {
+static struct sg_pool sg_pools[] = {
 	SP(8),
 	SP(16),
 #if (SCSI_MAX_SG_SEGMENTS > 32)
@@ -553,7 +553,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static inline unsigned int scsi_sgtable_index(unsigned short nents)
+static inline unsigned int sg_pool_index(unsigned short nents)
 {
 	unsigned int index;
 
@@ -567,30 +567,30 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-static void scsi_sg_free(struct scatterlist *sgl, unsigned int nents)
+static void sg_pool_free(struct scatterlist *sgl, unsigned int nents)
 {
-	struct scsi_host_sg_pool *sgp;
+	struct sg_pool *sgp;
 
-	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
+	sgp = sg_pools + sg_pool_index(nents);
 	mempool_free(sgl, sgp->pool);
 }
 
-static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
+static struct scatterlist *sg_pool_alloc(unsigned int nents, gfp_t gfp_mask)
 {
-	struct scsi_host_sg_pool *sgp;
+	struct sg_pool *sgp;
 
-	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
+	sgp = sg_pools + sg_pool_index(nents);
 	return mempool_alloc(sgp->pool, gfp_mask);
 }
 
-static void scsi_free_sgtable(struct sg_table *table, bool first_chunk)
+static void sg_free_table_chained(struct sg_table *table, bool first_chunk)
 {
 	if (first_chunk && table->orig_nents <= SCSI_MAX_SG_SEGMENTS)
 		return;
-	__sg_free_table(table, SCSI_MAX_SG_SEGMENTS, first_chunk, scsi_sg_free);
+	__sg_free_table(table, SCSI_MAX_SG_SEGMENTS, first_chunk, sg_pool_free);
 }
 
-static int scsi_alloc_sgtable(struct sg_table *table, int nents,
+static int sg_alloc_table_chained(struct sg_table *table, int nents,
 		struct scatterlist *first_chunk)
 {
 	int ret;
@@ -606,9 +606,9 @@ static int scsi_alloc_sgtable(struct sg_table *table, int nents,
 	}
 
 	ret = __sg_alloc_table(table, nents, SCSI_MAX_SG_SEGMENTS,
-			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
+			       first_chunk, GFP_ATOMIC, sg_pool_alloc);
 	if (unlikely(ret))
-		scsi_free_sgtable(table, (bool)first_chunk);
+		sg_free_table_chained(table, (bool)first_chunk);
 	return ret;
 }
 
@@ -627,14 +627,14 @@ static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 	struct scsi_data_buffer *sdb;
 
 	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb.table, true);
+		sg_free_table_chained(&cmd->sdb.table, true);
 	if (cmd->request->next_rq) {
 		sdb = cmd->request->next_rq->special;
 		if (sdb)
-			scsi_free_sgtable(&sdb->table, true);
+			sg_free_table_chained(&sdb->table, true);
 	}
 	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(&cmd->prot_sdb->table, true);
+		sg_free_table_chained(&cmd->prot_sdb->table, true);
 }
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
@@ -673,19 +673,19 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb.table, false);
+		sg_free_table_chained(&cmd->sdb.table, false);
 
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 
 	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(&cmd->prot_sdb->table, false);
+		sg_free_table_chained(&cmd->prot_sdb->table, false);
 }
 
 static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
 {
 	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
 
-	scsi_free_sgtable(&bidi_sdb->table, false);
+	sg_free_table_chained(&bidi_sdb->table, false);
 	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 	cmd->request->next_rq->special = NULL;
 }
@@ -1089,7 +1089,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	if (unlikely(scsi_alloc_sgtable(&sdb->table, req->nr_phys_segments,
+	if (unlikely(sg_alloc_table_chained(&sdb->table, req->nr_phys_segments,
 					sdb->table.sgl)))
 		return BLKPREP_DEFER;
 
@@ -1162,7 +1162,7 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
-		if (scsi_alloc_sgtable(&prot_sdb->table, ivecs,
+		if (sg_alloc_table_chained(&prot_sdb->table, ivecs,
 				prot_sdb->table.sgl)) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
@@ -2280,7 +2280,7 @@ int __init scsi_init_queue(void)
 	}
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		struct sg_pool *sgp = sg_pools + i;
 		int size = sgp->size * sizeof(struct scatterlist);
 
 		sgp->slab = kmem_cache_create(sgp->name, size, 0,
@@ -2304,7 +2304,7 @@ int __init scsi_init_queue(void)
 
 cleanup_sdb:
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		struct sg_pool *sgp = sg_pools + i;
 		if (sgp->pool)
 			mempool_destroy(sgp->pool);
 		if (sgp->slab)
@@ -2322,7 +2322,7 @@ void scsi_exit_queue(void)
 	kmem_cache_destroy(scsi_sdb_cache);
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		struct sg_pool *sgp = sg_pools + i;
 		mempool_destroy(sgp->pool);
 		kmem_cache_destroy(sgp->slab);
 	}
-- 
1.9.1
