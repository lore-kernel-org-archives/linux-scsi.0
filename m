From: Martin Hicks <mort@wildopensource.com>
Subject: Transport Attributes -- attempt#2
Date: Wed, 7 Jan 2004 13:54:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040107185420.GA30627@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:32409 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265540AbUAGSy1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2004 13:54:27 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi,

Here's my next whack at export Transport-specific attributes to sysfs.

This version has the following changes.  The person who suggested the
change is quoted in brackets.

-Stuck the transport attributes and trancport class pointer into the
 host template. (hch)

-Separated the two classes into their own .c files. (jejb)

-Removed attribute overloading. (jejb)

The number of changes that must be done in the host driver are much
smaller now, and I think the whole idea is a little cleaner.  Removing
the attribute overloading really cleaned things up a lot.

There are three patches attached.  The core patch, and two driver
patches (qla2xxx and qla1280).

Opinions or other comments are welcome.
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-core-v3-3.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1520  -> 1.1521 
#	include/scsi/scsi_device.h	1.11    -> 1.12   
#	include/scsi/scsi_host.h	1.13    -> 1.14   
#	drivers/scsi/scsi_sysfs.c	1.38    -> 1.39   
#	drivers/scsi/scsi_scan.c	1.114   -> 1.115  
#	drivers/scsi/Makefile	1.50    -> 1.51   
#	drivers/scsi/Kconfig	1.47    -> 1.48   
#	               (new)	        -> 1.1     drivers/scsi/scsi_transport.c
#	               (new)	        -> 1.1     include/scsi/scsi_transport.h
#	               (new)	        -> 1.1     include/scsi/scsi_transport_pscsi.h
#	               (new)	        -> 1.1     include/scsi/scsi_transport_fc.h
#	               (new)	        -> 1.1     drivers/scsi/scsi_transport_pscsi.c
#	               (new)	        -> 1.1     drivers/scsi/scsi_transport_fc.c
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/07	mort@tomahawk.engr.sgi.com	1.1521
# Add the transport attributes core.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Wed Jan  7 10:39:14 2004
+++ b/drivers/scsi/Kconfig	Wed Jan  7 10:39:14 2004
@@ -196,6 +196,25 @@
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+menu "SCSI Transport Attributes (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && SCSI!=n
+
+config SCSI_PSCSI_ATTRS
+	bool "Parallel SCSI Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached SCSI device to sysfs, say Y.  Otherwise, say N.
+
+config SCSI_FC_ATTRS
+	bool "FiberChannel Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached FiberChannel device to sysfs, say Y.
+	  Otherwise, say N.
+
+endmenu
 
 menu "SCSI low-level drivers"
 	depends on SCSI!=n
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Wed Jan  7 10:39:14 2004
+++ b/drivers/scsi/Makefile	Wed Jan  7 10:39:14 2004
@@ -127,14 +127,17 @@
 obj-$(CONFIG_BLK_DEV_SR)	+= sr_mod.o
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 
+obj-$(CONFIG_SCSI_PSCSI_ATTRS)	+= scsi_transport_pscsi.o
+obj-$(CONFIG_SCSI_FC_ATTRS)	+= scsi_transport_fc.o
+
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o \
 				   scsi_scan.o scsi_syms.o scsi_sysfs.o \
-				   scsi_devinfo.o
+				   scsi_devinfo.o scsi_transport.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-$(CONFIG_X86_PC9800)	+= scsi_pc98.o
-			
+
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 initio-objs	:= ini9100u.o i91uscsi.o
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Wed Jan  7 10:39:14 2004
+++ b/drivers/scsi/scsi_scan.c	Wed Jan  7 10:39:14 2004
@@ -238,7 +238,6 @@
 	}
 
 	if (get_device(&sdev->host->shost_gendev)) {
-
 		device_initialize(&sdev->sdev_gendev);
 		sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
 		sdev->sdev_gendev.bus = &scsi_bus_type;
@@ -251,6 +250,13 @@
 		sdev->sdev_classdev.dev = &sdev->sdev_gendev;
 		sdev->sdev_classdev.class = &sdev_class;
 		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
+			 "%d:%d:%d:%d", sdev->host->host_no,
+			 sdev->channel, sdev->id, sdev->lun);
+
+		class_device_initialize(&sdev->transport_classdev);
+		sdev->transport_classdev.dev = &sdev->sdev_gendev;
+		sdev->transport_classdev.class = sdev->host->hostt->transport_class;
+		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
 			 "%d:%d:%d:%d", sdev->host->host_no,
 			 sdev->channel, sdev->id, sdev->lun);
 	} else
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Wed Jan  7 10:39:14 2004
+++ b/drivers/scsi/scsi_sysfs.c	Wed Jan  7 10:39:14 2004
@@ -13,6 +13,9 @@
 #include <linux/device.h>
 
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_pscsi.h>
+#include <scsi/scsi_transport_fc.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -162,13 +165,41 @@
 	int error;
 
 	error = bus_register(&scsi_bus_type);
