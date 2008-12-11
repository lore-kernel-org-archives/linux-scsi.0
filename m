From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 05/13] st: add st_scsi_execute helper function
Date: Thu, 11 Dec 2008 23:07:42 +0900
Message-ID: <1229004470-25718-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43886 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbYLKOK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:56 -0500
In-Reply-To: <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

st_scsi_execute is a helper function to perform SCSI commands
involving data transfer between user and kernel space (st_read and
st_write).

It's the future plan to combine this with st_scsi_kern_execute helper
function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/st.h |    1 +
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ce47495..f62f6ca 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -475,6 +475,60 @@ static void st_release_request(struct st_request *streq)
 	kfree(streq);
 }
 
+static void st_scsi_execute_end(struct request *req, int uptodate)
+{
+	struct st_request *SRpnt = req->end_io_data;
+	struct scsi_tape *STp = SRpnt->stp;
+
+	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
+	STp->buffer->cmdstat.residual = req->data_len;
+
+	if (SRpnt->waiting)
+		complete(SRpnt->waiting);
+
+	blk_rq_unmap_user(SRpnt->bio);
+	__blk_put_request(req->q, req);
+}
+
+static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
+			   int data_direction, void *buffer, unsigned bufflen,
+			   int timeout, int retries)
+{
+	struct request *req;
+	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
+	int err = 0;
+	int write = (data_direction == DMA_TO_DEVICE);
+
+	req = blk_get_request(SRpnt->stp->device->request_queue, write,
+			      GFP_KERNEL);
+	if (!req)
+		return DRIVER_ERROR << 24;
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_QUIET;
+
+	mdata->null_mapped = 1;
+
+	err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen, GFP_KERNEL);
+	if (err) {
+		blk_put_request(req);
+		return DRIVER_ERROR << 24;
+	}
+
+	SRpnt->bio = req->bio;
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memset(req->cmd, 0, BLK_MAX_CDB);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = SRpnt->sense;
+	req->sense_len = 0;
+	req->timeout = timeout;
+	req->retries = retries;
+	req->end_io_data = SRpnt;
+
+	blk_execute_rq_nowait(req->q, NULL, req, 1, st_scsi_execute_end);
+	return 0;
+}
+
 /* Do the scsi command. Waits until command performed if do_wait is true.
    Otherwise write_behind_check() is used to check that the command
    has finished. */
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 74748ab..77302fa 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -29,6 +29,7 @@ struct st_request {
 	int result;
 	struct scsi_tape *stp;
 	struct completion *waiting;
+	struct bio *bio;
 };
 
 /* The tape buffer descriptor. */
-- 
1.5.6.5

