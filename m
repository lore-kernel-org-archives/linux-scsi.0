From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] scsi: Return ENOSPC on thin provisioning failure
Date: Wed,  5 Jun 2013 09:11:00 +0200
Message-ID: <1370416261-57005-3-git-send-email-hare@suse.de>
References: <1370416261-57005-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab3FEHLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jun 2013 03:11:05 -0400
In-Reply-To: <1370416261-57005-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When the thin provisioning hard threshold is reached we
should return ENOSPC to inform upper layers about this fact.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 12 +++++++++++-
 drivers/scsi/scsi_lib.c   |  5 +++++
 include/scsi/scsi.h       |  2 ++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 443b0e3..bf5e61a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -234,6 +234,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  *	FAILED
  *	NEEDS_RETRY
  *	TARGET_ERROR
+ *	ALLOC_ERROR
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -359,11 +360,15 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 		/* these are not supported */
+	case DATA_PROTECT:
+		if (sshdr.asc == 0x27 && sshdr.ascq == 0x07) {
+			/* Thin provisioning hard threshold reached */
+			return ALLOC_ERROR;
+		}
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
 	case BLANK_CHECK:
-	case DATA_PROTECT:
 		return TARGET_ERROR;
 
 	case MEDIUM_ERROR:
@@ -849,6 +854,7 @@ retry:
 		case NEEDS_RETRY:
 		case FAILED:
 		case TARGET_ERROR:
+		case ALLOC_ERROR:
 			break;
 		case ADD_TO_MLQUEUE:
 			rtn = NEEDS_RETRY;
@@ -1588,6 +1594,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 			 */
 			set_host_byte(scmd, DID_TARGET_FAILURE);
 			rtn = SUCCESS;
+		} else if (rtn == ALLOC_ERROR) {
+			/* target hit out-of-space condition */
+			set_host_byte(scmd, DID_ALLOC_FAILURE);
+			rtn = SUCCESS;
 		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 12bfa73..209a4d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -710,6 +710,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * -ENOLINK	temporary transport failure
  * -EREMOTEIO	permanent target failure, do not retry
  * -EBADE	permanent nexus failure, retry on other path
+ * -ENOSPC	No write space available
  */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 {
@@ -727,6 +728,10 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 		set_host_byte(cmd, DID_OK);
 		error = -EBADE;
 		break;
+	case DID_ALLOC_FAILURE:
+		set_host_byte(cmd, DID_OK);
+		error = -ENOSPC;
+		break;
 	default:
 		error = -EIO;
 		break;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..5ead86b 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -452,6 +452,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 				 * other paths */
 #define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
 				 * paths might yield different results */
+#define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
@@ -482,6 +483,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
 #define TARGET_ERROR    0x200A
+#define ALLOC_ERROR     0x200B
 
 /*
  * Midlevel queue return values.
-- 
1.7.12.4

