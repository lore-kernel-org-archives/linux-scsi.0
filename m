From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] SATA Transport Attributes
Date: Mon, 29 Mar 2004 19:46:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040330004601.GE18948@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dkEUBIird37B8yKS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:35242 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S262966AbUC3AqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 19:46:05 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, jgarzik@pobox.com, Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@sgi.com>, jeremy@sgi.com


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello,

Here is a patch that introduces a Transport Attribute class for SATA
devices.  The patch also includes an update to the Vitesse driver to use
the transport attribute.

The only problem that I'm having right now is that sometimes I get
a NULL pointer dereference in scsi_remove_device() when I rmmod sata_vsc.
Although sdev->host->transportt->cleanup is NULL coming into the
function, the call to class_device_unregister(&sdev->transport_classdev)
somtimes makes ->cleanup non-NULL and bad things happen from there.

I could not reproduce this when calling rmmod on the qla2200 driver. 

Any comments on this patch?  Any ideas about this rmmod issue?

The patch is against 2.6.5-rc1.

thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sata-transport-attributes.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1664  -> 1.1666 
#	drivers/scsi/libata-core.c	1.26    -> 1.27   
#	include/linux/libata.h	1.13    -> 1.14   
#	drivers/scsi/sata_vsc.c	1.3     -> 1.4    
#	drivers/scsi/Makefile	1.57    -> 1.58   
#	drivers/scsi/Kconfig	1.60    -> 1.61   
#	               (new)	        -> 1.1     include/scsi/scsi_transport_sata.h
#	               (new)	        -> 1.2     drivers/scsi/scsi_transport_sata.c
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/29	mort@tomahawk.engr.sgi.com	1.1665
# sata-transport-attributes-2.patch
# --------------------------------------------
# 04/03/29	mort@tomahawk.engr.sgi.com	1.1666
# scsi_transport_sata.c:
#   Remove some debug info
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Mon Mar 29 15:47:30 2004
+++ b/drivers/scsi/Kconfig	Mon Mar 29 15:47:30 2004
@@ -214,6 +214,14 @@
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config SCSI_SATA_ATTRS
+        tristate "Serial ATA Transport Attributes"
+        depends on SCSI
+        help
+          If you wish to export transport-specific information about
+          each attached Serial ATA device to sysfs, say Y. Otherwise,
+          say N.
+
 endmenu
 
 menu "SCSI low-level drivers"
@@ -460,6 +468,7 @@
 config SCSI_SATA_VITESSE
 	tristate "VITESSE VSC-7174 SATA support"
 	depends on SCSI_SATA && PCI && EXPERIMENTAL
+        select SCSI_SATA_ATTRS
 	help
 	  This option enables support for Vitesse VSC7174 Serial ATA.
 
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Mon Mar 29 15:47:30 2004
+++ b/drivers/scsi/Makefile	Mon Mar 29 15:47:30 2004
@@ -28,6 +28,7 @@
 # --------------------------
 obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
+obj-$(CONFIG_SCSI_SATA_ATTRS)	+= scsi_transport_sata.o
 
 
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
diff -Nru a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
--- a/drivers/scsi/libata-core.c	Mon Mar 29 15:47:30 2004
+++ b/drivers/scsi/libata-core.c	Mon Mar 29 15:47:30 2004
@@ -38,6 +38,7 @@
 #include <scsi/scsi.h>
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsi_transport_sata.h>
 #include <linux/libata.h>
 #include <asm/io.h>
 #include <asm/semaphore.h>
@@ -2800,6 +2801,8 @@
 	host->max_channel = 1;
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = 12;
+	if (ent->transportt)
+		host->transportt = ent->transportt;
 	scsi_set_device(host, &ent->pdev->dev);
 
 	ap->flags = ATA_FLAG_PORT_DISABLED;
@@ -3334,6 +3337,20 @@
 	return (tmp == bits->val) ? 1 : 0;
 }
 
