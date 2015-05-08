From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 2/5] Move code that is used both by initiator and target
 drivers
Date: Fri, 8 May 2015 10:07:48 +0200
Message-ID: <554C6ED4.7070106@sandisk.com>
References: <554C6E79.7020501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <554C6E79.7020501@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Move the functions that are used by both the initiator and target
subsystems into scsi_common.c/.h. This change will allow to remove
the initiator SCSI header include directives from most SCSI target
source files in a later patch.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Makefile      |   1 +
 drivers/scsi/scsi.c        |  46 ------------
 drivers/scsi/scsi_common.c | 178 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  |  64 ----------------
 drivers/scsi/scsi_scan.c   |  62 ----------------
 include/scsi/scsi.h        |  19 +----
 include/scsi/scsi_common.h |  64 ++++++++++++++++
 include/scsi/scsi_device.h |   2 -
 include/scsi/scsi_eh.h     |  31 --------
 9 files changed, 244 insertions(+), 223 deletions(-)
 create mode 100644 drivers/scsi/scsi_common.c
 create mode 100644 include/scsi/scsi_common.h

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index dee160a..ee4517b 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -161,6 +161,7 @@ obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
 				   scsicam.o scsi_error.o scsi_lib.o
+scsi_mod-y			+= scsi_common.o
 scsi_mod-$(CONFIG_SCSI_CONSTANTS) += constants.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3833bf5..207d6a7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -98,52 +98,6 @@ EXPORT_SYMBOL(scsi_sd_probe_domain);
 ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
 EXPORT_SYMBOL(scsi_sd_pm_domain);
 
