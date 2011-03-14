From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 03/12] iscsi-target: Add TCM v4 compatiable ConfigFS control plane
Date: Mon, 14 Mar 2011 04:57:00 -0700
Message-ID: <1300103829-10337-4-git-send-email-nab@linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for /sys/kernel/config/target/iscsi using
TCM v4.0 compatiable calls following target_core_fabric_configfs.c

This includes a number of iSCSI fabric dependent attributes upon
target_core_fabric_configfs.c provided struct config_item_types from
include/target/target_core_configfs.hstruct target_fabric_configfs_temp=
late

It also includes iscsi_target_nodeattrib.[c,h] for handling the
lio_target_nacl_attrib_attrs[] store/show for iSCSI fabric dependent
attributes.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c   | 1610 ++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target_configfs.h   |    9 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c |  300 +++++
 drivers/target/iscsi/iscsi_target_nodeattrib.h |   14 +
 4 files changed, 1933 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.c
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.h
 create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.c
 create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.h

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/tar=
get/iscsi/iscsi_target_configfs.c
new file mode 100644
index 0000000..ee6ec6c
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -0,0 +1,1610 @@
+/*********************************************************************=
**********
+ * This file contains the configfs implementation for iSCSI Target mod=
e
+ * from the LIO-Target Project.
+ *
+ * Copyright (c) 2008, 2009, 2010 Rising Tide, Inc.
+ * Copyright (c) 2008, 2009, 2010 Linux-iSCSI.org
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*******/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <generated/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/configfs.h>
+#include <linux/inet.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/configfs_macros.h>
+
+#include "iscsi_target_core.h"
+#include "iscsi_parameters.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_nodeattrib.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_target_stat.h"
+#include "iscsi_target_configfs.h"
+
+struct target_fabric_configfs *lio_target_fabric_configfs;
+
+struct lio_target_configfs_attribute {
+	struct configfs_attribute attr;
+	ssize_t (*show)(void *, char *);
+	ssize_t (*store)(void *, const char *, size_t);
+};
+
+struct iscsi_portal_group *lio_get_tpg_from_tpg_item(
+	struct config_item *item,
+	struct iscsi_tiqn **tiqn_out)
+{
+	struct se_portal_group *se_tpg =3D container_of(to_config_group(item)=
,
+					struct se_portal_group, tpg_group);
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+	int ret;
+
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to locate struct iscsi_portal_group "
+			"pointer\n");
+		return NULL;
+	}
+	ret =3D iscsi_get_tpg(tpg);
+	if (ret < 0)
+		return NULL;
+
+	*tiqn_out =3D tpg->tpg_tiqn;
+	return tpg;
+}
+
+/* Start items for lio_target_portal_cit */
+
+static ssize_t lio_target_np_show_sctp(
+	struct se_tpg_np *se_tpg_np,
+	char *page)
+{
+	struct iscsi_tpg_np *tpg_np =3D container_of(se_tpg_np,
+				struct iscsi_tpg_np, se_tpg_np);
+	struct iscsi_tpg_np *tpg_np_sctp;
+	ssize_t rb;
+
+	tpg_np_sctp =3D iscsi_tpg_locate_child_np(tpg_np, ISCSI_SCTP_TCP);
+	if ((tpg_np_sctp))
+		rb =3D sprintf(page, "1\n");
+	else
+		rb =3D sprintf(page, "0\n");
+
+	return rb;
+}
+
+static ssize_t lio_target_np_store_sctp(
+	struct se_tpg_np *se_tpg_np,
+	const char *page,
+	size_t count)
+{
+	struct iscsi_np *np;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np *tpg_np =3D container_of(se_tpg_np,
+				struct iscsi_tpg_np, se_tpg_np);
+	struct iscsi_tpg_np *tpg_np_sctp =3D NULL;
+	struct iscsi_np_addr np_addr;
+	char *endptr;
+	u32 op;
+	int ret;
+
+	op =3D simple_strtoul(page, &endptr, 0);
+	 if ((op !=3D 1) && (op !=3D 0)) {
+		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+	np =3D tpg_np->tpg_np;
+	if (!(np)) {
+		printk(KERN_ERR "Unable to locate struct iscsi_np from"
+				" struct iscsi_tpg_np\n");
+		return -EINVAL;
+	}
+
+	tpg =3D tpg_np->tpg;
+	if (iscsi_get_tpg(tpg) < 0)
+		return -EINVAL;
+
+	if (op) {
+		memset((void *)&np_addr, 0, sizeof(struct iscsi_np_addr));
+		if (np->np_flags & NPF_NET_IPV6)
+			snprintf(np_addr.np_ipv6, IPV6_ADDRESS_SPACE,
+				"%s", np->np_ipv6);
+		else
+			np_addr.np_ipv4 =3D np->np_ipv4;
+		np_addr.np_flags =3D np->np_flags;
+		np_addr.np_port =3D np->np_port;
+
+		tpg_np_sctp =3D iscsi_tpg_add_network_portal(tpg, &np_addr,
+					tpg_np, ISCSI_SCTP_TCP);
+		if (!(tpg_np_sctp) || IS_ERR(tpg_np_sctp))
+			goto out;
+	} else {
+		tpg_np_sctp =3D iscsi_tpg_locate_child_np(tpg_np, ISCSI_SCTP_TCP);
+		if (!(tpg_np_sctp))
+			goto out;
+
+		ret =3D iscsi_tpg_del_network_portal(tpg, tpg_np_sctp);
+		if (ret < 0)
+			goto out;
+	}
+
+	iscsi_put_tpg(tpg);
+	return count;
+out:
+	iscsi_put_tpg(tpg);
+	return -EINVAL;
+}
+
+TF_NP_BASE_ATTR(lio_target, sctp, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_portal_attrs[] =3D {
+	&lio_target_np_sctp.attr,
+	NULL,
+};
+
+/* Stop items for lio_target_portal_cit */
+
+/* Start items for lio_target_np_cit */
+
+#define MAX_PORTAL_LEN		256
+
+struct se_tpg_np *lio_target_call_addnptotpg(
+	struct se_portal_group *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np *tpg_np;
+	char *str, *str2, *end_ptr, *ip_str, *port_str;
+	struct iscsi_np_addr np_addr;
+	u32 ipv4 =3D 0;
+	int ret;
+	char buf[MAX_PORTAL_LEN];
+
+	if (strlen(name) > MAX_PORTAL_LEN) {
+		printk(KERN_ERR "strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
+			(int)strlen(name), MAX_PORTAL_LEN);
+		return ERR_PTR(-EOVERFLOW);
+	}
+	memset(buf, 0, MAX_PORTAL_LEN);
+	snprintf(buf, MAX_PORTAL_LEN, "%s", name);
+
+	memset((void *)&np_addr, 0, sizeof(struct iscsi_np_addr));
+
+	str =3D strstr(buf, "[");
+	if ((str)) {
+		str2 =3D strstr(str, "]");
+		if (!(str2)) {
+			printk(KERN_ERR "Unable to locate trailing \"]\""
+				" in IPv6 iSCSI network portal address\n");
+			return ERR_PTR(-EINVAL);
+		}
+		str++; /* Skip over leading "[" */
+		*str2 =3D '\0'; /* Terminate the IPv6 address */
+		str2 +=3D 1; /* Skip over the "]" */
+		port_str =3D strstr(str2, ":");
+		if (!(port_str)) {
+			printk(KERN_ERR "Unable to locate \":port\""
+				" in IPv6 iSCSI network portal address\n");
+			return ERR_PTR(-EINVAL);
+		}
+		*port_str =3D '\0'; /* Terminate string for IP */
+		port_str +=3D 1; /* Skip over ":" */
+		np_addr.np_port =3D simple_strtoul(port_str, &end_ptr, 0);
+
+		snprintf(np_addr.np_ipv6, IPV6_ADDRESS_SPACE, "%s", str);
+		np_addr.np_flags |=3D NPF_NET_IPV6;
+	} else {
+		ip_str =3D &buf[0];
+		port_str =3D strstr(ip_str, ":");
+		if (!(port_str)) {
+			printk(KERN_ERR "Unable to locate \":port\""
+				" in IPv4 iSCSI network portal address\n");
+			return ERR_PTR(-EINVAL);
+		}
+		*port_str =3D '\0'; /* Terminate string for IP */
+		port_str +=3D 1; /* Skip over ":" */
+		np_addr.np_port =3D simple_strtoul(port_str, &end_ptr, 0);
+
+		ipv4 =3D in_aton(ip_str);
+		np_addr.np_ipv4 =3D htonl(ipv4);
+		np_addr.np_flags |=3D NPF_NET_IPV4;
+	}
+	tpg =3D container_of(se_tpg, struct iscsi_portal_group, tpg_se_tpg);
+	ret =3D iscsi_get_tpg(tpg);
+	if (ret < 0)
+		return ERR_PTR(-EINVAL);
+
+	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
+		" PORTAL: %s\n",
+		config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
+		tpg->tpgt, name);
+	/*
+	 * Assume ISCSI_TCP by default.  Other network portals for other
+	 * iSCSI fabrics:
+	 *
+	 * Traditional iSCSI over SCTP (initial support)
+	 * iSER/TCP (TODO, hardware available)
+	 * iSER/SCTP (TODO, software emulation with osc-iwarp)
+	 * iSER/IB (TODO, hardware available)
+	 *
+	 * can be enabled with atributes under
+	 * sys/kernel/config/iscsi/$IQN/$TPG/np/$IP:$PORT/
+	 *
+	 */
+	tpg_np =3D iscsi_tpg_add_network_portal(tpg, &np_addr, NULL, ISCSI_TC=
P);
+	if (IS_ERR(tpg_np)) {
+		iscsi_put_tpg(tpg);
+		return ERR_PTR(PTR_ERR(tpg_np));
+	}
+	printk(KERN_INFO "LIO_Target_ConfigFS: addnptotpg done!\n");
+
+	iscsi_put_tpg(tpg);
+	return &tpg_np->se_tpg_np;
+}
+
+static void lio_target_call_delnpfromtpg(
+	struct se_tpg_np *se_tpg_np)
+{
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np *tpg_np;
+	struct se_portal_group *se_tpg;
+	int ret =3D 0;
+
+	tpg_np =3D container_of(se_tpg_np, struct iscsi_tpg_np, se_tpg_np);
+	tpg =3D tpg_np->tpg;
+	ret =3D iscsi_get_tpg(tpg);
+	if (ret < 0)
+		return;
+
+	se_tpg =3D &tpg->tpg_se_tpg;
+	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
+		" PORTAL: %s\n", config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_=
item),
+		tpg->tpgt, config_item_name(&se_tpg_np->tpg_np_group.cg_item));
+
+	ret =3D iscsi_tpg_del_network_portal(tpg, tpg_np);
+	if (ret < 0)
+		goto out;
+
+	printk(KERN_INFO "LIO_Target_ConfigFS: delnpfromtpg done!\n");
+out:
+	iscsi_put_tpg(tpg);
+}
+
+/* End items for lio_target_np_cit */
+
+/* Start items for lio_target_nacl_attrib_cit */
+
+#define DEF_NACL_ATTRIB(name)						\
+static ssize_t iscsi_nacl_attrib_show_##name(				\
+	struct se_node_acl *se_nacl,					\
+	char *page)							\
+{									\
+	struct iscsi_node_acl *nacl =3D container_of(se_nacl, struct iscsi_no=
de_acl, \
+					se_node_acl);			\
+	ssize_t rb;							\
+									\
+	rb =3D sprintf(page, "%u\n", ISCSI_NODE_ATTRIB(nacl)->name);	\
+	return rb;							\
+}									\
+									\
+static ssize_t iscsi_nacl_attrib_store_##name(				\
+	struct se_node_acl *se_nacl,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct iscsi_node_acl *nacl =3D container_of(se_nacl, struct iscsi_no=
de_acl, \
+					se_node_acl);			\
+	char *endptr;							\
+	u32 val;							\
+	int ret;							\
+									\
+	val =3D simple_strtoul(page, &endptr, 0);				\
+	ret =3D iscsi_na_##name(nacl, val);				\
+	if (ret < 0)							\
+		return ret;						\
+									\
+	return count;							\
+}
+
+#define NACL_ATTR(_name, _mode) TF_NACL_ATTRIB_ATTR(iscsi, _name, _mod=
e);
+/*
+ * Define iscsi_node_attrib_s_dataout_timeout
+ */
+DEF_NACL_ATTRIB(dataout_timeout);
+NACL_ATTR(dataout_timeout, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_dataout_timeout_retries
+ */
+DEF_NACL_ATTRIB(dataout_timeout_retries);
+NACL_ATTR(dataout_timeout_retries, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_default_erl
+ */
+DEF_NACL_ATTRIB(default_erl);
+NACL_ATTR(default_erl, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_nopin_timeout
+ */
+DEF_NACL_ATTRIB(nopin_timeout);
+NACL_ATTR(nopin_timeout, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_nopin_response_timeout
+ */
+DEF_NACL_ATTRIB(nopin_response_timeout);
+NACL_ATTR(nopin_response_timeout, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_random_datain_pdu_offsets
+ */
+DEF_NACL_ATTRIB(random_datain_pdu_offsets);
+NACL_ATTR(random_datain_pdu_offsets, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_random_datain_seq_offsets
+ */
+DEF_NACL_ATTRIB(random_datain_seq_offsets);
+NACL_ATTR(random_datain_seq_offsets, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_node_attrib_s_random_r2t_offsets
+ */
+DEF_NACL_ATTRIB(random_r2t_offsets);
+NACL_ATTR(random_r2t_offsets, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_nacl_attrib_attrs[] =3D {
+	&iscsi_nacl_attrib_dataout_timeout.attr,
+	&iscsi_nacl_attrib_dataout_timeout_retries.attr,
+	&iscsi_nacl_attrib_default_erl.attr,
+	&iscsi_nacl_attrib_nopin_timeout.attr,
+	&iscsi_nacl_attrib_nopin_response_timeout.attr,
+	&iscsi_nacl_attrib_random_datain_pdu_offsets.attr,
+	&iscsi_nacl_attrib_random_datain_seq_offsets.attr,
+	&iscsi_nacl_attrib_random_r2t_offsets.attr,
+	NULL,
+};
+
+/* End items for lio_target_nacl_attrib_cit */
+
+/* Start items for lio_target_nacl_auth_cit */
+
+#define __DEF_NACL_AUTH_STR(prefix, name, flags)			\
+static ssize_t __iscsi_##prefix##_show_##name(				\
+	struct iscsi_node_acl *nacl,					\
+	char *page)							\
+{									\
+	struct iscsi_node_auth *auth =3D &nacl->node_auth;		\
+	ssize_t rb;							\
+									\
+	if (!capable(CAP_SYS_ADMIN))					\
+		return -EPERM;						\
+	rb =3D snprintf(page, PAGE_SIZE, "%s\n", auth->name);		\
+	return rb;							\
+}									\
+									\
+static ssize_t __iscsi_##prefix##_store_##name(				\
+	struct iscsi_node_acl *nacl,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct iscsi_node_auth *auth =3D &nacl->node_auth;		\
+									\
+	if (!capable(CAP_SYS_ADMIN))					\
+		return -EPERM;						\
+									\
+	snprintf(auth->name, PAGE_SIZE, "%s", page);			\
+	if (!(strncmp("NULL", auth->name, 4)))				\
+		auth->naf_flags &=3D ~flags;				\
+	else								\
+		auth->naf_flags |=3D flags;				\
+									\
+	if ((auth->naf_flags & NAF_USERID_IN_SET) &&			\
+	    (auth->naf_flags & NAF_PASSWORD_IN_SET))			\
+		auth->authenticate_target =3D 1;				\
+	else								\
+		auth->authenticate_target =3D 0;				\
+									\
+	return count;							\
+}
+
+#define __DEF_NACL_AUTH_INT(prefix, name)				\
+static ssize_t __iscsi_##prefix##_show_##name(				\
+	struct iscsi_node_acl *nacl,					\
+	char *page)							\
+{									\
+	struct iscsi_node_auth *auth =3D &nacl->node_auth;		\
+	ssize_t rb;							\
+									\
+	if (!capable(CAP_SYS_ADMIN))					\
+		return -EPERM;						\
+									\
+	rb =3D snprintf(page, PAGE_SIZE, "%d\n", auth->name);		\
+	return rb;							\
+}
+
+#define DEF_NACL_AUTH_STR(name, flags)					\
+	__DEF_NACL_AUTH_STR(nacl_auth, name, flags)			\
+static ssize_t iscsi_nacl_auth_show_##name(				\
+	struct se_node_acl *nacl,					\
+	char *page)							\
+{									\
+	return __iscsi_nacl_auth_show_##name(container_of(nacl,		\
+			struct iscsi_node_acl, se_node_acl), page);		\
+}									\
+static ssize_t iscsi_nacl_auth_store_##name(				\
+	struct se_node_acl *nacl,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	return __iscsi_nacl_auth_store_##name(container_of(nacl,	\
+			struct iscsi_node_acl, se_node_acl), page, count);	\
+}
+
+#define DEF_NACL_AUTH_INT(name)						\
+	__DEF_NACL_AUTH_INT(nacl_auth, name)				\
+static ssize_t iscsi_nacl_auth_show_##name(				\
+	struct se_node_acl *nacl,					\
+	char *page)							\
+{									\
+	return __iscsi_nacl_auth_show_##name(container_of(nacl,		\
+			struct iscsi_node_acl, se_node_acl), page);		\
+}
+
+#define AUTH_ATTR(_name, _mode)	TF_NACL_AUTH_ATTR(iscsi, _name, _mode)=
;
+#define AUTH_ATTR_RO(_name) TF_NACL_AUTH_ATTR_RO(iscsi, _name);
+
+/*
+ * One-way authentication userid
+ */
+DEF_NACL_AUTH_STR(userid, NAF_USERID_SET);
+AUTH_ATTR(userid, S_IRUGO | S_IWUSR);
+/*
+ * One-way authentication password
+ */
+DEF_NACL_AUTH_STR(password, NAF_PASSWORD_SET);
+AUTH_ATTR(password, S_IRUGO | S_IWUSR);
+/*
+ * Enforce mutual authentication
+ */
+DEF_NACL_AUTH_INT(authenticate_target);
+AUTH_ATTR_RO(authenticate_target);
+/*
+ * Mutual authentication userid
+ */
+DEF_NACL_AUTH_STR(userid_mutual, NAF_USERID_IN_SET);
+AUTH_ATTR(userid_mutual, S_IRUGO | S_IWUSR);
+/*
+ * Mutual authentication password
+ */
+DEF_NACL_AUTH_STR(password_mutual, NAF_PASSWORD_IN_SET);
+AUTH_ATTR(password_mutual, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_nacl_auth_attrs[] =3D {
+	&iscsi_nacl_auth_userid.attr,
+	&iscsi_nacl_auth_password.attr,
+	&iscsi_nacl_auth_authenticate_target.attr,
+	&iscsi_nacl_auth_userid_mutual.attr,
+	&iscsi_nacl_auth_password_mutual.attr,
+	NULL,
+};
+
+/* End items for lio_target_nacl_auth_cit */
+
+/* Start items for lio_target_nacl_param_cit */
+
+#define DEF_NACL_PARAM(name)						\
+static ssize_t iscsi_nacl_param_show_##name(				\
+	struct se_node_acl *se_nacl,					\
+	char *page)							\
+{									\
+	struct iscsi_session *sess;						\
+	struct se_session *se_sess;						\
+	ssize_t rb;							\
+									\
+	spin_lock_bh(&se_nacl->nacl_sess_lock);				\
+	se_sess =3D se_nacl->nacl_sess;					\
+	if (!(se_sess)) {						\
+		rb =3D snprintf(page, PAGE_SIZE,				\
+			"No Active iSCSI Session\n");			\
+	} else {							\
+		sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;	\
+		rb =3D snprintf(page, PAGE_SIZE, "%u\n",			\
+			(u32)SESS_OPS(sess)->name);			\
+	}								\
+	spin_unlock_bh(&se_nacl->nacl_sess_lock);			\
+									\
+	return rb;							\
+}
+
+#define NACL_PARAM_ATTR(_name) TF_NACL_PARAM_ATTR_RO(iscsi, _name);
+
+DEF_NACL_PARAM(MaxConnections);
+NACL_PARAM_ATTR(MaxConnections);
+
+DEF_NACL_PARAM(InitialR2T);
+NACL_PARAM_ATTR(InitialR2T);
+
+DEF_NACL_PARAM(ImmediateData);
+NACL_PARAM_ATTR(ImmediateData);
+
+DEF_NACL_PARAM(MaxBurstLength);
+NACL_PARAM_ATTR(MaxBurstLength);
+
+DEF_NACL_PARAM(FirstBurstLength);
+NACL_PARAM_ATTR(FirstBurstLength);
+
+DEF_NACL_PARAM(DefaultTime2Wait);
+NACL_PARAM_ATTR(DefaultTime2Wait);
+
+DEF_NACL_PARAM(DefaultTime2Retain);
+NACL_PARAM_ATTR(DefaultTime2Retain);
+
+DEF_NACL_PARAM(MaxOutstandingR2T);
+NACL_PARAM_ATTR(MaxOutstandingR2T);
+
+DEF_NACL_PARAM(DataPDUInOrder);
+NACL_PARAM_ATTR(DataPDUInOrder);
+
+DEF_NACL_PARAM(DataSequenceInOrder);
+NACL_PARAM_ATTR(DataSequenceInOrder);
+
+DEF_NACL_PARAM(ErrorRecoveryLevel);
+NACL_PARAM_ATTR(ErrorRecoveryLevel);
+
+static struct configfs_attribute *lio_target_nacl_param_attrs[] =3D {
+	&iscsi_nacl_param_MaxConnections.attr,
+	&iscsi_nacl_param_InitialR2T.attr,
+	&iscsi_nacl_param_ImmediateData.attr,
+	&iscsi_nacl_param_MaxBurstLength.attr,
+	&iscsi_nacl_param_FirstBurstLength.attr,
+	&iscsi_nacl_param_DefaultTime2Wait.attr,
+	&iscsi_nacl_param_DefaultTime2Retain.attr,
+	&iscsi_nacl_param_MaxOutstandingR2T.attr,
+	&iscsi_nacl_param_DataPDUInOrder.attr,
+	&iscsi_nacl_param_DataSequenceInOrder.attr,
+	&iscsi_nacl_param_ErrorRecoveryLevel.attr,
+	NULL,
+};
+
+/* End items for lio_target_nacl_param_cit */
+
+/* Start items for lio_target_acl_cit */
+
+static ssize_t lio_target_nacl_show_info(
+	struct se_node_acl *se_nacl,
+	char *page)
+{
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+	struct se_session *se_sess;
+	unsigned char *ip, buf_ipv4[IPV4_BUF_SIZE];
+	ssize_t rb =3D 0;
+
+	spin_lock_bh(&se_nacl->nacl_sess_lock);
+	se_sess =3D se_nacl->nacl_sess;
+	if (!(se_sess))
+		rb +=3D sprintf(page+rb, "No active iSCSI Session for Initiator"
+			" Endpoint: %s\n", se_nacl->initiatorname);
+	else {
+		sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
+
+		if (SESS_OPS(sess)->InitiatorName)
+			rb +=3D sprintf(page+rb, "InitiatorName: %s\n",
+				SESS_OPS(sess)->InitiatorName);
+		if (SESS_OPS(sess)->InitiatorAlias)
+			rb +=3D sprintf(page+rb, "InitiatorAlias: %s\n",
+				SESS_OPS(sess)->InitiatorAlias);
+
+		rb +=3D sprintf(page+rb, "LIO Session ID: %u   "
+			"ISID: 0x%02x %02x %02x %02x %02x %02x  "
+			"TSIH: %hu  ", sess->sid,
+			sess->isid[0], sess->isid[1], sess->isid[2],
+			sess->isid[3], sess->isid[4], sess->isid[5],
+			sess->tsih);
+		rb +=3D sprintf(page+rb, "SessionType: %s\n",
+				(SESS_OPS(sess)->SessionType) ?
+				"Discovery" : "Normal");
+		rb +=3D sprintf(page+rb, "Session State: ");
+		switch (sess->session_state) {
+		case TARG_SESS_STATE_FREE:
+			rb +=3D sprintf(page+rb, "TARG_SESS_FREE\n");
+			break;
+		case TARG_SESS_STATE_ACTIVE:
+			rb +=3D sprintf(page+rb, "TARG_SESS_STATE_ACTIVE\n");
+			break;
+		case TARG_SESS_STATE_LOGGED_IN:
+			rb +=3D sprintf(page+rb, "TARG_SESS_STATE_LOGGED_IN\n");
+			break;
+		case TARG_SESS_STATE_FAILED:
+			rb +=3D sprintf(page+rb, "TARG_SESS_STATE_FAILED\n");
+			break;
+		case TARG_SESS_STATE_IN_CONTINUE:
+			rb +=3D sprintf(page+rb, "TARG_SESS_STATE_IN_CONTINUE\n");
+			break;
+		default:
+			rb +=3D sprintf(page+rb, "ERROR: Unknown Session"
+					" State!\n");
+			break;
+		}
+
+		rb +=3D sprintf(page+rb, "---------------------[iSCSI Session"
+				" Values]-----------------------\n");
+		rb +=3D sprintf(page+rb, "  CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN"
+				"  :  MaxCmdSN  :     ITT    :     TTT\n");
+		rb +=3D sprintf(page+rb, " 0x%08x   0x%08x   0x%08x   0x%08x"
+				"   0x%08x   0x%08x\n",
+			sess->cmdsn_window,
+			(sess->max_cmd_sn - sess->exp_cmd_sn) + 1,
+			sess->exp_cmd_sn, sess->max_cmd_sn,
+			sess->init_task_tag, sess->targ_xfer_tag);
+		rb +=3D sprintf(page+rb, "----------------------[iSCSI"
+				" Connections]-------------------------\n");
+
+		spin_lock(&sess->conn_lock);
+		list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+			rb +=3D sprintf(page+rb, "CID: %hu  Connection"
+					" State: ", conn->cid);
+			switch (conn->conn_state) {
+			case TARG_CONN_STATE_FREE:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_FREE\n");
+				break;
+			case TARG_CONN_STATE_XPT_UP:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_XPT_UP\n");
+				break;
+			case TARG_CONN_STATE_IN_LOGIN:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_IN_LOGIN\n");
+				break;
+			case TARG_CONN_STATE_LOGGED_IN:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_LOGGED_IN\n");
+				break;
+			case TARG_CONN_STATE_IN_LOGOUT:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_IN_LOGOUT\n");
+				break;
+			case TARG_CONN_STATE_LOGOUT_REQUESTED:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_LOGOUT_REQUESTED\n");
+				break;
+			case TARG_CONN_STATE_CLEANUP_WAIT:
+				rb +=3D sprintf(page+rb,
+					"TARG_CONN_STATE_CLEANUP_WAIT\n");
+				break;
+			default:
+				rb +=3D sprintf(page+rb,
+					"ERROR: Unknown Connection State!\n");
+				break;
+			}
+
+			if (conn->net_size =3D=3D IPV6_ADDRESS_SPACE)
+				ip =3D &conn->ipv6_login_ip[0];
+			else {
+				iscsi_ntoa2(buf_ipv4, conn->login_ip);
+				ip =3D &buf_ipv4[0];
+			}
+			rb +=3D sprintf(page+rb, "   Address %s %s", ip,
+				(conn->network_transport =3D=3D ISCSI_TCP) ?
+				"TCP" : "SCTP");
+			rb +=3D sprintf(page+rb, "  StatSN: 0x%08x\n",
+				conn->stat_sn);
+		}
+		spin_unlock(&sess->conn_lock);
+	}
+	spin_unlock_bh(&se_nacl->nacl_sess_lock);
+
+	return rb;
+}
+
+TF_NACL_BASE_ATTR_RO(lio_target, info);
+
+static ssize_t lio_target_nacl_show_cmdsn_depth(
+	struct se_node_acl *se_nacl,
+	char *page)
+{
+	return sprintf(page, "%u\n", se_nacl->queue_depth);
+}
+
+static ssize_t lio_target_nacl_store_cmdsn_depth(
+	struct se_node_acl *se_nacl,
+	const char *page,
+	size_t count)
+{
+	struct se_portal_group *se_tpg =3D se_nacl->se_tpg;
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,
+			struct iscsi_portal_group, tpg_se_tpg);
+	struct config_item *acl_ci, *tpg_ci, *wwn_ci;
+	char *endptr;
+	u32 cmdsn_depth =3D 0;
+	int ret =3D 0;
+
+	cmdsn_depth =3D simple_strtoul(page, &endptr, 0);
+	if (cmdsn_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
+		printk(KERN_ERR "Passed cmdsn_depth: %u exceeds"
+			" TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n", cmdsn_depth,
+			TA_DEFAULT_CMDSN_DEPTH_MAX);
+		return -EINVAL;
+	}
+	acl_ci =3D &se_nacl->acl_group.cg_item;
+	if (!(acl_ci)) {
+		printk(KERN_ERR "Unable to locatel acl_ci\n");
+		return -EINVAL;
+	}
+	tpg_ci =3D &acl_ci->ci_parent->ci_group->cg_item;
+	if (!(tpg_ci)) {
+		printk(KERN_ERR "Unable to locate tpg_ci\n");
+		return -EINVAL;
+	}
+	wwn_ci =3D &tpg_ci->ci_group->cg_item;
+	if (!(wwn_ci)) {
+		printk(KERN_ERR "Unable to locate config_item wwn_ci\n");
+		return -EINVAL;
+	}
+
+	if (iscsi_get_tpg(tpg) < 0)
+		return -EINVAL;
+	/*
+	 * iscsi_tpg_set_initiator_node_queue_depth() assumes force=3D1
+	 */
+	ret =3D iscsi_tpg_set_initiator_node_queue_depth(tpg,
+				config_item_name(acl_ci), cmdsn_depth, 1);
+
+	printk(KERN_INFO "LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for=
"
+		"InitiatorName: %s\n", config_item_name(wwn_ci),
+		config_item_name(tpg_ci), cmdsn_depth,
+		config_item_name(acl_ci));
+
+	iscsi_put_tpg(tpg);
+	return (!ret) ? count : (ssize_t)ret;
+}
+
+TF_NACL_BASE_ATTR(lio_target, cmdsn_depth, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_initiator_attrs[] =3D {
+	&lio_target_nacl_info.attr,
+	&lio_target_nacl_cmdsn_depth.attr,
+	NULL,
+};
+
+static struct se_node_acl *lio_target_make_nodeacl(
+	struct se_portal_group *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	struct config_group *stats_cg;
+	struct iscsi_node_acl *acl;
+	struct se_node_acl *se_nacl_new, *se_nacl;
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,
+			struct iscsi_portal_group, tpg_se_tpg);
+	u32 cmdsn_depth;
+
+	se_nacl_new =3D lio_tpg_alloc_fabric_acl(se_tpg);
+
+	acl =3D container_of(se_nacl_new, struct iscsi_node_acl,
+				se_node_acl);
+
+	cmdsn_depth =3D ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NdoeACL from demo mode -> explict
+	 */
+	se_nacl =3D core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, cmdsn_depth);
+	if (IS_ERR(se_nacl))
+		return ERR_PTR(PTR_ERR(se_nacl));
+
+	stats_cg =3D &acl->se_node_acl.acl_fabric_stat_group;
+
+	stats_cg->default_groups =3D kzalloc(sizeof(struct config_group) * 2,
+				GFP_KERNEL);
+	if (!stats_cg->default_groups) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" stats_cg->default_groups\n");
+		core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
+		kfree(acl);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	stats_cg->default_groups[0] =3D &NODE_STAT_GRPS(acl)->iscsi_sess_stat=
s_group;
+	stats_cg->default_groups[1] =3D NULL;
+	config_group_init_type_name(&NODE_STAT_GRPS(acl)->iscsi_sess_stats_gr=
oup,
+			"iscsi_sess_stats", &iscsi_stat_sess_cit);
+
+	return se_nacl;
+}
+
+static void lio_target_drop_nodeacl(
+	struct se_node_acl *se_nacl)
+{
+	struct se_portal_group *se_tpg =3D se_nacl->se_tpg;
+	struct iscsi_node_acl *acl =3D container_of(se_nacl,
+			struct iscsi_node_acl, se_node_acl);
+	struct config_item *df_item;
+	struct config_group *stats_cg;
+	int i;
+
+	stats_cg =3D &acl->se_node_acl.acl_fabric_stat_group;
+	for (i =3D 0; stats_cg->default_groups[i]; i++) {
+		df_item =3D &stats_cg->default_groups[i]->cg_item;
+		stats_cg->default_groups[i] =3D NULL;
+		config_item_put(df_item);
+	}
+	kfree(stats_cg->default_groups);
+
+	core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
+	kfree(acl);
+}
+
+/* End items for lio_target_acl_cit */
+
+/* Start items for lio_target_tpg_attrib_cit */
+
+#define DEF_TPG_ATTRIB(name)						\
+									\
+static ssize_t iscsi_tpg_attrib_show_##name(				\
+	struct se_portal_group *se_tpg,				\
+	char *page)							\
+{									\
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,		\
+			struct iscsi_portal_group, tpg_se_tpg);	\
+	ssize_t rb;							\
+									\
+	if (iscsi_get_tpg(tpg) < 0)					\
+		return -EINVAL;						\
+									\
+	rb =3D sprintf(page, "%u\n", ISCSI_TPG_ATTRIB(tpg)->name);	\
+	iscsi_put_tpg(tpg);						\
+	return rb;							\
+}									\
+									\
+static ssize_t iscsi_tpg_attrib_store_##name(				\
+	struct se_portal_group *se_tpg,				\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,		\
+			struct iscsi_portal_group, tpg_se_tpg);	\
+	char *endptr;							\
+	u32 val;							\
+	int ret;							\
+									\
+	if (iscsi_get_tpg(tpg) < 0)					\
+		return -EINVAL;						\
+									\
+	val =3D simple_strtoul(page, &endptr, 0);				\
+	ret =3D iscsi_ta_##name(tpg, val);				\
+	if (ret < 0)							\
+		goto out;						\
+									\
+	iscsi_put_tpg(tpg);						\
+	return count;							\
+out:									\
+	iscsi_put_tpg(tpg);						\
+	return ret;							\
+}
+
+#define TPG_ATTR(_name, _mode) TF_TPG_ATTRIB_ATTR(iscsi, _name, _mode)=
;
+
+/*
+ * Define iscsi_tpg_attrib_s_authentication
+ */
+DEF_TPG_ATTRIB(authentication);
+TPG_ATTR(authentication, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_login_timeout
+ */
+DEF_TPG_ATTRIB(login_timeout);
+TPG_ATTR(login_timeout, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_netif_timeout
+ */
+DEF_TPG_ATTRIB(netif_timeout);
+TPG_ATTR(netif_timeout, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_generate_node_acls
+ */
+DEF_TPG_ATTRIB(generate_node_acls);
+TPG_ATTR(generate_node_acls, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_default_cmdsn_depth
+ */
+DEF_TPG_ATTRIB(default_cmdsn_depth);
+TPG_ATTR(default_cmdsn_depth, S_IRUGO | S_IWUSR);
+/*
+ Define iscsi_tpg_attrib_s_cache_dynamic_acls
+ */
+DEF_TPG_ATTRIB(cache_dynamic_acls);
+TPG_ATTR(cache_dynamic_acls, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_demo_mode_write_protect
+ */
+DEF_TPG_ATTRIB(demo_mode_write_protect);
+TPG_ATTR(demo_mode_write_protect, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_prod_mode_write_protect
+ */
+DEF_TPG_ATTRIB(prod_mode_write_protect);
+TPG_ATTR(prod_mode_write_protect, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_tpg_attrib_attrs[] =3D {
+	&iscsi_tpg_attrib_authentication.attr,
+	&iscsi_tpg_attrib_login_timeout.attr,
+	&iscsi_tpg_attrib_netif_timeout.attr,
+	&iscsi_tpg_attrib_generate_node_acls.attr,
+	&iscsi_tpg_attrib_default_cmdsn_depth.attr,
+	&iscsi_tpg_attrib_cache_dynamic_acls.attr,
+	&iscsi_tpg_attrib_demo_mode_write_protect.attr,
+	&iscsi_tpg_attrib_prod_mode_write_protect.attr,
+	NULL,
+};
+
+/* End items for lio_target_tpg_attrib_cit */
+
+/* Start items for lio_target_tpg_param_cit */
+
+#define DEF_TPG_PARAM(name)						\
+static ssize_t iscsi_tpg_param_show_##name(				\
+	struct se_portal_group *se_tpg,				\
+	char *page)							\
+{									\
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,		\
+			struct iscsi_portal_group, tpg_se_tpg);	\
+	struct iscsi_param *param;						\
+	ssize_t rb;							\
+									\
+	if (iscsi_get_tpg(tpg) < 0)					\
+		return -EINVAL;						\
+									\
+	param =3D iscsi_find_param_from_key(__stringify(name),		\
+				tpg->param_list);			\
+	if (!(param)) {							\
+		iscsi_put_tpg(tpg);					\
+		return -EINVAL;						\
+	}								\
+	rb =3D snprintf(page, PAGE_SIZE, "%s\n", param->value);		\
+									\
+	iscsi_put_tpg(tpg);						\
+	return rb;							\
+}									\
+static ssize_t iscsi_tpg_param_store_##name(				\
+	struct se_portal_group *se_tpg,				\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,		\
+			struct iscsi_portal_group, tpg_se_tpg);	\
+	char *buf;							\
+	int ret;							\
+									\
+	buf =3D kzalloc(PAGE_SIZE, GFP_KERNEL);				\
+	if (!(buf))							\
+		return -ENOMEM;						\
+	snprintf(buf, PAGE_SIZE, "%s=3D%s", __stringify(name), page);	\
+	buf[strlen(buf)-1] =3D '\0'; /* Kill newline */			\
+									\
+	if (iscsi_get_tpg(tpg) < 0)					\
+		return -EINVAL;						\
+									\
+	ret =3D iscsi_change_param_value(buf, tpg->param_list, 1);	\
+	if (ret < 0)							\
+		goto out;						\
+									\
+	kfree(buf);							\
+	iscsi_put_tpg(tpg);						\
+	return count;							\
+out:									\
+	kfree(buf);							\
+	iscsi_put_tpg(tpg);						\
+	return -EINVAL;						\
+}
+
+#define TPG_PARAM_ATTR(_name, _mode) TF_TPG_PARAM_ATTR(iscsi, _name, _=
mode);
+
+DEF_TPG_PARAM(AuthMethod);
+TPG_PARAM_ATTR(AuthMethod, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(HeaderDigest);
+TPG_PARAM_ATTR(HeaderDigest, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DataDigest);
+TPG_PARAM_ATTR(DataDigest, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxConnections);
+TPG_PARAM_ATTR(MaxConnections, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(TargetAlias);
+TPG_PARAM_ATTR(TargetAlias, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(InitialR2T);
+TPG_PARAM_ATTR(InitialR2T, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(ImmediateData);
+TPG_PARAM_ATTR(ImmediateData, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxRecvDataSegmentLength);
+TPG_PARAM_ATTR(MaxRecvDataSegmentLength, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxBurstLength);
+TPG_PARAM_ATTR(MaxBurstLength, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(FirstBurstLength);
+TPG_PARAM_ATTR(FirstBurstLength, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DefaultTime2Wait);
+TPG_PARAM_ATTR(DefaultTime2Wait, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DefaultTime2Retain);
+TPG_PARAM_ATTR(DefaultTime2Retain, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxOutstandingR2T);
+TPG_PARAM_ATTR(MaxOutstandingR2T, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DataPDUInOrder);
+TPG_PARAM_ATTR(DataPDUInOrder, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DataSequenceInOrder);
+TPG_PARAM_ATTR(DataSequenceInOrder, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(ErrorRecoveryLevel);
+TPG_PARAM_ATTR(ErrorRecoveryLevel, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(IFMarker);
+TPG_PARAM_ATTR(IFMarker, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(OFMarker);
+TPG_PARAM_ATTR(OFMarker, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(IFMarkInt);
+TPG_PARAM_ATTR(IFMarkInt, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(OFMarkInt);
+TPG_PARAM_ATTR(OFMarkInt, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_tpg_param_attrs[] =3D {
+	&iscsi_tpg_param_AuthMethod.attr,
+	&iscsi_tpg_param_HeaderDigest.attr,
+	&iscsi_tpg_param_DataDigest.attr,
+	&iscsi_tpg_param_MaxConnections.attr,
+	&iscsi_tpg_param_TargetAlias.attr,
+	&iscsi_tpg_param_InitialR2T.attr,
+	&iscsi_tpg_param_ImmediateData.attr,
+	&iscsi_tpg_param_MaxRecvDataSegmentLength.attr,
+	&iscsi_tpg_param_MaxBurstLength.attr,
+	&iscsi_tpg_param_FirstBurstLength.attr,
+	&iscsi_tpg_param_DefaultTime2Wait.attr,
+	&iscsi_tpg_param_DefaultTime2Retain.attr,
+	&iscsi_tpg_param_MaxOutstandingR2T.attr,
+	&iscsi_tpg_param_DataPDUInOrder.attr,
+	&iscsi_tpg_param_DataSequenceInOrder.attr,
+	&iscsi_tpg_param_ErrorRecoveryLevel.attr,
+	&iscsi_tpg_param_IFMarker.attr,
+	&iscsi_tpg_param_OFMarker.attr,
+	&iscsi_tpg_param_IFMarkInt.attr,
+	&iscsi_tpg_param_OFMarkInt.attr,
+	NULL,
+};
+
+/* End items for lio_target_tpg_param_cit */
+
+/* Start items for lio_target_tpg_cit */
+
+static ssize_t lio_target_tpg_show_enable(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,
+			struct iscsi_portal_group, tpg_se_tpg);
+	ssize_t len =3D 0;
+
+	spin_lock(&tpg->tpg_state_lock);
+	len =3D sprintf(page, "%d\n",
+			(tpg->tpg_state =3D=3D TPG_STATE_ACTIVE) ? 1 : 0);
+	spin_unlock(&tpg->tpg_state_lock);
+
+	return len;
+}
+
+static ssize_t lio_target_tpg_store_enable(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct iscsi_portal_group *tpg =3D container_of(se_tpg,
+			struct iscsi_portal_group, tpg_se_tpg);
+	char *endptr;
+	u32 op;
+	int ret =3D 0;
+
+	op =3D simple_strtoul(page, &endptr, 0);
+	if ((op !=3D 1) && (op !=3D 0)) {
+		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+
+	ret =3D iscsi_get_tpg(tpg);
+	if (ret < 0)
+		return -EINVAL;
+
+	if (op) {
+		ret =3D iscsi_tpg_enable_portal_group(tpg);
+		if (ret < 0)
+			goto out;
+	} else {
+		/*
+		 * iscsi_tpg_disable_portal_group() assumes force=3D1
+		 */
+		ret =3D iscsi_tpg_disable_portal_group(tpg, 1);
+		if (ret < 0)
+			goto out;
+	}
+
+	iscsi_put_tpg(tpg);
+	return count;
+out:
+	iscsi_put_tpg(tpg);
+	return -EINVAL;
+}
+
+TF_TPG_BASE_ATTR(lio_target, enable, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_tpg_attrs[] =3D {
+	&lio_target_tpg_enable.attr,
+	NULL,
+};
+
+/* End items for lio_target_tpg_cit */
+
+/* Start items for lio_target_tiqn_cit */
+
+struct se_portal_group *lio_target_tiqn_addtpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tiqn *tiqn;
+	char *tpgt_str, *end_ptr;
+	int ret =3D 0;
+	unsigned short int tpgt;
+
+	tiqn =3D container_of(wwn, struct iscsi_tiqn, tiqn_wwn);
+	/*
+	 * Only tpgt_# directory groups can be created below
+	 * target/iscsi/iqn.superturodiskarry/
+	*/
+	tpgt_str =3D strstr(name, "tpgt_");
+	if (!(tpgt_str)) {
+		printk(KERN_ERR "Unable to locate \"tpgt_#\" directory"
+				" group\n");
+		return NULL;
+	}
+	tpgt_str +=3D 5; /* Skip ahead of "tpgt_" */
+	tpgt =3D (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
+
+	tpg =3D core_alloc_portal_group(tiqn, tpgt);
+	if (!(tpg))
+		return NULL;
+
+	ret =3D core_tpg_register(
+			&lio_target_fabric_configfs->tf_ops,
+			wwn, &tpg->tpg_se_tpg, (void *)tpg,
+			TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0)
+		return NULL;
+
+	ret =3D iscsi_tpg_add_portal_group(tiqn, tpg);
+	if (ret !=3D 0)
+		goto out;
+
+	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn)=
;
+	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\=
n",
+			name);
+	return &tpg->tpg_se_tpg;
+out:
+	core_tpg_deregister(&tpg->tpg_se_tpg);
+	kmem_cache_free(lio_tpg_cache, tpg);
+	return NULL;
+}
+
+void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tiqn *tiqn;
+
+	tpg =3D container_of(se_tpg, struct iscsi_portal_group, tpg_se_tpg);
+	tiqn =3D tpg->tpg_tiqn;
+	/*
+	 * iscsi_tpg_del_portal_group() assumes force=3D1
+	 */
+	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n"=
);
+	iscsi_tpg_del_portal_group(tiqn, tpg, 1);
+}
+
+/* End items for lio_target_tiqn_cit */
+
+/* Start LIO-Target TIQN struct contig_item lio_target_cit */
+
+static ssize_t lio_target_wwn_show_attr_lio_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "Linux-iSCSI.org Target "ISCSI_VERSION""
+		" on %s/%s on "UTS_RELEASE"\n", utsname()->sysname,
+		utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(lio_target, lio_version);
+
+static struct configfs_attribute *lio_target_wwn_attrs[] =3D {
+	&lio_target_wwn_lio_version.attr,
+	NULL,
+};
+
+struct se_wwn *lio_target_call_coreaddtiqn(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct config_group *stats_cg;
+	struct iscsi_tiqn *tiqn;
+	int ret =3D 0;
+
+	tiqn =3D core_add_tiqn((unsigned char *)name, &ret);
+	if (!(tiqn))
+		return NULL;
+	/*
+	 * Setup struct iscsi_wwn_stat_grps for se_wwn->fabric_stat_group.
+	 */
+	stats_cg =3D &tiqn->tiqn_wwn.fabric_stat_group;
+
+	stats_cg->default_groups =3D kzalloc(sizeof(struct config_group) * 6,
+				GFP_KERNEL);
+	if (!stats_cg->default_groups) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" stats_cg->default_groups\n");
+		core_del_tiqn(tiqn);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	stats_cg->default_groups[0] =3D &WWN_STAT_GRPS(tiqn)->iscsi_instance_=
group;
+	stats_cg->default_groups[1] =3D &WWN_STAT_GRPS(tiqn)->iscsi_sess_err_=
group;
+	stats_cg->default_groups[2] =3D &WWN_STAT_GRPS(tiqn)->iscsi_tgt_attr_=
group;
+	stats_cg->default_groups[3] =3D &WWN_STAT_GRPS(tiqn)->iscsi_login_sta=
ts_group;
+	stats_cg->default_groups[4] =3D &WWN_STAT_GRPS(tiqn)->iscsi_logout_st=
ats_group;
+	stats_cg->default_groups[5] =3D NULL;
+	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_instance_grou=
p,
+			"iscsi_instance", &iscsi_stat_instance_cit);
+	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_sess_err_grou=
p,
+			"iscsi_sess_err", &iscsi_stat_sess_err_cit);
+	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_tgt_attr_grou=
p,
+			"iscsi_tgt_attr", &iscsi_stat_tgt_attr_cit);
+	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_login_stats_g=
roup,
+			"iscsi_login_stats", &iscsi_stat_login_cit);
+	config_group_init_type_name(&WWN_STAT_GRPS(tiqn)->iscsi_logout_stats_=
group,
+			"iscsi_logout_stats", &iscsi_stat_logout_cit);
+
+	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn)=
;
+	printk(KERN_INFO "LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
+			" %s\n", name);
+	return &tiqn->tiqn_wwn;
+}
+
+void lio_target_call_coredeltiqn(
+	struct se_wwn *wwn)
+{
+	struct iscsi_tiqn *tiqn =3D container_of(wwn, struct iscsi_tiqn, tiqn=
_wwn);
+	struct config_item *df_item;
+	struct config_group *stats_cg;
+	int i;
+
+	stats_cg =3D &tiqn->tiqn_wwn.fabric_stat_group;
+	for (i =3D 0; stats_cg->default_groups[i]; i++) {
+		df_item =3D &stats_cg->default_groups[i]->cg_item;
+		stats_cg->default_groups[i] =3D NULL;
+		config_item_put(df_item);
+	}
+	kfree(stats_cg->default_groups);
+
+	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> %s\n",
+			tiqn->tiqn);
+	printk(KERN_INFO "LIO_Target_ConfigFS: DEREGISTER -> Releasing"
+			" core_del_tiqn()\n");
+	core_del_tiqn(tiqn);
+}
+
+/* End LIO-Target TIQN struct contig_lio_target_cit */
+
+/* Start lio_target_discovery_auth_cit */
+
+#define DEF_DISC_AUTH_STR(name, flags)					\
+	__DEF_NACL_AUTH_STR(disc, name, flags)				\
+static ssize_t iscsi_disc_show_##name(					\
+	struct target_fabric_configfs *tf,				\
+	char *page)							\
+{									\
+	return __iscsi_disc_show_##name(&iscsi_global->discovery_acl,	\
+		page);							\
+}									\
+static ssize_t iscsi_disc_store_##name(					\
+	struct target_fabric_configfs *tf,				\
+	const char *page,						\
+	size_t count)							\
+{									\
+	return __iscsi_disc_store_##name(&iscsi_global->discovery_acl,	\
+		page, count);						\
+}
+
+#define DEF_DISC_AUTH_INT(name)						\
+	__DEF_NACL_AUTH_INT(disc, name)					\
+static ssize_t iscsi_disc_show_##name(					\
+	struct target_fabric_configfs *tf,				\
+	char *page)							\
+{									\
+	return __iscsi_disc_show_##name(&iscsi_global->discovery_acl,	\
+			page);						\
+}
+
+#define DISC_AUTH_ATTR(_name, _mode) TF_DISC_ATTR(iscsi, _name, _mode)
+#define DISC_AUTH_ATTR_RO(_name) TF_DISC_ATTR_RO(iscsi, _name)
+
+/*
+ * One-way authentication userid
+ */
+DEF_DISC_AUTH_STR(userid, NAF_USERID_SET);
+DISC_AUTH_ATTR(userid, S_IRUGO | S_IWUSR);
+/*
+ * One-way authentication password
+ */
+DEF_DISC_AUTH_STR(password, NAF_PASSWORD_SET);
+DISC_AUTH_ATTR(password, S_IRUGO | S_IWUSR);
+/*
+ * Enforce mutual authentication
+ */
+DEF_DISC_AUTH_INT(authenticate_target);
+DISC_AUTH_ATTR_RO(authenticate_target);
+/*
+ * Mutual authentication userid
+ */
+DEF_DISC_AUTH_STR(userid_mutual, NAF_USERID_IN_SET);
+DISC_AUTH_ATTR(userid_mutual, S_IRUGO | S_IWUSR);
+/*
+ * Mutual authentication password
+ */
+DEF_DISC_AUTH_STR(password_mutual, NAF_PASSWORD_IN_SET);
+DISC_AUTH_ATTR(password_mutual, S_IRUGO | S_IWUSR);
+
+/*
+ * enforce_discovery_auth
+ */
+static ssize_t iscsi_disc_show_enforce_discovery_auth(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	struct iscsi_node_auth *discovery_auth =3D &iscsi_global->discovery_a=
cl.node_auth;
+
+	return sprintf(page, "%d\n", discovery_auth->enforce_discovery_auth);
+}
+
+static ssize_t iscsi_disc_store_enforce_discovery_auth(
+	struct target_fabric_configfs *tf,
+	const char *page,
+	size_t count)
+{
+	struct iscsi_param *param;
+	struct iscsi_portal_group *discovery_tpg =3D iscsi_global->discovery_=
tpg;
+	char *endptr;
+	u32 op;
+
+	op =3D simple_strtoul(page, &endptr, 0);
+	if ((op !=3D 1) && (op !=3D 0)) {
+		printk(KERN_ERR "Illegal value for enforce_discovery_auth:"
+				" %u\n", op);
+		return -EINVAL;
+	}
+
+	if (!(discovery_tpg)) {
+		printk(KERN_ERR "iscsi_global->discovery_tpg is NULL\n");
+		return -EINVAL;
+	}
+
+	param =3D iscsi_find_param_from_key(AUTHMETHOD,
+				discovery_tpg->param_list);
+	if (!(param))
+		return -EINVAL;
+
+	if (op) {
+		/*
+		 * Reset the AuthMethod key to CHAP.
+		 */
+		if (iscsi_update_param_value(param, CHAP) < 0)
+			return -EINVAL;
+
+		discovery_tpg->tpg_attrib.authentication =3D 1;
+		iscsi_global->discovery_acl.node_auth.enforce_discovery_auth =3D 1;
+		printk(KERN_INFO "LIO-CORE[0] Successfully enabled"
+			" authentication enforcement for iSCSI"
+			" Discovery TPG\n");
+	} else {
+		/*
+		 * Reset the AuthMethod key to CHAP,None
+		 */
+		if (iscsi_update_param_value(param, "CHAP,None") < 0)
+			return -EINVAL;
+
+		discovery_tpg->tpg_attrib.authentication =3D 0;
+		iscsi_global->discovery_acl.node_auth.enforce_discovery_auth =3D 0;
+		printk(KERN_INFO "LIO-CORE[0] Successfully disabled"
+			" authentication enforcement for iSCSI"
+			" Discovery TPG\n");
+	}
+
+	return count;
+}
+
+DISC_AUTH_ATTR(enforce_discovery_auth, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_discovery_auth_attrs[] =3D=
 {
+	&iscsi_disc_userid.attr,
+	&iscsi_disc_password.attr,
+	&iscsi_disc_authenticate_target.attr,
+	&iscsi_disc_userid_mutual.attr,
+	&iscsi_disc_password_mutual.attr,
+	&iscsi_disc_enforce_discovery_auth.attr,
+	NULL,
+};
+
+/* End lio_target_discovery_auth_cit */
+
+int iscsi_target_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	int ret;
+
+	lio_target_fabric_configfs =3D NULL;
+	fabric =3D target_fabric_configfs_init(THIS_MODULE, "iscsi");
+	if (!(fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() for"
+				" LIO-Target failed!\n");
+		return -1;
+	}
+	/*
+	 * Setup the fabric API of function pointers used by target_core_mod.=
=2E
+	 */
+	fabric->tf_ops.get_fabric_name =3D &iscsi_get_fabric_name;
+	fabric->tf_ops.get_fabric_proto_ident =3D &iscsi_get_fabric_proto_ide=
nt;
+	fabric->tf_ops.tpg_get_wwn =3D &lio_tpg_get_endpoint_wwn;
+	fabric->tf_ops.tpg_get_tag =3D &lio_tpg_get_tag;
+	fabric->tf_ops.tpg_get_default_depth =3D &lio_tpg_get_default_depth;
+	fabric->tf_ops.tpg_get_pr_transport_id =3D &iscsi_get_pr_transport_id=
;
+	fabric->tf_ops.tpg_get_pr_transport_id_len =3D
+				&iscsi_get_pr_transport_id_len;
+	fabric->tf_ops.tpg_parse_pr_out_transport_id =3D
+				&iscsi_parse_pr_out_transport_id;
+	fabric->tf_ops.tpg_check_demo_mode =3D &lio_tpg_check_demo_mode;
+	fabric->tf_ops.tpg_check_demo_mode_cache =3D
+				&lio_tpg_check_demo_mode_cache;
+	fabric->tf_ops.tpg_check_demo_mode_write_protect =3D
+				&lio_tpg_check_demo_mode_write_protect;
+	fabric->tf_ops.tpg_check_prod_mode_write_protect =3D
+				&lio_tpg_check_prod_mode_write_protect;
+	fabric->tf_ops.tpg_alloc_fabric_acl =3D &lio_tpg_alloc_fabric_acl;
+	fabric->tf_ops.tpg_release_fabric_acl =3D &lio_tpg_release_fabric_acl=
;
+	fabric->tf_ops.tpg_get_inst_index =3D &lio_tpg_get_inst_index;
+	/*
+	 * Use our local iscsi_allocate_iovecs_for_cmd() for the extra
+	 * callback in transport_generic_new_cmd() to allocate
+	 * iscsi_cmd->iov_data[] for Linux/Net kernel sockets operations.
+	 */
+	fabric->tf_ops.alloc_cmd_iovecs =3D &iscsi_allocate_iovecs_for_cmd;
+	fabric->tf_ops.release_cmd_to_pool =3D &lio_release_cmd_to_pool;
+	fabric->tf_ops.release_cmd_direct =3D &lio_release_cmd_direct;
+	fabric->tf_ops.shutdown_session =3D &lio_tpg_shutdown_session;
+	fabric->tf_ops.close_session =3D &lio_tpg_close_session;
+	fabric->tf_ops.stop_session =3D &lio_tpg_stop_session;
+	fabric->tf_ops.fall_back_to_erl0 =3D &lio_tpg_fall_back_to_erl0;
+	fabric->tf_ops.sess_logged_in =3D &lio_sess_logged_in;
+	fabric->tf_ops.sess_get_index =3D &lio_sess_get_index;
+	fabric->tf_ops.sess_get_initiator_sid =3D &lio_sess_get_initiator_sid=
;
+	fabric->tf_ops.write_pending =3D &lio_write_pending;
+	fabric->tf_ops.write_pending_status =3D &lio_write_pending_status;
+	fabric->tf_ops.set_default_node_attributes =3D
+				&lio_set_default_node_attributes;
+	fabric->tf_ops.get_task_tag =3D &iscsi_get_task_tag;
+	fabric->tf_ops.get_cmd_state =3D &iscsi_get_cmd_state;
+	fabric->tf_ops.new_cmd_failure =3D &iscsi_new_cmd_failure;
+	fabric->tf_ops.queue_data_in =3D &lio_queue_data_in;
+	fabric->tf_ops.queue_status =3D &lio_queue_status;
+	fabric->tf_ops.queue_tm_rsp =3D &lio_queue_tm_rsp;
+	fabric->tf_ops.set_fabric_sense_len =3D &lio_set_fabric_sense_len;
+	fabric->tf_ops.get_fabric_sense_len =3D &lio_get_fabric_sense_len;
+	fabric->tf_ops.is_state_remove =3D &iscsi_is_state_remove;
+	fabric->tf_ops.pack_lun =3D &iscsi_pack_lun;
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_co=
nfigfs.c
+	 */
+	fabric->tf_ops.fabric_make_wwn =3D &lio_target_call_coreaddtiqn;
+	fabric->tf_ops.fabric_drop_wwn =3D &lio_target_call_coredeltiqn;
+	fabric->tf_ops.fabric_make_tpg =3D &lio_target_tiqn_addtpg;
+	fabric->tf_ops.fabric_drop_tpg =3D &lio_target_tiqn_deltpg;
+	fabric->tf_ops.fabric_post_link	=3D NULL;
+	fabric->tf_ops.fabric_pre_unlink =3D NULL;
+	fabric->tf_ops.fabric_make_np =3D &lio_target_call_addnptotpg;
+	fabric->tf_ops.fabric_drop_np =3D &lio_target_call_delnpfromtpg;
+	fabric->tf_ops.fabric_make_nodeacl =3D &lio_target_make_nodeacl;
+	fabric->tf_ops.fabric_drop_nodeacl =3D &lio_target_drop_nodeacl;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 * sturct config_item_type's
+	 */
+	TF_CIT_TMPL(fabric)->tfc_discovery_cit.ct_attrs =3D lio_target_discov=
ery_auth_attrs;
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs =3D lio_target_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs =3D lio_target_tpg_att=
rs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs =3D lio_target_tpg_a=
ttrib_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs =3D lio_target_tpg_pa=
ram_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs =3D lio_target_port=
al_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs =3D lio_target_in=
itiator_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs =3D lio_target_=
nacl_attrib_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs =3D lio_target_na=
cl_auth_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs =3D lio_target_n=
acl_param_attrs;
+
+	ret =3D target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() for"
+				" LIO-Target failed!\n");
+		target_fabric_configfs_free(fabric);
+		return -1;
+	}
+
+	lio_target_fabric_configfs =3D fabric;
+	printk(KERN_INFO "LIO_TARGET[0] - Set fabric ->"
+			" lio_target_fabric_configfs\n");
+	return 0;
+}
+
+
+void iscsi_target_deregister_configfs(void)
+{
+	if (!(lio_target_fabric_configfs))
+		return;
+	/*
+	 * Shutdown discovery sessions and disable discovery TPG
+	 */
+	if (iscsi_global->discovery_tpg)
+		iscsi_tpg_disable_portal_group(iscsi_global->discovery_tpg, 1);
+
+	target_fabric_configfs_deregister(lio_target_fabric_configfs);
+	lio_target_fabric_configfs =3D NULL;
+	printk(KERN_INFO "LIO_TARGET[0] - Cleared"
+				" lio_target_fabric_configfs\n");
+}
diff --git a/drivers/target/iscsi/iscsi_target_configfs.h b/drivers/tar=
get/iscsi/iscsi_target_configfs.h
new file mode 100644
index 0000000..52c5123
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_configfs.h
@@ -0,0 +1,9 @@
+#ifndef ISCSI_TARGET_CONFIGFS_H
+#define ISCSI_TARGET_CONFIGFS_H
+
+extern int iscsi_target_register_configfs(void);
+extern void iscsi_target_deregister_configfs(void);
+
+extern struct kmem_cache *lio_tpg_cache;
+
+#endif /* ISCSI_TARGET_CONFIGFS_H */
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/t=
arget/iscsi/iscsi_target_nodeattrib.c
new file mode 100644
index 0000000..b889e88
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -0,0 +1,300 @@
+/*********************************************************************=
**********
+ * This file contains the main functions related to Initiator Node Att=
ributes.
+ *
+ * Copyright (c) 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*********/
+
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target_nodeattrib.h"
+
+static inline char *iscsi_na_get_initiatorname(
+	struct iscsi_node_acl *nacl)
+{
+	struct se_node_acl *se_nacl =3D &nacl->se_node_acl;
+
+	return &se_nacl->initiatorname[0];
+}
+
+/*	iscsi_set_default_node_attribues():
+ *
+ *
+ */
+void iscsi_set_default_node_attribues(
+	struct iscsi_node_acl *acl)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	a->dataout_timeout =3D NA_DATAOUT_TIMEOUT;
+	a->dataout_timeout_retries =3D NA_DATAOUT_TIMEOUT_RETRIES;
+	a->nopin_timeout =3D NA_NOPIN_TIMEOUT;
+	a->nopin_response_timeout =3D NA_NOPIN_RESPONSE_TIMEOUT;
+	a->random_datain_pdu_offsets =3D NA_RANDOM_DATAIN_PDU_OFFSETS;
+	a->random_datain_seq_offsets =3D NA_RANDOM_DATAIN_SEQ_OFFSETS;
+	a->random_r2t_offsets =3D NA_RANDOM_R2T_OFFSETS;
+	a->default_erl =3D NA_DEFAULT_ERL;
+}
+
+/*	iscsi_na_dataout_timeout():
+ *
+ *
+ */
+extern int iscsi_na_dataout_timeout(
+	struct iscsi_node_acl *acl,
+	u32 dataout_timeout)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (dataout_timeout > NA_DATAOUT_TIMEOUT_MAX) {
+		printk(KERN_ERR "Requested DataOut Timeout %u larger than"
+			" maximum %u\n", dataout_timeout,
+			NA_DATAOUT_TIMEOUT_MAX);
+		return -EINVAL;
+	} else if (dataout_timeout < NA_DATAOUT_TIMEOUT_MIX) {
+		printk(KERN_ERR "Requested DataOut Timeout %u smaller than"
+			" minimum %u\n", dataout_timeout,
+			NA_DATAOUT_TIMEOUT_MIX);
+		return -EINVAL;
+	}
+
+	a->dataout_timeout =3D dataout_timeout;
+	TRACE(TRACE_NODEATTRIB, "Set DataOut Timeout to %u for Initiator Node=
"
+		" %s\n", a->dataout_timeout, iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
+
+/*	iscsi_na_dataout_timeout_retries():
+ *
+ *
+ */
+extern int iscsi_na_dataout_timeout_retries(
+	struct iscsi_node_acl *acl,
+	u32 dataout_timeout_retries)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (dataout_timeout_retries > NA_DATAOUT_TIMEOUT_RETRIES_MAX) {
+		printk(KERN_ERR "Requested DataOut Timeout Retries %u larger"
+			" than maximum %u", dataout_timeout_retries,
+				NA_DATAOUT_TIMEOUT_RETRIES_MAX);
+		return -EINVAL;
+	} else if (dataout_timeout_retries < NA_DATAOUT_TIMEOUT_RETRIES_MIN) =
{
+		printk(KERN_ERR "Requested DataOut Timeout Retries %u smaller"
+			" than minimum %u", dataout_timeout_retries,
+				NA_DATAOUT_TIMEOUT_RETRIES_MIN);
+		return -EINVAL;
+	}
+
+	a->dataout_timeout_retries =3D dataout_timeout_retries;
+	TRACE(TRACE_NODEATTRIB, "Set DataOut Timeout Retries to %u for"
+		" Initiator Node %s\n", a->dataout_timeout_retries,
+		iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
+
+/*	iscsi_na_nopin_timeout():
+ *
+ *
+ */
+extern int iscsi_na_nopin_timeout(
+	struct iscsi_node_acl *acl,
+	u32 nopin_timeout)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+	struct se_node_acl *se_nacl =3D &a->nacl->se_node_acl;
+	struct se_session *se_sess;
+	u32 orig_nopin_timeout =3D a->nopin_timeout;
+
+	if (nopin_timeout > NA_NOPIN_TIMEOUT_MAX) {
+		printk(KERN_ERR "Requested NopIn Timeout %u larger than maximum"
+			" %u\n", nopin_timeout, NA_NOPIN_TIMEOUT_MAX);
+		return -EINVAL;
+	} else if ((nopin_timeout < NA_NOPIN_TIMEOUT_MIN) &&
+		   (nopin_timeout !=3D 0)) {
+		printk(KERN_ERR "Requested NopIn Timeout %u smaller than"
+			" minimum %u and not 0\n", nopin_timeout,
+			NA_NOPIN_TIMEOUT_MIN);
+		return -EINVAL;
+	}
+
+	a->nopin_timeout =3D nopin_timeout;
+	TRACE(TRACE_NODEATTRIB, "Set NopIn Timeout to %u for Initiator"
+		" Node %s\n", a->nopin_timeout,
+		iscsi_na_get_initiatorname(acl));
+	/*
+	 * Reenable disabled nopin_timeout timer for all iSCSI connections.
+	 */
+	if (!(orig_nopin_timeout)) {
+		spin_lock_bh(&se_nacl->nacl_sess_lock);
+		se_sess =3D se_nacl->nacl_sess;
+		if (se_sess) {
+			sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
+
+			spin_lock(&sess->conn_lock);
+			list_for_each_entry(conn, &sess->sess_conn_list,
+					conn_list) {
+				if (conn->conn_state !=3D
+						TARG_CONN_STATE_LOGGED_IN)
+					continue;
+
+				spin_lock(&conn->nopin_timer_lock);
+				__iscsi_start_nopin_timer(conn);
+				spin_unlock(&conn->nopin_timer_lock);
+			}
+			spin_unlock(&sess->conn_lock);
+		}
+		spin_unlock_bh(&se_nacl->nacl_sess_lock);
+	}
+
+	return 0;
+}
+
+/*	iscsi_na_nopin_response_timeout():
+ *
+ *
+ */
+extern int iscsi_na_nopin_response_timeout(
+	struct iscsi_node_acl *acl,
+	u32 nopin_response_timeout)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (nopin_response_timeout > NA_NOPIN_RESPONSE_TIMEOUT_MAX) {
+		printk(KERN_ERR "Requested NopIn Response Timeout %u larger"
+			" than maximum %u\n", nopin_response_timeout,
+				NA_NOPIN_RESPONSE_TIMEOUT_MAX);
+		return -EINVAL;
+	} else if (nopin_response_timeout < NA_NOPIN_RESPONSE_TIMEOUT_MIN) {
+		printk(KERN_ERR "Requested NopIn Response Timeout %u smaller"
+			" than minimum %u\n", nopin_response_timeout,
+				NA_NOPIN_RESPONSE_TIMEOUT_MIN);
+		return -EINVAL;
+	}
+
+	a->nopin_response_timeout =3D nopin_response_timeout;
+	TRACE(TRACE_NODEATTRIB, "Set NopIn Response Timeout to %u for"
+		" Initiator Node %s\n", a->nopin_timeout,
+		iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
+
+/*	iscsi_na_random_datain_pdu_offsets():
+ *
+ *
+ */
+extern int iscsi_na_random_datain_pdu_offsets(
+	struct iscsi_node_acl *acl,
+	u32 random_datain_pdu_offsets)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (random_datain_pdu_offsets !=3D 0 && random_datain_pdu_offsets !=3D=
 1) {
+		printk(KERN_ERR "Requested Random DataIN PDU Offsets: %u not"
+			" 0 or 1\n", random_datain_pdu_offsets);
+		return -EINVAL;
+	}
+
+	a->random_datain_pdu_offsets =3D random_datain_pdu_offsets;
+	TRACE(TRACE_NODEATTRIB, "Set Random DataIN PDU Offsets to %u for"
+		" Initiator Node %s\n", a->random_datain_pdu_offsets,
+		iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
+
+/*	iscsi_na_random_datain_seq_offsets():
+ *
+ *
+ */
+extern int iscsi_na_random_datain_seq_offsets(
+	struct iscsi_node_acl *acl,
+	u32 random_datain_seq_offsets)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (random_datain_seq_offsets !=3D 0 && random_datain_seq_offsets !=3D=
 1) {
+		printk(KERN_ERR "Requested Random DataIN Sequence Offsets: %u"
+			" not 0 or 1\n", random_datain_seq_offsets);
+		return -EINVAL;
+	}
+
+	a->random_datain_seq_offsets =3D random_datain_seq_offsets;
+	TRACE(TRACE_NODEATTRIB, "Set Random DataIN Sequence Offsets to %u for=
"
+		" Initiator Node %s\n", a->random_datain_seq_offsets,
+		iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
+
+/*	iscsi_na_random_r2t_offsets():
+ *
+ *
+ */
+extern int iscsi_na_random_r2t_offsets(
+	struct iscsi_node_acl *acl,
+	u32 random_r2t_offsets)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (random_r2t_offsets !=3D 0 && random_r2t_offsets !=3D 1) {
+		printk(KERN_ERR "Requested Random R2T Offsets: %u not"
+			" 0 or 1\n", random_r2t_offsets);
+		return -EINVAL;
+	}
+
+	a->random_r2t_offsets =3D random_r2t_offsets;
+	TRACE(TRACE_NODEATTRIB, "Set Random R2T Offsets to %u for"
+		" Initiator Node %s\n", a->random_r2t_offsets,
+		iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
+
+extern int iscsi_na_default_erl(
+	struct iscsi_node_acl *acl,
+	u32 default_erl)
+{
+	struct iscsi_node_attrib *a =3D &acl->node_attrib;
+
+	if (default_erl !=3D 0 && default_erl !=3D 1 && default_erl !=3D 2) {
+		printk(KERN_ERR "Requested default ERL: %u not 0, 1, or 2\n",
+				default_erl);
+		return -EINVAL;
+	}
+
+	a->default_erl =3D default_erl;
+	TRACE(TRACE_NODEATTRIB, "Set use ERL0 flag to %u for Initiator"
+		" Node %s\n", a->default_erl,
+		iscsi_na_get_initiatorname(acl));
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.h b/drivers/t=
arget/iscsi/iscsi_target_nodeattrib.h
new file mode 100644
index 0000000..ed5884e
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.h
@@ -0,0 +1,14 @@
+#ifndef ISCSI_TARGET_NODEATTRIB_H
+#define ISCSI_TARGET_NODEATTRIB_H
+
+extern void iscsi_set_default_node_attribues(struct iscsi_node_acl *);
+extern int iscsi_na_dataout_timeout(struct iscsi_node_acl *, u32);
+extern int iscsi_na_dataout_timeout_retries(struct iscsi_node_acl *, u=
32);
+extern int iscsi_na_nopin_timeout(struct iscsi_node_acl *, u32);
+extern int iscsi_na_nopin_response_timeout(struct iscsi_node_acl *, u3=
2);
+extern int iscsi_na_random_datain_pdu_offsets(struct iscsi_node_acl *,=
 u32);
+extern int iscsi_na_random_datain_seq_offsets(struct iscsi_node_acl *,=
 u32);
+extern int iscsi_na_random_r2t_offsets(struct iscsi_node_acl *, u32);
+extern int iscsi_na_default_erl(struct iscsi_node_acl *, u32);
+
+#endif /* ISCSI_TARGET_NODEATTRIB_H */
--=20
1.7.4.1
