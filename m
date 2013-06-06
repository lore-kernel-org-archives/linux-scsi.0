From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: Return ENODATA on medium error
Date: Thu,  6 Jun 2013 10:26:07 +0200
Message-ID: <1370507167-35998-4-git-send-email-hare@suse.de>
References: <1370507167-35998-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139Ab3FFI0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 04:26:11 -0400
In-Reply-To: <1370507167-35998-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>

When a medium error is detected the SCSI stack should return
ENODATA to the upper layers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c          | 3 +++
 drivers/scsi/scsi_error.c | 7 ++++++-
 drivers/scsi/scsi_lib.c   | 5 +++++
 include/scsi/scsi.h       | 2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index dab068b..c5548a4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2318,6 +2318,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENOSPC:
 			error_type = "space allocation";
 			break;
+		case -ENODATA:
+			error_type = "medium";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index eff9b55..0a9e3f3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -236,6 +236,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  *	TARGET_ERROR
  *	ADD_TO_MLQUEUE
  *	ALLOC_ERROR
+ *	MEDIA_FAILURE
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -376,7 +377,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return TARGET_ERROR;
+			return MEDIA_FAILURE;
 		}
 		return NEEDS_RETRY;
 
@@ -1599,6 +1600,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index 8de6697..27ec5b4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -711,6 +711,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * -EREMOTEIO	permanent target failure, do not retry
  * -EBADE	permanent nexus failure, retry on other path
  * -ENOSPC	No write space available
+ * -ENODATA	Medium error
  * -EIO		unclassified I/O error
  */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
@@ -733,6 +734,10 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
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

