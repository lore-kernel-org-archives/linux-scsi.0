From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] raid class update
Date: Sun, 06 Nov 2005 11:59:08 -0600
Message-ID: <1131299948.3316.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:36488 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932242AbVKFR7J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Nov 2005 12:59:09 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id jA6Hx8x20664
	for <linux-scsi@vger.kernel.org>; Sun, 6 Nov 2005 12:59:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

- Update raid class to use nested classes for raid components (this will
allow us to move to a component control model now)
- Make the raid level an enumeration rather than and int.

James

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -1,5 +1,13 @@
 /*
- * RAID Attributes
+ * raid_class.c - implementation of a simple raid visualisation class
+ *
+ * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
+ *
+ * This file is licensed under GPLv2
+ *
+ * This class is designed to allow raid attributes to be visualised and
+ * manipulated in a form independent of the underlying raid.  Ultimately this
+ * should work for both hardware and software raids.
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -22,7 +30,7 @@ struct raid_internal {
 
 struct raid_component {
 	struct list_head node;
-	struct device *dev;
+	struct class_device cdev;
 	int num;
 };
 
@@ -72,11 +80,10 @@ static int raid_setup(struct transport_c
 
 	BUG_ON(class_get_devdata(cdev));
 
-	rd = kmalloc(sizeof(*rd), GFP_KERNEL);
+	rd = kzalloc(sizeof(*rd), GFP_KERNEL);
 	if (!rd)
 		return -ENOMEM;
 
-	memset(rd, 0, sizeof(*rd));
 	INIT_LIST_HEAD(&rd->component_list);
 	class_set_devdata(cdev, rd);
 		
@@ -88,15 +95,15 @@ static int raid_remove(struct transport_
 {
 	struct raid_data *rd = class_get_devdata(cdev);
 	struct raid_component *rc, *next;
+	dev_printk(KERN_ERR, dev, "RAID REMOVE\n");
 	class_set_devdata(cdev, NULL);
 	list_for_each_entry_safe(rc, next, &rd->component_list, node) {
-		char buf[40];
-		snprintf(buf, sizeof(buf), "component-%d", rc->num);
 		list_del(&rc->node);
-		sysfs_remove_link(&cdev->kobj, buf);
-		kfree(rc);
+		dev_printk(KERN_ERR, rc->cdev.dev, "RAID COMPONENT REMOVE\n");
+		class_device_unregister(&rc->cdev);
 	}
-	kfree(class_get_devdata(cdev));
+	dev_printk(KERN_ERR, dev, "RAID REMOVE DONE\n");
+	kfree(rd);
 	return 0;
 }
 
@@ -110,10 +117,11 @@ static struct {
 	enum raid_state	value;
 	char		*name;
 } raid_states[] = {
-	{ RAID_ACTIVE, "active" },
-	{ RAID_DEGRADED, "degraded" },
-	{ RAID_RESYNCING, "resyncing" },
-	{ RAID_OFFLINE, "offline" },
+	{ RAID_STATE_UNKNOWN, "unknown" },
+	{ RAID_STATE_ACTIVE, "active" },
+	{ RAID_STATE_DEGRADED, "degraded" },
+	{ RAID_STATE_RESYNCING, "resyncing" },
+	{ RAID_STATE_OFFLINE, "offline" },
 };
 
 static const char *raid_state_name(enum raid_state state)
@@ -130,6 +138,33 @@ static const char *raid_state_name(enum 
 	return name;
 }
 
+static struct {
+	enum raid_level value;
+	char *name;
+} raid_levels[] = {
+	{ RAID_LEVEL_UNKNOWN, "unknown" },
+	{ RAID_LEVEL_LINEAR, "linear" },
+	{ RAID_LEVEL_0, "raid0" },
+	{ RAID_LEVEL_1, "raid1" },
+	{ RAID_LEVEL_3, "raid3" },
+	{ RAID_LEVEL_4, "raid4" },
+	{ RAID_LEVEL_5, "raid5" },
+	{ RAID_LEVEL_6, "raid6" },
+};
+
+static const char *raid_level_name(enum raid_level level)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < sizeof(raid_levels)/sizeof(raid_levels[0]); i++) {
+		if (raid_levels[i].value == level) {
+			name = raid_levels[i].name;
+			break;
+		}
+	}
+	return name;
+}
 
 #define raid_attr_show_internal(attr, fmt, var, code)			\
 static ssize_t raid_show_##attr(struct class_device *cdev, char *buf)	\
@@ -159,11 +194,22 @@ static CLASS_DEVICE_ATTR(attr, S_IRUGO, 
 
 #define raid_attr_ro(attr)	raid_attr_ro_internal(attr, )
 #define raid_attr_ro_fn(attr)	raid_attr_ro_internal(attr, ATTR_CODE(attr))
-#define raid_attr_ro_state(attr)	raid_attr_ro_states(attr, attr, ATTR_CODE(attr))
+#define raid_attr_ro_state(attr)	raid_attr_ro_states(attr, attr, )
+#define raid_attr_ro_state_fn(attr)	raid_attr_ro_states(attr, attr, ATTR_CODE(attr))
+
 
-raid_attr_ro(level);
+raid_attr_ro_state(level);
 raid_attr_ro_fn(resync);
-raid_attr_ro_state(state);
+raid_attr_ro_state_fn(state);
+
+static void raid_component_release(struct class_device *cdev)
+{
+	struct raid_component *rc = container_of(cdev, struct raid_component,
+						 cdev);
+	dev_printk(KERN_ERR, rc->cdev.dev, "COMPONENT RELEASE\n");
+	put_device(rc->cdev.dev);
+	kfree(rc);
+}
 
 void raid_component_add(struct raid_template *r,struct device *raid_dev,
 			struct device *component_dev)
@@ -173,34 +219,36 @@ void raid_component_add(struct raid_temp
 						      raid_dev);
 	struct raid_component *rc;
 	struct raid_data *rd = class_get_devdata(cdev);
-	char buf[40];
 
-	rc = kmalloc(sizeof(*rc), GFP_KERNEL);
+	rc = kzalloc(sizeof(*rc), GFP_KERNEL);
 	if (!rc)
 		return;
 
 	INIT_LIST_HEAD(&rc->node);
-	rc->dev = component_dev;
+	class_device_initialize(&rc->cdev);
+	rc->cdev.release = raid_component_release;
+	rc->cdev.dev = get_device(component_dev);
 	rc->num = rd->component_count++;
 
-	snprintf(buf, sizeof(buf), "component-%d", rc->num);
+	snprintf(rc->cdev.class_id, sizeof(rc->cdev.class_id),
+		 "component-%d", rc->num);
 	list_add_tail(&rc->node, &rd->component_list);
-	sysfs_create_link(&cdev->kobj, &component_dev->kobj, buf);
+	rc->cdev.parent = cdev;
+	rc->cdev.class = &raid_class.class;
+	class_device_add(&rc->cdev);
 }
 EXPORT_SYMBOL(raid_component_add);
 
 struct raid_template *
 raid_class_attach(struct raid_function_template *ft)
 {
-	struct raid_internal *i = kmalloc(sizeof(struct raid_internal),
+	struct raid_internal *i = kzalloc(sizeof(struct raid_internal),
 					  GFP_KERNEL);
 	int count = 0;
 
 	if (unlikely(!i))
 		return NULL;
 
-	memset(i, 0, sizeof(*i));
-
 	i->f = ft;
 
 	i->r.raid_attrs.ac.class = &raid_class.class;
diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
--- a/include/linux/raid_class.h
+++ b/include/linux/raid_class.h
@@ -1,4 +1,9 @@
 /*
+ * raid_class.h - a generic raid visualisation class
+ *
+ * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
+ *
+ * This file is licensed under GPLv2
  */
 #include <linux/transport_class.h>
 
