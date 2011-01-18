From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4 1/3] scsi: Detailed I/O errors
Date: Tue, 18 Jan 2011 10:13:11 +0100
Message-ID: <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
References: <cover.1295340405.git.hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab1ARJNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 04:13:14 -0500
In-Reply-To: <cover.1295340405.git.hare@suse.de>
In-Reply-To: <cover.1295340405.git.hare@suse.de>
References: <cover.1295340405.git.hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>

Instead of just passing 'EIO' for any I/O error we should be
notifying the upper layers with more details about the cause
of this error.

Update the possible I/O errors to:

- ENOLINK: Link failure between host and target
- EIO: Retryable I/O error
- EREMOTEIO: Non-retryable I/O error
- EBADE: I/O error restricted to the I_T_L nexus

'Retryable' in this context means that an I/O error _might_ be
restricted to the I_T_L nexus (vulgo: path), so retrying on another
nexus / path might succeed.

'Non-retryable' in general refers to a target failure, so this
error will always be generated regardless of the I_T_L nexus
it was send on.

I/O errors restricted to the I_T_L nexus might be retried
on another nexus / path, but they should _not_ be queued
if no paths are available.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/scsi_error.c |   24 +++++++++++++++++-------
 drivers/scsi/scsi_lib.c   |   28 ++++++++++++++++++++++++++--
 include/scsi/scsi.h       |    5 +++++
 3 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 45c7564..991de3c 100644
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
+		scmd->result |= (DID_NEXUS_FAILURE << 16);
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0ed7a66..91f1c13 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -667,6 +667,30 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
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
+	case DID_NEXUS_FAILURE:
+		cmd->result |= (DID_OK << 16);
+		error = -EBADE;
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
@@ -737,7 +761,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 			if (!sense_deferred)
-				error = -EIO;
+				error = __scsi_error_from_host_byte(cmd, result);
 		}
 
 		req->resid_len = scsi_get_resid(cmd);
@@ -796,7 +820,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	error = -EIO;
+	error = __scsi_error_from_host_byte(cmd, result);
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 1651fef..078a0ac 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -433,6 +433,10 @@ static inline int scsi_is_wlun(unsigned int lun)
 				      * recover the link. Transport class will
 				      * retry or fail IO */
 #define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
+#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
+				 * other paths */
+#define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
+				 * paths might yield different results */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
@@ -462,6 +466,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
+#define TARGET_ERROR    0x200A
 
 /*
  * Midlevel queue return values.
-- 
1.6.0.2