-	if (!error) {
-		error = class_register(&sdev_class);
-		if (error)
-			bus_unregister(&scsi_bus_type);
-	}
+	if (error)
+		return error;
+
+	error = class_register(&sdev_class);
+	if (error)
+		goto undo_bus;
+
+#ifdef CONFIG_SCSI_PSCSI_ATTRS
+	error = scsi_pscsi_transport_init();
+	if (error)
+		goto undo_sdev;
+#endif
+#ifdef CONFIG_SCSI_FC_ATTRS
+	error = scsi_fc_transport_init();
+	if (error)
+		goto undo_all;
+#endif
 
+ out:
 	return error;
+
+	/* Prevent "unused label" warnings when either of the
+	 * transport attributes config options are turned off. */
+	goto undo_all;
+	goto undo_sdev;
+
+ undo_all:
+#ifdef CONFIG_SCSI_PSCSI_ATTRS
+	scsi_pscsi_transport_exit();
+#endif
+ undo_sdev:
+	class_unregister(&sdev_class);
+ undo_bus:
+	bus_unregister(&scsi_bus_type);
+	goto out;
 }
 
 void scsi_sysfs_unregister(void)
@@ -364,6 +395,12 @@
 		return error;
 	}
 
+	if (sdev->transport_classdev.class) {
+		error = class_device_add(&sdev->transport_classdev);
+		if (error)
+			goto clean_device2;
+	}
+
 	get_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->sdev_attrs) {
@@ -385,9 +422,17 @@
 		}
 	}
 
+	if (sdev->transport_classdev.class) {
+		error = scsi_add_transport_attributes(sdev);
+		if (error)
+			scsi_remove_device(sdev);
+	}
+
 	return error;
 
-clean_device:
+ clean_device2:
+	class_device_del(&sdev->sdev_classdev);
+ clean_device:
 	sdev->sdev_state = SDEV_CANCEL;
 
 	device_del(&sdev->sdev_gendev);
