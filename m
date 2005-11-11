From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/5] complete the while command when it is REQ_BLOCK_PC
Date: Fri, 11 Nov 2005 05:31:40 -0600
Message-ID: <1131708700.3066.27.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32182 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750739AbVKKLby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 06:31:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

sd does not allow scsi_io_completion to retry commands for
SG_IO requests, and it make sense that it should not happen for st
SG_IO commands too. If for st we hit the bottom of scsi_io_completion
we will probably screw things up pretty bad. This patch returns to the
block layer that the whole command completed and relies on the caller to check
the request errors field. For initialization commands like in sd, this adds
the previous behavior where scsi_io_completion did not process the error.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 55e3faa..80d3414 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1246,7 +1246,13 @@ static int scsi_issue_flush_fn(request_q
 static void scsi_generic_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
-	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
+	/*
+	 * This will complete the whole command with uptodate=1 so
+	 * as far as the block layer is concerned the command completed
+	 * successfully. Since this is a REQ_BLOCK_PC command the
+	 * caller should check the request's errors value
+	 */
+	scsi_io_completion(cmd, cmd->bufflen, 0);
 }
 
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8a99246..6ff6d99 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4185,7 +4185,11 @@ static void scsi_tape_release(struct kre
 
 static void st_intr(struct scsi_cmnd *SCpnt)
 {
-	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen), 1);
+	/*
+	 * The caller should be checking the request's errors
+	 * value.
+	 */
+	scsi_io_completion(SCpnt, SCpnt->bufflen, 0);
 }
 
 /*