-/* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
- * You may not alter any existing entry (although adding new ones is
- * encouraged once assigned by ANSI/INCITS T10
- */
-static const char *const scsi_device_types[] = {
-	"Direct-Access    ",
-	"Sequential-Access",
-	"Printer          ",
-	"Processor        ",
-	"WORM             ",
-	"CD-ROM           ",
-	"Scanner          ",
-	"Optical Device   ",
-	"Medium Changer   ",
-	"Communications   ",
-	"ASC IT8          ",
-	"ASC IT8          ",
-	"RAID             ",
-	"Enclosure        ",
-	"Direct-Access-RBC",
-	"Optical card     ",
-	"Bridge controller",
-	"Object storage   ",
-	"Automation/Drive ",
-	"Security Manager ",
-	"Direct-Access-ZBC",
-};
-
-/**
- * scsi_device_type - Return 17 char string indicating device type.
- * @type: type number to look up
- */
-
-const char * scsi_device_type(unsigned type)
-{
-	if (type == 0x1e)
-		return "Well-known LUN   ";
-	if (type == 0x1f)
-		return "No Device        ";
-	if (type >= ARRAY_SIZE(scsi_device_types))
-		return "Unknown          ";
-	return scsi_device_types[type];
-}
-
-EXPORT_SYMBOL(scsi_device_type);
-
 struct scsi_host_cmd_pool {
 	struct kmem_cache	*cmd_slab;
 	struct kmem_cache	*sense_slab;
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
new file mode 100644
index 0000000..2ff0922
--- /dev/null
+++ b/drivers/scsi/scsi_common.c
@@ -0,0 +1,178 @@
+/*
+ * SCSI functions used by both the initiator and the target code.
+ */
+
+#include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <scsi/scsi_common.h>
+
+/* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
+ * You may not alter any existing entry (although adding new ones is
+ * encouraged once assigned by ANSI/INCITS T10
+ */
+static const char *const scsi_device_types[] = {
+	"Direct-Access    ",
+	"Sequential-Access",
+	"Printer          ",
+	"Processor        ",
+	"WORM             ",
+	"CD-ROM           ",
+	"Scanner          ",
+	"Optical Device   ",
+	"Medium Changer   ",
+	"Communications   ",
+	"ASC IT8          ",
+	"ASC IT8          ",
+	"RAID             ",
+	"Enclosure        ",
+	"Direct-Access-RBC",
+	"Optical card     ",
+	"Bridge controller",
+	"Object storage   ",
+	"Automation/Drive ",
+	"Security Manager ",
+	"Direct-Access-ZBC",
+};
+
+/**
+ * scsi_device_type - Return 17 char string indicating device type.
+ * @type: type number to look up
+ */
+const char *scsi_device_type(unsigned type)
+{
+	if (type == 0x1e)
+		return "Well-known LUN   ";
+	if (type == 0x1f)
+		return "No Device        ";
+	if (type >= ARRAY_SIZE(scsi_device_types))
+		return "Unknown          ";
+	return scsi_device_types[type];
+}
+EXPORT_SYMBOL(scsi_device_type);
+
+/**
+ * scsilun_to_int - convert a scsi_lun to an int
+ * @scsilun:	struct scsi_lun to be converted.
+ *
+ * Description:
+ *     Convert @scsilun from a struct scsi_lun to a four byte host byte-ordered
+ *     integer, and return the result. The caller must check for
+ *     truncation before using this function.
+ *
+ * Notes:
+ *     For a description of the LUN format, post SCSI-3 see the SCSI
+ *     Architecture Model, for SCSI-3 see the SCSI Controller Commands.
+ *
+ *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
+ *     returns the integer: 0x0b03d204
+ *
+ *     This encoding will return a standard integer LUN for LUNs smaller
+ *     than 256, which typically use a single level LUN structure with
+ *     addressing method 0.
+ */
+u64 scsilun_to_int(struct scsi_lun *scsilun)
+{
+	int i;
+	u64 lun;
+
+	lun = 0;
+	for (i = 0; i < sizeof(lun); i += 2)
+		lun = lun | (((u64)scsilun->scsi_lun[i] << ((i + 1) * 8)) |
+			     ((u64)scsilun->scsi_lun[i + 1] << (i * 8)));
+	return lun;
+}
+EXPORT_SYMBOL(scsilun_to_int);
+
+/**
+ * int_to_scsilun - reverts an int into a scsi_lun
+ * @lun:        integer to be reverted
+ * @scsilun:	struct scsi_lun to be set.
+ *
+ * Description:
+ *     Reverts the functionality of the scsilun_to_int, which packed
+ *     an 8-byte lun value into an int. This routine unpacks the int
+ *     back into the lun value.
+ *
+ * Notes:
+ *     Given an integer : 0x0b03d204,  this function returns a
+ *     struct scsi_lun of: d2 04 0b 03 00 00 00 00
+ *
+ */
+void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
+{
+	int i;
+
+	memset(scsilun->scsi_lun, 0, sizeof(scsilun->scsi_lun));
+
+	for (i = 0; i < sizeof(lun); i += 2) {
+		scsilun->scsi_lun[i] = (lun >> 8) & 0xFF;
+		scsilun->scsi_lun[i+1] = lun & 0xFF;
+		lun = lun >> 16;
+	}
+}
+EXPORT_SYMBOL(int_to_scsilun);
+
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
+	if (!sense_buffer || !sb_len)
+		return false;
+
+	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
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
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c95a4e9..106884a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2399,70 +2399,6 @@ out_put_autopm_host:
 }
 EXPORT_SYMBOL(scsi_ioctl_reset);
 
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
-	if (!sense_buffer || !sb_len)
-		return false;
-
-	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
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
 bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 				  struct scsi_sense_hdr *sshdr)
 {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6efab1c..5d90cf4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1269,68 +1269,6 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 }
 
 /**
- * scsilun_to_int - convert a scsi_lun to an int
- * @scsilun:	struct scsi_lun to be converted.
- *
- * Description:
- *     Convert @scsilun from a struct scsi_lun to a four byte host byte-ordered
- *     integer, and return the result. The caller must check for
- *     truncation before using this function.
- *
- * Notes:
- *     For a description of the LUN format, post SCSI-3 see the SCSI
- *     Architecture Model, for SCSI-3 see the SCSI Controller Commands.
- *
- *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
- *     returns the integer: 0x0b03d204
- *
- *     This encoding will return a standard integer LUN for LUNs smaller
- *     than 256, which typically use a single level LUN structure with
- *     addressing method 0.
- **/
-u64 scsilun_to_int(struct scsi_lun *scsilun)
-{
-	int i;
-	u64 lun;
-
-	lun = 0;
-	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((u64)scsilun->scsi_lun[i] << ((i + 1) * 8)) |
-			     ((u64)scsilun->scsi_lun[i + 1] << (i * 8)));
-	return lun;
-}
-EXPORT_SYMBOL(scsilun_to_int);
-
-/**
- * int_to_scsilun - reverts an int into a scsi_lun
- * @lun:        integer to be reverted
- * @scsilun:	struct scsi_lun to be set.
- *
- * Description:
- *     Reverts the functionality of the scsilun_to_int, which packed
- *     an 8-byte lun value into an int. This routine unpacks the int
- *     back into the lun value.
- *
- * Notes:
- *     Given an integer : 0x0b03d204,  this function returns a
- *     struct scsi_lun of: d2 04 0b 03 00 00 00 00
- *
- **/
-void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
-{
-	int i;
-
-	memset(scsilun->scsi_lun, 0, sizeof(scsilun->scsi_lun));
-
-	for (i = 0; i < sizeof(lun); i += 2) {
-		scsilun->scsi_lun[i] = (lun >> 8) & 0xFF;
-		scsilun->scsi_lun[i+1] = lun & 0xFF;
-		lun = lun >> 16;
-	}
-}
-EXPORT_SYMBOL(int_to_scsilun);
-
-/**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
  * @starget: which target
  * @bflags: Zero or a mix of BLIST_NOLUN, BLIST_REPORTLUN2, or BLIST_NOREPORTLUN
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index f238e6e..e0a3398 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/scatterlist.h>
 #include <linux/kernel.h>
+#include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
 
 struct scsi_cmnd;
@@ -47,22 +48,6 @@ enum scsi_timeouts {
  */
 #define SCAN_WILD_CARD	~0
 
