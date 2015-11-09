From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/18] scsi_dh: move 'dh_state' sysfs attribute to generic code
Date: Mon,  9 Nov 2015 16:08:06 +0100
Message-ID: <1447081703-110552-2-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbbKIPIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:25 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

As scsi_dh.c is now always compiled in we should be moving
the 'dh_state' attribute to the generic code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_dh.c    | 68 +----------------------------------------------
 drivers/scsi/scsi_sysfs.c | 58 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 0a2168e..57ad0f3 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -153,76 +153,11 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev)
 	module_put(sdev->handler->module);
 }
 
-/*
- * Functions for sysfs attribute 'dh_state'
- */
-static ssize_t
-store_dh_state(struct device *dev, struct device_attribute *attr,
-	       const char *buf, size_t count)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_device_handler *scsi_dh;
-	int err = -EINVAL;
-
-	if (sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
-		return -ENODEV;
-
-	if (!sdev->handler) {
-		/*
-		 * Attach to a device handler
-		 */
-		scsi_dh = scsi_dh_lookup(buf);
-		if (!scsi_dh)
-			return err;
-		err = scsi_dh_handler_attach(sdev, scsi_dh);
-	} else {
-		if (!strncmp(buf, "detach", 6)) {
-			/*
-			 * Detach from a device handler
-			 */
-			sdev_printk(KERN_WARNING, sdev,
-				    "can't detach handler %s.\n",
-				    sdev->handler->name);
-			err = -EINVAL;
-		} else if (!strncmp(buf, "activate", 8)) {
-			/*
-			 * Activate a device handler
-			 */
-			if (sdev->handler->activate)
-				err = sdev->handler->activate(sdev, NULL, NULL);
-			else
-				err = 0;
-		}
-	}
-
-	return err<0?err:count;
-}
-
-static ssize_t
-show_dh_state(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-
-	if (!sdev->handler)
-		return snprintf(buf, 20, "detached\n");
-
-	return snprintf(buf, 20, "%s\n", sdev->handler->name);
-}
-
-static struct device_attribute scsi_dh_state_attr =
-	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
-	       store_dh_state);
-
 int scsi_dh_add_device(struct scsi_device *sdev)
 {
 	struct scsi_device_handler *devinfo = NULL;
 	const char *drv;
-	int err;
-
-	err = device_create_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
-	if (err)
-		return err;
+	int err = 0;
 
 	drv = scsi_dh_find_driver(sdev);
 	if (drv)
@@ -236,7 +171,6 @@ void scsi_dh_remove_device(struct scsi_device *sdev)
 {
 	if (sdev->handler)
 		scsi_dh_handler_detach(sdev);
-	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 }
 
 /*
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f021423..13a5ede 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -17,6 +17,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 
@@ -902,6 +903,60 @@ sdev_show_function(queue_depth, "%d\n");
 static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
 		   sdev_store_queue_depth);
 
+#ifdef CONFIG_SCSI_DH
+static ssize_t
+sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
+		   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (!sdev->handler)
+		return snprintf(buf, 20, "detached\n");
+
+	return snprintf(buf, 20, "%s\n", sdev->handler->name);
+}
+
+static ssize_t
+sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = -EINVAL;
+
+	if (sdev->sdev_state == SDEV_CANCEL ||
+	    sdev->sdev_state == SDEV_DEL)
+		return -ENODEV;
+
+	if (!sdev->handler) {
+		/*
+		 * Attach to a device handler
+		 */
+		err = scsi_dh_attach(sdev->request_queue, buf);
+	} else if (!strncmp(buf, "activate", 8)) {
+		/*
+		 * Activate a device handler
+		 */
+		if (sdev->handler->activate)
+			err = sdev->handler->activate(sdev, NULL, NULL);
+		else
+			err = 0;
+	} else if (!strncmp(buf, "detach", 6)) {
+		/*
+		 * Detach from a device handler
+		 */
+		sdev_printk(KERN_WARNING, sdev,
+			    "can't detach handler %s.\n",
+			    sdev->handler->name);
+		err = -EINVAL;
+	}
+
+	return err < 0 ? err : count;
+}
+
+static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
+		   sdev_store_dh_state);
+#endif
+
 static ssize_t
 sdev_show_queue_ramp_up_period(struct device *dev,
 			       struct device_attribute *attr,
@@ -971,6 +1026,9 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
+#ifdef CONFIG_SCSI_DH
+	&dev_attr_dh_state.attr,
+#endif
 	&dev_attr_queue_ramp_up_period.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
-- 
1.8.5.6

