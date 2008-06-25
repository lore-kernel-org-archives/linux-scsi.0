From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 01 of 10] sd: Move sd.h header file
Date: Wed, 25 Jun 2008 11:22:40 -0400
Message-ID: <c98c38f81ba11487baba.1214407360@sermon.lab.mkp.net>
References: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41035 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942AbYFYPZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:26 -0400
In-Reply-To: <patchbomb.1214407359@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Christoph objected to having sd.h in include/scsi since it is internal
to the sd driver.  Move it to drivers/scsi/sd.h.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
3 files changed, 58 insertions(+), 58 deletions(-)
drivers/scsi/sd.c |    2 -
drivers/scsi/sd.h |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
include/scsi/sd.h |   57 -----------------------------------------------------



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -58,8 +58,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
-#include <scsi/sd.h>
 
+#include "sd.h"
 #include "scsi_logging.h"
 
 MODULE_AUTHOR("Eric Youngdale");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/sd.h
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
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
deleted file mode 100644
--- a/include/scsi/sd.h
+++ /dev/null
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


