From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] Transport Attributes Export API
Date: Wed, 31 Dec 2003 14:08:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031231190849.GE3066@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:51591 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265245AbTLaTIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 14:08:50 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello,

I've run into a situation where I need to export driver-hidden
information to sysfs.  This information is specific to a transport
(e.g., Parallel SCSI or Fiber Channel) and, in general, the kernel
doesn't use this information so it is not available outside the HBA
driver.

Attached is a patch that attempts to provide a means to export this
information to sysfs.  It introduces a new class for the scsi_device's
transport and provides facilities to export class_device_attributes.

A few suggestions that James Bottomley has already given are below, but
I thought that it was time that others saw this and could give their
suggestions too.  Thanks.

mh.


James' suggestions:

- Separate the transports out into two separate .c files (so they can be
loaded as modules).  This also plays in to future work I'm thinking
about: make the error handler more transport specific.
- Then, the class register/unregister can be done in the
module_init/exit routines
- Probably move all the show/store routines in .h files so they can be
used equally for fc and parallel
- This switch on ttype (and the enum transport_type) in
scsi_add_transport_attributes is not scaleable.  I think a better
solution might be to have a struct scsi_transport which has the class
device and a pointer to the overridden attribute.  Then, this is the
thing pointed to in the scsi host structure (and it can contain the
attributes, the class and a pointer to the default attributes, so most
of the trying to find the defaults code goes away).


-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-qla1280-2.diff"

===== drivers/scsi/qla1280.c 1.51 vs edited =====
--- 1.51/drivers/scsi/qla1280.c	Wed Dec 17 00:20:02 2003
+++ edited/drivers/scsi/qla1280.c	Wed Dec 31 13:43:29 2003
@@ -324,6 +324,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020545
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_sysfs.h>
 #include "scsi.h"
 #else
 #include <linux/blk.h>
@@ -440,7 +441,9 @@
  */
 static void qla1280_done(struct scsi_qla_host *, struct srb **, struct srb **);
 static void qla1280_done_q_put(struct srb *, struct srb **, struct srb **);
+static int qla1280_slave_alloc(Scsi_Device *);
 static int qla1280_slave_configure(Scsi_Device *);
+static void qla1280_slave_destroy(Scsi_Device *);
 #if LINUX_VERSION_CODE < 0x020545
 static void qla1280_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
 static void qla1280_get_target_options(struct scsi_cmnd *, struct scsi_qla_host *);
@@ -499,6 +502,27 @@
 
 static struct qla_driver_setup driver_setup __initdata;
 
+static ssize_t
+qla1280_show_someval(struct class_device *dev, char *buf)
+{
+	int i = 5;
+	return snprintf(buf, 20, "%d\n", i);
+}
+
+static struct class_device_attribute qla1280_someval_attr = {
+	.attr = {
+		.name = "someval",
+		.mode =	S_IRUGO,
+	},
+	.show = qla1280_show_someval,
+};
+
+static struct class_device_attribute *qla1280_transport_attributes[] = {
+	&qla1280_someval_attr,
+	NULL,
+};
+
+
 /*
  * convert scsi data direction to request_t control flags
  */
@@ -949,6 +973,8 @@
 	ha->instance = num_hosts;
 	host->unique_id = ha->instance;
 
+	host->hostt->trans_attrs = qla1280_transport_attributes;
+
 	if (qla1280_pci_config(ha)) {
 		printk(KERN_INFO "qla1x160: Unable to configure PCI\n");
 		goto error_mem_alloced;
@@ -1671,6 +1697,31 @@
 }
 
 
