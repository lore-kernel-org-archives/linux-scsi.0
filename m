From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RFC PATCH 4/4] convert scsi to blkerr error values
Date: Wed, 24 Aug 2005 04:04:31 -0500
Message-ID: <1124874271.10888.22.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1491 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750799AbVHXJEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:04:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com

This patch convert scsi to use the BLKERR values.
It uses the scsi_cmnd->result values to try
and "guess" (LLDs are not all consistent in
their host byte usage) if it is a transport or
device or driver error. Maybe it would be better to
have the transport classes define new host byte error
values (or add a transport byte), and scsi-ml can then
call into the transport class to tell it if the error
is retryable or fatal.

If this approach is ok, I guess the next step
is more testing and figure out how to best
support vendor specifics. While converting
dm-emc's asc/ascq code there are comments
indicating we might need to send additional
commands to try and figure out what to do
(Enginio or Sun people did you need this too?)

The patch has been lightly tested with iscsi_sfnet
and open-iscsi using dm-multipath to verify that
when we send retryable errors dm-multipath does
nice things like not automatically fail a path
and fail the IO.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1269,6 +1269,7 @@ int scsi_device_cancel(struct scsi_devic
 				scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
 			} else {
 				scmd->result = (DID_ABORT << 16);
+				scmd->blk_result = BLKERR_FATAL_DEV;
 				scsi_finish_command(scmd);
 			}
 		}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1213,6 +1213,7 @@ int scsi_decide_disposition(struct scsi_
 		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
 						  " as SUCCESS\n",
 						  __FUNCTION__));
+		scmd->blk_result = BLKERR_FATAL_DEV;
 		return SUCCESS;
 	}
 
@@ -1228,6 +1229,7 @@ int scsi_decide_disposition(struct scsi_
 		 * did_ok.
 		 */
 		scmd->result &= 0xff00ffff;
+		scmd->blk_result = BLK_SUCCESS;
 		return SUCCESS;
 	case DID_OK:
 		/*
@@ -1236,7 +1238,10 @@ int scsi_decide_disposition(struct scsi_
 		break;
 	case DID_NO_CONNECT:
 	case DID_BAD_TARGET:
+		scmd->blk_result = BLKERR_FATAL_XPT;
+		return SUCCESS;
 	case DID_ABORT:
+		scmd->blk_result = BLKERR_RETRY_DEV;
 		/*
 		 * note - this means that we just report the status back
 		 * to the top level driver, not that we actually think
@@ -1253,6 +1258,7 @@ int scsi_decide_disposition(struct scsi_
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
+		scmd->blk_result = BLKERR_RETRY_DEV;
 		goto maybe_retry;
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
@@ -1269,11 +1275,12 @@ int scsi_decide_disposition(struct scsi_
 			 */
 			break;
 		/* fallthrough */
-
 	case DID_BUS_BUSY:
 	case DID_PARITY:
+		scmd->blk_result = BLKERR_RETRY_XPT;
 		goto maybe_retry;
 	case DID_TIME_OUT:
+		scmd->blk_result = BLKERR_FATAL_DEV;
 		/*
 		 * when we scan the bus, we get timeout messages for
 		 * these commands if there is no device available.
@@ -1286,16 +1293,20 @@ int scsi_decide_disposition(struct scsi_
 			return FAILED;
 		}
 	case DID_RESET:
+		scmd->blk_result = BLKERR_RETRY_DEV;
 		return SUCCESS;
 	default:
+		scmd->blk_result = BLKERR_FATAL_DEV;
 		return FAILED;
 	}
 
 	/*
 	 * next, check the message byte.
 	 */
-	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
+	if (msg_byte(scmd->result) != COMMAND_COMPLETE) {
+		scmd->blk_result = BLKERR_FATAL_DEV;
 		return FAILED;
+	}
 
 	/*
 	 * check the status byte to see if this indicates anything special.
@@ -1315,13 +1326,19 @@ int scsi_decide_disposition(struct scsi_
 		 */
 		return ADD_TO_MLQUEUE;
 	case GOOD:
+		scmd->blk_result = BLK_SUCCESS;
+		return SUCCESS;
 	case COMMAND_TERMINATED:
 	case TASK_ABORTED:
+		scmd->blk_result = BLKERR_FATAL_DEV;
 		return SUCCESS;
 	case CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
-		if (rtn == NEEDS_RETRY)
+		if (rtn == NEEDS_RETRY) {
+			scmd->blk_result = BLKERR_RETRY_DEV;
 			goto maybe_retry;
+		} else
+			scmd->blk_result = BLKERR_FATAL_DEV;
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
@@ -1334,6 +1351,7 @@ int scsi_decide_disposition(struct scsi_
 		/*
 		 * who knows?  FIXME(eric)
 		 */
+		scmd->blk_result = BLK_SUCCESS;
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
@@ -1341,10 +1359,13 @@ int scsi_decide_disposition(struct scsi_
                                 " %d channel %d id %d lun %d\n",
 		       scmd->device->host->host_no, scmd->device->channel,
 		       scmd->device->id, scmd->device->lun);
+		scmd->blk_result = BLK_SUCCESS;
 		return SUCCESS; /* causes immediate i/o error */
 	default:
+		scmd->blk_result = BLKERR_FATAL_DEV;
 		return FAILED;
 	}
+	scmd->blk_result = BLKERR_FATAL_DEV;
 	return FAILED;
 
       maybe_retry:
@@ -1519,6 +1540,7 @@ static void scsi_eh_flush_done_q(struct 
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
 							" cmd: %p\n",
 							current->comm, scmd));
