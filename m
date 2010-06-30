From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 11/12] be2iscsi: iscsi boot changes for the kernel
Date: Wed, 30 Jun 2010 05:31:53 +0530
Message-ID: <20100630000137.GA20320@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34593 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754065Ab0F3ABp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:01:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This pacth contain the changes required for iscsi_boot

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/firmware/Kconfig            |    9 +
 drivers/firmware/Makefile           |    1 +
 drivers/firmware/iscsi_boot_sysfs.c |  472 +++++++++++++++++++++++
 drivers/firmware/iscsi_ibft.c       |  726 +++++++++++++----------------------
 drivers/firmware/iscsi_ibft_find.c  |   55 ++-
 drivers/scsi/be2iscsi/be_main.h     |    1 -
 include/linux/iscsi_boot_sysfs.h    |  123 ++++++
 include/linux/iscsi_ibft.h          |   12 +-
 9 files changed, 925 insertions(+), 485 deletions(-)
 create mode 100644 drivers/firmware/iscsi_boot_sysfs.c
 create mode 100644 include/linux/iscsi_boot_sysfs.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 1b03ba1..a6c670b 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -122,8 +122,17 @@ config ISCSI_IBFT_FIND
 	  is necessary for iSCSI Boot Firmware Table Attributes module to work
 	  properly.
 
+config ISCSI_BOOT_SYSFS
+	tristate "iSCSI Boot Sysfs Interface"
+	default	n
+	help
+	  This option enables support for exposing iSCSI boot information
+	  via sysfs to userspace. If you wish to export this information,
+	  say Y. Otherwise, say N.
+
 config ISCSI_IBFT
 	tristate "iSCSI Boot Firmware Table Attributes module"
+	select ISCSI_BOOT_SYSFS
 	depends on ISCSI_IBFT_FIND
 	default	n
 	help
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 1c3c173..5fe7e16 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_DCDBAS)		+= dcdbas.o
 obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
