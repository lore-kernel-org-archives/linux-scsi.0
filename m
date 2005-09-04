From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] SAS transport class
Date: Mon, 5 Sep 2005 01:50:41 +0200
Message-ID: <20050904235041.GA28799@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37827 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932127AbVIDXup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Sep 2005 19:50:45 -0400
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id j84Nof6t028822
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 5 Sep 2005 01:50:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id j84Nofiv028820
	for linux-scsi@vger.kernel.org; Mon, 5 Sep 2005 01:50:41 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

New version of the SAS transport class.  This now introduces the concept
of remote ports as suggested by James Smart.  Also ports can be layer
ontop of remote ports in addition to scsi hosts to support extenders,
although that functionality is rather theoretical as I didn't manage to
update the Fusion driver for that support yet.  I've also improved the
handling of ports quite a bit, there's a sas_remove_host now that gets
rid of all ports and remote ports, and the API to create ports makes
much more sense.

There's still quite a few review comments I haven't addresses but I
wanted to get a snapshot with support for extenders out.


Index: scsi-misc-2.6/drivers/scsi/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/Kconfig	2005-09-05 01:52:48.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/Kconfig	2005-09-05 01:53:55.000000000 +0200
@@ -235,6 +235,13 @@
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
--- scsi-misc-2.6.orig/drivers/scsi/Makefile	2005-09-05 01:52:48.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/Makefile	2005-09-05 01:53:55.000000000 +0200
@@ -31,6 +31,7 @@
 obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
+obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
Index: scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2005-09-05 01:55:07.000000000 +0200
@@ -0,0 +1,795 @@
+/*
+ * Copyright (C) 2005 Dell Inc.
+ *	Released under GPL v2.
+ *
+ * Serial Attached SCSI (SAS) transport class.
+ *
+ * The SAS transport class contains common code to deal with SAS HBAs,
+ * an aproximated representation of SAS topologies in the driver model,
+ * and various sysfs attributes to expose these topologies and managment
+ * interfaces to userspace.
+ *
+ * In addition to the basic SCSI core objects this transport class
+ * introduces two additional intermediate objects:  The SAS port
+ * as represented by struct sas_port defines an "outgoing" port on
+ * a SAS HBA or Expander, and the SAS remote port represented by
+ * struct sas_rport defines an "incoming" port on a SAS Expander or
+ * End device.  Note that this is purely a software concept, the
+ * underlying hardware for ports and remote ports is the same.
+ *
+ * We also have a sas_host class, but that one doesn't serve any purpose
+ * except giving us a per-host handle that allows us to match devices
+ * that we want to claim.
+ *
+ * Note:  Currently this code does not deal with wide ports at all,
+ *	  thus there is no distinction between ports and phys.  This
+ *	  will be fixed very soon.
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
+#define SAS_HOST_ATTRS		0
+#define SAS_PORT_ATTRS		11
+#define SAS_RPORT_ATTRS		5
+
+struct sas_internal {
+	struct scsi_transport_template t;
+	struct sas_function_template *f;
+
+	struct class_device_attribute private_host_attrs[SAS_HOST_ATTRS];
+	struct class_device_attribute private_port_attrs[SAS_PORT_ATTRS];
+	struct class_device_attribute private_rport_attrs[SAS_RPORT_ATTRS];
+
+	struct transport_container port_attr_cont;
+	struct transport_container rport_attr_cont;
+
+	/*
+	 * The array of null terminated pointers to attributes
+	 * needed by scsi_sysfs.c
+	 */
+	struct class_device_attribute *host_attrs[SAS_HOST_ATTRS + 1];
+	struct class_device_attribute *port_attrs[SAS_PORT_ATTRS + 1];
+	struct class_device_attribute *rport_attrs[SAS_RPORT_ATTRS + 1];
+};
+#define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)
+
+struct sas_host_attrs {
+};
+#define to_sas_host_attrs(host)	((struct sas_host_attrs *)(host)->shost_data)
+
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
+ * SAS host attributes
+ */
+
+static DECLARE_TRANSPORT_CLASS(sas_host_class,
+		"sas_host", NULL, NULL, NULL);
+
+static int sas_host_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+	shost = dev_to_shost(dev);
+
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class !=
+			&sas_host_class.class)
+		return 0;
+
+	i = to_sas_internal(shost->transportt);
+	return &i->t.host_attrs.ac == cont;
+}
+
+static int do_sas_port_delete(struct device *dev, void *data)
+{
+	if (scsi_is_sas_port(dev))
+		sas_port_delete(dev_to_port(dev));
+	return 0;
+}
+
+/**
+ * sas_remove_host  --  tear down a Scsi_Host's SAS data structures
+ * @shost:	Scsi Host that is torn down
+ *
+ * Removes all SAS ports and remote ports for a given Scsi_Host.
+ * Must be called just before scsi_remove_host for SAS HBAs.
+ */
+void sas_remove_host(struct Scsi_Host *shost)
+{
+	device_for_each_child(&shost->shost_gendev, NULL, do_sas_port_delete);
+}
+EXPORT_SYMBOL(sas_remove_host);
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
+	return snprintf(buf, 20, format_string, port->field);		\
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
+	if (!port->field)						\
+		return snprintf(buf, 20, "none\n");			\
+	return get_sas_protocol_names(port->field, buf);		\
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
+	return get_sas_linkspeed_names(port->field, buf);		\
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
+	if (!port->identify.device_type)
+		return snprintf(buf, 20, "none\n");
+	return get_sas_device_type_names(port->identify.device_type, buf);
+}
+
+static CLASS_DEVICE_ATTR(device_type, S_IRUGO, show_sas_device_type, NULL);
+
+sas_port_protocol_attr(identify.initiator_port_protocols,
+		initiator_port_protocols);
+sas_port_protocol_attr(identify.target_port_protocols,
+		target_port_protocols);
+sas_port_simple_attr(identify.sas_address,
+		sas_address, "0x%016llx\n");
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
+	if (shost->transportt->host_attrs.ac.class !=
+			&sas_host_class.class)
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
+	put_device(dev->parent);
+	kfree(port);
+}
+
+/**
+ * sas_port_alloc  --  allocates and initialize a SAS port structure
+ * @parent:	Parent device
+ * @number:	Port number
+ *
+ * Allocates an SAS port structure.  It will be added in the device tree
+ * below the device specified by @parent, which has to be either a Scsi_Host
+ * or sas_rport.
+ *
+ * Returns:
+ *	SAS port allocated or %NULL if the allocation failed.
+ */
+struct sas_port *sas_port_alloc(struct device *parent, int number)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct sas_port *port;
+
+	port = kmalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return NULL;
+	memset(port, 0, sizeof(*port));
+
+	get_device(parent);
+
+	port->number = number;
+
+	device_initialize(&port->dev);
+	port->dev.parent = get_device(parent);
+	port->dev.release = sas_port_release;
+	sprintf(port->dev.bus_id, "port-%d:%d",
+		shost->host_no, number);
+
+	transport_setup_device(&port->dev);
+
+	return port;
+}
+EXPORT_SYMBOL(sas_port_alloc);
+
+/**
+ * sas_port_add  --  add a SAS port to the device hierachy
+ * @port:	The port to be added
+ *
+ * Publishes a SAS port to the rest of the system.
+ */
+void sas_port_add(struct sas_port *port)
+{
+	int error;
+
+	error = device_add(&port->dev);
+	if (error)
+		goto out_transport_destroy;
+	transport_add_device(&port->dev);
+	transport_configure_device(&port->dev);
+	return;
+
+ out_transport_destroy:
+	transport_destroy_device(&port->dev);
+	put_device(port->dev.parent);
+	put_device(port->dev.parent);
+	put_device(port->dev.parent);
+	kfree(port);
+}
+EXPORT_SYMBOL(sas_port_add);
+
+/**
+ * sas_port_delete  --  remove SAS port
+ * @port:	SAS port to remove
+ *
+ * Removes the specified SAS port.  If the SAS port has an
+ * associated remote port it is removed before.
+ */
+void
+sas_port_delete(struct sas_port *port)
+{
+	struct device *dev = &port->dev;
+
+	if (port->rport)
+		sas_rport_delete(port->rport);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev->parent);
+}
+EXPORT_SYMBOL(sas_port_delete);
+
+/**
+ * scsi_is_sas_port  --  check if a struct device represents a SAS port
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a SAS port, %0 else
+ */
+int scsi_is_sas_port(const struct device *dev)
+{
+	return dev->release == sas_port_release;
+}
+EXPORT_SYMBOL(scsi_is_sas_port);
+
+/* copied from drivers/base/core.c */
+static struct device *next_device(struct klist_iter * i)
+{
+	struct klist_node * n = klist_next(i);
+	return n ? container_of(n, struct device, knode_parent) : NULL;
+}
+
+/* should move to drivers/base/core.c */
+static struct device *device_lookup(struct device *parent, void *data,
+		     int (*match)(struct device *, void *))
+
+{
+	struct device *child;
+	struct klist_iter i;
+
+	klist_iter_init(&parent->klist_children, &i);
+	while ((child = next_device(&i))) {
+		if (match(child, data)) {
+			get_device(child);
+			klist_iter_exit(&i);
+			return child;
+		}
+	}
+	klist_iter_exit(&i);
+
+	return NULL;
+}
+
+static int sas_port_lookup_match(struct device *dev, void *data)
+{
+	return scsi_is_sas_port(dev) &&
+		dev_to_port(dev)->number == *((int *)data);
+}
+
+static struct sas_port *sas_port_lookup(struct device *parent, int number)
+{
+	struct device *found;
+
+	found = device_lookup(parent, &number, sas_port_lookup_match);
+	if (!found)
+		return NULL;
+	return dev_to_port(found);
+}
+
+/*
+ * SAS remote port attributes.
+ */
+
+#define sas_rport_show_simple(field, name, format_string)		\
+static ssize_t								\
+show_sas_rport_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_rport *rport = transport_class_to_rport(cdev);	\
+									\
+	return snprintf(buf, 20, format_string, rport->field);		\
+}
+
+#define sas_rport_simple_attr(field, name, format_string)		\
+	sas_rport_show_simple(field, name, format_string)		\
+static SAS_CLASS_DEVICE_ATTR(rport, name, S_IRUGO, 			\
+		show_sas_rport_##name, NULL)
+
+#define sas_rport_show_protocol(field, name)				\
+static ssize_t								\
+show_sas_rport_##name(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_rport *rport = transport_class_to_rport(cdev);	\
+									\
+	if (!rport->field)					\
+		return snprintf(buf, 20, "none\n");			\
+	return get_sas_protocol_names(rport->field, buf);	\
+}
+
+#define sas_rport_protocol_attr(field, name)				\
+	sas_rport_show_protocol(field, name)				\
+static SAS_CLASS_DEVICE_ATTR(rport, name, S_IRUGO,			\
+		show_sas_rport_##name, NULL)
+
+static ssize_t
+show_sas_rport_device_type(struct class_device *cdev, char *buf)
+{
+	struct sas_rport *rport = transport_class_to_rport(cdev);
+
+	if (!rport->identify.device_type)
+		return snprintf(buf, 20, "none\n");
+	return get_sas_device_type_names(
+			rport->identify.device_type, buf);
+}
+
+static SAS_CLASS_DEVICE_ATTR(rport, device_type, S_IRUGO,
+		show_sas_rport_device_type, NULL);
+
+sas_rport_protocol_attr(identify.initiator_port_protocols,
+		initiator_port_protocols);
+sas_rport_protocol_attr(identify.target_port_protocols,
+		target_port_protocols);
+sas_rport_simple_attr(identify.sas_address,
+		sas_address, "0x%016llx\n");
+sas_rport_simple_attr(identify.phy_identifier,
+		phy_identifier, "%d\n");
+
+static DECLARE_TRANSPORT_CLASS(sas_rport_class,
+		"sas_rport", NULL, NULL, NULL);
+
+static int sas_rport_match(struct attribute_container *cont, struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct sas_internal *i;
+
+	if (!scsi_is_sas_rport(dev))
+		return 0;
+	shost = dev_to_shost(dev->parent->parent);
+
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class !=
+			&sas_host_class.class)
+		return 0;
+
+	i = to_sas_internal(shost->transportt);
+	return &i->rport_attr_cont.ac == cont;
+}
+
+static void sas_rport_release(struct device *dev)
+{
+	struct sas_rport *rport = dev_to_rport(dev);
+
+	put_device(dev->parent);
+	kfree(rport);
+}
+
+/**
+ * sas_rport_alloc  --  allocates and initialize a SAS remote port structure
+ * @grandparent:	Parent device of the parent SAS port
+ * @port:		Port number of the parent SAS port
+ * @channel:		SCSI Core channel number
+ * @id:			SCSI Core target id
+ *
+ * Allocates an SAS remote port structure, connected to the port @port of the
+ * Scsi_Host or sas_rport specified by @grandparent.
+ *
+ * Note:
+ *	@channel and @id only make sense for sas ports that support protocols
+ *	support by the SCSI subsystem (ssp, stp or direct attached sata).
+ *
+ *	@id will go away soon, and there will be no visible SPI-ish target
+ *	ID visible to SAS LLDDs.
+ *
+ * Returns:
+ *	SAS port allocated or %NULL if the allocation failed.
+ */
+struct sas_rport *sas_rport_alloc(struct device *grandparent,
+		int port, uint channel, uint id)
+{
+	struct Scsi_Host *shost = dev_to_shost(grandparent);
+	struct sas_port *parent;
+	struct sas_rport *rport;
+
+	parent = sas_port_lookup(grandparent, port);
+	if (!parent)
+		return NULL;
+
+	rport = kmalloc(sizeof(*rport), GFP_KERNEL);
+	if (!rport) {
+		put_device(&parent->dev);
+		return NULL;
+	}
+	memset(rport, 0, sizeof(*rport));
+
+	rport->channel = channel;
+	rport->id = id;
+
+	device_initialize(&rport->dev);
+	rport->dev.parent = get_device(&parent->dev);
+	rport->dev.release = sas_rport_release;
+	sprintf(rport->dev.bus_id, "rport-%d:%d",
+		shost->host_no, parent->number);
+	transport_setup_device(&rport->dev);
+
+	return rport;
+}
+EXPORT_SYMBOL(sas_rport_alloc);
+
+/**
+ * sas_rport_add  --  add a SAS remote port to the device hierachy
+ * @rport:	The remote port to be added
+ *
+ * Publishes a SAS remote port to the rest of the system.
+ */
+void sas_rport_add(struct sas_rport *rport)
+{
+	struct sas_port *parent = dev_to_port(rport->dev.parent);
+	struct sas_identify *identify = &rport->identify;
+	int error;
+
+	if (parent->rport)
+		return;
+	parent->rport = rport;
+
+	error = device_add(&rport->dev);
+	if (error)
+		goto out_transport_destroy;
+	transport_add_device(&rport->dev);
+	transport_configure_device(&rport->dev);
+
+	if (identify->device_type == SAS_END_DEVICE &&
+	    (identify->target_port_protocols &
+	     (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA)))
+		scsi_scan_target(&rport->dev, rport->channel,
+				rport->id, ~0, 0);
+
+	return;
+
+ out_transport_destroy:
+	transport_destroy_device(&rport->dev);
+	put_device(rport->dev.parent);
+	put_device(rport->dev.parent);
+	put_device(rport->dev.parent);
+	kfree(rport);
+}
+EXPORT_SYMBOL(sas_rport_add);
+
+/**
+ * sas_rport_delete  --  remove SAS remote port
+ * @rport:	SAS remote port to remove
+ *
+ * Removes the specified SAS remote port.
+ */
+void
+sas_rport_delete(struct sas_rport *rport)
+{
+	struct device *dev = &rport->dev;
+	struct sas_port *parent = dev_to_port(dev->parent);
+
+	scsi_remove_target(&rport->dev);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(&parent->dev);
+}
+EXPORT_SYMBOL(sas_rport_delete);
+
+/**
+ * scsi_is_sas_rport  --  check if a struct device represents a SAS remote port
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a SAS remote port, %0 else
+ */
+int scsi_is_sas_rport(const struct device *dev)
+{
+	return dev->release == sas_rport_release;
+}
+EXPORT_SYMBOL(scsi_is_sas_rport);
+
+
+/*
+ * Setup / Teardown code
+ */
+
+#define SETUP_RPORT_ATTRIBUTE(field)					\
+	i->private_rport_attrs[count] = class_device_attr_##field;	\
+	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_rport_attrs[count].store = NULL;			\
+	i->rport_attrs[count] = &i->private_rport_attrs[count];	\
+	count++
+
+#define SETUP_PORT_ATTRIBUTE(field)					\
+	i->private_port_attrs[count] = class_device_attr_##field;	\
+        i->private_port_attrs[count].attr.mode = S_IRUGO;		\
+        i->private_port_attrs[count].store = NULL;			\
+        i->port_attrs[count] = &i->private_port_attrs[count];		\
+	count++
+
+
+/**
+ * sas_attach_transport  --  instantiate SAS transport template
+ * @ft:		SAS transport class function template
+ */
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
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &sas_host_class.class;
+	i->t.host_attrs.ac.match = sas_host_match;
+	transport_container_register(&i->t.host_attrs);
+	i->t.host_size = sizeof(struct sas_host_attrs);
+
+	i->port_attr_cont.ac.class = &sas_port_class.class;
+	i->port_attr_cont.ac.attrs = &i->port_attrs[0];
+	i->port_attr_cont.ac.match = sas_port_match;
+	transport_container_register(&i->port_attr_cont);
+
+	i->rport_attr_cont.ac.class = &sas_rport_class.class;
+	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
+	i->rport_attr_cont.ac.match = sas_rport_match;
+	transport_container_register(&i->rport_attr_cont);
+
+	i->f = ft;
+
+	count = 0;
+	i->host_attrs[count] = NULL;
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
+	SETUP_RPORT_ATTRIBUTE(rport_initiator_port_protocols);
+	SETUP_RPORT_ATTRIBUTE(rport_target_port_protocols);
+	SETUP_RPORT_ATTRIBUTE(rport_device_type);
+	SETUP_RPORT_ATTRIBUTE(rport_sas_address);
+	SETUP_RPORT_ATTRIBUTE(rport_phy_identifier);
+	i->rport_attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(sas_attach_transport);
+
+/**
+ * sas_release_transport  --  release SAS transport template instance
+ * @t:		transport template instance
+ */
+void sas_release_transport(struct scsi_transport_template *t)
+{
+	struct sas_internal *i = to_sas_internal(t);
+
+	transport_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->port_attr_cont);
+	transport_container_unregister(&i->rport_attr_cont);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(sas_release_transport);
+
+static __init int sas_transport_init(void)
+{
+	int error;
+
+	error = transport_class_register(&sas_host_class);
+	if (error)
+		goto out;
+	error = transport_class_register(&sas_port_class);
+	if (error)
+		goto out_unregister_transport;
+	error = transport_class_register(&sas_rport_class);
+	if (error)
+		goto out_unregister_port;
+
+	return 0;
+
+ out_unregister_port:
+	transport_class_unregister(&sas_port_class);
+ out_unregister_transport:
+	transport_class_unregister(&sas_host_class);
+ out:
+	return error;
+
+}
+
+static void __exit sas_transport_exit(void)
+{
+	transport_class_unregister(&sas_host_class);
+	transport_class_unregister(&sas_port_class);
+	transport_class_unregister(&sas_rport_class);
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
+++ scsi-misc-2.6/include/scsi/scsi_transport_sas.h	2005-09-05 01:54:02.000000000 +0200
@@ -0,0 +1,101 @@
+#ifndef SCSI_TRANSPORT_SAS_H
+#define SCSI_TRANSPORT_SAS_H
+
+#include <linux/transport_class.h>
+#include <linux/types.h>
+
+struct scsi_transport_template;
+struct sas_rport;
+
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
+/* The functions by which the transport class and the driver communicate */
+struct sas_function_template {
+};
+
+struct sas_port {
+	struct device		dev;
+	int			number;
+
+	struct sas_rport	*rport;
+
+	struct sas_identify	identify;
+	enum sas_linkrate	negotiated_linkrate;
+	enum sas_linkrate	minimum_linkrate_hw;
+	enum sas_linkrate	minimum_linkrate;
+	enum sas_linkrate	maximum_linkrate_hw;
+	enum sas_linkrate	maximum_linkrate;
+	u8			port_identifier;
+};
+
+#define dev_to_port(d) \
+	container_of((d), struct sas_port, dev)
+#define transport_class_to_port(cdev) \
+	dev_to_port((cdev)->dev)
+#define port_to_shost(port) \
+	dev_to_shost((port)->dev.parent)
+
+struct sas_rport {
+	struct device		dev;
+	int			number;
+	uint			channel;
+	uint			id;
+	struct sas_identify	identify;
+};
+
+#define dev_to_rport(d) \
+	container_of((d), struct sas_rport, dev)
+#define transport_class_to_rport(cdev) \
+	dev_to_rport((cdev)->dev)
+#define rport_to_shost(rport) \
+	dev_to_shost((rport)->dev.parent)
+
+extern void sas_remove_host(struct Scsi_Host *);
+
+extern struct sas_port *sas_port_alloc(struct device *, int);
+extern void sas_port_add(struct sas_port *);
+extern void sas_port_delete(struct sas_port *);
+extern int scsi_is_sas_port(const struct device *);
+
+extern struct sas_rport *sas_rport_alloc(struct device *, int, uint, uint);
+extern void sas_rport_add(struct sas_rport *);
+extern void sas_rport_delete(struct sas_rport *);
+extern int scsi_is_sas_rport(const struct device *);
+
+extern struct scsi_transport_template *
+sas_attach_transport(struct sas_function_template *);
+extern void sas_release_transport(struct scsi_transport_template *);
+
+#endif /* SCSI_TRANSPORT_SAS_H */
