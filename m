From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] Update FC transport attributes API
Date: Mon, 22 Mar 2004 13:35:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040322183535.GS19428@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XF85m9dhOBO43t/C"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:34242 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S262213AbUCVSfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 13:35:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi,

This patch brings the FC transport attributes up to date with the SPI
attributes API.

The only major change I made was to separate read-only attributes
from read-write attributes.

thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fc-trans-attr-update.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1830  -> 1.1831 
#	drivers/scsi/scsi_transport_fc.c	1.1     -> 1.2    
#	include/scsi/scsi_transport_fc.h	1.1     -> 1.2    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/22	mort@tomahawk.engr.sgi.com	1.1831
# Update FC transport attributes API
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Mon Mar 22 10:33:42 2004
+++ b/drivers/scsi/scsi_transport_fc.c	Mon Mar 22 10:33:42 2004
@@ -24,8 +24,26 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
+#define FC_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
+
 static void transport_class_release(struct class_device *class_dev);
 
+#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
+				 * attributes */
+
+struct fc_internal {
+	struct scsi_transport_template t;
+	struct fc_function_template *f;
+	/* The actual attributes */
+	struct class_device_attribute private_attrs[FC_NUM_ATTRS];
+	/* The array of null terminated pointers to attributes
+	 * needed by scsi_sysfs.c */
+	struct class_device_attribute *attrs[FC_NUM_ATTRS + FC_OTHER_ATTRS + 1];
+};
+
+#define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
+
 struct class fc_transport_class = {
 	.name = "fc_transport",
 	.release = transport_class_release,
@@ -43,7 +61,8 @@
 
 static int fc_setup_transport_attrs(struct scsi_device *sdev)
 {
-	/* FIXME: Callback into the driver */
+	/* I'm not sure what values are invalid.  We should pick some invalid
+	 * values for the defaults */
 	fc_node_name(sdev) = -1;
 	fc_port_name(sdev) = -1;
 	fc_port_id(sdev) = -1;
@@ -57,44 +76,114 @@
 	put_device(&sdev->sdev_gendev);
 }
 
-#define fc_transport_show_function(field, format_string, cast)			\
-static ssize_t									\
-show_fc_transport_##field (struct class_device *cdev, char *buf)		\
-{										\
-	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
-	struct fc_transport_attrs *tp;						\
-	tp = (struct fc_transport_attrs *)&sdev->transport_data;		\
-	return snprintf(buf, 20, format_string, cast tp->field);		\
-}
-
-#define fc_transport_rd_attr(field, format_string)				\
-	fc_transport_show_function(field, format_string, )			\
-static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
-
-#define fc_transport_rd_attr_cast(field, format_string, cast)			\
-	fc_transport_show_function(field, format_string, (cast))		\
-static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
+#define fc_transport_show_function(field, format_string, cast)		\
+									\
+static ssize_t								\
+show_fc_transport_##field (struct class_device *cdev, char *buf)	\
+{									\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct fc_transport_attrs *tp;					\
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);	\
+	tp = (struct fc_transport_attrs *)&sdev->transport_data;	\
+	if (i->f->get_##field)						\
+		i->f->get_##field(sdev);				\
+	return snprintf(buf, 20, format_string, cast tp->field);	\
+}
+
+#define fc_transport_store_function(field, format_string)		\
+static ssize_t								\
+store_fc_transport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	int val;							\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct fc_internal *i = to_fc_internal(sdev->host->transportt);	\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->f->set_##field(sdev, val);					\
+	return count;							\
+}
+
+#define fc_transport_rd_attr(field, format_string)			\
+	fc_transport_show_function(field, format_string, )		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
+			 show_fc_transport_##field, NULL)
+
+#define fc_transport_rd_attr_cast(field, format_string, cast)		\
+	fc_transport_show_function(field, format_string, (cast))	\
+static CLASS_DEVICE_ATTR( field, S_IRUGO,				\
+			  show_fc_transport_##field, NULL)
+
+#define fc_transport_rw_attr(field, format_string)			\
+	fc_transport_show_function(field, format_string, )		\
+	fc_transport_store_function(field, format_string)		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			show_fc_transport_##field,			\
+			store_fc_transport_##field)
 
 /* the FiberChannel Tranport Attributes: */
 fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
 
-struct class_device_attribute *fc_transport_attrs[] = {
-	&class_device_attr_node_name,
-	&class_device_attr_port_name,
-	&class_device_attr_port_id,
-	NULL
-};
+#define SETUP_ATTRIBUTE_RD(field)				\
+	i->private_attrs[count] = class_device_attr_##field;	\
+	i->private_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_attrs[count].store = NULL;			\
+	i->attrs[count] = &i->private_attrs[count];		\
+	if (i->f->show_##field)					\
+		count++
+
+#define SETUP_ATTRIBUTE_RW(field)				\
+	i->private_attrs[count] = class_device_attr_##field;	\
+	if (!i->f->set_##field) {				\
+		i->private_attrs[count].attr.mode = S_IRUGO;	\
+		i->private_attrs[count].store = NULL;		\
+	}							\
+	i->attrs[count] = &i->private_attrs[count];		\
+	if (i->f->show_##field)					\
+		count++
+
+struct scsi_transport_template *
+fc_attach_transport(struct fc_function_template *ft)
+{
+	struct fc_internal *i = kmalloc(sizeof(struct fc_internal),
+					GFP_KERNEL);
+	int count = 0;
+
+	if (unlikely(!i))
+		return NULL;
+
+	memset(i, 0, sizeof(struct fc_internal));
+
+	i->t.attrs = &i->attrs[0];
+	i->t.class = &fc_transport_class;
+	i->t.setup = &fc_setup_transport_attrs;
+	i->t.size = sizeof(struct fc_transport_attrs) - sizeof(unsigned long);
+	i->f = ft;
+
+	SETUP_ATTRIBUTE_RD(port_id);
+	SETUP_ATTRIBUTE_RD(port_name);
+	SETUP_ATTRIBUTE_RD(node_name);
+
+	BUG_ON(count > FC_NUM_ATTRS);
+
+	/* Setup the always-on attributes here */
+
+	i->attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(fc_attach_transport);
+
+void fc_release_transport(struct scsi_transport_template *t)
+{
+	struct fc_internal *i = to_fc_internal(t);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(fc_release_transport);
 
-struct scsi_transport_template fc_transport_template = {
-	.attrs = fc_transport_attrs,
-	.class = &fc_transport_class,
-	.setup = &fc_setup_transport_attrs,
-	.cleanup = NULL,
-	.size = sizeof(struct fc_transport_attrs) - sizeof(unsigned long),
-};
-EXPORT_SYMBOL(fc_transport_template);
 
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("FC Transport Attributes");
diff -Nru a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	Mon Mar 22 10:33:42 2004
+++ b/include/scsi/scsi_transport_fc.h	Mon Mar 22 10:33:42 2004
@@ -20,6 +20,8 @@
 #ifndef SCSI_TRANSPORT_FC_H
 #define SCSI_TRANSPORT_FC_H
 
+#include <linux/config.h>
+
 struct scsi_transport_template;
 
 struct fc_transport_attrs {
@@ -33,6 +35,22 @@
 #define fc_node_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->node_name)
 #define fc_port_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_name)
 
-extern struct scsi_transport_template fc_transport_template;
+/* The functions by which the transport class and the driver communicate */
+struct fc_function_template {
+	void 	(*get_port_id)(struct scsi_device *);
+	void	(*get_node_name)(struct scsi_device *);
+	void	(*get_port_name)(struct scsi_device *);
+	/* The driver sets these to tell the transport class it
+	 * wants the attributes displayed in sysfs.  If the show_ flag
+	 * is not set, the attribute will be private to the transport
+	 * class */
+	unsigned long	show_port_id:1;
+	unsigned long	show_node_name:1;
+	unsigned long	show_port_name:1;
+	/* Private Attributes */
+};
+
+struct scsi_transport_template *fc_attach_transport(struct fc_function_template *);
+void fc_release_transport(struct scsi_transport_template *);
 
 #endif /* SCSI_TRANSPORT_FC_H */

--XF85m9dhOBO43t/C--
