From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move some constants around
Date: Sat, 20 Sep 2003 15:33:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920133335.GA23251@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:62849 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261883AbTITNdi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 09:33:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

We should try to keep all constants in include/scsi/scsi.h instead
of drivers/scsi/scsi.h.  Also tidy up include/scsi/scsi.h a bit.


--- 1.90/drivers/scsi/scsi.h	Sat Sep 20 11:11:42 2003
+++ edited/drivers/scsi/scsi.h	Sat Sep 20 11:50:50 2003
@@ -63,57 +63,12 @@
 #define sense_error(sense)  ((sense) & 0xf)
 #define sense_valid(sense)  ((sense) & 0x80);
 
-#define NEEDS_RETRY     0x2001
-#define SUCCESS         0x2002
-#define FAILED          0x2003
-#define QUEUED          0x2004
-#define SOFT_ERROR      0x2005
-#define ADD_TO_MLQUEUE  0x2006
 
 #define IDENTIFY_BASE       0x80
 #define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
 		     ((can_disconnect) ?  0x40 : 0) |\
 		     ((lun) & 0x07))
 
-/* host byte codes */
-#define DID_OK          0x00	/* NO error                                */
-#define DID_NO_CONNECT  0x01	/* Couldn't connect before timeout period  */
-#define DID_BUS_BUSY    0x02	/* BUS stayed busy through time out period */
-#define DID_TIME_OUT    0x03	/* TIMED OUT for other reason              */
-#define DID_BAD_TARGET  0x04	/* BAD target.                             */
-#define DID_ABORT       0x05	/* Told to abort for some other reason     */
-#define DID_PARITY      0x06	/* Parity error                            */
-#define DID_ERROR       0x07	/* Internal error                          */
-#define DID_RESET       0x08	/* Reset by somebody.                      */
-#define DID_BAD_INTR    0x09	/* Got an interrupt we weren't expecting.  */
-#define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer            */
-#define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry  */
-#define DRIVER_OK       0x00	/* Driver status                           */
-
-/*
- *  These indicate the error that occurred, and what is available.
- */
-
-#define DRIVER_BUSY         0x01
-#define DRIVER_SOFT         0x02
-#define DRIVER_MEDIA        0x03
-#define DRIVER_ERROR        0x04
-
-#define DRIVER_INVALID      0x05
-#define DRIVER_TIMEOUT      0x06
-#define DRIVER_HARD         0x07
-#define DRIVER_SENSE	    0x08
-
-#define SUGGEST_RETRY       0x10
-#define SUGGEST_ABORT       0x20
-#define SUGGEST_REMAP       0x30
-#define SUGGEST_DIE         0x40
-#define SUGGEST_SENSE       0x80
-#define SUGGEST_IS_OK       0xff
-
-#define DRIVER_MASK         0x0f
-#define SUGGEST_MASK        0xf0
-
 /*
  *  SCSI command sets
  */
@@ -145,13 +100,6 @@
 extern int print_msg(const unsigned char *);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
-
-/*
- * Definitions and prototypes used for scsi mid-level queue.
- */
-#define SCSI_MLQUEUE_HOST_BUSY   0x1055
-#define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
-#define SCSI_MLQUEUE_EH_RETRY    0x1057
 
 /*
  * Legacy dma direction interfaces.
--- 1.13/include/scsi/scsi.h	Mon Aug 18 04:41:43 2003
+++ edited/include/scsi/scsi.h	Sat Sep 20 11:50:46 2003
@@ -1,22 +1,15 @@
-#ifndef _LINUX_SCSI_H
-#define _LINUX_SCSI_H
-
 /*
  * This header file contains public constants and structures used by
  * the scsi code for linux.
+ *
+ * For documentation on the OPCODES, MESSAGES, and SENSE values,
+ * please consult the SCSI standard.
  */
+#ifndef _SCSI_SCSI_H
+#define _SCSI_SCSI_H
 
 #include <linux/types.h>
 
