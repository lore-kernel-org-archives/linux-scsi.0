From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] Invalidate VPD page data
Date: Sat, 15 Mar 2014 09:51:52 +0100
Message-ID: <1394873512-102073-7-git-send-email-hare@suse.de>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaCOIvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 04:51:55 -0400
In-Reply-To: <1394873512-102073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add a flag 'vpd_invalid' to the SCSI device to indicate that
the VPD data needs to be refreshed. This is required if either
a manual rescan is triggered or if the sense code INQUIRY DATA
HAS CHANGED has been received.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 91 ++++++++++++++++++++++++++++++++++------------
 drivers/scsi/scsi_error.c  |  1 +
 drivers/scsi/scsi_scan.c   |  7 +++-
 drivers/scsi/scsi_sysfs.c  |  6 ++-
 drivers/scsi/ses.c         |  2 +-
 include/scsi/scsi_device.h |  2 +
 6 files changed, 82 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2669cb8..971b099 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1056,10 +1056,11 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int vpd_len = 255;
 	int pg80_supported = 0;
 	int pg83_supported = 0;
-	unsigned char *vpd_buf;
+	unsigned char *vpd_buf, *tmp_pg;
 
 	if (sdev->skip_vpd_pages)
 		return;
+
 retry_pg0:
 	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
 	if (!vpd_buf)
@@ -1087,45 +1088,89 @@ retry_pg0:
 	}
 	kfree(vpd_buf);
 
-	if (pg80_supported) {
 retry_pg80:
+	if (pg80_supported) {
 		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
 		if (!vpd_buf)
-			return;
-
-		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
+			result = -ENOMEM;
+		else
+			result = scsi_vpd_inquiry(sdev, vpd_buf,
+						  0x80, vpd_len);
 		if (result < 0) {
 			kfree(vpd_buf);
+			spin_lock(&sdev->reconfig_lock);
+			tmp_pg = sdev->vpd_pg80;
+			sdev->vpd_pg80 = NULL;
+			sdev->vpd_pg80_len = result;
+			kfree(tmp_pg);
+			spin_unlock(&sdev->reconfig_lock);
+			/*
+			 * An unexpected error occurred,
+			 * do not clear vpd_invalid flag
+			 */
 			return;
+		} else {
+			if (result > vpd_len) {
+				vpd_len = result;
+				kfree(vpd_buf);
+				goto retry_pg80;
+			}
+			spin_lock(&sdev->reconfig_lock);
+			sdev->vpd_pg80 = vpd_buf;
+			sdev->vpd_pg80_len = result;
+			spin_unlock(&sdev->reconfig_lock);
 		}
-		if (result > vpd_len) {
-			vpd_len = result;
-			kfree(vpd_buf);
-			goto retry_pg80;
-		}
-		sdev->vpd_pg80_len = result;
-		sdev->vpd_pg80 = vpd_buf;
+	} else {
+		spin_lock(&sdev->reconfig_lock);
+		tmp_pg = sdev->vpd_pg80;
+		sdev->vpd_pg80 = NULL;
+		sdev->vpd_pg80_len = -ENOENT;
+		kfree(tmp_pg);
+		spin_unlock(&sdev->reconfig_lock);
 	}
 
-	if (pg83_supported) {
 retry_pg83:
+	if (pg83_supported) {
 		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
 		if (!vpd_buf)
-			return;
-
-		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
+			result = -ENOMEM;
+		else
+			result = scsi_vpd_inquiry(sdev, vpd_buf,
+						  0x83, vpd_len);
 		if (result < 0) {
 			kfree(vpd_buf);
+			spin_lock(&sdev->reconfig_lock);
+			tmp_pg = sdev->vpd_pg83;
+			sdev->vpd_pg83 = NULL;
+			sdev->vpd_pg83_len = result;
+			kfree(tmp_pg);
+			spin_unlock(&sdev->reconfig_lock);
+			/*
+			 * An unexpected error occurred,
+			 * do not clear vpd_invalid flag
+			 */
 			return;
+		} else {
+			if (result > vpd_len) {
+				vpd_len = result;
+				kfree(vpd_buf);
+				goto retry_pg83;
+			}
+			spin_lock(&sdev->reconfig_lock);
+			sdev->vpd_pg83 = vpd_buf;
+			sdev->vpd_pg83_len = result;
+			spin_unlock(&sdev->reconfig_lock);
 		}
-		if (result > vpd_len) {
-			vpd_len = result;
-			kfree(vpd_buf);
-			goto retry_pg83;
-		}
-		sdev->vpd_pg83_len = result;
-		sdev->vpd_pg83 = vpd_buf;
+	} else {
+		spin_lock(&sdev->reconfig_lock);
+		tmp_pg = sdev->vpd_pg83;
+		sdev->vpd_pg83 = NULL;
+		sdev->vpd_pg83_len = -ENOENT;
+		kfree(tmp_pg);
+		spin_unlock(&sdev->reconfig_lock);
 	}
+
+	sdev->vpd_invalid = 0;
 }
 
 /**
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 78b004d..b1468c7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -393,6 +393,7 @@ static void scsi_report_sense(struct scsi_device *sdev,
 
 	if (sshdr->sense_key == UNIT_ATTENTION) {
 		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03) {
+			sdev->vpd_invalid = 1;
 			evt_type = SDEV_EVT_INQUIRY_CHANGE_REPORTED;
 			sdev_printk(KERN_WARNING, sdev,
 				    "Inquiry data has changed");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 154bb5e..d177929 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -252,6 +252,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
+	spin_lock_init(&sdev->reconfig_lock);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
@@ -1558,7 +1559,11 @@ EXPORT_SYMBOL(scsi_add_device);
 void scsi_rescan_device(struct device *dev)
 {
 	struct scsi_driver *drv;
-	
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	sdev->vpd_invalid = 1;
+	scsi_attach_vpd(sdev);
+
 	if (!dev->driver)
 		return;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8c916d0..315d1d3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -764,8 +764,10 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 {									\
 	struct device *dev = container_of(kobj, struct device, kobj);	\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	if (!sdev->vpd_##_page)						\
-		return -EINVAL;						\
+	if (sdev->vpd_invalid)						\
+		scsi_attach_vpd(sdev);					\
+	if (sdev->vpd_##_page##_len < 0)				\
+		return sdev->vpd_##_page##_len;				\
 	return memory_read_from_buffer(buf, count, &off,		\
 				       sdev->vpd_##_page,		\
 				       sdev->vpd_##_page##_len);	\
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 80bfece..773766a 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -456,7 +456,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (!sdev->vpd_pg83_len)
+	if (sdev->vpd_pg83_len < 4)
 		return;
 
 	desc = sdev->vpd_pg83 + 4;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2ea8212..9fa5771 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -117,6 +117,7 @@ struct scsi_device {
 	unsigned char *vpd_pg83;
 	unsigned char vpd_pg80_len;
 	unsigned char *vpd_pg80;
+	spinlock_t reconfig_lock;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
@@ -171,6 +172,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned vpd_invalid:1; /* VPD data needs to be refreshed */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
-- 
1.7.12.4

