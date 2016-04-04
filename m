From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v3 2/5] scsi: replace "mq" with "first_chunk" in SG functions
Date: Mon, 04 Apr 2016 14:48:08 -0700
Message-ID: <1459806491-16428-3-git-send-email-mlin@kernel.org>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:58488 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbcDDVsa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 17:48:30 -0400
In-reply-to: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>

From: Ming Lin <ming.l@ssi.samsung.com>

Parameter "bool mq" is block driver specific.
Change it to "first_chunk" to make it more generic.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/scsi/scsi_lib.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4229c18..9675353 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,33 +583,32 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
 	return mempool_alloc(sgp->pool, gfp_mask);
 }
 
-static void scsi_free_sgtable(struct sg_table *table, bool mq)
+static void scsi_free_sgtable(struct sg_table *table, bool first_chunk)
 {
-	if (mq && table->orig_nents <= SCSI_MAX_SG_SEGMENTS)
+	if (first_chunk && table->orig_nents <= SCSI_MAX_SG_SEGMENTS)
 		return;
-	__sg_free_table(table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
+	__sg_free_table(table, SCSI_MAX_SG_SEGMENTS, first_chunk, scsi_sg_free);
 }
 
-static int scsi_alloc_sgtable(struct sg_table *table, int nents, bool mq)
+static int scsi_alloc_sgtable(struct sg_table *table, int nents,
+		struct scatterlist *first_chunk)
 {
-	struct scatterlist *first_chunk = NULL;
 	int ret;
 
 	BUG_ON(!nents);
 
-	if (mq) {
+	if (first_chunk) {
 		if (nents <= SCSI_MAX_SG_SEGMENTS) {
 			table->nents = table->orig_nents = nents;
 			sg_init_table(table->sgl, nents);
 			return 0;
 		}
-		first_chunk = table->sgl;
 	}
 
 	ret = __sg_alloc_table(table, nents, SCSI_MAX_SG_SEGMENTS,
 			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
 	if (unlikely(ret))
-		scsi_free_sgtable(table, mq);
+		scsi_free_sgtable(table, (bool)first_chunk);
 	return ret;
 }
 
@@ -1091,7 +1090,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 	 * If sg table allocation fails, requeue request later.
 	 */
 	if (unlikely(scsi_alloc_sgtable(&sdb->table, req->nr_phys_segments,
-					req->mq_ctx != NULL)))
+					sdb->table.sgl)))
 		return BLKPREP_DEFER;
 
 	/* 
@@ -1163,7 +1162,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
-		if (scsi_alloc_sgtable(&prot_sdb->table, ivecs, is_mq)) {
+		if (scsi_alloc_sgtable(&prot_sdb->table, ivecs,
+				prot_sdb->table.sgl)) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
 		}
-- 
1.9.1

