From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH][RFC] iSCSI transport class
Date: Fri, 26 Mar 2004 12:50:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4064979E.3020208@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020002080301040909030907"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49676 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261239AbUCZUuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 15:50:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--------------020002080301040909030907
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is the begining of an iSCSI transport class. Currently,
the Cisco driver has some sysfs issues, so the patch in the next
mail will convert their print_info attribute to use this class
instead.

This patch was built against 2.6.5-rc2. And, here is a tree. Not
much yet, so please send comments. Maybe it should be per session
instead of per device?

[mc@minna 1:0:0:0]$ pwd
/sys/class/iscsi_transport/1:0:0:0
[mc@minna 1:0:0:0]$ tree
.
|-- device -> ../../../devices/platform/iscsi/1:0:0:0
|-- driver -> ../../../bus/scsi/drivers/sd
|-- target_addr
|-- target_name
`-- target_port

Mike Christie

--------------020002080301040909030907
Content-Type: text/plain;
 name="iscsi-transport-class.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iscsi-transport-class.patch"

diff -Naurp linux-2.6.5-rc2/drivers/scsi/Kconfig linux-2.6.5-rc2-iscsi/drivers/scsi/Kconfig
--- linux-2.6.5-rc2/drivers/scsi/Kconfig	2004-03-19 16:11:42.000000000 -0800
+++ linux-2.6.5-rc2-iscsi/drivers/scsi/Kconfig	2004-03-25 01:26:32.000000000 -0800
@@ -214,6 +214,14 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config SCSI_ISCSI_ATTRS
+	tristate "iSCSI Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached iSCSI device to sysfs, say Y.
+	  Otherwise, say N.
+
 endmenu
 
 menu "SCSI low-level drivers"
diff -Naurp linux-2.6.5-rc2/drivers/scsi/Makefile linux-2.6.5-rc2-iscsi/drivers/scsi/Makefile
--- linux-2.6.5-rc2/drivers/scsi/Makefile	2004-03-19 16:11:40.000000000 -0800
+++ linux-2.6.5-rc2-iscsi/drivers/scsi/Makefile	2004-03-25 01:34:52.000000000 -0800
@@ -28,6 +28,7 @@ obj-$(CONFIG_SCSI)		+= scsi_mod.o
 # --------------------------
 obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
+obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 
 
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
diff -Naurp linux-2.6.5-rc2/drivers/scsi/scsi_transport_iscsi.c linux-2.6.5-rc2-iscsi/drivers/scsi/scsi_transport_iscsi.c
--- linux-2.6.5-rc2/drivers/scsi/scsi_transport_iscsi.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.5-rc2-iscsi/drivers/scsi/scsi_transport_iscsi.c	2004-03-25 01:26:26.000000000 -0800
@@ -0,0 +1,133 @@
+/* 
+ * iSCSI sysfs attributes.
+ *
+ * Copyright (C) IBM
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
+
+#define ISCSI_NUM_ATTRS 3	/* increase this if you add attributes */
+
+struct iscsi_internal {
+	struct scsi_transport_template t;
+	struct iscsi_function_template *f;
+	/* The actual attributes */
+	struct class_device_attribute private_attrs[ISCSI_NUM_ATTRS];
+	/* The array of null terminated pointers to attributes 
+	 * needed by scsi_sysfs.c */
+	struct class_device_attribute *attrs[ISCSI_NUM_ATTRS + 1];
+};
+
+#define to_iscsi_internal(tmpl) container_of(tmpl, struct iscsi_internal, t)
+
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+struct class iscsi_transport_class = {
+	.name = "iscsi_transport",
+	.release = transport_class_release,
+};
+
+#define iscsi_transport_show_function(field)				\
+									\
+static ssize_t								\
+show_iscsi_transport_##field(struct class_device *cdev, char *buf)	\
+{									\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct iscsi_internal *i = to_iscsi_internal(sdev->host->transportt); \
+	return i->f->get_##field(sdev, buf);				\
+}
+
+#define iscsi_transport_rd_attr(field)					\
+	iscsi_transport_show_function(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_iscsi_transport_##field, NULL)
+
+iscsi_transport_rd_attr(target_port);
+iscsi_transport_rd_attr(target_name);
+iscsi_transport_rd_attr(target_addr);
+
+#define SETUP_ATTRIBUTE(ft, field)					\
+	if (ft->get_##field) {						\
+		i->private_attrs[count] = class_device_attr_##field;	\
+		i->attrs[count] = &i->private_attrs[count];		\
+		count++;						\
+	}
+
+struct scsi_transport_template *
+iscsi_attach_transport(struct iscsi_function_template *ft)
+{
+	struct iscsi_internal *i = kmalloc(sizeof(struct iscsi_internal),
+					   GFP_KERNEL);
+	int count = 0;
+	if (unlikely(!i))
+		return NULL;
+
+	memset(i, 0, sizeof(struct iscsi_internal));
+
+	i->t.attrs = &i->attrs[0];
+	i->t.class = &iscsi_transport_class;
+	i->t.size = 0;
+	i->f = ft;
+
+	SETUP_ATTRIBUTE(ft, target_port);
+	SETUP_ATTRIBUTE(ft, target_name);
+	SETUP_ATTRIBUTE(ft, target_addr);
+	i->attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(iscsi_attach_transport);
+
+void iscsi_release_transport(struct scsi_transport_template *t)
+{
+	struct iscsi_internal *i = to_iscsi_internal(t);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(iscsi_release_transport);
+
+
+static __init int iscsi_transport_init(void)
+{
+	return class_register(&iscsi_transport_class);
+}
+
+static void __exit iscsi_transport_exit(void)
+{
+	class_unregister(&iscsi_transport_class);
+}
+
+module_init(iscsi_transport_init);
+module_exit(iscsi_transport_exit);
+
+MODULE_AUTHOR("Mike Christie");
+MODULE_DESCRIPTION("iSCSI Transport Attributes");
+MODULE_LICENSE("GPL");
+
diff -Naurp linux-2.6.5-rc2/include/scsi/scsi_transport_iscsi.h linux-2.6.5-rc2-iscsi/include/scsi/scsi_transport_iscsi.h
--- linux-2.6.5-rc2/include/scsi/scsi_transport_iscsi.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.5-rc2-iscsi/include/scsi/scsi_transport_iscsi.h	2004-03-25 01:26:02.000000000 -0800
@@ -0,0 +1,41 @@
+/* 
+ * iSCSI sysfs attributes.
+ *
+ * Copyright (C) IBM
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef SCSI_TRANSPORT_ISCSI_H
+#define SCSI_TRANSPORT_ISCSI_H
+
+#include <linux/config.h>
+
+struct scsi_transport_template;
+
+/* The functions by which the transport class and the driver communicate */
+struct iscsi_function_template {
+	ssize_t (*get_target_port)(struct scsi_device *, char *);
+	ssize_t (*get_target_addr)(struct scsi_device *, char *);
+	ssize_t (*get_target_name)(struct scsi_device *, char *);
+};
+
+struct scsi_transport_template *iscsi_attach_transport(struct iscsi_function_template *);
+void iscsi_release_transport(struct scsi_transport_template *t);
+
+#endif /* SCSI_TRANSPORT_ISCSI_H */

--------------020002080301040909030907--

