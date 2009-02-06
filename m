From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/6] [Target_Core_Mod/ConfigFS]: Add ALUA infrastructure
Date: Fri, 06 Feb 2009 00:02:01 -0800
Message-ID: <1233907321.12375.367.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:44491 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752553AbZBFIDJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 03:03:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>

>From 0632c9f0eadc387c654f67163bdddc34478c3065 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 5 Feb 2009 23:22:28 -0800
Subject: [PATCH 5/6] [Target_Core_Mod/ConfigFS]: Add ALUA infrastructure

This patch adds /sys/kernel/config/target/core/alua, and adds
the following default groups from there:

lu_gps/default_lu_gp
tg_pt_gps/default_tg_pt_gps

by default, all Target_Core_Mod/ConfigFS $STORAGE_OBJECTs are added
to lu_gps/default_lu_gp.  When a $STORAGE_OBJECT is used to create
a SCSI Target Port in a ConfigFS enabled $FABRIC_MOD, said SCSI
Target Port are added to tg_pt_gps/default_tg_pt_gps.

New ConfigFS groups can be made in both core/alua/lu_gps and
core/alua/tg_pt_gps, and associated via:

echo $LU_GROUP_NAME > core/$HBA/$DEV/alua_lu_gp
echo $TG_PT_GROUP_NAME > $FABRIC_MOD/$TARGETNAME/$TPGT/lun/lun_0/alua_tg_pt_gp

Also, echoing "NULL" to these two attributes will release any existing
Logical Unit or Target Port Group association.

This patch also adds three (3) levels deep default groups for
/sys/kernel/config/target/core/alua in target_core_init_configfs(),
and releases them in target_core_exit_configfs().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |  564 +++++++++++++++++++++++++++++-
 1 files changed, 545 insertions(+), 19 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 08229dd..888522b 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -40,6 +40,7 @@
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
 #include <target_core_transport.h>
+#include <target_core_alua.h>
 #include <target_core_pr.h>
 
 #ifdef SNMP_SUPPORT
@@ -53,8 +54,6 @@
 
 extern se_global_t *se_global;
 
-struct config_group target_core_hbagroup;
-
 struct list_head g_tf_list;
 struct mutex g_tf_lock;
 
@@ -1247,11 +1246,105 @@ static struct target_core_configfs_attribute target_core_attr_dev_enable = {
 	.store	= target_core_store_dev_enable,
 };
 