+/*
+ * qla1280_slave_alloc
+ */
+static int
+qla1280_slave_alloc(Scsi_Device *device)
+{
+	struct scsi_qla_host *ha;
+	struct nvram *nv;
+	struct scsi_transport_attrs *sattrs;
+	int bus = device->channel;
+	int target = device->id;
+
+	if (scsi_sysfs_setup_scsi_transport(device))
+		return -1;
+
+	ha = (struct scsi_qla_host *)device->host->hostdata;
+	nv = &ha->nvram;
+	sattrs = (struct scsi_transport_attrs *)device->transport_attrs;
+
+	sattrs->period = nv->bus[bus].target[target].sync_period;
+	sattrs->offset = nv->bus[bus].target[target].flags.flags_43 & 0xff;
+
+	return 0;
+}
+
 /**************************************************************************
  *   qla1280_slave_configure
  *
@@ -1739,6 +1790,17 @@
 	return status;
 }
 
+
+/*
+ * qla1280_slave_destroy
+ */
+static void
+qla1280_slave_destroy(Scsi_Device *device)
+{
+	scsi_sysfs_cleanup_scsi_transport(device);
+}
+
+
 #if LINUX_VERSION_CODE < 0x020545
 /**************************************************************************
  *   qla1280_select_queue_depth
@@ -5145,7 +5207,9 @@
 	.info			= qla1280_info,
 	.queuecommand		= qla1280_queuecommand,
 #if LINUX_VERSION_CODE >= 0x020545
+	.slave_alloc		= qla1280_slave_alloc,
 	.slave_configure	= qla1280_slave_configure,
+	.slave_destroy		= qla1280_slave_destroy,
 #endif
 	.eh_abort_handler	= qla1280_eh_abort,
 	.eh_device_reset_handler= qla1280_eh_device_reset,

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-qla2xxx-2.diff"

--- qla_os.c.orig	2003-12-05 19:45:14.000000000 -0500
+++ qla_os.c	2003-12-31 13:54:02.000000000 -0500
@@ -20,6 +20,7 @@
 #include "qla_os.h"
 
 #include "qla_def.h"
+#include <scsi/scsi_sysfs.h>
 
 /*
  * Driver version
@@ -167,7 +168,9 @@
 /*
  * SCSI host template entry points 
  */
+static int qla2xxx_slave_alloc(struct scsi_device *device);
 static int qla2xxx_slave_configure(struct scsi_device * device);
+static void qla2xxx_slave_destroy(struct scsi_device *device);
 extern int qla2x00_ioctl(struct scsi_device *, int , void *);
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
@@ -191,7 +194,9 @@
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
+	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_configure	= qla2xxx_slave_configure,
+	.slave_destroy		= qla2xxx_slave_destroy,
 
 	.this_id		= -1,
 	.can_queue		= REQUEST_ENTRY_CNT+128,
@@ -1848,8 +1853,34 @@
 	return qla2x00_abort_target(reset_fcport);
 }
 
+/*************************************************************************
+ * qla2xxx_slave_alloc
+ *
+ * Description:
+ ************************************************************************/
+static int
+qla2xxx_slave_alloc(struct scsi_device *sdev)
+{
+    	scsi_qla_host_t *ha =  (scsi_qla_host_t *)sdev->host->hostdata;
+	struct fc_transport_attrs *fcattrs;
+	struct fc_port *fc;
+
+	if (scsi_sysfs_setup_fc_transport(sdev))
+		return -1;
+	fcattrs = (struct fc_transport_attrs *)sdev->transport_attrs;
+
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			fcattrs->port_id = fc->d_id.b24;
+			break;
+		}
+ 	}
+
+	return 0;
+}
+
 /**************************************************************************
-* qla2x00_slave_configure
+* qla2xxx_slave_configure
 *
 * Description:
 **************************************************************************/
@@ -1886,6 +1917,17 @@
 	return (0);
 }
 
+/**************************************************************************
+ * qla2xxx_slave_destroy
+ *
+ * Description:
+ *************************************************************************/
+static void
+qla2xxx_slave_destroy(struct scsi_device *sdev)
+{
+	scsi_sysfs_cleanup_fc_transport(sdev);
+}
+
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-transport-class-attr-v2-3.diff"

diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Tue Dec 23 09:26:23 2003
+++ b/drivers/scsi/scsi_syms.c	Tue Dec 23 09:26:23 2003
@@ -21,6 +21,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_sysfs.h>
 #include <scsi/scsicam.h>
 #include "scsi.h"
 
@@ -86,6 +87,13 @@
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
 EXPORT_SYMBOL(scsi_device_cancel);
+
+EXPORT_SYMBOL(scsi_sysfs_setup_scsi_transport);
+EXPORT_SYMBOL(scsi_sysfs_cleanup_scsi_transport);
+EXPORT_SYMBOL(scsi_sysfs_setup_fc_transport);
+EXPORT_SYMBOL(scsi_sysfs_cleanup_fc_transport);
+EXPORT_SYMBOL(scsi_sysfs_scsitransport_attrs);
+EXPORT_SYMBOL(scsi_sysfs_fctransport_attrs);
 
 EXPORT_SYMBOL(__scsi_mode_sense);
 EXPORT_SYMBOL(scsi_mode_sense);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Tue Dec 23 09:26:23 2003