+			scmd->blk_result = BLKERR_RETRY_DEV;
 			scsi_finish_command(scmd);
 		}
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -513,7 +513,7 @@ void scsi_run_host_queues(struct Scsi_Ho
  *		of upper level post-processing and scsi_io_completion).
  *
  * Arguments:   cmd	 - command that is complete.
- *              uptodate - 1 if I/O indicates success, <= 0 for I/O error.
+ *              uptodate - a block layer error value 
  *              bytes    - number of bytes of completed I/O
  *		requeue  - indicates whether we should requeue leftovers.
  *
@@ -527,7 +527,7 @@ void scsi_run_host_queues(struct Scsi_Ho
  *		We are guaranteeing that the request queue will be goosed
  *		at some point during this call.
  */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
+static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int blkerr,
 					  int bytes, int requeue)
 {
 	request_queue_t *q = cmd->device->request_queue;
@@ -538,15 +538,15 @@ static struct scsi_cmnd *scsi_end_reques
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_chunk(req, uptodate, bytes)) {
+	if (end_that_request_chunk(req, blkerr, bytes)) {
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
 		/* kill remainder if no retrys */
-		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+		if (blkerr != BLK_SUCCESS && blk_noretry_request(req))
+			end_that_request_chunk(req, blkerr, leftover);
 		else {
 			if (requeue)
 				/*
@@ -781,7 +781,8 @@ void scsi_io_completion(struct scsi_cmnd
 		 * requeueing right here - we will requeue down below
 		 * when we handle the bad sectors.
 		 */
-		cmd = scsi_end_request(cmd, 1, good_bytes, result == 0);
+		cmd = scsi_end_request(cmd, BLK_SUCCESS, good_bytes,
+				       result == 0);
 
 		/*
 		 * If the command completed without error, then either finish off the
@@ -804,8 +805,8 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				cmd = scsi_end_request(cmd, 0,
-						this_count, 1);
+				cmd = scsi_end_request(cmd, BLKERR_FATAL_DEV,
+						       this_count, 1);
 				return;
 			} else {
 				/*
@@ -838,7 +839,8 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_requeue_command(q, cmd);
 				result = 0;
 			} else {
-				cmd = scsi_end_request(cmd, 0, this_count, 1);
+				cmd = scsi_end_request(cmd, cmd->blk_result,
+						       this_count, 1);
 				return;
 			}
 			break;
@@ -853,7 +855,8 @@ void scsi_io_completion(struct scsi_cmnd
 			}
 			printk(KERN_INFO "Device %s not ready.\n",
 			       req->rq_disk ? req->rq_disk->disk_name : "");
-			cmd = scsi_end_request(cmd, 0, this_count, 1);
+			cmd = scsi_end_request(cmd, cmd->blk_result,
+					       this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
 			printk(KERN_INFO "Volume overflow <%d %d %d %d> CDB: ",
@@ -862,7 +865,8 @@ void scsi_io_completion(struct scsi_cmnd
 			       (int)cmd->device->id, (int)cmd->device->lun);
 			__scsi_print_command(cmd->data_cmnd);
 			scsi_print_sense("", cmd);
-			cmd = scsi_end_request(cmd, 0, block_bytes, 1);
+			cmd = scsi_end_request(cmd, cmd->blk_result,
+					       block_bytes, 1);
 			return;
 		default:
 			break;
@@ -894,7 +898,7 @@ void scsi_io_completion(struct scsi_cmnd
 		block_bytes = req->hard_cur_sectors << 9;
 		if (!block_bytes)
 			block_bytes = req->data_len;
-		cmd = scsi_end_request(cmd, 0, block_bytes, 1);
+		cmd = scsi_end_request(cmd, cmd->blk_result, block_bytes, 1);
 	}
 }
 EXPORT_SYMBOL(scsi_io_completion);
@@ -1246,7 +1250,8 @@ static void scsi_kill_requests(request_q
 	while ((req = elv_next_request(q)) != NULL) {
 		blkdev_dequeue_request(req);
 		req->flags |= REQ_QUIET;
-		while (end_that_request_first(req, 0, req->nr_sectors))
+		while (end_that_request_first(req, BLKERR_FATAL_DEV,
+					      req->nr_sectors))
 			;
 		end_that_request_last(req);
 	}
@@ -1301,7 +1306,8 @@ static void scsi_request_fn(struct reque
 			       sdev->host->host_no, sdev->id, sdev->lun);
 			blkdev_dequeue_request(req);
 			req->flags |= REQ_QUIET;
-			while (end_that_request_first(req, 0, req->nr_sectors))
+			while (end_that_request_first(req, BLKERR_FATAL_DEV,
+						      req->nr_sectors))
 				;
 			end_that_request_last(req);
 			continue;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -754,7 +754,8 @@ static void sd_end_flush(request_queue_t
 		/*
 		 * force journal abort of barriers
 		 */
-		end_that_request_first(rq, -EOPNOTSUPP, rq->hard_nr_sectors);
+		end_that_request_first(rq, BLKERR_NOTSUPP,
+				       rq->hard_nr_sectors);
 		end_that_request_last(rq);
 	}
 }
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -127,6 +127,7 @@ struct scsi_cmnd {
 					   * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
+	int blk_result;		/* block layer return value */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */


