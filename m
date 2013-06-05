From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: Return ENODATA on medium error
Date: Wed,  5 Jun 2013 09:11:01 +0200
Message-ID: <1370416261-57005-4-git-send-email-hare@suse.de>
References: <1370416261-57005-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1370416261-57005-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When a medium error is detected the SCSI stack should return
ENODATA to the upper layers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 7 ++++++-
 drivers/scsi/scsi_lib.c   | 5 +++++
 include/scsi/scsi.h       | 2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index bf5e61a..2ded10a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -235,6 +235,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  *	NEEDS_RETRY
  *	TARGET_ERROR
  *	ALLOC_ERROR
+ *	MEDIA_FAILURE
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -375,7 +376,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return TARGET_ERROR;
+			return MEDIA_FAILURE;
 		}
 		return NEEDS_RETRY;
 
@@ -1598,6 +1599,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 			/* target hit out-of-space condition */
 			set_host_byte(scmd, DID_ALLOC_FAILURE);
 			rtn = SUCCESS;
+		} else if (rtn == MEDIA_FAILURE) {
+			/* medium error */
+			set_host_byte(scmd, DID_MEDIUM_ERROR);
+			rtn = SUCCESS;
 		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 209a4d5..39d626e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -711,6 +711,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * -EREMOTEIO	permanent target failure, do not retry
  * -EBADE	permanent nexus failure, retry on other path
  * -ENOSPC	No write space available
+ * -ENODATA	Medium error
  */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 {
@@ -732,6 +733,10 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 		set_host_byte(cmd, DID_OK);
 		error = -ENOSPC;
 		break;
+	case DID_MEDIUM_ERROR:
+		set_host_byte(cmd, DID_OK);
+		error = -ENODATA;
+		break;
 	default:
 		error = -EIO;
 		break;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5ead86b..c397684 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -453,6 +453,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
 				 * paths might yield different results */
 #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
+#define DID_MEDIUM_ERROR  0x13  /* Medium error */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
@@ -484,6 +485,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define FAST_IO_FAIL	0x2009
 #define TARGET_ERROR    0x200A
 #define ALLOC_ERROR     0x200B
+#define MEDIA_FAILURE   0x200C
 
 /*
  * Midlevel queue return values.
-- 
1.7.12.4

