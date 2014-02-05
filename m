From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/15] scsi: cleanup scsi_end_request calling conventions
Date: Wed, 05 Feb 2014 04:41:26 -0800
Message-ID: <20140205124153.565415017@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBEMlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:55 -0500
Content-Disposition: inline; filename=0008-scsi-cleanup-scsi_end_request-calling-conventions.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Don't bother returning a stale pointer when a bool does the work much
better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a206da5..c6fc552 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -531,17 +531,16 @@ static void __scsi_release_buffers(struct scsi_cmnd *, int);
  *
  * Lock status: Assumed that lock is not held upon entry.
  *
- * Returns:     cmd if requeue required, NULL otherwise.
+ * Returns:     false if requeue required, true otherwise.
  *
  * Notes:       This is called for block device requests in order to
  *              mark some number of sectors as complete.
  * 
  *		We are guaranteeing that the request queue will be goosed
  *		at some point during this call.
- * Notes:	If cmd was requeued, upon return it will be a stale pointer.
  */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
-					  int bytes, int requeue)
+static bool scsi_end_request(struct scsi_cmnd *cmd, int error, int bytes,
+		int requeue)
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
@@ -554,19 +553,18 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 		/* kill remainder if no retrys */
 		if (error && scsi_noretry_cmd(cmd))
 			blk_end_request_all(req, error);
-		else {
-			if (requeue) {
-				/*
-				 * Bleah.  Leftovers again.  Stick the
-				 * leftovers in the front of the
-				 * queue, and goose the queue again.
-				 */
-				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
-				cmd = NULL;
-			}
-			return cmd;
+		else if (requeue) {
+			/*
+			 * Bleah.  Leftovers again.  Stick the
+			 * leftovers in the front of the
+			 * queue, and goose the queue again.
+			 */
+			scsi_release_buffers(cmd);
+			scsi_requeue_command(q, cmd);
+			return true;
 		}
+
+		return false;
 	}
 
 	/*
@@ -575,7 +573,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 	 */
 	__scsi_release_buffers(cmd, 0);
 	scsi_next_command(cmd);
-	return NULL;
+	return true;
 }
 
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
@@ -847,7 +845,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * are leftovers and there is some kind of error
 	 * (result != 0), retry the rest.
 	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
+	if (scsi_end_request(cmd, error, good_bytes, result == 0))
 		return;
 
 	error = __scsi_error_from_host_byte(cmd, result);
-- 
1.7.10.4