+obj-$(CONFIG_ISCSI_BOOT_SYSFS)	+= iscsi_boot_sysfs.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
diff --git a/drivers/firmware/iscsi_boot_sysfs.c b/drivers/firmware/iscsi_boot_sysfs.c
new file mode 100644
index 0000000..2d6bf94
--- /dev/null
+++ b/drivers/firmware/iscsi_boot_sysfs.c
@@ -0,0 +1,472 @@
+/*
+ * Export the iSCSI boot info to userland via sysfs.
+ *
+ * Copyright (C) 2010 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2010 Mike Christie
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include <linux/capability.h>
+#include <linux/iscsi_boot_sysfs.h>
+
+
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>");
+MODULE_DESCRIPTION("sysfs interface and helpers to export iSCSI boot information");
+MODULE_LICENSE("GPL");
+/*
+ * The kobject and attribute structures.
+ */
+struct iscsi_boot_attr {
+	struct attribute attr;
+	int type;
+	ssize_t (*show) (void *data, int type, char *buf);
+};
+
+/*
+ * The routine called for all sysfs attributes.
+ */
+static ssize_t iscsi_boot_show_attribute(struct kobject *kobj,
+					 struct attribute *attr, char *buf)
+{
+	struct iscsi_boot_kobj *boot_kobj =
+			container_of(kobj, struct iscsi_boot_kobj, kobj);
+	struct iscsi_boot_attr *boot_attr =
+			container_of(attr, struct iscsi_boot_attr, attr);
+	ssize_t ret = -EIO;
+	char *str = buf;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (boot_kobj->show)
+		ret = boot_kobj->show(boot_kobj->data, boot_attr->type, str);
+	return ret;
+}
+
+static const struct sysfs_ops iscsi_boot_attr_ops = {
+	.show = iscsi_boot_show_attribute,
+};
+
+static void iscsi_boot_kobj_release(struct kobject *kobj)
+{
+	struct iscsi_boot_kobj *boot_kobj =
+			container_of(kobj, struct iscsi_boot_kobj, kobj);
+
+	kfree(boot_kobj->data);
+	kfree(boot_kobj);
+}
+
+static struct kobj_type iscsi_boot_ktype = {
+	.release = iscsi_boot_kobj_release,
+	.sysfs_ops = &iscsi_boot_attr_ops,
+};
+
+#define iscsi_boot_rd_attr(fnname, sysfs_name, attr_type)		\
+static struct iscsi_boot_attr iscsi_boot_attr_##fnname = {	\
+	.attr	= { .name = __stringify(sysfs_name), .mode = 0444 },	\
+	.type	= attr_type,						\
+}
+
+/* Target attrs */
+iscsi_boot_rd_attr(tgt_index, index, ISCSI_BOOT_TGT_INDEX);
+iscsi_boot_rd_attr(tgt_flags, flags, ISCSI_BOOT_TGT_FLAGS);
+iscsi_boot_rd_attr(tgt_ip, ip-addr, ISCSI_BOOT_TGT_IP_ADDR);
+iscsi_boot_rd_attr(tgt_port, port, ISCSI_BOOT_TGT_PORT);
+iscsi_boot_rd_attr(tgt_lun, lun, ISCSI_BOOT_TGT_LUN);
+iscsi_boot_rd_attr(tgt_chap, chap-type, ISCSI_BOOT_TGT_CHAP_TYPE);
+iscsi_boot_rd_attr(tgt_nic, nic-assoc, ISCSI_BOOT_TGT_NIC_ASSOC);
+iscsi_boot_rd_attr(tgt_name, target-name, ISCSI_BOOT_TGT_NAME);
+iscsi_boot_rd_attr(tgt_chap_name, chap-name, ISCSI_BOOT_TGT_CHAP_NAME);
+iscsi_boot_rd_attr(tgt_chap_secret, chap-secret, ISCSI_BOOT_TGT_CHAP_SECRET);
+iscsi_boot_rd_attr(tgt_chap_rev_name, rev-chap-name,
+		   ISCSI_BOOT_TGT_REV_CHAP_NAME);
+iscsi_boot_rd_attr(tgt_chap_rev_secret, rev-chap-name-secret,
+		   ISCSI_BOOT_TGT_REV_CHAP_SECRET);
+
+static struct attribute *target_attrs[] = {
+	&iscsi_boot_attr_tgt_index.attr,
+	&iscsi_boot_attr_tgt_flags.attr,
+	&iscsi_boot_attr_tgt_ip.attr,
+	&iscsi_boot_attr_tgt_port.attr,
+	&iscsi_boot_attr_tgt_lun.attr,
+	&iscsi_boot_attr_tgt_chap.attr,
+	&iscsi_boot_attr_tgt_nic.attr,
+	&iscsi_boot_attr_tgt_name.attr,
+	&iscsi_boot_attr_tgt_chap_name.attr,
+	&iscsi_boot_attr_tgt_chap_secret.attr,
+	&iscsi_boot_attr_tgt_chap_rev_name.attr,
+	&iscsi_boot_attr_tgt_chap_rev_secret.attr,
+	NULL
+};
+
+static mode_t iscsi_boot_tgt_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int i)
+{
+	struct iscsi_boot_kobj *boot_kobj =
+			container_of(kobj, struct iscsi_boot_kobj, kobj);
+
+	if (attr ==  &iscsi_boot_attr_tgt_index.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_INDEX);
+	else if (attr == &iscsi_boot_attr_tgt_flags.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_FLAGS);
+	else if (attr == &iscsi_boot_attr_tgt_ip.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					      ISCSI_BOOT_TGT_IP_ADDR);
+	else if (attr == &iscsi_boot_attr_tgt_port.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					      ISCSI_BOOT_TGT_PORT);
+	else if (attr == &iscsi_boot_attr_tgt_lun.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					      ISCSI_BOOT_TGT_LUN);
+	else if (attr == &iscsi_boot_attr_tgt_chap.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_CHAP_TYPE);
+	else if (attr == &iscsi_boot_attr_tgt_nic.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_NIC_ASSOC);
+	else if (attr == &iscsi_boot_attr_tgt_name.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_NAME);
+	else if (attr == &iscsi_boot_attr_tgt_chap_name.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_CHAP_NAME);
+	else if (attr == &iscsi_boot_attr_tgt_chap_secret.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_CHAP_SECRET);
+	else if (attr == &iscsi_boot_attr_tgt_chap_rev_name.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_REV_CHAP_NAME);
+	else if (attr == &iscsi_boot_attr_tgt_chap_rev_secret.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_TGT_REV_CHAP_SECRET);
+	return 0;
+}
+
+static struct attribute_group iscsi_boot_target_attr_group = {
+	.attrs = target_attrs,
+	.is_visible = iscsi_boot_tgt_attr_is_visible,
+};
+
+/* Ethernet attrs */
+iscsi_boot_rd_attr(eth_index, index, ISCSI_BOOT_ETH_INDEX);
+iscsi_boot_rd_attr(eth_flags, flags, ISCSI_BOOT_ETH_FLAGS);
+iscsi_boot_rd_attr(eth_ip, ip-addr, ISCSI_BOOT_ETH_IP_ADDR);
+iscsi_boot_rd_attr(eth_subnet, subnet-mask, ISCSI_BOOT_ETH_SUBNET_MASK);
+iscsi_boot_rd_attr(eth_origin, origin, ISCSI_BOOT_ETH_ORIGIN);
+iscsi_boot_rd_attr(eth_gateway, gateway, ISCSI_BOOT_ETH_GATEWAY);
+iscsi_boot_rd_attr(eth_primary_dns, primary-dns, ISCSI_BOOT_ETH_PRIMARY_DNS);
+iscsi_boot_rd_attr(eth_secondary_dns, secondary-dns,
+		   ISCSI_BOOT_ETH_SECONDARY_DNS);
+iscsi_boot_rd_attr(eth_dhcp, dhcp, ISCSI_BOOT_ETH_DHCP);
+iscsi_boot_rd_attr(eth_vlan, vlan, ISCSI_BOOT_ETH_VLAN);
+iscsi_boot_rd_attr(eth_mac, mac, ISCSI_BOOT_ETH_MAC);
+iscsi_boot_rd_attr(eth_hostname, hostname, ISCSI_BOOT_ETH_HOSTNAME);
+
+static struct attribute *ethernet_attrs[] = {
+	&iscsi_boot_attr_eth_index.attr,
+	&iscsi_boot_attr_eth_flags.attr,
+	&iscsi_boot_attr_eth_ip.attr,
+	&iscsi_boot_attr_eth_subnet.attr,
+	&iscsi_boot_attr_eth_origin.attr,
+	&iscsi_boot_attr_eth_gateway.attr,
+	&iscsi_boot_attr_eth_primary_dns.attr,
+	&iscsi_boot_attr_eth_secondary_dns.attr,
+	&iscsi_boot_attr_eth_dhcp.attr,
+	&iscsi_boot_attr_eth_vlan.attr,
+	&iscsi_boot_attr_eth_mac.attr,
+	&iscsi_boot_attr_eth_hostname.attr,
+	NULL
+};
+
+static mode_t iscsi_boot_eth_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int i)
+{
+	struct iscsi_boot_kobj *boot_kobj =
+			container_of(kobj, struct iscsi_boot_kobj, kobj);
+
+	if (attr ==  &iscsi_boot_attr_eth_index.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_INDEX);
+	else if (attr ==  &iscsi_boot_attr_eth_flags.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_FLAGS);
+	else if (attr ==  &iscsi_boot_attr_eth_ip.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_IP_ADDR);
+	else if (attr ==  &iscsi_boot_attr_eth_subnet.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_SUBNET_MASK);
+	else if (attr ==  &iscsi_boot_attr_eth_origin.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_ORIGIN);
+	else if (attr ==  &iscsi_boot_attr_eth_gateway.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_GATEWAY);
+	else if (attr ==  &iscsi_boot_attr_eth_primary_dns.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_PRIMARY_DNS);
+	else if (attr ==  &iscsi_boot_attr_eth_secondary_dns.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_SECONDARY_DNS);
+	else if (attr ==  &iscsi_boot_attr_eth_dhcp.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_DHCP);
+	else if (attr ==  &iscsi_boot_attr_eth_vlan.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_VLAN);
+	else if (attr ==  &iscsi_boot_attr_eth_mac.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_MAC);
+	else if (attr ==  &iscsi_boot_attr_eth_hostname.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_HOSTNAME);
+	return 0;
+}
+
+static struct attribute_group iscsi_boot_ethernet_attr_group = {
+	.attrs = ethernet_attrs,
+	.is_visible = iscsi_boot_eth_attr_is_visible,
+};
+
+/* Initiator attrs */
+iscsi_boot_rd_attr(ini_index, index, ISCSI_BOOT_INI_INDEX);
+iscsi_boot_rd_attr(ini_flags, flags, ISCSI_BOOT_INI_FLAGS);
+iscsi_boot_rd_attr(ini_isns, isns-server, ISCSI_BOOT_INI_ISNS_SERVER);
+iscsi_boot_rd_attr(ini_slp, slp-server, ISCSI_BOOT_INI_SLP_SERVER);
+iscsi_boot_rd_attr(ini_primary_radius, pri-radius-server,
+		   ISCSI_BOOT_INI_PRI_RADIUS_SERVER);
+iscsi_boot_rd_attr(ini_secondary_radius, sec-radius-server,
+		   ISCSI_BOOT_INI_SEC_RADIUS_SERVER);
+iscsi_boot_rd_attr(ini_name, initiator-name, ISCSI_BOOT_INI_INITIATOR_NAME);
+
+static struct attribute *initiator_attrs[] = {
+	&iscsi_boot_attr_ini_index.attr,
+	&iscsi_boot_attr_ini_flags.attr,
+	&iscsi_boot_attr_ini_isns.attr,
+	&iscsi_boot_attr_ini_slp.attr,
+	&iscsi_boot_attr_ini_primary_radius.attr,
+	&iscsi_boot_attr_ini_secondary_radius.attr,
+	&iscsi_boot_attr_ini_name.attr,
+	NULL
+};
+
+static mode_t iscsi_boot_ini_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int i)
+{
+	struct iscsi_boot_kobj *boot_kobj =
+			container_of(kobj, struct iscsi_boot_kobj, kobj);
+
+	if (attr ==  &iscsi_boot_attr_ini_index.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_INDEX);
+	if (attr ==  &iscsi_boot_attr_ini_flags.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_FLAGS);
+	if (attr ==  &iscsi_boot_attr_ini_isns.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_ISNS_SERVER);
+	if (attr ==  &iscsi_boot_attr_ini_slp.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_SLP_SERVER);
+	if (attr ==  &iscsi_boot_attr_ini_primary_radius.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_PRI_RADIUS_SERVER);
+	if (attr ==  &iscsi_boot_attr_ini_secondary_radius.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_SEC_RADIUS_SERVER);
+	if (attr ==  &iscsi_boot_attr_ini_name.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_INI_INITIATOR_NAME);
+
+	return 0;
+}
+
+static struct attribute_group iscsi_boot_initiator_attr_group = {
+	.attrs = initiator_attrs,
+	.is_visible = iscsi_boot_ini_attr_is_visible,
+};
+
+static struct iscsi_boot_kobj *
+iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_kset,
+		       struct attribute_group *attr_group,
+		       const char *name, int index, void *data,
+		       ssize_t (*show) (void *data, int type, char *buf),
+		       mode_t (*is_visible) (void *data, int type))
+{
+	struct iscsi_boot_kobj *boot_kobj;
+
+	boot_kobj = kzalloc(sizeof(*boot_kobj), GFP_KERNEL);
+	if (!boot_kobj)
+		return NULL;
+	INIT_LIST_HEAD(&boot_kobj->list);
+
+	boot_kobj->kobj.kset = boot_kset->kset;
+	if (kobject_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,
+				 NULL, name, index)) {
+		kfree(boot_kobj);
+		return NULL;
+	}
+	boot_kobj->data = data;
+	boot_kobj->show = show;
+	boot_kobj->is_visible = is_visible;
+
+	if (sysfs_create_group(&boot_kobj->kobj, attr_group)) {
+		/*
+		 * We do not want to free this because the caller
+		 * will assume that since the creation call failed
+		 * the boot kobj was not setup and the normal release
+		 * path is not being run.
+		 */
+		boot_kobj->data = NULL;
+		kobject_put(&boot_kobj->kobj);
+		return NULL;
+	}
+	boot_kobj->attr_group = attr_group;
+
+	kobject_uevent(&boot_kobj->kobj, KOBJ_ADD);
+	/* Nothing broke so lets add it to the list. */
+	list_add_tail(&boot_kobj->list, &boot_kset->kobj_list);
+	return boot_kobj;
+}
+
+static void iscsi_boot_remove_kobj(struct iscsi_boot_kobj *boot_kobj)
+{
+	list_del(&boot_kobj->list);
+	sysfs_remove_group(&boot_kobj->kobj, boot_kobj->attr_group);
+	kobject_put(&boot_kobj->kobj);
+}
+
+/**
+ * iscsi_boot_create_target() - create boot target sysfs dir
+ * @boot_kset: boot kset
+ * @index: the target id
+ * @data: driver specific data
+ * @show: attr show function
+ * @is_visible: attr visibility function
+ */
+struct iscsi_boot_kobj *
+iscsi_boot_create_target(struct iscsi_boot_kset *boot_kset, int index,
+			 void *data,
+			 ssize_t (*show) (void *data, int type, char *buf),
+			 mode_t (*is_visible) (void *data, int type))
+{
+	return iscsi_boot_create_kobj(boot_kset, &iscsi_boot_target_attr_group,
+				      "target%d", index, data, show, is_visible);
+}
+EXPORT_SYMBOL_GPL(iscsi_boot_create_target);
+
+/**
+ * iscsi_boot_create_initiator() - create boot initiator sysfs dir
+ * @boot_kset: boot kset
+ * @index: the initiator id
+ * @data: driver specific data
+ * @show: attr show function
+ * @is_visible: attr visibility function
+ */
+struct iscsi_boot_kobj *
+iscsi_boot_create_initiator(struct iscsi_boot_kset *boot_kset, int index,
+			    void *data,
+			    ssize_t (*show) (void *data, int type, char *buf),
+			    mode_t (*is_visible) (void *data, int type))
+{
+	return iscsi_boot_create_kobj(boot_kset,
+				      &iscsi_boot_initiator_attr_group,
+				      "initiator", index, data, show,
+				      is_visible);
+}
+EXPORT_SYMBOL_GPL(iscsi_boot_create_initiator);
+
+/**
+ * iscsi_boot_create_ethernet() - create boot ethernet sysfs dir
+ * @boot_kset: boot kset
+ * @index: the ethernet device id
+ * @data: driver specific data
+ * @show: attr show function
+ * @is_visible: attr visibility function
+ */
+struct iscsi_boot_kobj *
+iscsi_boot_create_ethernet(struct iscsi_boot_kset *boot_kset, int index,
+			   void *data,
+			   ssize_t (*show) (void *data, int type, char *buf),
+			   mode_t (*is_visible) (void *data, int type))
+{
+	return iscsi_boot_create_kobj(boot_kset,
+				      &iscsi_boot_ethernet_attr_group,
+				      "ethernet%d", index, data, show,
+				      is_visible);
+}
+EXPORT_SYMBOL_GPL(iscsi_boot_create_ethernet);
+
+/**
+ * iscsi_boot_create_kset() - creates root sysfs tree
+ * @set_name: name of root dir
+ */
+struct iscsi_boot_kset *iscsi_boot_create_kset(const char *set_name)
+{
+	struct iscsi_boot_kset *boot_kset;
+
+	boot_kset = kzalloc(sizeof(*boot_kset), GFP_KERNEL);
+	if (!boot_kset)
+		return NULL;
+
+	boot_kset->kset = kset_create_and_add(set_name, NULL, firmware_kobj);
+	if (!boot_kset->kset) {
+		kfree(boot_kset);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&boot_kset->kobj_list);
+	return boot_kset;
+}
+EXPORT_SYMBOL_GPL(iscsi_boot_create_kset);
+
+/**
+ * iscsi_boot_create_host_kset() - creates root sysfs tree for a scsi host
+ * @hostno: host number of scsi host
+ */
+struct iscsi_boot_kset *iscsi_boot_create_host_kset(unsigned int hostno)
+{
+	struct iscsi_boot_kset *boot_kset;
+	char *set_name;
+
+	set_name = kasprintf(GFP_KERNEL, "iscsi_boot%u", hostno);
+	if (!set_name)
+		return NULL;
+
+	boot_kset = iscsi_boot_create_kset(set_name);
+	kfree(set_name);
+	return boot_kset;
+}
+EXPORT_SYMBOL_GPL(iscsi_boot_create_host_kset);
+
+/**
+ * iscsi_boot_destroy_kset() - destroy kset and kobjects under it
+ * @boot_kset: boot kset
+ *
+ * This will remove the kset and kobjects and attrs under it.
+ */
+void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
+{
+	struct iscsi_boot_kobj *boot_kobj, *tmp_kobj;
+
+	list_for_each_entry_safe(boot_kobj, tmp_kobj,
+				 &boot_kset->kobj_list, list)
+		iscsi_boot_remove_kobj(boot_kobj);
+
+	kset_unregister(boot_kset->kset);
+}
+EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index ed2801c..693238c 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright 2007 Red Hat, Inc.
+ *  Copyright 2007-2010 Red Hat, Inc.
  *  by Peter Jones <pjones@redhat.com>
  *  Copyright 2008 IBM, Inc.
  *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
