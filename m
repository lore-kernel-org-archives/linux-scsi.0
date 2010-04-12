From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] RFC: iscsi ibft: separate ibft parsing from sysfs interface
Date: Mon, 12 Apr 2010 13:06:17 -0500
Message-ID: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0DLSH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2010 14:07:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, konrad@darnok.org, pjones@redhat.com, open-iscsi@googlegroups.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Not all iscsi drivers support ibft. For drivers like be2iscsi
that do not but are bootable through a vendor firmware specific
format/process this patch moves the sysfs interface from the ibft code
to a lib module. This then allows userspace tools to search for iscsi boot
info in a common place and in a common format.

ibft iscsi boot info is exported in the same place as it was
before: /sys/firmware/ibft.

vendor/fw boot info gets export in /sys/firmware/iscsi_bootX, where X is the
scsi host number of the HBA. Underneath these parent dirs, the
target, ethernet, and initiator dirs are the same as they were before.

This patch was made over the ibft-2.6 tree's ibft-1.03 branch:
http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=shortlog;h=refs/heads/ibft-1.03


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/firmware/Kconfig            |    8 +
 drivers/firmware/Makefile           |    1 +
 drivers/firmware/iscsi_boot_sysfs.c |  481 +++++++++++++++++++++++++++++++++++
 include/linux/iscsi_boot_sysfs.h    |  123 +++++++++
 4 files changed, 613 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/iscsi_boot_sysfs.c
 create mode 100644 include/linux/iscsi_boot_sysfs.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 1b03ba1..571d218 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -122,6 +122,14 @@ config ISCSI_IBFT_FIND
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
 	depends on ISCSI_IBFT_FIND
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
index 0000000..df6bff7
--- /dev/null
+++ b/drivers/firmware/iscsi_boot_sysfs.c
@@ -0,0 +1,481 @@
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
+ * @data: driver specific data for target
+ * @show: attr show function
+ * @is_visible: attr visibility function
+ *
+ * Note: The boot sysfs lib will free the data passed in for the caller
+ * when all refs to the target kobject have been released.
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
+ *
+ * Note: The boot sysfs lib will free the data passed in for the caller
+ * when all refs to the initiator kobject have been released.
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
+ *
+ * Note: The boot sysfs lib will free the data passed in for the caller
+ * when all refs to the ethernet kobject have been released.
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
-- 
1.6.6.1

