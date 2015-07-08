From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] scsi: rescan VPD attributes
Date: Wed,  8 Jul 2015 13:09:44 +0200
Message-ID: <1436353788-104911-2-git-send-email-hare@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933789AbbGHLJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 07:09:52 -0400
In-Reply-To: <1436353788-104911-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

This patch implements a VPD page rescan if the 'rescan' sysfs
attribute is triggered.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 11 +++++++----
 drivers/scsi/scsi.c                        | 20 +++++++++++++++++---
 drivers/scsi/scsi_scan.c                   |  4 ++++
 drivers/scsi/scsi_sysfs.c                  |  8 ++++++--
 drivers/scsi/ses.c                         |  6 ++++--
 include/scsi/scsi_device.h                 |  1 +
 6 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d077014..e4cabc8 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -264,8 +264,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 	int device_id_size, device_id_type = 0;
 	struct alua_port_group *tmp_pg, *pg = NULL;
 
-	if (!sdev->vpd_pg83)
+	rcu_read_lock();
+	if (!rcu_dereference(sdev->vpd_pg83)) {
+		rcu_read_unlock();
 		return SCSI_DH_DEV_UNSUPP;
+	}
 
 	/*
 	 * Look for the correct descriptor.
@@ -281,8 +284,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 	 */
 	memset(device_id_str, 0, 256);
 	device_id_size = 0;
-	d = sdev->vpd_pg83 + 4;
-	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
+	d = rcu_dereference(sdev->vpd_pg83) + 4;
+	while (d < rcu_dereference(sdev->vpd_pg83) + sdev->vpd_pg83_len) {
 		switch (d[1] & 0xf) {
 		case 0x2:
 			/* EUI-64 */
@@ -366,7 +369,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		}
 		d += d[3] + 4;
 	}
-
+	rcu_read_unlock();
 	if (group_id == -1) {
 		/*
 		 * Internal error; TPGS supported but required
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 207d6a7..f1c0fb5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -803,7 +803,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int vpd_len = SCSI_VPD_PG_LEN;
 	int pg80_supported = 0;
 	int pg83_supported = 0;
-	unsigned char *vpd_buf;
+	unsigned char *vpd_buf, *orig_vpd_buf = NULL;
 
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
index f9f3f82..190d743 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -235,6 +235,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
+	mutex_init(&sdev->inquiry_mutex);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
@@ -1516,6 +1517,9 @@ EXPORT_SYMBOL(scsi_add_device);
 void scsi_rescan_device(struct device *dev)
 {
 	device_lock(dev);
+
+	scsi_attach_vpd(to_scsi_device(dev));
+
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e3c3b86..b4de776 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -759,11 +759,15 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
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
index dcb0d76..1fc372e 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -563,8 +563,9 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (!sdev->vpd_pg83_len)
 		return;
 
-	desc = sdev->vpd_pg83 + 4;
-	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
+	rcu_read_lock();
+	desc = rcu_dereference(sdev->vpd_pg83) + 4;
+	while (desc < rcu_dereference(sdev->vpd_pg83) + sdev->vpd_pg83_len) {
 		enum scsi_protocol proto = desc[0] >> 4;
 		u8 code_set = desc[0] & 0x0f;
 		u8 piv = desc[1] & 0x80;
@@ -578,6 +579,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 		desc += len + 4;
 	}
+	rcu_read_unlock();
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2725f8f..d2f8b7a 100644
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
-- 
1.8.5.2