diff -Nru a/drivers/scsi/scsi_transport.c b/drivers/scsi/scsi_transport.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport.c	Wed Jan  7 10:39:14 2004
@@ -0,0 +1,39 @@
+/* 
+ *  Transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/config.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_pscsi.h>
+#include <scsi/scsi_transport_fc.h>
+
+int scsi_add_transport_attributes(struct scsi_device *sdev)
+{
+	int error, i;
+	struct class_device_attribute **attrs = sdev->host->hostt->transport_attrs;
+
+	for (i = 0; attrs[i]; i++) {
+                error = class_device_create_file(&sdev->transport_classdev,
+                                                 attrs[i]);
+                if (error)
+                        return error;
+        }
+        return 0;
+}
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_fc.c	Wed Jan  7 10:39:14 2004
@@ -0,0 +1,108 @@
+/* 
+ *  FiberChannel transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+
+struct class fc_transport_class = {
+	.name = "fc_transport",
+	.release = transport_class_release,
+};
+
+
+#define fc_transport_show_function(field, format_string, cast)			\
+static ssize_t									\
+show_fc_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct fc_transport_attrs *tp;						\
+	tp = (struct fc_transport_attrs *)sdev->transport_attr_values;		\
+	return snprintf(buf, 20, format_string, cast tp->field);		\
+}
+
+#define fc_transport_rd_attr(field, format_string)				\
+	fc_transport_show_function(field, format_string, )			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
+
+#define fc_transport_rd_attr_cast(field, format_string, cast)			\
+	fc_transport_show_function(field, format_string, (cast))		\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
+
+
+/* the FiberChannel Tranport Attributes: */
+fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
+fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
+fc_transport_rd_attr(port_id, "0x%x\n");
+
+struct class_device_attribute *fc_transport_attrs[] = {
+	&class_device_attr_node_name,
+	&class_device_attr_port_name,
+	&class_device_attr_port_id,
+	NULL
+};
+
+
+int scsi_fc_transport_init(void)
+{
+	return class_register(&fc_transport_class);
+}
+
+void scsi_fc_tranport_exit(void)
+{
+	class_unregister(&fc_transport_class);
+}
+
+void scsi_sysfs_cleanup_fc_transport(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attr_values);
+	put_device(&sdev->host->shost_gendev);
+}
+
+/* Allocates the struct to place the attribute values in.
+ * Usually called from the scsi host driver's slave_alloc
+ * function.
+ */
+int fc_alloc_transport_attrs(struct scsi_device *sdev)
+{
+	struct fc_transport_attrs *ptr;
+
+	ptr = (struct fc_transport_attrs *)
+		kmalloc(sizeof(struct fc_transport_attrs),
+			GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	INIT_FC_TRANSPORT(ptr);
+	sdev->transport_attr_values = ptr;
+
+	return 0;
+}
+
+/* Cleans up after fc_alloc_transport_attrs().
+ * Usually called from the scsi host driver's slave_destroy
+ * function
+ */
+void fc_destroy_transport_attrs(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attr_values);
+}
+
diff -Nru a/drivers/scsi/scsi_transport_pscsi.c b/drivers/scsi/scsi_transport_pscsi.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_pscsi.c	Wed Jan  7 10:39:14 2004
@@ -0,0 +1,104 @@
+/* 
+ *  Parallel SCSI transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_pscsi.h>
+
+struct class pscsi_transport_class = {
+	.name = "pscsi_transport",
+	.release = transport_class_release,
+};
+
+
+#define pscsi_transport_show_function(field, format_string)			\
+static ssize_t									\
+show_pscsi_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct pscsi_transport_attrs *tp;					\
+	tp = (struct pscsi_transport_attrs *)sdev->transport_attr_values;	\
+	return snprintf(buf, 20, format_string, tp->field);			\
+}
+
+#define pscsi_transport_rd_attr(field, format_string)				\
+	pscsi_transport_show_function(field, format_string)			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_pscsi_transport_##field, NULL)
+
+
+/* The Parallel SCSI Tranport Attributes: */
+pscsi_transport_rd_attr(period, "%d\n");
+pscsi_transport_rd_attr(offset, "%d\n");
+
+struct class_device_attribute *pscsi_transport_attrs[] = {
+	&class_device_attr_period,
+	&class_device_attr_offset,
+	NULL
+};
+
+
+int scsi_pscsi_transport_init(void)
+{
+	return class_register(&pscsi_transport_class);
+}
+
+void scsi_pscsi_transport_exit(void)
+{
+	class_unregister(&pscsi_transport_class);
+}
+
+
+void scsi_sysfs_cleanup_scsi_transport(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attr_values);
+	put_device(&sdev->host->shost_gendev);
+}
+
+
+/* Allocates the struct to place the attribute values in.
+ * Usually called from the scsi host driver's slave_alloc
+ * function.
+ */
+int pscsi_alloc_transport_attrs(struct scsi_device *sdev)
+{
+	struct pscsi_transport_attrs *ptr;
+
+	ptr = (struct pscsi_transport_attrs *)
+		kmalloc(sizeof(struct pscsi_transport_attrs),
+			GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	INIT_PSCSI_TRANSPORT(ptr);
+	sdev->transport_attr_values = ptr;
+
+	return 0;
+}
+
+
+/* Cleans up after fc_alloc_transport_attrs().
+ * Usually called from the scsi host driver's slave_destroy
+ * function
+ */
+void pscsi_destroy_transport_attrs(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attr_values);
+}
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Wed Jan  7 10:39:14 2004
+++ b/include/scsi/scsi_device.h	Wed Jan  7 10:39:14 2004
@@ -103,6 +103,9 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
+	void *			transport_attr_values;
+	struct class_device	transport_classdev;
+
 	enum scsi_device_state sdev_state;
 };
 #define	to_scsi_device(d)	\
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Wed Jan  7 10:39:14 2004
+++ b/include/scsi/scsi_host.h	Wed Jan  7 10:39:14 2004
@@ -337,6 +337,12 @@
 	struct device_attribute **sdev_attrs;
 
 	/*
+	 * Pointers to the Transport attributes and the Transport class.
+	 */
+	struct class_device_attribute **transport_attrs;
+	struct class *transport_class;
+
+	/*
 	 * List of hosts per template.
 	 *
 	 * This is only for use by scsi_module.c for legacy templates.
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport.h	Wed Jan  7 10:39:14 2004
@@ -0,0 +1,39 @@
+/* 
+ *  Transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef SCSI_TRANSPORT_H
+#define SCSI_TRANSPORT_H
+
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_pscsi.h>
+#include <scsi/scsi_transport_fc.h>
+
+#define transport_class_to_sdev(class_dev) \
+	container_of(class_dev, struct scsi_device, transport_classdev)
+
+static inline void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+extern int scsi_add_transport_attributes(struct scsi_device *sdev);
+extern int scsi_export_transport_attributes(struct scsi_device *sdev);
+
+#endif /* SCSI_TRANSPORT_H */
diff -Nru a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_fc.h	Wed Jan  7 10:39:14 2004
@@ -0,0 +1,44 @@
+/* 
+ *  FiberChannel transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef SCSI_TRANSPORT_FC_H
+#define SCSI_TRANSPORT_FC_H
+
+extern struct class fc_transport_class;
+extern struct class_device_attribute *fc_transport_attrs[];
+
+struct fc_transport_attrs {
+	int port_id;
+	uint64_t node_name;
+	uint64_t port_name;
+};
+
+#define INIT_FC_TRANSPORT(ptr) do {	\
+	(ptr)->port_id		= -1;	\
+	(ptr)->node_name	= -1;	\
+	(ptr)->port_name	= -1;	\
+} while (0)
+
+extern int scsi_fc_transport_init(void);
+extern void scsi_fc_transport_exit(void);
+extern int fc_alloc_transport_attrs(struct scsi_device *sdev);
+extern void fc_destroy_transport_attrs(struct scsi_device *sdev);
+extern int scsi_add_fc_transport_attributes(struct scsi_device *sdev);
+
+#endif /* SCSI_TRANSPORT_FC_H */
diff -Nru a/include/scsi/scsi_transport_pscsi.h b/include/scsi/scsi_transport_pscsi.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_pscsi.h	Wed Jan  7 10:39:14 2004
@@ -0,0 +1,42 @@
+/* 
+ *  Parallel SCSI transport specific attributes exported to sysfs.
+ *
+ *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef SCSI_TRANSPORT_PSCSI_H
+#define SCSI_TRANSPORT_PSCSI_H
+
+extern struct class pscsi_transport_class;
+extern struct class_device_attribute *pscsi_transport_attrs[];
+
+struct pscsi_transport_attrs {
+	int period;
+	int offset;
+};
+
+#define INIT_PSCSI_TRANSPORT(ptr) do {	\
+	(ptr)->period		= -1;	\
+	(ptr)->offset		= -1;	\
+} while (0)
+
+extern int scsi_pscsi_transport_init(void);
+extern void scsi_pscsi_transport_exit(void);
+extern int pscsi_alloc_transport_attrs(struct scsi_device *sdev);
+extern void pscsi_destroy_transport_attrs(struct scsi_device *sdev);
+extern int scsi_add_pscsi_transport_attributes(struct scsi_device *sdev);
+
+#endif /* SCSI_TRANSPORT_PSCSI_H */

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-qla1280-v3-3.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1521  -> 1.1522 
#	drivers/scsi/Kconfig	1.48    -> 1.49   
#	drivers/scsi/qla1280.c	1.51    -> 1.52   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/07	mort@tomahawk.engr.sgi.com	1.1522
# Export transport attributes from qla1280
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Wed Jan  7 08:33:58 2004
+++ b/drivers/scsi/Kconfig	Wed Jan  7 08:33:58 2004
@@ -1210,7 +1210,7 @@
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && SCSI_PSCSI_ATTRS
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Wed Jan  7 08:33:58 2004
+++ b/drivers/scsi/qla1280.c	Wed Jan  7 08:33:58 2004
@@ -324,6 +324,8 @@
 
 #if LINUX_VERSION_CODE >= 0x020545
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_pscsi.h>
 #include "scsi.h"
 #else
 #include <linux/blk.h>
