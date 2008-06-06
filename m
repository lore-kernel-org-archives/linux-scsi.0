From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] Move sd.h header file
Date: Fri, 06 Jun 2008 15:24:23 -0400
Message-ID: <yq1mylyl63c.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:15789 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbYFFTZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 15:25:03 -0400
Received: from rgmgw2.us.oracle.com (rgmgw2.us.oracle.com [138.1.186.111])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id m56JOxL3015848
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 14:24:59 -0500
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by rgmgw2.us.oracle.com (Switch-3.2.4/Switch-3.2.4) with ESMTP id m56HeUZY024519
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 13:24:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sd: Move sd.h header file.

Christoph objected to having sd.h in include/scsi since it's internal
to the sd driver.  Move it to drivers/scsi/sd.h.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r fa746907367e drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Fri Jun 06 00:07:11 2008 -0400
+++ b/drivers/scsi/sd.c	Fri Jun 06 15:09:07 2008 -0400
@@ -58,8 +58,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
-#include <scsi/sd.h>
 
+#include "sd.h"
 #include "scsi_logging.h"
 
 MODULE_AUTHOR("Eric Youngdale");
diff -r fa746907367e drivers/scsi/sd.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/scsi/sd.h	Fri Jun 06 15:09:07 2008 -0400
@@ -0,0 +1,57 @@
+#ifndef _SCSI_DISK_H
+#define _SCSI_DISK_H
+
+/*
+ * More than enough for everybody ;)  The huge number of majors
+ * is a leftover from 16bit dev_t days, we don't really need that
+ * much numberspace.
+ */
+#define SD_MAJORS	16
+
+/*
+ * This is limited by the naming scheme enforced in sd_probe,
+ * add another character to it if you really need more disks.
+ */
+#define SD_MAX_DISKS	(((26 * 26) + 26 + 1) * 26)
+
+/*
+ * Time out in seconds for disks and Magneto-opticals (which are slower).
+ */
+#define SD_TIMEOUT		(30 * HZ)
+#define SD_MOD_TIMEOUT		(75 * HZ)
+
+/*
+ * Number of allowed retries
+ */
+#define SD_MAX_RETRIES		5
+#define SD_PASSTHROUGH_RETRIES	1
+
+/*
+ * Size of the initial data buffer for mode and read capacity data
+ */
+#define SD_BUF_SIZE		512
+
+struct scsi_disk {
+	struct scsi_driver *driver;	/* always &sd_template */
+	struct scsi_device *device;
+	struct device	dev;
+	struct gendisk	*disk;
+	unsigned int	openers;	/* protected by BKL for now, yuck */
+	sector_t	capacity;	/* size in 512-byte sectors */
+	u32		index;
+	u8		media_present;
+	u8		write_prot;
+	unsigned	previous_state : 1;
+	unsigned	WCE : 1;	/* state of disk WCE bit */
+	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
+	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+};
+#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
+
+#define sd_printk(prefix, sdsk, fmt, a...)				\
+        (sdsk)->disk ?							\
+	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
+		    (sdsk)->disk->disk_name, ##a) :			\
+	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
+
+#endif /* _SCSI_DISK_H */
diff -r fa746907367e include/scsi/sd.h
--- a/include/scsi/sd.h	Fri Jun 06 00:07:11 2008 -0400
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,57 +0,0 @@
-#ifndef _SCSI_DISK_H
-#define _SCSI_DISK_H
-
-/*
- * More than enough for everybody ;)  The huge number of majors
- * is a leftover from 16bit dev_t days, we don't really need that
- * much numberspace.
- */
-#define SD_MAJORS	16
-
-/*
- * This is limited by the naming scheme enforced in sd_probe,
- * add another character to it if you really need more disks.
- */
-#define SD_MAX_DISKS	(((26 * 26) + 26 + 1) * 26)
-
-/*
- * Time out in seconds for disks and Magneto-opticals (which are slower).
- */
-#define SD_TIMEOUT		(30 * HZ)
-#define SD_MOD_TIMEOUT		(75 * HZ)
-
-/*
- * Number of allowed retries
- */
-#define SD_MAX_RETRIES		5
-#define SD_PASSTHROUGH_RETRIES	1
-
-/*
- * Size of the initial data buffer for mode and read capacity data
- */
-#define SD_BUF_SIZE		512
-
-struct scsi_disk {
-	struct scsi_driver *driver;	/* always &sd_template */
-	struct scsi_device *device;
-	struct device	dev;
-	struct gendisk	*disk;
-	unsigned int	openers;	/* protected by BKL for now, yuck */
-	sector_t	capacity;	/* size in 512-byte sectors */
-	u32		index;
-	u8		media_present;
-	u8		write_prot;
-	unsigned	previous_state : 1;
-	unsigned	WCE : 1;	/* state of disk WCE bit */
-	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
-	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
-};
-#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
-
-#define sd_printk(prefix, sdsk, fmt, a...)				\
-        (sdsk)->disk ?							\
-	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-		    (sdsk)->disk->disk_name, ##a) :			\
-	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
-
-#endif /* _SCSI_DISK_H */