@@ -19,6 +19,9 @@
  *
  * Changelog:
  *
+ *  06 Jan 2010 - Peter Jones <pjones@redhat.com>
+ *    New changelog entries are in the git log from now on.  Not here.
+ *
  *  14 Mar 2008 - Konrad Rzeszutek <ketuzsezr@darnok.org>
  *    Updated comments and copyrights. (v0.4.9)
  *
@@ -78,9 +81,11 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
+#include <linux/iscsi_boot_sysfs.h>
 
-#define IBFT_ISCSI_VERSION "0.4.9"
-#define IBFT_ISCSI_DATE "2008-Mar-14"
+#define IBFT_ISCSI_VERSION "0.5.0"
+#define IBFT_ISCSI_DATE "2010-Feb-25"
 
 MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and \
 Konrad Rzeszutek <ketuzsezr@darnok.org>");
@@ -166,108 +171,20 @@ enum ibft_id {
 };
 
 /*
- * We do not support the other types, hence the usage of NULL.
- * This maps to the enum ibft_id.
- */
-static const char *ibft_id_names[] =
-	{NULL, NULL, "initiator", "ethernet%d", "target%d", NULL, NULL};
-
-/*
- * The text attributes names for each of the kobjects.
-*/
-enum ibft_eth_properties_enum {
-	ibft_eth_index,
-	ibft_eth_flags,
-	ibft_eth_ip_addr,
-	ibft_eth_subnet_mask,
-	ibft_eth_origin,
-	ibft_eth_gateway,
-	ibft_eth_primary_dns,
-	ibft_eth_secondary_dns,
-	ibft_eth_dhcp,
-	ibft_eth_vlan,
-	ibft_eth_mac,
-	/* ibft_eth_pci_bdf - this is replaced by link to the device itself. */
-	ibft_eth_hostname,
-	ibft_eth_end_marker,
-};
-
-static const char *ibft_eth_properties[] =
-	{"index", "flags", "ip-addr", "subnet-mask", "origin", "gateway",
-	"primary-dns", "secondary-dns", "dhcp", "vlan", "mac", "hostname",
-	NULL};
-
-enum ibft_tgt_properties_enum {
-	ibft_tgt_index,
-	ibft_tgt_flags,
-	ibft_tgt_ip_addr,
-	ibft_tgt_port,
-	ibft_tgt_lun,
-	ibft_tgt_chap_type,
-	ibft_tgt_nic_assoc,
-	ibft_tgt_name,
-	ibft_tgt_chap_name,
-	ibft_tgt_chap_secret,
-	ibft_tgt_rev_chap_name,
-	ibft_tgt_rev_chap_secret,
-	ibft_tgt_end_marker,
-};
-
-static const char *ibft_tgt_properties[] =
-	{"index", "flags", "ip-addr", "port", "lun", "chap-type", "nic-assoc",
-	"target-name", "chap-name", "chap-secret", "rev-chap-name",
-	"rev-chap-name-secret", NULL};
-
-enum ibft_initiator_properties_enum {
-	ibft_init_index,
-	ibft_init_flags,
-	ibft_init_isns_server,
-	ibft_init_slp_server,
-	ibft_init_pri_radius_server,
-	ibft_init_sec_radius_server,
-	ibft_init_initiator_name,
-	ibft_init_end_marker,
-};
-
-static const char *ibft_initiator_properties[] =
-	{"index", "flags", "isns-server", "slp-server", "pri-radius-server",
-	"sec-radius-server", "initiator-name", NULL};
-
-/*
  * The kobject and attribute structures.
  */
 
 struct ibft_kobject {
-	struct ibft_table_header *header;
+	struct acpi_table_ibft *header;
 	union {
 		struct ibft_initiator *initiator;
 		struct ibft_nic *nic;
 		struct ibft_tgt *tgt;
 		struct ibft_hdr *hdr;
 	};
-	struct kobject kobj;
-	struct list_head node;
 };
 
