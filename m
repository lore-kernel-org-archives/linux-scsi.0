From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/10] scsi: Conditionally compile in constants.c
Date: Thu,  6 Nov 2014 09:30:38 +0100
Message-ID: <1415262639-121586-10-git-send-email-hare@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaKFIap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:30:45 -0500
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Instead of having constants.c littered with ifdef statements
we should be moving dummy functions into the header and
condintionally compile in constants.c if selected.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Makefile      |  4 +--
 drivers/scsi/constants.c   | 42 ----------------------------
 drivers/xen/xen-scsiback.c |  1 +
 include/scsi/scsi_dbg.h    | 68 +++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 67 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 4991b62..76f8932 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -158,9 +158,9 @@ obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
 
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
-
-scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
+scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
 				   scsicam.o scsi_error.o scsi_lib.o
+scsi_mod-$(CONFIG_SCSI_CONSTANTS) += constants.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index dfa8639..a66572b 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -18,8 +18,6 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
 
-
-
 /* Commands with service actions that change the command name */
 #define THIRD_PARTY_COPY_OUT 0x83
 #define THIRD_PARTY_COPY_IN 0x84
@@ -35,7 +33,6 @@ struct value_name_pair {
 	const char * name;
 };
 
-#ifdef CONFIG_SCSI_CONSTANTS
 static const char * cdb_byte0_names[] = {
 /* 00-03 */ "Test Unit Ready", "Rezero Unit/Rewind", NULL, "Request Sense",
 /* 04-07 */ "Format Unit/Medium", "Read Block Limits", NULL,
@@ -259,26 +256,6 @@ static struct sa_name_list sa_names_arr[] = {
 	{0, NULL, 0},
 };
 
-#else /* ifndef CONFIG_SCSI_CONSTANTS */
-static const char *cdb_byte0_names[0];
-
-static struct sa_name_list sa_names_arr[] = {
-	{VARIABLE_LENGTH_CMD, NULL, 0},
-	{MAINTENANCE_IN, NULL, 0},
-	{MAINTENANCE_OUT, NULL, 0},
-	{PERSISTENT_RESERVE_IN, NULL, 0},
-	{PERSISTENT_RESERVE_OUT, NULL, 0},
-	{SERVICE_ACTION_IN_12, NULL, 0},
-	{SERVICE_ACTION_OUT_12, NULL, 0},
-	{SERVICE_ACTION_BIDIRECTIONAL, NULL, 0},
-	{SERVICE_ACTION_IN_16, NULL, 0},
-	{SERVICE_ACTION_OUT_16, NULL, 0},
-	{THIRD_PARTY_COPY_IN, NULL, 0},
-	{THIRD_PARTY_COPY_OUT, NULL, 0},
-	{0, NULL, 0},
-};
-#endif /* CONFIG_SCSI_CONSTANTS */
-
 bool scsi_opcode_sa_name(int opcode, int service_action,
 			 const char **cdb_name, const char **sa_name)
 {
@@ -313,8 +290,6 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
 	return true;
 }
 
-#ifdef CONFIG_SCSI_CONSTANTS
-
 struct error_info {
 	unsigned short code12;	/* 0x0302 looks better than 0x03,0x02 */
 	const char * text;
@@ -1177,15 +1152,12 @@ static const char * const snstext[] = {
 	"Completed",	    /* F: command completed sense data reported,
 				  may occur for successful command */
 };
-#endif
 
 /* Get sense key string or NULL if not available */
 const char *
 scsi_sense_key_string(unsigned char key) {
-#ifdef CONFIG_SCSI_CONSTANTS
 	if (key <= 0xE)
 		return snstext[key];
-#endif
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_sense_key_string);
@@ -1197,7 +1169,6 @@ EXPORT_SYMBOL(scsi_sense_key_string);
 const char *
 scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 {
-#ifdef CONFIG_SCSI_CONSTANTS
 	int i;
 	unsigned short code = ((asc << 8) | ascq);
 
@@ -1211,13 +1182,10 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 			*fmt = additional2[i].fmt;
 			return additional2[i].str;
 	}
-#endif
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_extd_sense_format);
 
-#ifdef CONFIG_SCSI_CONSTANTS
-
 static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
@@ -1229,17 +1197,13 @@ static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 
-#endif
-
 const char *scsi_hostbyte_string(int result)
 {
 	const char *hb_string = NULL;
-#ifdef CONFIG_SCSI_CONSTANTS
 	int hb = host_byte(result);
 
 	if (hb < ARRAY_SIZE(hostbyte_table))
 		hb_string = hostbyte_table[hb];
-#endif
 	return hb_string;
 }
 EXPORT_SYMBOL(scsi_hostbyte_string);
@@ -1247,17 +1211,14 @@ EXPORT_SYMBOL(scsi_hostbyte_string);
 const char *scsi_driverbyte_string(int result)
 {
 	const char *db_string = NULL;
-#ifdef CONFIG_SCSI_CONSTANTS
 	int db = driver_byte(result);
 
 	if (db < ARRAY_SIZE(driverbyte_table))
 		db_string = driverbyte_table[db];
-#endif
 	return db_string;
 }
 EXPORT_SYMBOL(scsi_driverbyte_string);
 
-#ifdef CONFIG_SCSI_CONSTANTS
 #define scsi_mlreturn_name(result)	{ result, #result }
 static const struct value_name_pair scsi_mlreturn_arr[] = {
 	scsi_mlreturn_name(NEEDS_RETRY),
@@ -1270,11 +1231,9 @@ static const struct value_name_pair scsi_mlreturn_arr[] = {
 	scsi_mlreturn_name(SCSI_RETURN_NOT_HANDLED),
 	scsi_mlreturn_name(FAST_IO_FAIL)
 };
-#endif
 
 const char *scsi_mlreturn_string(int result)
 {
-#ifdef CONFIG_SCSI_CONSTANTS
 	const struct value_name_pair *arr = scsi_mlreturn_arr;
 	int k;
 
@@ -1282,7 +1241,6 @@ const char *scsi_mlreturn_string(int result)
 		if (result == arr->value)
 			return arr->name;
 	}
-#endif
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_mlreturn_string);
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 50610a6..cc0ebf2 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -47,6 +47,7 @@
 
 #include <generated/utsrelease.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_tcq.h>
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index c7ed7b8..6434130 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -7,7 +7,6 @@ struct scsi_sense_hdr;
 
 #define SCSI_LOG_BUFSIZE 128
 
-extern bool scsi_opcode_sa_name(int, int, const char **, const char **);
 extern void scsi_print_command(struct scsi_cmnd *);
 extern size_t __scsi_format_command(char *, size_t,
 				   const unsigned char *, size_t);
@@ -22,11 +21,72 @@ extern void __scsi_print_sense(const struct scsi_device *, const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
 extern void scsi_print_result(struct scsi_cmnd *, const char *, int);
-extern const char *scsi_hostbyte_string(int);
-extern const char *scsi_driverbyte_string(int);
-extern const char *scsi_mlreturn_string(int);
+
+#ifdef CONFIG_SCSI_CONSTANTS
+extern bool scsi_opcode_sa_name(int, int, const char **, const char **);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
+extern const char *scsi_mlreturn_string(int);
+extern const char *scsi_hostbyte_string(int);
+extern const char *scsi_driverbyte_string(int);
+#else
+static inline bool
+scsi_opcode_sa_name(int cmd, int sa,
+		    const char **cdb_name, const char **sa_name)
+{
+	*cdb_name = NULL;
+	switch (cmd) {
+	case VARIABLE_LENGTH_CMD:
+	case MAINTENANCE_IN:
+	case MAINTENANCE_OUT:
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+	case SERVICE_ACTION_IN_12:
+	case SERVICE_ACTION_OUT_12:
+	case SERVICE_ACTION_BIDIRECTIONAL:
+	case SERVICE_ACTION_IN_16:
+	case SERVICE_ACTION_OUT_16:
+	case EXTENDED_COPY:
+	case RECEIVE_COPY_RESULTS:
+		*sa_name = NULL;
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline const char *
+scsi_sense_key_string(unsigned char key)
+{
+	return NULL;
+}
+
+static inline const char *
+scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
+{
+	*fmt = NULL;
+	return NULL;
+}
+
+static inline const char *
+scsi_mlreturn_string(int result)
+{
+	return NULL;
+}
+
+static inline const char *
+scsi_hostbyte_string(int result)
+{
+	return NULL;
+}
+
+static inline const char *
+scsi_driverbyte_string(int result)
+{
+	return NULL;
+}
+
+#endif
 
 #endif /* _SCSI_SCSI_DBG_H */
-- 
1.8.5.2

