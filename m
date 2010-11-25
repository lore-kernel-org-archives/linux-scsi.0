From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] target: remove unused snapshot attributes
Date: Thu, 25 Nov 2010 03:01:16 -0500
Message-ID: <20101125080116.GB6469@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0KYIBQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 03:01:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_configfs.c
===================================================================
--- lio-core.orig/drivers/target/target_core_configfs.c	2010-11-25 08:52:56.000000000 +0100
+++ lio-core/drivers/target/target_core_configfs.c	2010-11-25 08:53:47.000000000 +0100
@@ -1635,162 +1635,6 @@ static struct config_item_type target_co
 
 /*  End functions for struct config_item_type target_core_dev_pr_cit */
 
-/* Start functions for struct config_item type target_core_dev_snap_cit */
-
-CONFIGFS_EATTR_STRUCT(target_core_dev_snap, se_subsystem_dev);
-#define SE_DEV_SNAP_ATTR(_name, _mode)					\
-static struct target_core_dev_snap_attribute				\
-			target_core_dev_snap_attr_##_name =		\
-	__CONFIGFS_EATTR(_name, _mode,					\
-	target_core_dev_snap_show_attr_##_name,				\
-	target_core_dev_snap_store_attr_##_name);
-
-#define DEF_SNAP_ATTRIB_STR_SHOW(_name)					\
-static ssize_t target_core_dev_snap_show_attr_##_name(			\
-	struct se_subsystem_dev *se_dev,				\
-	char *page)							\
-{									\
-	return snprintf(page, PAGE_SIZE, "%s\n", SE_DEV_SNAP(se_dev)->_name); \
-}
-
-#define DEF_SNAP_ATTRIB_STR_STORE(_name, _max)				\
-static ssize_t target_core_dev_snap_store_attr_##_name(			\
-	struct se_subsystem_dev *se_dev,				\
-	const char *page,						\
-	size_t count)							\
-{									\
-	if (strlen(page) > _max) {					\
-		printk(KERN_ERR "String length for attrib: %s exceeds max:" \
-			" %d\n", __stringify(_name), _max);		\
-		return -EINVAL;						\
-	}								\
-	snprintf(SE_DEV_SNAP(se_dev)->_name, PAGE_SIZE, "%s", page);	\
-	return count;							\
-}
-
-#define DEF_SNAP_ATTRIB_STR(_name, _max)				\
-DEF_SNAP_ATTRIB_STR_SHOW(_name)						\
-DEF_SNAP_ATTRIB_STR_STORE(_name, _max)
-
-#define DEF_SNAP_ATTRIB_INT_SHOW(_name)					\
-static ssize_t target_core_dev_snap_show_attr_##_name(			\
-	struct se_subsystem_dev *se_dev,				\
-	char *page)							\
-{									\
-	return snprintf(page, PAGE_SIZE, "%d\n", SE_DEV_SNAP(se_dev)->_name); \
-}
-
-#define DEF_SNAP_ATTRIB_INT_STORE(_name, _max, _min)			\
-static ssize_t target_core_dev_snap_store_attr_##_name(			\
-	struct se_subsystem_dev *se_dev,				\
-	const char *page,						\
-	size_t count)							\
-{									\
-	int ret;							\
-	unsigned long val;						\
-									\
-	ret = strict_strtoul(page, 0, &val);				\
-	if (ret < 0) {							\
-		printk(KERN_ERR "strict_strtoul() failed for %s with"	\
-			" ret: %d\n", __stringify(_name), ret);		\
-		return -EINVAL;						\
-	}								\
-	if ((_max != 0) && (val > _max)) {				\
-		printk(KERN_ERR "snap attribute: %s exceeds max: %d\n",	\
-				__stringify(_name), _max);		\
-		return -EINVAL;						\
-	}								\
-	if (val < _min) {						\
-		printk(KERN_ERR "snap attribute: %s less than min: %d\n", \
-				__stringify(_name), _min);		\
-		return -EINVAL;						\
-	}								\
-	SE_DEV_SNAP(se_dev)->_name = (int)val;				\
-	return count;							\
-}
-
-#define DEF_SNAP_ATTRIB_INT(_name, _max, _min)				\
-DEF_SNAP_ATTRIB_INT_SHOW(_name)						\
-DEF_SNAP_ATTRIB_INT_STORE(_name, _max, _min)
-
-DEF_SNAP_ATTRIB_STR(contact, SNAP_CONTACT_LEN);
-SE_DEV_SNAP_ATTR(contact, S_IRUGO | S_IWUSR);
-
-DEF_SNAP_ATTRIB_STR(lv_group, SNAP_GROUP_LEN);
-SE_DEV_SNAP_ATTR(lv_group, S_IRUGO | S_IWUSR);
-
-DEF_SNAP_ATTRIB_STR(lvc_size, SNAP_LVC_LEN);
-SE_DEV_SNAP_ATTR(lvc_size, S_IRUGO | S_IWUSR);
-
-DEF_SNAP_ATTRIB_INT(pid, 0, 0);
-SE_DEV_SNAP_ATTR(pid, S_IRUGO | S_IWUSR);
-
-DEF_SNAP_ATTRIB_INT(enabled, 1, 0);
-SE_DEV_SNAP_ATTR(enabled, S_IRUGO | S_IWUSR);
-
-DEF_SNAP_ATTRIB_INT(permissions, 1, 0);
-SE_DEV_SNAP_ATTR(permissions, S_IRUGO | S_IWUSR);
-
-/* Max number of snapshots to rotate */
-DEF_SNAP_ATTRIB_INT(max_snapshots, 256, 1);
-SE_DEV_SNAP_ATTR(max_snapshots, S_IRUGO | S_IWUSR);
-
-/* Max minutes for warning emails about usage */
-DEF_SNAP_ATTRIB_INT(max_warn, 60, 0);
-SE_DEV_SNAP_ATTR(max_warn, S_IRUGO | S_IWUSR);
-
-/* 15 Minute max, 5 second min */
-DEF_SNAP_ATTRIB_INT(check_interval, 900, 5);
-SE_DEV_SNAP_ATTR(check_interval, S_IRUGO | S_IWUSR);
-
-/* One 7-day week max, 1 minute min */
-DEF_SNAP_ATTRIB_INT(create_interval, 604800, 60);
-SE_DEV_SNAP_ATTR(create_interval, S_IRUGO | S_IWUSR);
-
-/* Snapshot usage */
-DEF_SNAP_ATTRIB_INT(usage, 100, 0);
-SE_DEV_SNAP_ATTR(usage, S_IRUGO | S_IWUSR);
-
-/* Snapshot usage before sending warning */
-DEF_SNAP_ATTRIB_INT(usage_warn, 100, 0);
-SE_DEV_SNAP_ATTR(usage_warn, S_IRUGO | S_IWUSR);
-
-/* Volume group usage before sending warning */
-DEF_SNAP_ATTRIB_INT(vgs_usage_warn, 100, 0);
-SE_DEV_SNAP_ATTR(vgs_usage_warn, S_IRUGO | S_IWUSR);
-
-CONFIGFS_EATTR_OPS(target_core_dev_snap, se_subsystem_dev, se_dev_snap_group);
-
-static struct configfs_attribute *target_core_dev_snap_attrs[] = {
-	&target_core_dev_snap_attr_contact.attr,
-	&target_core_dev_snap_attr_lv_group.attr,
-	&target_core_dev_snap_attr_lvc_size.attr,
-	&target_core_dev_snap_attr_pid.attr,
-	&target_core_dev_snap_attr_enabled.attr,
-	&target_core_dev_snap_attr_permissions.attr,
-	&target_core_dev_snap_attr_max_snapshots.attr,
-	&target_core_dev_snap_attr_max_warn.attr,
-	&target_core_dev_snap_attr_check_interval.attr,
-	&target_core_dev_snap_attr_create_interval.attr,
-	&target_core_dev_snap_attr_usage.attr,
-	&target_core_dev_snap_attr_usage_warn.attr,
-	&target_core_dev_snap_attr_vgs_usage_warn.attr,
-	NULL,
-};
-
-static struct configfs_item_operations target_core_dev_snap_ops = {
-	.show_attribute		= target_core_dev_snap_attr_show,
-	.store_attribute	= target_core_dev_snap_attr_store,
-};
-
-static struct config_item_type target_core_dev_snap_cit = {
-	.ct_item_ops		= &target_core_dev_snap_ops,
-	.ct_attrs		= target_core_dev_snap_attrs,
-	.ct_owner		= THIS_MODULE,
-};
-
-/* End functions for struct config_item type target_core_dev_snap_cit */
-
 /*  Start functions for struct config_item_type target_core_dev_cit */
 
 static ssize_t target_core_show_dev_info(void *p, char *page)