+++ b/drivers/scsi/scsi_sysfs.c	Tue Dec 23 09:26:23 2003
@@ -13,11 +13,15 @@
 #include <linux/device.h>
 
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_sysfs.h>
 #include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+/* forward declarations */
+static int scsi_add_transport_attributes(struct scsi_device *sdev);
+
 static int check_set(unsigned int *val, char *src)
 {
 	char *last;
@@ -115,6 +119,14 @@
 	put_device(&sdev->sdev_gendev);
 }
 
+static void scsi_device_transport_cls_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev;
+
+	sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
 void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdev;
@@ -146,6 +158,18 @@
 	.release	= scsi_device_cls_release,
 };
 
+/* Classes for transport-specific device attributes */
+struct class pscsi_transport_class = {
+	.name = "pscsi_transport",
+	.release = scsi_device_transport_cls_release,
+};
+
+struct class fc_transport_class = {
+	.name = "fc_transport",
+	.release = scsi_device_transport_cls_release,
+};
+
+
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
@@ -162,17 +186,37 @@
 	int error;
 
 	error = bus_register(&scsi_bus_type);
-	if (!error) {
-		error = class_register(&sdev_class);
-		if (error)
-			bus_unregister(&scsi_bus_type);
-	}
+	if (error)
+		return error;
 
+	error = class_register(&sdev_class);
+	if (error)
+		goto undo_bus;
+
+	error = class_register(&pscsi_transport_class);
+	if (error)
+		goto undo_sdev;
+
+	error = class_register(&fc_transport_class);
+	if (error)
+		goto undo_scsitrans;
+	
+ out:
 	return error;
+
+ undo_scsitrans:
+	class_unregister(&pscsi_transport_class);
+ undo_sdev:
+	class_unregister(&sdev_class);
+ undo_bus:
+	bus_unregister(&scsi_bus_type);
+	goto out;
 }
 
 void scsi_sysfs_unregister(void)
 {
+	class_unregister(&pscsi_transport_class);
+	class_unregister(&fc_transport_class);
 	class_unregister(&sdev_class);
 	bus_unregister(&scsi_bus_type);
 }
@@ -361,7 +405,15 @@
 	if (error) {
 		printk(KERN_INFO "error 2\n");
 		goto clean_device;
-		return error;
+	}
+
+	/* if .class is not set, then this is not implemented in the driver */
+	if (sdev->transport_classdev.class) {
+		error = class_device_add(&sdev->transport_classdev);
+		if (error) {
+			printk(KERN_INFO "error 3\n");
+			goto clean_device2;
+		}
 	}
 
 	get_device(&sdev->sdev_gendev);
@@ -385,9 +437,17 @@
 		}
 	}
 
+	get_device(&sdev->sdev_gendev);
+
+	error = scsi_add_transport_attributes(sdev);
+	if (error)
+		scsi_remove_device(sdev);
+
 	return error;
 
-clean_device:
+ clean_device2:
+	class_device_del(&sdev->sdev_classdev);
+ clean_device:
 	sdev->sdev_state = SDEV_CANCEL;
 
 	device_del(&sdev->sdev_gendev);
@@ -406,6 +466,7 @@
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
 		sdev->sdev_state = SDEV_DEL;
 		class_device_unregister(&sdev->sdev_classdev);
