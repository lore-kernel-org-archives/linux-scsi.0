From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] add srp transport class
Date: Wed, 27 Jun 2007 16:32:39 +0900
Message-ID: <20070627163239D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:36929 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXF0Lqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2007 07:46:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, santil@us.ibm.com, rdreier@cisco.com

This adds srp transport class that works with ib_srp and ibmvscsi.

It creates only /sys/class/{srp_host,srp_remote_ports} and
srp_remote_ports has only "port_id" attribute.

viola:/sys/class/srp_remote_ports/port-0:1# ls
device  port_id  subsystem  uevent
viola:/sys/class/srp_remote_ports/port-0:1# cat port_id
4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/Kconfig              |    7 +
 drivers/scsi/Makefile             |    1 +
 drivers/scsi/scsi_transport_srp.c |  320 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_srp.h |   32 ++++
 4 files changed, 360 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 874cfee..c261ccb 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -283,6 +283,13 @@ config SCSI_SAS_ATTRS
 
 source "drivers/scsi/libsas/Kconfig"
 
+config SCSI_SRP_ATTRS
+	tristate "SRP Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached SRP device to sysfs, say Y.
+
 endmenu
 
 menu "SCSI low-level drivers"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 3027b53..0943b4c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_tra
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
+obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
new file mode 100644
index 0000000..dcb3d2a
--- /dev/null
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -0,0 +1,320 @@
+/*
+ * SCSI RDMA (SRP) transport class
+ *
+ * Copyright (C) 2007 FUJITA Tomonori <tomof@acm.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_srp.h>
+
+struct srp_host_attrs {
+	atomic_t next_port_id;
+};
+#define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
+
+#define SRP_HOST_ATTRS 0
+#define SRP_RPORT_ATTRS 3
+
+struct srp_internal {
+	struct scsi_transport_template t;
+	struct srp_function_template *f;
+
+	struct class_device_attribute *host_attrs[SRP_HOST_ATTRS + 1];
+
+	struct class_device_attribute *rport_attrs[SRP_RPORT_ATTRS + 1];
+	struct class_device_attribute private_rport_attrs[SRP_RPORT_ATTRS];
+	struct transport_container rport_attr_cont;
+};
+
+#define to_srp_internal(tmpl) container_of(tmpl, struct srp_internal, t)
+
+#define	dev_to_rport(d)	container_of(d, struct srp_rport, dev)
+#define transport_class_to_srp_rport(cdev) dev_to_rport((cdev)->dev)
+
+static int srp_host_setup(struct transport_container *tc, struct device *dev,
+			  struct class_device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
+
+	atomic_set(&srp_host->next_port_id, 0);
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(srp_host_class, "srp_host", srp_host_setup,
+			       NULL, NULL);
+
+static DECLARE_TRANSPORT_CLASS(srp_rport_class, "srp_remote_ports",
+			       NULL, NULL, NULL);
+
+#define SETUP_TEMPLATE(attrb, field, perm, test, ro_test, ro_perm)	\
+	i->private_##attrb[count] = class_device_attr_##field;		\
+	i->private_##attrb[count].attr.mode = perm;			\
+	if (ro_test) {							\
+		i->private_##attrb[count].attr.mode = ro_perm;		\
+		i->private_##attrb[count].store = NULL;			\
+	}								\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
+
+#define SETUP_RPORT_ATTRIBUTE_RD(field)					\
+	SETUP_TEMPLATE(rport_attrs, field, S_IRUGO, 1, 0, 0)
+
+#define SETUP_RPORT_ATTRIBUTE_RW(field)					\
+	SETUP_TEMPLATE(rport_attrs, field, S_IRUGO | S_IWUSR,		\
+		       1, 1, S_IRUGO)
+
+#define SRP_PID(p) \
+	(p)->port_id[0], (p)->port_id[1], (p)->port_id[2], (p)->port_id[3], \
+	(p)->port_id[4], (p)->port_id[5], (p)->port_id[6], (p)->port_id[7], \
+	(p)->port_id[8], (p)->port_id[9], (p)->port_id[10], (p)->port_id[11], \
+	(p)->port_id[12], (p)->port_id[13], (p)->port_id[14], (p)->port_id[15]
+
+#define SRP_PID_FMT "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:" \
+	"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x"
+
+static ssize_t
+show_srp_rport_id(struct class_device *cdev, char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(cdev);
+	return sprintf(buf, SRP_PID_FMT "\n", SRP_PID(rport));
+}
+
+static CLASS_DEVICE_ATTR(port_id, S_IRUGO, show_srp_rport_id, NULL);
+
+static void srp_rport_release(struct device *dev)
+{
+	struct srp_rport *rport = dev_to_rport(dev);
+
+	put_device(dev->parent);
+	kfree(rport);
+}
+
+static int scsi_is_srp_rport(const struct device *dev)
+{
+	return dev->release == srp_rport_release;
+}
+
+static int srp_rport_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct srp_internal *i;
+
+	if (!scsi_is_srp_rport(dev))
+		return 0;
+
+	shost = dev_to_shost(dev->parent);
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class != &srp_host_class.class)
+		return 0;
+
+	i = to_srp_internal(shost->transportt);
+	return &i->rport_attr_cont.ac == cont;
+}
+
+static int srp_host_match(struct attribute_container *cont, struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct srp_internal *i;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt)
+		return 0;
+	if (shost->transportt->host_attrs.ac.class != &srp_host_class.class)
+		return 0;
+
+	i = to_srp_internal(shost->transportt);
+	return &i->t.host_attrs.ac == cont;
+}
+
+/**
+ * srp_rport_add - add a SRP remote port to the device hierarchy
+ *
+ * @shost:	scsi host the remote port is connected to.
+ * @ids:	The port id for the remote port.
+ *
+ * publishes a port to the rest of the system
+ */
+struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
+				struct srp_rport_identifiers *ids)
+{
+	struct srp_rport *rport;
+	struct device *parent = &shost->shost_gendev;
+	int id, ret;
+
+	rport = kzalloc(sizeof(*rport), GFP_KERNEL);
+	if (!rport)
+		return ERR_PTR(-ENOMEM);
+
+	device_initialize(&rport->dev);
+
+	rport->dev.parent = get_device(parent);
+	rport->dev.release = srp_rport_release;
+
+	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
+
+	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
+	sprintf(rport->dev.bus_id, "port-%d:%d", shost->host_no, id);
+
+	transport_setup_device(&rport->dev);
+
+	ret = device_add(&rport->dev);
+	if (ret) {
+		transport_destroy_device(&rport->dev);
+		put_device(&rport->dev);
+		return ERR_PTR(ret);
+	}
+
+	transport_add_device(&rport->dev);
+	transport_configure_device(&rport->dev);
+
+	return rport;
+}
+EXPORT_SYMBOL_GPL(srp_rport_add);
+
+/**
+ * srp_rport_del  --  remove a SRP remote port
+ * @port:	SRP remote port to remove
+ *
+ * Removes the specified SRP remote port.
+ */
+void srp_rport_del(struct srp_rport *rport)
+{
+	struct device *dev = &rport->dev;
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+EXPORT_SYMBOL_GPL(srp_rport_del);
+
+static int do_srp_rport_del(struct device *dev, void *data)
+{
+	srp_rport_del(dev_to_rport(dev));
+	return 0;
+}
+
+/**
+ * srp_remove_host  --  tear down a Scsi_Host's SRP data structures
+ * @shost:	Scsi Host that is torn down
+ *
+ * Removes all SRP remote ports for a given Scsi_Host.
+ * Must be called just before scsi_remove_host for SRP HBAs.
+ */
+void srp_remove_host(struct Scsi_Host *shost)
+{
+	device_for_each_child(&shost->shost_gendev, NULL, do_srp_rport_del);
+}
+EXPORT_SYMBOL_GPL(srp_remove_host);
+
+/**
+ * srp_attach_transport  --  instantiate SRP transport template
+ * @ft:		SRP transport class function template
+ */
+struct scsi_transport_template *
+srp_attach_transport(struct srp_function_template *ft)
+{
+	int count;
+	struct srp_internal *i;
+
+	i = kzalloc(sizeof(*i), GFP_KERNEL);
+	if (!i)
+		return NULL;
+
+	i->t.host_size = sizeof(struct srp_host_attrs);
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &srp_host_class.class;
+	i->t.host_attrs.ac.match = srp_host_match;
+	i->host_attrs[0] = NULL;
+	transport_container_register(&i->t.host_attrs);
+
+	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
+	i->rport_attr_cont.ac.class = &srp_rport_class.class;
+	i->rport_attr_cont.ac.match = srp_rport_match;
+	transport_container_register(&i->rport_attr_cont);
+
+	count = 0;
+	SETUP_RPORT_ATTRIBUTE_RD(port_id);
+	i->rport_attrs[count] = NULL;
+
+	i->f = ft;
+
+	return &i->t;
+}
+EXPORT_SYMBOL_GPL(srp_attach_transport);
+
+/**
+ * srp_release_transport  --  release SRP transport template instance
+ * @t:		transport template instance
+ */
+void srp_release_transport(struct scsi_transport_template *t)
+{
+	struct srp_internal *i = to_srp_internal(t);
+
+	transport_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->rport_attr_cont);
+
+	kfree(i);
+}
+EXPORT_SYMBOL_GPL(srp_release_transport);
+
+static __init int srp_transport_init(void)
+{
+	int ret;
+
+	ret = transport_class_register(&srp_host_class);
+	if (ret)
+		return ret;
+	ret = transport_class_register(&srp_rport_class);
+	if (ret)
+		goto unregister_host_class;
+
+	return 0;
+unregister_host_class:
+	transport_class_unregister(&srp_host_class);
+	return ret;
+}
+
+static void __exit srp_transport_exit(void)
+{
+	transport_class_unregister(&srp_host_class);
+	transport_class_unregister(&srp_rport_class);
+}
+
+MODULE_AUTHOR("FUJITA Tomonori");
+MODULE_DESCRIPTION("SRP Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(srp_transport_init);
+module_exit(srp_transport_exit);
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
new file mode 100644
index 0000000..adbfca4
--- /dev/null
+++ b/include/scsi/scsi_transport_srp.h
@@ -0,0 +1,32 @@
+#ifndef SCSI_TRANSPORT_SRP_H
+#define SCSI_TRANSPORT_SRP_H
+
+#include <linux/transport_class.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+
+struct srp_rport_identifiers {
+	u8 port_id[16];
+};
+
+struct srp_rport {
+	struct device dev;
+
+	u8 port_id[16];
+};
+
+struct srp_function_template {
+	/* later */
+};
+
+extern struct scsi_transport_template *
+srp_attach_transport(struct srp_function_template *);
+extern void srp_release_transport(struct scsi_transport_template *);
+
+extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
+				       struct srp_rport_identifiers *);
+extern void srp_rport_del(struct srp_rport *);
+
+extern void srp_remove_host(struct Scsi_Host *);
+
+#endif
-- 
1.4.3.2

