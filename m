From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v4 3/5] scsi: Move sense handling routines to scsi_common
Date: Wed,  8 Jul 2015 17:58:52 +0300
Message-ID: <1436367534-15995-4-git-send-email-sagig@mellanox.com>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:56992 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933005AbbGHO7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 10:59:38 -0400
In-Reply-To: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Sense data handling is also done in the target stack.
Hence, move sense handling routines to scsi_common so
the target will be able to use them as well.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_common.c | 98 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  | 99 +---------------------------------------------
 include/scsi/scsi_common.h |  5 +++
 include/scsi/scsi_eh.h     |  7 +---
 4 files changed, 105 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 2ff0922..41432c1 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -5,6 +5,7 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
@@ -176,3 +177,100 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 	return true;
 }
 EXPORT_SYMBOL(scsi_normalize_sense);
+
+/**
+ * scsi_sense_desc_find - search for a given descriptor type in	descriptor sense data format.
+ * @sense_buffer:	byte array of descriptor format sense data
+ * @sb_len:		number of valid bytes in sense_buffer
+ * @desc_type:		value of descriptor type to find
+ *			(e.g. 0 -> information)
+ *
+ * Notes:
+ *	only valid when sense data is in descriptor format
+ *
+ * Return value:
+ *	pointer to start of (first) descriptor if found else NULL
+ */
+const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
+				int desc_type)
+{
+	int add_sen_len, add_len, desc_len, k;
+	const u8 * descp;
+
+	if ((sb_len < 8) || (0 == (add_sen_len = sense_buffer[7])))
+		return NULL;
+	if ((sense_buffer[0] < 0x72) || (sense_buffer[0] > 0x73))
+		return NULL;
+	add_sen_len = (add_sen_len < (sb_len - 8)) ?
+			add_sen_len : (sb_len - 8);
+	descp = &sense_buffer[8];
+	for (desc_len = 0, k = 0; k < add_sen_len; k += desc_len) {
+		descp += desc_len;
+		add_len = (k < (add_sen_len - 1)) ? descp[1]: -1;
+		desc_len = add_len + 2;
+		if (descp[0] == desc_type)
+			return descp;
+		if (add_len < 0) // short descriptor ??
+			break;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(scsi_sense_desc_find);
+
+/**
+ * scsi_build_sense_buffer - build sense data in a buffer
+ * @desc:	Sense format (non zero == descriptor format,
+ *              0 == fixed format)
+ * @buf:	Where to build sense data
+ * @key:	Sense key
+ * @asc:	Additional sense code
+ * @ascq:	Additional sense code qualifier
+ *
+ **/
+void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
+{
+	if (desc) {
+		buf[0] = 0x72;	/* descriptor, current */
+		buf[1] = key;
+		buf[2] = asc;
+		buf[3] = ascq;
+		buf[7] = 0;
+	} else {
+		buf[0] = 0x70;	/* fixed, current */
+		buf[2] = key;
+		buf[7] = 0xa;
+		buf[12] = asc;
+		buf[13] = ascq;
+	}
+}
+EXPORT_SYMBOL(scsi_build_sense_buffer);
+
+/**
+ * scsi_set_sense_information - set the information field in a
+ *		formatted sense data buffer
+ * @buf:	Where to build sense data
+ * @info:	64-bit information value to be set
+ *
+ **/
+void scsi_set_sense_information(u8 *buf, u64 info)
+{
+	if ((buf[0] & 0x7f) == 0x72) {
+		u8 *ucp, len;
+
+		len = buf[7];
+		ucp = (char *)scsi_sense_desc_find(buf, len + 8, 0);
+		if (!ucp) {
+			buf[7] = len + 0xa;
+			ucp = buf + 8 + len;
+		}
+		ucp[0] = 0;
+		ucp[1] = 0xa;
+		ucp[2] = 0x80; /* Valid bit */
+		ucp[3] = 0;
+		put_unaligned_be64(info, &ucp[4]);
+	} else if ((buf[0] & 0x7f) == 0x70) {
+		buf[0] |= 0x80;
+		put_unaligned_be64(info, &buf[3]);
+	}
+}
+EXPORT_SYMBOL(scsi_set_sense_information);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106884a..6e6b2d2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -26,7 +26,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
-#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -34,6 +33,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_common.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
@@ -2408,45 +2408,6 @@ bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 EXPORT_SYMBOL(scsi_command_normalize_sense);
 
 /**
- * scsi_sense_desc_find - search for a given descriptor type in	descriptor sense data format.
- * @sense_buffer:	byte array of descriptor format sense data
- * @sb_len:		number of valid bytes in sense_buffer
- * @desc_type:		value of descriptor type to find
- *			(e.g. 0 -> information)
- *
- * Notes:
- *	only valid when sense data is in descriptor format
- *
- * Return value:
- *	pointer to start of (first) descriptor if found else NULL
- */
-const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
-				int desc_type)
-{
-	int add_sen_len, add_len, desc_len, k;
-	const u8 * descp;
-
-	if ((sb_len < 8) || (0 == (add_sen_len = sense_buffer[7])))
-		return NULL;
-	if ((sense_buffer[0] < 0x72) || (sense_buffer[0] > 0x73))
-		return NULL;
-	add_sen_len = (add_sen_len < (sb_len - 8)) ?
-			add_sen_len : (sb_len - 8);
-	descp = &sense_buffer[8];
-	for (desc_len = 0, k = 0; k < add_sen_len; k += desc_len) {
-		descp += desc_len;
-		add_len = (k < (add_sen_len - 1)) ? descp[1]: -1;
-		desc_len = add_len + 2;
-		if (descp[0] == desc_type)
-			return descp;
-		if (add_len < 0) // short descriptor ??
-			break;
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(scsi_sense_desc_find);
-
-/**
  * scsi_get_sense_info_fld - get information field from sense data (either fixed or descriptor format)
  * @sense_buffer:	byte array of sense data
  * @sb_len:		number of valid bytes in sense_buffer
@@ -2495,61 +2456,3 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
-
-/**
- * scsi_build_sense_buffer - build sense data in a buffer
- * @desc:	Sense format (non zero == descriptor format,
- * 		0 == fixed format)
- * @buf:	Where to build sense data
- * @key:	Sense key
- * @asc:	Additional sense code
- * @ascq:	Additional sense code qualifier
- *
- **/
-void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
-{
-	if (desc) {
-		buf[0] = 0x72;	/* descriptor, current */
-		buf[1] = key;
-		buf[2] = asc;
-		buf[3] = ascq;
-		buf[7] = 0;
-	} else {
-		buf[0] = 0x70;	/* fixed, current */
-		buf[2] = key;
-		buf[7] = 0xa;
-		buf[12] = asc;
-		buf[13] = ascq;
-	}
-}
-EXPORT_SYMBOL(scsi_build_sense_buffer);
-
-/**
- * scsi_set_sense_information - set the information field in a
- *		formatted sense data buffer
- * @buf:	Where to build sense data
- * @info:	64-bit information value to be set
- *
- **/
-void scsi_set_sense_information(u8 *buf, u64 info)
-{
-	if ((buf[0] & 0x7f) == 0x72) {
-		u8 *ucp, len;
-
-		len = buf[7];
-		ucp = (char *)scsi_sense_desc_find(buf, len + 8, 0);
-		if (!ucp) {
-			buf[7] = len + 0xa;
-			ucp = buf + 8 + len;
-		}
-		ucp[0] = 0;
-		ucp[1] = 0xa;
-		ucp[2] = 0x80; /* Valid bit */
-		ucp[3] = 0;
-		put_unaligned_be64(info, &ucp[4]);
-	} else if ((buf[0] & 0x7f) == 0x70) {
-		buf[0] |= 0x80;
-		put_unaligned_be64(info, &buf[3]);
-	}
-}
-EXPORT_SYMBOL(scsi_set_sense_information);
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 676b03b..156d673 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -61,4 +61,9 @@ static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
 extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
+extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
+extern void scsi_set_sense_information(u8 *buf, u64 info);
+extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
+				       int desc_type);
+
 #endif /* _SCSI_COMMON_H_ */
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 4942710..dbb8c64 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -4,6 +4,7 @@
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_common.h>
 struct scsi_device;
 struct Scsi_Host;
 
@@ -21,15 +22,9 @@ static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
 }
 
-extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
-				       int desc_type);
-
 extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 				   u64 * info_out);
 
-extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
-extern void scsi_set_sense_information(u8 *buf, u64 info);
-
 extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
 struct scsi_eh_save {
-- 
1.8.4.3

