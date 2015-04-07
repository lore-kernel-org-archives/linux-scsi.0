From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 1/4] Split SCSI header files
Date: Tue, 7 Apr 2015 14:33:17 +0200
Message-ID: <5523CE8D.1050904@sandisk.com>
References: <5523CE55.3090401@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:1760
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753142AbbDGMd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 08:33:26 -0400
In-Reply-To: <5523CE55.3090401@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Move the constants that are used by both initiator and target
drivers into the new header file <scsi/scsi_proto.h>. Move the
functions that are used by both subsystems into scsi_common.c/.h.
This change will allow to remove the initiator SCSI header
include directives from most SCSI target source files in a later
patch.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Makefile      |   1 +
 drivers/scsi/scsi.c        |  46 -------
 drivers/scsi/scsi_common.c | 178 +++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  |  64 ----------
 drivers/scsi/scsi_scan.c   |  62 ----------
 include/scsi/scsi.h        | 291 +--------------------------------------------
 include/scsi/scsi_common.h |  64 ++++++++++
 include/scsi/scsi_device.h |   2 -
 include/scsi/scsi_eh.h     |  31 -----
 include/scsi/scsi_proto.h  | 281 +++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 527 insertions(+), 493 deletions(-)
 create mode 100644 drivers/scsi/scsi_common.c
 create mode 100644 include/scsi/scsi_common.h
 create mode 100644 include/scsi/scsi_proto.h

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
index c9c3b57..6322d10 100644
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
index 4cdaffc..b79bbea 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2398,70 +2398,6 @@ out_put_autopm_host:
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
index 9c0a520..202369b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1263,68 +1263,6 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
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
index d0a66aa..e0a3398 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -1,9 +1,6 @@
 /*
  * This header file contains public constants and structures used by
- * the scsi code for linux.
- *
- * For documentation on the OPCODES, MESSAGES, and SENSE values,
- * please consult the SCSI standard.
+ * the SCSI initiator code.
  */
 #ifndef _SCSI_SCSI_H
 #define _SCSI_SCSI_H
@@ -11,6 +8,8 @@
 #include <linux/types.h>
 #include <linux/scatterlist.h>
 #include <linux/kernel.h>
+#include <scsi/scsi_common.h>
+#include <scsi/scsi_proto.h>
 
 struct scsi_cmnd;
 
