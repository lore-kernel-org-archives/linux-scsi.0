From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix rescan warning
Date: Mon, 17 Mar 2003 16:53:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030317165301.B29420@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

The prototype for scsi_rescan_device was missing and once added it's
caller doesn't compile anymore because it expects a return value..


--- 1.67/drivers/scsi/scsi.h	Sat Mar 15 01:35:26 2003
+++ edited/drivers/scsi/scsi.h	Mon Mar 17 16:04:49 2003
@@ -442,6 +442,7 @@
 extern int scsi_retry_command(Scsi_Cmnd *);
 extern int scsi_attach_device(struct scsi_device *);
 extern void scsi_detach_device(struct scsi_device *);
+extern void scsi_rescan_device(struct scsi_device *);
 extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
 
 /*
--- 1.8/drivers/scsi/scsi_sysfs.c	Tue Mar  4 10:15:42 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Mon Mar 17 16:30:31 2003
@@ -275,12 +275,8 @@
 static ssize_t
 store_rescan_field (struct device *dev, const char *buf, size_t count) 
 {
-	int ret = ENODEV;
-	struct scsi_device *sdev;
-	sdev = to_scsi_device(dev);
-	if (sdev)
-		ret = scsi_rescan_device(sdev);
-	return ret;
+	scsi_rescan_device(to_scsi_device(dev));
+	return 0;
 }
 
 static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_rescan_field)