-static inline unsigned
-scsi_varlen_cdb_length(const void *hdr)
-{
-	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
-}
-
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
 #ifdef CONFIG_ACPI
 struct acpi_bus_type;
 
@@ -96,8 +81,6 @@ static inline int scsi_status_is_good(int status)
 		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
-/* Returns a human-readable name for the device */
-extern const char * scsi_device_type(unsigned type);
 
 /*
  * standard mode-select header prepended to all mode-select commands
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
new file mode 100644
index 0000000..676b03b
--- /dev/null
+++ b/include/scsi/scsi_common.h
@@ -0,0 +1,64 @@
+/*
+ * Functions used by both the SCSI initiator code and the SCSI target code.
+ */
+
+#ifndef _SCSI_COMMON_H_
+#define _SCSI_COMMON_H_
+
+#include <linux/types.h>
+#include <scsi/scsi_proto.h>
+
+static inline unsigned
+scsi_varlen_cdb_length(const void *hdr)
+{
+	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
+}
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
+extern void int_to_scsilun(u64, struct scsi_lun *);
+extern u64 scsilun_to_int(struct scsi_lun *);
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
+extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+				 struct scsi_sense_hdr *sshdr);
+
+#endif /* _SCSI_COMMON_H_ */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a4c9336..ae84b22 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -413,8 +413,6 @@ extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *, enum scsi_device_state);
 extern void scsi_remove_target(struct device *);
-extern void int_to_scsilun(u64, struct scsi_lun *);
-extern u64 scsilun_to_int(struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 5a4bb5b..4942710 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -7,43 +7,12 @@
 struct scsi_device;
 struct Scsi_Host;
 
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
-
 extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
 			       struct list_head *done_q);
 extern void scsi_eh_flush_done_q(struct list_head *done_q);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
-extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
-				 struct scsi_sense_hdr *sshdr);
 extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 					 struct scsi_sense_hdr *sshdr);
 
-- 
2.1.4