-struct ibft_attribute {
-	struct attribute attr;
-	ssize_t (*show) (struct  ibft_kobject *entry,
-			 struct ibft_attribute *attr, char *buf);
-	union {
-		struct ibft_initiator *initiator;
-		struct ibft_nic *nic;
-		struct ibft_tgt *tgt;
-		struct ibft_hdr *hdr;
-	};
-	struct kobject *kobj;
-	int type; /* The enum of the type. This can be any value of:
-		ibft_eth_properties_enum, ibft_tgt_properties_enum,
-		or ibft_initiator_properties_enum. */
-	struct list_head node;
-};
-
-static LIST_HEAD(ibft_attr_list);
-static LIST_HEAD(ibft_kobject_list);
+static struct iscsi_boot_kset *boot_kset;
 
 static const char nulls[16];
 
@@ -306,35 +223,27 @@ static ssize_t sprintf_string(char *str, int len, char *buf)
 static int ibft_verify_hdr(char *t, struct ibft_hdr *hdr, int id, int length)
 {
 	if (hdr->id != id) {
-		printk(KERN_ERR "iBFT error: We expected the " \
+		printk(KERN_ERR "iBFT error: We expected the %s " \
 				"field header.id to have %d but " \
-				"found %d instead!\n", id, hdr->id);
+				"found %d instead!\n", t, id, hdr->id);
 		return -ENODEV;
 	}
 	if (hdr->length != length) {
-		printk(KERN_ERR "iBFT error: We expected the " \
+		printk(KERN_ERR "iBFT error: We expected the %s " \
 				"field header.length to have %d but " \
-				"found %d instead!\n", length, hdr->length);
+				"found %d instead!\n", t, length, hdr->length);
 		return -ENODEV;
 	}
 
 	return 0;
 }
 
-static void ibft_release(struct kobject *kobj)
-{
-	struct ibft_kobject *ibft =
-		container_of(kobj, struct ibft_kobject, kobj);
-	kfree(ibft);
-}
-
 /*
  *  Routines for parsing the iBFT data to be human readable.
  */
