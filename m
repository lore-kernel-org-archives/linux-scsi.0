From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/2] Move USB Storage definitions to their own header file
Date: Tue, 28 Sep 2010 06:14:55 -0400
Message-ID: <1285668896-6356-1-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61753 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760344Ab0I1KPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 06:15:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@kroah.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew.r.wilcox@intel.com>

The libusual header file is hard to use from code that isn't part
of libusual.  As the comment suggests, these definitions are moved to
their own header file, paralleling other USB classes.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/usb/storage.h |   44 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb_usual.h   |   37 +-----------------------------------
 2 files changed, 45 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/usb/storage.h

diff --git a/include/linux/usb/storage.h b/include/linux/usb/storage.h
new file mode 100644
index 0000000..218caf0
--- /dev/null
+++ b/include/linux/usb/storage.h
@@ -0,0 +1,44 @@
+/*
+ * linux/usb/storage.h
+ *
+ * Copyright Matthew Wilcox for Intel Corp, 2010
+ *
+ * This file contains definitions taken from the
+ * USB Mass Storage Class Specification Overview
+ *
+ * Distributed under the terms of the GNU GPL, version two.
+ */
+
+/* Storage subclass codes */
+
+#define US_SC_RBC	0x01		/* Typically, flash devices */
+#define US_SC_8020	0x02		/* CD-ROM */
+#define US_SC_QIC	0x03		/* QIC-157 Tapes */
+#define US_SC_UFI	0x04		/* Floppy */
+#define US_SC_8070	0x05		/* Removable media */
+#define US_SC_SCSI	0x06		/* Transparent */
+#define US_SC_LOCKABLE	0x07		/* Password-protected */
+
+#define US_SC_ISD200    0xf0		/* ISD200 ATA */
+#define US_SC_CYP_ATACB 0xf1		/* Cypress ATACB */
+#define US_SC_DEVICE	0xff		/* Use device's value */
+
+/* Storage protocol codes */
+
+#define US_PR_CBI	0x00		/* Control/Bulk/Interrupt */
+#define US_PR_CB	0x01		/* Control/Bulk w/o interrupt */
+#define US_PR_BULK	0x50		/* bulk only */
+#define US_PR_UAS	0x62		/* USB Attached SCSI */
+
+#define US_PR_USBAT	0x80		/* SCM-ATAPI bridge */
+#define US_PR_EUSB_SDDR09	0x81	/* SCM-SCSI bridge for SDDR-09 */
+#define US_PR_SDDR55	0x82		/* SDDR-55 (made up) */
+#define US_PR_DPCM_USB  0xf0		/* Combination CB/SDDR09 */
+#define US_PR_FREECOM   0xf1		/* Freecom */
+#define US_PR_DATAFAB   0xf2		/* Datafab chipsets */
+#define US_PR_JUMPSHOT  0xf3		/* Lexar Jumpshot */
+#define US_PR_ALAUDA    0xf4		/* Alauda chipsets */
+#define US_PR_KARMA     0xf5		/* Rio Karma */
+
+#define US_PR_DEVICE	0xff		/* Use device's value */
+
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index a4b947e..f091dc6 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -74,42 +74,7 @@ enum { US_DO_ALL_FLAGS };
 #define USB_US_TYPE(flags) 		(((flags) >> 24) & 0xFF)
 #define USB_US_ORIG_FLAGS(flags)	((flags) & 0x00FFFFFF)
 
-/*
- * This is probably not the best place to keep these constants, conceptually.
- * But it's the only header included into all places which need them.
- */
-
-/* Sub Classes */
-
-#define US_SC_RBC	0x01		/* Typically, flash devices */
-#define US_SC_8020	0x02		/* CD-ROM */
-#define US_SC_QIC	0x03		/* QIC-157 Tapes */
-#define US_SC_UFI	0x04		/* Floppy */
-#define US_SC_8070	0x05		/* Removable media */
-#define US_SC_SCSI	0x06		/* Transparent */
-#define US_SC_LOCKABLE	0x07		/* Password-protected */
-
-#define US_SC_ISD200    0xf0		/* ISD200 ATA */
-#define US_SC_CYP_ATACB 0xf1		/* Cypress ATACB */
-#define US_SC_DEVICE	0xff		/* Use device's value */
-
-/* Protocols */
-
-#define US_PR_CBI	0x00		/* Control/Bulk/Interrupt */
-#define US_PR_CB	0x01		/* Control/Bulk w/o interrupt */
-#define US_PR_BULK	0x50		/* bulk only */
-
-#define US_PR_USBAT	0x80		/* SCM-ATAPI bridge */
-#define US_PR_EUSB_SDDR09	0x81	/* SCM-SCSI bridge for SDDR-09 */
-#define US_PR_SDDR55	0x82		/* SDDR-55 (made up) */
-#define US_PR_DPCM_USB  0xf0		/* Combination CB/SDDR09 */
-#define US_PR_FREECOM   0xf1		/* Freecom */
-#define US_PR_DATAFAB   0xf2		/* Datafab chipsets */
-#define US_PR_JUMPSHOT  0xf3		/* Lexar Jumpshot */
-#define US_PR_ALAUDA    0xf4		/* Alauda chipsets */
-#define US_PR_KARMA     0xf5		/* Rio Karma */
-
-#define US_PR_DEVICE	0xff		/* Use device's value */
+#include <linux/usb/storage.h>
 
 /*
  */
-- 
1.7.1