@@ -440,7 +442,9 @@
  */
 static void qla1280_done(struct scsi_qla_host *, struct srb **, struct srb **);
 static void qla1280_done_q_put(struct srb *, struct srb **, struct srb **);
+static int qla1280_slave_alloc(Scsi_Device *);
 static int qla1280_slave_configure(Scsi_Device *);
+static void qla1280_slave_destroy(Scsi_Device *);
 #if LINUX_VERSION_CODE < 0x020545
 static void qla1280_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
 static void qla1280_get_target_options(struct scsi_cmnd *, struct scsi_qla_host *);
@@ -949,6 +953,9 @@
 	ha->instance = num_hosts;
 	host->unique_id = ha->instance;
 
+	host->hostt->transport_attrs = pscsi_transport_attrs;
+	host->hostt->transport_class = &pscsi_transport_class;
+
 	if (qla1280_pci_config(ha)) {
 		printk(KERN_INFO "qla1x160: Unable to configure PCI\n");
 		goto error_mem_alloced;
@@ -1670,6 +1677,17 @@
 	return status;
 }
 
+static int
+qla1280_slave_alloc(Scsi_Device *device)
+{
+	int error = 0;
+
+	error = pscsi_alloc_transport_attrs(device);
+	if (error)
+		return error;
+
+	return error;
+}
 
 /**************************************************************************
  *   qla1280_slave_configure
@@ -1686,12 +1704,14 @@
 qla1280_slave_configure(Scsi_Device *device)
 {
 	struct scsi_qla_host *ha;
+	struct pscsi_transport_attrs *attrs;
 	int default_depth = 3;
 	int bus = device->channel;
 	int target = device->id;
 	int status = 0;
 	struct nvram *nv;
 	unsigned long flags;
+	int is1x160;
 
 	ha = (struct scsi_qla_host *)device->host->hostdata;
 	nv = &ha->nvram;
@@ -1699,6 +1719,12 @@
 	if (qla1280_check_for_dead_scsi_bus(ha, bus))
 		return 1;
 
+	if (ha->device_id == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
+	    ha->device_id == PCI_DEVICE_ID_QLOGIC_ISP10160)
+		is1x160 = 1;
+	else
+		is1x160 = 0;
+
 	if (device->tagged_supported &&
 	    (ha->bus_settings[bus].qtag_enables & (BIT_0 << target))) {
 		scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
@@ -1736,9 +1762,25 @@
 
 	qla12160_get_target_parameters(ha, device);
 	spin_unlock_irqrestore(HOST_LOCK, flags);
+
+	/* Set the parallel scsi transport attributes */
+	attrs = (struct pscsi_transport_attrs *)device->transport_attr_values;
+	attrs->period = nv->bus[bus].target[target].sync_period;
+	if (is1x160)
+		attrs->offset = nv->bus[bus].target[target].flags.
+			flags1x160.sync_offset;
+	else
+		attrs->offset = nv->bus[bus].target[target].flags.
+			flags1x80.sync_offset;
+
 	return status;
 }
 
