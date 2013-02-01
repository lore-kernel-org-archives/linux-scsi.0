From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2 6/8] [SCSI] Add sysfs support for enhanced Unit Attention handling
Date: Fri,  1 Feb 2013 12:53:13 -0500
Message-ID: <1359741195-2641-7-git-send-email-emilne@redhat.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab3BARxU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 12:53:20 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r11HrJng011730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:19 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r11HrGRj011917
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:19 -0500
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Added support for additional scsi_device events in sysfs, as
well as support for scsi_target events.  Also added "rescan"
node in scsi_target sysfs to permit targets to be rescanned
from udev rules in a more straightforward way.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_priv.h  |   4 +-
 drivers/scsi/scsi_scan.c  |  29 +---------
 drivers/scsi/scsi_sysfs.c | 141 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 136 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b237c8e..fa3366a97 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -136,7 +136,9 @@ extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
-extern int scsi_sysfs_target_initialize(struct scsi_device *);
+extern void scsi_sysfs_target_initialize(struct scsi_target *,
+					 struct Scsi_Host *,
+					 struct device *parent);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1ad4287..1bbbc43 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -346,25 +346,6 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	put_device(dev);
 }
 
-static void scsi_target_dev_release(struct device *dev)
-{
-	struct device *parent = dev->parent;
-	struct scsi_target *starget = to_scsi_target(dev);
-
-	kfree(starget);
-	put_device(parent);
-}
-
-static struct device_type scsi_target_type = {
-	.name =		"scsi_target",
-	.release =	scsi_target_dev_release,
-};
-
-int scsi_is_target_device(const struct device *dev)
-{
-	return dev->type == &scsi_target_type;
-}
-EXPORT_SYMBOL(scsi_is_target_device);
 
 static struct scsi_target *__scsi_find_target(struct device *parent,
 					      int channel, uint id)
@@ -416,15 +397,11 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
-	dev = &starget->dev;
-	device_initialize(dev);
-	starget->reap_ref = 1;
-	dev->parent = get_device(parent);
-	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
-	dev->bus = &scsi_bus_type;
-	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
+	scsi_sysfs_target_initialize(starget, shost, parent);
+	dev = &starget->dev;
+	starget->reap_ref = 1;
 	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index aff1e29..363e29f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -502,7 +502,7 @@ sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
 {									\
 	int ret;							\
 	struct scsi_device *sdev;					\
-	ret = scsi_sdev_check_buf_bit(buf);				\
+	ret = scsi_sysfs_check_buf_bit(buf);				\
 	if (ret >= 0)	{						\
 		sdev = to_scsi_device(dev);				\
 		sdev->field = ret;					\
@@ -513,10 +513,10 @@ sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
 
 /*
- * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
+ * scsi_sysfs_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
  * else return -EINVAL.
  */
-static int scsi_sdev_check_buf_bit(const char *buf)
+static int scsi_sysfs_check_buf_bit(const char *buf)
 {
 	if ((buf[1] == '\0') || ((buf[1] == '\n') && (buf[2] == '\0'))) {
 		if (buf[0] == '1')
@@ -650,7 +650,8 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
 
 static ssize_t
-show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
+show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
 }
@@ -681,7 +682,7 @@ sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
-#define DECLARE_EVT_SHOW(name, Cap_name)				\
+#define DECLARE_SDEV_EVT_SHOW(name, Cap_name)				\
 static ssize_t								\
 sdev_show_evt_##name(struct device *dev, struct device_attribute *attr,	\
 		     char *buf)						\
@@ -691,7 +692,7 @@ sdev_show_evt_##name(struct device *dev, struct device_attribute *attr,	\
 	return snprintf(buf, 20, "%d\n", val);				\
 }
 
-#define DECLARE_EVT_STORE(name, Cap_name)				\
+#define DECLARE_SDEV_EVT_STORE(name, Cap_name)				\
 static ssize_t								\
 sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
 		      const char *buf, size_t count)			\
@@ -707,15 +708,20 @@ sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
 	return count;							\
 }
 
-#define DECLARE_EVT(name, Cap_name)					\
-	DECLARE_EVT_SHOW(name, Cap_name)				\
-	DECLARE_EVT_STORE(name, Cap_name)				\
+#define DECLARE_SDEV_EVT(name, Cap_name)				\
+	DECLARE_SDEV_EVT_SHOW(name, Cap_name)				\
+	DECLARE_SDEV_EVT_STORE(name, Cap_name)				\
 	static DEVICE_ATTR(evt_##name, S_IRUGO, sdev_show_evt_##name,	\
 			   sdev_store_evt_##name);
 #define REF_EVT(name) &dev_attr_evt_##name.attr
 
-DECLARE_EVT(media_change, MEDIA_CHANGE)
-DECLARE_EVT(capacity_change, CAPACITY_CHANGE)
+DECLARE_SDEV_EVT(media_change, MEDIA_CHANGE)
+DECLARE_SDEV_EVT(capacity_change, CAPACITY_CHANGE)
+#ifdef CONFIG_SCSI_ENHANCED_UA
+DECLARE_SDEV_EVT(capacity_change_reported, CAPACITY_CHANGE_REPORTED)
+DECLARE_SDEV_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED)
+DECLARE_SDEV_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
+#endif
 
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
@@ -736,6 +742,11 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_modalias.attr,
 	REF_EVT(media_change),
 	REF_EVT(capacity_change),
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	REF_EVT(capacity_change_reported),
+	REF_EVT(soft_threshold_reached),
+	REF_EVT(mode_parameter_change_reported),
+#endif
 	NULL
 };
 
