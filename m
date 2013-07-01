From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] scsi: return ENOSPC on thin provisioning failure
Date: Mon,  1 Jul 2013 10:12:09 +0200
Message-ID: <1372666331-66996-4-git-send-email-hare@suse.de>
References: <1372666331-66996-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1372666331-66996-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When the thin provisioning hard threshold is reached we
should return ENOSPC to inform upper layers about this fact.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c          | 3 +++
 drivers/scsi/scsi_error.c | 7 ++++++-
 drivers/scsi/scsi_lib.c   | 5 +++++
 include/scsi/scsi.h       | 1 +
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d5745b5..170607c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2315,6 +2315,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -EBADE:
 			error_type = "critical nexus";
 			break;
+		case -ENOSPC:
+			error_type = "critical space allocation";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e5cb162..aeec0e7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -374,11 +374,16 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 		/* these are not supported */
+	case DATA_PROTECT:
+		if (sshdr.asc == 0x27 && sshdr.ascq == 0x07) {
+			/* Thin provisioning hard threshold reached */
+			set_host_byte(scmd, DID_ALLOC_FAILURE);
+			return SUCCESS;
+		}
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
 	case BLANK_CHECK:
-	case DATA_PROTECT:
 		set_host_byte(scmd, DID_TARGET_FAILURE);
 		return SUCCESS;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d3fc50f..8a2f92d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -710,6 +710,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * -ENOLINK	temporary transport failure
  * -EREMOTEIO	permanent target failure, do not retry
  * -EBADE	permanent nexus failure, retry on other path
+ * -ENOSPC	No write space available
  * -EIO		unspecified I/O error
  */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
@@ -728,6 +729,10 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
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
index 07d4bd916..7d5b8e2 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -452,6 +452,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 				 * other paths */
 #define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
 				 * paths might yield different results */
+#define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
-- 
1.7.12.4