@@ -2872,18 +2716,15 @@ static struct config_group *target_core_
 			&target_core_dev_attrib_cit);
 	config_group_init_type_name(&se_dev->se_dev_pr_group, "pr",
 			&target_core_dev_pr_cit);
-	config_group_init_type_name(&se_dev->se_dev_snap_group, "snap",
-			&target_core_dev_snap_cit);
 	config_group_init_type_name(&se_dev->t10_wwn.t10_wwn_group, "wwn",
 			&target_core_dev_wwn_cit);
 	config_group_init_type_name(&se_dev->t10_alua.alua_tg_pt_gps_group,
 			"alua", &target_core_alua_tg_pt_gps_cit);
 	dev_cg->default_groups[0] = &se_dev->se_dev_attrib.da_group;
 	dev_cg->default_groups[1] = &se_dev->se_dev_pr_group;
-	dev_cg->default_groups[2] = &se_dev->se_dev_snap_group;
-	dev_cg->default_groups[3] = &se_dev->t10_wwn.t10_wwn_group;
-	dev_cg->default_groups[4] = &se_dev->t10_alua.alua_tg_pt_gps_group;
-	dev_cg->default_groups[5] = NULL;
+	dev_cg->default_groups[2] = &se_dev->t10_wwn.t10_wwn_group;
+	dev_cg->default_groups[3] = &se_dev->t10_alua.alua_tg_pt_gps_group;
+	dev_cg->default_groups[4] = NULL;
 	/*
 	 * Add core/$HBA/$DEV/alua/tg_pt_gps/default_tg_pt_gp
 	 */
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-25 08:53:17.774272876 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-25 08:53:47.000000000 +0100
@@ -688,25 +688,6 @@ struct se_dev_attrib {
 	struct config_group da_group;
 } ____cacheline_aligned;
 
