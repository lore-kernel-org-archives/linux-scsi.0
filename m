From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] iSCSI transport class
Date: Fri, 29 Oct 2004 05:14:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41823426.5090007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060105010608030500090101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53688 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S263293AbUJ2MPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 08:15:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-iscsi-devel@lists.sourceforge.net, duane.grigsby@qlogic.com, James Dykman <dykman@us.ibm.com>

This is a multi-part message in MIME format.
--------------060105010608030500090101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch adds an iSCSI transport class. It was
built against scsi-misc-2.6. It allows the software/virtual
iSCSI driver to remove at least one of its ioctl commands.
The patch also assumes the no multipath/failover rule in
llds applies to iSCSI drivers, so when we remove our
portal/portal_group failover support it will allow us to
kill all our ioctl commands execpt the session creation one
(that will take more thought).

We would like to build some functions like the
unblock/block capabilites into the iscsi transport class
like James Smart has done with FC class. but initially we
would like to begin with this smaller patch that only provides
an iscsi sysfs interface.

Comments? Suggestions?

I put some patches to convert our driver here
http://www.cs.wisc.edu/~michaelc/iscsi/sysfs/
if you want to test the class out. Those patches
were made against the current linux-iscsi cvs tree.

Mike Christie

--------------060105010608030500090101
Content-Type: text/x-patch;
 name="iscsi-transport-class3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iscsi-transport-class3.patch"

