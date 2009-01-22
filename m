From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [Target_Core_Mod/ConfigFS] Add
	target/core/$HBA/$STORAGE_OBJECT/pr for T10 reservations
Date: Thu, 22 Jan 2009 00:25:23 -0800
Message-ID: <1232612723.1274.535.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:25318 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752335AbZAVIZr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 03:25:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>

>From 18ebd433d4123895fca5272f7da81decd78fc3ae Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 21 Jan 2009 23:59:24 -0800
Subject: [PATCH 4/4] [Target_Core_Mod/ConfigFS] Add target/core/$HBA/$STORAGE_OBJECT/pr for T10 reservations

This patch adds se_device_t->se_dev_pr_group of type struct config_group and
target_core_dev_pr_cit of type struct config_item_type in target_core_configfs.c.
The new ConfigFS group is located at target/core/$HBA/$STORAGE_OBJECT/pr.
Here are the attributes for registered storage for $STORAGE_OBJECTS from
Target_Core_Mod/IBLOCK, Target_Core_Mod/PSCSI and Target_Core_Mod/RAMDISK
subsystem plugins respectively:

`-- target
    |-- core
    |   |-- iblock_0
    |   |   |-- hba_info
    |   |   `-- lvm_test0
	<SNIP>
    |   |       |-- pr
    |   |       |   |-- res_active
    |   |       |   `-- res_type
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial
    |   |-- pscsi_0
    |   |   |-- hba_info
    |   |   `-- sdd
	<SNIP>
    |   |       |-- pr
    |   |       |   |-- res_active
    |   |       |   `-- res_type
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial
    |   `-- rd_mcp_0
    |       |-- hba_info
    |       `-- ramdisk
	<SNIP>
    |           |-- pr
    |           |   |-- res_active
    |           |   `-- res_type
    |           `-- wwn
    |               |-- evpd_assoc_logical_unit
    |               |-- evpd_assoc_scsi_target_device
    |               |-- evpd_assoc_target_port
    |               |-- evpd_protocol_identifier
    |               `-- evpd_unit_serial

These attributes are defined as READ-ONLY, here is what their output currently
looks like:

target:/sys/kernel/config/target/core# cat iblock_0/lvm_test0/pr/*
FABRIC[iSCSI]: Initiator: iqn.1996-04.de.suse:01:1661f9ee7b5
SPC2_RESERVATIONS

target:/sys/kernel/config/target/core# cat pscsi_0/sdd/pr/*
None
SPC_PASSTHROUGH

target:/sys/kernel/config/target/core# cat rd_mcp_0/ramdisk/pr/*
None
SPC2_RESERVATIONS

This is a WIP and will be changing as >= SPC-3 compliant persistent reservations
are added to target_core_pr.c for Target_Core_Mod/ConfigFS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h     |    1 +
 drivers/lio-core/target_core_configfs.c |  137 ++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 8902128..99d2373 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -557,6 +557,7 @@ typedef struct se_subsystem_dev_s {
         spinlock_t      se_dev_lock;
         void            *se_dev_su_ptr;
         struct config_group se_dev_group;
+	struct config_group se_dev_pr_group;	/* For T10 Reservations */
 } ____cacheline_aligned se_subsystem_dev_t;
 
 #define T10_RES(su_dev)		(&(su_dev)->t10_reservation)
diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 04c23b6..5b1d275 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -3,7 +3,7 @@
  *
  * This file contains ConfigFS logic for the Generic Target Engine project.
  *
- * Copyright (c) 2008  Nicholas A. Bellinger <nab@linux-iscsi.org>
+ * Copyright (c) 2008, 2009  Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
  * based on configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