-static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
-					struct ibft_attribute *attr,
-					char *buf)
+static ssize_t ibft_attr_show_initiator(void *data, int type, char *buf)
 {
+	struct ibft_kobject *entry = data;
 	struct ibft_initiator *initiator = entry->initiator;
 	void *ibft_loc = entry->header;
 	char *str = buf;
@@ -342,26 +251,26 @@ static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
 	if (!initiator)
 		return 0;
 
-	switch (attr->type) {
-	case ibft_init_index:
+	switch (type) {
+	case ISCSI_BOOT_INI_INDEX:
 		str += sprintf(str, "%d\n", initiator->hdr.index);
 		break;
-	case ibft_init_flags:
+	case ISCSI_BOOT_INI_FLAGS:
 		str += sprintf(str, "%d\n", initiator->hdr.flags);
 		break;
-	case ibft_init_isns_server:
+	case ISCSI_BOOT_INI_ISNS_SERVER:
 		str += sprintf_ipaddr(str, initiator->isns_server);
 		break;
-	case ibft_init_slp_server:
+	case ISCSI_BOOT_INI_SLP_SERVER:
 		str += sprintf_ipaddr(str, initiator->slp_server);
 		break;
-	case ibft_init_pri_radius_server:
+	case ISCSI_BOOT_INI_PRI_RADIUS_SERVER:
 		str += sprintf_ipaddr(str, initiator->pri_radius_server);
 		break;
-	case ibft_init_sec_radius_server:
+	case ISCSI_BOOT_INI_SEC_RADIUS_SERVER:
 		str += sprintf_ipaddr(str, initiator->sec_radius_server);
 		break;
-	case ibft_init_initiator_name:
+	case ISCSI_BOOT_INI_INITIATOR_NAME:
 		str += sprintf_string(str, initiator->initiator_name_len,
 				      (char *)ibft_loc +
 				      initiator->initiator_name_off);
@@ -373,10 +282,9 @@ static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
 	return str - buf;
 }
 
-static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
-				  struct ibft_attribute *attr,
-				  char *buf)
+static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
 {
+	struct ibft_kobject *entry = data;
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
 	char *str = buf;
@@ -385,42 +293,42 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	if (!nic)
 		return 0;
 
-	switch (attr->type) {
-	case ibft_eth_index:
+	switch (type) {
+	case ISCSI_BOOT_ETH_INDEX:
 		str += sprintf(str, "%d\n", nic->hdr.index);
 		break;
-	case ibft_eth_flags:
+	case ISCSI_BOOT_ETH_FLAGS:
 		str += sprintf(str, "%d\n", nic->hdr.flags);
 		break;
-	case ibft_eth_ip_addr:
+	case ISCSI_BOOT_ETH_IP_ADDR:
 		str += sprintf_ipaddr(str, nic->ip_addr);
 		break;
-	case ibft_eth_subnet_mask:
+	case ISCSI_BOOT_ETH_SUBNET_MASK:
 		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
 		str += sprintf(str, "%pI4", &val);
 		break;
-	case ibft_eth_origin:
+	case ISCSI_BOOT_ETH_ORIGIN:
 		str += sprintf(str, "%d\n", nic->origin);
 		break;
-	case ibft_eth_gateway:
+	case ISCSI_BOOT_ETH_GATEWAY:
 		str += sprintf_ipaddr(str, nic->gateway);
 		break;
-	case ibft_eth_primary_dns:
+	case ISCSI_BOOT_ETH_PRIMARY_DNS:
 		str += sprintf_ipaddr(str, nic->primary_dns);
 		break;
-	case ibft_eth_secondary_dns:
+	case ISCSI_BOOT_ETH_SECONDARY_DNS:
 		str += sprintf_ipaddr(str, nic->secondary_dns);
 		break;
-	case ibft_eth_dhcp:
+	case ISCSI_BOOT_ETH_DHCP:
 		str += sprintf_ipaddr(str, nic->dhcp);
 		break;
-	case ibft_eth_vlan:
+	case ISCSI_BOOT_ETH_VLAN:
 		str += sprintf(str, "%d\n", nic->vlan);
 		break;
-	case ibft_eth_mac:
+	case ISCSI_BOOT_ETH_MAC:
 		str += sprintf(str, "%pM\n", nic->mac);
 		break;
-	case ibft_eth_hostname:
+	case ISCSI_BOOT_ETH_HOSTNAME:
 		str += sprintf_string(str, nic->hostname_len,
 				      (char *)ibft_loc + nic->hostname_off);
 		break;
@@ -431,10 +339,9 @@ static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	return str - buf;
 };
 
-static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
-				     struct ibft_attribute *attr,
-				     char *buf)
+static ssize_t ibft_attr_show_target(void *data, int type, char *buf)
 {
+	struct ibft_kobject *entry = data;
 	struct ibft_tgt *tgt = entry->tgt;
 	void *ibft_loc = entry->header;
 	char *str = buf;
@@ -443,48 +350,48 @@ static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
 	if (!tgt)
 		return 0;
 
-	switch (attr->type) {
-	case ibft_tgt_index:
+	switch (type) {
+	case ISCSI_BOOT_TGT_INDEX:
 		str += sprintf(str, "%d\n", tgt->hdr.index);
 		break;
-	case ibft_tgt_flags:
+	case ISCSI_BOOT_TGT_FLAGS:
 		str += sprintf(str, "%d\n", tgt->hdr.flags);
 		break;
-	case ibft_tgt_ip_addr:
+	case ISCSI_BOOT_TGT_IP_ADDR:
 		str += sprintf_ipaddr(str, tgt->ip_addr);
 		break;
-	case ibft_tgt_port:
+	case ISCSI_BOOT_TGT_PORT:
 		str += sprintf(str, "%d\n", tgt->port);
 		break;
-	case ibft_tgt_lun:
+	case ISCSI_BOOT_TGT_LUN:
 		for (i = 0; i < 8; i++)
 			str += sprintf(str, "%x", (u8)tgt->lun[i]);
 		str += sprintf(str, "\n");
 		break;
-	case ibft_tgt_nic_assoc:
+	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		str += sprintf(str, "%d\n", tgt->nic_assoc);
 		break;
-	case ibft_tgt_chap_type:
+	case ISCSI_BOOT_TGT_CHAP_TYPE:
 		str += sprintf(str, "%d\n", tgt->chap_type);
 		break;
-	case ibft_tgt_name:
+	case ISCSI_BOOT_TGT_NAME:
 		str += sprintf_string(str, tgt->tgt_name_len,
 				      (char *)ibft_loc + tgt->tgt_name_off);
 		break;
-	case ibft_tgt_chap_name:
+	case ISCSI_BOOT_TGT_CHAP_NAME:
 		str += sprintf_string(str, tgt->chap_name_len,
 				      (char *)ibft_loc + tgt->chap_name_off);
 		break;
-	case ibft_tgt_chap_secret:
+	case ISCSI_BOOT_TGT_CHAP_SECRET:
 		str += sprintf_string(str, tgt->chap_secret_len,
 				      (char *)ibft_loc + tgt->chap_secret_off);
 		break;
-	case ibft_tgt_rev_chap_name:
+	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
 		str += sprintf_string(str, tgt->rev_chap_name_len,
 				      (char *)ibft_loc +
 				      tgt->rev_chap_name_off);
 		break;
-	case ibft_tgt_rev_chap_secret:
+	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
 		str += sprintf_string(str, tgt->rev_chap_secret_len,
 				      (char *)ibft_loc +
 				      tgt->rev_chap_secret_off);
@@ -496,52 +403,19 @@ static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
 	return str - buf;
 }
 
-/*
- * The routine called for all sysfs attributes.
- */
-static ssize_t ibft_show_attribute(struct kobject *kobj,
-				    struct attribute *attr,
-				    char *buf)
-{
-	struct ibft_kobject *dev =
-		container_of(kobj, struct ibft_kobject, kobj);
-	struct ibft_attribute *ibft_attr =
-		container_of(attr, struct ibft_attribute, attr);
-	ssize_t ret = -EIO;
-	char *str = buf;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (ibft_attr->show)
-		ret = ibft_attr->show(dev, ibft_attr, str);
-
-	return ret;
-}
-
-static const struct sysfs_ops ibft_attr_ops = {
-	.show = ibft_show_attribute,
-};
-
-static struct kobj_type ibft_ktype = {
-	.release = ibft_release,
-	.sysfs_ops = &ibft_attr_ops,
-};
-
-static struct kset *ibft_kset;
-
 static int __init ibft_check_device(void)
 {
 	int len;
 	u8 *pos;
 	u8 csum = 0;
 
-	len = ibft_addr->length;
+	len = ibft_addr->header.length;
 
 	/* Sanity checking of iBFT. */
-	if (ibft_addr->revision != 1) {
+	if (ibft_addr->header.revision != 1) {
 		printk(KERN_ERR "iBFT module supports only revision 1, " \
-				"while this is %d.\n", ibft_addr->revision);
+				"while this is %d.\n",
+				ibft_addr->header.revision);
 		return -ENOENT;
 	}
 	for (pos = (u8 *)ibft_addr; pos < (u8 *)ibft_addr + len; pos++)
@@ -556,12 +430,149 @@ static int __init ibft_check_device(void)
 }
 
 /*
+ * Helper routiners to check to determine if the entry is valid
+ * in the proper iBFT structure.
+ */
+static mode_t ibft_check_nic_for(void *data, int type)
+{
+	struct ibft_kobject *entry = data;
+	struct ibft_nic *nic = entry->nic;
+	mode_t rc = 0;
+
+	switch (type) {
+	case ISCSI_BOOT_ETH_INDEX:
+	case ISCSI_BOOT_ETH_FLAGS:
+		rc = 1;
+		break;
+	case ISCSI_BOOT_ETH_IP_ADDR:
+		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_SUBNET_MASK:
+		if (nic->subnet_mask_prefix)
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_ORIGIN:
+		rc = 1;
+		break;
+	case ISCSI_BOOT_ETH_GATEWAY:
+		if (memcmp(nic->gateway, nulls, sizeof(nic->gateway)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_PRIMARY_DNS:
+		if (memcmp(nic->primary_dns, nulls,
+			   sizeof(nic->primary_dns)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_SECONDARY_DNS:
+		if (memcmp(nic->secondary_dns, nulls,
+			   sizeof(nic->secondary_dns)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_DHCP:
+		if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_VLAN:
+	case ISCSI_BOOT_ETH_MAC:
+		rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_ETH_HOSTNAME:
+		if (nic->hostname_off)
+			rc = S_IRUGO;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+static mode_t __init ibft_check_tgt_for(void *data, int type)
+{
+	struct ibft_kobject *entry = data;
+	struct ibft_tgt *tgt = entry->tgt;
+	mode_t rc = 0;
+
+	switch (type) {
+	case ISCSI_BOOT_TGT_INDEX:
+	case ISCSI_BOOT_TGT_FLAGS:
+	case ISCSI_BOOT_TGT_IP_ADDR:
+	case ISCSI_BOOT_TGT_PORT:
+	case ISCSI_BOOT_TGT_LUN:
+	case ISCSI_BOOT_TGT_NIC_ASSOC:
+	case ISCSI_BOOT_TGT_CHAP_TYPE:
+		rc = S_IRUGO;
+	case ISCSI_BOOT_TGT_NAME:
+		if (tgt->tgt_name_len)
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_TGT_CHAP_NAME:
+	case ISCSI_BOOT_TGT_CHAP_SECRET:
+		if (tgt->chap_name_len)
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
+	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
+		if (tgt->rev_chap_name_len)
+			rc = S_IRUGO;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+static mode_t __init ibft_check_initiator_for(void *data, int type)
+{
+	struct ibft_kobject *entry = data;
+	struct ibft_initiator *init = entry->initiator;
+	mode_t rc = 0;
+
+	switch (type) {
+	case ISCSI_BOOT_INI_INDEX:
+	case ISCSI_BOOT_INI_FLAGS:
+		rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_ISNS_SERVER:
+		if (memcmp(init->isns_server, nulls,
+			   sizeof(init->isns_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_SLP_SERVER:
+		if (memcmp(init->slp_server, nulls,
+			   sizeof(init->slp_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_PRI_RADIUS_SERVER:
+		if (memcmp(init->pri_radius_server, nulls,
+			   sizeof(init->pri_radius_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_SEC_RADIUS_SERVER:
+		if (memcmp(init->sec_radius_server, nulls,
+			   sizeof(init->sec_radius_server)))
+			rc = S_IRUGO;
+		break;
+	case ISCSI_BOOT_INI_INITIATOR_NAME:
+		if (init->initiator_name_len)
+			rc = S_IRUGO;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+/*
  * Helper function for ibft_register_kobjects.
  */
-static int __init ibft_create_kobject(struct ibft_table_header *header,
-				       struct ibft_hdr *hdr,
-				       struct list_head *list)
+static int __init ibft_create_kobject(struct acpi_table_ibft *header,
+				      struct ibft_hdr *hdr)
 {
+	struct iscsi_boot_kobj *boot_kobj = NULL;
 	struct ibft_kobject *ibft_kobj = NULL;
 	struct ibft_nic *nic = (struct ibft_nic *)hdr;
 	struct pci_dev *pci_dev;
@@ -578,14 +589,47 @@ static int __init ibft_create_kobject(struct ibft_table_header *header,
 	case id_initiator:
 		rc = ibft_verify_hdr("initiator", hdr, id_initiator,
 				     sizeof(*ibft_kobj->initiator));
+		if (rc)
+			break;
+
+		boot_kobj = iscsi_boot_create_initiator(boot_kset, hdr->index,
+						ibft_kobj,
+						ibft_attr_show_initiator,
+						ibft_check_initiator_for);
+		if (!boot_kobj) {
+			rc = -ENOMEM;
+			goto free_ibft_obj;
+		}
 		break;
 	case id_nic:
 		rc = ibft_verify_hdr("ethernet", hdr, id_nic,
 				     sizeof(*ibft_kobj->nic));
+		if (rc)
+			break;
+
+		boot_kobj = iscsi_boot_create_ethernet(boot_kset, hdr->index,
+						       ibft_kobj,
+						       ibft_attr_show_nic,
+						       ibft_check_nic_for);
+		if (!boot_kobj) {
+			rc = -ENOMEM;
+			goto free_ibft_obj;
+		}
 		break;
 	case id_target:
 		rc = ibft_verify_hdr("target", hdr, id_target,
 				     sizeof(*ibft_kobj->tgt));
+		if (rc)
+			break;
+	
+		boot_kobj = iscsi_boot_create_target(boot_kset, hdr->index,
+						     ibft_kobj,
+						     ibft_attr_show_target,
+						     ibft_check_tgt_for);
+		if (!boot_kobj) {
+			rc = -ENOMEM;
+			goto free_ibft_obj;
+		}
 		break;
 	case id_reserved:
 	case id_control:
@@ -596,29 +640,17 @@ static int __init ibft_create_kobject(struct ibft_table_header *header,
 	default:
 		printk(KERN_ERR "iBFT has unknown structure type (%d). " \
 				"Report this bug to %.6s!\n", hdr->id,
-				header->oem_id);
+				header->header.oem_id);
 		rc = 1;
 		break;
 	}
 
 	if (rc) {
 		/* Skip adding this kobject, but exit with non-fatal error. */
-		kfree(ibft_kobj);
-		goto out_invalid_struct;
+		rc = 0;
+		goto free_ibft_obj;
 	}
 
-	ibft_kobj->kobj.kset = ibft_kset;
-
-	rc = kobject_init_and_add(&ibft_kobj->kobj, &ibft_ktype,
-				  NULL, ibft_id_names[hdr->id], hdr->index);
-
-	if (rc) {
-		kfree(ibft_kobj);
-		goto out;
-	}
-
-	kobject_uevent(&ibft_kobj->kobj, KOBJ_ADD);
-
 	if (hdr->id == id_nic) {
 		/*
 		* We don't search for the device in other domains than
@@ -629,19 +661,16 @@ static int __init ibft_create_kobject(struct ibft_table_header *header,
 		pci_dev = pci_get_bus_and_slot((nic->pci_bdf & 0xff00) >> 8,
 					       (nic->pci_bdf & 0xff));
 		if (pci_dev) {
-			rc = sysfs_create_link(&ibft_kobj->kobj,
+			rc = sysfs_create_link(&boot_kobj->kobj,
 					       &pci_dev->dev.kobj, "device");
 			pci_dev_put(pci_dev);
 		}
 	}
+	return 0;
 
-	/* Nothing broke so lets add it to the list. */
-	list_add_tail(&ibft_kobj->node, list);
-out:
+free_ibft_obj:
+	kfree(ibft_kobj);
 	return rc;
-out_invalid_struct:
-	/* Unsupported structs are skipped. */
-	return 0;
 }
 
 /*
@@ -649,8 +678,7 @@ out_invalid_struct:
  * found add them on the passed-in list. We do not support the other
  * fields at this point, so they are skipped.
  */
-static int __init ibft_register_kobjects(struct ibft_table_header *header,
-					  struct list_head *list)
+static int __init ibft_register_kobjects(struct acpi_table_ibft *header)
 {
 	struct ibft_control *control = NULL;
 	void *ptr, *end;
@@ -660,7 +688,7 @@ static int __init ibft_register_kobjects(struct ibft_table_header *header,
 
 	control = (void *)header + sizeof(*header);
 	end = (void *)control + control->hdr.length;
-	eot_offset = (void *)header + header->length - (void *)control;
+	eot_offset = (void *)header + header->header.length - (void *)control;
 	rc = ibft_verify_hdr("control", (struct ibft_hdr *)control, id_control,
 			     sizeof(*control));
 
@@ -672,10 +700,10 @@ static int __init ibft_register_kobjects(struct ibft_table_header *header,
 	}
 	for (ptr = &control->initiator_off; ptr < end; ptr += sizeof(u16)) {
 		offset = *(u16 *)ptr;
-		if (offset && offset < header->length && offset < eot_offset) {
+		if (offset && offset < header->header.length &&
+						offset < eot_offset) {
 			rc = ibft_create_kobject(header,
-						 (void *)header + offset,
-						 list);
+						 (void *)header + offset);
 			if (rc)
 				break;
 		}
@@ -684,240 +712,28 @@ static int __init ibft_register_kobjects(struct ibft_table_header *header,
 	return rc;
 }
 
-static void ibft_unregister(struct list_head *attr_list,
-			     struct list_head *kobj_list)
+static void ibft_unregister(void)
 {
-	struct ibft_kobject *data = NULL, *n;
-	struct ibft_attribute *attr = NULL, *m;
-
-	list_for_each_entry_safe(attr, m, attr_list, node) {
-		sysfs_remove_file(attr->kobj, &attr->attr);
-		list_del(&attr->node);
-		kfree(attr);
-	};
-	list_del_init(attr_list);
-
-	list_for_each_entry_safe(data, n, kobj_list, node) {
-		list_del(&data->node);
-		if (data->hdr->id == id_nic)
-			sysfs_remove_link(&data->kobj, "device");
-		kobject_put(&data->kobj);
+	struct iscsi_boot_kobj *boot_kobj, *tmp_kobj;
+	struct ibft_kobject *ibft_kobj;
+
+	list_for_each_entry_safe(boot_kobj, tmp_kobj,
+				 &boot_kset->kobj_list, list) {
+		ibft_kobj = boot_kobj->data;
+		if (ibft_kobj->hdr->id == id_nic)
+			sysfs_remove_link(&boot_kobj->kobj, "device");
 	};
-	list_del_init(kobj_list);
-}
-
-static int __init ibft_create_attribute(struct ibft_kobject *kobj_data,
-					 int type,
-					 const char *name,
-					 ssize_t (*show)(struct ibft_kobject *,
-							 struct ibft_attribute*,
-							 char *buf),
-					 struct list_head *list)
-{
-	struct ibft_attribute *attr = NULL;
-	struct ibft_hdr *hdr = kobj_data->hdr;
-
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
-	attr->attr.name = name;
-	attr->attr.mode = S_IRUSR;
-
-	attr->hdr = hdr;
-	attr->show = show;
-	attr->kobj = &kobj_data->kobj;
-	attr->type = type;
-
-	list_add_tail(&attr->node, list);
-
-	return 0;
-}
-
-/*
- * Helper routiners to check to determine if the entry is valid
- * in the proper iBFT structure.
- */
-static int __init ibft_check_nic_for(struct ibft_nic *nic, int entry)
-{
-	int rc = 0;
-
-	switch (entry) {
-	case ibft_eth_index:
-	case ibft_eth_flags:
-		rc = 1;
-		break;
-	case ibft_eth_ip_addr:
-		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
-			rc = 1;
-		break;
-	case ibft_eth_subnet_mask:
-		if (nic->subnet_mask_prefix)
-			rc = 1;
-		break;
-	case ibft_eth_origin:
-		rc = 1;
-		break;
-	case ibft_eth_gateway:
-		if (memcmp(nic->gateway, nulls, sizeof(nic->gateway)))
-			rc = 1;
-		break;
-	case ibft_eth_primary_dns:
-		if (memcmp(nic->primary_dns, nulls,
-			   sizeof(nic->primary_dns)))
-			rc = 1;
-		break;
-	case ibft_eth_secondary_dns:
-		if (memcmp(nic->secondary_dns, nulls,
-			   sizeof(nic->secondary_dns)))
-			rc = 1;
-		break;
-	case ibft_eth_dhcp:
-		if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
-			rc = 1;
-		break;
-	case ibft_eth_vlan:
-	case ibft_eth_mac:
-		rc = 1;
-		break;
-	case ibft_eth_hostname:
-		if (nic->hostname_off)
-			rc = 1;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
-}
-
-static int __init ibft_check_tgt_for(struct ibft_tgt *tgt, int entry)
-{
-	int rc = 0;
-
-	switch (entry) {
-	case ibft_tgt_index:
-	case ibft_tgt_flags:
-	case ibft_tgt_ip_addr:
-	case ibft_tgt_port:
-	case ibft_tgt_lun:
-	case ibft_tgt_nic_assoc:
-	case ibft_tgt_chap_type:
-		rc = 1;
-	case ibft_tgt_name:
-		if (tgt->tgt_name_len)
-			rc = 1;
-		break;
-	case ibft_tgt_chap_name:
-	case ibft_tgt_chap_secret:
-		if (tgt->chap_name_len)
-			rc = 1;
-		break;
-	case ibft_tgt_rev_chap_name:
-	case ibft_tgt_rev_chap_secret:
-		if (tgt->rev_chap_name_len)
-			rc = 1;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
 }
 
-static int __init ibft_check_initiator_for(struct ibft_initiator *init,
-					    int entry)
+static void ibft_cleanup(void)
 {
-	int rc = 0;
-
-	switch (entry) {
-	case ibft_init_index:
-	case ibft_init_flags:
-		rc = 1;
-		break;
-	case ibft_init_isns_server:
-		if (memcmp(init->isns_server, nulls,
-			   sizeof(init->isns_server)))
-			rc = 1;
-		break;
-	case ibft_init_slp_server:
-		if (memcmp(init->slp_server, nulls,
-			   sizeof(init->slp_server)))
-			rc = 1;
-		break;
-	case ibft_init_pri_radius_server:
-		if (memcmp(init->pri_radius_server, nulls,
-			   sizeof(init->pri_radius_server)))
-			rc = 1;
-		break;
-	case ibft_init_sec_radius_server:
-		if (memcmp(init->sec_radius_server, nulls,
-			   sizeof(init->sec_radius_server)))
-			rc = 1;
-		break;
-	case ibft_init_initiator_name:
-		if (init->initiator_name_len)
-			rc = 1;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
+	ibft_unregister();
+	iscsi_boot_destroy_kset(boot_kset);
 }
 
-/*
- *  Register the attributes for all of the kobjects.
- */
-static int __init ibft_register_attributes(struct list_head *kobject_list,
-					    struct list_head *attr_list)
+static void __exit ibft_exit(void)
 {
-	int rc = 0, i = 0;
-	struct ibft_kobject *data = NULL;
-	struct ibft_attribute *attr = NULL, *m;
-
-	list_for_each_entry(data, kobject_list, node) {
-		switch (data->hdr->id) {
-		case id_nic:
-			for (i = 0; i < ibft_eth_end_marker && !rc; i++)
-				if (ibft_check_nic_for(data->nic, i))
-					rc = ibft_create_attribute(data, i,
-						ibft_eth_properties[i],
-						ibft_attr_show_nic, attr_list);
-			break;
-		case id_target:
-			for (i = 0; i < ibft_tgt_end_marker && !rc; i++)
-				if (ibft_check_tgt_for(data->tgt, i))
-					rc = ibft_create_attribute(data, i,
-						ibft_tgt_properties[i],
-						ibft_attr_show_target,
-						attr_list);
-			break;
-		case id_initiator:
-			for (i = 0; i < ibft_init_end_marker && !rc; i++)
-				if (ibft_check_initiator_for(
-					data->initiator, i))
-					rc = ibft_create_attribute(data, i,
-						ibft_initiator_properties[i],
-						ibft_attr_show_initiator,
-						attr_list);
-			break;
-		default:
-			break;
-		}
-		if (rc)
-			break;
-	}
-	list_for_each_entry_safe(attr, m, attr_list, node) {
-		rc = sysfs_create_file(attr->kobj, &attr->attr);
-		if (rc) {
-			list_del(&attr->node);
-			kfree(attr);
-			break;
-		}
-	}
-
-	return rc;
+	ibft_cleanup();
 }
 
 /*
@@ -927,26 +743,20 @@ static int __init ibft_init(void)
 {
 	int rc = 0;
 
-	ibft_kset = kset_create_and_add("ibft", NULL, firmware_kobj);
-	if (!ibft_kset)
-		return -ENOMEM;
-
 	if (ibft_addr) {
 		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
 		       (u64)isa_virt_to_bus(ibft_addr));
 
 		rc = ibft_check_device();
 		if (rc)
-			goto out_firmware_unregister;
+			return rc;
 
-		/* Scan the IBFT for data and register the kobjects. */
-		rc = ibft_register_kobjects(ibft_addr, &ibft_kobject_list);
-		if (rc)
-			goto out_free;
+		boot_kset = iscsi_boot_create_kset("ibft");
+		if (!boot_kset)
+			return -ENOMEM;
 
-		/* Register the attributes */
-		rc = ibft_register_attributes(&ibft_kobject_list,
-					      &ibft_attr_list);
+		/* Scan the IBFT for data and register the kobjects. */
+		rc = ibft_register_kobjects(ibft_addr);
 		if (rc)
 			goto out_free;
 	} else
@@ -955,17 +765,9 @@ static int __init ibft_init(void)
 	return 0;
 
 out_free:
-	ibft_unregister(&ibft_attr_list, &ibft_kobject_list);
-out_firmware_unregister:
-	kset_unregister(ibft_kset);
+	ibft_cleanup();
 	return rc;
 }
 
-static void __exit ibft_exit(void)
-{
-	ibft_unregister(&ibft_attr_list, &ibft_kobject_list);
-	kset_unregister(ibft_kset);
-}
-
 module_init(ibft_init);
 module_exit(ibft_exit);
diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index d6470ef..0bc3fae 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright 2007 Red Hat, Inc.
+ *  Copyright 2007-2010 Red Hat, Inc.
  *  by Peter Jones <pjones@redhat.com>
  *  Copyright 2007 IBM, Inc.
  *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
+#include <linux/efi.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/limits.h>
@@ -30,13 +31,14 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 
 #include <asm/mmzone.h>
 
 /*
  * Physical location of iSCSI Boot Format Table.
  */
-struct ibft_table_header *ibft_addr;
+struct acpi_table_ibft *ibft_addr;
 EXPORT_SYMBOL_GPL(ibft_addr);
 
 #define IBFT_SIGN "iBFT"
@@ -46,19 +48,20 @@ EXPORT_SYMBOL_GPL(ibft_addr);
 #define VGA_MEM 0xA0000 /* VGA buffer */
 #define VGA_SIZE 0x20000 /* 128kB */
 
+#ifdef CONFIG_ACPI
+static int __init acpi_find_ibft(struct acpi_table_header *header)
+{
+	ibft_addr = (struct acpi_table_ibft *)header;
+	return 0;
+}
+#endif /* CONFIG_ACPI */
 
-/*
- * Routine used to find the iSCSI Boot Format Table. The logical
- * kernel address is set in the ibft_addr global variable.
- */
-unsigned long __init find_ibft_region(unsigned long *sizep)
+static int __init find_ibft_mem_scan(void)
 {
 	unsigned long pos;
 	unsigned int len = 0;
 	void *virt;
 
-	ibft_addr = NULL;
-
 	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
 		/* The table can't be inside the VGA BIOS reserved space,
 		 * so skip that area */
@@ -72,14 +75,42 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 			/* if the length of the table extends past 1M,
 			 * the table cannot be valid. */
 			if (pos + len <= (IBFT_END-1)) {
-				ibft_addr = (struct ibft_table_header *)virt;
+				ibft_addr = (struct acpi_table_ibft *)virt;
 				break;
 			}
 		}
 	}
+	return len;
+}
+/*
+ * Routine used to find the iSCSI Boot Format Table. The logical
+ * kernel address is set in the ibft_addr global variable.
+ */
+unsigned long __init find_ibft_region(unsigned long *sizep)
+{
+
+	ibft_addr = NULL;
+
+#ifdef CONFIG_ACPI
+	/*
+	 * One spec says "IBFT", the other says "iBFT". We have to check
+	 * for both.
+	 */
+	if (!ibft_addr)
+		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
+	if (!ibft_addr)
+		acpi_table_parse("iBFT", acpi_find_ibft);
+#endif /* CONFIG_ACPI */
+
+	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
+	 * only use ACPI for this */
+
+	if (!ibft_addr && !efi_enabled)
+		find_ibft_mem_scan();
+
 	if (ibft_addr) {
-		*sizep = PAGE_ALIGN(len);
-		return pos;
+		*sizep = PAGE_ALIGN(ibft_addr->header.length);
+		return (u64)isa_virt_to_bus(ibft_addr);
 	}
 
 	*sizep = 0;
diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
new file mode 100644
index 0000000..f1e6c18
--- /dev/null
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -0,0 +1,123 @@
+/*
+ * Export the iSCSI boot info to userland via sysfs.
+ *
+ * Copyright (C) 2010 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2010 Mike Christie
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _ISCSI_BOOT_SYSFS_
+#define _ISCSI_BOOT_SYSFS_
+
+/*
+ * The text attributes names for each of the kobjects.
+*/
+enum iscsi_boot_eth_properties_enum {
+	ISCSI_BOOT_ETH_INDEX,
+	ISCSI_BOOT_ETH_FLAGS,
+	ISCSI_BOOT_ETH_IP_ADDR,
+	ISCSI_BOOT_ETH_SUBNET_MASK,
+	ISCSI_BOOT_ETH_ORIGIN,
+	ISCSI_BOOT_ETH_GATEWAY,
+	ISCSI_BOOT_ETH_PRIMARY_DNS,
+	ISCSI_BOOT_ETH_SECONDARY_DNS,
+	ISCSI_BOOT_ETH_DHCP,
+	ISCSI_BOOT_ETH_VLAN,
+	ISCSI_BOOT_ETH_MAC,
+	/* eth_pci_bdf - this is replaced by link to the device itself. */
+	ISCSI_BOOT_ETH_HOSTNAME,
+	ISCSI_BOOT_ETH_END_MARKER,
+};
+
+enum iscsi_boot_tgt_properties_enum {
+	ISCSI_BOOT_TGT_INDEX,
+	ISCSI_BOOT_TGT_FLAGS,
+	ISCSI_BOOT_TGT_IP_ADDR,
+	ISCSI_BOOT_TGT_PORT,
+	ISCSI_BOOT_TGT_LUN,
+	ISCSI_BOOT_TGT_CHAP_TYPE,
+	ISCSI_BOOT_TGT_NIC_ASSOC,
+	ISCSI_BOOT_TGT_NAME,
+	ISCSI_BOOT_TGT_CHAP_NAME,
+	ISCSI_BOOT_TGT_CHAP_SECRET,
+	ISCSI_BOOT_TGT_REV_CHAP_NAME,
+	ISCSI_BOOT_TGT_REV_CHAP_SECRET,
+	ISCSI_BOOT_TGT_END_MARKER,
+};
+
+enum iscsi_boot_initiator_properties_enum {
+	ISCSI_BOOT_INI_INDEX,
+	ISCSI_BOOT_INI_FLAGS,
+	ISCSI_BOOT_INI_ISNS_SERVER,
+	ISCSI_BOOT_INI_SLP_SERVER,
+	ISCSI_BOOT_INI_PRI_RADIUS_SERVER,
+	ISCSI_BOOT_INI_SEC_RADIUS_SERVER,
+	ISCSI_BOOT_INI_INITIATOR_NAME,
+	ISCSI_BOOT_INI_END_MARKER,
+};
+
+struct attribute_group;
+
+struct iscsi_boot_kobj {
+	struct kobject kobj;
+	struct attribute_group *attr_group;
+	struct list_head list;
+
+	/*
+	 * Pointer to store driver specific info. If set this will
+	 * be freed for the LLD when the kobj release function is called.
+	 */
+	void *data;
+	/*
+	 * Driver specific show function.
+	 *
+	 * The enum of the type. This can be any value of the above
+	 * properties.
+	 */
+	ssize_t (*show) (void *data, int type, char *buf);
+
+	/*
+	 * Drivers specific visibility function.
+	 * The function should return if they the attr should be readable
+	 * writable or should not be shown.
+	 *
+	 * The enum of the type. This can be any value of the above
+	 * properties.
+	 */
+	mode_t (*is_visible) (void *data, int type);
+};
+
+struct iscsi_boot_kset {
+	struct list_head kobj_list;
+	struct kset *kset;
+};
+
+struct iscsi_boot_kobj *
+iscsi_boot_create_initiator(struct iscsi_boot_kset *boot_kset, int index,
+			    void *data,
+			    ssize_t (*show) (void *data, int type, char *buf),
+			    mode_t (*is_visible) (void *data, int type));
+
+struct iscsi_boot_kobj *
+iscsi_boot_create_ethernet(struct iscsi_boot_kset *boot_kset, int index,
+			   void *data,
+			   ssize_t (*show) (void *data, int type, char *buf),
+			   mode_t (*is_visible) (void *data, int type));
+struct iscsi_boot_kobj *
+iscsi_boot_create_target(struct iscsi_boot_kset *boot_kset, int index,
+			 void *data,
+			 ssize_t (*show) (void *data, int type, char *buf),
+			 mode_t (*is_visible) (void *data, int type));
+
+struct iscsi_boot_kset *iscsi_boot_create_kset(const char *set_name);
+struct iscsi_boot_kset *iscsi_boot_create_host_kset(unsigned int hostno);
+void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset);
+
+#endif
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
index d2e4042..8ba7e5b 100644
--- a/include/linux/iscsi_ibft.h
+++ b/include/linux/iscsi_ibft.h
@@ -21,21 +21,13 @@
 #ifndef ISCSI_IBFT_H
 #define ISCSI_IBFT_H
 
-struct ibft_table_header {
-	char signature[4];
-	u32 length;
-	u8 revision;
-	u8 checksum;
-	char oem_id[6];
-	char oem_table_id[8];
-	char reserved[24];
-} __attribute__((__packed__));
+#include <acpi/acpi.h>
 
 /*
  * Logical location of iSCSI Boot Format Table.
  * If the value is NULL there is no iBFT on the machine.
  */
-extern struct ibft_table_header *ibft_addr;
+extern struct acpi_table_ibft *ibft_addr;
 
 /*
  * Routine used to find and reserve the iSCSI Boot Format Table. The
-- 
1.6.5.2

