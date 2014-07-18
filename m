From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] scsi: unwind blk_end_request_all and blk_end_request_err calls
Date: Fri, 18 Jul 2014 12:13:10 +0200
Message-ID: <1405678393-11497-12-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace the calls to the various blk_end_request variants with opencode
equivalents.  Blk-mq is using a model that gives the driver control
between the bio updates and the actual completion, and making the old
code follow that same model allows us to keep the code more similar for
both paths.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/scsi_lib.c | 61 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a643353..8723abe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -621,6 +621,37 @@ static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
 	cmd->request->next_rq->special = NULL;
 }
 
+static bool scsi_end_request(struct request *req, int error,
+		unsigned int bytes, unsigned int bidi_bytes)
+{
+	struct scsi_cmnd *cmd = req->special;
+	struct scsi_device *sdev = cmd->device;
+	struct request_queue *q = sdev->request_queue;
+	unsigned long flags;
+
+
+	if (blk_update_request(req, error, bytes))
+		return true;
+
+	/* Bidi request must be completed as a whole */
+	if (unlikely(bidi_bytes) &&
+	    blk_update_request(req->next_rq, error, bidi_bytes))
+		return true;
+
+	if (blk_queue_add_random(q))
+		add_disk_randomness(req->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_finish_request(req, error);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (bidi_bytes)
+		scsi_release_bidi_buffers(cmd);
+	scsi_release_buffers(cmd);
+	scsi_next_command(cmd);
+	return false;
+}
+
 /**
  * __scsi_error_from_host_byte - translate SCSI error code into errno
  * @cmd:	SCSI command (unused)
@@ -693,7 +724,7 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
  *		   be put back on the queue and retried using the same
  *		   command as before, possibly after a delay.
  *
- *		c) We can call blk_end_request() with -EIO to fail
+ *		c) We can call scsi_end_request() with -EIO to fail
  *		   the remainder of the request.
  */
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
@@ -744,13 +775,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			 * both sides at once.
 			 */
 			req->next_rq->resid_len = scsi_in(cmd)->resid;
-
-			scsi_release_buffers(cmd);
-			scsi_release_bidi_buffers(cmd);
-
-			blk_end_request_all(req, 0);
-
-			scsi_next_command(cmd);
+			if (scsi_end_request(req, 0, blk_rq_bytes(req),
+					blk_rq_bytes(req->next_rq)))
+				BUG();
 			return;
 		}
 	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
@@ -797,15 +824,16 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	/*
 	 * If we finished all bytes in the request we are done now.
 	 */
-	if (!blk_end_request(req, error, good_bytes))
-		goto next_command;
+	if (!scsi_end_request(req, error, good_bytes, 0))
+		return;
 
 	/*
 	 * Kill remainder if no retrys.
 	 */
 	if (error && scsi_noretry_cmd(cmd)) {
-		blk_end_request_all(req, error);
-		goto next_command;
+		if (scsi_end_request(req, error, blk_rq_bytes(req), 0))
+			BUG();
+		return;
 	}
 
 	/*
@@ -919,8 +947,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (!blk_end_request_err(req, error))
-			goto next_command;
+		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
+			return;
 		/*FALLTHRU*/
 	case ACTION_REPREP:
 	requeue:
@@ -939,11 +967,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
 		break;
 	}
-	return;
-
-next_command:
-	scsi_release_buffers(cmd);
-	scsi_next_command(cmd);
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
-- 
1.9.1