@@ -709,6 +709,131 @@ static struct config_item_type target_core_dev_wwn_cit = {
 
 //  End functions for struct config_item_type target_core_dev_wwn_cit
 
+//  Start functions for struct config_item_type target_core_dev_pr_cit
+
+CONFIGFS_EATTR_STRUCT(target_core_dev_pr, se_subsystem_dev_s);
+#define SE_DEV_PR_ATTR(_name, _mode)						\
+static struct target_core_dev_pr_attribute target_core_dev_pr_##_name = 	\
+	__CONFIGFS_EATTR(_name, _mode,						\
+	target_core_dev_wwn_show_attr_##_name,					\
+	target_core_dev_wwn_store_attr_##_name);
+
+#define SE_DEV_PR_ATTR_RO(_name);						\
+static struct target_core_dev_pr_attribute target_core_dev_pr_##_name =		\
+	__CONFIGFS_EATTR_RO(_name,						\
+	target_core_dev_pr_show_attr_##_name);					\
+
+/*
+ * res_active
+ */
+static ssize_t target_core_dev_pr_show_spc3_res (
+	struct se_device_s *dev,
+	char *page,
+	ssize_t *len)
+{
+	*len += sprintf(page+*len, "Not Implemented yet\n");
+	return(*len);
+}
+
+static ssize_t target_core_dev_pr_show_spc2_res (
+        struct se_device_s *dev,
+        char *page,
+	ssize_t *len)
+{
+	se_node_acl_t *se_nacl;
+
+	spin_lock(&dev->dev_reservation_lock);
+	if (!(se_nacl = dev->dev_reserved_node_acl)) {
+		*len += sprintf(page+*len, "None\n");
+		spin_unlock(&dev->dev_reservation_lock);
+		return(*len);
+	}
+	*len += sprintf(page+*len, "FABRIC[%s]: Initiator: %s\n",
+		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
+		se_nacl->initiatorname);
+	spin_unlock(&dev->dev_reservation_lock);
+
+	return(*len);
+}
+
+static ssize_t target_core_dev_pr_show_attr_res_active (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	ssize_t len = 0;
+
+	switch (T10_RES(su_dev)->res_type) {
+	case SPC3_PERSISTENT_RESERVATIONS:
+		target_core_dev_pr_show_spc3_res(su_dev->se_dev_ptr,
+				page, &len);
+		break;
+	case SPC2_RESERVATIONS:
+		target_core_dev_pr_show_spc2_res(su_dev->se_dev_ptr,
+				page, &len);
+		break;
+	case SPC_PASSTHROUGH:
+		len += sprintf(page+len, "None\n");
+		break;
+	default:
+		len += sprintf(page+len, "Unknown\n");
+		break;
+	}
+
+	return(len);
+}
+
+SE_DEV_PR_ATTR_RO(res_active);
+
+/*
+ * res_type
+ */
+static ssize_t target_core_dev_pr_show_attr_res_type (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	ssize_t len = 0;
+	
+	switch (T10_RES(su_dev)->res_type) {
+	case SPC3_PERSISTENT_RESERVATIONS:
+		len = sprintf(page, "SPC3_PERSISTENT_RESERVATIONS\n");
+		break;
+	case SPC2_RESERVATIONS:
+		len = sprintf(page, "SPC2_RESERVATIONS\n");
+		break;
+	case SPC_PASSTHROUGH:
+		len = sprintf(page, "SPC_PASSTHROUGH\n");
+		break;
+	default:
+		len = sprintf(page, "UNKNOWN\n");
+		break;
+	}
+
+	return(len);
+}
+
+SE_DEV_PR_ATTR_RO(res_type);
+
+CONFIGFS_EATTR_OPS(target_core_dev_pr, se_subsystem_dev_s, se_dev_pr_group);
+
+static struct configfs_attribute *target_core_dev_pr_attrs[] = {
+	&target_core_dev_pr_res_active.attr,
+	&target_core_dev_pr_res_type.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_core_dev_pr_ops = {
+	.show_attribute		= target_core_dev_pr_attr_show,
+	.store_attribute	= target_core_dev_pr_attr_store,
+};
+
+static struct config_item_type target_core_dev_pr_cit = {
+	.ct_item_ops		= &target_core_dev_pr_ops,
+	.ct_attrs		= target_core_dev_pr_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+//  End functions for struct config_item_type target_core_dev_pr_cit
+
 //  Start functions for struct config_item_type target_core_dev_cit
 
 static ssize_t target_core_show_dev_info (void *p, char *page)
@@ -956,7 +1081,7 @@ static struct config_group *target_core_call_createdev (
 	se_dev->se_dev_hba = hba;
 	dev_cg = &se_dev->se_dev_group;
 
-	if (!(dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 3,
+	if (!(dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 4,
 			GFP_KERNEL)))
 		goto out;
 
@@ -973,11 +1098,14 @@ static struct config_group *target_core_call_createdev (
 			&target_core_dev_cit);
 	config_group_init_type_name(&se_dev->se_dev_attrib.da_group, "attrib",
 			&target_core_dev_attrib_cit);
+	config_group_init_type_name(&se_dev->se_dev_pr_group, "pr",
+			&target_core_dev_pr_cit);
 	config_group_init_type_name(&se_dev->t10_wwn.t10_wwn_group, "wwn",
 			&target_core_dev_wwn_cit);
 	dev_cg->default_groups[0] = &se_dev->se_dev_attrib.da_group;
-	dev_cg->default_groups[1] = &se_dev->t10_wwn.t10_wwn_group;
-	dev_cg->default_groups[2] = NULL;
+	dev_cg->default_groups[1] = &se_dev->se_dev_pr_group;
+	dev_cg->default_groups[2] = &se_dev->t10_wwn.t10_wwn_group;
+	dev_cg->default_groups[3] = NULL;
 
 	printk("Target_Core_ConfigFS: Allocated se_subsystem_dev_t: %p se_dev_su_ptr: %p\n",
 			se_dev, se_dev->se_dev_su_ptr);
@@ -1294,6 +1422,7 @@ extern void target_core_exit_configfs (void)
 	return;
 }
 
+MODULE_DESCRIPTION("Target_Core_Mod/ConfigFS");
 MODULE_AUTHOR("nab@Linux-iSCSI.org");
 MODULE_LICENSE("GPL");
 
-- 
1.5.4.1