+static ssize_t target_core_show_alua_lu_gp (void *p, char *page)
+{
+	se_device_t *dev;
+	se_subsystem_dev_t *su_dev = (se_subsystem_dev_t *)p;
+	struct config_item *lu_ci;
+	t10_alua_lu_gp_t *lu_gp;
+	ssize_t len = 0;
+
+	if (!(dev = su_dev->se_dev_ptr)) 
+		return(-ENODEV);
+
+	spin_lock(&dev->dev_alua_lock);
+	if ((lu_gp = dev->dev_alua_lu_gp)) {
+		lu_ci = &lu_gp->lu_gp_group.cg_item;
+		len += sprintf(page, "LU Group Alias: %s\nLU Group ID: %hu\n",
+			config_item_name(lu_ci), lu_gp->lu_gp_id);
+	}
+	spin_unlock(&dev->dev_alua_lock);	
+
+	return(len);
+}
+
+static ssize_t target_core_store_alua_lu_gp (void *p, const char *page, size_t count)
+{
+	se_device_t *dev;
+	se_subsystem_dev_t *su_dev = (se_subsystem_dev_t *)p;
+	se_hba_t *hba = su_dev->se_dev_hba;
+	t10_alua_lu_gp_t *lu_gp = NULL, *lu_gp_new;
+	unsigned char buf[256];
+	int move = 0;
+
+	if (!(dev = su_dev->se_dev_ptr)) 
+		return(-ENODEV);
+
+	if (T10_ALUA(su_dev)->alua_type != SPC3_ALUA_EMULATED) {
+		printk(KERN_WARNING "SPC3_ALUA_EMULATED not enabled for %s/%s\n",
+			config_item_name(&hba->hba_group.cg_item),
+			config_item_name(&su_dev->se_dev_group.cg_item));
+		return(-EINVAL);
+	}
+	if (count > 256) {
+		printk(KERN_ERR "ALUA LU Group Alias too large!\n");
+		return(-EINVAL);
+	}
+	memset(buf, 0, 256);
+	memcpy(buf, page, count);
+
+	spin_lock(&dev->dev_alua_lock);
+	if ((lu_gp = dev->dev_alua_lu_gp)) {
+		if (!(strcmp(strstrip(buf), "NULL"))) {
+			printk("Target_Core_ConfigFS: Releasing %s/%s from ALUA"
+				" LU Group: core/alua/lu_gps/%s, ID: %hu\n",  
+				config_item_name(&hba->hba_group.cg_item),
+				config_item_name(&su_dev->se_dev_group.cg_item),
+				config_item_name(&lu_gp->lu_gp_group.cg_item),
+				lu_gp->lu_gp_id);
+
+			__core_alua_put_lu_gp(dev, 1);
+			spin_unlock(&dev->dev_alua_lock);
+
+			return(count);
+		}
+	}
+	spin_unlock(&dev->dev_alua_lock);
+
+	if (!(lu_gp_new = core_alua_get_lu_gp_by_name(dev, strstrip(buf))))
+		return(-ENODEV);
+
+	if (lu_gp) {
+		core_alua_put_lu_gp(dev, 0);
+		move = 1;
+	}
+	core_alua_attach_lu_gp(dev, lu_gp_new);
+
+	printk("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
+		" core/alua/lu_gps/%s, ID: %hu\n",
+		(move) ? "Moving" : "Adding",
+		config_item_name(&hba->hba_group.cg_item),
+		config_item_name(&su_dev->se_dev_group.cg_item),
+		config_item_name(&lu_gp_new->lu_gp_group.cg_item),
+		lu_gp_new->lu_gp_id);
+
+	return(count);
+}
+
+static struct target_core_configfs_attribute target_core_attr_dev_alua_lu_gp = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "alua_lu_gp",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= target_core_show_alua_lu_gp,
+	.store	= target_core_store_alua_lu_gp,
+};
+
 static struct configfs_attribute *lio_core_dev_attrs[] = {
 	&target_core_attr_dev_info.attr,
 	&target_core_attr_dev_control.attr,
 	&target_core_attr_dev_fd.attr,
 	&target_core_attr_dev_enable.attr,
+	&target_core_attr_dev_alua_lu_gp.attr,
 	NULL,
 };
 
