From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] scsi: clean up S/G table freeing
Date: Sun,  7 Sep 2014 09:31:04 -0700
Message-ID: <1410107469-896-4-git-send-email-hch@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaIGQ3A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:29:00 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfKk-0006Ss-KT
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:28:59 +0000
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Now that we are using the split completion model for the legacy request
path as well we can use scsi_mq_free_sgtables unconditionally.

Rename it to scsi_free_sgtables, use it for the legacy path and remove
scsi_release_(bidi_)buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 76 +++++++++++--------------------------------------
 1 file changed, 17 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f21e661..0062865 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -621,7 +621,7 @@ static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
-static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
+static void scsi_free_sgtables(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
 		scsi_free_sgtable(&cmd->sdb, true);
@@ -637,7 +637,6 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
-	scsi_mq_free_sgtables(cmd);
 	scsi_uninit_cmd(cmd);
 
 	if (shost->use_cmd_list) {
@@ -648,42 +647,6 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
-/*
- * Function:    scsi_release_buffers()
- *
- * Purpose:     Free resources allocate for a scsi_command.
- *
- * Arguments:   cmd	- command that we are bailing.
- *
- * Lock status: Assumed that no lock is held upon entry.
- *
- * Returns:     Nothing
- *
- * Notes:       In the event that an upper level driver rejects a
- *		command, we must release resources allocated during
- *		the __init_io() function.  Primarily this would involve
- *		the scatter-gather table.
- */
-static void scsi_release_buffers(struct scsi_cmnd *cmd)
-{
-	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb, false);
-
-	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
-
-	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(cmd->prot_sdb, false);
-}
-
-static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
-{
-	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
-
-	scsi_free_sgtable(bidi_sdb, false);
-	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
-	cmd->request->next_rq->special = NULL;
-}
-
 static bool scsi_end_request(struct request *req, int error,
 		unsigned int bytes, unsigned int bidi_bytes)
 {
@@ -702,16 +665,14 @@ static bool scsi_end_request(struct request *req, int error,
 	if (blk_queue_add_random(q))
 		add_disk_randomness(req->rq_disk);
 
+	/*
+	 * In the MQ case the command gets freed by __blk_mq_end_io, so we have
+	 * to do all cleanup that depends on the command before that.
+	 */
+	scsi_free_sgtables(cmd);
+
 	if (req->mq_ctx) {
-		/*
-		 * In the MQ case the command gets freed by __blk_mq_end_io,
-		 * so we have to do all cleanup that depends on it earlier.
-		 *
-		 * We also can't kick the queues from irq context, so we
-		 * will have to defer it to a workqueue.
-		 */
 		scsi_mq_uninit_cmd(cmd);
-
 		__blk_mq_end_io(req, error);
 
 		if (scsi_target(sdev)->single_lun ||
@@ -726,10 +687,6 @@ static bool scsi_end_request(struct request *req, int error,
 		blk_finish_request(req, error);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
-		if (bidi_bytes)
-			scsi_release_bidi_buffers(cmd);
-		scsi_release_buffers(cmd);
-
 		scsi_put_command(cmd);
 		scsi_run_queue(q);
 	}
@@ -1041,14 +998,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
+		scsi_free_sgtables(cmd);
 		if (q->mq_ops) {
 			cmd->request->cmd_flags &= ~REQ_DONTPREP;
 			scsi_mq_uninit_cmd(cmd);
 			scsi_mq_requeue_cmd(cmd);
-		} else {
-			scsi_release_buffers(cmd);
+		} else
 			scsi_requeue_command(q, cmd);
-		}
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
@@ -1149,10 +1105,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 	return BLKPREP_OK;
 err_exit:
-	if (is_mq) {
-		scsi_mq_free_sgtables(cmd);
-	} else {
-		scsi_release_buffers(cmd);
+	scsi_free_sgtables(cmd);
+	if (!is_mq) {
 		cmd->request->special = NULL;
 		scsi_put_command(cmd);
 		put_device(&sdev->sdev_gendev);
@@ -1322,7 +1276,9 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
-			scsi_release_buffers(cmd);
+	
+			scsi_free_sgtables(cmd);
+
 			scsi_put_command(cmd);
 			put_device(&sdev->sdev_gendev);
 			req->special = NULL;
@@ -1912,8 +1868,10 @@ out:
 		 * we hit an error, as we will never see this command
 		 * again.
 		 */
-		if (req->cmd_flags & REQ_DONTPREP)
+		if (req->cmd_flags & REQ_DONTPREP) {
+			scsi_free_sgtables(cmd);
 			scsi_mq_uninit_cmd(cmd);
+		}
 		break;
 	default:
 		break;
-- 
1.9.1

