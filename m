From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2] add bidi support for block pc requests
Date: Tue, 08 May 2007 11:25:53 +0900
Message-ID: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:64326 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967606AbXEHC1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 22:27:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

Here is an updated version of the patch to add bidi support to block
pc requests. Bugs spotted by Benny were fixed.

This patch can be applied cleanly to the scsi-misc git tree and is on
the top of the following patch to add linked request support:

http://marc.info/?l=linux-scsi&m=117835587615642&w=2

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 7 May 2007 16:42:24 +0900
Subject: [PATCH] add bidi support to scsi pc commands

This adds bidi support to block pc requests.

A bidi request uses req->next_rq pointer for an in request.

This patch introduces a new structure, scsi_data_buffer to hold the
data buffer information. To avoid make scsi_cmnd structure fatter, the
scsi mid-layer uses cmnd->request->next_rq->special pointer for
a scsi_data_buffer structure. LLDs don't touch the second request
(req->next_rq) so it's safe to use req->special.

scsi_blk_pc_done() always completes the whole command so
scsi_end_request() simply completes the bidi chunk too.

A helper function, scsi_bidi_data_buffer() is for LLDs to access to
the scsi_data_buffer structure easily.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |  128 +++++++++++++++++++++++++++++++++++++++------
 include/scsi/scsi_cmnd.h |   14 +++++
 2 files changed, 125 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fbcdc..ba874a6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -66,6 +66,12 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 
 static void scsi_run_queue(struct request_queue *q);
 