diff -Naurp scsi-misc-2.6.orig/drivers/scsi/Kconfig scsi-misc-2.6.work/drivers/scsi/Kconfig
--- scsi-misc-2.6.orig/drivers/scsi/Kconfig	2004-10-29 04:20:38.000000000 -0700
+++ scsi-misc-2.6.work/drivers/scsi/Kconfig	2004-10-28 20:57:11.000000000 -0700
@@ -203,6 +203,14 @@ config SCSI_FC_ATTRS
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
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/Makefile scsi-misc-2.6.work/drivers/scsi/Makefile
--- scsi-misc-2.6.orig/drivers/scsi/Makefile	2004-10-29 04:20:33.000000000 -0700
+++ scsi-misc-2.6.work/drivers/scsi/Makefile	2004-10-28 20:57:11.000000000 -0700
@@ -28,7 +28,7 @@ obj-$(CONFIG_SCSI)		+= scsi_mod.o
 # --------------------------
 obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_transport_spi.o
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
-
+obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/scsi_transport_iscsi.c scsi-misc-2.6.work/drivers/scsi/scsi_transport_iscsi.c
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_iscsi.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.work/drivers/scsi/scsi_transport_iscsi.c	2004-10-29 04:30:19.992065756 -0700
@@ -0,0 +1,355 @@
+/* 
+ * iSCSI transport class definitions
+ *
+ * Copyright (C) IBM Corporation, 2004
+ * Copyright (C) Mike Christie, 2004
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
+
+#define ISCSI_SESSION_ATTRS 20
+#define ISCSI_HOST_ATTRS 2
+
+struct iscsi_internal {
+	struct scsi_transport_template t;
+	struct iscsi_function_template *fnt;
+	/*
+	 * We do not have any private or other attrs.
+	 */
+	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
+	struct class_device_attribute *host_attrs[ISCSI_HOST_ATTRS + 1];
+};
+
+#define to_iscsi_internal(tmpl) container_of(tmpl, struct iscsi_internal, t)
+
+static void iscsi_transport_class_release(struct class_device *class_dev)
+{
+	struct scsi_target *starget = transport_class_to_starget(class_dev);
+	put_device(&starget->dev);
+}
+
+struct class iscsi_transport_class = {
+	.name = "iscsi_transport_class",
+	.release = iscsi_transport_class_release,
+};
+
+static void iscsi_host_class_release(struct class_device *class_dev)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
+	put_device(&shost->shost_gendev);
+}
+
+struct class iscsi_host_class = {
+	.name = "iscsi_host",
+	.release = iscsi_host_class_release,
+};
+
+/*
+ * iSCSI target and session attrs
+ */
+#define iscsi_session_show_fn(field, format)				\
+									\
+static ssize_t								\
+show_session_##field(struct class_device *cdev, char *buf)		\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_##field)					\
+		i->fnt->get_##field(starget);				\
+	return snprintf(buf, 20, format"\n", iscsi_##field(starget));	\
+}
+
+#define iscsi_session_rd_attr(field, format)				\
+	iscsi_session_show_fn(field, format)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_##field, NULL);
+
+iscsi_session_rd_attr(tpgt, "%hu");
+iscsi_session_rd_attr(tsih, "%2x");
+iscsi_session_rd_attr(max_recv_data_segment_len, "%u");
+iscsi_session_rd_attr(max_burst_len, "%u");
+iscsi_session_rd_attr(first_burst_len, "%u");
+iscsi_session_rd_attr(def_time2wait, "%hu");
+iscsi_session_rd_attr(def_time2retain, "%hu");
+iscsi_session_rd_attr(max_outstanding_r2t, "%hu");
+iscsi_session_rd_attr(erl, "%d");
+
+
+#define iscsi_session_show_bool_fn(field)				\
+									\
+static ssize_t								\
+show_session_bool_##field(struct class_device *cdev, char *buf)		\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_##field)					\
+		i->fnt->get_##field(starget);				\
+									\
+	if (iscsi_##field(starget))					\
+		return sprintf(buf, "Yes\n");				\
+	return sprintf(buf, "No\n");					\
+}
+
+#define iscsi_session_rd_bool_attr(field)				\
+	iscsi_session_show_bool_fn(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_bool_##field, NULL);
+
+iscsi_session_rd_bool_attr(initial_r2t);
+iscsi_session_rd_bool_attr(immediate_data);
+iscsi_session_rd_bool_attr(data_pdu_in_order);
+iscsi_session_rd_bool_attr(data_sequence_in_order);
+
+#define iscsi_session_show_digest_fn(field)				\
+									\
+static ssize_t								\
+show_##field(struct class_device *cdev, char *buf)			\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_##field)					\
+		i->fnt->get_##field(starget);				\
+									\
+	if (iscsi_##field(starget))					\
+		return sprintf(buf, "CRC32C\n");			\
+	return sprintf(buf, "None\n");					\
+}
+
+#define iscsi_session_rd_digest_attr(field)				\
+	iscsi_session_show_digest_fn(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_##field, NULL);
+
+iscsi_session_rd_digest_attr(header_digest);
+iscsi_session_rd_digest_attr(data_digest);
+
+static ssize_t
+show_port(struct class_device *cdev, char *buf)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	if (i->fnt->get_port)
+		i->fnt->get_port(starget);
+
+	return snprintf(buf, 20, "%hu\n", ntohs(iscsi_port(starget)));
+}
+static CLASS_DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
+
+static ssize_t
+show_ip_address(struct class_device *cdev, char *buf)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	if (i->fnt->get_ip_address)
+		i->fnt->get_ip_address(starget);
+
+	if (iscsi_addr_type(starget) == AF_INET)
+		return sprintf(buf, "%u.%u.%u.%u\n",
+			       NIPQUAD(iscsi_sin_addr(starget)));
+	else if(iscsi_addr_type(starget) == AF_INET6)
+		return sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
+			       NIP6(iscsi_sin6_addr(starget)));
+	return -EINVAL;
+}
+static CLASS_DEVICE_ATTR(ip_address, S_IRUGO, show_ip_address, NULL);
+
+static ssize_t
+show_isid(struct class_device *cdev, char *buf)
+{
+	struct scsi_target *starget = transport_class_to_starget(cdev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	if (i->fnt->get_isid)
+		i->fnt->get_isid(starget);
+
+	return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
+		       iscsi_isid(starget)[0], iscsi_isid(starget)[1],
+		       iscsi_isid(starget)[2], iscsi_isid(starget)[3],
+		       iscsi_isid(starget)[4], iscsi_isid(starget)[5]);
+}
+static CLASS_DEVICE_ATTR(isid, S_IRUGO, show_isid, NULL);
+
+/*
+ * This is used for iSCSI names. Normally, we follow
+ * the transport class convention of having the lld
+ * set the field, but in these cases the value is
+ * too large.
+ */
+#define iscsi_session_show_str_fn(field)				\
+									\
+static ssize_t								\
+show_session_str_##field(struct class_device *cdev, char *buf)		\
+{									\
+	ssize_t ret = 0;						\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_##field)					\
+		ret = i->fnt->get_##field(starget, buf, PAGE_SIZE);	\
+	return ret;							\
+}
+
+#define iscsi_session_rd_str_attr(field)				\
+	iscsi_session_show_str_fn(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_str_##field, NULL);
+
+iscsi_session_rd_str_attr(target_name);
+iscsi_session_rd_str_attr(target_alias);
+
+/*
+ * iSCSI host attrs
+ */
+
+/*
+ * Again, this is used for iSCSI names. Normally, we follow
+ * the transport class convention of having the lld set
+ * the field, but in these cases the value is too large.
+ */
+#define iscsi_host_show_str_fn(field)					\
+									\
+static ssize_t								\
+show_host_str_##field(struct class_device *cdev, char *buf)		\
+{									\
+	int ret = 0;							\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_##field)					\
+		ret = i->fnt->get_##field(shost, buf, PAGE_SIZE);	\
+	return ret;							\
+}
+
+#define iscsi_host_rd_str_attr(field)					\
+	iscsi_host_show_str_fn(field)					\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_host_str_##field, NULL);
+
+iscsi_host_rd_str_attr(initiator_name);
+iscsi_host_rd_str_attr(initiator_alias);
+
+#define SETUP_SESSION_RD_ATTR(field)					\
+	if (i->fnt->show_##field) {					\
+		i->session_attrs[count] = &class_device_attr_##field;	\
+		count++;						\
+	}
+
+#define SETUP_HOST_RD_ATTR(field)					\
+	if (i->fnt->show_##field) {					\
+		i->host_attrs[count] = &class_device_attr_##field;	\
+		count++;						\
+	}
+
+struct scsi_transport_template *
+iscsi_attach_transport(struct iscsi_function_template *fnt)
+{
+	struct iscsi_internal *i = kmalloc(sizeof(struct iscsi_internal),
+					   GFP_KERNEL);
+	int count = 0;
+
+	if (unlikely(!i))
+		return NULL;
+
+	memset(i, 0, sizeof(struct iscsi_internal));
+	i->fnt = fnt;
+
+	i->t.target_attrs = &i->session_attrs[0];
+	i->t.target_class = &iscsi_transport_class;
+	i->t.target_setup = NULL;
+	i->t.target_size = sizeof(struct iscsi_class_session);
+
+	SETUP_SESSION_RD_ATTR(tsih);
+	SETUP_SESSION_RD_ATTR(isid);
+	SETUP_SESSION_RD_ATTR(header_digest);
+	SETUP_SESSION_RD_ATTR(data_digest);
+	SETUP_SESSION_RD_ATTR(target_name);
+	SETUP_SESSION_RD_ATTR(target_alias);
+	SETUP_SESSION_RD_ATTR(port);
+	SETUP_SESSION_RD_ATTR(tpgt);
+	SETUP_SESSION_RD_ATTR(ip_address);
+	SETUP_SESSION_RD_ATTR(initial_r2t);
+	SETUP_SESSION_RD_ATTR(immediate_data);
+	SETUP_SESSION_RD_ATTR(max_recv_data_segment_len);
+	SETUP_SESSION_RD_ATTR(max_burst_len);
+	SETUP_SESSION_RD_ATTR(first_burst_len);
+	SETUP_SESSION_RD_ATTR(def_time2wait);
+	SETUP_SESSION_RD_ATTR(def_time2retain);
+	SETUP_SESSION_RD_ATTR(max_outstanding_r2t);
+	SETUP_SESSION_RD_ATTR(data_pdu_in_order);
+	SETUP_SESSION_RD_ATTR(data_sequence_in_order);
+	SETUP_SESSION_RD_ATTR(erl);
+
+	BUG_ON(count > ISCSI_SESSION_ATTRS);
+	i->session_attrs[count] = NULL;
+
+	i->t.host_attrs = &i->host_attrs[0];
+	i->t.host_class = &iscsi_host_class;
+	i->t.host_setup = NULL;
+	i->t.host_size = 0;
+
+	count = 0;
+	SETUP_HOST_RD_ATTR(initiator_name);
+	SETUP_HOST_RD_ATTR(initiator_alias);
+
+	BUG_ON(count > ISCSI_HOST_ATTRS);
+	i->host_attrs[count] = NULL;
+
+	return &i->t;
+}
+
+EXPORT_SYMBOL(iscsi_attach_transport);
+
+void iscsi_release_transport(struct scsi_transport_template *t)
+{
+	struct iscsi_internal *i = to_iscsi_internal(t);
+	kfree(i);
+}
+
+EXPORT_SYMBOL(iscsi_release_transport);
+
+static __init int iscsi_transport_init(void)
+{
+	int err = class_register(&iscsi_transport_class);
+
+	if (err)
+		return err;
+	return class_register(&iscsi_host_class);
+}
+
+static void __exit iscsi_transport_exit(void)
+{
+	class_unregister(&iscsi_host_class);
+	class_unregister(&iscsi_transport_class);
+}
+
+module_init(iscsi_transport_init);
+module_exit(iscsi_transport_exit);
+
+MODULE_AUTHOR("Mike Christie");
+MODULE_DESCRIPTION("iSCSI Transport Attributes");
+MODULE_LICENSE("GPL");
diff -Naurp scsi-misc-2.6.orig/include/scsi/scsi_transport_iscsi.h scsi-misc-2.6.work/include/scsi/scsi_transport_iscsi.h
--- scsi-misc-2.6.orig/include/scsi/scsi_transport_iscsi.h	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.work/include/scsi/scsi_transport_iscsi.h	2004-10-29 03:55:13.000000000 -0700
@@ -0,0 +1,178 @@
+/* 
+ * iSCSI transport class definitions
+ *
+ * Copyright (C) IBM Corporation, 2004
+ * Copyright (C) Mike Christie, 2004
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#ifndef SCSI_TRANSPORT_ISCSI_H
+#define SCSI_TRANSPORT_ISCSI_H
+
+#include <linux/config.h>
+#include <linux/in6.h>
+#include <linux/in.h>
+
+struct scsi_transport_template;
+
+struct iscsi_class_session {
+	uint8_t isid[6];
+	uint16_t tsih;
+	int header_digest;		/* 1 CRC32, 0 None */
+	int data_digest;		/* 1 CRC32, 0 None */
+	uint16_t tpgt;
+	union {
+		struct in6_addr sin6_addr;
+		struct in_addr sin_addr;
+	};
+	sa_family_t addr_type;		/* must be AF_INET or AF_INET6 */
+	uint16_t port;			/* must be in network byte order */
+	int initial_r2t;		/* 1 Yes, 0 No */
+	int immediate_data;		/* 1 Yes, 0 No */
+	uint32_t max_recv_data_segment_len;
+	uint32_t max_burst_len;
+	uint32_t first_burst_len;
+	uint16_t def_time2wait;
+	uint16_t def_time2retain;
+	uint16_t max_outstanding_r2t;
+	int data_pdu_in_order;		/* 1 Yes, 0 No */
+	int data_sequence_in_order;	/* 1 Yes, 0 No */
+	int erl;
+};
+
+/*
+ * accessor macros
+ */
+#define iscsi_isid(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->isid)
+#define iscsi_tsih(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->tsih)
+#define iscsi_header_digest(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->header_digest)
+#define iscsi_data_digest(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->data_digest)
+#define iscsi_port(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->port)
+#define iscsi_addr_type(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->addr_type)
+#define iscsi_sin_addr(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->sin_addr)
+#define iscsi_sin6_addr(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->sin6_addr)
+#define iscsi_tpgt(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->tpgt)
+#define iscsi_initial_r2t(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->initial_r2t)
+#define iscsi_immediate_data(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->immediate_data)
+#define iscsi_max_recv_data_segment_len(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->max_recv_data_segment_len)
+#define iscsi_max_burst_len(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->max_burst_len)
+#define iscsi_first_burst_len(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->first_burst_len)
+#define iscsi_def_time2wait(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->def_time2wait)
+#define iscsi_def_time2retain(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->def_time2retain)
+#define iscsi_max_outstanding_r2t(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->max_outstanding_r2t)
+#define iscsi_data_pdu_in_order(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->data_pdu_in_order)
+#define iscsi_data_sequence_in_order(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->data_sequence_in_order)
+#define iscsi_erl(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->erl)
+
+/*
+ * The functions by which the transport class and the driver communicate
+ */
+struct iscsi_function_template {
+	/*
+	 * target attrs
+	 */
+	void (*get_isid)(struct scsi_target *);
+	void (*get_tsih)(struct scsi_target *);
+	void (*get_header_digest)(struct scsi_target *);
+	void (*get_data_digest)(struct scsi_target *);
+	void (*get_port)(struct scsi_target *);
+	void (*get_tpgt)(struct scsi_target *);
+	/*
+	 * In get_ip_address the lld must set the address and
+	 * the address type
+	 */
+	void (*get_ip_address)(struct scsi_target *);
+	/*
+	 * The lld should snprintf the name or alias to the buffer
+	 */
+	ssize_t (*get_target_name)(struct scsi_target *, char *, ssize_t);
+	ssize_t (*get_target_alias)(struct scsi_target *, char *, ssize_t);
+	void (*get_initial_r2t)(struct scsi_target *);
+	void (*get_immediate_data)(struct scsi_target *);
+	void (*get_max_recv_data_segment_len)(struct scsi_target *);
+	void (*get_max_burst_len)(struct scsi_target *);
+	void (*get_first_burst_len)(struct scsi_target *);
+	void (*get_def_time2wait)(struct scsi_target *);
+	void (*get_def_time2retain)(struct scsi_target *);
+	void (*get_max_outstanding_r2t)(struct scsi_target *);
+	void (*get_data_pdu_in_order)(struct scsi_target *);
+	void (*get_data_sequence_in_order)(struct scsi_target *);
+	void (*get_erl)(struct scsi_target *);
+
+	/*
+	 * host atts
+	 */
+
+	/*
+	 * The lld should snprintf the name or alias to the buffer
+	 */
+	ssize_t (*get_initiator_alias)(struct Scsi_Host *, char *, ssize_t);
+	ssize_t (*get_initiator_name)(struct Scsi_Host *, char *, ssize_t);
+	/*
+	 * The driver sets these to tell the transport class it
+	 * wants the attributes displayed in sysfs.  If the show_ flag
+	 * is not set, the attribute will be private to the transport
+	 * class. We could probably just test if a get_ fn was set
+	 * since we only use the values for sysfs but this is how
+	 * fc does it too.
+	 */
+	unsigned long show_isid:1;
+	unsigned long show_tsih:1;
+	unsigned long show_header_digest:1;
+	unsigned long show_data_digest:1;
+	unsigned long show_port:1;
+	unsigned long show_tpgt:1;
+	unsigned long show_ip_address:1;
+	unsigned long show_target_name:1;
+	unsigned long show_target_alias:1;
+	unsigned long show_initial_r2t:1;
+	unsigned long show_immediate_data:1;
+	unsigned long show_max_recv_data_segment_len:1;
+	unsigned long show_max_burst_len:1;
+	unsigned long show_first_burst_len:1;
+	unsigned long show_def_time2wait:1;
+	unsigned long show_def_time2retain:1;
+	unsigned long show_max_outstanding_r2t:1;
+	unsigned long show_data_pdu_in_order:1;
+	unsigned long show_data_sequence_in_order:1;
+	unsigned long show_erl:1;
+	unsigned long show_initiator_name:1;
+	unsigned long show_initiator_alias:1;
+};
+
+struct scsi_transport_template *iscsi_attach_transport(struct iscsi_function_template *);
+void iscsi_release_transport(struct scsi_transport_template *);
+
+#endif

--------------060105010608030500090101--
