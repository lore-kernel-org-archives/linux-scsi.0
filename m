From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Wed, 2 Mar 2005 11:46:47 -0800
Message-ID: <20050302194647.GB9776@us.ibm.com>
References: <20050302194432.GA9743@us.ibm.com> <20050302194553.GA9776@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e33.co.us.ibm.com ([32.97.110.131]:15812 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262442AbVCBTq5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 14:46:57 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j22Jku0D671070
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 14:46:56 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j22JktdB134968
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 12:46:55 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j22JktFY028534
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 12:46:55 -0700
Content-Disposition: inline
In-Reply-To: <20050302194553.GA9776@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

Use bus dev_attrs to create the default scsi_device attributes.

Note sdev_default_attrs is not a pointer to an array (like
scsi_sysfs_sdev_attrs), and so DEVICE_ATTR's can be removed, and __ATTR
used instaed.

Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>

--- sattrs-linux-2.6.11/drivers/scsi/s1-scsi_sysfs.c	2005-03-02 09:58:21.000000000 -0800
+++ sattrs-linux-2.6.11/drivers/scsi/scsi_sysfs.c	2005-03-02 10:22:25.000000000 -0800
@@ -193,40 +193,6 @@
 	.release	= scsi_device_cls_release,
 };
 
-/* all probing is done in the individual ->probe routines */
-static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
-{
-	struct scsi_device *sdp = to_scsi_device(dev);
-	if (sdp->no_uld_attach)
-		return 0;
-	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
-}
-
-struct bus_type scsi_bus_type = {
-        .name		= "scsi",
-        .match		= scsi_bus_match,
-};
-
-int scsi_sysfs_register(void)
-{
-	int error;
-
-	error = bus_register(&scsi_bus_type);
-	if (!error) {
-		error = class_register(&sdev_class);
-		if (error)
-			bus_unregister(&scsi_bus_type);
-	}
-
-	return error;
-}
-
-void scsi_sysfs_unregister(void)
-{
-	class_unregister(&sdev_class);
-	bus_unregister(&scsi_bus_type);
-}
-
 /*
  * sdev_show_function: macro to create an attr function that can be used to
  * show a non-bit field.
@@ -245,8 +211,7 @@
  * read only field.
  */
 #define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)			\
-static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
+	sdev_show_function(field, format_string)
 
 
 /*
@@ -263,8 +228,7 @@
 	sdev = to_scsi_device(dev);					\
 	snscanf (buf, 20, format_string, &sdev->field);			\
 	return count;							\
-}									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
+}
 
 /* Currently we don't export bit fields, but we might in future,
  * so leave this code in */
@@ -288,8 +252,7 @@
 		ret = count;						\
 	}								\
 	return ret;							\
-}									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
+}
 
 /*
  * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
@@ -336,15 +299,13 @@
 	sdev->timeout = timeout * HZ;
 	return count;
 }
-static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
-store_rescan_field (struct device *dev, const char *buf, size_t count) 
+sdev_store_rescan (struct device *dev, const char *buf, size_t count) 
 {
 	scsi_rescan_device(dev);
 	return count;
 }
-static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
 static ssize_t sdev_store_delete(struct device *dev, const char *buf,
 				 size_t count)
@@ -352,10 +313,9 @@
 	scsi_remove_device(to_scsi_device(dev));
 	return count;
 };
-static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
 static ssize_t
-store_state_field(struct device *dev, const char *buf, size_t count)
+sdev_store_state(struct device *dev, const char *buf, size_t count)
 {
 	int i;
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -378,7 +338,7 @@
 }
 
 static ssize_t
-show_state_field(struct device *dev, char *buf)
+sdev_show_state(struct device *dev, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	const char *name = scsi_device_state_name(sdev->sdev_state);
@@ -389,8 +349,6 @@
 	return snprintf(buf, 20, "%s\n", name);
 }
 
-static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
-
 sdev_show_function (queue_depth, "%d\n");
 
 static ssize_t sdev_store_queue_depth(struct device *dev, const char *buf,
@@ -420,7 +378,7 @@
 	       sdev_store_queue_depth);
 
 static ssize_t
-show_queue_type_field(struct device *dev, char *buf)
+sdev_show_queue_type(struct device *dev, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	const char *name = "none";
@@ -461,25 +419,29 @@
 	return count;
 }
 
-static struct device_attribute dev_attr_queue_type =
-	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
-	       sdev_store_queue_type);
+#define SDEV_ATTR_RO(_name) __ATTR(_name, S_IRUGO, sdev_show_##_name, NULL)
+#define SDEV_ATTR_WO(_name) __ATTR(_name, S_IWUSR, NULL, sdev_store_##_name)
+#define SDEV_ATTR_RW(_name) __ATTR(_name, S_IRUGO | S_IWUSR, \
+				   sdev_show_##_name, sdev_store_##_name)
+
+/* Default scsi_device attributes, cannot be overidden */
+static struct device_attribute sdev_default_attrs[] = {
+	SDEV_ATTR_RO(device_blocked),
+	SDEV_ATTR_RW(queue_type),
+	SDEV_ATTR_RO(type),
+	SDEV_ATTR_RO(scsi_level),
+	SDEV_ATTR_RO(vendor),
+	SDEV_ATTR_RO(model),
+	SDEV_ATTR_RO(rev),
+	SDEV_ATTR_WO(rescan),
+	SDEV_ATTR_WO(delete),
+	SDEV_ATTR_RW(state),
+	SDEV_ATTR_RW(timeout),
+	__ATTR_NULL
+};
 
-/* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
-	&dev_attr_device_blocked,
-	&dev_attr_queue_depth,
-	&dev_attr_queue_type,
-	&dev_attr_type,
-	&dev_attr_scsi_level,
-	&dev_attr_vendor,
-	&dev_attr_model,
-	&dev_attr_rev,
-	&dev_attr_rescan,
-	&dev_attr_delete,
-	&dev_attr_state,
-	&dev_attr_timeout,
-	NULL
+	&dev_attr_queue_depth
 };
 
 static struct device_attribute *attr_overridden(
@@ -518,6 +480,41 @@
 	return device_create_file(dev, attr);
 }
 
+/* all probing is done in the individual ->probe routines */
+static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	if (sdp->no_uld_attach)
+		return 0;
+	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
+}
+
+struct bus_type scsi_bus_type = {
+        .name		= "scsi",
+        .match		= scsi_bus_match,
+	.dev_attrs	= sdev_default_attrs,
+};
+
+int scsi_sysfs_register(void)
+{
+	int error;
+
+	error = bus_register(&scsi_bus_type);
+	if (!error) {
+		error = class_register(&sdev_class);
+		if (error)
+			bus_unregister(&scsi_bus_type);
+	}
+
+	return error;
+}
+
+void scsi_sysfs_unregister(void)
+{
+	class_unregister(&sdev_class);
+	bus_unregister(&scsi_bus_type);
+}
+
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct scsi_target *starget = to_scsi_target(dev);
