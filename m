From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 19/21] target: add initial fabric MappedLUN context target_core_stat.c code
Date: Mon, 14 Mar 2011 04:06:13 -0700
Message-ID: <1300100775-10012-20-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29.bullet.mail.ne1.yahoo.com ([98.138.90.92]:46715 "HELO
	nm29.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754598Ab1CNLH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:56 -0400
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a target_core_mib.c statistics conversion for
TCM MappedLUN/LunACL context struct se_lun_acl + struct se_dev_entry
config_group based statistics in target_core_fabric_configfs.c using
CONFIGFS_EATTR() based struct config_item_types from existing generic
target fabric TF_CIT_SETUP() wrapper code in target_core_fabric_configfs.c.

The conversion from backend /proc/scsi_target/mib/ context output to configfs
default groups+attributes include scsi_att_intr_port and scsi_auth_intr output
from within individual:

	/sys/kernel/config/target/fabric/$WWN/tpgt_$TPGT/acls/$INITIATOR_WWN/lun_$LUN_ID/statistics/

The legacy procfs output now appear as individual configfs attributes under:

*) acls/$INITIATOR_WWN/lun_$LUN_ID/statistics/scsi_att_intr_port

|-- dev
|-- indx
|-- inst
|-- port
|-- port_auth_indx
`-- port_ident

*) acls/$INITIATOR_WWN/lun_$LUN_ID/statistics/scsi_auth_intr

|-- att_count
|-- creation_time
|-- dev
|-- dev_or_port
|-- hs_num_cmds
|-- indx
|-- inst
|-- intr_name
|-- map_indx
|-- num_cmds
|-- port
|-- read_mbytes
|-- row_status
`-- write_mbytes

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   79 ++++-
 drivers/target/target_core_stat.c            |  582 ++++++++++++++++++++++++++
 drivers/target/target_core_stat.h            |    1 +
 include/target/target_core_base.h            |    9 +
 include/target/target_core_configfs.h        |    1 +
 5 files changed, 671 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 146e8fa..7d58be3 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -242,6 +242,32 @@ TF_CIT_SETUP(tpg_mappedlun, &target_fabric_mappedlun_item_ops, NULL,
 
 /* End of tfc_tpg_mappedlun_cit */
 
+/* Start of tfc_tpg_mappedlun_port_cit */
+
+static struct config_group *target_core_mappedlun_stat_mkdir(
+	struct config_group *group,
+	const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static void target_core_mappedlun_stat_rmdir(
+	struct config_group *group,
+	struct config_item *item)
+{
+	return;
+}
+
+static struct configfs_group_operations target_fabric_mappedlun_stat_group_ops = {
+	.make_group		= target_core_mappedlun_stat_mkdir,
+	.drop_item		= target_core_mappedlun_stat_rmdir,
+};
+
+TF_CIT_SETUP(tpg_mappedlun_stat, NULL, &target_fabric_mappedlun_stat_group_ops,
+		NULL);
+
+/* End of tfc_tpg_mappedlun_port_cit */
+
 /* Start of tfc_tpg_nacl_attrib_cit */
 
 CONFIGFS_EATTR_OPS(target_fabric_nacl_attrib, se_node_acl, acl_attrib_group);
@@ -295,6 +321,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
 	struct se_lun_acl *lacl;
 	struct config_item *acl_ci;
+	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
 	char *buf;
 	unsigned long mapped_lun;
 	int ret = 0;
@@ -331,15 +358,42 @@ static struct config_group *target_fabric_make_mappedlun(
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
 			config_item_name(acl_ci), &ret);
-	if (!(lacl))
+	if (!(lacl)) {
+		ret = -EINVAL;
 		goto out;
+	}
+
+	lacl_cg = &lacl->se_lun_group;
+	lacl_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+				GFP_KERNEL);
+	if (!lacl_cg->default_groups) {
+		printk(KERN_ERR "Unable to allocate lacl_cg->default_groups\n");
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	config_group_init_type_name(&lacl->se_lun_group, name,
 			&TF_CIT_TMPL(tf)->tfc_tpg_mappedlun_cit);
+	config_group_init_type_name(&lacl->ml_stat_grps.stat_group,
+			"statistics", &TF_CIT_TMPL(tf)->tfc_tpg_mappedlun_stat_cit);
+	lacl_cg->default_groups[0] = &lacl->ml_stat_grps.stat_group;
+	lacl_cg->default_groups[1] = NULL;
+
+	ml_stat_grp = &ML_STAT_GRPS(lacl)->stat_group;
+	ml_stat_grp->default_groups = kzalloc(sizeof(struct config_group) * 3,
+				GFP_KERNEL);
+	if (!ml_stat_grp->default_groups) {
+		printk(KERN_ERR "Unable to allocate ml_stat_grp->default_groups\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	target_stat_setup_mappedlun_default_groups(lacl);
 
 	kfree(buf);
 	return &lacl->se_lun_group;
 out:
+	if (lacl_cg)
+		kfree(lacl_cg->default_groups);
 	kfree(buf);
 	return ERR_PTR(ret);
 }
@@ -348,6 +402,28 @@ static void target_fabric_drop_mappedlun(
 	struct config_group *group,
 	struct config_item *item)
 {
+	struct se_lun_acl *lacl = container_of(to_config_group(item),
+			struct se_lun_acl, se_lun_group);
+	struct config_item *df_item;
+	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
+	int i;
+
+	ml_stat_grp = &ML_STAT_GRPS(lacl)->stat_group;
+	for (i = 0; ml_stat_grp->default_groups[i]; i++) {
+		df_item = &ml_stat_grp->default_groups[i]->cg_item;
+		ml_stat_grp->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+	kfree(ml_stat_grp->default_groups);
+
+	lacl_cg = &lacl->se_lun_group;
+	for (i = 0; lacl_cg->default_groups[i]; i++) {
+		df_item = &lacl_cg->default_groups[i]->cg_item;
+		lacl_cg->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+	kfree(lacl_cg->default_groups);
+
 	config_item_put(item);
 }
 
@@ -1106,6 +1182,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 	target_fabric_setup_tpg_nacl_auth_cit(tf);
 	target_fabric_setup_tpg_nacl_param_cit(tf);
 	target_fabric_setup_tpg_mappedlun_cit(tf);
+	target_fabric_setup_tpg_mappedlun_stat_cit(tf);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 2f3e478..5e3a067 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1226,3 +1226,585 @@ void target_stat_setup_port_default_groups(struct se_lun *lun)
 	port_stat_grp->default_groups[2] = &PORT_STAT_GRP(lun)->scsi_transport_group;
 	port_stat_grp->default_groups[3] = NULL;
 }
+
+/*
+ * SCSI Authorized Initiator Table
+ */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_auth_intr, se_ml_stat_grps);
+#define DEV_STAT_SCSI_AUTH_INTR_ATTR(_name, _mode)			\
+static struct target_stat_scsi_auth_intr_attribute			\
+			target_stat_scsi_auth_intr_##_name =		\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_auth_intr_show_attr_##_name,			\
+	target_stat_scsi_auth_intr_store_attr_##_name);
+
+#define DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(_name)				\
+static struct target_stat_scsi_auth_intr_attribute			\
+			target_stat_scsi_auth_intr_##_name =		\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_auth_intr_show_attr_##_name);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_inst(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	tpg = nacl->se_tpg;
+	/* scsiInstIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+			TPG_TFO(tpg)->tpg_get_inst_index(tpg));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_dev(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	struct se_lun *lun;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	tpg = nacl->se_tpg;
+	lun = deve->se_lun;
+	/* scsiDeviceIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_se_dev->dev_index);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(dev);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_port(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	tpg = nacl->se_tpg;
+	/* scsiAuthIntrTgtPortIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", TPG_TFO(tpg)->tpg_get_tag(tpg));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(port);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_indx(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", nacl->acl_index);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_dev_or_port(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrDevOrPort */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", 1);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(dev_or_port);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_intr_name(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrName */
+	ret = snprintf(page, PAGE_SIZE, "%s\n", nacl->initiatorname);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(intr_name);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_map_indx(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* FIXME: scsiAuthIntrLunMapIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(map_indx);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_att_count(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrAttachedTimes */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->attach_count);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(att_count);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_num_cmds(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrOutCommands */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->total_cmds);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(num_cmds);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_read_mbytes(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrReadMegaBytes */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(deve->read_bytes >> 20));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(read_mbytes);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_write_mbytes(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrWrittenMegaBytes */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(deve->write_bytes >> 20));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(write_mbytes);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_hs_num_cmds(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* FIXME: scsiAuthIntrHSOutCommands */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(hs_num_cmds);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_creation_time(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAuthIntrLastCreation */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(((u32)deve->creation_time -
+				INITIAL_JIFFIES) * 100 / HZ));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(creation_time);
+
+static ssize_t target_stat_scsi_auth_intr_show_attr_row_status(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* FIXME: scsiAuthIntrRowStatus */
+	ret = snprintf(page, PAGE_SIZE, "Ready\n");
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(row_status);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_auth_intr, se_ml_stat_grps,
+		scsi_auth_intr_group);
+
+static struct configfs_attribute *target_stat_scsi_auth_intr_attrs[] = {
+	&target_stat_scsi_auth_intr_inst.attr,
+	&target_stat_scsi_auth_intr_dev.attr,
+	&target_stat_scsi_auth_intr_port.attr,
+	&target_stat_scsi_auth_intr_indx.attr,
+	&target_stat_scsi_auth_intr_dev_or_port.attr,
+	&target_stat_scsi_auth_intr_intr_name.attr,
+	&target_stat_scsi_auth_intr_map_indx.attr,
+	&target_stat_scsi_auth_intr_att_count.attr,
+	&target_stat_scsi_auth_intr_num_cmds.attr,
+	&target_stat_scsi_auth_intr_read_mbytes.attr,
+	&target_stat_scsi_auth_intr_write_mbytes.attr,
+	&target_stat_scsi_auth_intr_hs_num_cmds.attr,
+	&target_stat_scsi_auth_intr_creation_time.attr,
+	&target_stat_scsi_auth_intr_row_status.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_auth_intr_attrib_ops = {
+	.show_attribute		= target_stat_scsi_auth_intr_attr_show,
+	.store_attribute	= target_stat_scsi_auth_intr_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_auth_intr_cit = {
+	.ct_item_ops		= &target_stat_scsi_auth_intr_attrib_ops,
+	.ct_attrs		= target_stat_scsi_auth_intr_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * SCSI Attached Initiator Port Table
+ */
+
+CONFIGFS_EATTR_STRUCT(target_stat_scsi_att_intr_port, se_ml_stat_grps);
+#define DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR(_name, _mode)			\
+static struct target_stat_scsi_att_intr_port_attribute			\
+		target_stat_scsi_att_intr_port_##_name =		\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	target_stat_scsi_att_intr_port_show_attr_##_name,		\
+	target_stat_scsi_att_intr_port_store_attr_##_name);
+
+#define DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(_name)			\
+static struct target_stat_scsi_att_intr_port_attribute			\
+		target_stat_scsi_att_intr_port_##_name =		\
+	__CONFIGFS_EATTR_RO(_name,					\
+	target_stat_scsi_att_intr_port_show_attr_##_name);
+
+static ssize_t target_stat_scsi_att_intr_port_show_attr_inst(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	tpg = nacl->se_tpg;
+	/* scsiInstIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+			TPG_TFO(tpg)->tpg_get_inst_index(tpg));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(inst);
+
+static ssize_t target_stat_scsi_att_intr_port_show_attr_dev(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	struct se_lun *lun;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	tpg = nacl->se_tpg;
+	lun = deve->se_lun;
+	/* scsiDeviceIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_se_dev->dev_index);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(dev);
+
+static ssize_t target_stat_scsi_att_intr_port_show_attr_port(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	tpg = nacl->se_tpg;
+	/* scsiPortIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", TPG_TFO(tpg)->tpg_get_tag(tpg));
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port);
+
+static ssize_t target_stat_scsi_att_intr_port_show_attr_indx(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_session *se_sess;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->nacl_sess_lock);
+	se_sess = nacl->nacl_sess;
+	if (!se_sess) {
+		spin_unlock_irq(&nacl->nacl_sess_lock);
+		return -ENODEV;
+	}
+
+	tpg = nacl->se_tpg;
+	/* scsiAttIntrPortIndex */
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+			TPG_TFO(tpg)->sess_get_index(se_sess));
+	spin_unlock_irq(&nacl->nacl_sess_lock);
+	return ret;
+}
+DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(indx);
+
+static ssize_t target_stat_scsi_att_intr_port_show_attr_port_auth_indx(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry *deve;
+	ssize_t ret;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	if (!deve->se_lun || !deve->se_lun_acl) {
+		spin_unlock_irq(&nacl->device_list_lock);
+		return -ENODEV;
+	}
+	/* scsiAttIntrPortAuthIntrIdx */
+	ret = snprintf(page, PAGE_SIZE, "%u\n", nacl->acl_index);
+	spin_unlock_irq(&nacl->device_list_lock);
+	return ret;
+}
+DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port_auth_indx);
+
+static ssize_t target_stat_scsi_att_intr_port_show_attr_port_ident(
+	struct se_ml_stat_grps *lgrps, char *page)
+{
+	struct se_lun_acl *lacl = container_of(lgrps,
+			struct se_lun_acl, ml_stat_grps);
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_session *se_sess;
+	struct se_portal_group *tpg;
+	ssize_t ret;
+	unsigned char buf[64];
+
+	spin_lock_irq(&nacl->nacl_sess_lock);
+	se_sess = nacl->nacl_sess;
+	if (!se_sess) {
+		spin_unlock_irq(&nacl->nacl_sess_lock);
+		return -ENODEV;
+	}
+
+	tpg = nacl->se_tpg;
+	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
+	memset(buf, 0, 64);
+	if (TPG_TFO(tpg)->sess_get_initiator_sid != NULL)
+		TPG_TFO(tpg)->sess_get_initiator_sid(se_sess,
+				(unsigned char *)&buf[0], 64);
+
+	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
+	spin_unlock_irq(&nacl->nacl_sess_lock);
+	return ret;
+}
+DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port_ident);
+
+CONFIGFS_EATTR_OPS(target_stat_scsi_att_intr_port, se_ml_stat_grps,
+		scsi_att_intr_port_group);
+
+static struct configfs_attribute *target_stat_scsi_ath_intr_port_attrs[] = {
+	&target_stat_scsi_att_intr_port_inst.attr,
+	&target_stat_scsi_att_intr_port_dev.attr,
+	&target_stat_scsi_att_intr_port_port.attr,
+	&target_stat_scsi_att_intr_port_indx.attr,
+	&target_stat_scsi_att_intr_port_port_auth_indx.attr,
+	&target_stat_scsi_att_intr_port_port_ident.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_stat_scsi_att_intr_port_attrib_ops = {
+	.show_attribute		= target_stat_scsi_att_intr_port_attr_show,
+	.store_attribute	= target_stat_scsi_att_intr_port_attr_store,
+};
+
+static struct config_item_type target_stat_scsi_att_intr_port_cit = {
+	.ct_item_ops		= &target_stat_scsi_att_intr_port_attrib_ops,
+	.ct_attrs		= target_stat_scsi_ath_intr_port_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * Called from target_core_fabric_configfs.c:target_fabric_make_mappedlun() to setup
+ * the target MappedLUN statistics groups + configfs CITs located in target_core_stat.c
+ */
+void target_stat_setup_mappedlun_default_groups(struct se_lun_acl *lacl)
+{
+	struct config_group *ml_stat_grp = &ML_STAT_GRPS(lacl)->stat_group;
+
+	config_group_init_type_name(&ML_STAT_GRPS(lacl)->scsi_auth_intr_group,
+			"scsi_auth_intr", &target_stat_scsi_auth_intr_cit);
+	config_group_init_type_name(&ML_STAT_GRPS(lacl)->scsi_att_intr_port_group,
+			"scsi_att_intr_port", &target_stat_scsi_att_intr_port_cit);
+
+	ml_stat_grp->default_groups[0] = &ML_STAT_GRPS(lacl)->scsi_auth_intr_group;
+	ml_stat_grp->default_groups[1] = &ML_STAT_GRPS(lacl)->scsi_att_intr_port_group;
+	ml_stat_grp->default_groups[2] = NULL;
+}
diff --git a/drivers/target/target_core_stat.h b/drivers/target/target_core_stat.h
index 0204e6b..86c252f 100644
--- a/drivers/target/target_core_stat.h
+++ b/drivers/target/target_core_stat.h
@@ -3,5 +3,6 @@
 
 extern void target_stat_setup_dev_default_groups(struct se_subsystem_dev *);
 extern void target_stat_setup_port_default_groups(struct se_lun *);
+extern void target_stat_setup_mappedlun_default_groups(struct se_lun_acl *);
 
 #endif   /*** TARGET_CORE_STAT_H ***/
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0c8f5e1..9c2b90c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -622,6 +622,12 @@ struct se_device;
 struct se_transform_info;
 struct scatterlist;
 
+struct se_ml_stat_grps {
+	struct config_group	stat_group;
+	struct config_group	scsi_auth_intr_group;
+	struct config_group	scsi_att_intr_port_group;
+};
+
 struct se_lun_acl {
 	char			initiatorname[TRANSPORT_IQN_LEN];
 	u32			mapped_lun;
@@ -629,8 +635,11 @@ struct se_lun_acl {
 	struct se_lun		*se_lun;
 	struct list_head	lacl_list;
 	struct config_group	se_lun_group;
+	struct se_ml_stat_grps	ml_stat_grps;
 }  ____cacheline_aligned;
 
+#define ML_STAT_GRPS(lacl)	(&(lacl)->ml_stat_grps)
+
 struct se_dev_entry {
 	bool			def_pr_registered;
 	/* See transport_lunflags_table */
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index 06c5b1d..fc3bb9f 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -29,6 +29,7 @@ struct target_fabric_configfs_template {
 	struct config_item_type tfc_tpg_nacl_auth_cit;
 	struct config_item_type tfc_tpg_nacl_param_cit;
 	struct config_item_type tfc_tpg_mappedlun_cit;
+	struct config_item_type tfc_tpg_mappedlun_stat_cit;
 };
 
 struct target_fabric_configfs {
-- 
1.7.4.1