+/**
+ *	ata_get_port - sysfs transport attributes function
+ *
+ *	LOCKING:
+ *
+ *	RETURNS:
+ */
+
+void ata_get_port(struct scsi_device *sdev)
+{
+	struct ata_port *ap = (struct ata_port *) &sdev->host->hostdata[0];
+
+	sata_port(sdev) = ap->port_no;
+}
 
 /**
  *	ata_init -
@@ -3391,3 +3408,4 @@
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_release);
 EXPORT_SYMBOL_GPL(ata_host_intr);
+EXPORT_SYMBOL_GPL(ata_get_port);
diff -Nru a/drivers/scsi/sata_vsc.c b/drivers/scsi/sata_vsc.c
--- a/drivers/scsi/sata_vsc.c	Mon Mar 29 15:47:30 2004
+++ b/drivers/scsi/sata_vsc.c	Mon Mar 29 15:47:30 2004
@@ -19,6 +19,8 @@
 #include <linux/interrupt.h>
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sata.h>
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_vsc"
@@ -237,6 +239,7 @@
 	port->scr_addr		= base + VSC_SATA_SCR_STATUS_OFFSET;
 }
 
+static struct scsi_transport_template *vsc_transport_template = NULL;
 
 static int __devinit vsc_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -305,6 +308,8 @@
 	probe_ent->irq = pdev->irq;
 	probe_ent->irq_flags = SA_SHIRQ;
 	probe_ent->mmio_base = mmio_base;
+	BUG_ON(vsc_transport_template == NULL);
+	probe_ent->transportt = vsc_transport_template;
 
 	/* We don't care much about the PIO/UDMA masks, but the core won't like us
 	 * if we don't fill these
@@ -355,15 +360,26 @@
 	.remove			= ata_pci_remove_one,
 };
 
+/* Need to actually export some attributes */
+static struct sata_function_template vsc_transport_functions = {
+	.get_port	= ata_get_port,
+	.show_port	= 1,
+};
 
 static int __init vsc_sata_init(void)
 {
+	vsc_transport_template = sata_attach_transport(&vsc_transport_functions);
+	if (!vsc_transport_template)
+		return -ENODEV;
+
 	return pci_module_init(&vsc_sata_pci_driver);
 }
 
 
 static void __exit vsc_sata_exit(void)
 {
+	sata_release_transport(vsc_transport_template);
+
 	pci_unregister_driver(&vsc_sata_pci_driver);
 }
 
