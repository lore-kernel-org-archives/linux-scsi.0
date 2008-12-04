From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] [LIO-Target/ConfigFS]: Add Target Portal Group
	*_write_protect attributes and iSCSI LUN ACL write_protect bit
Date: Wed, 03 Dec 2008 20:35:13 -0800
Message-ID: <1228365313.4153.108.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24672 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755192AbYLDEfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 23:35:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 6c25f12e9bae4a289080327002795352fa5856e4 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 3 Dec 2008 18:58:14 -0800
Subject: [PATCH] [LIO-Target/ConfigFS]: Add Target Portal Group *_write_protect attributes and iSCSI LUN ACL write_protect bit

This patch adds demo_mode_write_protect and prod_mode_write_protect TPG attributes
to /sys/kernel/config/target/iscsi/$IQN/$TPGT/attrib, here is what the current list
of TPG attributes for LIO-Target v3.0 looks like with tree $CONFIGFS

<SNIP>

    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    |   |   `-- tpgt_1
    |   |       |-- attrib
    |   |       |   |-- authentication
    |   |       |   |-- cache_dynamic_acls
    |   |       |   |-- default_cmdsn_depth
    |   |       |   |-- demo_mode_write_protect
    |   |       |   |-- generate_node_acls
    |   |       |   |-- login_timeout
    |   |       |   |-- netif_timeout
    |   |       |   `-- prod_mode_write_protect

And the new write_protect bit for the iSCSI Initiator LUN ACLs:

<SNIP>

    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    |   |   `-- tpgt_1
    |   |       |-- acls
    |   |       |   |-- iqn.1993-08.org.debian:01:2dadf92d
    |   |       |   |   |-- lun_0
    |   |       |   |   |   |-- lun_0 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:s
n.e475ed6fcdd0/tpgt_1/lun/lun_0
    |   |       |   |   |   `-- write_protect
    |   |       |   |   |-- lun_1
    |   |       |   |   |   |-- lun_1 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:s