+		class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
@@ -488,6 +549,208 @@
 					scsi_sysfs_shost_attrs[i])) {
 			error = class_device_create_file(&shost->shost_classdev,
 					scsi_sysfs_shost_attrs[i]);
+			if (error)
+				return error;
+		}
+	}
+
+	return 0;
+}
+
+#define scsi_transport_show_function(field, format_string)			\
+static ssize_t									\
+show_scsi_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct scsi_transport_attrs *tp;					\
+	tp = (struct scsi_transport_attrs *)sdev->transport_attrs;		\
+	return snprintf(buf, 20, format_string, tp->field);			\
+}
+
+#define scsi_transport_rd_attr(field, format_string)				\
+	scsi_transport_show_function(field, format_string)			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_scsi_transport_##field, NULL)
+
+
+#define fc_transport_show_function(field, format_string)			\
+static ssize_t									\
+show_fc_transport_##field (struct class_device *cdev, char *buf)		\
+{										\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);		\
+	struct fc_transport_attrs *tp;					\
+	tp = (struct fc_transport_attrs *)sdev->transport_attrs;		\
+	return snprintf(buf, 20, format_string, tp->field);			\
+}
+
+#define fc_transport_rd_attr(field, format_string)				\
+	fc_transport_show_function(field, format_string)			\
+static CLASS_DEVICE_ATTR( field, S_IRUGO, show_fc_transport_##field, NULL)
+
+
+scsi_transport_rd_attr(period, "%d\n");
+scsi_transport_rd_attr(offset, "%d\n");
+
+fc_transport_rd_attr(port_id, "%d\n");
+
+struct class_device_attribute *scsi_sysfs_scsitransport_attrs[] = {
+	&class_device_attr_period,
+	&class_device_attr_offset,
+	NULL
+};
+
+struct class_device_attribute *scsi_sysfs_fctransport_attrs[] = {
+	&class_device_attr_port_id,
+	NULL
+};
+
+
+int scsi_sysfs_setup_scsi_transport(struct scsi_device *sdev)
+{
+	struct scsi_transport_attrs *ptr;
+
+	if (!get_device(&sdev->host->shost_gendev))
+		return -1;
+
+	ptr = (struct scsi_transport_attrs *)
+		kmalloc(sizeof(struct scsi_transport_attrs),
+			GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	INIT_SCSI_TRANSPORT(ptr);
+	sdev->transport_attrs = ptr;
+
+	class_device_initialize(&sdev->transport_classdev);
+	sdev->transport_classdev.dev = &sdev->sdev_gendev;
+	sdev->transport_classdev.class = &pscsi_transport_class;
+	snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
+		 "%d:%d:%d:%d", sdev->host->host_no,
+		 sdev->channel, sdev->id, sdev->lun);
+	return 0;
+}
+
+void scsi_sysfs_cleanup_scsi_transport(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attrs);
+	put_device(&sdev->host->shost_gendev);
+}
+
+
+int scsi_sysfs_setup_fc_transport(struct scsi_device *sdev)
+{
+	struct fc_transport_attrs *ptr;
+
+	if (!get_device(&sdev->host->shost_gendev))
+		return -1;
+
+	ptr = (struct fc_transport_attrs *)
+		kmalloc(sizeof(struct fc_transport_attrs),
+			GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	INIT_FC_TRANSPORT(ptr);
+	sdev->transport_attrs = ptr;
+
+	class_device_initialize(&sdev->transport_classdev);
+	sdev->transport_classdev.dev = &sdev->sdev_gendev;
+	sdev->transport_classdev.class = &fc_transport_class;
+	snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
+		 "%d:%d:%d:%d", sdev->host->host_no,
+		 sdev->channel, sdev->id, sdev->lun);
+	return 0;
+}
+
+
+void scsi_sysfs_cleanup_fc_transport(struct scsi_device *sdev)
+{
+	kfree(sdev->transport_attrs);
+	put_device(&sdev->host->shost_gendev);
+}
+
+
+static int transport_class_attr_add(struct class_device_attribute **master_list,
+				    struct class_device *cdev,
+				    struct class_device_attribute *attr)
+{
+	struct class_device_attribute *base_attr;
+
+	/*
+	 * Spare the caller from having to copy things it's not interested in.
+	 */
+	base_attr = class_attr_overridden(master_list, attr);
+	if (base_attr) {
+		/* extended permissions */
+		attr->attr.mode |= base_attr->attr.mode;
+
+		/* override null show/store with default */
+		if (!attr->show)
+			attr->show = base_attr->show;
+		if (!attr->store)
+			attr->store = base_attr->store;
+	}
+
+	return class_device_create_file(cdev, attr);
+}
+
+static inline int scsi_class_attribute_add(struct class_device *cdev, 
+					   struct class_device_attribute *attr)
+{
+	return transport_class_attr_add(scsi_sysfs_scsitransport_attrs, cdev, attr);
+}
+
+static inline int fc_class_attribute_add(struct class_device *cdev, 
+					 struct class_device_attribute *attr)
+{
+	return transport_class_attr_add(scsi_sysfs_fctransport_attrs, cdev, attr);
+}
+
+
+static int scsi_add_transport_attributes(struct scsi_device *sdev)
+{
+	struct scsi_transport_attrs *ptr;
+	struct class_device_attribute **trans_attrs = NULL;
+	enum transport_type ttype;
+	int i, error;
+
+	ptr = (struct scsi_transport_attrs *)sdev->transport_attrs;
+	ttype = ptr->type;
+
+	if (sdev->host->hostt->trans_attrs) {
+		int (*class_attr_add_func)(struct class_device *,
+					   struct class_device_attribute *) = NULL;
+
+		switch (ttype) {
+		case scsi_transport:
+			class_attr_add_func = scsi_class_attribute_add;
+			break;
+		case fc_transport:
+			class_attr_add_func = fc_class_attribute_add;
+			break;
+		}
+
+		for (i = 0; sdev->host->hostt->trans_attrs[i]; i++) {
+			error = class_attr_add_func(&sdev->transport_classdev,
+						    sdev->host->hostt->trans_attrs[i]);
+			if (error)
+				return error;
+		}
+	}
+
+	switch (ttype) {
+	case scsi_transport:
+		trans_attrs = scsi_sysfs_scsitransport_attrs;
+		break;
+	case fc_transport:
+		trans_attrs = scsi_sysfs_fctransport_attrs;
+		break;
+	}
+
+	for (i = 0; trans_attrs[i]; i++) {
+		if (!class_attr_overridden(sdev->host->hostt->trans_attrs,
+					   trans_attrs[i])) {
+			error = class_device_create_file(&sdev->transport_classdev,
+							 trans_attrs[i]);
 			if (error)
 				return error;
 		}
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Tue Dec 23 09:26:23 2003
+++ b/include/scsi/scsi_device.h	Tue Dec 23 09:26:23 2003
@@ -103,12 +103,17 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
+	void *			transport_attrs;
+	struct class_device	transport_classdev;
+
 	enum scsi_device_state sdev_state;
 };
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
+#define transport_class_to_sdev(d)	\
+	container_of(d, struct scsi_device, transport_classdev)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Tue Dec 23 09:26:23 2003
+++ b/include/scsi/scsi_host.h	Tue Dec 23 09:26:23 2003
@@ -337,6 +337,11 @@
 	struct device_attribute **sdev_attrs;
 
 	/*
+	 * Pointer to the device transport attributes for this host, NULL terminated.
+	 */
+	struct class_device_attribute **trans_attrs;
+
+	/*
 	 * List of hosts per template.
 	 *
 	 * This is only for use by scsi_module.c for legacy templates.
diff -Nru a/include/scsi/scsi_sysfs.h b/include/scsi/scsi_sysfs.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_sysfs.h	Tue Dec 23 09:26:23 2003
@@ -0,0 +1,42 @@
+#ifndef _SCSI_SYSFS_H
+#define _SCSI_SYSFS_H
+
+extern struct class scsi_transport_class;
+extern struct class fc_transport_class;
+
+extern struct class_device_attribute *scsi_sysfs_scsitransport_attrs[];
+extern struct class_device_attribute *scsi_sysfs_fctransport_attrs[];
+
+extern int scsi_sysfs_setup_scsi_transport(struct scsi_device *sdev);
+extern void scsi_sysfs_cleanup_scsi_transport(struct scsi_device *sdev);
+extern int scsi_sysfs_setup_fc_transport(struct scsi_device *sdev);
+extern void scsi_sysfs_cleanup_fc_transport(struct scsi_device *sdev);
+
+enum transport_type {
+	scsi_transport = 1,
+	fc_transport = 2,
+};
+
+struct scsi_transport_attrs {
+	enum transport_type type;  	/* Must be the first element */
+	int period;
+	int offset;
+};
+
+struct fc_transport_attrs {
+	enum transport_type type;	/* Must be the first element */
+	int port_id;
+};
+
+#define INIT_SCSI_TRANSPORT(ptr) do { 		\
+	(ptr)->type	= scsi_transport,	\
+     	(ptr)->period 	= -1;			\
+	(ptr)->offset 	= -1;			\
+} while (0)
+
+#define INIT_FC_TRANSPORT(ptr) do {	\
+	(ptr)->type	= fc_transport,	\
+	(ptr)->port_id	= -1; 		\
+} while (0)
+
+#endif

--envbJBWh7q8WU6mo--
