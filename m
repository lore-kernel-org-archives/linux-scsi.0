From: Martin Hicks <mort@wildopensource.com>
Subject: Transport Attributes -- attempt#4
Date: Tue, 20 Jan 2004 16:56:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120215645.GG15871@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+g7M9IMkV8truYOl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:3272 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265778AbUATV4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 16:56:47 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi again,

Updated patches against Linus' bk tree from earlier today.  The patch
that fixes up the scsi_sysfs.c error path, that was sent out by me on
Jan 16, is required for the core patch to apply cleanly.

I think I've addressed all the comments from the last round with the
exception of doing Lazy registration of the transport classes.  I'm
still not totally convinced that this is really required.

thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-core-v5-1.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1494  -> 1.1495 
#	include/scsi/scsi_device.h	1.11    -> 1.12   
#	include/scsi/scsi_host.h	1.13    -> 1.14   
#	drivers/scsi/scsi_sysfs.c	1.39    -> 1.40   
#	drivers/scsi/scsi_priv.h	1.30    -> 1.31   
#	drivers/scsi/scsi_scan.c	1.115   -> 1.116  
#	drivers/scsi/Makefile	1.51    -> 1.52   
#	drivers/scsi/Kconfig	1.48    -> 1.49   
#	               (new)	        -> 1.1     include/scsi/scsi_transport_spi.h
#	               (new)	        -> 1.1     drivers/scsi/scsi_transport_spi.c
#	               (new)	        -> 1.1     include/scsi/scsi_transport.h
#	               (new)	        -> 1.1     drivers/scsi/scsi_transport_fc.c
#	               (new)	        -> 1.1     include/scsi/scsi_transport_fc.h
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/20	mort@green.i.bork.org	1.1495
# Transport Attributes core patch
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Tue Jan 20 15:52:29 2004
+++ b/drivers/scsi/Kconfig	Tue Jan 20 15:52:29 2004
@@ -196,6 +196,25 @@
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+menu "SCSI Transport Attributes"
+	depends on SCSI
+
+config SCSI_SPI_ATTRS
+	bool "Parallel SCSI (SPI) Transport Attributes"
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
--- a/drivers/scsi/Makefile	Tue Jan 20 15:52:29 2004
+++ b/drivers/scsi/Makefile	Tue Jan 20 15:52:29 2004
@@ -131,7 +131,9 @@
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-$(CONFIG_X86_PC9800)	+= scsi_pc98.o
-			
+scsi_mod-$(CONFIG_SCSI_SPI_ATTRS) += scsi_transport_spi.o
+scsi_mod-$(CONFIG_SCSI_FC_ATTRS)  += scsi_transport_fc.o
+
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 initio-objs	:= ini9100u.o i91uscsi.o
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Tue Jan 20 15:52:29 2004
+++ b/drivers/scsi/scsi_priv.h	Tue Jan 20 15:52:29 2004
@@ -156,6 +156,7 @@
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
+extern struct scsi_transport_template blank_transport_template;
 
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Tue Jan 20 15:52:29 2004
+++ b/drivers/scsi/scsi_scan.c	Tue Jan 20 15:52:29 2004
@@ -35,6 +35,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -237,6 +238,16 @@
 			goto out_free_queue;
 	}
 
+	/* Give each shost a default transportt if the driver
+	 * doesn't yet support Transport Attributes */
+	if (!shost->transportt) 
+		shost->transportt = &blank_transport_template;
+
+	if (shost->transportt->setup) {
+		if (shost->transportt->setup(sdev))
+			goto out_cleanup_slave;
+	}
+
 	if (get_device(&sdev->host->shost_gendev)) {
 
 		device_initialize(&sdev->sdev_gendev);
@@ -253,8 +264,15 @@
 		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
 			 "%d:%d:%d:%d", sdev->host->host_no,
 			 sdev->channel, sdev->id, sdev->lun);
+
+		class_device_initialize(&sdev->transport_classdev);
+		sdev->transport_classdev.dev = &sdev->sdev_gendev;
+		sdev->transport_classdev.class = sdev->host->transportt->class;
+		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
+			 "%d:%d:%d:%d", sdev->host->host_no,
+			 sdev->channel, sdev->id, sdev->lun);
 	} else