@@ -1299,6 +1392,320 @@ static struct config_item_type target_core_dev_cit = {
 
 // End functions for struct config_item_type target_core_dev_cit
 
+// Start functions for struct config_item_type target_core_alua_lu_gp_cit
+
+CONFIGFS_EATTR_STRUCT(target_core_alua_lu_gp, t10_alua_lu_gp_s);
+#define SE_DEV_ALUA_LU_ATTR_RO(_name)						\
+static struct target_core_alua_lu_gp_attribute target_core_alua_lu_gp_##_name =	\
+	__CONFIGFS_EATTR_RO(_name,						\
+	target_core_alua_lu_gp_show_attr_##_name);
+
+/*
+ * alua_access_state
+ */
+static ssize_t target_core_alua_lu_gp_show_attr_alua_access_state (
+	struct t10_alua_lu_gp_s *lu_gp,
+	char *page)
+{
+	return(sprintf(page, "%d\n", lu_gp->lu_gp_alua_access_state));
+}
+
+SE_DEV_ALUA_LU_ATTR_RO(alua_access_state);
+
+/*
+ * lu_gp_id
+ */
+static ssize_t target_core_alua_lu_gp_show_attr_lu_gp_id (
+	struct t10_alua_lu_gp_s *lu_gp,
+	char *page)
+{
+	return(sprintf(page, "%hu\n", lu_gp->lu_gp_id));
+}
+
+SE_DEV_ALUA_LU_ATTR_RO(lu_gp_id);
+
+/*
+ * members
+ */
+static ssize_t target_core_alua_lu_gp_show_attr_members (
+	struct t10_alua_lu_gp_s *lu_gp,
+	char *page)
+{
+	se_device_t *dev;
+	se_hba_t *hba;
+	se_subsystem_dev_t *su_dev;
+	ssize_t len = 0, cur_len;
+	unsigned char buf[256];
+
+	memset(buf, 0, 256);
+
+	spin_lock(&lu_gp->lu_gp_ref_lock);
+	list_for_each_entry(dev, &lu_gp->lu_gp_ref_list, dev_lu_gp_list) {
+		su_dev = dev->se_sub_dev;
+		hba = su_dev->se_dev_hba;
+
+		cur_len = snprintf(buf, 256, "%s/%s\n",
+			config_item_name(&su_dev->se_dev_group.cg_item),
+			config_item_name(&hba->hba_group.cg_item));
+		cur_len++; // Extra byte for NULL terminator
+
+		if ((cur_len + len) > PAGE_SIZE) {
+			printk(KERN_WARNING "Ran out of lu_gp_show_attr"
+				"_members buffer\n");
+			break;
+		}
+		memcpy(page+len, buf, cur_len);
+		len += cur_len;
+	}
+	spin_unlock(&lu_gp->lu_gp_ref_lock);
+
+	return(len);
+}
+
+SE_DEV_ALUA_LU_ATTR_RO(members);
+
+CONFIGFS_EATTR_OPS_RO(target_core_alua_lu_gp, t10_alua_lu_gp_s, lu_gp_group);
+
+static struct configfs_attribute *target_core_alua_lu_gp_attrs[] = {
+	&target_core_alua_lu_gp_alua_access_state.attr,
+	&target_core_alua_lu_gp_lu_gp_id.attr,
+	&target_core_alua_lu_gp_members.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_core_alua_lu_gp_ops = {
+	.show_attribute		= target_core_alua_lu_gp_attr_show,
+	.store_attribute	= NULL,
+};
+
+static struct config_item_type target_core_alua_lu_gp_cit = {
+	.ct_item_ops		= &target_core_alua_lu_gp_ops,
+	.ct_attrs		= target_core_alua_lu_gp_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+// End functions for struct config_item_type target_core_alua_lu_gp_cit
+
+// Start functions for struct config_item_type target_core_alua_lu_gps_cit
+
+static struct config_group *target_core_alua_create_lu_gp (
+	struct config_group *group,
+	const char *name)
+{
+	t10_alua_lu_gp_t *lu_gp;
+	struct config_group *alua_lu_gp_cg = NULL;
+	struct config_item *alua_lu_gp_ci = NULL;
+
+	if (!(lu_gp = core_alua_allocate_lu_gp(name)))
+		return(NULL);
+
+	alua_lu_gp_cg = &lu_gp->lu_gp_group;
+	alua_lu_gp_ci = &alua_lu_gp_cg->cg_item;
+
+	config_group_init_type_name(alua_lu_gp_cg, name,
+			&target_core_alua_lu_gp_cit);
+	
+	printk("Target_Core_ConfigFS: Allocated ALUA Logical Unit Group:"
+		" core/alua/lu_gps/%s, ID: %hu\n",
+		config_item_name(alua_lu_gp_ci), lu_gp->lu_gp_id);
+
+	return(alua_lu_gp_cg);
+		
+}
+
+static void target_core_alua_drop_lu_gp (
+	struct config_group *group,
+	struct config_item *item)
+{
+	t10_alua_lu_gp_t *lu_gp = container_of(to_config_group(item),
+			t10_alua_lu_gp_t, lu_gp_group);
+
+	printk("Target_Core_ConfigFS: Releasing ALUA Logical Unit Group:"
+		" core/alua/lu_gps/%s, ID: %hu\n", config_item_name(item),
+		lu_gp->lu_gp_id);
+
+	config_item_put(item);
+	core_alua_free_lu_gp(lu_gp);	
+	return;
+}
+
+static struct configfs_group_operations target_core_alua_lu_gps_group_ops = {
+	.make_group		= &target_core_alua_create_lu_gp,
+	.drop_item		= &target_core_alua_drop_lu_gp,
+};
+
+static struct config_item_type target_core_alua_lu_gps_cit = {
+	.ct_group_ops		= &target_core_alua_lu_gps_group_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+// End functions for struct config_item_type target_core_alua_lu_gps_cit
+
+// Start functions for struct config_item_type target_core_alua_tg_pt_gp_cit
+
+CONFIGFS_EATTR_STRUCT(target_core_alua_tg_pt_gp, t10_alua_tg_pt_gp_s);
+#define SE_DEV_ALUA_TG_PT_ATTR_RO(_name)						\
+static struct target_core_alua_tg_pt_gp_attribute target_core_alua_tg_pt_gp_##_name =	\
+	__CONFIGFS_EATTR_RO(_name,							\
+	target_core_alua_tg_pt_gp_show_attr_##_name);
+
+/*
+ * alua_access_state
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_state (
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return(sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_alua_access_state));
+}
+
+SE_DEV_ALUA_TG_PT_ATTR_RO(alua_access_state);
+
+/*
+ * tg_pt_gp_id
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_tg_pt_gp_id (
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return(sprintf(page, "%hu\n", tg_pt_gp->tg_pt_gp_id));
+}
+
+SE_DEV_ALUA_TG_PT_ATTR_RO(tg_pt_gp_id);
+
+/*
+ * members
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_members (
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	se_port_t *port;
+	se_portal_group_t *tpg;
+	se_lun_t *lun;
+	ssize_t len = 0, cur_len;
+	unsigned char buf[256];
+
+	memset(buf, 0, 256);
+
+	spin_lock(&tg_pt_gp->tg_pt_gp_ref_lock);
+	list_for_each_entry(port, &tg_pt_gp->tg_pt_gp_ref_list, sep_tg_pt_gp_list) {
+		tpg = port->sep_tpg;
+		lun = port->sep_lun;
+
+		cur_len = snprintf(buf, 256, "%s/tpgt_%hu/%s\n",
+			TPG_TFO(tpg)->tpg_get_wwn(tpg),
+			TPG_TFO(tpg)->tpg_get_tag(tpg),
+			config_item_name(&lun->lun_group.cg_item));
+		cur_len++; // Extra byte for NULL terminator
+
+		if ((cur_len + len) > PAGE_SIZE) {
+			printk(KERN_WARNING "Ran out of lu_gp_show_attr"
+				"_members buffer\n");
+			break;
+		}
+		memcpy(page+len, buf, cur_len);
+		len += cur_len;
+	}
+	spin_unlock(&tg_pt_gp->tg_pt_gp_ref_lock);
+
+	return(len);
+}
+
+SE_DEV_ALUA_TG_PT_ATTR_RO(members);
+
+CONFIGFS_EATTR_OPS_RO(target_core_alua_tg_pt_gp, t10_alua_tg_pt_gp_s, tg_pt_gp_group);
+
+static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
+	&target_core_alua_tg_pt_gp_alua_access_state.attr,
+	&target_core_alua_tg_pt_gp_tg_pt_gp_id.attr,
+	&target_core_alua_tg_pt_gp_members.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_core_alua_tg_pt_gp_ops = {
+	.show_attribute		= target_core_alua_tg_pt_gp_attr_show,
+	.store_attribute	= NULL,
+};
+
+static struct config_item_type target_core_alua_tg_pt_gp_cit = {
+	.ct_item_ops		= &target_core_alua_tg_pt_gp_ops,
+	.ct_attrs		= target_core_alua_tg_pt_gp_attrs,
+        .ct_owner               = THIS_MODULE,
+};
+
+// End functions for struct config_item_type target_core_alua_tg_pt_gp_cit
+
+// Start functions for struct config_item_type target_core_alua_tg_pt_gps_cit
+
+static struct config_group *target_core_alua_create_tg_pt_gp (
+	struct config_group *group,
+	const char *name)
+{
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	struct config_group *alua_tg_pt_gp_cg = NULL;
+	struct config_item *alua_tg_pt_gp_ci = NULL;
+
+	if (!(tg_pt_gp = core_alua_allocate_tg_pt_gp(name)))
+		return(NULL);
+
+	alua_tg_pt_gp_cg = &tg_pt_gp->tg_pt_gp_group;
+	alua_tg_pt_gp_ci = &alua_tg_pt_gp_cg->cg_item;
+
+	config_group_init_type_name(alua_tg_pt_gp_cg, name,
+			&target_core_alua_tg_pt_gp_cit);
+	
+	printk("Target_Core_ConfigFS: Allocated ALUA Target Port Group:"
+		" core/alua/tg_pt_gps/%s, ID: %hu\n",
+		config_item_name(alua_tg_pt_gp_ci), tg_pt_gp->tg_pt_gp_id);
+
+	return(alua_tg_pt_gp_cg);
+}
+
+static void target_core_alua_drop_tg_pt_gp (
+	struct config_group *group,
+	struct config_item *item)
+{
+	t10_alua_tg_pt_gp_t *tg_pt_gp = container_of(to_config_group(item),
+			t10_alua_tg_pt_gp_t, tg_pt_gp_group);
+
+	printk("Target_Core_ConfigFS: Releasing ALUA Target Port Group:"
+		" core/alua/tg_pt_gps/%s, ID: %hu\n", config_item_name(item),
+		tg_pt_gp->tg_pt_gp_id);
+
+	config_item_put(item);
+	core_alua_free_tg_pt_gp(tg_pt_gp);
+	return;
+}
+
+static struct configfs_group_operations target_core_alua_tg_pt_gps_group_ops = {
+	.make_group		= &target_core_alua_create_tg_pt_gp,
+	.drop_item		= &target_core_alua_drop_tg_pt_gp,
+};
+
+static struct config_item_type target_core_alua_tg_pt_gps_cit = {
+	.ct_group_ops		= &target_core_alua_tg_pt_gps_group_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+// End functions for struct config_item_type target_core_alua_tg_pt_gps_cit
+
+// Start functions for struct config_item_type target_core_alua_cit
+
+/*
+ * target_core_alua_cit is a ConfigFS group that lives under
+ * /sys/kernel/config/target/core/alua.  There are default groups
+ * core/alua/lu_gps and core/alua/tg_pt_gps that are attached to
+ * target_core_alua_cit in target_core_init_configfs() below.
+ */
+static struct config_item_type target_core_alua_cit = {
+	.ct_item_ops		= NULL,
+	.ct_attrs		= NULL,
+	.ct_owner		= THIS_MODULE,
+};
+
+// End functions for struct config_item_type target_core_alua_cit
+
 // Start functions for struct config_item_type target_core_hba_cit
 
 static struct config_group *target_core_call_createdev (
@@ -1589,11 +1996,14 @@ static struct config_item_type target_core_cit = {
 
 extern int target_core_init_configfs (void)
 {
-	struct config_group *target_cg;
+	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
+	struct config_group *lu_gp_cg = NULL, *tg_pt_gp_cg = NULL;
 	struct configfs_subsystem *subsys;
 #ifdef SNMP_SUPPORT
 	struct proc_dir_entry *scsi_target_proc;
 #endif
+	t10_alua_lu_gp_t *lu_gp;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	int ret;
 
 	printk("TARGET_CORE[0]: Loading Generic Kernel Storage Engine: %s on %s/%s"
@@ -1604,42 +2014,108 @@ extern int target_core_init_configfs (void)
 	config_group_init(&subsys->su_group);
 	mutex_init(&subsys->su_mutex);
 
+	INIT_LIST_HEAD(&g_tf_list);
+	mutex_init(&g_tf_lock);
+#ifdef SNMP_SUPPORT
+        init_scsi_index_table();
+#endif
+	if ((ret = init_se_global()) < 0)
+		return(-1);
 	/*
 	 * Create $CONFIGFS/target/core default group for HBA <-> Storage Object
+	 * and ALUA Logical Unit Group and Target Port Group infrastructure.
 	 */
 	target_cg = &subsys->su_group;
 	if (!(target_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL))) {
-		printk(KERN_ERR "Unable to allocate core_cg\n");
-		return(-ENOMEM);
+		printk(KERN_ERR "Unable to allocate target_cg->default_groups\n");
+		goto out_global;
 	}
 
-	config_group_init_type_name(&target_core_hbagroup,
+	config_group_init_type_name(&se_global->target_core_hbagroup,
 		 	"core", &target_core_cit);
-	target_cg->default_groups[0] = &target_core_hbagroup;
+	target_cg->default_groups[0] = &se_global->target_core_hbagroup;
 	target_cg->default_groups[1] = NULL;
+	/*
+	 * Create ALUA infrastructure under /sys/kernel/config/target/core/alua/
+	 */
+	hba_cg = &se_global->target_core_hbagroup;
+	if (!(hba_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+			GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate hba_cg->default_groups\n");
+		goto out_global;
+	}
+	config_group_init_type_name(&se_global->alua_group,
+			"alua", &target_core_alua_cit);
+	hba_cg->default_groups[0] = &se_global->alua_group;
+	hba_cg->default_groups[1] = NULL;
+	/*
+	 * Add ALUA Logical Unit Group and Target Port Group ConfigFS
+	 * groups under /sys/kernel/config/target/core/alua/
+	 */
+	alua_cg = &se_global->alua_group;
+	if (!(alua_cg->default_groups = kzalloc(sizeof(struct config_group) * 3,
+			GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate alua_cg->default_groups\n");
+		goto out_global;
+	}
+	
+	config_group_init_type_name(&se_global->alua_lu_gps_group,
+			"lu_gps", &target_core_alua_lu_gps_cit);
+	config_group_init_type_name(&se_global->alua_tg_pt_gps_group,
+			"tg_pt_gps", &target_core_alua_tg_pt_gps_cit);
+	alua_cg->default_groups[0] = &se_global->alua_lu_gps_group;
+	alua_cg->default_groups[1] = &se_global->alua_tg_pt_gps_group;
+	alua_cg->default_groups[2] = NULL;
+	/*
+	 * Add core/alua/lu_gps/default_lu_gp
+	 */
+	if (!(lu_gp = core_alua_allocate_lu_gp("default_lu_gp")))
+		goto out_global;
 
+	lu_gp_cg = &se_global->alua_lu_gps_group;
+	if (!(lu_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+			GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate lu_gp_cg->default_groups\n");
+		goto out_global;
+	}
+
+	config_group_init_type_name(&lu_gp->lu_gp_group, "default_lu_gp",
+				&target_core_alua_lu_gp_cit);
+	lu_gp_cg->default_groups[0] = &lu_gp->lu_gp_group;
+	lu_gp_cg->default_groups[1] = NULL;
+	se_global->default_lu_gp = lu_gp;
 	/*
-	 * Initialize the global vars, and then register the target subsystem
-	 * with configfs.
+	 * Add core/alua/tg_pt_gps/default_tg_pt_gp
+	 */
+	if (!(tg_pt_gp = core_alua_allocate_tg_pt_gp("default_tg_pt_gp")))
+		goto out_global;
+
+	tg_pt_gp_cg = &se_global->alua_tg_pt_gps_group;
+	if (!(tg_pt_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+			GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate tg_pt_gp_cg->default_groups\n");
+		goto out_global;
+	}
+
+	config_group_init_type_name(&tg_pt_gp->tg_pt_gp_group, "default_tg_pt_gp",
+				&target_core_alua_tg_pt_gp_cit);
+	tg_pt_gp_cg->default_groups[0] = &tg_pt_gp->tg_pt_gp_group;
+	tg_pt_gp_cg->default_groups[1] = NULL;
+	se_global->default_tg_pt_gp = tg_pt_gp;
+
+	/*
+	 * Register the target_core_mod subsystem with configfs.
 	 */
-	INIT_LIST_HEAD(&g_tf_list);
-	mutex_init(&g_tf_lock);
-#ifdef SNMP_SUPPORT
-	init_scsi_index_table();
-#endif
 	if ((ret = configfs_register_subsystem(subsys)) < 0) {
 		printk(KERN_ERR "Error %d while registering subsystem %s\n",
 			ret, subsys->su_group.cg_item.ci_namebuf);
-		return(-1);
+		goto out_global;
 	}
 	printk("TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: "
 		""TARGET_CORE_CONFIGFS_VERSION" on %s/%s on "UTS_RELEASE"\n",
 			utsname()->sysname, utsname()->machine);
 
-	if ((ret = init_se_global()) < 0)
-		goto out;
-
 	plugin_load_all_classes();
 #ifdef SNMP_SUPPORT
 	if (!(scsi_target_proc = proc_mkdir("scsi_target", 0))) {
@@ -1657,6 +2133,24 @@ out:
 	remove_proc_entry("scsi_target", 0);
 #endif
 	plugin_unload_all_classes();
+out_global:
+	if (se_global->default_lu_gp) {
+		core_alua_free_lu_gp(se_global->default_lu_gp);
+		se_global->default_lu_gp = NULL;
+	}
+	if (se_global->default_tg_pt_gp) {
+		core_alua_free_tg_pt_gp(se_global->default_tg_pt_gp);
+		se_global->default_tg_pt_gp = NULL;
+	}
+	if (lu_gp_cg)
+		kfree(lu_gp_cg->default_groups);
+	if (tg_pt_gp_cg)
+		kfree(tg_pt_gp_cg->default_groups);
+	if (alua_cg)
+		kfree(alua_cg->default_groups);
+	if (hba_cg)
+		kfree(hba_cg->default_groups);
+	kfree(target_cg->default_groups);
 	release_se_global();
 	return(-1);
 }
@@ -1664,13 +2158,45 @@ out:
 extern void target_core_exit_configfs (void)
 {
 	struct configfs_subsystem *subsys;
+	struct config_group *hba_cg, *alua_cg, *lu_gp_cg, *tg_pt_gp_cg;
 	struct config_item *item;
 	int i;
 
 	se_global->in_shutdown = 1;
-
 	subsys = target_core_subsystem[0];
 
+	tg_pt_gp_cg = &se_global->alua_tg_pt_gps_group;
+	for (i = 0; tg_pt_gp_cg->default_groups[i]; i++) {
+		item = &tg_pt_gp_cg->default_groups[i]->cg_item;
+		tg_pt_gp_cg->default_groups[i] = NULL;
+		config_item_put(item);
+	}
+	core_alua_free_tg_pt_gp(se_global->default_tg_pt_gp);
+	se_global->default_tg_pt_gp = NULL;
+
+	lu_gp_cg = &se_global->alua_lu_gps_group;
+	for (i = 0; lu_gp_cg->default_groups[i]; i++) {
+		item = &lu_gp_cg->default_groups[i]->cg_item;
+		lu_gp_cg->default_groups[i] = NULL;
+		config_item_put(item);
+	}
+	core_alua_free_lu_gp(se_global->default_lu_gp);
+	se_global->default_lu_gp = NULL;
+
+	alua_cg = &se_global->alua_group;
+	for (i = 0; alua_cg->default_groups[i]; i++) {
+		item = &alua_cg->default_groups[i]->cg_item;
+		alua_cg->default_groups[i] = NULL;
+		config_item_put(item);
+	}
+
+	hba_cg = &se_global->target_core_hbagroup;
+	for (i = 0; hba_cg->default_groups[i]; i++) {
+		item = &hba_cg->default_groups[i]->cg_item;
+		hba_cg->default_groups[i] = NULL;
+		config_item_put(item);
+	}
+
 	for (i = 0; subsys->su_group.default_groups[i]; i++) {
 		item = &subsys->su_group.default_groups[i]->cg_item;	
 		subsys->su_group.default_groups[i] = NULL;
-- 
1.5.4.1