-/*
-    $Header: /usr/src/linux/include/linux/RCS/scsi.h,v 1.3 1993/09/24 12:20:33 drew Exp $
-
-    For documentation on the OPCODES, MESSAGES, and SENSE values,
-    please consult the SCSI standard.
-
-*/
-
-#include <linux/types.h> 
 
 /*
  * SCSI command lengths
@@ -133,19 +126,17 @@
  */
 static inline int scsi_status_is_good(int status)
 {
-	/* mask out the relevant bits
-	 *
+	/*
 	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
 	 * significant in SCSI-3.  For now, we follow the SCSI-2
-	 * behaviour and ignore reserved bits. */
-	
+	 * behaviour and ignore reserved bits.
+	 */
 	status &= 0xfe;
-
-	return ((status == SAM_STAT_GOOD)
-		|| (status == SAM_STAT_INTERMEDIATE)
-		|| (status == SAM_STAT_INTERMEDIATE_CONDITION_MET)
+	return ((status == SAM_STAT_GOOD) ||
+		(status == SAM_STAT_INTERMEDIATE) ||
+		(status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
 		/* FIXME: this is obsolete in SAM-3 */
-		|| (status == SAM_STAT_COMMAND_TERMINATED));
+		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
 /*
@@ -206,12 +197,9 @@
 
 /*
  * standard mode-select header prepended to all mode-select commands
- *
- * moved here from cdrom.h -- kraxel
  */
 
-struct ccs_modesel_head
-{
+struct ccs_modesel_head {
 	u8 _r1;			/* reserved */
 	u8 medium;		/* device-specific medium type */
 	u8 _r2;			/* reserved */
@@ -229,9 +217,9 @@
 /*
  * ScsiLun: 8 byte LUN.
  */
-typedef struct scsi_lun {
+struct scsi_lun {
 	u8 scsi_lun[8];
-} ScsiLun;
+};
 
 /*
  *  MESSAGE CODES
@@ -263,25 +251,84 @@
 #define ORDERED_QUEUE_TAG   0x22
 
 /*
- * Here are some scsi specific ioctl commands which are sometimes useful.
+ * Host byte codes
+ */
+
+#define DID_OK          0x00	/* NO error                                */
+#define DID_NO_CONNECT  0x01	/* Couldn't connect before timeout period  */
+#define DID_BUS_BUSY    0x02	/* BUS stayed busy through time out period */
+#define DID_TIME_OUT    0x03	/* TIMED OUT for other reason              */
+#define DID_BAD_TARGET  0x04	/* BAD target.                             */
+#define DID_ABORT       0x05	/* Told to abort for some other reason     */
+#define DID_PARITY      0x06	/* Parity error                            */
+#define DID_ERROR       0x07	/* Internal error                          */
+#define DID_RESET       0x08	/* Reset by somebody.                      */
+#define DID_BAD_INTR    0x09	/* Got an interrupt we weren't expecting.  */
+#define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer            */
+#define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry  */
+#define DRIVER_OK       0x00	/* Driver status                           */
+
+/*
+ *  These indicate the error that occurred, and what is available.
  */
-/* These are a few other constants  only used by scsi  devices */
-/* Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395 */
 
-#define SCSI_IOCTL_GET_IDLUN 0x5382	/* conflicts with CDROMAUDIOBUFSIZ */
+#define DRIVER_BUSY         0x01
+#define DRIVER_SOFT         0x02
+#define DRIVER_MEDIA        0x03
+#define DRIVER_ERROR        0x04
+
+#define DRIVER_INVALID      0x05
+#define DRIVER_TIMEOUT      0x06
+#define DRIVER_HARD         0x07
+#define DRIVER_SENSE	    0x08
+
+#define SUGGEST_RETRY       0x10
+#define SUGGEST_ABORT       0x20
+#define SUGGEST_REMAP       0x30
+#define SUGGEST_DIE         0x40
+#define SUGGEST_SENSE       0x80
+#define SUGGEST_IS_OK       0xff
+
+#define DRIVER_MASK         0x0f
+#define SUGGEST_MASK        0xf0
+
+/*
+ * Internal return values.
+ */
+
+#define NEEDS_RETRY     0x2001
+#define SUCCESS         0x2002
+#define FAILED          0x2003
+#define QUEUED          0x2004
+#define SOFT_ERROR      0x2005
+#define ADD_TO_MLQUEUE  0x2006
+
+/*
+ * Midlevel queue return values.
+ */
+#define SCSI_MLQUEUE_HOST_BUSY   0x1055
+#define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
+#define SCSI_MLQUEUE_EH_RETRY    0x1057
+
+
+/*
+ * Here are some scsi specific ioctl commands which are sometimes useful.
+ *
+ * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ */
 
-/* Used to turn on and off tagged queuing for scsi devices */
+/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
+#define SCSI_IOCTL_GET_IDLUN		0x5382
 
-#define SCSI_IOCTL_TAGGED_ENABLE 0x5383
-#define SCSI_IOCTL_TAGGED_DISABLE 0x5384
+/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
 
 /* Used to obtain the host number of a device. */
-#define SCSI_IOCTL_PROBE_HOST 0x5385
+#define SCSI_IOCTL_PROBE_HOST		0x5385
 
-/* Used to get the bus number for a device */
-#define SCSI_IOCTL_GET_BUS_NUMBER 0x5386
+/* Used to obtain the bus number for a device */
+#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
 
-/* Used to get the PCI location of a device */
-#define SCSI_IOCTL_GET_PCI 0x5387
+/* Used to obtain the PCI location of a device */
+#define SCSI_IOCTL_GET_PCI		0x5387
 
-#endif
+#endif /* _SCSI_SCSI_H */
