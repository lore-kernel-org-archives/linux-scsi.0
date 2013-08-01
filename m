From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 10/10] scsi: Added scsi_target rescan capability to sysfs
Date: Thu,  1 Aug 2013 16:57:39 -0400
Message-ID: <1375390659-12495-11-git-send-email-emilne@redhat.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab3HAU5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:47 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71KvltH015666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:47 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvgvj031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:47 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Add a "rescan" attribute to sysfs for scsi_target objects,
to permit them to be scanned for LUN changes (e.g. from udev).

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_priv.h  |  4 +++-
 drivers/scsi/scsi_scan.c  | 30 +++--------------------
 drivers/scsi/scsi_sysfs.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index ed80f21..7c33799 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -131,7 +131,9 @@ extern int scsi_sysfs_add_host(struct Scsi_Host *);
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
index 0adfecb..243c8b4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -343,26 +343,6 @@ static void scsi_target_destroy(struct scsi_target *starget)
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
-
 static struct scsi_target *__scsi_find_target(struct device *parent,
 					      int channel, uint id)
 {
@@ -413,15 +393,11 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
index d5d86b2..212b43a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1129,6 +1129,67 @@ int scsi_is_sdev_device(const struct device *dev)
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
+static struct attribute *scsi_target_attrs[] = {
+	&dev_attr_trescan.attr,
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

