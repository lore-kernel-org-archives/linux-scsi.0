From: hare@suse.de (Hannes Reinecke)
Subject: [RFC][PATCHv2] scsi: Detailed I/O errors
Date: Fri, 17 Dec 2010 10:48:53 +0100
Message-ID: <20101217094853.4B31BF90C0@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0LQJo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 04:44:27 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 0716C8730A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2010 10:44:26 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


Instead of just passing 'EIO' for any I/O errors we should be
notifying the upper layers with some more details about the cause
of this error.
This patch updates the possible I/O errors to:

- ENOLINK: Link failure between host and target
- EIO: Retryable I/O error
- EREMOTEIO: Non-retryable I/O error

'Retryable' in this context means that an I/O error _might_ be
restricted to the I_T_L nexus (vulgo: path), so retrying on another
nexus / path might succeed.
Additionally we can modify blk_update_request() to print out some
more details about the error.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..c8fa30c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2028,9 +2028,22 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
 	if (error && req->cmd_type == REQ_TYPE_FS &&
 	    !(req->cmd_flags & REQ_QUIET)) {
-		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
-				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)blk_rq_pos(req));
+		char *errstr;
+
+		switch (error) {
+		case -ENOLINK:
+			errstr = "transport";
+			break;
+		case -EREMOTEIO:
+			errstr = "target";
+			break;
+		default:
+			errstr = "I/O";
+			break;
+		}
+		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+		       errstr, req->rq_disk ? req->rq_disk->disk_name : "?",
+		       (unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..d49b375 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1270,7 +1270,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP)
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
 		return error;
 
 	if (clone->cmd_flags & REQ_DISCARD)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 30ac116..007b8dd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -223,7 +223,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  * @scmd:	Cmd to have sense checked.
  *
  * Return value:
- * 	SUCCESS or FAILED or NEEDS_RETRY
+ *	SUCCESS or FAILED or NEEDS_RETRY or TARGET_ERROR
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -330,25 +330,25 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
-		return SUCCESS;
+	case DATA_PROTECT:
+	case BLANK_CHECK:
+		return TARGET_ERROR;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return SUCCESS;
+			return TARGET_ERROR;
 		}
 		return NEEDS_RETRY;
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
-		else
-			return SUCCESS;
-
+		else {
+			return TARGET_ERROR;
+		}
 	case ILLEGAL_REQUEST:
-	case BLANK_CHECK:
-	case DATA_PROTECT:
 	default:
 		return SUCCESS;
 	}
@@ -787,6 +787,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		case SUCCESS:
 		case NEEDS_RETRY:
 		case FAILED:
+		case TARGET_ERROR:
 			break;
 		case ADD_TO_MLQUEUE:
 			rtn = NEEDS_RETRY;
@@ -1480,6 +1481,12 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
+		if (rtn == TARGET_ERROR) {
+			/* Need to modify host byte to signal a
+			 * permanent target failure */
+			scmd->result |= (DID_TARGET_FAILURE << 16);
+			rtn = SUCCESS;
+		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5b6bbae..9b4fe20 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -736,8 +736,20 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				memcpy(req->sense, cmd->sense_buffer,  len);
 				req->sense_len = len;
 			}
-			if (!sense_deferred)
-				error = -EIO;
+			if (!sense_deferred) {
+				switch(host_byte(result)) {
+				case DID_TRANSPORT_FAILFAST:
+					error = -ENOLINK;
+					break;
+				case DID_TARGET_FAILURE:
+					cmd->result |= (DID_OK << 16);
+					error = -EREMOTEIO;
+					break;
+				default:
+					error = -EIO;
+					break;
+				}
+			}
 		}
 
 		req->resid_len = scsi_get_resid(cmd);
@@ -796,7 +808,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	error = -EIO;
+	switch (host_byte(result)) {
+	case DID_TRANSPORT_FAILFAST:
+		error = -ENOLINK;
+		break;
+	case DID_TARGET_FAILURE:
+		cmd->result |= (DID_OK << 16);
+		error = -EREMOTEIO;
+		break;
+	default:
+		error = -EIO;
+		break;
+	}
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
@@ -1415,7 +1438,6 @@ static void scsi_softirq_done(struct request *rq)
 			    wait_for/HZ);
 		disposition = SUCCESS;
 	}
-			
 	scsi_log_completion(cmd, disposition);
 
 	switch (disposition) {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 216af85..73d27d9 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -405,6 +405,8 @@ static inline int scsi_is_wlun(unsigned int lun)
 				      * recover the link. Transport class will
 				      * retry or fail IO */
 #define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
+#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
+				 * other paths */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
@@ -434,6 +436,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
+#define TARGET_ERROR    0x200A
 
 /*
  * Midlevel queue return values.
