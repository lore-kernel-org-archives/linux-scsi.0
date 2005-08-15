From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 15:55:37 +0200
Message-ID: <20050815135537.GB19426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:17617 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964774AbVHON4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 09:56:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

This is a minmal, bottom-up SAS transport class.  So far it only exposed
information about the SAS port/phy and SAS device (scsi target).  I hope
this will integrate nicely with the top-down work Luben has done once he
finally releases it publically, but for now I think we should have
something so SAS drivers can go in the tree.

In detail this transport class does:

 - introduces a SAS port object between the Scsi_Host and scsi_target,
   this is used to hold all information specific to the SAS port and
   PHY - right now they're used interchangable as I haven't found the
   right abstraction for wide ports yet - if there is a proper solution
   at all as the SAS spec leaves binding PHYs together to wide ports
   up to the implementation.
 - adds some attributes to the scsi_target, and an API call to
   preinitialize them.

It does not:

 - handle any managment interfaces or chaning of attributes
 - any SAS devices that are not scsi targets, most importantly there's
   no support for SMP and extenders yet
 - wide ports (as mentioned above)
 - software device discovery (although I know Luben has some nice code
   for that)
 - everythig not mentioned here

A bit of warning: I've only tested this with an SATA disk attached to
a SAS HBA so far because I don't have any real SAS storage yet.

To use the transport class you need a patched fusion driver for now,
use the LSI tarball at:

  ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/mptlinux-3.02.55-src.tar.gz

plus my patch at:

  http://verein.lst.de/~hch/fusion-sas-transport-class.diff

I'll try to port my changes plus basic SAS support over to the mainline
driver, but the driver is currently not endian clean which makes it hard
for me to actually test it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/Kconfig	2005-08-13 13:53:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/Kconfig	2005-08-15 15:34:56.000000000 +0200
@@ -229,6 +229,13 @@
 	  each attached iSCSI device to sysfs, say Y.
 	  Otherwise, say N.
 
+config SCSI_SAS_ATTRS
+	tristate "SAS Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached SAS device to sysfs, say Y.
+
 endmenu
 
 menu "SCSI low-level drivers"
Index: scsi-misc-2.6/drivers/scsi/Makefile
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/Makefile	2005-08-13 13:53:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/Makefile	2005-08-15 15:35:12.000000000 +0200
@@ -29,6 +29,7 @@
 obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
+obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
Index: scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2005-08-15 15:40:00.000000000 +0200
@@ -0,0 +1,491 @@
+/*
+ * Copyright (C) 2005 Dell Inc.
+ *	Released under GPL v2.
+ *
+ * Based on the FC transport class work by James Smart, Emulex Corporation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/err.h>
+
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sas.h>
+
+
+#define SAS_TARGET_ATTRS	25
+#define SAS_PORT_ATTRS		25
+
+struct sas_internal {
+	struct scsi_transport_template t;
+	struct sas_function_template *f;
+
+	struct class_device_attribute private_target_attrs[SAS_TARGET_ATTRS];
+	struct class_device_attribute private_port_attrs[SAS_TARGET_ATTRS];
+
+	struct transport_container port_attr_cont;
+
+	/*
+	 * The array of null terminated pointers to attributes
+	 * needed by scsi_sysfs.c
+	 */
+	struct class_device_attribute *target_attrs[SAS_TARGET_ATTRS];
+	struct class_device_attribute *port_attrs[SAS_PORT_ATTRS + 1];
+};
+#define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)
+
+/*
+ * Hack to allow attributes of the same name in different objects.
+ */
+#define SAS_CLASS_DEVICE_ATTR(_prefix,_name,_mode,_show,_store) \
+	struct class_device_attribute class_device_attr_##_prefix##_##_name = \
+	__ATTR(_name,_mode,_show,_store)
+
+
+/*
+ * Pretty printing helpers
+ */
+
+#define sas_bitfield_name_match(title, table)			\
+static ssize_t							\
+get_sas_##title##_names(u32 table_key, char *buf)		\
+{								\
+	char *prefix = "";					\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
+		if (table[i].value & table_key) {		\
+			len += sprintf(buf + len, "%s%s",	\
+				prefix, table[i].name);		\
+			prefix = ", ";				\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+#define sas_bitfield_name_search(title, table)			\
+static ssize_t							\
+get_sas_##title##_names(u32 table_key, char *buf)		\
+{								\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
+		if (table[i].value == table_key) {		\
+			len += sprintf(buf + len, "%s",		\
+				table[i].name);			\
+			break;					\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+static struct {
+	u32		value;
+	char		*name;
+} sas_device_type_names[] = {
+	{ SAS_PHY_UNUSED,		"unused" },
+	{ SAS_END_DEVICE,		"end device" },
+	{ SAS_EDGE_EXPANDER_DEVICE,	"edge expander" },
+	{ SAS_FANOUT_EXPANDER_DEVICE,	"fanout expander" },
+};
+sas_bitfield_name_search(device_type, sas_device_type_names)
+
+
+static struct {
+	u32		value;
+	char		*name;
+} sas_protocol_names[] = {
+	{ SAS_PROTOCOL_SATA,		"sata" },
+	{ SAS_PROTOCOL_SMP,		"smp" },
+	{ SAS_PROTOCOL_STP,		"stp" },
+	{ SAS_PROTOCOL_SSP,		"ssp" },
+};
+sas_bitfield_name_match(protocol, sas_protocol_names)
+
+static struct {
+	u32		value;
+	char		*name;
+} sas_linkspeed_names[] = {
+	{ SAS_LINK_RATE_UNKNOWN,	"Unknown" },
+	{ SAS_PHY_DISABLED,		"Phy disabled" },
+	{ SAS_LINK_RATE_FAILED,		"Link Rate failed" },
+	{ SAS_SATA_SPINUP_HOLD,		"Spin-up hold" },
+	{ SAS_LINK_RATE_1_5_GBPS,	"1.5 Gbit" },
+	{ SAS_LINK_RATE_3_0_GBPS,	"3.0 Gbit" },
+};
+sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
+
+
+/*
+ * SAS target attributes
+ */
+
+#define sas_transport_show_simple(field, name, format_string)		\
+static ssize_t								\
+show_sas_transport_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct sas_transport_attrs *tp;					\
+									\
+	tp = (struct sas_transport_attrs *)&starget->starget_data;	\
+	return snprintf(buf, 20, format_string, tp->field);		\
+}
+
+#define sas_transport_simple_attr(field, name, format_string)		\
+	sas_transport_show_simple(field, name, format_string)		\
+static SAS_CLASS_DEVICE_ATTR(transport, name, S_IRUGO, 			\
+		show_sas_transport_##name, NULL)
+
+#define sas_transport_show_protocol(field, name)			\
+static ssize_t								\
+show_sas_transport_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct sas_transport_attrs *tp =				\
+		(struct sas_transport_attrs *)&starget->starget_data;	\
+									\
+	if (!tp->field)							\
+		return snprintf(buf, 20, "none\n");			\
+	return get_sas_protocol_names(tp->field, buf);			\
+}
+
+#define sas_transport_protocol_attr(field, name)			\
+	sas_transport_show_protocol(field, name)			\
+static SAS_CLASS_DEVICE_ATTR(transport, name, S_IRUGO,			\
+		show_sas_transport_##name, NULL)
+
+static ssize_t
+show_sas_transport_device_type(struct class_device *cdev, char *buf)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct sas_transport_attrs *tp =
+		(struct sas_transport_attrs *)&starget->starget_data;
+
+	if (!tp->attached.device_type)
+		return snprintf(buf, 20, "none\n");
+	return get_sas_device_type_names(tp->attached.device_type, buf);
+}
+
+static SAS_CLASS_DEVICE_ATTR(transport, device_type, S_IRUGO,
+		show_sas_transport_device_type, NULL);
+
+sas_transport_protocol_attr(attached.initiator_port_protocols,
+		initiator_port_protocols);
+sas_transport_protocol_attr(attached.target_port_protocols,
+		target_port_protocols);
+sas_transport_simple_attr(attached.sas_address,
+		sas_address, "0x%llx\n");
+sas_transport_simple_attr(attached.phy_identifier,
+		phy_identifier, "%d\n");
+
+static DECLARE_TRANSPORT_CLASS(sas_transport_class,
+		"sas_transport", NULL, NULL, NULL);
+
+static int sas_target_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+
+	if (!scsi_is_target_device(dev))
+		return 0;
+	shost = dev_to_shost(dev->parent);
+
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->target_attrs.ac.class !=
+			&sas_transport_class.class)
+		return 0;
+
+	i = to_sas_internal(shost->transportt);
+	return &i->t.target_attrs.ac == cont;
+}
+
+void sas_add_target(struct sas_port *port, struct sas_identify *attached,
+		uint channel, uint target)
+{
+	if (attached->target_port_protocols &
+	    (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA))
+		scsi_scan_target(&port->dev, channel, target, ~0, 0, attached);
+}
+EXPORT_SYMBOL(sas_add_target);
+
+
+/*
+ * SAS Port attributes
+ */
+
+#define sas_port_show_simple(field, name, format_string)		\
+static ssize_t								\
+show_sas_port_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_port *port = transport_class_to_port(cdev);		\
+									\
+	return snprintf(buf, 20, format_string, port->attrs->field);	\
+}
+
+#define sas_port_simple_attr(field, name, format_string)		\
+	sas_port_show_simple(field, name, format_string)		\
+static CLASS_DEVICE_ATTR(name, S_IRUGO, show_sas_port_##name, NULL)
+
+#define sas_port_show_protocol(field, name)				\
+static ssize_t								\
+show_sas_port_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_port *port = transport_class_to_port(cdev);		\
+									\
+	if (!port->attrs->field)					\
+		return snprintf(buf, 20, "none\n");			\
+	return get_sas_protocol_names(port->attrs->field, buf);		\
+}
+
+#define sas_port_protocol_attr(field, name)				\
+	sas_port_show_protocol(field, name)				\
+static CLASS_DEVICE_ATTR(name, S_IRUGO, show_sas_port_##name, NULL)
+
+#define sas_port_show_linkspeed(field)					\
+static ssize_t								\
+show_sas_port_##field(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_port *port = transport_class_to_port(cdev);		\
+									\
+	return get_sas_linkspeed_names(port->attrs->field, buf);	\
+}
+
+#define sas_port_linkspeed_attr(field)					\
+	sas_port_show_linkspeed(field)					\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_sas_port_##field, NULL)
+
+static ssize_t
+show_sas_device_type(struct class_device *cdev, char *buf)
+{
+	struct sas_port *port = transport_class_to_port(cdev);
+
+	if (!port->attrs->identify.device_type)
+		return snprintf(buf, 20, "none\n");
+	return get_sas_device_type_names(
+			port->attrs->identify.device_type, buf);
+}
+
+static CLASS_DEVICE_ATTR(device_type, S_IRUGO, show_sas_device_type, NULL);
+
+sas_port_protocol_attr(identify.initiator_port_protocols,
+		initiator_port_protocols);
+sas_port_protocol_attr(identify.target_port_protocols,
+		target_port_protocols);
+sas_port_simple_attr(identify.sas_address,
+		sas_address, "0x%llx\n");
+sas_port_simple_attr(identify.phy_identifier,
+		phy_identifier, "%d\n");
+sas_port_simple_attr(port_identifier, port_identifier, "%d\n");
+sas_port_linkspeed_attr(negotiated_linkrate);
+sas_port_linkspeed_attr(minimum_linkrate_hw);
+sas_port_linkspeed_attr(minimum_linkrate);
+sas_port_linkspeed_attr(maximum_linkrate_hw);
+sas_port_linkspeed_attr(maximum_linkrate);
+
+
+static DECLARE_TRANSPORT_CLASS(sas_port_class,
+		"sas_port", NULL, NULL, NULL);
+
+static int sas_port_match(struct attribute_container *cont, struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+
+	if (!scsi_is_sas_port(dev))
+		return 0;
+	shost = dev_to_shost(dev->parent);
+
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->target_attrs.ac.class !=
+			&sas_transport_class.class)
+		return 0;
+
+	i = to_sas_internal(shost->transportt);
+	return &i->port_attr_cont.ac == cont;
+}
+
+static void sas_port_release(struct device *dev)
+{
+	struct sas_port *port = dev_to_port(dev);
+
+	kfree(port->attrs);
+	put_device(dev->parent);
+	kfree(port);
+}
+
+struct sas_port *
+sas_port_add(struct Scsi_Host *shost, int number,
+		struct sas_port_attrs *attrs)
+{
+	struct sas_port *port;
+	int error;
+
+	port = kmalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return ERR_PTR(-ENOMEM);
+	memset(port, 0, sizeof(*port));
+
+	get_device(&shost->shost_gendev);
+
+	port->attrs = attrs;
+	port->number = number;
+
+	device_initialize(&port->dev);
+	port->dev.parent = get_device(&shost->shost_gendev);
+	port->dev.release = sas_port_release;
+	sprintf(port->dev.bus_id, "port-%d:%d",
+		shost->host_no, number);
+	transport_setup_device(&port->dev);
+
+	error = device_add(&port->dev);
+	if (error)
+		goto out_transport_destroy;
+	transport_add_device(&port->dev);
+	transport_configure_device(&port->dev);
+
+	return port;
+
+ out_transport_destroy:
+	transport_destroy_device(&port->dev);
+	put_device(port->dev.parent);
+	put_device(port->dev.parent);
+	put_device(&shost->shost_gendev);
+	kfree(port);
+	return NULL;
+}
+EXPORT_SYMBOL(sas_port_add);
+
+void
+sas_port_delete(struct sas_port *port)
+{
+	struct Scsi_Host *shost = port_to_shost(port);
+	struct device *dev = &port->dev;
+
+	scsi_remove_target(&port->dev);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(&shost->shost_gendev);
+}
+EXPORT_SYMBOL(sas_port_delete);
+
+int scsi_is_sas_port(const struct device *dev)
+{
+	return dev->release == sas_port_release;
+}
+EXPORT_SYMBOL(scsi_is_sas_port);
+
+
+/*
+ * Setup / Teardown code
+ */
+
+#define SETUP_TARGET_ATTRIBUTE(field)					\
+	i->private_target_attrs[count] = class_device_attr_##field;	\
+	i->private_target_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_target_attrs[count].store = NULL;			\
+	i->target_attrs[count] = &i->private_target_attrs[count];	\
+	count++
+
+#define SETUP_PORT_ATTRIBUTE(field)					\
+	i->private_port_attrs[count] = class_device_attr_##field;	\
+        i->private_port_attrs[count].attr.mode = S_IRUGO;		\
+        i->private_port_attrs[count].store = NULL;			\
+        i->port_attrs[count] = &i->private_port_attrs[count];		\
+	count++
+
+struct scsi_transport_template *
+sas_attach_transport(struct sas_function_template *ft)
+{
+	struct sas_internal *i;
+	int count;
+
+	i = kmalloc(sizeof(struct sas_internal), GFP_KERNEL);
+	if (!i)
+		return NULL;
+	memset(i, 0, sizeof(struct sas_internal));
+
+	i->t.target_attrs.ac.class = &sas_transport_class.class;
+	i->t.target_attrs.ac.attrs = &i->target_attrs[0];
+	i->t.target_attrs.ac.match = sas_target_match;
+	transport_container_register(&i->t.target_attrs);
+	i->t.target_size = sizeof(struct sas_transport_attrs);
+
+	i->port_attr_cont.ac.class = &sas_port_class.class;
+	i->port_attr_cont.ac.attrs = &i->port_attrs[0];
+	i->port_attr_cont.ac.match = sas_port_match;
+	transport_container_register(&i->port_attr_cont);
+
+	i->f = ft;
+
+	count = 0;
+	SETUP_PORT_ATTRIBUTE(initiator_port_protocols);
+	SETUP_PORT_ATTRIBUTE(target_port_protocols);
+	SETUP_PORT_ATTRIBUTE(device_type);
+	SETUP_PORT_ATTRIBUTE(sas_address);
+	SETUP_PORT_ATTRIBUTE(phy_identifier);
+	SETUP_PORT_ATTRIBUTE(port_identifier);
+	SETUP_PORT_ATTRIBUTE(negotiated_linkrate);
+	SETUP_PORT_ATTRIBUTE(minimum_linkrate_hw);
+	SETUP_PORT_ATTRIBUTE(minimum_linkrate);
+	SETUP_PORT_ATTRIBUTE(maximum_linkrate_hw);
+	SETUP_PORT_ATTRIBUTE(maximum_linkrate);
+	i->port_attrs[count] = NULL;
+
+	count = 0;
+	SETUP_TARGET_ATTRIBUTE(transport_initiator_port_protocols);
+	SETUP_TARGET_ATTRIBUTE(transport_target_port_protocols);
+	SETUP_TARGET_ATTRIBUTE(transport_device_type);
+	SETUP_TARGET_ATTRIBUTE(transport_sas_address);
+	SETUP_TARGET_ATTRIBUTE(transport_phy_identifier);
+	i->target_attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(sas_attach_transport);
+
+void sas_release_transport(struct scsi_transport_template *t)
+{
+	struct sas_internal *i = to_sas_internal(t);
+
+	transport_container_unregister(&i->t.target_attrs);
+	transport_container_unregister(&i->port_attr_cont);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(sas_release_transport);
+
+static __init int sas_transport_init(void)
+{
+	int error = transport_class_register(&sas_transport_class);
+	if (!error) {
+		error = transport_class_register(&sas_port_class);
+		if (error)
+			transport_class_unregister(&sas_transport_class);
+	}
+	return error;
+
+}
+
+static void __exit sas_transport_exit(void)
+{
+	transport_class_unregister(&sas_transport_class);
+	transport_class_unregister(&sas_port_class);
+}
+
+MODULE_AUTHOR("Christoph Hellwig");
+MODULE_DESCRIPTION("SAS Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(sas_transport_init);
+module_exit(sas_transport_exit);
Index: scsi-misc-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ scsi-misc-2.6/include/scsi/scsi_transport_sas.h	2005-08-15 15:33:45.000000000 +0200
@@ -0,0 +1,88 @@
+#ifndef SCSI_TRANSPORT_SAS_H
+#define SCSI_TRANSPORT_SAS_H
+
+#include <linux/transport_class.h>
+#include <linux/types.h>
+
+
+struct scsi_transport_template;
+
+enum sas_device_type {
+	SAS_PHY_UNUSED			= 0x00,
+	SAS_END_DEVICE			= 0x10,
+	SAS_EDGE_EXPANDER_DEVICE	= 0x20,
+	SAS_FANOUT_EXPANDER_DEVICE	= 0x30,
+};
+
+enum sas_protocol {
+	SAS_PROTOCOL_SATA		= 0x01,
+	SAS_PROTOCOL_SMP		= 0x02,
+	SAS_PROTOCOL_STP		= 0x04,
+	SAS_PROTOCOL_SSP		= 0x08,
+};
+
+enum sas_linkrate {
+	SAS_LINK_RATE_UNKNOWN		= 0x00,
+	SAS_PHY_DISABLED		= 0x01,
+	SAS_LINK_RATE_FAILED		= 0x02,
+	SAS_SATA_SPINUP_HOLD		= 0x03,
+	SAS_SATA_PORT_SELECTOR		= 0x04,
+	SAS_LINK_RATE_1_5_GBPS		= 0x08,
+	SAS_LINK_RATE_3_0_GBPS		= 0x09,
+	SAS_LINK_VIRTUAL		= 0x10,
+};
+
+struct sas_identify {
+	enum sas_device_type	device_type;
+	enum sas_protocol	initiator_port_protocols;
+	enum sas_protocol	target_port_protocols;
+	u64			sas_address;
+	u8			phy_identifier;
+};
+
+struct sas_transport_attrs {
+	struct sas_identify	attached;
+};
+
+struct sas_port_attrs {
+	struct list_head	port_list;
+	struct sas_identify	identify;
+	struct sas_identify	attached;
+	enum sas_linkrate	negotiated_linkrate;
+	enum sas_linkrate	minimum_linkrate_hw;
+	enum sas_linkrate	minimum_linkrate;
+	enum sas_linkrate	maximum_linkrate_hw;
+	enum sas_linkrate	maximum_linkrate;
+	u8			port_identifier;
+};
+
+/* The functions by which the transport class and the driver communicate */
+struct sas_function_template {
+};
+
+struct sas_port {
+	struct device		dev;
+	int			number;
+	struct sas_port_attrs	*attrs;
+};
+
+#define dev_to_port(d) \
+	container_of((d), struct sas_port, dev)
+#define transport_class_to_port(cdev) \
+	dev_to_port((cdev)->dev)
+#define port_to_shost(port) \
+	dev_to_shost((port)->dev.parent)
+
+extern void sas_add_target(struct sas_port *, struct sas_identify *,
+		uint, uint);
+
+extern struct sas_port *sas_port_add(struct Scsi_Host *, int,
+		struct sas_port_attrs *);
+extern void sas_port_delete(struct sas_port *);
+extern int scsi_is_sas_port(const struct device *);
+
+extern struct scsi_transport_template *
+sas_attach_transport(struct sas_function_template *);
+extern void sas_release_transport(struct scsi_transport_template *);
+
+#endif /* SCSI_TRANSPORT_SAS_H */
