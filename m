From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] tgt: use scsi_init_io instead of scsi_alloc_sgtable
Date: Fri, 11 Jan 2008 21:11:23 -0600
Message-ID: <1200107483.3286.81.camel@localhost.localdomain>
References: <1200107340.3286.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42413 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbYALDL2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 22:11:28 -0500
In-Reply-To: <1200107340.3286.79.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 13 Dec 2007 16:14:27 -0800
Subject: [SCSI] tgt: use scsi_init_io instead of scsi_alloc_sgtable

If we export scsi_init_io()/scsi_release_buffers() instead of
scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is much more
insulated from scsi_lib changes. As a bonus it will also gain bidi
capability when it comes.

[jejb: rebase on to sg_table and fix up rejections]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c     |   20 +++++++++-----------
 drivers/scsi/scsi_tgt_lib.c |   28 +++++-----------------------
 include/scsi/scsi_cmnd.h    |    4 ++--
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0849c7c..5bc60f9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -755,7 +755,7 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
 	return mempool_alloc(sgp->pool, gfp_mask);
 }
 
-int scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static int scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	int ret;
 
@@ -769,15 +769,11 @@ int scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	return ret;
 }
 
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+static void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
 	__sg_free_table(&cmd->sg_table, scsi_sg_free);
 }
 
-EXPORT_SYMBOL(scsi_free_sgtable);
-
 /*
  * Function:    scsi_release_buffers()
  *
@@ -795,7 +791,7 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  *		the scatter-gather table, and potentially any bounce
  *		buffers.
  */
-static void scsi_release_buffers(struct scsi_cmnd *cmd)
+void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->use_sg)
 		scsi_free_sgtable(cmd);
@@ -807,6 +803,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
 }
+EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
  * Function:    scsi_io_completion()
@@ -1008,7 +1005,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
  * Returns:     0 on success
  *		BLKPREP_DEFER if the failure is retryable
  */
-static int scsi_init_io(struct scsi_cmnd *cmd)
+int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request     *req = cmd->request;
 	int		   count;
@@ -1023,7 +1020,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	if (unlikely(scsi_alloc_sgtable(cmd, GFP_ATOMIC))) {
+	if (unlikely(scsi_alloc_sgtable(cmd, gfp_mask))) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
@@ -1043,6 +1040,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	cmd->use_sg = count;
 	return BLKPREP_OK;
 }
+EXPORT_SYMBOL(scsi_init_io);
 
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		struct request *req)
@@ -1088,7 +1086,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 
 		BUG_ON(!req->nr_phys_segments);
 
-		ret = scsi_init_io(cmd);
+		ret = scsi_init_io(cmd, GFP_ATOMIC);
 		if (unlikely(ret))
 			return ret;
 	} else {
@@ -1139,7 +1137,7 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (unlikely(!cmd))
 		return BLKPREP_DEFER;
 
-	return scsi_init_io(cmd);
+	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 01e03f3..91630ba 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -331,8 +331,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (scsi_sglist(cmd))
-		scsi_free_sgtable(cmd);
+	scsi_release_buffers(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -353,25 +352,6 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
 	return 0;
 }
 
-static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
-{
-	struct request *rq = cmd->request;
-	int count;
-
-	cmd->use_sg = rq->nr_phys_segments;
-	if (scsi_alloc_sgtable(cmd, gfp_mask))
-		return -ENOMEM;
-
-	cmd->request_bufflen = rq->data_len;
-
-	dprintk("cmd %p cnt %d %lu\n", cmd, scsi_sg_count(cmd),
-		rq_data_dir(rq));
-	count = blk_rq_map_sg(rq->q, rq, scsi_sglist(cmd));
-	BUG_ON(count > cmd->use_sg);
-	cmd->use_sg = count;
-	return 0;
-}
-
 /* TODO: test this crap and replace bio_map_user with new interface maybe */
 static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 			       unsigned long uaddr, unsigned int len, int rw)
@@ -397,9 +377,11 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 	}
 
 	tcmd->bio = rq->bio;
-	err = scsi_tgt_init_cmd(cmd, GFP_KERNEL);
-	if (err)
+	err = scsi_init_io(cmd, GFP_KERNEL);
+	if (err) {
+		scsi_release_buffers(cmd);
 		goto unmap_rq;
+	}
 
 	return 0;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 40f7c7c..764b929 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -127,8 +127,8 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern int scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask);
+extern void scsi_release_buffers(struct scsi_cmnd *cmd);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
-- 
1.5.3.7



