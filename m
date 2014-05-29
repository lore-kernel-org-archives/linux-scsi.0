From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 12/14] block: Add specific data integrity errors
Date: Wed, 28 May 2014 23:28:46 -0400
Message-ID: <1401334128-15499-13-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26967 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbaE2D33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:29 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Introduce a set of error codes that can be used by the block integrity
subsystem to signal which class of error was encountered by either the
I/O controller or the storage device.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-core.c                 | 12 ++++++++++++
 drivers/md/dm-mpath.c            |  9 +++++++++
 drivers/scsi/scsi_lib.c          | 30 ++++++++++++++++++++++++++++--
 include/uapi/asm-generic/errno.h | 11 +++++++++++
 4 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5b6f768a7c01..9e8b9649baf7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2428,6 +2428,18 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENODATA:
 			error_type = "critical medium";
 			break;
+		case -ECTRLGRD:
+		case -ECTRLAPP:
+		case -ECTRLREF:
+		case -EDISKGRD:
+		case -EDISKAPP:
+		case -EDISKREF:
+		case -EKERNGRD:
+		case -EKERNAPP:
+		case -EKERNREF:
+		case -EILSEQ:
+			error_type = "data integrity";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa009e865871..a8756cdd1002 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1208,6 +1208,15 @@ static int noretry_error(int error)
 	case -EOPNOTSUPP:
 	case -EREMOTEIO:
 	case -EILSEQ:
+	case -ECTRLGRD:
+	case -ECTRLAPP:
+	case -ECTRLREF:
+	case -EDISKGRD:
+	case -EDISKAPP:
+	case -EDISKREF:
+	case -EKERNGRD:
+	case -EKERNAPP:
+	case -EKERNREF:
 	case -ENODATA:
 	case -ENOSPC:
 		return 1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3cc82d3dec78..4f369d6f1162 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -892,7 +892,20 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			} else if (sshdr.asc == 0x10) /* DIX */ {
 				description = "Host Data Integrity Failure";
 				action = ACTION_FAIL;
-				error = -EILSEQ;
+				switch (sshdr.ascq) {
+				case 0x1:
+					error = -ECTRLGRD;
+					break;
+				case 0x2:
+					error = -ECTRLAPP;
+					break;
+				case 0x3:
+					error = -ECTRLREF;
+					break;
+				default:
+					error = -EILSEQ;
+					break;
+				}
 			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
 			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
 				switch (cmd->cmnd[0]) {
@@ -920,7 +933,20 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			if (sshdr.asc == 0x10) { /* DIF */
 				description = "Target Data Integrity Failure";
-				error = -EILSEQ;
+				switch (sshdr.ascq) {
+				case 0x1:
+					error = -EDISKGRD;
+					break;
+				case 0x2:
+					error = -EDISKAPP;
+					break;
+				case 0x3:
+					error = -EDISKREF;
+					break;
+				default:
+					error = -EILSEQ;
+					break;
+				}
 			}
 			break;
 		case NOT_READY:
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index 1e1ea6e6e7a5..d89af4ba1e04 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -110,4 +110,15 @@
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
+/* data integrity errors */
+#define ECTRLGRD	134	/* I/O controller detected guard tag error */
+#define ECTRLAPP	135	/* I/O controller detected app tag error */
+#define ECTRLREF	136	/* I/O controller detected ref tag error */
+#define EDISKGRD	137	/* Storage device detected guard tag error */
+#define EDISKAPP	138	/* Storage device detected app tag error */
+#define EDISKREF	139	/* Storage device detected ref tag error */
+#define EKERNGRD	140	/* Kernel detected guard tag error */
+#define EKERNAPP	141	/* Kernel detected app tag error */
+#define EKERNREF	142	/* Kernel detected ref tag error */
+
 #endif
-- 
1.9.0

