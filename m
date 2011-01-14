From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 1/3] scsi: Detailed I/O errors
Date: Fri, 14 Jan 2011 10:58:54 -0500
Message-ID: <1295020736-27699-2-git-send-email-snitzer@redhat.com>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1ANP7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 10:59:14 -0500
In-Reply-To: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu, Mike Snitzer <snitzer@redhat.com>

From: Hannes Reinecke <hare@suse.de>

Instead of just passing 'EIO' for any I/O error we should be
notifying the upper layers with more details about the cause
of this error.

Update the possible I/O errors to:

- ENOLINK: Link failure between host and target
- EIO: Retryable I/O error
- EREMOTEIO: Non-retryable I/O error

'Retryable' in this context means that an I/O error _might_ be
restricted to the I_T_L nexus (vulgo: path), so retrying on another
nexus / path might succeed.

'Non-retryable' means target failure or reservation conflict.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/scsi_error.c |   24 +++++++++++++++++-------
 drivers/scsi/scsi_lib.c   |   24 ++++++++++++++++++++++--
 include/scsi/scsi.h       |    3 +++
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 45c7564..a6c4f5d 100644
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
@@ -326,17 +326,19 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 */
 		return SUCCESS;
 
-		/* these three are not supported */
+		/* these are not supported */
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
-		return SUCCESS;
+	case BLANK_CHECK:
+	case DATA_PROTECT:
+		return TARGET_ERROR;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return SUCCESS;
+			return TARGET_ERROR;
 		}
 		return NEEDS_RETRY;
 
@@ -344,11 +346,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
 		else
-			return SUCCESS;
+			return TARGET_ERROR;
 
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
@@ -1469,6 +1470,14 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
+		else if (rtn == TARGET_ERROR) {
+			/*
+			 * Need to modify host byte to signal a
+			 * permanent target failure
+			 */
+			scmd->result |= (DID_TARGET_FAILURE << 16);
+			rtn = SUCCESS;
+		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
@@ -1486,6 +1495,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case RESERVATION_CONFLICT:
 		sdev_printk(KERN_INFO, scmd->device,
 			    "reservation conflict\n");
+		scmd->result |= (DID_TARGET_FAILURE << 16);
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9045c52..7c5894c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -667,6 +667,26 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
+static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
+{
+	int error = 0;
+
+	switch(host_byte(result)) {
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
+
+	return error;
+}
+
 /*
  * Function:    scsi_io_completion()
  *
@@ -737,7 +757,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 			if (!sense_deferred)
-				error = -EIO;
+				error = __scsi_error_from_host_byte(cmd, result);
 		}
 
 		req->resid_len = scsi_get_resid(cmd);
@@ -796,7 +816,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	error = -EIO;
+	error = __scsi_error_from_host_byte(cmd, result);
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 648d233..18cb2ca 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -434,6 +434,8 @@ static inline int scsi_is_wlun(unsigned int lun)
 				      * recover the link. Transport class will
 				      * retry or fail IO */
 #define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
+#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
+				 * other paths */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
@@ -463,6 +465,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
+#define TARGET_ERROR    0x200A
 
 /*
  * Midlevel queue return values.
-- 
1.7.3.4

