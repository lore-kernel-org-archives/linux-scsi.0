From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] clean up SCSI_TIMEOUT usage
Date: Sun, 6 Jun 2004 14:43:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606124340.GB30931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:12234 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263457AbUFFMnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:43:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - qlogicfc.c abuses SCSI_TIEMOUT although it's not part of the scsi
   core, give it it's own ISP_TIMEOUT define
 - avoid redefining timeouts #ifdef DEBUG, that's a cause for heisenbugs
   just waiting to happen
 - now SCSI_TIMEOUT is private to scsi_scan.c, move it there


--- 1.43/drivers/scsi/qlogicfc.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/qlogicfc.c	2004-06-06 13:17:21 +02:00
@@ -100,6 +100,7 @@
 
 #define DEFAULT_LOOP_COUNT	1000000000
 
+#define ISP_TIMEOUT (2*HZ)
 /* End Configuration section ************************************************ */
 
 #include <linux/module.h>
@@ -1305,7 +1306,7 @@
 		cmd->control_flags = cpu_to_le16(CFLAG_READ);
 
 	if (Cmnd->device->tagged_supported) {
-		if ((jiffies - hostdata->tag_ages[Cmnd->device->id]) > (2 * SCSI_TIMEOUT)) {
+		if ((jiffies - hostdata->tag_ages[Cmnd->device->id]) > (2 * ISP_TIMEOUT)) {
 			cmd->control_flags |= cpu_to_le16(CFLAG_ORDERED_TAG);
 			hostdata->tag_ages[Cmnd->device->id] = jiffies;
 		} else
===== drivers/scsi/scsi.h 1.93 vs edited =====
--- 1.93/drivers/scsi/scsi.h	2004-05-19 19:46:14 +02:00
+++ edited/drivers/scsi/scsi.h	2004-06-06 13:17:31 +02:00
@@ -40,12 +40,6 @@
 #define FALSE 0
 #endif
 
-#ifdef DEBUG
-#define SCSI_TIMEOUT (5*HZ)
-#else
-#define SCSI_TIMEOUT (2*HZ)
-#endif
-
 struct Scsi_Host;
 struct scsi_cmnd;
 struct scsi_device;
===== drivers/scsi/scsi_error.c 1.75 vs edited =====
--- 1.75/drivers/scsi/scsi_error.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/scsi_error.c	2004-06-06 13:19:15 +02:00
@@ -31,20 +31,15 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-#ifdef DEBUG
-#define SENSE_TIMEOUT SCSI_TIMEOUT
-#else
-#define SENSE_TIMEOUT (10*HZ)
-#endif
-
-#define START_UNIT_TIMEOUT (30*HZ)
+#define SENSE_TIMEOUT		(10*HZ)
+#define START_UNIT_TIMEOUT	(30*HZ)
 
 /*
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
  */
-#define BUS_RESET_SETTLE_TIME   10*HZ
-#define HOST_RESET_SETTLE_TIME  10*HZ
+#define BUS_RESET_SETTLE_TIME   (10*HZ)
+#define HOST_RESET_SETTLE_TIME  (10*HZ)
 
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
===== drivers/scsi/scsi_scan.c 1.124 vs edited =====
--- 1.124/drivers/scsi/scsi_scan.c	2004-05-21 17:53:07 +02:00
+++ edited/drivers/scsi/scsi_scan.c	2004-06-06 13:20:50 +02:00
@@ -45,6 +45,11 @@
 	" SCSI scanning, some SCSI devices might not be configured\n"
 
 /*
+ * Default timeout
+ */
+#define SCSI_TIMEOUT (2*HZ)
+
+/*
  * Prefix values for the SCSI id's (stored in driverfs name field)
  */
 #define SCSI_UID_SER_NUM 'S'
