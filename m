From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH for kernel 4.1] Split SCSI header files
Date: Wed, 25 Feb 2015 09:40:17 +0100
Message-ID: <54ED8A71.3050701@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:35872
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750703AbbBYIka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2015 03:40:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Move the constants and functions that are used by both initiator and
target drivers into new header files. This change will allow to modify
the SCSI target code such that the initiator SCSI header files are no
longer included. Note: the SCSI target driver patch is available for
review at https://github.com/bvanassche/linux/commit/092c3cf236ae35a460dead9423fae8f210ee2345.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi.h               | 291 +----------------------------------
 include/scsi/scsi_cmnd.h          |  17 ---
 include/scsi/scsi_device.h        |   2 -
 include/scsi/scsi_lun.h           |  23 +++
 include/scsi/scsi_proto.h         | 311 ++++++++++++++++++++++++++++++++++++++
 include/target/target_core_base.h |   5 +-
 6 files changed, 339 insertions(+), 310 deletions(-)
 create mode 100644 include/scsi/scsi_lun.h
 create mode 100644 include/scsi/scsi_proto.h

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d0a66aa..187ba56 100644
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
+#include <scsi/scsi_lun.h>
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
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9fc1aec..3416b70 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -14,23 +14,6 @@ struct scsi_driver;
 
 #include <scsi/scsi_device.h>
 
-/*
- * MAX_COMMAND_SIZE is:
- * The longest fixed-length SCSI CDB as per the SCSI standard.
- * fixed-length means: commands that their size can be determined
- * by their opcode and the CDB does not carry a length specifier, (unlike
- * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
- * true and the SCSI standard also defines extended commands and
- * vendor specific commands that can be bigger than 16 bytes. The kernel
- * will support these using the same infrastructure used for VARLEN CDB's.
- * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
- * supports without specifying a cmd_len by ULD's
- */
-#define MAX_COMMAND_SIZE 16
-#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
-# error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
-#endif
-
 struct scsi_data_buffer {
 	struct sg_table table;
 	unsigned length;
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
diff --git a/include/scsi/scsi_lun.h b/include/scsi/scsi_lun.h
new file mode 100644
index 0000000..3b6cd47
--- /dev/null
+++ b/include/scsi/scsi_lun.h
@@ -0,0 +1,23 @@
+/*
+ * Linux representation of a SCSI LUN and LUN translation functions.
+ *
+ * See also the section "Logical Unit Number (LUN)" in the SCSI Architecture
+ * Model (SAM) document.
+ */
+
+#ifndef _SCSI_LUN_H_
+#define _SCSI_LUN_H_
+
+#include <linux/types.h>
+
+/*
+ * ScsiLun: 8 byte LUN.
+ */
+struct scsi_lun {
+	__u8 scsi_lun[8];
+};
+
+extern void int_to_scsilun(u64, struct scsi_lun *);
+extern u64 scsilun_to_int(struct scsi_lun *);
+
+#endif /* _SCSI_LUN_H_ */
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
new file mode 100644
index 0000000..934ec6a
--- /dev/null
+++ b/include/scsi/scsi_proto.h
@@ -0,0 +1,311 @@
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
+#include <linux/blkdev.h> /* BLK_MAX_CDB */
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
+/*
+ * MAX_COMMAND_SIZE is:
+ * The longest fixed-length SCSI CDB as per the SCSI standard.
+ * fixed-length means: commands that their size can be determined
+ * by their opcode and the CDB does not carry a length specifier, (unlike
+ * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
+ * true and the SCSI standard also defines extended commands and
+ * vendor specific commands that can be bigger than 16 bytes. The kernel
+ * will support these using the same infrastructure used for VARLEN CDB's.
+ * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
+ * supports without specifying a cmd_len by ULD's
+ */
+#define MAX_COMMAND_SIZE 16
+#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
+# error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
+#endif
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
+/* Returns a human-readable name for the device */
+extern const char *scsi_device_type(unsigned type);
+
+
+#endif /* _SCSI_PROTO_H_ */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 672150b..ce71e7f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -19,9 +19,8 @@
 /*
  * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
  *
- * Note that both include/scsi/scsi_cmnd.h:MAX_COMMAND_SIZE and
- * include/linux/blkdev.h:BLOCK_MAX_CDB as of v2.6.36-rc4 still use
- * 16-byte CDBs by default and require an extra allocation for
+ * Note that both MAX_COMMAND_SIZE and BLOCK_MAX_CDB as of v4.0-rc1 still
+ * use 16-byte CDBs by default and require an extra allocation for
  * 32-byte CDBs to because of legacy issues.
  *
  * Within TCM Core there are no such legacy limitiations, so we go ahead
-- 
2.1.4

