From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] scsi: Return ENODATA on medium error
Date: Mon,  1 Jul 2013 15:16:26 +0200
Message-ID: <1372684586-41829-5-git-send-email-hare@suse.de>
References: <1372684586-41829-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab3GANQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 09:16:34 -0400
In-Reply-To: <1372684586-41829-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

When a medium error is detected the SCSI stack should return
ENODATA to the upper layers.

Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c          |  3 +++
 drivers/md/dm-mpath.c     | 16 +++++++++++++++-
 drivers/scsi/scsi_error.c |  2 +-
 drivers/scsi/scsi_lib.c   |  5 +++++
 include/scsi/scsi.h       |  1 +
 5 files changed, 25 insertions(+), 2 deletions(-)

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
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bdf26f5..57896cea 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1261,6 +1261,20 @@ static void activate_path(struct work_struct *work)
 				pg_init_done, pgpath);
 }
 
+static int noretry_error(int error)
+{
+	switch(error) {
+	case -EOPNOTSUPP:
+	case -EREMOTEIO:
+	case -EILSEQ:
+	case -ENODATA:
+		return 1;
+	}
+
+	/* Anything else could be a path failure, so should be retried */
+	return 0;
+}
+
 /*
  * end_io handling
  */
@@ -1284,7 +1298,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
+	if (noretry_error(error))
 		return error;
 
 	if (mpio->pgpath)
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

