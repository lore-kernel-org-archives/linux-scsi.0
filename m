From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 3/3] Rework handling of scsi_device.vpd_pg8[03]
Date: Mon, 28 Aug 2017 13:44:46 -0700
Message-ID: <20170828204446.29066-8-bart.vanassche@wdc.com>
References: <20170828204446.29066-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1612 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdH1UrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2017 16:47:16 -0400
In-Reply-To: <20170828204446.29066-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

Introduce struct scsi_vpd for the VPD page length, data and the
RCU head that will be used to free the VPD data. Use kfree_rcu()
instead of kfree() to free VPD data. Move the VPD buffer pointer
check inside the RCU read lock in the sysfs code. Only annotate
pointers that are shared across threads with __rcu. Use
rcu_dereference() when dereferencing an RCU pointer. This patch
suppresses about twenty sparse complaints about the vpd_pg8[03]
pointers. This patch also fixes a race condition, namely that
updating of the VPD pointers and length variables in struct
scsi_device was not atomic with reference to the code reading
these variables. See also "Does the update code tolerate concurrent
accesses?" in Documentation/RCU/checklist.txt.

Fixes: commit 09e2b0b14690 ("scsi: rescan VPD attributes")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane Seymour <shane.seymour@hpe.com>
---
 drivers/scsi/scsi.c        | 44 ++++++++++++++++++--------------------------
 drivers/scsi/scsi_lib.c    | 16 ++++++++--------
 drivers/scsi/scsi_sysfs.c  | 29 ++++++++++++++++++++---------
 include/scsi/scsi_device.h | 18 ++++++++++++++----
 4 files changed, 60 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f3f4926a3e77..d201ebcf4544 100644
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
@@ -441,31 +439,27 @@ static unsigned char *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page,
 		goto retry_pg;
 	}
 
-	*len = result;
+	vpd_buf->len = result;
 
 	return vpd_buf;
 }
 
 static void scsi_update_vpd_page(struct scsi_device *sdev, u8 page,
-				 unsigned char __rcu **sdev_vpd_buf,
-				 int *sdev_vpd_len)
+				 struct scsi_vpd __rcu **sdev_vpd_buf)
 {
-	unsigned char *vpd_buf;
-	int len;
+	struct scsi_vpd *vpd_buf;
 
-	vpd_buf = scsi_get_vpd_buf(sdev, page, &len);
+	vpd_buf = scsi_get_vpd_buf(sdev, page);
 	if (!vpd_buf)
 		return;
 
 	mutex_lock(&sdev->inquiry_mutex);
 	rcu_swap_protected(*sdev_vpd_buf, vpd_buf,
 			   lockdep_is_held(&sdev->inquiry_mutex));
-	*sdev_vpd_len = len;
 	mutex_unlock(&sdev->inquiry_mutex);
 
-	synchronize_rcu();
-
-	kfree(vpd_buf);
+	if (vpd_buf)
+		kfree_rcu(vpd_buf, rcu);
 }
 
 /**
@@ -479,24 +473,22 @@ static void scsi_update_vpd_page(struct scsi_device *sdev, u8 page,
  */
 void scsi_attach_vpd(struct scsi_device *sdev)
 {
-	int i, vpd_len;
-	unsigned char *vpd_buf;
+	int i;
+	struct scsi_vpd *vpd_buf;
 
 	if (!scsi_device_supports_vpd(sdev))
 		return;
 
 	/* Ask for all the pages supported by this device */
-	vpd_buf = scsi_get_vpd_buf(sdev, 0, &vpd_len);
+	vpd_buf = scsi_get_vpd_buf(sdev, 0);
 	if (!vpd_buf)
 		return;
 
-	for (i = 4; i < vpd_len; i++) {
-		if (vpd_buf[i] == 0x80)
-			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80,
-					     &sdev->vpd_pg80_len);
-		if (vpd_buf[i] == 0x83)
-			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83,
-					     &sdev->vpd_pg83_len);
+	for (i = 4; i < vpd_buf->len; i++) {
+		if (vpd_buf->data[i] == 0x80)
+			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
+		if (vpd_buf->data[i] == 0x83)
+			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
 	}
 	kfree(vpd_buf);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 696d2eae0ba6..938a7e398cd4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3272,8 +3272,8 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 {
 	u8 cur_id_type = 0xff;
 	u8 cur_id_size = 0;
-	unsigned char *d, *cur_id_str;
-	unsigned char __rcu *vpd_pg83;
+	const unsigned char *d, *cur_id_str;
+	const struct scsi_vpd *vpd_pg83;
 	int id_size = -EINVAL;
 
 	rcu_read_lock();
@@ -3304,8 +3304,8 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	}
 
 	memset(id, 0, id_len);
-	d = vpd_pg83 + 4;
-	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
+	d = vpd_pg83->data + 4;
+	while (d < vpd_pg83->data + vpd_pg83->len) {
 		/* Skip designators not referring to the LUN */
 		if ((d[1] & 0x30) != 0x00)
 			goto next_desig;
@@ -3421,8 +3421,8 @@ EXPORT_SYMBOL(scsi_vpd_lun_id);
  */
 int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 {
-	unsigned char *d;
-	unsigned char __rcu *vpd_pg83;
+	const unsigned char *d;
+	const struct scsi_vpd *vpd_pg83;
 	int group_id = -EAGAIN, rel_port = -1;
 
 	rcu_read_lock();
@@ -3432,8 +3432,8 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
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
index 5ed473a87589..bf53356f41f0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -428,6 +428,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_device *sdev;
 	struct device *parent;
 	struct list_head *this, *tmp;
+	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
@@ -456,8 +457,17 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	kfree(sdev->vpd_pg83);
-	kfree(sdev->vpd_pg80);
+	mutex_lock(&sdev->inquiry_mutex);
+	rcu_swap_protected(sdev->vpd_pg80, vpd_pg80,
+			   lockdep_is_held(&sdev->inquiry_mutex));
+	rcu_swap_protected(sdev->vpd_pg83, vpd_pg83,
+			   lockdep_is_held(&sdev->inquiry_mutex));
+	mutex_unlock(&sdev->inquiry_mutex);
+
+	if (vpd_pg83)
+		kfree_rcu(vpd_pg83, rcu);
+	if (vpd_pg80)
+		kfree_rcu(vpd_pg80, rcu);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -795,15 +805,16 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 {									\
 	struct device *dev = container_of(kobj, struct device, kobj);	\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	int ret;							\
-	if (!sdev->vpd_##_page)						\
-		return -EINVAL;						\
+	struct scsi_vpd *vpd_page;					\
+	int ret = -EINVAL;						\
+									\
 	rcu_read_lock();						\
-	ret = memory_read_from_buffer(buf, count, &off,			\
-				      rcu_dereference(sdev->vpd_##_page), \
-				       sdev->vpd_##_page##_len);	\
+	vpd_page = rcu_dereference(sdev->vpd_##_page);			\
+	if (vpd_page)							\
+		ret = memory_read_from_buffer(buf, count, &off,		\
+				vpd_page->data, vpd_page->len);		\
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
