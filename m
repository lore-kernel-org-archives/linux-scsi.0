From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 3/3] target: Use scsi helpers to build the sense data correctly
Date: Sun,  5 Jul 2015 10:31:11 +0300
Message-ID: <1436081471-667-4-git-send-email-sagig@mellanox.com>
References: <1436081471-667-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:46118 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbbGEIbk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jul 2015 04:31:40 -0400
In-Reply-To: <1436081471-667-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Instead of open coding the sense buffer construction, use
scsi scsi_build_sense_buffer() and scsi_set_sense_information()
helpers which moved to scsi_common.

This patch also fixes wrong setting of descriptor format sense data
for t10-pi integrity errors.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/scsi_common.c             | 58 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c              | 58 ----------------------------------
 drivers/target/target_core_spc.c       | 31 +++---------------
 drivers/target/target_core_transport.c | 24 ++++----------
 include/scsi/scsi_common.h             |  3 ++
 include/scsi/scsi_eh.h                 |  4 +--
 include/target/target_core_base.h      |  9 +-----
 7 files changed, 75 insertions(+), 112 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 2ff0922..081d7dd 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -176,3 +176,61 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 	return true;
 }
 EXPORT_SYMBOL(scsi_normalize_sense);
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
index 106884a..462630f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2495,61 +2495,3 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
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
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index b074443..c43dcbf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1157,32 +1157,11 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	if (!rbuf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq)) {
-		/*
-		 * CURRENT ERROR, UNIT ATTENTION
-		 */
-		buf[0] = 0x70;
-		buf[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
-
-		/*
-		 * The Additional Sense Code (ASC) from the UNIT ATTENTION
-		 */
-		buf[SPC_ASC_KEY_OFFSET] = ua_asc;
-		buf[SPC_ASCQ_KEY_OFFSET] = ua_ascq;
-		buf[7] = 0x0A;
-	} else {
-		/*
-		 * CURRENT ERROR, NO SENSE
-		 */
-		buf[0] = 0x70;
-		buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
-
-		/*
-		 * NO ADDITIONAL SENSE INFORMATION
-		 */
-		buf[SPC_ASC_KEY_OFFSET] = 0x00;
-		buf[7] = 0x0A;
-	}
+	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
+		scsi_build_sense_buffer(0, buf, UNIT_ATTENTION,
+					ua_asc, ua_ascq);
+	else
+		scsi_build_sense_buffer(0, buf, NO_SENSE, 0x0, 0x0);
 
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7e31eaf..6ae0e28 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2695,24 +2695,12 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
-static
-void transport_err_sector_info(unsigned char *buffer, sector_t bad_sector)
-{
-	/* Place failed LBA in sense data information descriptor 0. */
-	buffer[SPC_ADD_SENSE_LEN_OFFSET] = 0xc;
-	buffer[SPC_DESC_TYPE_OFFSET] = 0; /* Information */
-	buffer[SPC_ADDITIONAL_DESC_LEN_OFFSET] = 0xa;
-	buffer[SPC_VALIDITY_OFFSET] = 0x80;
-
-	/* Descriptor Information: failing sector */
-	put_unaligned_be64(bad_sector, &buffer[12]);
-}
-
 struct sense_info {
 	u8 key;
 	u8 asc;
 	u8 ascq;
 	bool add_sector_info;
+	int desc_format;
 };
 
 static const struct sense_info sense_info_table[] = {
@@ -2796,18 +2784,21 @@ static const struct sense_info sense_info_table[] = {
 		.asc = 0x10,
 		.ascq = 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
 		.add_sector_info = true,
+		.desc_format = 1,
 	},
 	[TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] = {
 		.key = ILLEGAL_REQUEST,
 		.asc = 0x10,
 		.ascq = 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
 		.add_sector_info = true,
+		.desc_format = 1,
 	},
 	[TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] = {
 		.key = ILLEGAL_REQUEST,
 		.asc = 0x10,
 		.ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
 		.add_sector_info = true,
+		.desc_format = 1,
 	},
 	[TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE] = {
 		/*
@@ -2833,7 +2824,6 @@ static void translate_sense_reason(struct se_cmd *cmd, int r)
 		si = &sense_info_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
-	buffer[SPC_SENSE_KEY_OFFSET] = si->key;
 	if (r == (__force int)TCM_CHECK_CONDITION_UNIT_ATTENTION) {
 		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
 		WARN_ON_ONCE(asc == 0);
@@ -2845,10 +2835,10 @@ static void translate_sense_reason(struct se_cmd *cmd, int r)
 		asc = si->asc;
 		ascq = si->ascq;
 	}
-	buffer[SPC_ASC_KEY_OFFSET] = asc;
-	buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
+
+	scsi_build_sense_buffer(si->desc_format, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
-		transport_err_sector_info(cmd->sense_buffer, cmd->bad_sector);
+		scsi_set_sense_information(buffer, cmd->bad_sector);
 }
 
 int
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 676b03b..8350f1e 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -61,4 +61,7 @@ static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
 extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
+extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
+extern void scsi_set_sense_information(u8 *buf, u64 info);
+
 #endif /* _SCSI_COMMON_H_ */
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 4942710..ea47833 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -4,6 +4,7 @@
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_common.h>
 struct scsi_device;
 struct Scsi_Host;
 
@@ -27,9 +28,6 @@ extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 				   u64 * info_out);
 
-extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
-extern void scsi_set_sense_information(u8 *buf, u64 info);
-
 extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
 struct scsi_eh_save {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9e2e0c0..dfdd560 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -7,6 +7,7 @@
 #include <linux/blkdev.h>
 #include <linux/percpu_ida.h>
 #include <linux/t10-pi.h>
+#include <scsi/scsi_common.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 
@@ -22,14 +23,6 @@
  * defined 96, but the real limit is 252 (or 260 including the header)
  */
 #define TRANSPORT_SENSE_BUFFER			96
-/* Used by transport_send_check_condition_and_sense() */
-#define SPC_SENSE_KEY_OFFSET			2
-#define SPC_ADD_SENSE_LEN_OFFSET		7
-#define SPC_DESC_TYPE_OFFSET			8
-#define SPC_ADDITIONAL_DESC_LEN_OFFSET		9
-#define SPC_VALIDITY_OFFSET			10
-#define SPC_ASC_KEY_OFFSET			12
-#define SPC_ASCQ_KEY_OFFSET			13
 #define TRANSPORT_IQN_LEN			224
 /* Used by target_core_store_alua_lu_gp() and target_core_alua_lu_gp_show_attr_members() */
 #define LU_GROUP_NAME_BUF			256
-- 
1.8.4.3