-		goto out_cleanup_slave;
+		goto out_cleanup_transport;
 
 	/*
 	 * If there are any same target siblings, add this to the
@@ -283,6 +301,9 @@
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return sdev;
 
+out_cleanup_transport:
+	if (shost->transportt->cleanup)
+		shost->transportt->cleanup(sdev);
 out_cleanup_slave:
 	if (shost->hostt->slave_destroy)
 		shost->hostt->slave_destroy(sdev);
@@ -744,6 +765,8 @@
 	} else {
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
+		if (sdev->host->transportt->cleanup)
+			sdev->host->transportt->cleanup(sdev);
 		put_device(&sdev->sdev_gendev);
 	}
  out:
@@ -1300,5 +1323,7 @@
 
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
+	if (sdev->host->transportt->cleanup)
+		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
 }
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Tue Jan 20 15:52:29 2004
+++ b/drivers/scsi/scsi_sysfs.c	Tue Jan 20 15:52:29 2004
@@ -13,6 +13,9 @@
 #include <linux/device.h>
 
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+#include <scsi/scsi_transport_fc.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
@@ -162,13 +165,31 @@
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
+	error = scsi_spi_transport_init();
+	if (error)
+		goto undo_sdev;
+
+	error = scsi_fc_transport_init();
+	if (error)
+		goto undo_all;
 
+ out:
 	return error;
+
+ undo_all:
+	scsi_spi_transport_exit();
+ undo_sdev:
+	class_unregister(&sdev_class);
+ undo_bus:
+	bus_unregister(&scsi_bus_type);
+	goto out;
 }
 
 void scsi_sysfs_unregister(void)
@@ -344,6 +365,7 @@
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
+	struct class_device_attribute **attrs;
 	int error = -EINVAL, i;
 
 	if (sdev->sdev_state != SDEV_CREATED)
@@ -363,6 +385,12 @@
 		goto clean_device;
 	}
 
+	if (sdev->transport_classdev.class) {
+		error = class_device_add(&sdev->transport_classdev);
+		if (error)
+			goto clean_device2;
+	}
+
 	get_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->sdev_attrs) {
@@ -388,10 +416,24 @@
 		}
 	}
 
+ 	if (sdev->transport_classdev.class) {
+ 		attrs = sdev->host->transportt->attrs;
+ 		for (i = 0; attrs[i]; i++) {
+ 			error = class_device_create_file(&sdev->transport_classdev,
+ 							 attrs[i]);
+ 			if (error) {
+ 				scsi_remove_device(sdev);
+				goto out;
+			}
+ 		}
+ 	}
+
  out:
 	return error;
 
-clean_device:
+ clean_device2:
+	class_device_del(&sdev->sdev_classdev);
+ clean_device:
 	sdev->sdev_state = SDEV_CANCEL;
 
 	device_del(&sdev->sdev_gendev);
@@ -409,9 +451,12 @@
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
 		sdev->sdev_state = SDEV_DEL;
 		class_device_unregister(&sdev->sdev_classdev);
+		class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
+		if (sdev->host->transportt->cleanup)
+			sdev->host->transportt->cleanup(sdev);
 		put_device(&sdev->sdev_gendev);
 	}
 }
@@ -498,3 +543,7 @@
 
 	return 0;
 }
+
+/* A blank transport template that is used in drivers that don't
+ * yet implement Transport Attributes */
+struct scsi_transport_template blank_transport_template;
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_fc.c	Tue Jan 20 15:52:29 2004
@@ -0,0 +1,116 @@
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
+static void transport_class_release(struct class_device *class_dev);
+
+struct class fc_transport_class = {
+	.name = "fc_transport",
+	.release = transport_class_release,
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
+/* Allocates the struct to place the attribute values in.
+ * Usually called from the scsi host driver's slave_alloc
+ * function.
+ */
+static int fc_alloc_transport_attrs(struct scsi_device *sdev)
+{
+	sdev->transport_attr_values = kmalloc(sizeof(struct fc_transport_attrs),
+					      GFP_ATOMIC);
+	if (!sdev->transport_attr_values)
+		return -ENOMEM;
+
+	memcpy(sdev->transport_attr_values, sdev->host->transportt->default_attr_values,
+	       sizeof(struct fc_transport_attrs));
+
+	return 0;
+}
+
+static void fc_destroy_transport_attrs(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attr_values);
+}
+
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
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
+fc_transport_rd_attr(port_id, "0x%06x\n");
+
+struct class_device_attribute *fc_transport_attrs[] = {
+	&class_device_attr_node_name,
+	&class_device_attr_port_name,
+	&class_device_attr_port_id,
+	NULL
+};
+
+struct fc_transport_attrs fc_transport_attr_defaults = {
+	.node_name = -1,
+	.port_name = -1,
+	.port_id = -1,
+};
+
+struct scsi_transport_template fc_transport_template = {
+	.attrs = fc_transport_attrs,
+	.class = &fc_transport_class,
+	.setup = &fc_alloc_transport_attrs,
+	.cleanup = &fc_destroy_transport_attrs,
+	.default_attr_values = &fc_transport_attr_defaults,
+};
+EXPORT_SYMBOL(fc_transport_template);
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_spi.c	Tue Jan 20 15:52:29 2004
@@ -0,0 +1,104 @@
+/* 
+ *  Parallel SCSI (SPI) transport specific attributes exported to sysfs.
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
+#include <scsi/scsi_transport_spi.h>
+
+static void transport_class_release(struct class_device *class_dev);
+
+struct class spi_transport_class = {
+	.name = "spi_transport",
+	.release = transport_class_release,
+};
+
+int scsi_spi_transport_init(void)
+{
+	return class_register(&spi_transport_class);
+}
+
+void scsi_spi_transport_exit(void)
+{
+	class_unregister(&spi_transport_class);
+}
+
+static int spi_alloc_transport_attrs(struct scsi_device *sdev)
+{
+	sdev->transport_attr_values = kmalloc(sizeof(struct spi_transport_attrs),
+					      GFP_ATOMIC);
+	if (!sdev->transport_attr_values)
+		return -ENOMEM;
+
+	memcpy(sdev->transport_attr_values, sdev->host->transportt->default_attr_values,
+	       sizeof(struct spi_transport_attrs));
+
+	return 0;
+}
+
+static void spi_destroy_transport_attrs(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attr_values);
+}
+
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+#define spi_transport_show_function(field, format_string)			\
+static ssize_t									\
+show_spi_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct spi_transport_attrs *tp;						\
+	tp = (struct spi_transport_attrs *)sdev->transport_attr_values;		\
+	return snprintf(buf, 20, format_string, tp->field);			\
+}
+
+#define spi_transport_rd_attr(field, format_string)				\
+	spi_transport_show_function(field, format_string)			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_spi_transport_##field, NULL)
+
+
+/* The Parallel SCSI Tranport Attributes: */
+spi_transport_rd_attr(period, "%d\n");
+spi_transport_rd_attr(offset, "%d\n");
+
+struct class_device_attribute *spi_transport_attrs[] = {
+	&class_device_attr_period,
+	&class_device_attr_offset,
+	NULL
+};
+
+struct spi_transport_attrs spi_transport_attr_defaults = {
+	.period = -1,
+	.offset = -1,
+};
+
+struct scsi_transport_template spi_transport_template = {
+	.attrs = spi_transport_attrs,
+	.class = &spi_transport_class,
+	.setup = &spi_alloc_transport_attrs,
+	.cleanup = &spi_destroy_transport_attrs,
+	.default_attr_values = &spi_transport_attr_defaults,
+};
+EXPORT_SYMBOL(spi_transport_template);
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Tue Jan 20 15:52:29 2004
+++ b/include/scsi/scsi_device.h	Tue Jan 20 15:52:29 2004
@@ -103,12 +103,17 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
+	void			*transport_attr_values;
+	struct class_device	transport_classdev;
+
 	enum scsi_device_state sdev_state;
 };
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
+#define transport_class_to_sdev(class_dev) \
+	container_of(class_dev, struct scsi_device, transport_classdev)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Tue Jan 20 15:52:29 2004
+++ b/include/scsi/scsi_host.h	Tue Jan 20 15:52:29 2004
@@ -11,6 +11,7 @@
 struct scsi_device;
 struct Scsi_Host;
 struct scsi_host_cmd_pool;
