From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 3/3] add fc transport events
Date: Thu, 27 May 2004 00:26:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B59815.2020204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000805070704040501010503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47364 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261693AbUE0H0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 03:26:38 -0400
Received: from cs.wisc.edu ([199.108.226.254])
	(authenticated (0 bits))
	by sabe.cs.wisc.edu (8.11.3/8.11.3) with ESMTP id i4R7QEw07606
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2004 02:26:36 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000805070704040501010503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


03-convert-fc-class.patch - converts the fc class from a class_device
scsi_device to a kobject and adds a basic link_up/down event fucntion.

  drivers/scsi/scsi_transport_fc.c |  125 ++++++++++++++++++++++++++++++++-------
  include/scsi/scsi_transport.h    |   14 ++--
  2 files changed, 111 insertions(+), 28 deletions(-)

--------------000805070704040501010503
Content-Type: text/plain;
 name="03-convert-fc-class.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-convert-fc-class.patch"

diff -arup linux-2.6.7-rc1/drivers/scsi/scsi_transport_fc.c linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.7-rc1/drivers/scsi/scsi_transport_fc.c	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_transport_fc.c	2004-05-26 23:36:07.000000000 -0700
@@ -19,6 +19,7 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kobject.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -26,7 +27,11 @@
 
 #define FC_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
 
-static void transport_class_release(struct class_device *class_dev);
+struct fc_sdev_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct scsi_device *, char *);
+	ssize_t (*store)(struct scsi_device *, const char *, size_t);
+};
 
 #define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