-struct se_dev_snap_attrib {
-#define SNAP_CONTACT_LEN		128
-	unsigned char	contact[SNAP_CONTACT_LEN];
-#define SNAP_GROUP_LEN			128
-	unsigned char	lv_group[SNAP_GROUP_LEN];
-#define SNAP_LVC_LEN			32
-	unsigned char	lvc_size[SNAP_LVC_LEN];
-	pid_t		pid;
-	int		enabled;
-	int		permissions;
-	int		max_snapshots;
-	int		max_warn;
-	int		check_interval;
-	int		create_interval;
-	int		usage;
-	int		usage_warn;
-	int		vgs_usage_warn;
-} ____cacheline_aligned;
-
 struct se_subsystem_dev {
 /* Used for struct se_subsystem_dev-->se_dev_alias, must be less than PAGE_SIZE */
 #define SE_DEV_ALIAS_LEN		512
@@ -718,7 +699,6 @@ struct se_subsystem_dev {
 	struct se_hba *se_dev_hba;
 	struct se_device *se_dev_ptr;
 	struct se_dev_attrib se_dev_attrib;
-	struct se_dev_snap_attrib se_snap_attrib;
 	/* T10 Asymmetric Logical Unit Assignment for Target Ports */
 	struct t10_alua	t10_alua;
 	/* T10 Inquiry and VPD WWN Information */
@@ -731,11 +711,8 @@ struct se_subsystem_dev {
 	struct config_group se_dev_group;
 	/* For T10 Reservations */
 	struct config_group se_dev_pr_group;
-	/* For userspace lvm utils */
-	struct config_group se_dev_snap_group;
 } ____cacheline_aligned;
 
-#define SE_DEV_SNAP(su_dev)	(&(su_dev)->se_snap_attrib)
 #define T10_ALUA(su_dev)	(&(su_dev)->t10_alua)
 #define T10_RES(su_dev)		(&(su_dev)->t10_reservation)
 #define T10_PR_OPS(su_dev)	(&(su_dev)->t10_reservation.pr_ops)
