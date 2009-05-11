From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] scsi: simplify the bidi completion
Date: Mon, 11 May 2009 17:56:08 +0900
Message-ID: <1242032169-22422-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37525 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZEKI46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:56:58 -0400
In-Reply-To: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Let's use blk_end_request_all() instead of blk_end_bidi_request().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |   43 +++++++++++++------------------------------
 1 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b12750f..a54bec9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -673,33 +673,6 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
- * Bidi commands Must be complete as a whole, both sides at once.  If
- * part of the bytes were written and lld returned scsi_in()->resid
- * and/or scsi_out()->resid this information will be left in
- * req->resid_len and req->next_rq->resid_len. The upper-layer driver
- * can decide what to do with this information.
- */
-static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
-{
-	struct request *req = cmd->request;
-
-	req->resid_len = scsi_out(cmd)->resid;
-	req->next_rq->resid_len = scsi_in(cmd)->resid;
-
-	/* The req and req->next_rq have not been completed */
-	BUG_ON(blk_end_bidi_request(req, 0, blk_rq_bytes(req),
-				    blk_rq_bytes(req->next_rq)));
-
-	scsi_release_buffers(cmd);
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	scsi_next_command(cmd);
-}
-
-/*
  * Function:    scsi_io_completion()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -772,12 +745,22 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (!sense_deferred)
 				error = -EIO;
 		}
+
+		req->resid_len = scsi_get_resid(cmd);
+
 		if (scsi_bidi_cmnd(cmd)) {
-			/* will also release_buffers */
-			scsi_end_bidi_request(cmd);
+			/*
+			 * Bidi commands Must be complete as a whole,
+			 * both sides at once.
+			 */
+			req->next_rq->resid_len = scsi_in(cmd)->resid;
+
+			blk_end_request_all(req, 0);
+
+			scsi_release_buffers(cmd);
+			scsi_next_command(cmd);
 			return;
 		}
-		req->resid_len = scsi_get_resid(cmd);
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
-- 
1.6.0.6

