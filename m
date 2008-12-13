From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] osst: replace scsi_execute_async with the block layer API
Date: Sun, 14 Dec 2008 00:55:18 +0900
Message-ID: <1229183718-1171-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229183718-1171-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229183718-1171-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40804 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYLMQMt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:12:49 -0500
In-Reply-To: <1229183718-1171-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces scsi_execute_async with the block layer API. st does the
same thing so it might make sense to have something like libst (there
are other things that os and osst can share).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/osst.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/osst.h |    2 +
 2 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index f733b93..676f9e2 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -317,18 +317,25 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 
 
 /* Wakeup from interrupt */
-static void osst_sleep_done(void *data, char *sense, int result, int resid)
+static void osst_end_async(struct request *req, int update)
 {
-	struct osst_request *SRpnt = data;
+	struct osst_request *SRpnt = req->end_io_data;
 	struct osst_tape *STp = SRpnt->stp;
+	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 
-	memcpy(SRpnt->sense, sense, SCSI_SENSE_BUFFERSIZE);
-	STp->buffer->cmdstat.midlevel_result = SRpnt->result = result;
+	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
 #if DEBUG
 	STp->write_pending = 0;
 #endif
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
+
+	if (SRpnt->bio) {
+		kfree(mdata->pages);
+		blk_rq_unmap_user(SRpnt->bio);
+	}
+
+	__blk_put_request(req->q, req);
 }
 
 /* osst_request memory management */
@@ -342,6 +349,74 @@ static void osst_release_request(struct osst_request *streq)
 	kfree(streq);
 }
 
+static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
+			int cmd_len, int data_direction, void *buffer, unsigned bufflen,
+			int use_sg, int timeout, int retries)
+{
+	struct request *req;
+	struct page **pages = NULL;
+	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
+
+	int err = 0;
+	int write = (data_direction == DMA_TO_DEVICE);
+
+	req = blk_get_request(SRpnt->stp->device->request_queue, write, GFP_KERNEL);
+	if (!req)
+		return DRIVER_ERROR << 24;
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_QUIET;
+
+	SRpnt->bio = NULL;
+
+	if (use_sg) {
+		struct scatterlist *sg, *sgl = (struct scatterlist *)buffer;
+		int i;
+
+		pages = kzalloc(use_sg * sizeof(struct page *), GFP_KERNEL);
+		if (!pages)
+			goto free_req;
+
+		for_each_sg(sgl, sg, use_sg, i)
+			pages[i] = sg_page(sg);
+
+		mdata->null_mapped = 1;
+
+		mdata->page_order = get_order(sgl[0].length);
+		mdata->nr_entries =
+			DIV_ROUND_UP(bufflen, PAGE_SIZE << mdata->page_order);
+		mdata->offset = 0;
+
+		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen, GFP_KERNEL);
+		if (err) {
+			kfree(pages);
+			goto free_req;
+		}
+		SRpnt->bio = req->bio;
+		mdata->pages = pages;
+
+	} else if (bufflen) {
+		err = blk_rq_map_kern(req->q, req, buffer, bufflen, GFP_KERNEL);
+		if (err)
+			goto free_req;
+	}
+
+	req->cmd_len = cmd_len;
+	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = SRpnt->sense;
+	req->sense_len = 0;
+	req->timeout = timeout;
+	req->retries = retries;
+	req->end_io_data = SRpnt;
+
+	blk_execute_rq_nowait(req->q, NULL, req, 1, osst_end_async);
+	return 0;
+free_req:
+	blk_put_request(req);
+	return DRIVER_ERROR << 24;
+}
+
 /* Do the scsi command. Waits until command performed if do_wait is true.
    Otherwise osst_write_behind_check() is used to check that the command
    has finished. */
@@ -403,8 +478,8 @@ static	struct osst_request * osst_do_scsi(struct osst_request *SRpnt, struct oss
 	STp->buffer->cmdstat.have_sense = 0;
 	STp->buffer->syscall_result = 0;
 
-	if (scsi_execute_async(STp->device, cmd, COMMAND_SIZE(cmd[0]), direction, bp, bytes,
-			use_sg, timeout, retries, SRpnt, osst_sleep_done, GFP_KERNEL))
+	if (osst_execute(SRpnt, cmd, COMMAND_SIZE(cmd[0]), direction, bp, bytes,
+			 use_sg, timeout, retries))
 		/* could not allocate the buffer or request was too large */
 		(STp->buffer)->syscall_result = (-EBUSY);
 	else if (do_wait) {
diff --git a/drivers/scsi/osst.h b/drivers/scsi/osst.h
index 5aa2274..11d26c5 100644
--- a/drivers/scsi/osst.h
+++ b/drivers/scsi/osst.h
@@ -520,6 +520,7 @@ struct osst_buffer {
   int syscall_result;
   struct osst_request *last_SRpnt;
   struct st_cmdstatus cmdstat;
+  struct rq_map_data map_data;
   unsigned char *b_data;
   os_aux_t *aux;               /* onstream AUX structure at end of each block     */
   unsigned short use_sg;       /* zero or number of s/g segments for this adapter */
@@ -634,6 +635,7 @@ struct osst_request {
 	int result;
 	struct osst_tape *stp;
 	struct completion *waiting;
+	struct bio *bio;
 };
 
 /* Values of write_type */
-- 
1.5.6.5

