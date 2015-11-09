From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: rescan VPD attributes
Date: Mon,  9 Nov 2015 13:24:28 +0100
Message-ID: <1447071868-8509-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbbKIMYb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 07:24:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.Petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Hannes Reinecke <hare@suse.de>

The VPD page information might change, so we need to be able to
update it. This patch implements a VPD page rescan whenever
the 'rescan' sysfs attribute is triggered.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 20 +++++++++++++++++---
 drivers/scsi/scsi_scan.c   |  4 ++++
 drivers/scsi/scsi_sysfs.c  |  8 ++++++--
 drivers/scsi/ses.c         | 12 +++++++++---
 include/scsi/scsi_device.h |  5 +++--
 5 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 207d6a7..2e4ef56 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -803,7 +803,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int vpd_len = SCSI_VPD_PG_LEN;
 	int pg80_supported = 0;
 	int pg83_supported = 0;
-	unsigned char *vpd_buf;
+	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
 
 	if (sdev->skip_vpd_pages)
 		return;
@@ -849,8 +849,16 @@ retry_pg80:
 			kfree(vpd_buf);
 			goto retry_pg80;
 		}
+		mutex_lock(&sdev->inquiry_mutex);
+		orig_vpd_buf = sdev->vpd_pg80;
 		sdev->vpd_pg80_len = result;
-		sdev->vpd_pg80 = vpd_buf;
+		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
+		mutex_unlock(&sdev->inquiry_mutex);
+		synchronize_rcu();
+		if (orig_vpd_buf) {
+			kfree(orig_vpd_buf);
+			orig_vpd_buf = NULL;
+		}
 		vpd_len = SCSI_VPD_PG_LEN;
 	}
 
@@ -870,8 +878,14 @@ retry_pg83:
 			kfree(vpd_buf);
 			goto retry_pg83;
 		}
+		mutex_lock(&sdev->inquiry_mutex);
+		orig_vpd_buf = sdev->vpd_pg83;
 		sdev->vpd_pg83_len = result;
-		sdev->vpd_pg83 = vpd_buf;
+		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
+		mutex_unlock(&sdev->inquiry_mutex);
+		synchronize_rcu();
+		if (orig_vpd_buf)
+			kfree(orig_vpd_buf);
 	}
 }
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3b3dfef..7e0820f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -236,6 +236,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
+	mutex_init(&sdev->inquiry_mutex);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
@@ -1517,6 +1518,9 @@ EXPORT_SYMBOL(scsi_add_device);
 void scsi_rescan_device(struct device *dev)
 {
 	device_lock(dev);
+
+	scsi_attach_vpd(to_scsi_device(dev));
+
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fdcf0ab..f021423 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -758,11 +758,15 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 {									\
 	struct device *dev = container_of(kobj, struct device, kobj);	\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
+	int ret;							\
 	if (!sdev->vpd_##_page)						\
 		return -EINVAL;						\
-	return memory_read_from_buffer(buf, count, &off,		\
-				       sdev->vpd_##_page,		\
+	rcu_read_lock();						\
+	ret = memory_read_from_buffer(buf, count, &off,			\
+				      rcu_dereference(sdev->vpd_##_page), \
 				       sdev->vpd_##_page##_len);	\
+	rcu_read_unlock();						\
+	return ret;						\
 }									\
 static struct bin_attribute dev_attr_vpd_##_page = {		\
 	.attr =	{.name = __stringify(vpd_##_page), .mode = S_IRUGO },	\
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index dcb0d76..e234da7 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -554,17 +554,22 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
 	unsigned char *desc;
+	unsigned char __rcu *vpd_pg83;
 	struct efd efd = {
 		.addr = 0,
 	};
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (!sdev->vpd_pg83_len)
+	rcu_read_lock();
+	vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
+	if (!vpd_pg83) {
+		rcu_read_unlock();
 		return;
+	}
 
-	desc = sdev->vpd_pg83 + 4;
-	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
+	desc = vpd_pg83 + 4;
+	while (desc < vpd_pg83 + sdev->vpd_pg83_len) {
 		enum scsi_protocol proto = desc[0] >> 4;
 		u8 code_set = desc[0] & 0x0f;
 		u8 piv = desc[1] & 0x80;
@@ -578,6 +583,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 		desc += len + 4;
 	}
+	rcu_read_unlock();
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index fe89d7c..bde4077 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -109,6 +109,7 @@ struct scsi_device {
 	char type;
 	char scsi_level;
 	char inq_periph_qual;	/* PQ from INQUIRY data */	
+	struct mutex inquiry_mutex;
 	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
 	unsigned char * inquiry;	/* INQUIRY response data */
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
@@ -117,9 +118,9 @@ struct scsi_device {
 
 #define SCSI_VPD_PG_LEN                255
 	int vpd_pg83_len;
-	unsigned char *vpd_pg83;
+	unsigned char __rcu *vpd_pg83;
 	int vpd_pg80_len;
-	unsigned char *vpd_pg80;
+	unsigned char __rcu *vpd_pg80;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-- 
1.8.5.6

