From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/2] scsi.h: Make exported header exportable
Date: Mon, 08 Nov 2010 18:31:29 +0200
Message-ID: <4CD825E1.2040105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:54814 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754081Ab0KHQbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 11:31:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>


* Move kernel specific things to end of file inside
  an #ifdef __KERNEL__ clause
* Convert some u8 to __u8

CC: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/scsi.h |   97 +++++++++++++++++++++++++++------------------------
 1 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 216af85..b217c7c 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -10,39 +10,6 @@
 
 #include <linux/types.h>
 
-struct scsi_cmnd;
-
-/*
- * The maximum number of SG segments that we will put inside a
- * scatterlist (unless chaining is used). Should ideally fit inside a
- * single page, to avoid a higher order allocation.  We could define this
- * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
- * minimum value is 32
- */
-#define SCSI_MAX_SG_SEGMENTS	128
-
-/*
- * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
- * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
- */
-#ifdef ARCH_HAS_SG_CHAIN
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
-#else
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
-#endif
-
-/*
- * DIX-capable adapters effectively support infinite chaining for the
- * protection information scatterlist
- */
-#define SCSI_MAX_PROT_SG_SEGMENTS	0xFFFF
-
-/*
- * Special value for scanning to specify scanning or rescanning of all
- * possible channels, (target) ids, or luns on a given shost.
- */
-#define SCAN_WILD_CARD	~0
-
 /*
  *      SCSI opcodes
  */
@@ -173,16 +140,6 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
 
-extern const unsigned char scsi_command_size_tbl[8];
-#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
-
-static inline unsigned
-scsi_command_size(const unsigned char *cmnd)
-{
-	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
-		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
-}
-
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
@@ -298,9 +255,6 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
-/* Returns a human-readable name for the device */
-extern const char * scsi_device_type(unsigned type);
-
 /*
  * standard mode-select header prepended to all mode-select commands
  */
@@ -526,4 +480,55 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
 
+
+#ifdef __KERNEL__
+
+struct scsi_cmnd;
+
+/*
+ * The maximum number of SG segments that we will put inside a
+ * scatterlist (unless chaining is used). Should ideally fit inside a
+ * single page, to avoid a higher order allocation.  We could define this
+ * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
+ * minimum value is 32
+ */
+#define SCSI_MAX_SG_SEGMENTS	128
+
+/*
+ * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
+ * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
+ */
+#ifdef ARCH_HAS_SG_CHAIN
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
+#else
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
+#endif
+
+/*
+ * DIX-capable adapters effectively support infinite chaining for the
+ * protection information scatterlist
+ */
+#define SCSI_MAX_PROT_SG_SEGMENTS	0xFFFF
+
+/*
+ * Special value for scanning to specify scanning or rescanning of all
+ * possible channels, (target) ids, or luns on a given shost.
+ */
+#define SCAN_WILD_CARD	~0
+
+extern const unsigned char scsi_command_size_tbl[8];
+#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
+
+static inline unsigned
+scsi_command_size(const unsigned char *cmnd)
+{
+	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
+		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
+}
+
+/* Returns a human-readable name for the device */
+extern const char *scsi_device_type(unsigned type);
+
+#endif /* __KERNEL__ */
+
 #endif /* _SCSI_SCSI_H */
-- 
1.7.2.3

