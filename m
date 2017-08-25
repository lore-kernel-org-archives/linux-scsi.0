From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/2] Rework handling of scsi_device.vpd_pg8[03]
Date: Fri, 25 Aug 2017 13:36:01 -0700
Message-ID: <20170825203601.23612-3-bart.vanassche@wdc.com>
References: <20170825203601.23612-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14039 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756291AbdHYUgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:36:47 -0400
In-Reply-To: <20170825203601.23612-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

Introduce struct scsi_vpd for the VPD page length, data and the
RCU head that will be used to free the VPD data. Use kfree_rcu()
instead of kfree() to free VPD data. Only annotate pointers that
are shared across threads with __rcu. Use rcu_dereference() when
dereferencing an RCU pointer. This patch suppresses about twenty
sparse complaints about the vpd_pg8[03] pointers.

Fixes: commit 09e2b0b14690 ("scsi: rescan VPD attributes")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane Seymour <shane.seymour@hpe.com>
---
 drivers/scsi/scsi.c        | 48 +++++++++++++++++++++-------------------------
 drivers/scsi/scsi_lib.c    | 16 ++++++++--------
 drivers/scsi/scsi_sysfs.c  | 26 +++++++++++++++++++------
 include/scsi/scsi_device.h | 18 +++++++++++++----
 4 files changed, 64 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 775f609f89e2..1cf3aef0de8a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -415,22 +415,20 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
  * scsi_get_vpd_buf - Get Vital Product Data from a SCSI device
  * @sdev: The device to ask
  * @page: Which Vital Product Data to return
- * @len: Upon success, the VPD length will be stored in *@len.
  *
  * Returns %NULL upon failure.
  */
-static unsigned char *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page,
-				       int *len)
+static struct scsi_vpd *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page)
 {
-	unsigned char *vpd_buf;
+	struct scsi_vpd *vpd_buf;
 	int vpd_len = SCSI_VPD_PG_LEN, result;
 
 retry_pg:
-	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
+	vpd_buf = kmalloc(sizeof(*vpd_buf) + vpd_len, GFP_KERNEL);
 	if (!vpd_buf)
 		return NULL;
 
-	result = scsi_vpd_inquiry(sdev, vpd_buf, page, vpd_len);
+	result = scsi_vpd_inquiry(sdev, vpd_buf->data, page, vpd_len);
 	if (result < 0) {
 		kfree(vpd_buf);
 		return NULL;
@@ -441,7 +439,7 @@ static unsigned char *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page,
 		goto retry_pg;
 	}
 
-	*len = result;
+	vpd_buf->len = result;
 
 	return vpd_buf;
 }