+struct scsi_transport_template;
 
 
 /*
@@ -395,6 +396,7 @@
 	unsigned int            eh_kill:1; /* set when killing the eh thread */
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
+	struct scsi_transport_template *transportt;
 	volatile unsigned short host_busy;   /* commands actually active on low-level */
 	volatile unsigned short host_failed; /* commands that failed. */
     
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport.h	Tue Jan 20 15:52:29 2004
@@ -0,0 +1,40 @@
+/* 
+ *  Transport specific attributes.
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
+struct scsi_transport_template {
+	/* The NULL terminated list of transport attributes
+	 * that should be exported.
+	 */
+	struct class_device_attribute **attrs;
+
+	/* The transport class that the device is in */
+	struct class *class;
+
+	/* Constructor/Destructor functions */
+	int (* setup)(struct scsi_device *);
+	void (* cleanup)(struct scsi_device *);
+
+	/* Default values for the transport attributes */
+	void *default_attr_values;
+};
+
+#endif /* SCSI_TRANSPORT_H */
diff -Nru a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_fc.h	Tue Jan 20 15:52:29 2004
@@ -0,0 +1,41 @@
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
+struct scsi_transport_template;
+
+struct fc_transport_attrs {
+	int port_id;
+	uint64_t node_name;
+	uint64_t port_name;
+};
+
+extern struct scsi_transport_template fc_transport_template;
+
+#ifdef CONFIG_SCSI_FC_ATTRS
+extern int scsi_fc_transport_init(void);
+extern void scsi_fc_transport_exit(void);
+#else
+# define scsi_fc_transport_init() 0
+# define scsi_fc_transport_exit()
+#endif
+
+#endif /* SCSI_TRANSPORT_FC_H */
diff -Nru a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_spi.h	Tue Jan 20 15:52:29 2004
@@ -0,0 +1,42 @@
+/* 
+ *  Parallel SCSI (SPI) transport specific attributes exported to sysfs.
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
+#ifndef SCSI_TRANSPORT_SPI_H
+#define SCSI_TRANSPORT_SPI_H
+
+#include <linux/config.h>
+
+struct scsi_transport_template;
+
+struct spi_transport_attrs {
+	int period;
+	int offset;
+};
+
+extern struct scsi_transport_template spi_transport_template;
+
+#ifdef CONFIG_SCSI_SPI_ATTRS
+extern int scsi_spi_transport_init(void);
+extern void scsi_spi_transport_exit(void);
+#else
+# define scsi_spi_transport_init() 0
+# define scsi_spi_transport_exit()
+#endif
+
+#endif /* SCSI_TRANSPORT_SPI_H */

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-qla1280-v5-1.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1496  -> 1.1497 
#	drivers/scsi/Kconfig	1.49    -> 1.50   
#	drivers/scsi/qla1280.c	1.53    -> 1.54   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/20	mort@green.i.bork.org	1.1497
# Transport Attributes for qla1280
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Tue Jan 20 15:50:46 2004
+++ b/drivers/scsi/Kconfig	Tue Jan 20 15:50:46 2004
@@ -1210,7 +1210,7 @@
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && SCSI_SPI_ATTRS
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Tue Jan 20 15:50:46 2004
+++ b/drivers/scsi/qla1280.c	Tue Jan 20 15:50:46 2004
@@ -347,6 +347,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 #include "scsi.h"
 #else
 #include <linux/blk.h>