@@ -14,20 +19,35 @@ struct raid_function_template {
 };
 
 enum raid_state {
-	RAID_ACTIVE = 1,
-	RAID_DEGRADED,
-	RAID_RESYNCING,
-	RAID_OFFLINE,
+	RAID_STATE_UNKNOWN = 0,
+	RAID_STATE_ACTIVE,
+	RAID_STATE_DEGRADED,
+	RAID_STATE_RESYNCING,
+	RAID_STATE_OFFLINE,
+};
+
+enum raid_level {
+	RAID_LEVEL_UNKNOWN = 0,
+	RAID_LEVEL_LINEAR,
+	RAID_LEVEL_0,
+	RAID_LEVEL_1,
+	RAID_LEVEL_3,
+	RAID_LEVEL_4,
+	RAID_LEVEL_5,
+	RAID_LEVEL_6,
 };
 
 struct raid_data {
 	struct list_head component_list;
 	int component_count;
-	int level;
+	enum raid_level level;
 	enum raid_state state;
 	int resync;
 };
 
+/* resync complete goes from 0 to this */
+#define RAID_MAX_RESYNC		(10000)
+
 #define DEFINE_RAID_ATTRIBUTE(type, attr)				      \
 static inline void							      \
 raid_set_##attr(struct raid_template *r, struct device *dev, type value) {    \
@@ -48,7 +68,7 @@ raid_get_##attr(struct raid_template *r,
 	return rd->attr;						      \
 }
 
-DEFINE_RAID_ATTRIBUTE(int, level)
+DEFINE_RAID_ATTRIBUTE(enum raid_level, level)
 DEFINE_RAID_ATTRIBUTE(int, resync)
 DEFINE_RAID_ATTRIBUTE(enum raid_state, state)
 	


