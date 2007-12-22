From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 3/5] bsg: accept varlen commands
Date: Sat, 22 Dec 2007 15:35:18 -0500
Message-ID: <20071222203633.02DE3900CD9@quasar.osc.edu>
References: <20071222201558.GA25063@osc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:53900 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXLVUgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2007 15:36:33 -0500
In-Reply-To: <20071222201558.GA25063@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

[Resend, date was in ancient history.]

Accept variable length SCSI commands through BSG.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 8e181ab..0d9364d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -175,14 +175,29 @@ unlock:
 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, int has_write_perm)
 {
-	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
-
-	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
-			   hdr->request_len))
-		return -EFAULT;
+	void __user *buf = (void __user *)(unsigned long) hdr->request;
+	int len = hdr->request_len;
+	unsigned char *cmd;
+
+	if (len > BLK_MAX_CDB) {
+		rq->cmd_len = 0;
+		rq->varlen_cdb_len = len;
+		rq->varlen_cdb = kmalloc(len, GFP_KERNEL);
+		if (rq->varlen_cdb == NULL)
+			return -ENOMEM;
+		if (copy_from_user(rq->varlen_cdb, buf, len))
+			return -EFAULT;
+		cmd = &rq->varlen_cdb[0];
+	} else {
+		rq->cmd_len = len;
+		memset(rq->cmd, 0, BLK_MAX_CDB);  /* for ATAPI */
+		if (copy_from_user(rq->cmd, buf, len))
+			return -EFAULT;
+		cmd = &rq->cmd[0];
+	}
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(rq->cmd, has_write_perm))
+		if (blk_verify_command(cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -190,7 +205,6 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->request_len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
 	rq->timeout = (hdr->timeout * HZ) / 1000;
@@ -212,8 +226,6 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
 
 	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->request_len > BLK_MAX_CDB)
-		return -EINVAL;
 	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
 	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
@@ -302,6 +314,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	}
 	return rq;
 out:
+	if (rq->varlen_cdb_len)
+		kfree(rq->varlen_cdb);
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
@@ -446,6 +460,8 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		hdr->dout_resid = rq->data_len;
 
 	blk_rq_unmap_user(bio);
+	if (rq->varlen_cdb_len)
+		kfree(rq->varlen_cdb);
 	blk_put_request(rq);
 
 	return ret;
-- 
1.5.3.6