@@ -35,15 +40,22 @@ static void transport_class_release(stru
 struct fc_internal {
 	struct scsi_transport_template t;
 	struct fc_function_template *f;
+	struct kobj_type sdev_attrs;
 	/* The actual attributes */
-	struct class_device_attribute private_attrs[FC_NUM_ATTRS];
+	struct fc_sdev_attribute private_attrs[FC_NUM_ATTRS];
 	/* The array of null terminated pointers to attributes
-	 * needed by scsi_sysfs.c */
-	struct class_device_attribute *attrs[FC_NUM_ATTRS + FC_OTHER_ATTRS + 1];
+	 * needed by the kobj_type */
+	struct attribute *attrs[FC_NUM_ATTRS + FC_OTHER_ATTRS + 1];
 };
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
 
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
+	put_device(&shost->shost_gendev);
+}
+
 struct class fc_transport_class = {
 	.name = "fc_transport",
 	.release = transport_class_release,
@@ -59,6 +71,37 @@ static void __exit fc_transport_exit(voi
 	class_unregister(&fc_transport_class);
 }
 
+/*
+ * fc_link_up/down - Fires off a hotplug event.
+ * @shost	host to send an event for.
+ *
+ * Sends a hotplug event to userspace utilizing the
+ * kobject infrastructure.
+ */
+void fc_link_up(struct Scsi_Host *shost)
+{
+	struct kobject *kobj;
+
+	if (!shost)
+		return;
+
+	kobj = &shost->transport_classdev.kobj;
+	kobject_hotplug("fc_link_up", kobj);
+}
+EXPORT_SYMBOL(fc_link_up);
+
+void fc_link_down(struct Scsi_Host *shost)
+{
+	struct kobject *kobj;
+
+	if (!shost)
+		return;
+
+	kobj = &shost->transport_classdev.kobj;
+	kobject_hotplug("fc_link_down", kobj);
+}
+EXPORT_SYMBOL(fc_link_down);
+
 static int fc_setup_transport_attrs(struct scsi_device *sdev)
 {
 	/* I'm not sure what values are invalid.  We should pick some invalid
@@ -70,18 +113,20 @@ static int fc_setup_transport_attrs(stru
 	return 0;
 }
 
-static void transport_class_release(struct class_device *class_dev)
-{
-	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
-	put_device(&sdev->sdev_gendev);
-}
+#define FC_SDEV_ATTR(_name,_mode,_show,_store)		\
+struct fc_sdev_attribute fc_sdev_attr_##_name = { 	\
+	.attr = {.name = __stringify(_name),		\
+		 .mode = _mode,				\
+		 .owner = THIS_MODULE },		\
+	.show	= _show,				\
+	.store	= _store,				\
+};
 
 #define fc_transport_show_function(field, format_string, cast)		\
 									\
 static ssize_t								\
-show_fc_transport_##field (struct class_device *cdev, char *buf)	\
+show_fc_transport_##field (struct scsi_device *sdev, char *buf)		\
 {									\
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
 	struct fc_transport_attrs *tp;					\
 	struct fc_internal *i = to_fc_internal(sdev->host->transportt);	\
 	tp = (struct fc_transport_attrs *)&sdev->transport_data;	\
@@ -92,11 +137,10 @@ show_fc_transport_##field (struct class_
 
 #define fc_transport_store_function(field, format_string)		\
 static ssize_t								\
-store_fc_transport_##field(struct class_device *cdev, const char *buf,	\
+store_fc_transport_##field(struct scsi_device *sdev, const char *buf,	\
 			   size_t count)				\
 {									\
 	int val;							\
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
 	struct fc_internal *i = to_fc_internal(sdev->host->transportt);	\
 									\
 	val = simple_strtoul(buf, NULL, 0);				\
@@ -106,18 +150,18 @@ store_fc_transport_##field(struct class_
 
 #define fc_transport_rd_attr(field, format_string)			\
 	fc_transport_show_function(field, format_string, )		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
+static FC_SDEV_ATTR(field, S_IRUGO,					\
 			 show_fc_transport_##field, NULL)
 
 #define fc_transport_rd_attr_cast(field, format_string, cast)		\
 	fc_transport_show_function(field, format_string, (cast))	\
-static CLASS_DEVICE_ATTR( field, S_IRUGO,				\
+static FC_SDEV_ATTR( field, S_IRUGO,					\
 			  show_fc_transport_##field, NULL)
 
 #define fc_transport_rw_attr(field, format_string)			\
 	fc_transport_show_function(field, format_string, )		\
 	fc_transport_store_function(field, format_string)		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+static FC_SDEV_ATTR(field, S_IRUGO | S_IWUSR,				\
 			show_fc_transport_##field,			\
 			store_fc_transport_##field)
 
@@ -126,21 +170,56 @@ fc_transport_rd_attr_cast(node_name, "0x
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
 
+#define to_sdev_attr(_attr) \
+	container_of((_attr), struct fc_sdev_attribute, attr)
+
+static ssize_t fc_sdev_attr_show(struct kobject *kobj, struct attribute *attr,
+				 char *page)
+{
+	struct fc_sdev_attribute *fc_attr = to_sdev_attr(attr);
+	struct scsi_device *sdev = transport_class_to_sdev(kobj);
+	return fc_attr->show(sdev, page);
+}
+
+static ssize_t fc_sdev_attr_store(struct kobject *kobj, struct attribute *attr,
+				  const char *page, size_t length)
+{
+	struct fc_sdev_attribute *fc_attr = to_sdev_attr(attr);
+	struct scsi_device *sdev = transport_class_to_sdev(kobj);
+	return fc_attr->store(sdev, page, length);
+}
+
+static struct sysfs_ops fc_sdev_sysfs_ops = {
+	.show	= fc_sdev_attr_show,
+	.store	= fc_sdev_attr_store,
+};
+
+static void fc_sdev_release(struct kobject * kobj)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(kobj);
+	put_device(&sdev->sdev_gendev);
+}
+
+struct kobj_type fc_sdev_ktype = {
+	.release	= fc_sdev_release,
+	.sysfs_ops	= &fc_sdev_sysfs_ops,
+};
+
 #define SETUP_ATTRIBUTE_RD(field)				\
-	i->private_attrs[count] = class_device_attr_##field;	\
+	i->private_attrs[count] = fc_sdev_attr_##field;		\
 	i->private_attrs[count].attr.mode = S_IRUGO;		\
 	i->private_attrs[count].store = NULL;			\
-	i->attrs[count] = &i->private_attrs[count];		\
+	i->attrs[count] = &i->private_attrs[count].attr;	\
 	if (i->f->show_##field)					\
 		count++
 
 #define SETUP_ATTRIBUTE_RW(field)				\
-	i->private_attrs[count] = class_device_attr_##field;	\
+	i->private_attrs[count] = fc_sdev_attr_##field;		\
 	if (!i->f->set_##field) {				\
 		i->private_attrs[count].attr.mode = S_IRUGO;	\
 		i->private_attrs[count].store = NULL;		\
 	}							\
-	i->attrs[count] = &i->private_attrs[count];		\
+	i->attrs[count] = &i->private_attrs[count].attr;	\
 	if (i->f->show_##field)					\
 		count++
 
@@ -156,7 +235,11 @@ fc_attach_transport(struct fc_function_t
 
 	memset(i, 0, sizeof(struct fc_internal));
 
-	i->t.attrs = &i->attrs[0];
+	i->sdev_attrs.release = fc_sdev_release;
+	i->sdev_attrs.sysfs_ops = &fc_sdev_sysfs_ops;
+	i->sdev_attrs.default_attrs = &i->attrs[0];
+ 
+	i->t.sdev_attrs = &i->sdev_attrs;
 	i->t.class = &fc_transport_class;
 	i->t.setup = &fc_setup_transport_attrs;
 	i->t.size = sizeof(struct fc_transport_attrs);
diff -arup linux-2.6.7-rc1/include/scsi/scsi_transport.h linux-2.6.7-rc1-hotplug/include/scsi/scsi_transport.h
--- linux-2.6.7-rc1/include/scsi/scsi_transport.h	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/include/scsi/scsi_transport.h	2004-05-26 23:35:37.000000000 -0700
@@ -21,15 +21,15 @@
 #define SCSI_TRANSPORT_H
 
 struct scsi_transport_template {
-	/* The NULL terminated list of transport attributes
-	 * that should be exported.
-	 */
-	struct class_device_attribute **attrs;
-
-	/* The transport class that the device is in */
+	/* The transport class that the adapter is in */
 	struct class *class;
 
-	/* Constructor/Destructor functions */
+	/*
+	 * The device specific attributes that should be exported
+	 */
+	struct kobj_type *sdev_attrs;
+
+	/* device Constructor/Destructor functions */
 	int (* setup)(struct scsi_device *);
 	void (* cleanup)(struct scsi_device *);
 	/* The size of the specific transport attribute structure (a

--------------000805070704040501010503--

