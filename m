From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: unify the error handling of the prep functions
Date: Mon, 5 Jul 2010 13:00:19 +0900
Message-ID: <20100705125651R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37023 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0GEEAv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2010 00:00:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@suse.de
Cc: snitzer@redhat.com, linux-scsi@vger.kernel.org, hch@lst.de, dm-devel@redhat.com

This can be applied to the block's for-2.6.36.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: unify the error handling of the prep functions

This unifies the error handling of the prep functions (and fix the
leak of a page allocated for discard in the case of BLKPREP_KILL or
BLK_PREP_DEFER).

The error handling of the prep path is very messy. Some errors are
handled in the prep functions while some are in scsi_prep_return().

Let's handle all the errors in scsi_prep_return().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |   26 +++++++++++++-------------
 drivers/scsi/sd.c       |    6 ++++--
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ee83619..f9b3f7b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1008,14 +1008,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	}
 
 	return BLKPREP_OK ;
-
 err_exit:
-	scsi_release_buffers(cmd);
-	if (error == BLKPREP_KILL)
-		scsi_put_command(cmd);
-	else /* BLKPREP_DEFER */
-		scsi_unprep_request(cmd->request);
-
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
@@ -1177,6 +1170,17 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 }
 EXPORT_SYMBOL(scsi_prep_state_check);
 
+static void scsi_prep_error(struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+
+	if (!cmd)
+		return;
+
+	scsi_release_buffers(cmd);
+	scsi_unprep_request(req);
+}
+
 int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 {
 	struct scsi_device *sdev = q->queuedata;
@@ -1185,14 +1189,10 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 	case BLKPREP_KILL:
 		req->errors = DID_NO_CONNECT << 16;
 		/* release the command and kill it */
-		if (req->special) {
-			struct scsi_cmnd *cmd = req->special;
-			scsi_release_buffers(cmd);
-			scsi_put_command(cmd);
-			req->special = NULL;
-		}
+		scsi_prep_error(req);
 		break;
 	case BLKPREP_DEFER:
+		scsi_prep_error(req);
 		/*
 		 * If we defer, the blk_peek_request() returns NULL, but the
 		 * queue must be restarted, so we plug here if no returning
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa6b48b..88ba0c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -473,8 +473,10 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
-		__free_page(virt_to_page(rq->buffer));
+	if (rq->cmd_flags & REQ_DISCARD) {
+		free_page((unsigned long)rq->buffer);
+		rq->buffer = NULL;
+	}
 }
 
 /**
-- 
1.6.5

