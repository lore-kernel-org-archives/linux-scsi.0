From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] consolidate timeout defintions in scsi.h
Date: Tue, 29 Mar 2005 19:23:19 +0200
Message-ID: <20050329172319.GA2430@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40850 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261252AbVC2RXX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 12:23:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Adapted from a patch in SuSE's kernel SRPM.


--- 1.65/drivers/block/scsi_ioctl.c	2005-01-20 16:41:57 +01:00
+++ edited/drivers/block/scsi_ioctl.c	2005-03-29 17:54:17 +02:00
@@ -328,11 +328,6 @@
 	return 0;
 }
 
-#define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
-#define START_STOP_TIMEOUT		(60 * HZ)
-#define MOVE_MEDIUM_TIMEOUT		(5 * 60 * HZ)
-#define READ_ELEMENT_STATUS_TIMEOUT	(5 * 60 * HZ)
-#define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )
 #define OMAX_SB_LEN 16          /* For backward compatibility */
 
 static int sg_scsi_ioctl(struct file *file, request_queue_t *q,
--- 1.34/drivers/scsi/scsi_ioctl.c	2005-03-14 00:29:46 +01:00
+++ edited/drivers/scsi/scsi_ioctl.c	2005-03-29 17:54:02 +02:00
@@ -27,11 +27,6 @@
 
 #define NORMAL_RETRIES			5
 #define IOCTL_NORMAL_TIMEOUT			(10 * HZ)
-#define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
-#define START_STOP_TIMEOUT		(60 * HZ)
-#define MOVE_MEDIUM_TIMEOUT		(5 * 60 * HZ)
-#define READ_ELEMENT_STATUS_TIMEOUT	(5 * 60 * HZ)
-#define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )  /* ZIP-250 on parallel port takes as long! */
 
 #define MAX_BUF PAGE_SIZE
 
--- 1.27/include/scsi/scsi.h	2005-03-08 00:29:09 +01:00
+++ edited/include/scsi/scsi.h	2005-03-29 17:53:44 +02:00
@@ -360,6 +360,15 @@
 #define sense_error(sense)  ((sense) & 0xf)
 #define sense_valid(sense)  ((sense) & 0x80);
 
+/*
+ * default timeouts
+*/
+#define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
+#define START_STOP_TIMEOUT		(60 * HZ)
+#define MOVE_MEDIUM_TIMEOUT		(5 * 60 * HZ)
+#define READ_ELEMENT_STATUS_TIMEOUT	(5 * 60 * HZ)
+#define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )
+
 
 #define IDENTIFY_BASE       0x80
 #define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