n.e475ed6fcdd0/tpgt_1/lun/lun_1
    |   |       |   |   |   `-- write_protect

This patch adds a struct iscsi_node_acl_s pointer at struct se_lun_acl_s->se_lun_nacl,
which is used to retrieve the iscsi_node_acl_s pointer in lacl_show_attrib_write_protect()
and lacl_store_attrib_write_protect().

Also, this patch has been tested with both production mode (generate_node_acls=0) with
explictly defined ACLs, and demo mode (genreate_node_acls=1) with making dynamic ACLs into
explict ones with active iSCSI sessions.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |  120 +++++++++++++++++++++++------
 drivers/lio-core/target_core_base.h      |    1 +
 2 files changed, 96 insertions(+), 25 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 0a9b902..e62667b 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -908,10 +908,10 @@ static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struc
 {
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
+	se_dev_entry_t *deve;
 	se_lun_t *lun;
 	se_lun_acl_t *lacl;
 	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *tiqn_ci, *tiqn_ci_s;
-	char *ro_ptr = NULL;
 	int ret = 0, lun_access;
 	unsigned short int tpgt;
 
@@ -968,13 +968,21 @@ static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struc
 	if (!(tpg = core_get_tpg_from_iqn(config_item_name(tiqn_ci),
 				&tiqn, tpgt, 0)))
 		return(-EINVAL);
-#if 0
-	if ((ro_ptr = strstr(buf, ":RO"))) {
-		*ro_ptr = '\0'; // Terminate : for simple_strtoul() below..
-		lun_access = ISCSI_LUNFLAGS_READ_ONLY;
-	} else
-#endif
-		lun_access = ISCSI_LUNFLAGS_READ_WRITE;
+
+	/*
+	 * If this iscsi_node_acl was dynamically generated with
+	 * tpg_1/attrib/generate_node_acls=1, use the existing deve->lun_flags,
+	 * which be will write protected (READ-ONLY) when 
+	 * tpg_1/attrib/demo_mode_write_protect=1
+	 */
+	spin_lock_bh(&lacl->se_lun_nacl->device_list_lock);
+	deve = &lacl->se_lun_nacl->device_list[lacl->mapped_lun];
+	if (deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS)
+		lun_access = deve->lun_flags;
+	else
+		lun_access = (ISCSI_TPG_ATTRIB(tpg)->prod_mode_write_protect) ?
+			ISCSI_LUNFLAGS_READ_ONLY : ISCSI_LUNFLAGS_READ_WRITE;
+	spin_unlock_bh(&lacl->se_lun_nacl->device_list_lock);
 
 	/*
 	 * Determine the actual mapped LUN value user wants..
@@ -987,8 +995,9 @@ static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struc
 		goto out;
 
 	printk("LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: %s TPG LUN: %s"
-		" Mapped LUN: %s %s\n", lacl->initiatorname, config_item_name(lun_ci),
-		config_item_name(lun_acl_ci), (ro_ptr) ? "READ-ONLY" : "READ-WRITE");
+		" Mapped LUN: %s Write Protect: %s\n", lacl->initiatorname,
+		config_item_name(lun_ci), config_item_name(lun_acl_ci),
+		(lun_access & ISCSI_LUNFLAGS_READ_ONLY) ? "ON" : "OFF");
 
 	iscsi_put_tpg(tpg);
 	return(0);
@@ -1049,16 +1058,76 @@ out:
 	return(ret);
 }
 
+/*
+ * Define the LUN ACL Attributes using configfs extended attributes.
+ */
+CONFIGFS_EATTR_STRUCT(lio_target_lacl, se_lun_acl_s);
+#define LACL_ATTR(_name, _mode)					\
+static struct lio_target_lacl_attribute lacl_attrib_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,				\
+	lacl_show_attrib_##_name,				\
+	lacl_store_attrib_##_name);
+
+static ssize_t lacl_show_attrib_write_protect (
+	struct se_lun_acl_s *lacl,
+	char *page)
+{
+	iscsi_node_acl_t *nacl = lacl->se_lun_nacl;
+	se_dev_entry_t *deve;
+	ssize_t len;
+
+	spin_lock_bh(&nacl->device_list_lock);
+	deve = &nacl->device_list[lacl->mapped_lun];
+	len = sprintf(page, "%d\n", (deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY) ?
+				   1 : 0);
+	spin_unlock_bh(&nacl->device_list_lock);
+
+	return(len);	
+}
+
+static ssize_t lacl_store_attrib_write_protect (
+	struct se_lun_acl_s *lacl,
+	const char *page,
+	size_t count)
+{
+	char *endptr;
+	u32 op;
+
+	op = simple_strtoul(page, &endptr, 0);
+	if ((op != 1) && (op != 0)) {
+		printk(KERN_ERR "Illegal value for access: %u\n", op);
+		return(-EINVAL);
+	}
+	iscsi_update_device_list_access(lacl->mapped_lun, (op) ?
+			ISCSI_LUNFLAGS_READ_ONLY : ISCSI_LUNFLAGS_READ_WRITE,
+			lacl->se_lun_nacl);
+
+	printk("LIO_Target_ConfigFS: Changed Initiator ACL: %s Mapped LUN: %u"
+		" Write Protect bit to %s\n", lacl->initiatorname,
+		lacl->mapped_lun, (op) ? "ON" : "OFF");
+
+	return(count);
+}
+
+LACL_ATTR(write_protect, S_IRUGO | S_IWUSR);
+
+CONFIGFS_EATTR_OPS(lio_target_lacl, se_lun_acl_s, se_lun_group)
+
+static struct configfs_attribute *lio_target_initiator_lacl_attrs[] = {
+	&lacl_attrib_write_protect.attr,
+	NULL,
+};
+
 static struct configfs_item_operations lio_target_initiator_lacl_item_ops = {
-	.show_attribute		= NULL,
-	.store_attribute	= NULL,
+	.show_attribute		= lio_target_lacl_attr_show,
+	.store_attribute	= lio_target_lacl_attr_store,
 	.allow_link		= lio_target_initiator_lacl_link,
 	.drop_link		= lio_target_initiator_lacl_unlink,
 };
 
 static struct config_item_type lio_target_initiator_lacl_cit = {
 	.ct_item_ops		= &lio_target_initiator_lacl_item_ops,
-//	.ct_attrs		= lio_target_initiator_lacl_attrs,
+	.ct_attrs		= lio_target_initiator_lacl_attrs,
 	.ct_owner		= THIS_MODULE,
 };
 
@@ -1638,15 +1707,21 @@ TPG_ATTR(generate_node_acls, S_IRUGO | S_IWUSR);
 DEF_TPG_ATTRIB(default_cmdsn_depth);
 TPG_ATTR(default_cmdsn_depth, S_IRUGO | S_IWUSR);
 /*
- Define iscsi_tpg_attrib_scache_dynamic_acls
+ Define iscsi_tpg_attrib_s_cache_dynamic_acls
  */
 DEF_TPG_ATTRIB(cache_dynamic_acls);
 TPG_ATTR(cache_dynamic_acls, S_IRUGO | S_IWUSR);
 /*
- * Define iscsi_tpg_attrib_sdemo_mode_lun_access
+ * Define iscsi_tpg_attrib_s_demo_mode_write_protect
  */
-DEF_TPG_ATTRIB(demo_mode_lun_access);
-TPG_ATTR(demo_mode_lun_access, S_IRUGO | S_IWUSR);
+DEF_TPG_ATTRIB(demo_mode_write_protect);
+TPG_ATTR(demo_mode_write_protect, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_prod_mode_write_protect
+ */
+DEF_TPG_ATTRIB(prod_mode_write_protect);
+TPG_ATTR(prod_mode_write_protect, S_IRUGO | S_IWUSR);
+
 /*
  * Finally, define functions iscsi_tpg_attrib_s_attr_show() and
  * iscsi_tpg_attrib_s_attr_store() for lio_target_tpg_attrib_ops below..
@@ -1660,7 +1735,8 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_generate_node_acls.attr,
 	&iscsi_tpg_attrib_default_cmdsn_depth.attr,
 	&iscsi_tpg_attrib_cache_dynamic_acls.attr,
-	&iscsi_tpg_attrib_demo_mode_lun_access.attr,
+	&iscsi_tpg_attrib_demo_mode_write_protect.attr,
+	&iscsi_tpg_attrib_prod_mode_write_protect.attr,
 	NULL,
 };
 
@@ -1698,7 +1774,7 @@ static ssize_t lio_target_show_tpg_param_##name (			\
 		iscsi_put_tpg(tpg);					\
 		return(-EINVAL);					\
 	}								\
-	rb = snprintf(page, PAGE_SIZE, "%s\n", param->value);		\ 
+	rb = snprintf(page, PAGE_SIZE, "%s\n", param->value);		\
 									\
 	iscsi_put_tpg(tpg);						\
 	return(rb);							\
@@ -1890,12 +1966,6 @@ static ssize_t lio_target_store_tpg_enable (void *p, const char *page, size_t co
 		return(-EINVAL);
 
 	if (op) {
-//#warning WARNING: enabletpg uses #warning Currently uses generate_node_acls=1,cache_dynamic_acls=1,demo_mode_lun_access=1
-#if 0
-		ISCSI_TPG_ATTRIB(tpg)->generate_node_acls = 1;
-		ISCSI_TPG_ATTRIB(tpg)->cache_dynamic_acls = 1;
-		ISCSI_TPG_ATTRIB(tpg)->demo_mode_lun_access = 1;
-#endif
 		if ((ret = iscsi_tpg_enable_portal_group(tpg)) < 0)
 			goto out;
 	} else {
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index b866613..f280264 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -302,6 +302,7 @@ struct scatterlist;
 typedef struct se_lun_acl_s {
 	char			initiatorname[ISCSI_IQN_LEN];
 	u32			mapped_lun;
+	struct iscsi_node_acl_s *se_lun_nacl;
 	struct se_lun_s		*iscsi_lun;
 	struct se_lun_acl_s	*next;
 	struct se_lun_acl_s	*prev;
-- 
1.5.4.1