@@ -49,187 +48,6 @@ enum scsi_timeouts {
  */
 #define SCAN_WILD_CARD	~0
 
-/*
- *      SCSI opcodes
- */
-
-#define TEST_UNIT_READY       0x00
-#define REZERO_UNIT           0x01
-#define REQUEST_SENSE         0x03
-#define FORMAT_UNIT           0x04
-#define READ_BLOCK_LIMITS     0x05
-#define REASSIGN_BLOCKS       0x07
-#define INITIALIZE_ELEMENT_STATUS 0x07
-#define READ_6                0x08
-#define WRITE_6               0x0a
-#define SEEK_6                0x0b
-#define READ_REVERSE          0x0f
-#define WRITE_FILEMARKS       0x10
-#define SPACE                 0x11
-#define INQUIRY               0x12
-#define RECOVER_BUFFERED_DATA 0x14
-#define MODE_SELECT           0x15
-#define RESERVE               0x16
-#define RELEASE               0x17
-#define COPY                  0x18
-#define ERASE                 0x19
-#define MODE_SENSE            0x1a
-#define START_STOP            0x1b
-#define RECEIVE_DIAGNOSTIC    0x1c
-#define SEND_DIAGNOSTIC       0x1d
-#define ALLOW_MEDIUM_REMOVAL  0x1e
-
-#define READ_FORMAT_CAPACITIES 0x23
-#define SET_WINDOW            0x24
-#define READ_CAPACITY         0x25
-#define READ_10               0x28
-#define WRITE_10              0x2a
-#define SEEK_10               0x2b
-#define POSITION_TO_ELEMENT   0x2b
-#define WRITE_VERIFY          0x2e
-#define VERIFY                0x2f
-#define SEARCH_HIGH           0x30
-#define SEARCH_EQUAL          0x31
-#define SEARCH_LOW            0x32
-#define SET_LIMITS            0x33
-#define PRE_FETCH             0x34
-#define READ_POSITION         0x34
-#define SYNCHRONIZE_CACHE     0x35
-#define LOCK_UNLOCK_CACHE     0x36
-#define READ_DEFECT_DATA      0x37
-#define MEDIUM_SCAN           0x38
-#define COMPARE               0x39
-#define COPY_VERIFY           0x3a
-#define WRITE_BUFFER          0x3b
-#define READ_BUFFER           0x3c
-#define UPDATE_BLOCK          0x3d
-#define READ_LONG             0x3e
-#define WRITE_LONG            0x3f
-#define CHANGE_DEFINITION     0x40
-#define WRITE_SAME            0x41
-#define UNMAP		      0x42
-#define READ_TOC              0x43
-#define READ_HEADER           0x44
-#define GET_EVENT_STATUS_NOTIFICATION 0x4a
-#define LOG_SELECT            0x4c
-#define LOG_SENSE             0x4d
-#define XDWRITEREAD_10        0x53
-#define MODE_SELECT_10        0x55
-#define RESERVE_10            0x56
-#define RELEASE_10            0x57
-#define MODE_SENSE_10         0x5a
-#define PERSISTENT_RESERVE_IN 0x5e
-#define PERSISTENT_RESERVE_OUT 0x5f
-#define VARIABLE_LENGTH_CMD   0x7f
-#define REPORT_LUNS           0xa0
-#define SECURITY_PROTOCOL_IN  0xa2
-#define MAINTENANCE_IN        0xa3
-#define MAINTENANCE_OUT       0xa4
-#define MOVE_MEDIUM           0xa5
-#define EXCHANGE_MEDIUM       0xa6
-#define READ_12               0xa8
-#define SERVICE_ACTION_OUT_12 0xa9
-#define WRITE_12              0xaa
-#define READ_MEDIA_SERIAL_NUMBER 0xab /* Obsolete with SPC-2 */
-#define SERVICE_ACTION_IN_12  0xab
-#define WRITE_VERIFY_12       0xae
-#define VERIFY_12	      0xaf
-#define SEARCH_HIGH_12        0xb0
-#define SEARCH_EQUAL_12       0xb1
-#define SEARCH_LOW_12         0xb2
-#define SECURITY_PROTOCOL_OUT 0xb5
-#define READ_ELEMENT_STATUS   0xb8
-#define SEND_VOLUME_TAG       0xb6
-#define WRITE_LONG_2          0xea
-#define EXTENDED_COPY         0x83
-#define RECEIVE_COPY_RESULTS  0x84
-#define ACCESS_CONTROL_IN     0x86
-#define ACCESS_CONTROL_OUT    0x87
-#define READ_16               0x88
-#define COMPARE_AND_WRITE     0x89
-#define WRITE_16              0x8a
-#define READ_ATTRIBUTE        0x8c
-#define WRITE_ATTRIBUTE	      0x8d
-#define VERIFY_16	      0x8f
-#define SYNCHRONIZE_CACHE_16  0x91
-#define WRITE_SAME_16	      0x93
-#define SERVICE_ACTION_BIDIRECTIONAL 0x9d
-#define SERVICE_ACTION_IN_16  0x9e
-#define SERVICE_ACTION_OUT_16 0x9f
-/* values for service action in */
-#define	SAI_READ_CAPACITY_16  0x10
-#define SAI_GET_LBA_STATUS    0x12
-#define SAI_REPORT_REFERRALS  0x13
-/* values for VARIABLE_LENGTH_CMD service action codes
- * see spc4r17 Section D.3.5, table D.7 and D.8 */
-#define VLC_SA_RECEIVE_CREDENTIAL 0x1800
-/* values for maintenance in */
-#define MI_REPORT_IDENTIFYING_INFORMATION 0x05
-#define MI_REPORT_TARGET_PGS  0x0a
-#define MI_REPORT_ALIASES     0x0b
-#define MI_REPORT_SUPPORTED_OPERATION_CODES 0x0c
-#define MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS 0x0d
-#define MI_REPORT_PRIORITY    0x0e
-#define MI_REPORT_TIMESTAMP   0x0f
-#define MI_MANAGEMENT_PROTOCOL_IN 0x10
-/* value for MI_REPORT_TARGET_PGS ext header */
-#define MI_EXT_HDR_PARAM_FMT  0x20
-/* values for maintenance out */
-#define MO_SET_IDENTIFYING_INFORMATION 0x06
-#define MO_SET_TARGET_PGS     0x0a
-#define MO_CHANGE_ALIASES     0x0b
-#define MO_SET_PRIORITY       0x0e
-#define MO_SET_TIMESTAMP      0x0f
-#define MO_MANAGEMENT_PROTOCOL_OUT 0x10
-/* values for variable length command */
-#define XDREAD_32	      0x03
-#define XDWRITE_32	      0x04
-#define XPWRITE_32	      0x06
-#define XDWRITEREAD_32	      0x07
-#define READ_32		      0x09
-#define VERIFY_32	      0x0a
-#define WRITE_32	      0x0b
-#define WRITE_SAME_32	      0x0d
-
-/* Values for T10/04-262r7 */
-#define	ATA_16		      0x85	/* 16-byte pass-thru */
-#define	ATA_12		      0xa1	/* 12-byte pass-thru */
-
-/* Vendor specific CDBs start here */
-#define VENDOR_SPECIFIC_CDB 0xc0
-
-/*
- *	SCSI command lengths
- */
-
-#define SCSI_MAX_VARLEN_CDB_SIZE 260
-
-/* defined in T10 SCSI Primary Commands-2 (SPC2) */
-struct scsi_varlen_cdb_hdr {
-	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	__u8 control;
-	__u8 misc[5];
-	__u8 additional_cdb_length;         /* total cdb length - 8 */
-	__be16 service_action;
-	/* service specific data follows */
-};
-
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
 
@@ -240,22 +58,6 @@ extern void
 scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
 #endif
 
-/*
- *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
- *  T10/1561-D Revision 4 Draft dated 7th November 2002.
- */
-#define SAM_STAT_GOOD            0x00
-#define SAM_STAT_CHECK_CONDITION 0x02
-#define SAM_STAT_CONDITION_MET   0x04
-#define SAM_STAT_BUSY            0x08
-#define SAM_STAT_INTERMEDIATE    0x10
-#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
-#define SAM_STAT_RESERVATION_CONFLICT 0x18
-#define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
-#define SAM_STAT_TASK_SET_FULL   0x28
-#define SAM_STAT_ACA_ACTIVE      0x30
-#define SAM_STAT_TASK_ABORTED    0x40
-
 /** scsi_status_is_good - check the status return.
  *
  * @status: the status passed up from the driver (including host and
@@ -279,86 +81,6 @@ static inline int scsi_status_is_good(int status)
 		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
-/*
- *  Status codes. These are deprecated as they are shifted 1 bit right
- *  from those found in the SCSI standards. This causes confusion for
- *  applications that are ported to several OSes. Prefer SAM Status codes
- *  above.
- */
-
-#define GOOD                 0x00
-#define CHECK_CONDITION      0x01
-#define CONDITION_GOOD       0x02
-#define BUSY                 0x04
-#define INTERMEDIATE_GOOD    0x08
-#define INTERMEDIATE_C_GOOD  0x0a
-#define RESERVATION_CONFLICT 0x0c
-#define COMMAND_TERMINATED   0x11
-#define QUEUE_FULL           0x14
-#define ACA_ACTIVE           0x18
-#define TASK_ABORTED         0x20
-
-#define STATUS_MASK          0xfe
-
-/*
- *  SENSE KEYS
- */
-
-#define NO_SENSE            0x00
-#define RECOVERED_ERROR     0x01
-#define NOT_READY           0x02
-#define MEDIUM_ERROR        0x03
-#define HARDWARE_ERROR      0x04
-#define ILLEGAL_REQUEST     0x05
-#define UNIT_ATTENTION      0x06
-#define DATA_PROTECT        0x07
-#define BLANK_CHECK         0x08
-#define COPY_ABORTED        0x0a
-#define ABORTED_COMMAND     0x0b
-#define VOLUME_OVERFLOW     0x0d
-#define MISCOMPARE          0x0e
-
-
-/*
- *  DEVICE TYPES
- *  Please keep them in 0x%02x format for $MODALIAS to work
- */
-
-#define TYPE_DISK           0x00
-#define TYPE_TAPE           0x01
-#define TYPE_PRINTER        0x02
-#define TYPE_PROCESSOR      0x03    /* HP scanners use this */
-#define TYPE_WORM           0x04    /* Treated as ROM by our system */
-#define TYPE_ROM            0x05
-#define TYPE_SCANNER        0x06
-#define TYPE_MOD            0x07    /* Magneto-optical disk - 
-				     * - treated as TYPE_DISK */
-#define TYPE_MEDIUM_CHANGER 0x08
-#define TYPE_COMM           0x09    /* Communications device */
-#define TYPE_RAID           0x0c
-#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
-#define TYPE_RBC	    0x0e
-#define TYPE_OSD            0x11
-#define TYPE_ZBC            0x14
-#define TYPE_WLUN           0x1e    /* well-known logical unit */
-#define TYPE_NO_LUN         0x7f
-
-/* SCSI protocols; these are taken from SPC-3 section 7.5 */
-enum scsi_protocol {
-	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
-	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
-	SCSI_PROTOCOL_SSA = 2,	/* Serial Storage Architecture - Obsolete */
-	SCSI_PROTOCOL_SBP = 3,	/* firewire */
-	SCSI_PROTOCOL_SRP = 4,	/* Infiniband RDMA */
-	SCSI_PROTOCOL_ISCSI = 5,
-	SCSI_PROTOCOL_SAS = 6,
-	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
-	SCSI_PROTOCOL_ATA = 8,
-	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
-};
-
-/* Returns a human-readable name for the device */
-extern const char * scsi_device_type(unsigned type);
 
 /*
  * standard mode-select header prepended to all mode-select commands
@@ -380,13 +102,6 @@ struct ccs_modesel_head {
 };
 
 /*
- * ScsiLun: 8 byte LUN.
- */
-struct scsi_lun {
-	__u8 scsi_lun[8];
-};
-
-/*
  * The Well Known LUNS (SAM-3) in our int representation of a LUN
  */
 #define SCSI_W_LUN_BASE 0xc100
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
index 1e1421b..8d1d7fa 100644
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
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
new file mode 100644
index 0000000..a9fbf1b
--- /dev/null
+++ b/include/scsi/scsi_proto.h
@@ -0,0 +1,281 @@
+/*
+ * This header file contains public constants and structures used by
+ * both the SCSI initiator and the SCSI target code.
+ *
+ * For documentation on the OPCODES, MESSAGES, and SENSE values,
+ * please consult the SCSI standard.
+ */
+
+#ifndef _SCSI_PROTO_H_
+#define _SCSI_PROTO_H_
+
+#include <linux/types.h>
+
+/*
+ *      SCSI opcodes
+ */
+
+#define TEST_UNIT_READY       0x00
+#define REZERO_UNIT           0x01
+#define REQUEST_SENSE         0x03
+#define FORMAT_UNIT           0x04
+#define READ_BLOCK_LIMITS     0x05
+#define REASSIGN_BLOCKS       0x07
+#define INITIALIZE_ELEMENT_STATUS 0x07
+#define READ_6                0x08
+#define WRITE_6               0x0a
+#define SEEK_6                0x0b
+#define READ_REVERSE          0x0f
+#define WRITE_FILEMARKS       0x10
+#define SPACE                 0x11
+#define INQUIRY               0x12
+#define RECOVER_BUFFERED_DATA 0x14
+#define MODE_SELECT           0x15
+#define RESERVE               0x16
+#define RELEASE               0x17
+#define COPY                  0x18
+#define ERASE                 0x19
+#define MODE_SENSE            0x1a
+#define START_STOP            0x1b
+#define RECEIVE_DIAGNOSTIC    0x1c
+#define SEND_DIAGNOSTIC       0x1d
+#define ALLOW_MEDIUM_REMOVAL  0x1e
+
+#define READ_FORMAT_CAPACITIES 0x23
+#define SET_WINDOW            0x24
+#define READ_CAPACITY         0x25
+#define READ_10               0x28
+#define WRITE_10              0x2a
+#define SEEK_10               0x2b
+#define POSITION_TO_ELEMENT   0x2b
+#define WRITE_VERIFY          0x2e
+#define VERIFY                0x2f
+#define SEARCH_HIGH           0x30
+#define SEARCH_EQUAL          0x31
+#define SEARCH_LOW            0x32
+#define SET_LIMITS            0x33
+#define PRE_FETCH             0x34
+#define READ_POSITION         0x34
+#define SYNCHRONIZE_CACHE     0x35
+#define LOCK_UNLOCK_CACHE     0x36
+#define READ_DEFECT_DATA      0x37
+#define MEDIUM_SCAN           0x38
+#define COMPARE               0x39
+#define COPY_VERIFY           0x3a
+#define WRITE_BUFFER          0x3b
+#define READ_BUFFER           0x3c
+#define UPDATE_BLOCK          0x3d
+#define READ_LONG             0x3e
+#define WRITE_LONG            0x3f
+#define CHANGE_DEFINITION     0x40
+#define WRITE_SAME            0x41
+#define UNMAP		      0x42
+#define READ_TOC              0x43
+#define READ_HEADER           0x44
+#define GET_EVENT_STATUS_NOTIFICATION 0x4a
+#define LOG_SELECT            0x4c
+#define LOG_SENSE             0x4d
+#define XDWRITEREAD_10        0x53
+#define MODE_SELECT_10        0x55
+#define RESERVE_10            0x56
+#define RELEASE_10            0x57
+#define MODE_SENSE_10         0x5a
+#define PERSISTENT_RESERVE_IN 0x5e
+#define PERSISTENT_RESERVE_OUT 0x5f
+#define VARIABLE_LENGTH_CMD   0x7f
+#define REPORT_LUNS           0xa0
+#define SECURITY_PROTOCOL_IN  0xa2
+#define MAINTENANCE_IN        0xa3
+#define MAINTENANCE_OUT       0xa4
+#define MOVE_MEDIUM           0xa5
+#define EXCHANGE_MEDIUM       0xa6
+#define READ_12               0xa8
+#define SERVICE_ACTION_OUT_12 0xa9
+#define WRITE_12              0xaa
+#define READ_MEDIA_SERIAL_NUMBER 0xab /* Obsolete with SPC-2 */
+#define SERVICE_ACTION_IN_12  0xab
+#define WRITE_VERIFY_12       0xae
+#define VERIFY_12	      0xaf
+#define SEARCH_HIGH_12        0xb0
+#define SEARCH_EQUAL_12       0xb1
+#define SEARCH_LOW_12         0xb2
+#define SECURITY_PROTOCOL_OUT 0xb5
+#define READ_ELEMENT_STATUS   0xb8
+#define SEND_VOLUME_TAG       0xb6
+#define WRITE_LONG_2          0xea
+#define EXTENDED_COPY         0x83
+#define RECEIVE_COPY_RESULTS  0x84
+#define ACCESS_CONTROL_IN     0x86
+#define ACCESS_CONTROL_OUT    0x87
+#define READ_16               0x88
+#define COMPARE_AND_WRITE     0x89
+#define WRITE_16              0x8a
+#define READ_ATTRIBUTE        0x8c
+#define WRITE_ATTRIBUTE	      0x8d
+#define VERIFY_16	      0x8f
+#define SYNCHRONIZE_CACHE_16  0x91
+#define WRITE_SAME_16	      0x93
+#define SERVICE_ACTION_BIDIRECTIONAL 0x9d
+#define SERVICE_ACTION_IN_16  0x9e
+#define SERVICE_ACTION_OUT_16 0x9f
+/* values for service action in */
+#define	SAI_READ_CAPACITY_16  0x10
+#define SAI_GET_LBA_STATUS    0x12
+#define SAI_REPORT_REFERRALS  0x13
+/* values for VARIABLE_LENGTH_CMD service action codes
+ * see spc4r17 Section D.3.5, table D.7 and D.8 */
+#define VLC_SA_RECEIVE_CREDENTIAL 0x1800
+/* values for maintenance in */
+#define MI_REPORT_IDENTIFYING_INFORMATION 0x05
+#define MI_REPORT_TARGET_PGS  0x0a
+#define MI_REPORT_ALIASES     0x0b
+#define MI_REPORT_SUPPORTED_OPERATION_CODES 0x0c
+#define MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS 0x0d
+#define MI_REPORT_PRIORITY    0x0e
+#define MI_REPORT_TIMESTAMP   0x0f
+#define MI_MANAGEMENT_PROTOCOL_IN 0x10
+/* value for MI_REPORT_TARGET_PGS ext header */
+#define MI_EXT_HDR_PARAM_FMT  0x20
+/* values for maintenance out */
+#define MO_SET_IDENTIFYING_INFORMATION 0x06
+#define MO_SET_TARGET_PGS     0x0a
+#define MO_CHANGE_ALIASES     0x0b
+#define MO_SET_PRIORITY       0x0e
+#define MO_SET_TIMESTAMP      0x0f
+#define MO_MANAGEMENT_PROTOCOL_OUT 0x10
+/* values for variable length command */
+#define XDREAD_32	      0x03
+#define XDWRITE_32	      0x04
+#define XPWRITE_32	      0x06
+#define XDWRITEREAD_32	      0x07
+#define READ_32		      0x09
+#define VERIFY_32	      0x0a
+#define WRITE_32	      0x0b
+#define WRITE_SAME_32	      0x0d
+
+/* Values for T10/04-262r7 */
+#define	ATA_16		      0x85	/* 16-byte pass-thru */
+#define	ATA_12		      0xa1	/* 12-byte pass-thru */
+
+/* Vendor specific CDBs start here */
+#define VENDOR_SPECIFIC_CDB 0xc0
+
+/*
+ *	SCSI command lengths
+ */
+
+#define SCSI_MAX_VARLEN_CDB_SIZE 260
+
+/* defined in T10 SCSI Primary Commands-2 (SPC2) */
+struct scsi_varlen_cdb_hdr {
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
+	__be16 service_action;
+	/* service specific data follows */
+};
+
+/*
+ *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
+ *  T10/1561-D Revision 4 Draft dated 7th November 2002.
+ */
+#define SAM_STAT_GOOD            0x00
+#define SAM_STAT_CHECK_CONDITION 0x02
+#define SAM_STAT_CONDITION_MET   0x04
+#define SAM_STAT_BUSY            0x08
+#define SAM_STAT_INTERMEDIATE    0x10
+#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
+#define SAM_STAT_RESERVATION_CONFLICT 0x18
+#define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
+#define SAM_STAT_TASK_SET_FULL   0x28
+#define SAM_STAT_ACA_ACTIVE      0x30
+#define SAM_STAT_TASK_ABORTED    0x40
+
+/*
+ *  Status codes. These are deprecated as they are shifted 1 bit right
+ *  from those found in the SCSI standards. This causes confusion for
+ *  applications that are ported to several OSes. Prefer SAM Status codes
+ *  above.
+ */
+
+#define GOOD                 0x00
+#define CHECK_CONDITION      0x01
+#define CONDITION_GOOD       0x02
+#define BUSY                 0x04
+#define INTERMEDIATE_GOOD    0x08
+#define INTERMEDIATE_C_GOOD  0x0a
+#define RESERVATION_CONFLICT 0x0c
+#define COMMAND_TERMINATED   0x11
+#define QUEUE_FULL           0x14
+#define ACA_ACTIVE           0x18
+#define TASK_ABORTED         0x20
+
+#define STATUS_MASK          0xfe
+
+/*
+ *  SENSE KEYS
+ */
+
+#define NO_SENSE            0x00
+#define RECOVERED_ERROR     0x01
+#define NOT_READY           0x02
+#define MEDIUM_ERROR        0x03
+#define HARDWARE_ERROR      0x04
+#define ILLEGAL_REQUEST     0x05
+#define UNIT_ATTENTION      0x06
+#define DATA_PROTECT        0x07
+#define BLANK_CHECK         0x08
+#define COPY_ABORTED        0x0a
+#define ABORTED_COMMAND     0x0b
+#define VOLUME_OVERFLOW     0x0d
+#define MISCOMPARE          0x0e
+
+
+/*
+ *  DEVICE TYPES
+ *  Please keep them in 0x%02x format for $MODALIAS to work
+ */
+
+#define TYPE_DISK           0x00
+#define TYPE_TAPE           0x01
+#define TYPE_PRINTER        0x02
+#define TYPE_PROCESSOR      0x03    /* HP scanners use this */
+#define TYPE_WORM           0x04    /* Treated as ROM by our system */
+#define TYPE_ROM            0x05
+#define TYPE_SCANNER        0x06
+#define TYPE_MOD            0x07    /* Magneto-optical disk -
+				     * - treated as TYPE_DISK */
+#define TYPE_MEDIUM_CHANGER 0x08
+#define TYPE_COMM           0x09    /* Communications device */
+#define TYPE_RAID           0x0c
+#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
+#define TYPE_RBC	    0x0e
+#define TYPE_OSD            0x11
+#define TYPE_ZBC            0x14
+#define TYPE_WLUN           0x1e    /* well-known logical unit */
+#define TYPE_NO_LUN         0x7f
+
+/* SCSI protocols; these are taken from SPC-3 section 7.5 */
+enum scsi_protocol {
+	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
+	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
+	SCSI_PROTOCOL_SSA = 2,	/* Serial Storage Architecture - Obsolete */
+	SCSI_PROTOCOL_SBP = 3,	/* firewire */
+	SCSI_PROTOCOL_SRP = 4,	/* Infiniband RDMA */
+	SCSI_PROTOCOL_ISCSI = 5,
+	SCSI_PROTOCOL_SAS = 6,
+	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
+	SCSI_PROTOCOL_ATA = 8,
+	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
+};
+
+/*
+ * ScsiLun: 8 byte LUN.
+ */
+struct scsi_lun {
+	__u8 scsi_lun[8];
+};
+
+
+#endif /* _SCSI_PROTO_H_ */
-- 
2.1.4

