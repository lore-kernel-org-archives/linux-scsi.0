From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] tgt: Use scsi_init_io instead of scsi_alloc_sgtable
Date: Thu, 08 Nov 2007 18:57:46 +0200
Message-ID: <4733400A.6050503@panasas.com>
References: <4730ACAA.2060007@panasas.com> <47333E2A.7020307@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:51908 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759389AbXKHQ56 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 11:57:58 -0500
In-Reply-To: <47333E2A.7020307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@osdl.org>


  - If we export scsi_init_io()/scsi_release_buffers() instead of
    scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
    much more insulated from scsi_lib changes. As a bonus it will
    also gain bidi capability when it comes.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---
 drivers/scsi/scsi_lib.c     |   21 ++++++++++-----------
 drivers/scsi/scsi_tgt_lib.c |   34 +++++-----------------------------
 include/scsi/scsi_cmnd.h    |    4 ++--
 3 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0e81e4c..6d8ea69 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -737,7 +737,8 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd,
+								gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl, *prev, *ret;
@@ -823,9 +824,7 @@ enomem:
 	return NULL;
 }
 
-EXPORT_SYMBOL(scsi_alloc_sgtable);
-
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+static void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
 	struct scatterlist *sgl = cmd->request_buffer;
 	struct scsi_host_sg_pool *sgp;
@@ -871,8 +870,6 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 	mempool_free(sgl, sgp->pool);
 }
 
-EXPORT_SYMBOL(scsi_free_sgtable);
-
 /*
  * Function:    scsi_release_buffers()
  *
@@ -890,7 +887,7 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  *		the scatter-gather table, and potentially any bounce
  *		buffers.
  */
-static void scsi_release_buffers(struct scsi_cmnd *cmd)
+void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->use_sg)
 		scsi_free_sgtable(cmd);
@@ -902,6 +899,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
 }
+EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
  * Function:    scsi_io_completion()
@@ -1104,7 +1102,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
  *		BLKPREP_DEFER if the failure is retryable
  *		BLKPREP_KILL if the failure is fatal
  */
-static int scsi_init_io(struct scsi_cmnd *cmd)
+int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request     *req = cmd->request;
 	int		   count;
@@ -1119,7 +1117,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
+	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
 	if (unlikely(!cmd->request_buffer)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
@@ -1148,6 +1146,7 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 
 	return BLKPREP_KILL;
 }
+EXPORT_SYMBOL(scsi_init_io);
 
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		struct request *req)
@@ -1193,7 +1192,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 
 		BUG_ON(!req->nr_phys_segments);
 
-		ret = scsi_init_io(cmd);
+		ret = scsi_init_io(cmd, GFP_ATOMIC);
 		if (unlikely(ret))
 			return ret;
 	} else {
@@ -1244,7 +1243,7 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (unlikely(!cmd))
 		return BLKPREP_DEFER;
 
-	return scsi_init_io(cmd);
+	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index deea3cd..5fd5fca 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -331,8 +331,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (scsi_sglist(cmd))
-		scsi_free_sgtable(cmd);
+	scsi_release_buffers(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -353,31 +352,6 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
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
-	if (likely(count <= scsi_sg_count(cmd))) {
-		cmd->use_sg = count;
-		return 0;
-	}
-
-	eprintk("cmd %p cnt %d\n", cmd, scsi_sg_count(cmd));
-	scsi_free_sgtable(cmd);
-	return -EINVAL;
-}
-
 /* TODO: test this crap and replace bio_map_user with new interface maybe */
 static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 			       unsigned long uaddr, unsigned int len, int rw)
@@ -403,9 +377,11 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
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
1.5.3.1