@@ -1126,6 +1137,114 @@ int scsi_is_sdev_device(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_sdev_device);
 
+static ssize_t
+starget_store_rescan_field(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct scsi_target *starget = to_scsi_target(dev);
+
+	scsi_scan_target(starget->dev.parent, starget->channel, starget->id,
+			 SCAN_WILD_CARD, 1);
+	return count;
+}
+/* DEVICE_ATTR(rescan) clashes with dev_attr_rescan for sdev */
+struct device_attribute dev_attr_trescan =
+	__ATTR(rescan, S_IWUSR, NULL, starget_store_rescan_field);
+
+#define DECLARE_STARGET_EVT_SHOW(name, Cap_name)			\
+static ssize_t								\
+starget_show_evt_##name(struct device *dev,				\
+			struct device_attribute *attr, char *buf)	\
+{									\
+	struct scsi_target *starget = to_scsi_target(dev);		\
+	int val = test_bit(STARGET_EVT_##Cap_name,			\
+			   starget->supported_events);			\
+	return snprintf(buf, 20, "%d\n", val);				\
+}
+
+#define DECLARE_STARGET_EVT_STORE(name, Cap_name)			\
+static ssize_t								\
+starget_store_evt_##name(struct device *dev,				\
+			 struct device_attribute *attr,			\
+			 const char *buf, size_t count)			\
+{									\
+	struct scsi_target *starget = to_scsi_target(dev);		\
+	unsigned int val;						\
+	int err = kstrtouint(buf, 10, &val);				\
+	if (err != 0)							\
+		return err;						\
+	if (val == 0)							\
+		clear_bit(STARGET_EVT_##Cap_name,			\
+			  starget->supported_events);			\
+	else if (val == 1)						\
+		set_bit(STARGET_EVT_##Cap_name,				\
+			starget->supported_events);			\
+	else								\
+		return -EINVAL;						\
+	return count;							\
+}
+
+#define DECLARE_STARGET_EVT(name, Cap_name)				\
+	DECLARE_STARGET_EVT_SHOW(name, Cap_name)			\
+	DECLARE_STARGET_EVT_STORE(name, Cap_name)			\
+	static DEVICE_ATTR(evt_##name, S_IRUGO,				\
+			   starget_show_evt_##name,			\
+			   starget_store_evt_##name);
+
+#ifdef CONFIG_SCSI_ENHANCED_UA
+DECLARE_STARGET_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
+#endif
+
+static struct attribute *scsi_target_attrs[] = {
+	&dev_attr_trescan.attr,
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	REF_EVT(lun_change_reported),
+#endif
+	NULL
+};
+
+static struct attribute_group scsi_target_attr_group = {
+	.attrs =	scsi_target_attrs,
+};
+
+static const struct attribute_group *scsi_target_attr_groups[] = {
+	&scsi_target_attr_group,
+	NULL
+};
+
+static void scsi_target_dev_release(struct device *dev)
+{
+	struct device *parent = dev->parent;
+	struct scsi_target *starget = to_scsi_target(dev);
+
+	kfree(starget);
+	put_device(parent);
+}
+
+static struct device_type scsi_target_type = {
+	.name =		"scsi_target",
+	.release =	scsi_target_dev_release,
+	.groups =	scsi_target_attr_groups,
+};
+
+int scsi_is_target_device(const struct device *dev)
+{
+	return dev->type == &scsi_target_type;
+}
+EXPORT_SYMBOL(scsi_is_target_device);
+
+void scsi_sysfs_target_initialize(struct scsi_target *starget,
+				  struct Scsi_Host *shost,
+				  struct device *parent)
+{
+	device_initialize(&starget->dev);
+	starget->dev.parent = get_device(parent);
+	starget->dev.bus = &scsi_bus_type;
+	starget->dev.type = &scsi_target_type;
+	dev_set_name(&starget->dev, "target%d:%d:%d", shost->host_no,
+		     starget->channel, starget->id);
+}
+
 /* A blank transport template that is used in drivers that don't
  * yet implement Transport Attributes */
 struct scsi_transport_template blank_transport_template = { { { {NULL, }, }, }, };
-- 
1.7.11.7

