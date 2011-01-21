From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Fri, 21 Jan 2011 09:07:54 +0100
Message-ID: <1295597274-5844-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1AUIH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2011 03:07:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 08A5090847
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2011 09:07:55 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Consider a scenario where a SCSI EH command like TUR fails with a NOT READY
status - MANUAL INTERVENTION REQUIRED (02/04/03). As evident in the ASC/ASCQ
description, manual intervention is required in this case i.e. the target wants
TUR to fail here so that the host administrator can take corrective action.

But this particular ASC/ASCQ is not handled in the scsi_check_sense, which
ultimately causes scsi_eh_tur to erroneously report a SUCCESS (device ready)
instead of the actual FAILURE state (device not ready).

This patch converts scsi_check_sense() to return SOFT_ERROR in
cases where an error has been signalled via the sense code, but
we should not wake the error handler. This error code will be
reverted back to SUCCESS for normal command handling, but
scsi_eh_completed_normally() will convert it to FAILED.

Reported-by: Martin George <marting@netapp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 45c7564..e86e62e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -223,7 +223,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  * @scmd:	Cmd to have sense checked.
  *
  * Return value:
- * 	SUCCESS or FAILED or NEEDS_RETRY
+ * 	SUCCESS or FAILED or NEEDS_RETRY or SOFT_ERROR
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -278,7 +278,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 
 	case ABORTED_COMMAND:
 		if (sshdr.asc == 0x10) /* DIF */
-			return SUCCESS;
+			return SOFT_ERROR;
 
 		return NEEDS_RETRY;
 	case NOT_READY:
@@ -324,19 +324,19 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 * Pass the UA upwards for a determination in the completion
 		 * functions.
 		 */
-		return SUCCESS;
+		return SOFT_ERROR;
 
 		/* these three are not supported */
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
-		return SUCCESS;
+		return SOFT_ERROR;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return SUCCESS;
+			return SOFT_ERROR;
 		}
 		return NEEDS_RETRY;
 
@@ -344,13 +344,13 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
 		else
-			return SUCCESS;
+			return SOFT_ERROR;
 
 	case ILLEGAL_REQUEST:
 	case BLANK_CHECK:
 	case DATA_PROTECT:
 	default:
-		return SUCCESS;
+		return SOFT_ERROR;
 	}
 }
 
@@ -1469,10 +1469,15 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
-		/* if rtn == FAILED, we have no sense information;
+		/* If rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
-		 * disposition */
+		 * disposition.
+		 * If rtn == SOFT_ERROR an error has occurred, but
+		 * we do _not_ need to wake the error handler.
+		 * So return SUCCESS here. */
+		if (rtn == SOFT_ERROR)
+			rtn = SUCCESS;
 		return rtn;
 	case CONDITION_GOOD:
 	case INTERMEDIATE_GOOD:
