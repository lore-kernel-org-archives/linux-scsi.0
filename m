From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Tue, 22 May 2018 11:15:09 -0700
Message-ID: <20180522181512.39316-4-keescook@chromium.org>
References: <20180522181512.39316-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522181512.39316-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Both SCSI and ATAPI share the sense header. In preparation for using the
struct scsi_sense_hdr more widely, move this into a separate header and
move the helper function to scsi_ioctl.c which is linked with CONFIG_IDE
by way of CONFIG_BLK_SCSI_REQUEST.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 block/scsi_ioctl.c         | 64 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_common.c | 64 --------------------------------------
 include/scsi/scsi_cmnd.h   |  1 -
 include/scsi/scsi_common.h | 32 +------------------
 include/scsi/scsi_sense.h  | 44 ++++++++++++++++++++++++++
 5 files changed, 109 insertions(+), 96 deletions(-)
 create mode 100644 include/scsi/scsi_sense.h

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 60b471f8621b..87ff3cc7a364 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -728,6 +728,70 @@ void scsi_req_init(struct scsi_request *req)
 }
 EXPORT_SYMBOL(scsi_req_init);
 
+/**
+ * scsi_normalize_sense - normalize main elements from either fixed or
+ *			descriptor sense data format into a common format.
+ *
+ * @sense_buffer:	byte array containing sense data returned by device
+ * @sb_len:		number of valid bytes in sense_buffer
+ * @sshdr:		pointer to instance of structure that common
+ *			elements are written to.
+ *
+ * Notes:
+ *	The "main elements" from sense data are: response_code, sense_key,
+ *	asc, ascq and additional_length (only for descriptor format).
+ *
+ *	Typically this function can be called after a device has
+ *	responded to a SCSI command with the CHECK_CONDITION status.
+ *
+ * Return value:
+ *	true if valid sense data information found, else false;
+ */
+bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+			  struct scsi_sense_hdr *sshdr)
+{
+	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
+
+	if (!sense_buffer || !sb_len)
+		return false;
+
+	sshdr->response_code = (sense_buffer[0] & 0x7f);
+
+	if (!scsi_sense_valid(sshdr))
+		return false;
+
+	if (sshdr->response_code >= 0x72) {
+		/*
+		 * descriptor format
+		 */
+		if (sb_len > 1)
+			sshdr->sense_key = (sense_buffer[1] & 0xf);
+		if (sb_len > 2)
+			sshdr->asc = sense_buffer[2];
+		if (sb_len > 3)
+			sshdr->ascq = sense_buffer[3];
+		if (sb_len > 7)
+			sshdr->additional_length = sense_buffer[7];
+	} else {
+		/*
+		 * fixed format
+		 */
+		if (sb_len > 2)
+			sshdr->sense_key = (sense_buffer[2] & 0xf);
+		if (sb_len > 7) {
+			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
+					 sb_len : (sense_buffer[7] + 8);
+			if (sb_len > 12)
+				sshdr->asc = sense_buffer[12];
+			if (sb_len > 13)
+				sshdr->ascq = sense_buffer[13];
+		}
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(scsi_normalize_sense);
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 90349498f686..8621a07cb967 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -116,70 +116,6 @@ void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
 }
 EXPORT_SYMBOL(int_to_scsilun);
 
-/**
- * scsi_normalize_sense - normalize main elements from either fixed or
- *			descriptor sense data format into a common format.
- *
- * @sense_buffer:	byte array containing sense data returned by device
- * @sb_len:		number of valid bytes in sense_buffer
- * @sshdr:		pointer to instance of structure that common
- *			elements are written to.
- *
- * Notes:
- *	The "main elements" from sense data are: response_code, sense_key,
- *	asc, ascq and additional_length (only for descriptor format).
- *
- *	Typically this function can be called after a device has
- *	responded to a SCSI command with the CHECK_CONDITION status.
- *
- * Return value:
- *	true if valid sense data information found, else false;
- */
-bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
-			  struct scsi_sense_hdr *sshdr)
-{
-	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
-
-	if (!sense_buffer || !sb_len)
-		return false;
-
-	sshdr->response_code = (sense_buffer[0] & 0x7f);
-
-	if (!scsi_sense_valid(sshdr))
-		return false;
-
-	if (sshdr->response_code >= 0x72) {
-		/*
-		 * descriptor format
-		 */
-		if (sb_len > 1)
-			sshdr->sense_key = (sense_buffer[1] & 0xf);
-		if (sb_len > 2)
-			sshdr->asc = sense_buffer[2];
-		if (sb_len > 3)
-			sshdr->ascq = sense_buffer[3];
-		if (sb_len > 7)
-			sshdr->additional_length = sense_buffer[7];
-	} else {
-		/*
-		 * fixed format
-		 */
-		if (sb_len > 2)
-			sshdr->sense_key = (sense_buffer[2] & 0xf);
-		if (sb_len > 7) {
-			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
-					 sb_len : (sense_buffer[7] + 8);
-			if (sb_len > 12)
-				sshdr->asc = sense_buffer[12];
-			if (sb_len > 13)
-				sshdr->ascq = sense_buffer[13];
-		}
-	}
-
-	return true;
-}
-EXPORT_SYMBOL(scsi_normalize_sense);
-
 /**
  * scsi_sense_desc_find - search for a given descriptor type in	descriptor sense data format.
  * @sense_buffer:	byte array of descriptor format sense data
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index aaf1e971c6a3..3b9f42f6615c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -120,7 +120,6 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
-#define SCSI_SENSE_BUFFERSIZE 	96
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 731ac09ed231..82d6209f2e10 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <scsi/scsi_proto.h>
+#include <scsi/scsi_sense.h>
 
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
@@ -31,37 +32,6 @@ extern const char *scsi_device_type(unsigned type);
 extern void int_to_scsilun(u64, struct scsi_lun *);
 extern u64 scsilun_to_int(struct scsi_lun *);
 
-/*
- * This is a slightly modified SCSI sense "descriptor" format header.
- * The addition is to allow the 0x70 and 0x71 response codes. The idea
- * is to place the salient data from either "fixed" or "descriptor" sense
- * format into one structure to ease application processing.
- *
- * The original sense buffer should be kept around for those cases
- * in which more information is required (e.g. the LBA of a MEDIUM ERROR).
- */
-struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
-	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
-	u8 sense_key;
-	u8 asc;
-	u8 ascq;
-	u8 byte4;
-	u8 byte5;
-	u8 byte6;
-	u8 additional_length;	/* always 0 for fixed sense format */
-};
-
-static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
-{
-	if (!sshdr)
-		return false;
-
-	return (sshdr->response_code & 0x70) == 0x70;
-}
-
-extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
-				 struct scsi_sense_hdr *sshdr);
-
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
 int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
 int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd);
diff --git a/include/scsi/scsi_sense.h b/include/scsi/scsi_sense.h
new file mode 100644
index 000000000000..be923c67b93e
--- /dev/null
+++ b/include/scsi/scsi_sense.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Structures and functions used by both SCSI and ATAPI sense code.
+ */
+
+#ifndef _SCSI_SENSE_H_
+#define _SCSI_SENSE_H_
+
+#include <linux/types.h>
+
+/*
+ * This is a slightly modified SCSI sense "descriptor" format header.
+ * The addition is to allow the 0x70 and 0x71 response codes. The idea
+ * is to place the salient data from either "fixed" or "descriptor" sense
+ * format into one structure to ease application processing.
+ *
+ * The original sense buffer should be kept around for those cases
+ * in which more information is required (e.g. the LBA of a MEDIUM ERROR).
+ */
+struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
+	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
+	u8 sense_key;
+	u8 asc;
+	u8 ascq;
+	u8 byte4;
+	u8 byte5;
+	u8 byte6;
+	u8 additional_length;	/* always 0 for fixed sense format */
+};
+
+static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
+{
+	if (!sshdr)
+		return false;
+
+	return (sshdr->response_code & 0x70) == 0x70;
+}
+
+#define SCSI_SENSE_BUFFERSIZE 	96
+
+extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+				 struct scsi_sense_hdr *sshdr);
+
+#endif /* _SCSI_SENSE_H_ */
-- 
2.17.0
