From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block#for-2.6.31 1/3] ub: use __blk_end_request_all()
Date: Sat, 16 May 2009 00:14:35 +0900
Message-ID: <4A0D86DB.9000203@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:55127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZEOPPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2009 11:15:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-s

ub_end_rq() always tries to complete full request.  The @cmd_len
parameter was there because rq->data_len used to be overwritten with
residue count.  Drop @cmd_len and use __blk_end_request_all().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
---
 drivers/block/ub.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

Index: block/drivers/block/ub.c
===================================================================
--- block.orig/drivers/block/ub.c
+++ block/drivers/block/ub.c
@@ -360,8 +360,7 @@ static void ub_cmd_build_block(struct ub
 static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_scsi_cmd *cmd, struct ub_request *urq);
 static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
-static void ub_end_rq(struct request *rq, unsigned int status,
-    unsigned int cmd_len);
+static void ub_end_rq(struct request *rq, unsigned int status);
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_request *urq, struct ub_scsi_cmd *cmd);
 static int ub_submit_scsi(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
@@ -644,13 +643,13 @@ static int ub_request_fn_1(struct ub_lun
 
 	if (atomic_read(&sc->poison)) {
 		blk_start_request(rq);
-		ub_end_rq(rq, DID_NO_CONNECT << 16, blk_rq_bytes(rq));
+		ub_end_rq(rq, DID_NO_CONNECT << 16);
 		return 0;
 	}
 
 	if (lun->changed && !blk_pc_request(rq)) {
 		blk_start_request(rq);
-		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION, blk_rq_bytes(rq));
+		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION);
 		return 0;
 	}
 
@@ -702,7 +701,7 @@ static int ub_request_fn_1(struct ub_lun
 
 drop:
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, DID_ERROR << 16, blk_rq_bytes(rq));
+	ub_end_rq(rq, DID_ERROR << 16);
 	return 0;
 }
 
@@ -777,7 +776,6 @@ static void ub_rw_cmd_done(struct ub_dev
 	struct ub_request *urq = cmd->back;
 	struct request *rq;
 	unsigned int scsi_status;
-	unsigned int cmd_len;
 
 	rq = urq->rq;
 
@@ -816,17 +814,14 @@ static void ub_rw_cmd_done(struct ub_dev
 
 	urq->rq = NULL;
 
-	cmd_len = cmd->len;
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, scsi_status, cmd_len);
+	ub_end_rq(rq, scsi_status);
 	blk_start_queue(lun->disk->queue);
 }
 
-static void ub_end_rq(struct request *rq, unsigned int scsi_status,
-    unsigned int cmd_len)
+static void ub_end_rq(struct request *rq, unsigned int scsi_status)
 {
 	int error;
-	long rqlen;
 
 	if (scsi_status == 0) {
 		error = 0;
@@ -834,12 +829,7 @@ static void ub_end_rq(struct request *rq
 		error = -EIO;
 		rq->errors = scsi_status;
 	}
-	rqlen = blk_rq_bytes(rq);    /* Oddly enough, this is the residue. */
-	if (__blk_end_request(rq, error, cmd_len)) {
-		printk(KERN_WARNING DRV_NAME
-		    ": __blk_end_request blew, %s-cmd total %u rqlen %ld\n",
-		    blk_pc_request(rq)? "pc": "fs", cmd_len, rqlen);
-	}
+	__blk_end_request_all(rq, error);
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