@@ -1400,12 +1402,14 @@
 qla1280_slave_configure(struct scsi_device *device)
 {
 	struct scsi_qla_host *ha;
+	struct spi_transport_attrs *attrs;
 	int default_depth = 3;
 	int bus = device->channel;
 	int target = device->id;
 	int status = 0;
 	struct nvram *nv;
 	unsigned long flags;
+	int is1x160;
 
 	ha = (struct scsi_qla_host *)device->host->hostdata;
 	nv = &ha->nvram;
@@ -1413,6 +1417,12 @@
 	if (qla1280_check_for_dead_scsi_bus(ha, bus))
 		return 1;
 
+	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
+	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
+		is1x160 = 1;
+	else
+		is1x160 = 0;
+
 	if (device->tagged_supported &&
 	    (ha->bus_settings[bus].qtag_enables & (BIT_0 << target))) {
 		scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
@@ -1448,6 +1458,17 @@
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
 	spin_unlock_irqrestore(HOST_LOCK, flags);
+
+	/* Set the parallel scsi transport attributes */
+	attrs = (struct spi_transport_attrs *)device->transport_attr_values;
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
 
@@ -4713,6 +4734,7 @@
 	host->max_id = MAX_TARGETS;
 	host->max_sectors = 1024;
 	host->unique_id = host->host_no;
+	host->transportt = &spi_transport_template;
 
 #if LINUX_VERSION_CODE < 0x020545
 	host->select_queue_depths = qla1280_select_queue_depth;

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-qla2xxx-v5-1.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1495  -> 1.1496 
#	drivers/scsi/qla2xxx/qla_os.h	1.1     -> 1.2    
#	drivers/scsi/qla2xxx/qla_os.c	1.1     -> 1.2    
#	drivers/scsi/qla2xxx/Kconfig	1.2     -> 1.3    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/20	mort@green.i.bork.org	1.1496
# Transport Attributes for qla2xxx
# --------------------------------------------
#
diff -Nru a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
--- a/drivers/scsi/qla2xxx/Kconfig	Tue Jan 20 15:52:05 2004
+++ b/drivers/scsi/qla2xxx/Kconfig	Tue Jan 20 15:52:05 2004
@@ -1,7 +1,7 @@
 config SCSI_QLA2XXX_CONFIG
 	tristate
 	default (SCSI && PCI)
-	depends on SCSI && PCI
+	depends on SCSI && PCI && SCSI_FC_ATTRS
 
 config SCSI_QLA2XXX
 	tristate
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Tue Jan 20 15:52:05 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Tue Jan 20 15:52:05 2004
@@ -1800,7 +1800,7 @@
 }
 
 /**************************************************************************
-* qla2x00_slave_configure
+* qla2xxx_slave_configure
 *
 * Description:
 **************************************************************************/
@@ -1808,6 +1808,8 @@
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_transport_attrs *attrs;
+	struct fc_port *fc;
 	int queue_depth;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
@@ -1834,9 +1836,21 @@
 		     sdev->host->hostt->cmd_per_lun /* 3 */);
 	}
 
