From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v3 1/5] scsi: replace "scsi_data_buffer" with "sg_table" in SG
 functions
Date: Mon, 04 Apr 2016 14:48:07 -0700
Message-ID: <1459806491-16428-2-git-send-email-mlin@kernel.org>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

Replace parameter "struct scsi_data_buffer" with "struct sg_table" in
SG alloc/free functions to make them generic.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/scsi/scsi_lib.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..4229c18 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,14 +583,14 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
 	return mempool_alloc(sgp->pool, gfp_mask);
 }
 
-static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
+static void scsi_free_sgtable(struct sg_table *table, bool mq)
 {
-	if (mq && sdb->table.orig_nents <= SCSI_MAX_SG_SEGMENTS)
+	if (mq && table->orig_nents <= SCSI_MAX_SG_SEGMENTS)
 		return;
-	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
+	__sg_free_table(table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
 }
 
-static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
+static int scsi_alloc_sgtable(struct sg_table *table, int nents, bool mq)
 {
 	struct scatterlist *first_chunk = NULL;
 	int ret;
@@ -599,17 +599,17 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 
 	if (mq) {
 		if (nents <= SCSI_MAX_SG_SEGMENTS) {
-			sdb->table.nents = sdb->table.orig_nents = nents;
-			sg_init_table(sdb->table.sgl, nents);
+			table->nents = table->orig_nents = nents;
+			sg_init_table(table->sgl, nents);
 			return 0;
 		}
-		first_chunk = sdb->table.sgl;
+		first_chunk = table->sgl;
 	}
 
-	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
+	ret = __sg_alloc_table(table, nents, SCSI_MAX_SG_SEGMENTS,
 			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
 	if (unlikely(ret))
-		scsi_free_sgtable(sdb, mq);
+		scsi_free_sgtable(table, mq);
 	return ret;
 }
 
@@ -625,12 +625,17 @@ static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 
 static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 {
+	struct scsi_data_buffer *sdb;
+
 	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb, true);
-	if (cmd->request->next_rq && cmd->request->next_rq->special)
-		scsi_free_sgtable(cmd->request->next_rq->special, true);
+		scsi_free_sgtable(&cmd->sdb.table, true);
+	if (cmd->request->next_rq) {
+		sdb = cmd->request->next_rq->special;
+		if (sdb)
+			scsi_free_sgtable(&sdb->table, true);
+	}
 	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(cmd->prot_sdb, true);
+		scsi_free_sgtable(&cmd->prot_sdb->table, true);
 }
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
@@ -669,19 +674,19 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb, false);
+		scsi_free_sgtable(&cmd->sdb.table, false);
 
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 
 	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(cmd->prot_sdb, false);
+		scsi_free_sgtable(&cmd->prot_sdb->table, false);
 }
 
 static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
 {
 	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
 
-	scsi_free_sgtable(bidi_sdb, false);
+	scsi_free_sgtable(&bidi_sdb->table, false);
 	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 	cmd->request->next_rq->special = NULL;
 }
@@ -1085,7 +1090,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
+	if (unlikely(scsi_alloc_sgtable(&sdb->table, req->nr_phys_segments,
 					req->mq_ctx != NULL)))
 		return BLKPREP_DEFER;
 
@@ -1158,7 +1163,7 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
-		if (scsi_alloc_sgtable(prot_sdb, ivecs, is_mq)) {
+		if (scsi_alloc_sgtable(&prot_sdb->table, ivecs, is_mq)) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
 		}
-- 
1.9.1