diff -Nru a/drivers/scsi/scsi_transport_sata.c b/drivers/scsi/scsi_transport_sata.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_transport_sata.c	Mon Mar 29 15:47:30 2004
@@ -0,0 +1,187 @@
+/* 
+ *  Serial ATA transport specific attributes exported to sysfs.
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sata.h>
+
+#define SATA_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
+
+static void transport_class_release(struct class_device *class_dev);
+
+#define SATA_NUM_ATTRS 		1	/* increase this if you add attributes */
+#define SATA_OTHER_ATTRS 	0	/* increase this if you add "always on"
+					 * attributes */
+
+struct sata_internal {
+	struct scsi_transport_template t;
+	struct sata_function_template *f;
+	/* The actual attributes */
+	struct class_device_attribute private_attrs[SATA_NUM_ATTRS];
+	/* The array of null terminated pointers to attributes
+	 * needed by scsi_sysfs.c */
+	struct class_device_attribute *attrs[SATA_NUM_ATTRS + SATA_OTHER_ATTRS + 1];
+};
+
+#define to_sata_internal(tmpl)	container_of(tmpl, struct sata_internal, t)
+
+struct class sata_transport_class = {
+	.name = "sata_transport",
+	.release = transport_class_release,
+};
+
+static __init int sata_transport_init(void)
+{
+	return class_register(&sata_transport_class);
+}
+
+static void __exit sata_transport_exit(void)
+{
+	class_unregister(&sata_transport_class);
+}
+
+static int sata_setup_transport_attrs(struct scsi_device *sdev)
+{
+	sata_port(sdev) = -1;
+
+	return 0;
+}
+
+static void transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_device *sdev = transport_class_to_sdev(class_dev);
+	put_device(&sdev->sdev_gendev);
+}
+
+#define sata_transport_show_function(field, format_string, cast)	\
+									\
+static ssize_t								\
+show_sata_transport_##field (struct class_device *cdev, char *buf)	\
+{									\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct sata_transport_attrs *tp;				\
+	struct sata_internal *i = to_sata_internal(sdev->host->transportt);	\
+	tp = (struct sata_transport_attrs *)&sdev->transport_data;	\
+	if (i->f->get_##field)						\
+		i->f->get_##field(sdev);				\
+	return snprintf(buf, 20, format_string, cast tp->field);	\
+}
+
+#define sata_transport_store_function(field, format_string)		\
+static ssize_t								\
+store_sata_transport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	int val;							\
+	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
+	struct sata_internal *i = to_sata_internal(sdev->host->transportt);	\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->f->set_##field(sdev, val);					\
+	return count;							\
+}
+
+#define sata_transport_rd_attr(field, format_string)			\
+	sata_transport_show_function(field, format_string, )		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
+			 show_sata_transport_##field, NULL)
+
+#define sata_transport_rd_attr_cast(field, format_string, cast)		\
+	sata_transport_show_function(field, format_string, (cast))	\
+static CLASS_DEVICE_ATTR( field, S_IRUGO,				\
+			  show_sata_transport_##field, NULL)
+
+#define sata_transport_rw_attr(field, format_string)			\
+	sata_transport_show_function(field, format_string, )		\
+	sata_transport_store_function(field, format_string)		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			show_sata_transport_##field,			\
+			store_sata_transport_##field)
+
+/* the Serial ATA Tranport Attributes: */
+sata_transport_rd_attr(port, "%d\n");
+
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
+sata_attach_transport(struct sata_function_template *ft)
+{
+	struct sata_internal *i = kmalloc(sizeof(struct sata_internal),
+					GFP_KERNEL);
+	int count = 0;
+
+	if (unlikely(!i))
+		return NULL;
+
+	memset(i, 0, sizeof(struct sata_internal));
+
+	i->t.attrs = &i->attrs[0];
+	i->t.class = &sata_transport_class;
+	i->t.setup = &sata_setup_transport_attrs;
+	i->t.cleanup = NULL;
+	i->t.size = sizeof(struct sata_transport_attrs);
+	i->f = ft;
+
+	/* Setup the attributes here */
+	SETUP_ATTRIBUTE_RD(port);
+
+	BUG_ON(count > SATA_NUM_ATTRS);
+
+	/* Setup the always-on attributes here */
+
+	i->attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(sata_attach_transport);
+
+void sata_release_transport(struct scsi_transport_template *t)
+{
+	struct sata_internal *i = to_sata_internal(t);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(sata_release_transport);
+
+
+MODULE_AUTHOR("Martin Hicks");
+MODULE_DESCRIPTION("SATA Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(sata_transport_init);
+module_exit(sata_transport_exit);
diff -Nru a/include/linux/libata.h b/include/linux/libata.h
--- a/include/linux/libata.h	Mon Mar 29 15:47:30 2004
+++ b/include/linux/libata.h	Mon Mar 29 15:47:30 2004
@@ -201,6 +201,7 @@
 	struct pci_dev		*pdev;
 	struct ata_port_operations	*port_ops;
 	Scsi_Host_Template	*sht;
+	struct scsi_transport_template *transportt;
 	struct ata_ioports	port[ATA_MAX_PORTS];
 	unsigned int		n_ports;
 	unsigned int		pio_mask;
@@ -435,6 +436,8 @@
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
 
+/* SATA Transport attributes functions */
+extern void ata_get_port(struct scsi_device *sdev);
 
 static inline unsigned long msecs_to_jiffies(unsigned long msecs)
 {
diff -Nru a/include/scsi/scsi_transport_sata.h b/include/scsi/scsi_transport_sata.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_transport_sata.h	Mon Mar 29 15:47:30 2004
@@ -0,0 +1,48 @@
+/* 
+ *  Serial ATA transport specific attributes exported to sysfs.
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
+#ifndef SCSI_TRANSPORT_SATA_H
+#define SCSI_TRANSPORT_SATA_H
+
+#include <linux/config.h>
+
+struct scsi_transport_template;
+
+struct sata_transport_attrs {
+	int port;
+};
+
+/* accessor functions */
+#define sata_port(x)	(((struct sata_transport_attrs *)&(x)->transport_data)->port)
+
+/* The functions by which the transport class and the driver communicate */
+struct sata_function_template {
+	void 	(*get_port)(struct scsi_device *);
+	/* The driver sets these to tell the transport class it
+	 * wants the attributes displayed in sysfs.  If the show_ flag
+	 * is not set, the attribute will be private to the transport
+	 * class */
+	unsigned long		show_port:1;
+	/* Private Attributes */
+};
+
+struct scsi_transport_template *sata_attach_transport(struct sata_function_template *);
+void sata_release_transport(struct scsi_transport_template *);
+
+#endif /* SCSI_TRANSPORT_SATA_H */

--dkEUBIird37B8yKS--
