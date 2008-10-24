From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Added storage object attributes
Date: Fri, 24 Oct 2008 13:04:42 -0700
Message-ID: <1224878682.16558.55.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:38753 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752562AbYJXUEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 16:04:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Hannes Reinecke <hare@suse.de>

>From 6f57b78ab1fca92d1fc85b6b82c15b12fccf256a Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 24 Oct 2008 01:12:25 -0700
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Added storage object attributes

Added storage object attributes that live under:

/sys/kernel/config/target/core/$PLUGIN_HBA/$STORAGE_OBJECT/attrib/

here is what they look like:

`-- target
    |-- core
    |   |-- iblock_0
    |   |   |-- hba_info
    |   |   `-- lvm_test0
    |   |       |-- attrib
    |   |       |   |-- hw_max_sectors
    |   |       |   |-- hw_queue_depth
    |   |       |   |-- max_sectors
    |   |       |   |-- queue_depth
    |   |       |   |-- status_thread
    |   |       |   |-- status_thread_tur
    |   |       |   `-- task_timeout
    |   |       |-- control
    |   |       |-- enable
    |   |       |-- fd
    |   |       `-- info
    |   |-- pscsi_0
    |   |   |-- hba_info
    |   |   `-- sdd
    |   |       |-- attrib
    |   |       |   |-- hw_max_sectors
    |   |       |   |-- hw_queue_depth
    |   |       |   |-- max_sectors
    |   |       |   |-- queue_depth
    |   |       |   |-- status_thread
    |   |       |   |-- status_thread_tur
    |   |       |   `-- task_timeout
    |   |       |-- control
    |   |       |-- enable
    |   |       |-- fd
    |   |       `-- info

These are the equivalent functionality of the IOCTL op:

target-ctl setdevattrib <storage object parameters>

Just as with 'setdevattrib', some of the cannot be changed while
$STORAGE_OBJECT has an active export to $FABRIC_MOD.

*queue_depth and *max_sectors  are determined by target_core_mod's subsystem
plugins (Linux/SCSI, Linux/IBLOCK, Linux/FILEIO), and in some cases
with a real backing struct block_device, are subject to *REAL* hardware and HBA
limitiations.

Also, updated target_core_store_dev_enable() to use new
se_subsystem_api_t->create_virtdevice() function parameters.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |  135 ++++++++++++++++++++++++++++++-
 1 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 264dcdb..a5792e3 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -39,13 +39,13 @@
 #include <iscsi_protocol.h>
 #include <iscsi_debug_opcodes.h>
 #include <iscsi_target_core.h>
+#include <target_core_base.h>
 #include <iscsi_target_error.h>
 #include <iscsi_target_ioctl.h>
 #include <iscsi_target_ioctl_defs.h>
 #include <target_core_device.h>
 #include <iscsi_target_device.h>
 #include <target_core_hba.h>
-#include <iscsi_target_info.h>
 #include <target_core_plugin.h>
 #include <target_core_transport.h>
 #include <iscsi_target.h>
@@ -57,6 +57,7 @@
 
 #include <target_core_fabric_ops.h>
 #include <target_core_configfs.h>
+#include <configfs_macros.h>
 
 extern se_global_t *se_global;
 
@@ -516,6 +517,118 @@ EXPORT_SYMBOL(target_fabric_configfs_deregister);
 // Stop functions called by external Target Fabrics Modules
 //##############################################################################
 
+// Start functions for struct config_item_type target_core_dev_attrib_cit
+
+#define DEF_DEV_ATTRIB_SHOW(_name)						\
+static ssize_t target_core_dev_show_attr_##_name (				\
+	struct se_dev_attrib_s *da,						\
+	char *page)								\
+{										\
+	se_device_t *dev;							\
+	se_subsystem_dev_t *se_dev = da->da_sub_dev;				\
+	ssize_t rb;								\
+										\
+	spin_lock(&se_dev->se_dev_lock);					\
+	if (!(dev = se_dev->se_dev_ptr)) {					\
+		spin_unlock(&se_dev->se_dev_lock); 				\
+		return(-ENODEV);						\
+	}									\
+	rb = snprintf(page, PAGE_SIZE, "%u\n", (u32)DEV_ATTRIB(dev)->_name);	\
+	spin_unlock(&se_dev->se_dev_lock);					\
+										\
+	return(rb);								\
+}									
+
+#define DEF_DEV_ATTRIB_STORE(_name)						\
+static ssize_t target_core_dev_store_attr_##_name (				\
+	struct se_dev_attrib_s *da,						\
+	const char *page,							\
+	size_t count)								\
+{										\
+	se_device_t *dev;							\
+	se_subsystem_dev_t *se_dev = da->da_sub_dev;				\
+	char *endptr;								\
+	u32 val;								\
+	int ret;								\
+										\
+	spin_lock(&se_dev->se_dev_lock);					\
+	if (!(dev = se_dev->se_dev_ptr)) {					\
+		spin_unlock(&se_dev->se_dev_lock);				\
+		return(-ENODEV);						\
+	}									\
+	val = simple_strtoul(page, &endptr, 0);					\
+	ret = se_dev_set_##_name(dev, (u32)val);				\
+	spin_unlock(&se_dev->se_dev_lock);					\
+										\
+	return((!ret) ? count : -EINVAL);					\
+}
+
+#define DEF_DEV_ATTRIB(_name)							\
+DEF_DEV_ATTRIB_SHOW(_name);							\
+DEF_DEV_ATTRIB_STORE(_name);
+
+#define DEF_DEV_ATTRIB_RO(_name)						\
+DEF_DEV_ATTRIB_SHOW(_name);
+
+CONFIGFS_EATTR_STRUCT(target_core_dev_attrib, se_dev_attrib_s);
+#define SE_DEV_ATTR(_name, _mode)						\
+static struct target_core_dev_attrib_attribute target_core_dev_attrib_##_name = \
+		__CONFIGFS_EATTR(_name, _mode,					\
+		target_core_dev_show_attr_##_name,				\
+		target_core_dev_store_attr_##_name);		
+
+#define SE_DEV_ATTR_RO(_name);							\
+static struct target_core_dev_attrib_attribute target_core_dev_attrib_##_name = \
+		__CONFIGFS_EATTR_RO(_name,					\
+		target_core_dev_show_attr_##_name);
+
+DEF_DEV_ATTRIB(status_thread);
+SE_DEV_ATTR(status_thread, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(status_thread_tur);
+SE_DEV_ATTR(status_thread_tur, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB_RO(hw_max_sectors);
+SE_DEV_ATTR_RO(hw_max_sectors);
+
+DEF_DEV_ATTRIB(max_sectors);
+SE_DEV_ATTR(max_sectors, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB_RO(hw_queue_depth);
+SE_DEV_ATTR_RO(hw_queue_depth);
+
+DEF_DEV_ATTRIB(queue_depth);
+SE_DEV_ATTR(queue_depth, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(task_timeout);
+SE_DEV_ATTR(task_timeout, S_IRUGO | S_IWUSR);
+
+CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib_s, da_group);
+
+static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
+	&target_core_dev_attrib_status_thread.attr,
+	&target_core_dev_attrib_status_thread_tur.attr,
+	&target_core_dev_attrib_hw_max_sectors.attr,
+	&target_core_dev_attrib_max_sectors.attr,
+	&target_core_dev_attrib_hw_queue_depth.attr,
+	&target_core_dev_attrib_queue_depth.attr,
+	&target_core_dev_attrib_task_timeout.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_core_dev_attrib_ops = {
+	.show_attribute		= target_core_dev_attrib_attr_show,
+	.store_attribute	= target_core_dev_attrib_attr_store,
+};
+
+static struct config_item_type target_core_dev_attrib_cit = {
+	.ct_item_ops		= &target_core_dev_attrib_ops,
+	.ct_attrs		= target_core_dev_attrib_attrs,	
+	.ct_owner		= THIS_MODULE,	
+};
+
+// End functions for struct config_item_type target_core_dev_attrib_cit
+
 //  Start functions for struct config_item_type target_core_dev_cit
 
 static ssize_t target_core_show_dev_info (void *p, char *page)
@@ -646,7 +759,7 @@ static ssize_t target_core_store_dev_enable (void *p, const char *page, size_t c
 	if (t->check_configfs_dev_params(hba, se_dev) < 0)
 		return(-EINVAL);
 
-	dev = t->create_virtdevice(hba, se_dev->se_dev_su_ptr);
+	dev = t->create_virtdevice(hba, se_dev, se_dev->se_dev_su_ptr);
 	if (!(dev) || IS_ERR(dev))
 		return(-EINVAL);
 
@@ -727,6 +840,7 @@ static struct config_group *target_core_call_createdev (
 	se_hba_t *hba, *hba_p;
 	se_subsystem_api_t *t;
 	struct config_item *hba_ci;
+	struct config_group *dev_cg = NULL;
 	int ret = 0;
 
 	if (!(hba_ci = &group->cg_item)) {
@@ -754,7 +868,15 @@ static struct config_group *target_core_call_createdev (
 		printk(KERN_ERR "Unable to allocate memory for se_subsystem_dev_t\n");
 		return(NULL);
 	}
+	spin_lock_init(&se_dev->se_dev_lock);
+	se_dev->se_dev_attrib.da_sub_dev = se_dev;
+
 	se_dev->se_dev_hba = hba;
+	dev_cg = &se_dev->se_dev_group;
+
+	if (!(dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+			GFP_KERNEL)))
+		goto out;
 
 	/*
 	 * Set se_dev_ptr from se_subsystem_api_t returned void ptr..
@@ -765,7 +887,12 @@ static struct config_group *target_core_call_createdev (
 		goto out;
 	}
 
-	config_group_init_type_name(&se_dev->se_dev_group, name, &target_core_dev_cit);
+	config_group_init_type_name(&se_dev->se_dev_group, name,
+			&target_core_dev_cit);
+	config_group_init_type_name(&se_dev->se_dev_attrib.da_group, "attrib",
+			&target_core_dev_attrib_cit);
+	dev_cg->default_groups[0] = &se_dev->se_dev_attrib.da_group;
+	dev_cg->default_groups[1] = NULL;
 
 	printk("Target_Core_ConfigFS: Allocated se_subsystem_dev_t: %p se_dev_su_ptr: %p\n",
 			se_dev, se_dev->se_dev_su_ptr);
@@ -773,6 +900,8 @@ static struct config_group *target_core_call_createdev (
 	core_put_hba(hba);
 	return(&se_dev->se_dev_group);
 out:
+	if (dev_cg)
+		kfree(dev_cg->default_groups);
 	kfree(se_dev);
 	core_put_hba(hba);
 	return(NULL);
-- 
1.5.4.1



