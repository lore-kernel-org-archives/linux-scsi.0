From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] scsi: Return ENODATA on medium error
Date: Mon,  1 Jul 2013 10:12:10 +0200
Message-ID: <1372666331-66996-5-git-send-email-hare@suse.de>
References: <1372666331-66996-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab3GAIMT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 04:12:19 -0400
In-Reply-To: <1372666331-66996-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When a medium error is detected the SCSI stack should return
ENODATA to the upper layers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c          | 3 +++
 drivers/scsi/scsi_error.c | 2 +-
 drivers/scsi/scsi_lib.c   | 5 +++++
 include/scsi/scsi.h       | 1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 170607c..1093ca1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2318,6 +2318,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENOSPC:
 			error_type = "critical space allocation";
 			break;
+		case -ENODATA:
+			error_type = "critical medium";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index aeec0e7..7f794d4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -391,7 +391,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			set_host_byte(scmd, DID_TARGET_FAILURE);
+			set_host_byte(scmd, DID_MEDIUM_ERROR);
 			return SUCCESS;
 		}
 		return NEEDS_RETRY;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8a2f92d..70ca1f6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -711,6 +711,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * -EREMOTEIO	permanent target failure, do not retry
  * -EBADE	permanent nexus failure, retry on other path
  * -ENOSPC	No write space available
+ * -ENODATA	Medium error
  * -EIO		unspecified I/O error
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
index 7d5b8e2..95ce204 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -453,6 +453,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
 				 * paths might yield different results */
 #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
+#define DID_MEDIUM_ERROR  0x13  /* Medium error */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
-- 
1.7.12.4

