From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move renamining defintions from drivers/scsi/scsi.h to include/scsi
Date: Fri, 13 Feb 2004 21:31:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213203131.GB5066@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:62917 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267192AbUBMUbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 15:31:38 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Simple move for a bunch of defintions so driver can finally stop doing
the -Idriver/scsi mess.  I'd like to get it out ASAP because the distros
are going to branch their first 2.6 releases soon and the vendors will
want to support those basically forever.


--- 1.91/drivers/scsi/scsi.h	Sat Sep 20 13:50:50 2003
+++ edited/drivers/scsi/scsi.h	Wed Feb 11 07:50:03 2004
@@ -34,51 +34,11 @@
 #define FALSE 0
 #endif
 
-#define MAX_SCSI_DEVICE_CODE 14
-extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
-
 #ifdef DEBUG
 #define SCSI_TIMEOUT (5*HZ)
 #else
 #define SCSI_TIMEOUT (2*HZ)
 #endif
-
-/*
- *  Use these to separate status msg and our bytes
- *
- *  These are set by:
- *
- *      status byte = set from target device
- *      msg_byte    = return status from host adapter itself.
- *      host_byte   = set by low-level driver to indicate status.
- *      driver_byte = set by mid-level.
- */
-#define status_byte(result) (((result) >> 1) & 0x1f)
-#define msg_byte(result)    (((result) >> 8) & 0xff)
-#define host_byte(result)   (((result) >> 16) & 0xff)
-#define driver_byte(result) (((result) >> 24) & 0xff)
-#define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
-
-#define sense_class(sense)  (((sense) >> 4) & 0x7)
-#define sense_error(sense)  ((sense) & 0xf)
-#define sense_valid(sense)  ((sense) & 0x80);
-
-
-#define IDENTIFY_BASE       0x80
-#define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
-		     ((can_disconnect) ?  0x40 : 0) |\
-		     ((lun) & 0x07))
-
-/*
- *  SCSI command sets
- */
-
-#define SCSI_UNKNOWN    0
-#define SCSI_1          1
-#define SCSI_1_CCS      2
-#define SCSI_2          3
-#define SCSI_3          4
-
 
 struct Scsi_Host;
 struct scsi_cmnd;
===== include/scsi/scsi.h 1.16 vs edited =====
--- 1.16/include/scsi/scsi.h	Sat Jan 10 20:04:26 2004
+++ edited/include/scsi/scsi.h	Wed Feb 11 07:49:41 2004
@@ -12,13 +12,20 @@
 
 
 /*
- * SCSI command lengths
+ *	SCSI command lengths
  */
 
 extern const unsigned char scsi_command_size[8];
 #define COMMAND_SIZE(opcode) scsi_command_size[((opcode) >> 5) & 7]
 
 /*
+ *	SCSI device types
+ */
+
+#define MAX_SCSI_DEVICE_CODE 14
+extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
+
+/*
  *      SCSI opcodes
  */
 
@@ -310,6 +317,42 @@
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
+
+/*
+ *  Use these to separate status msg and our bytes
+ *
+ *  These are set by:
+ *
+ *      status byte = set from target device
+ *      msg_byte    = return status from host adapter itself.
+ *      host_byte   = set by low-level driver to indicate status.
+ *      driver_byte = set by mid-level.
+ */
+#define status_byte(result) (((result) >> 1) & 0x1f)
+#define msg_byte(result)    (((result) >> 8) & 0xff)
+#define host_byte(result)   (((result) >> 16) & 0xff)
+#define driver_byte(result) (((result) >> 24) & 0xff)
+#define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
+
+#define sense_class(sense)  (((sense) >> 4) & 0x7)
+#define sense_error(sense)  ((sense) & 0xf)
+#define sense_valid(sense)  ((sense) & 0x80);
+
+
+#define IDENTIFY_BASE       0x80
+#define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
+		     ((can_disconnect) ?  0x40 : 0) |\
+		     ((lun) & 0x07))
+
+/*
+ *  SCSI command sets
+ */
+
+#define SCSI_UNKNOWN    0
+#define SCSI_1          1
+#define SCSI_1_CCS      2
+#define SCSI_2          3
+#define SCSI_3          4
 
 
 /*