@@ -458,52 +456,50 @@ static unsigned char *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page,
 void scsi_attach_vpd(struct scsi_device *sdev)
 {
 	int i;
-	int vpd_len;
 	int pg80_supported = 0;
 	int pg83_supported = 0;
-	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
+	struct scsi_vpd *vpd_buf, *orig_vpd_buf;
 
 	if (!scsi_device_supports_vpd(sdev))
 		return;
 
 	/* Ask for all the pages supported by this device */
-	vpd_buf = scsi_get_vpd_buf(sdev, 0, &vpd_len);
+	vpd_buf = scsi_get_vpd_buf(sdev, 0);
 	if (!vpd_buf)
 		return;
 
-	for (i = 4; i < vpd_len; i++) {
-		if (vpd_buf[i] == 0x80)
+	for (i = 4; i < vpd_buf->len; i++) {
+		if (vpd_buf->data[i] == 0x80)
 			pg80_supported = 1;
-		if (vpd_buf[i] == 0x83)
+		if (vpd_buf->data[i] == 0x83)
 			pg83_supported = 1;
 	}
 	kfree(vpd_buf);
 
 	if (pg80_supported) {
-		vpd_buf = scsi_get_vpd_buf(sdev, 0x80, &vpd_len);
+		vpd_buf = scsi_get_vpd_buf(sdev, 0x80);
 
 		mutex_lock(&sdev->inquiry_mutex);
-		orig_vpd_buf = sdev->vpd_pg80;
-		sdev->vpd_pg80_len = vpd_len;
+		orig_vpd_buf = rcu_dereference_protected(sdev->vpd_pg80,
+					lockdep_is_held(&sdev->inquiry_mutex));
 		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
 		mutex_unlock(&sdev->inquiry_mutex);
-		synchronize_rcu();
-		if (orig_vpd_buf) {
-			kfree(orig_vpd_buf);
-			orig_vpd_buf = NULL;
-		}
+
+		if (orig_vpd_buf)
+			kfree_rcu(orig_vpd_buf, rcu);
 	}
 
 	if (pg83_supported) {
-		vpd_buf = scsi_get_vpd_buf(sdev, 0x83, &vpd_len);
+		vpd_buf = scsi_get_vpd_buf(sdev, 0x83);
+
 		mutex_lock(&sdev->inquiry_mutex);
-		orig_vpd_buf = sdev->vpd_pg83;
-		sdev->vpd_pg83_len = vpd_len;
+		orig_vpd_buf = rcu_dereference_protected(sdev->vpd_pg83,
+					lockdep_is_held(&sdev->inquiry_mutex));
 		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
 		mutex_unlock(&sdev->inquiry_mutex);
-		synchronize_rcu();
+
 		if (orig_vpd_buf)
-			kfree(orig_vpd_buf);
+			kfree_rcu(orig_vpd_buf, rcu);
 	}
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 813d2456ae93..3d6e50087600 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3276,8 +3276,8 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 {
 	u8 cur_id_type = 0xff;
 	u8 cur_id_size = 0;
-	unsigned char *d, *cur_id_str;
-	unsigned char __rcu *vpd_pg83;
+	const unsigned char *d, *cur_id_str;
+	const struct scsi_vpd *vpd_pg83;
 	int id_size = -EINVAL;
 
 	rcu_read_lock();
@@ -3308,8 +3308,8 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	}
 
 	memset(id, 0, id_len);
-	d = vpd_pg83 + 4;
-	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
+	d = vpd_pg83->data + 4;
+	while (d < vpd_pg83->data + vpd_pg83->len) {
 		/* Skip designators not referring to the LUN */
 		if ((d[1] & 0x30) != 0x00)
 			goto next_desig;
@@ -3425,8 +3425,8 @@ EXPORT_SYMBOL(scsi_vpd_lun_id);
  */
 int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 {
-	unsigned char *d;
-	unsigned char __rcu *vpd_pg83;
+	const unsigned char *d;
+	const struct scsi_vpd *vpd_pg83;
 	int group_id = -EAGAIN, rel_port = -1;
 
 	rcu_read_lock();
@@ -3436,8 +3436,8 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 		return -ENXIO;
 	}
 
-	d = sdev->vpd_pg83 + 4;
-	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
+	d = vpd_pg83->data + 4;
+	while (d < vpd_pg83->data + vpd_pg83->len) {
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5ed473a87589..8a75e0f10eeb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -428,6 +428,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_device *sdev;
 	struct device *parent;
 	struct list_head *this, *tmp;
+	struct scsi_vpd *vpd_pg80, *vpd_pg83;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
@@ -456,8 +457,19 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	kfree(sdev->vpd_pg83);
-	kfree(sdev->vpd_pg80);
+	mutex_lock(&sdev->inquiry_mutex);
+	vpd_pg80 = rcu_dereference_protected(sdev->vpd_pg80,
+				lockdep_is_held(&sdev->inquiry_mutex));
+	rcu_assign_pointer(sdev->vpd_pg80, NULL);
+	vpd_pg83 = rcu_dereference_protected(sdev->vpd_pg83,
+				lockdep_is_held(&sdev->inquiry_mutex));
+	rcu_assign_pointer(sdev->vpd_pg83, NULL);
+	mutex_unlock(&sdev->inquiry_mutex);
+
+	if (vpd_pg83)
+		kfree_rcu(vpd_pg83, rcu);
+	if (vpd_pg80)
+		kfree_rcu(vpd_pg80, rcu);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -795,15 +807,17 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 {									\
 	struct device *dev = container_of(kobj, struct device, kobj);	\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct scsi_vpd *vpd_page;					\
 	int ret;							\
+									\
 	if (!sdev->vpd_##_page)						\
 		return -EINVAL;						\
 	rcu_read_lock();						\
-	ret = memory_read_from_buffer(buf, count, &off,			\
-				      rcu_dereference(sdev->vpd_##_page), \
-				       sdev->vpd_##_page##_len);	\
+	vpd_page = rcu_dereference(sdev->vpd_##_page);			\
+	ret = memory_read_from_buffer(buf, count, &off, vpd_page->data, \
+				      vpd_page->len);			\
 	rcu_read_unlock();						\
-	return ret;						\
+	return ret;							\
 }									\
 static struct bin_attribute dev_attr_vpd_##_page = {		\
 	.attr =	{.name = __stringify(vpd_##_page), .mode = S_IRUGO },	\
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f054f3f43c75..82e93ee94708 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -80,6 +80,18 @@ struct scsi_event {
 	 */
 };
 
+/**
+ * struct scsi_vpd - SCSI Vital Product Data
+ * @rcu: For kfree_rcu().
+ * @len: Length in bytes of @data.
+ * @data: VPD data as defined in various T10 SCSI standard documents.
+ */
+struct scsi_vpd {
+	struct rcu_head	rcu;
+	int		len;
+	unsigned char	data[];
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -122,10 +134,8 @@ struct scsi_device {
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 
 #define SCSI_VPD_PG_LEN                255
-	int vpd_pg83_len;
-	unsigned char __rcu *vpd_pg83;
-	int vpd_pg80_len;
-	unsigned char __rcu *vpd_pg80;
+	struct scsi_vpd __rcu *vpd_pg83;
+	struct scsi_vpd __rcu *vpd_pg80;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-- 
2.14.1