+void qla1280_slave_destroy(Scsi_Device *device)
+{
+	pscsi_destroy_transport_attrs(device);
+}
+
 #if LINUX_VERSION_CODE < 0x020545
 /**************************************************************************
  *   qla1280_select_queue_depth
@@ -5145,7 +5187,9 @@
 	.info			= qla1280_info,
 	.queuecommand		= qla1280_queuecommand,
 #if LINUX_VERSION_CODE >= 0x020545
+	.slave_alloc		= qla1280_slave_alloc,
 	.slave_configure	= qla1280_slave_configure,
+	.slave_destroy		= qla1280_slave_destroy,
 #endif
 	.eh_abort_handler	= qla1280_eh_abort,
 	.eh_device_reset_handler= qla1280_eh_device_reset,

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-qla2xxx-v3-3.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1522  -> 1.1523 
#	drivers/scsi/qla2xxx/Kconfig	1.1     -> 1.2    
#	drivers/scsi/qla2xxx/qla_os.c	1.1     -> 1.2    
#	drivers/scsi/qla2xxx/qla_os.h	1.1     -> 1.2    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/07	mort@tomahawk.engr.sgi.com	1.1523
# Export transport attributes from qla2xxx
# --------------------------------------------
#
diff -Nru a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
--- a/drivers/scsi/qla2xxx/Kconfig	Wed Jan  7 08:33:22 2004
+++ b/drivers/scsi/qla2xxx/Kconfig	Wed Jan  7 08:33:22 2004
@@ -1,6 +1,6 @@
 config SCSI_QLA2XXX
 	bool "QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && SCSI_FC_ATTRS
 	---help---
 	These drivers support the QLogic 2xxx host adapter family of SCSI FCP
 	HBAs.
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Wed Jan  7 08:33:22 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Wed Jan  7 08:33:22 2004
@@ -167,7 +167,9 @@
 /*
  * SCSI host template entry points 
  */
