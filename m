From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 27/30] blk_end_request: changing scsi (take 4)
Date: Tue, 11 Dec 2007 17:52:09 -0500 (EST)
Message-ID: <20071211.175209.10128473.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

This patch converts scsi mid-layer to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, scsi_end_request(),
is changed.

Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_lib.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

Index: 2.6.24-rc4/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.24-rc4.orig/drivers/scsi/scsi_lib.c
+++ 2.6.24-rc4/drivers/scsi/scsi_lib.c
@@ -632,7 +632,7 @@ void scsi_run_host_queues(struct Scsi_Ho
  *		of upper level post-processing and scsi_io_completion).
  *
  * Arguments:   cmd	 - command that is complete.
- *              uptodate - 1 if I/O indicates success, <= 0 for I/O error.
+ *              error    - 0 if I/O indicates success, < 0 for I/O error.
  *              bytes    - number of bytes of completed I/O
  *		requeue  - indicates whether we should requeue leftovers.
  *
@@ -647,26 +647,25 @@ void scsi_run_host_queues(struct Scsi_Ho
  *		at some point during this call.
  * Notes:	If cmd was requeued, upon return it will be a stale pointer.
  */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
+static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 					  int bytes, int requeue)
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
-	unsigned long flags;
 
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_chunk(req, uptodate, bytes)) {
+	if (blk_end_request(req, error, bytes)) {
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
 		/* kill remainder if no retrys */
-		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+		if (error && blk_noretry_request(req))
+			blk_end_request(req, error, leftover);
 		else {
 			if (requeue) {
 				/*
@@ -681,14 +680,6 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
-	add_disk_randomness(req->rq_disk);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-	end_that_request_last(req, uptodate);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
@@ -985,7 +976,7 @@ void scsi_io_completion(struct scsi_cmnd
 	 * are leftovers and there is some kind of error
 	 * (result != 0), retry the rest.
 	 */
-	if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
+	if (scsi_end_request(cmd, 0, good_bytes, result == 0) == NULL)
 		return;
 
 	/* good_bytes = 0, or (inclusive) there were leftovers and
@@ -999,7 +990,7 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				scsi_end_request(cmd, 0, this_count, 1);
+				scsi_end_request(cmd, -EIO, this_count, 1);
 				return;
 			} else {
 				/* Must have been a power glitch, or a
@@ -1031,7 +1022,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_requeue_command(q, cmd);
 				return;
 			} else {
-				scsi_end_request(cmd, 0, this_count, 1);
+				scsi_end_request(cmd, -EIO, this_count, 1);
 				return;
 			}
 			break;
@@ -1059,7 +1050,7 @@ void scsi_io_completion(struct scsi_cmnd
 							 "Device not ready",
 							 &sshdr);
 
-			scsi_end_request(cmd, 0, this_count, 1);
+			scsi_end_request(cmd, -EIO, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
 			if (!(req->cmd_flags & REQ_QUIET)) {
@@ -1069,7 +1060,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 			}
 			/* See SSC3rXX or current. */
-			scsi_end_request(cmd, 0, this_count, 1);
+			scsi_end_request(cmd, -EIO, this_count, 1);
 			return;
 		default:
 			break;
@@ -1090,7 +1081,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 		}
 	}
-	scsi_end_request(cmd, 0, this_count, !result);
+	scsi_end_request(cmd, -EIO, this_count, !result);
 }
 
 /*