-	return (0);
-}
+	attrs = (struct fc_transport_attrs *)sdev->transport_attr_values;
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			attrs->port_name = __be64_to_cpu(*(uint64_t *)fc->port_name);
+			attrs->node_name = __be64_to_cpu(*(uint64_t *)fc->node_name);
+			attrs->port_id = fc->d_id.b.domain << 16 |
+				fc->d_id.b.area << 8 |
+				fc->d_id.b.al_pa;
+			break;
+		}
+	}
 
+	return 0;
+}
+ 
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context
@@ -1949,10 +1963,10 @@
 	ha->mmio_length = mmio_len;
 #endif
 
-	return (0);
+	return 0;
 
 iospace_error_exit:
-	return (-ENOMEM);
+	return -ENOMEM;
 }
 
 /*
@@ -2179,6 +2193,8 @@
 
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
+
+	host->transportt = &fc_transport_template;
 
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: %s\n"
diff -Nru a/drivers/scsi/qla2xxx/qla_os.h b/drivers/scsi/qla2xxx/qla_os.h
--- a/drivers/scsi/qla2xxx/qla_os.h	Tue Jan 20 15:52:05 2004
+++ b/drivers/scsi/qla2xxx/qla_os.h	Tue Jan 20 15:52:05 2004
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -61,7 +62,8 @@
 
 #include "scsi.h"
 #include "hosts.h"
-
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_ioctl.h>
 

--+g7M9IMkV8truYOl--