+struct scsi_data_buffer *scsi_bidi_data_buffer(struct scsi_cmnd *cmd)
+{
+	return blk_bidi_rq(cmd->request) ? cmd->request->next_rq->special : NULL;
+}
+EXPORT_SYMBOL(scsi_bidi_data_buffer);
+
 /*
  * Function:	scsi_unprep_request()
  *
@@ -81,10 +87,14 @@ static void scsi_run_queue(struct request_queue *q);
 static void scsi_unprep_request(struct request *req)
 {
 	struct scsi_cmnd *cmd = req->special;
+	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
 
 	req->cmd_flags &= ~REQ_DONTPREP;
 	req->special = NULL;
-
+	if (sdb) {
+		kfree(sdb);
+		req->next_rq->special = NULL;
+	}
 	scsi_put_command(cmd);
 }
 
@@ -657,6 +667,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	unsigned long flags;
+	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
 
 	/*
 	 * If there are blocks left over at the end, set up the command
@@ -685,6 +696,14 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 		}
 	}
 
+	/*
+	 * a REQ_BLOCK_PC command is always completed fully so just do
+	 * end the bidi chunk.
+	 */
+	if (sdb)
+		end_that_request_chunk(req->next_rq, uptodate,
+				       sdb->request_bufflen);
+
 	add_disk_randomness(req->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -701,34 +720,35 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static struct scatterlist *do_scsi_alloc_sgtable(unsigned short use_sg,
+						 unsigned short *sglist_len,
+						 gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl;
 
-	BUG_ON(!cmd->use_sg);
+	BUG_ON(!use_sg);
 
-	switch (cmd->use_sg) {
+	switch (use_sg) {
 	case 1 ... 8:
-		cmd->sglist_len = 0;
+		*sglist_len = 0;
 		break;
 	case 9 ... 16:
-		cmd->sglist_len = 1;
+		*sglist_len = 1;
 		break;
 	case 17 ... 32:
-		cmd->sglist_len = 2;
+		*sglist_len = 2;
 		break;
 #if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	case 33 ... 64:
-		cmd->sglist_len = 3;
+		*sglist_len = 3;
 		break;
 #if (SCSI_MAX_PHYS_SEGMENTS > 64)
 	case 65 ... 128:
-		cmd->sglist_len = 4;
+		*sglist_len = 4;
 		break;
 #if (SCSI_MAX_PHYS_SEGMENTS  > 128)
 	case 129 ... 256:
-		cmd->sglist_len = 5;
+		*sglist_len = 5;
 		break;
 #endif
 #endif
@@ -737,11 +757,14 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		return NULL;
 	}
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	return sgl;
+	sgp = scsi_sg_pools + *sglist_len;
+	return mempool_alloc(sgp->pool, gfp_mask);
 }
 
+struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	return do_scsi_alloc_sgtable(cmd->use_sg, &cmd->sglist_len, gfp_mask);
+}
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
 void scsi_free_sgtable(struct scatterlist *sgl, int index)
@@ -775,6 +798,8 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
+	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
+
 	if (cmd->use_sg)
 		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 
@@ -784,6 +809,15 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 	 */
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
+
+	if (sdb) {
+		if (sdb->use_sg)
+			scsi_free_sgtable(sdb->request_buffer, sdb->sglist_len);
+		sdb->request_buffer = NULL;
+		sdb->request_bufflen = 0;
+		kfree(sdb);
+		cmd->request->next_rq->special = NULL;
+	}
 }
 
 /*
@@ -834,6 +868,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
+		struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
 		req->errors = result;
 		if (result) {
 			clear_errors = 0;
@@ -850,6 +885,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			}
 		}
 		req->data_len = cmd->resid;
+		if (sdb)
+			req->next_rq->data_len = sdb->resid;
 	}
 
 	/*
@@ -1075,6 +1112,38 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	return cmd;
 }
 
+static int scsi_data_buffer_init(struct scsi_cmnd *cmd)
+{
+	struct scatterlist *sgpnt;
+	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
+	struct request *req = cmd->request;
+	int count;
+
+	sdb->use_sg = req->next_rq->nr_phys_segments;
+	sgpnt = do_scsi_alloc_sgtable(sdb->use_sg, &sdb->sglist_len,
+				      GFP_ATOMIC);
+	if (unlikely(!sgpnt)) {
+		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+		scsi_unprep_request(req);
+		return BLKPREP_DEFER;
+	}
+
+	req->next_rq->buffer = NULL;
+	sdb->request_buffer = (char *) sgpnt;
+	sdb->request_bufflen = req->next_rq->data_len;
+
+	count = blk_rq_map_sg(req->q, req->next_rq, sgpnt);
+	if (likely(count <= sdb->use_sg)) {
+		sdb->use_sg = count;
+		return BLKPREP_OK;
+	}
+
+	scsi_release_buffers(cmd);
+	scsi_put_command(cmd);
+
+	return BLKPREP_KILL;
+}
+
 static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
@@ -1090,10 +1159,22 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
+	struct scsi_data_buffer *sdb = NULL;
+
+	if (blk_bidi_rq(req)) {
+		sdb = kzalloc(sizeof(*sdb), GFP_ATOMIC);
+		if (unlikely(!sdb))
+			return BLKPREP_DEFER;
+	}
 
 	cmd = scsi_get_cmd_from_req(sdev, req);
-	if (unlikely(!cmd))
+	if (unlikely(!cmd)) {
+		kfree(sdb);
 		return BLKPREP_DEFER;
+	}
+
+	if (sdb)
+		req->next_rq->special = sdb;
 
 	/*
 	 * BLOCK_PC requests may transfer data, in which case they must
@@ -1109,6 +1190,12 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		ret = scsi_init_io(cmd);
 		if (unlikely(ret))
 			return ret;
+
+		if (sdb) {
+			ret = scsi_data_buffer_init(cmd);
+			if (ret != BLKPREP_OK)
+				return ret;
+		}
 	} else {
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
@@ -1122,13 +1209,15 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
-	if (!req->data_len)
+	if (sdb)
+		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+	else if (!req->data_len)
 		cmd->sc_data_direction = DMA_NONE;
 	else if (rq_data_dir(req) == WRITE)
 		cmd->sc_data_direction = DMA_TO_DEVICE;
 	else
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
-	
+
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
@@ -1178,6 +1267,11 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_OK;
 
+	if (WARN_ON(!blk_pc_request(req) && blk_bidi_rq(req))) {
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+
 	/*
 	 * If the device is not in running state we will reject some
 	 * or all commands.
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..597c48c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -28,6 +28,18 @@ struct scsi_pointer {
 	volatile int phase;
 };
 
+struct scsi_data_buffer {
+	unsigned short use_sg;		/* Number of pieces of scatter-gather */
+	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
+	void *request_buffer;		/* Actual requested buffer */
+	unsigned request_bufflen;	/* Actual request size */
+	/*
+	 * Number of bytes requested to be transferred less actual
+	 * number transferred (0 if not supported)
+	*/
+	int resid;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
@@ -135,4 +147,6 @@ extern void scsi_kunmap_atomic_sg(void *virt);
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+extern struct scsi_data_buffer *scsi_bidi_data_buffer(struct scsi_cmnd *);
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.4.4.3