+static int qla2xxx_slave_alloc(struct scsi_device *device);
 static int qla2xxx_slave_configure(struct scsi_device * device);
+static void qla2xxx_slave_destroy(struct scsi_device *device);
 extern int qla2x00_ioctl(struct scsi_device *, int , void *);
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
@@ -191,7 +193,9 @@
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
+	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_configure	= qla2xxx_slave_configure,
+	.slave_destroy		= qla2xxx_slave_destroy,
 
 	.this_id		= -1,
 	.can_queue		= REQUEST_ENTRY_CNT+128,
@@ -1849,7 +1853,24 @@
 }
 
 /**************************************************************************
-* qla2x00_slave_configure
+ * qla2xxx_slave_alloc
+ *
+ * Description:
+ *************************************************************************/
+static int
+qla2xxx_slave_alloc(struct scsi_device *sdev)
+{
+	int error=0;
+
+	error = fc_alloc_transport_attrs(sdev);
+	if (error)
+		return error;
+
+	return error;
+}
+
+/**************************************************************************
+* qla2xxx_slave_configure
 *
 * Description:
 **************************************************************************/
@@ -1857,6 +1878,8 @@
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_transport_attrs *attrs;
+	struct fc_port *fc;
 	int queue_depth;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
@@ -1883,9 +1906,32 @@
 		     sdev->host->hostt->cmd_per_lun /* 3 */);
 	}
 
-	return (0);
+	attrs = (struct fc_transport_attrs *)sdev->transport_attr_values;
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			attrs->port_name = __be64_to_cpu(*(uint64_t *)fc->port_name);
+			attrs->node_name = __be64_to_cpu(*(uint64_t *)fc->node_name);
+			attrs->port_id = fc->d_id.b24;
+			break;
+		}
+	}
+
+	return 0;
+}
+ 
+ 
+/**************************************************************************
+ * qla2xxx_slave_destroy
+ *
+ * Description:
+ *************************************************************************/
+static void
+qla2xxx_slave_destroy(struct scsi_device *sdev)
+{
+	fc_destroy_transport_attrs(sdev);
 }
 
+
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context
@@ -1998,10 +2044,10 @@
 	ha->mmio_length = mmio_len;
 #endif
 
-	return (0);
+	return 0;
 
 iospace_error_exit:
-	return (-ENOMEM);
+	return -ENOMEM;
 }
 
 /*
@@ -2238,6 +2284,9 @@
 
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+
+	host->hostt->transport_attrs = fc_transport_attrs;
+	host->hostt->transport_class = &fc_transport_class;
 
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: %s\n"
diff -Nru a/drivers/scsi/qla2xxx/qla_os.h b/drivers/scsi/qla2xxx/qla_os.h
--- a/drivers/scsi/qla2xxx/qla_os.h	Wed Jan  7 08:33:22 2004
+++ b/drivers/scsi/qla2xxx/qla_os.h	Wed Jan  7 08:33:22 2004
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -91,7 +92,7 @@
 
 #include "scsi.h"
 #include "hosts.h"
-
+#include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_ioctl.h>
 

--azLHFNyN32YCQGCU--
