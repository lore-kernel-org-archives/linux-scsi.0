From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 02/11] st: add st_scsi_kern_execute helper function
Date: Sun, 30 Nov 2008 17:07:56 +0900
Message-ID: <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:38617 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYK3ISt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:18:49 -0500
In-Reply-To: <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

st_scsi_kern_execute is a helper function to perform SCSI commands
synchronously. It supports data transfer with a liner in-kernel buffer
(not scatter gather). st_scsi_kern_execute internally uses
blk_get_request, blk_rq_map_kern, and blk_execute_rq.

The majority of st_do_scsi can be replaced with
st_scsi_kern_execute. This is a preparation for rewriting st_do_scsi
to remove obsolete scsi_execute_async().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 878493d..6179940 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -533,6 +533,55 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	return SRpnt;
 }
 
+static int st_scsi_kern_execute(struct st_request *streq,
+				const unsigned char *cmd, int data_direction,
+				void *buffer, unsigned bufflen, int timeout,
+				int retries)
+{
+	struct scsi_tape *stp = streq->stp;
+	struct request *req;
+	int write = (data_direction == DMA_TO_DEVICE);
+	int ret = 0;
+
+	/* st_do_scsi returns -EBUSY in case of OOM */
+	req = blk_get_request(stp->device->request_queue, write, GFP_KERNEL);
+	if (!req)
+		return -EBUSY;
+
+	if (bufflen) {
+		ret = blk_rq_map_kern(stp->device->request_queue, req,
+				      buffer, bufflen, GFP_KERNEL);
+		if (ret)
+			goto out;
+	}
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_QUIET;
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+
+	req->sense = streq->sense;
+	req->sense_len = 0;
+
+	req->timeout = timeout;
+	req->retries = retries;
+
+	stp->buffer->cmdstat.have_sense = 0;
+	memcpy(streq->cmd, cmd, sizeof(streq->cmd));
+
+	blk_execute_rq(req->q, NULL, req, 1);
+
+	stp->buffer->cmdstat.midlevel_result = streq->result = req->errors;
+	stp->buffer->cmdstat.residual = req->data_len;
+
+	stp->buffer->syscall_result = st_chk_result(stp, streq);
+
+out:
+	blk_put_request(req);
+
+	return ret;
+}
 
 /* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
    write has been correct but EOM early warning reached, -EIO if write ended in
-- 
1.5.6.5

