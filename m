From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 15:03:20 -0800
Message-ID: <41E309B8.9080703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000004010000070707020607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1500 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262756AbVAJXD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 18:03:27 -0500
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j0AN3Qs8024998
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 17:03:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000004010000070707020607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Implements the driver interface which includes the
IOCTL and sysfs files. We currently do not have
any 32/64 bit conversion code but we will add it
if/when we know for sure the IOCL is the correct way
to go.

--------------000004010000070707020607
Content-Type: text/x-patch;
 name="09-interface.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09-interface.patch"

diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-attr.c scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-attr.c
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-attr.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-attr.c	2005-01-10 12:34:01.270434248 -0800
@@ -0,0 +1,214 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2002 Cisco Systems, Inc.
+ * Copyright (C) 2004 Mike Christie
+ * Copyright (C) 2004 IBM Corporation
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * The sysfs host attributes are defined here. 
+ */
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_host.h>
+
+#include "iscsi-session.h"
+#include "iscsi-sfnet.h"
+
+static ssize_t
+store_do_shutdown(struct class_device *class_dev, const char *buf, size_t count)
+{
+	iscsi_destroy_host(class_to_shost(class_dev));
+	return count;
+}
+
+static ssize_t
+store_drop_session(struct class_device *class_dev, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct iscsi_session *session = (struct iscsi_session *)shost->hostdata;
+
+	iscsi_drop_session(session);
+	return count;
+}
+
+static CLASS_DEVICE_ATTR(shutdown, S_IWUSR, NULL, store_do_shutdown);
+static CLASS_DEVICE_ATTR(drop_session, S_IWUSR, NULL, store_drop_session);
+
+/*
+ * Macro to show session values specific to this driver
+ * on the scsi host's class dev. Some of them could also
+ * be moved to the transport class one day.
+ */
+#define session_show_function(field, format_string)			\
+static ssize_t								\
+show_##field (struct class_device *class_dev, char *buf)		\
+{									\
+	struct Scsi_Host *shost = class_to_shost(class_dev);		\
+	struct iscsi_session *session;					\
+	session = (struct iscsi_session *)shost->hostdata;		\
+	return snprintf(buf, 20, format_string, session->field);	\
+}
+
+#define session_rd_attr(field, format_string)			\
+	session_show_function(field, format_string)		\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_##field, NULL);
+
+/*
+ * These times need to be fixed if they are going to be used
+ * by userspace. Should we also just spit out the time for the app
+ * instead.
+ */
+session_rd_attr(session_established_time, "%lu");
+session_rd_attr(session_drop_time, "%lu");
+session_rd_attr(ever_established, "%d");
+session_rd_attr(login_timeout, "%d");
+session_rd_attr(active_timeout, "%d");
+session_rd_attr(idle_timeout, "%d");
+session_rd_attr(ping_timeout, "%d");
+session_rd_attr(window_closed, "%lu");
+
+struct class_device_attribute *iscsi_host_attrs[] = {
+	&class_device_attr_shutdown,
+	&class_device_attr_drop_session,
+	&class_device_attr_session_established_time,
+	&class_device_attr_session_drop_time,
+	&class_device_attr_ever_established,
+	&class_device_attr_login_timeout,
+	&class_device_attr_active_timeout,
+	&class_device_attr_idle_timeout,
+	&class_device_attr_ping_timeout,
+	&class_device_attr_window_closed,
+	NULL
+};
+
+
+#define iscsi_transport_get_fn(field)					\
+static void								\
+iscsi_get_##field (struct scsi_target *stgt)				\
+{									\
+	struct Scsi_Host *shost = dev_to_shost(stgt->dev.parent);	\
+	struct iscsi_session *session;					\
+	session = (struct iscsi_session *)shost->hostdata;		\
+	iscsi_##field(stgt) = session->field;				\
+}
+
+iscsi_transport_get_fn(tsih);
+iscsi_transport_get_fn(initial_r2t);
+iscsi_transport_get_fn(immediate_data);
+iscsi_transport_get_fn(header_digest);
+iscsi_transport_get_fn(data_digest);
+iscsi_transport_get_fn(max_burst_len);
+iscsi_transport_get_fn(first_burst_len);
+iscsi_transport_get_fn(max_recv_data_segment_len);
+
+#define iscsi_target_transport_cp_fn(field)				\
+static ssize_t								\
+iscsi_get_##field (struct scsi_target *stgt, char *buf, ssize_t count)	\
+{									\
+	struct Scsi_Host *shost = dev_to_shost(stgt->dev.parent);	\
+	struct iscsi_session *session;					\
+	session = (struct iscsi_session *)shost->hostdata;		\
+	return snprintf(buf, count - 1, "%s\n", session->field);	\
+}
+
+iscsi_target_transport_cp_fn(target_name);
+iscsi_target_transport_cp_fn(target_alias);
+
+static void
+iscsi_get_ip_address(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_session *session = (struct iscsi_session *)shost->hostdata;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&session->addr;
+	/*
+	 * I am pretty sure I messed up the socket data structure
+	 * for ipv6 support. For now just do ipv4 until I can test
+	 */
+	iscsi_addr_type(starget) = addr->sin_family;
+	memcpy(&iscsi_sin_addr(starget), &addr->sin_addr,
+	       sizeof(struct in_addr));
+}
+
+static void
+iscsi_get_port(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_session *session = (struct iscsi_session *)shost->hostdata;
+
+	struct sockaddr_in *addr = (struct sockaddr_in *)&session->addr;
+	iscsi_port(starget) = addr->sin_port;
+}
+
+static void
+iscsi_get_tpgt(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_session *session = (struct iscsi_session *)shost->hostdata;
+
+	iscsi_tpgt(starget) = session->portal_group_tag;
+}
+
+static void
+iscsi_get_isid(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_session *session = (struct iscsi_session *)shost->hostdata;
+	memcpy(iscsi_isid(starget), session->isid, sizeof(session->isid));
+}
+
+#define iscsi_host_transport_cp_fn(field)				\
+static ssize_t								\
+iscsi_get_##field (struct Scsi_Host *shost, char *buf, ssize_t count)	\
+{									\
+	struct iscsi_session *s = (struct iscsi_session *)shost->hostdata; \
+	return snprintf(buf, count - 1, "%s\n", s->field);		\
+}
+
+iscsi_host_transport_cp_fn(initiator_name);
+iscsi_host_transport_cp_fn(initiator_alias);
+
+struct iscsi_function_template iscsi_fnt = {
+	.get_isid = iscsi_get_isid,
+	.show_isid = 1,
+	.get_tsih = iscsi_get_tsih,
+	.show_tsih = 1,
+	.get_port = iscsi_get_port,
+	.show_port = 1,
+	.get_tpgt = iscsi_get_tpgt,
+	.show_tpgt = 1,
+	.get_ip_address = iscsi_get_ip_address,
+	.show_ip_address = 1, 
+	.get_initial_r2t = iscsi_get_initial_r2t,
+	.show_initial_r2t = 1,
+	.get_immediate_data = iscsi_get_immediate_data,
+	.show_immediate_data = 1,
+	.get_header_digest = iscsi_get_header_digest,
+	.show_header_digest = 1,
+	.get_data_digest = iscsi_get_data_digest,
+	.show_data_digest = 1,
+	.get_max_burst_len = iscsi_get_max_burst_len,
+	.show_max_burst_len = 1,
+	.get_first_burst_len = iscsi_get_first_burst_len,
+	.show_first_burst_len = 1,
+	.get_max_recv_data_segment_len = iscsi_get_max_recv_data_segment_len,
+	.show_max_recv_data_segment_len = 1,
+	.get_target_name = iscsi_get_target_name,
+	.show_target_name = 1,
+	.get_target_alias = iscsi_get_target_alias,
+	.show_target_alias = 1,
+	.get_initiator_alias = iscsi_get_initiator_alias,
+	.show_initiator_alias = 1,
+	.get_initiator_name = iscsi_get_initiator_name,
+	.show_initiator_name = 1,
+};
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-ioctl.c scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-ioctl.c
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-ioctl.c	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-ioctl.c	2005-01-10 12:34:16.464457282 -0800
@@ -0,0 +1,140 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
+ * Copyright (C) 2004 Mike Christie
+ * Copyright (C) 2004 IBM Corporation
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * This file handles iscsi ioctl calls
+ */
+#include <linux/capability.h>
+#include <asm/uaccess.h>
+
+#include "iscsi-session.h"
+#include "iscsi-ioctl.h"
+#include "iscsi-sfnet.h"
+
+static int
+iscsi_ioctl_establish_session(void __user *arg)
+{
+	int rc;
+	struct iscsi_session *session;
+	struct iscsi_session_ioctl *ioctld;
+
+	ioctld = kmalloc(sizeof(*ioctld), GFP_KERNEL);
+	if (!ioctld) {
+		iscsi_err("Couldn't allocate space for session ioctl data\n");
+		return -ENOMEM;
+	}
+
+	if (copy_from_user(ioctld, (void *)arg, sizeof(*ioctld))) {
+		iscsi_err("Cannot copy session ioctl data\n");
+		kfree(ioctld);
+		return -EFAULT;
+	}
+
+	if (ioctld->ioctl_version != ISCSI_SESSION_IOCTL_VERSION) {
+		iscsi_err("ioctl version %u incorrect, expecting %u\n",
+			  ioctld->ioctl_version, ISCSI_SESSION_IOCTL_VERSION);
+		return -EINVAL;
+	}
+
+	/*
+	 * TODO - should update wait for the relogin?
+	 */
+	session = iscsi_find_session(ioctld->target_name, ioctld->isid,
+				     ioctld->portal.tag);
+	if (session) {
+		rc = iscsi_update_session(session, ioctld);
+		scsi_host_put(session->shost);
+	} else if (ioctld->update) {
+		iscsi_err("Could not find session to update\n");
+		rc = -EAGAIN;
+	} else
+		rc = iscsi_create_host(ioctld);
+
+	kfree(ioctld);
+	return rc;
+}
+
+static int
+iscsi_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	void __user *_arg = (void __user *) arg;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (_IOC_TYPE(cmd) != ISCSI_IOCTL)
+		return -ENOTTY;
+
+	if (cmd == ISCSI_ESTABLISH_SESSION)
+		return iscsi_ioctl_establish_session(_arg);
+
+	iscsi_err("Requested ioctl not found\n");
+	return -EINVAL;
+}
+
+static struct class_simple *iscsictl_sysfs_class;
+static int control_major;
+static const char *control_name = "iscsictl";
+
+static struct file_operations control_fops = {
+      .owner = THIS_MODULE,
+      .ioctl = iscsi_ctl_ioctl,
+};
+
+/*
+ * This file could be replaced with sysfs, but if it stays
+ * we need some 32bit conversion code to work on Power
+ */
+int
+iscsi_register_interface(void)
+{
+	control_major = register_chrdev(0, control_name, &control_fops);
+	if (control_major < 0) {
+		iscsi_err("Failed to register the control device\n");
+		return -ENODEV;
+	}
+	iscsi_notice("Control device major number %d\n", control_major);
+
+	 /* Provide udev support for the control device. */
+	iscsictl_sysfs_class = class_simple_create(THIS_MODULE,
+						   "iscsi_control");
+	if (!iscsictl_sysfs_class)
+		goto unreg_chrdev;
+
+	if (!class_simple_device_add(iscsictl_sysfs_class,
+				     MKDEV(control_major, 0), NULL,
+				     "iscsictl"))
+		goto destroy_iscsictl_cls;
+
+	return 0;
+
+ destroy_iscsictl_cls:
+	class_simple_destroy(iscsictl_sysfs_class);
+ unreg_chrdev:
+	unregister_chrdev(control_major, control_name);
+	return -ENODEV;
+}
+
+void
+iscsi_unregister_interface(void)
+{
+	class_simple_device_remove(MKDEV(control_major, 0));
+	class_simple_destroy(iscsictl_sysfs_class);
+	unregister_chrdev(control_major, control_name);
+}
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-ioctl.h scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-ioctl.h
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-ioctl.h	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-ioctl.h	2005-01-10 12:34:16.464457282 -0800
@@ -0,0 +1,67 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
+ * Copyright (C) 2004 Mike Christie
+ * Copyright (C) 2004 IBM Corporation
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * include for ioctl calls between the daemon and the kernel module
+ */
+#ifndef ISCSI_IOCTL_H_
+#define ISCSI_IOCTL_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#include "iscsi-protocol.h"
+#include "iscsi-portal.h"
+#include "iscsi-auth-client.h"
+
+/*
+ * still not sure if the ioctl is going to stay
+ * so can fix up later
+ */
+struct iscsi_session_ioctl {
+	__u32		ioctl_version;
+	__u32		config_number;
+	int		update;
+	__u8		isid[6];
+	/*
+	 * passwords can contain NULL chars so we need
+	 * the length.
+	 */
+	int		password_length;
+	char		username[AUTH_STR_MAX_LEN];
+	unsigned char	password[AUTH_STR_MAX_LEN];
+	int		password_length_in;
+	char		username_in[AUTH_STR_MAX_LEN];
+	unsigned char	password_in[AUTH_STR_MAX_LEN];
+	unsigned char	target_name[TARGET_NAME_MAXLEN + 1];
+	unsigned char	initiator_name[TARGET_NAME_MAXLEN + 1];
+	unsigned char	initiator_alias[TARGET_NAME_MAXLEN + 1];
+	struct iscsi_portal_info portal;
+};
+
+#define ISCSI_SESSION_IOCTL_VERSION 25
+
+/*
+ * ioctls
+ */
+#define ISCSI_EST_SESS_CMD 0
+
+#define ISCSI_IOCTL 0xbc
+#define ISCSI_ESTABLISH_SESSION _IOW(ISCSI_IOCTL, ISCSI_EST_SESS_CMD, \
+					struct iscsi_session_ioctl)
+#endif
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-protocol.h scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-protocol.h
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/iscsi-protocol.h	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.patch/drivers/scsi/iscsi-sfnet/iscsi-protocol.h	2005-01-10 12:34:22.232707066 -0800
@@ -0,0 +1,53 @@
+/*
+ * iSCSI driver for Linux
+ * Copyright (C) 2001 Cisco Systems, Inc.
+ * maintained by linux-iscsi-devel@lists.sourceforge.net
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * See the file COPYING included with this distribution for more details.
+ *
+ * This file sets up definitions of messages and constants used by the
+ * iSCSI protocol.
+ */
+#ifndef ISCSI_PROTOCOL_H_
+#define ISCSI_PROTOCOL_H_
+
+#include <scsi/iscsi.h>
+
+/* assumes a pointer to a 3-byte array */
+#define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
+
+/* assumes a pointer to a 3 byte array, and an integer value */
+#define hton24(p, v) {\
+        p[0] = (((v) >> 16) & 0xFF); \
+        p[1] = (((v) >> 8) & 0xFF); \
+        p[2] = ((v) & 0xFF); \
+}
+
+/* for Login min, max, active version fields */
+#define ISCSI_MIN_VERSION	ISCSI_DRAFT20_VERSION
+#define ISCSI_MAX_VERSION	ISCSI_DRAFT20_VERSION
+
+/* Padding word length */
+#define PAD_WORD_LEN		4
+
+/* maximum length for text values */
+#define TARGET_NAME_MAXLEN	255
+
+/*
+ * We should come up with a enum or some defines (in iscsi.h)
+ * of all the iSCSI defaults so we can verify values against
+ * what we receive (from the ioctl and targets)
+ */
+#define DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH	8192
+
+#endif

--------------000004010000070707020607--
