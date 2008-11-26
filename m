From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 2/7] Allow requeuement on DID_SOFT_ERROR
Date: Wed, 26 Nov 2008 18:46:50 +0100
Message-ID: <200811261846.51644.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:53707 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYKZRq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 12:46:57 -0500
In-Reply-To: <200811261840.45360.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Activate the error handler if DID_SOFT_ERROR failed to often, but only 
for commands which have a scmd->allowed > 1. 
Also make a function out of a goto-block.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

---
 drivers/scsi/scsi_error.c |   65 +++++++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c
+++ linux-2.6/drivers/scsi/scsi_error.c
@@ -1271,6 +1271,47 @@ int scsi_noretry_cmd(struct scsi_cmnd *s
 }
 
 /**
+ * maybe_retry - decide if to retry a scsi-command or to return an error
+ * @scmd:	scsi command to examine
+ * @retry_code	ADD_TO_MLQUEUE or NEEDS_RETRY
+ *
+ * Notes:
+ *    Returning FAILED will activate the error handler,
+ *    returning SUCCESS will fail the scsi command
+ **/
+static int maybe_retry(struct scsi_cmnd *scmd, int retry_code)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	scmd->retries++;
+
+	/* we requeue for retry because the error was retryable, and
+	 * the request was not marked fast fail.  Note that above,
+	 * even if the request is marked fast fail, we still requeue
+	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
+	if (scmd->retries <= scmd->allowed
+	    && !blk_noretry_request(scmd->request)) {
+		return retry_code;
+	} else  if (scmd->retries <= scmd->allowed + 1
+		&& !blk_noretry_request(scmd->request)
+		&& retry_code == ADD_TO_MLQUEUE
+		&& scmd->allowed > 1) {
+		/*
+		 * activate error recovery
+		 */
+		sdev_printk(KERN_INFO, sdev, "scmd retry %d/%d\n",
+			    scmd->retries, scmd->allowed + 1);
+		return FAILED;
+	} else {
+		/*
+		 * no more retries - report this one back to upper level.
+		 */
+		return SUCCESS;
+	}
+}
+
+
+/**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
  *
@@ -1336,7 +1377,7 @@ int scsi_decide_disposition(struct scsi_
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		goto maybe_retry;
+		return maybe_retry(scmd, ADD_TO_MLQUEUE);
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
 
@@ -1350,7 +1391,7 @@ int scsi_decide_disposition(struct scsi_
 		 * based on its timers and recovery capablilities if
 		 * there are enough retries.
 		 */
-		goto maybe_retry;
+		return maybe_retry(scmd, NEEDS_RETRY);
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely
@@ -1369,7 +1410,7 @@ int scsi_decide_disposition(struct scsi_
 
 	case DID_BUS_BUSY:
 	case DID_PARITY:
-		goto maybe_retry;
+		return maybe_retry(scmd, NEEDS_RETRY);
 	case DID_TIME_OUT:
 		/*
 		 * when we scan the bus, we get timeout messages for
@@ -1418,7 +1459,7 @@ int scsi_decide_disposition(struct scsi_
 	case CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
-			goto maybe_retry;
+			return maybe_retry(scmd, NEEDS_RETRY);
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
@@ -1441,22 +1482,6 @@ int scsi_decide_disposition(struct scsi_
 		return FAILED;
 	}
 	return FAILED;
-
-      maybe_retry:
-
-	/* we requeue for retry because the error was retryable, and
-	 * the request was not marked fast fail.  Note that above,
-	 * even if the request is marked fast fail, we still requeue
-	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !scsi_noretry_cmd(scmd)) {
-		return NEEDS_RETRY;
-	} else {
-		/*
-		 * no more retries - report this one back to upper level.
-		 */
-		return SUCCESS;
-	}
 }
 
 /**

