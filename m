From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] tgt: Use scsi_init_io instead of scsi_alloc_sgtable
Date: Thu, 13 Dec 2007 13:44:01 +0200
Message-ID: <47611B01.4010505@panasas.com>
References: <47611977.5080702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21779 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759843AbXLMLo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 06:44:26 -0500
In-Reply-To: <47611977.5080702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>


  - If we export scsi_init_io()/scsi_release_buffers() instead of
    scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
    much more insulated from scsi_lib changes. As a bonus it will
    also gain bidi capability when it comes.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c     |   21 ++++++++++-----------
 drivers/scsi/scsi_tgt_lib.c |   29 +++++------------------------
 include/scsi/scsi_cmnd.h    |    4 ++--
 3 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e273e4b..d1a4671 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -739,7 +739,8 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd,
+								gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl, *prev, *ret;
@@ -825,9 +826,7 @@ enomem:
 	return NULL;
 }
 
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+static void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
 	struct scatterlist *sgl = cmd->request_buffer;
 	struct scsi_host_sg_pool *sgp;
@@ -873,8 +872,6 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 	mempool_free(sgl, sgp->pool);
 }
 
-EXPORT_SYMBOL(scsi_free_sgtable);
-
 /*
  * Function:    scsi_release_buffers()
  *
@@ -892,7 +889,7 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  *		the scatter-gather table, and potentially any bounce
  *		buffers.
  */
-static void scsi_release_buffers(struct scsi_cmnd *cmd)
+void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->use_sg)
 		scsi_free_sgtable(cmd);
@@ -904,6 +901,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
 }
+EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
  * Function:    scsi_io_completion()
@@ -1105,7 +1103,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
  * Returns:     0 on success
  *		BLKPREP_DEFER if the failure is retryable
  */
-static int scsi_init_io(struct scsi_cmnd *cmd)
+int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request     *req = cmd->request;
 	int		   count;
@@ -1120,7 +1118,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
+	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
 	if (unlikely(!cmd->request_buffer)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
@@ -1141,6 +1139,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	cmd->use_sg = count;
 	return BLKPREP_OK;
 }
+EXPORT_SYMBOL(scsi_init_io);
 
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		struct request *req)
@@ -1186,7 +1185,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 
 		BUG_ON(!req->nr_phys_segments);
 
-		ret = scsi_init_io(cmd);
+		ret = scsi_init_io(cmd, GFP_ATOMIC);
 		if (unlikely(ret))
 			return ret;
 	} else {
@@ -1237,7 +1236,7 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (unlikely(!cmd))
 		return BLKPREP_DEFER;
 
-	return scsi_init_io(cmd);
+	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 93ece8f..91630ba 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -331,8 +331,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (scsi_sglist(cmd))
-		scsi_free_sgtable(cmd);
+	scsi_release_buffers(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -353,26 +352,6 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
 	return 0;
 }
 
-static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
-{
-	struct request *rq = cmd->request;
-	int count;
-
-	cmd->use_sg = rq->nr_phys_segments;
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
-	if (!cmd->request_buffer)
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
@@ -398,9 +377,11 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
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
index 3f47e52..a7be605 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -128,8 +128,8 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask);
+extern void scsi_release_buffers(struct scsi_cmnd *cmd);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
-- 
1.5.3.3


