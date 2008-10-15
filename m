From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert iSCSI Target Portal Group
	attributes to use configfs.h macros
Date: Tue, 14 Oct 2008 19:34:55 -0700
Message-ID: <1224038095.5556.115.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-D8QS6q2wN/EfO0NHPQ7F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:42078 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751034AbYJOCe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 22:34:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


--=-D8QS6q2wN/EfO0NHPQ7F
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Following in line with commit:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=ceae11470d537dbaf10575f3238bb4fce81333ef

convert all iSCSI TPG attributes to use CONFIGFS_ATTR_STRUCT(), __CONFIGFS_ATTR()
and CONFIGFS_ATTR_OPS() from include/linux/configfs.h to instead of using internal
->show() / ->store() with struct lio_target_configfs_attribute.

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/iscsi_target_configfs.c |  141 +++++++++++++++++-------------
 drivers/lio-core/iscsi_target_core.h     |    3 +-
 drivers/lio-core/iscsi_target_tpg.c      |    2 +
 3 files changed, 85 insertions(+), 61 deletions(-)


--=-D8QS6q2wN/EfO0NHPQ7F
Content-Disposition: attachment; filename=0001-LIO-Target-ConfigFS-Convert-iSCSI-Target-Portal-G.patch
Content-Type: application/mbox; name=0001-LIO-Target-ConfigFS-Convert-iSCSI-Target-Portal-G.patch
Content-Transfer-Encoding: 7bit

>From ea94e8e4268e74e9d6e1e871fceafd611ec65d89 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 14 Oct 2008 19:29:05 -0700
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert iSCSI Target Portal Group attributes to use configfs.h macros

Following in line with commit:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=ceae11470d537dbaf10575f3238bb4fce81333ef

convert all iSCSI TPG attributes to use CONFIGFS_ATTR_STRUCT(), __CONFIGFS_ATTR()
and CONFIGFS_ATTR_OPS() from include/linux/configfs.h to instead of using internal
->show() / ->store() with struct lio_target_configfs_attribute.

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/iscsi_target_configfs.c |  141 +++++++++++++++++-------------
 drivers/lio-core/iscsi_target_core.h     |    3 +-
 drivers/lio-core/iscsi_target_tpg.c      |    2 +
 3 files changed, 85 insertions(+), 61 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index c2b0eb6..fc864c3 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -1472,13 +1472,13 @@ static struct config_item_type lio_target_acl_cit = {
 
 // Start items for lio_target_tpg_attrib_cit
 
-#define SHOW_TPG_ATTRIB(name)						\
+#define DEF_TPG_ATTRIB(name)						\
 									\
 static ssize_t lio_target_show_tpg_attrib_##name (			\
-	void *p,							\
+	struct iscsi_tpg_attrib_s *ta,					\
 	char *page)							\
 {									\
-	iscsi_portal_group_t *tpg, *tpg_p = (iscsi_portal_group_t *)p;	\
+	iscsi_portal_group_t *tpg, *tpg_p = ta->tpg;			\
 	iscsi_tiqn_t *tiqn;						\
 	ssize_t rb;							\
 									\
@@ -1489,16 +1489,14 @@ static ssize_t lio_target_show_tpg_attrib_##name (			\
 	rb = sprintf(page, "%u\n", ISCSI_TPG_ATTRIB(tpg)->name);	\
 	iscsi_put_tpg(tpg);						\
 	return(rb);							\
-}
-
-#define STORE_TPG_ATTRIB(name)						\
+}									\
 									\
 static ssize_t lio_target_store_tpg_attrib_##name (			\
-	void *p,							\
+	struct iscsi_tpg_attrib_s *ta,					\
 	const char *page,						\
 	size_t count)							\
 {									\
-	iscsi_portal_group_t *tpg, *tpg_p = (iscsi_portal_group_t *)p;	\
+	iscsi_portal_group_t *tpg, *tpg_p = ta->tpg;			\
 	iscsi_tiqn_t *tiqn;						\
 	char *endptr;							\
 	u32 val;							\
@@ -1519,69 +1517,89 @@ out:									\
 	return(ret);							\
 }
 
-#define DEF_TPG_ATTRIB(name)						\
-	SHOW_TPG_ATTRIB(name)						\
-	STORE_TPG_ATTRIB(name)						\
-									\
-static struct lio_target_configfs_attribute lio_target_attr_tpg_##name = { \
-	.attr	= { .ca_owner = THIS_MODULE,				\
-		    .ca_name = __stringify(name),			\
-		    .ca_mode =  S_IRUGO | S_IWUSR },			\
-	.show	= lio_target_show_tpg_attrib_##name,			\
-	.store	= lio_target_store_tpg_attrib_##name,			\
-};
+static struct iscsi_tpg_attrib_s *to_iscsi_tpg_attrib_s (struct config_item *item)
+{
+	return((item) ? container_of(to_config_group(item), struct iscsi_tpg_attrib_s,
+		tpg_attrib_group) : NULL);	
+}
 
+/*
+ * Define the iSCSI TPG attributes using hybrid wrappers from include/linux/configfs.h
+ */
+CONFIGFS_ATTR_STRUCT(iscsi_tpg_attrib_s);
+#define TPG_ATTR(_name, _mode, _show, _store)				\
+static struct iscsi_tpg_attrib_s_attribute iscsi_tpg_attrib_s_##_name =	\
+	__CONFIGFS_ATTR(_name, _mode, _show, _store)
+
+/*
+ * Define iscsi_tpg_attrib_s_authentication
+ */
 DEF_TPG_ATTRIB(authentication);
+TPG_ATTR(authentication, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_authentication,
+	lio_target_store_tpg_attrib_authentication);
+/*
+ * Define iscsi_tpg_attrib_s_login_timeout
+ */
 DEF_TPG_ATTRIB(login_timeout);
+TPG_ATTR(login_timeout, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_login_timeout,
+	lio_target_store_tpg_attrib_login_timeout);
+/*
+ * Define iscsi_tpg_attrib_s_netif_timeout
+ */
 DEF_TPG_ATTRIB(netif_timeout);
+TPG_ATTR(netif_timeout, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_netif_timeout,
+	lio_target_store_tpg_attrib_netif_timeout);
+/*
+ * Define iscsi_tpg_attrib_s_generate_node_acls
+ */
 DEF_TPG_ATTRIB(generate_node_acls);
+TPG_ATTR(generate_node_acls, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_generate_node_acls,
+	lio_target_store_tpg_attrib_generate_node_acls);
+/*
+ * Define iscsi_tpg_attrib_s_default_cmdsn_depth
+ */
 DEF_TPG_ATTRIB(default_cmdsn_depth);
+TPG_ATTR(default_cmdsn_depth, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_default_cmdsn_depth,
+	lio_target_store_tpg_attrib_default_cmdsn_depth);
+/*
+ Define iscsi_tpg_attrib_scache_dynamic_acls
+ */
 DEF_TPG_ATTRIB(cache_dynamic_acls);
+TPG_ATTR(cache_dynamic_acls, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_cache_dynamic_acls,
+	lio_target_store_tpg_attrib_cache_dynamic_acls);
+/*
+ * Define iscsi_tpg_attrib_sdemo_mode_lun_access
+ */
 DEF_TPG_ATTRIB(demo_mode_lun_access);
+TPG_ATTR(demo_mode_lun_access, S_IRUGO | S_IWUSR,
+	lio_target_show_tpg_attrib_demo_mode_lun_access,
+	lio_target_store_tpg_attrib_demo_mode_lun_access);
+
+/*
+ * Finally, define functions iscsi_tpg_attrib_s_attr_show() and
+ * iscsi_tpg_attrib_s_attr_store() for lio_target_tpg_attrib_ops below..
+ */
+CONFIGFS_ATTR_OPS(iscsi_tpg_attrib_s);
 
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
-	&lio_target_attr_tpg_authentication.attr,
-	&lio_target_attr_tpg_login_timeout.attr,
-	&lio_target_attr_tpg_netif_timeout.attr,
-	&lio_target_attr_tpg_generate_node_acls.attr,
-	&lio_target_attr_tpg_default_cmdsn_depth.attr,
-	&lio_target_attr_tpg_cache_dynamic_acls.attr,
-	&lio_target_attr_tpg_demo_mode_lun_access.attr,
+	&iscsi_tpg_attrib_s_authentication.attr,
+	&iscsi_tpg_attrib_s_login_timeout.attr,
+	&iscsi_tpg_attrib_s_netif_timeout.attr,
+	&iscsi_tpg_attrib_s_generate_node_acls.attr,
+	&iscsi_tpg_attrib_s_default_cmdsn_depth.attr,
+	&iscsi_tpg_attrib_s_cache_dynamic_acls.attr,
+	&iscsi_tpg_attrib_s_demo_mode_lun_access.attr,
 };
 
-static ssize_t lio_target_tpg_attr_show (struct config_item *item,
-				       struct configfs_attribute *attr,
-				       char *page)
-{
-	iscsi_portal_group_t *tpg = container_of(to_config_group(item),
-			iscsi_portal_group_t, tpg_attrib_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->show))
-		return(-EINVAL);
-
-	return(lt_attr->show((void *)tpg, page));
-}
-
-static ssize_t lio_target_tpg_attr_store (struct config_item *item,
-					struct configfs_attribute *attr,
-					const char *page, size_t count)
-{
-	iscsi_portal_group_t *tpg = container_of(to_config_group(item),
-			iscsi_portal_group_t, tpg_attrib_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->store))
-		return(-EINVAL);
-
-	return(lt_attr->store((void *)tpg, page, count));
-}
-
 static struct configfs_item_operations lio_target_tpg_attrib_ops = {
-	.show_attribute		= lio_target_tpg_attr_show,
-	.store_attribute	= lio_target_tpg_attr_store,
+	.show_attribute		= iscsi_tpg_attrib_s_attr_show,
+	.store_attribute	= iscsi_tpg_attrib_s_attr_store,
 };
 
 static struct config_item_type lio_target_tpg_attrib_cit = {
@@ -1727,6 +1745,7 @@ static struct config_group *lio_target_tiqn_addtpg (
 {
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
+	iscsi_tpg_attrib_t *tattr;
 	struct config_group *tpg_cg;
 	struct config_item *tiqn_ci;
 	char *tpgt_str, *end_ptr;
@@ -1764,14 +1783,16 @@ static struct config_group *lio_target_tiqn_addtpg (
 			GFP_KERNEL)))
 		goto out;
 
+	tattr = &tpg->tpg_attrib;
+
 	config_group_init_type_name(&tpg->tpg_np_group, "np", &lio_target_np_cit);
 	config_group_init_type_name(&tpg->tpg_lun_group, "lun", &lio_target_lun_cit);
 	config_group_init_type_name(&tpg->tpg_acl_group, "acls", &lio_target_acl_cit);
-	config_group_init_type_name(&tpg->tpg_attrib_group, "attrib", &lio_target_tpg_attrib_cit);
+	config_group_init_type_name(&tattr->tpg_attrib_group, "attrib", &lio_target_tpg_attrib_cit);
 	tpg_cg->default_groups[0] = &tpg->tpg_np_group;
 	tpg_cg->default_groups[1] = &tpg->tpg_lun_group;
 	tpg_cg->default_groups[2] = &tpg->tpg_acl_group;
-	tpg_cg->default_groups[3] = &tpg->tpg_attrib_group;	
+	tpg_cg->default_groups[3] = &tattr->tpg_attrib_group;	
 	tpg_cg->default_groups[4] = NULL;
 
 	if ((ret = iscsi_tpg_add_portal_group(tiqn, tpg)) < 0)
diff --git a/drivers/lio-core/iscsi_target_core.h b/drivers/lio-core/iscsi_target_core.h
index 623f023..2df1972 100644
--- a/drivers/lio-core/iscsi_target_core.h
+++ b/drivers/lio-core/iscsi_target_core.h
@@ -1225,6 +1225,8 @@ typedef struct iscsi_tpg_attrib_s {
 	u32			default_cmdsn_depth;
 	u32			demo_mode_lun_access;
 	u32			cache_core_nps;
+	struct iscsi_portal_group_s *tpg;
+	struct config_group	tpg_attrib_group;
 }  ____cacheline_aligned iscsi_tpg_attrib_t;
 
 typedef struct se_lun_s {
@@ -1332,7 +1334,6 @@ typedef struct iscsi_portal_group_s {
 	se_lun_t		*tpg_lun_list;
 	iscsi_node_acl_t	*acl_node_head;	/* Pointer to start of Initiator ACL list */
 	iscsi_node_acl_t	*acl_node_tail;	/* Pointer to end of Initiator ACL list */
-	struct config_group	tpg_attrib_group;
 	struct config_group	tpg_np_group;
 	struct config_group	tpg_lun_group;
 	struct config_group	tpg_acl_group;
diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index 598825d..c41c22c 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -640,6 +640,8 @@ extern int iscsi_tpg_add_portal_group (iscsi_tiqn_t *tiqn, iscsi_portal_group_t
 	spin_lock_init(&tpg->tpg_lun_lock);
 	spin_lock_init(&tpg->tpg_np_lock);
 
+	ISCSI_TPG_ATTRIB(tpg)->tpg = tpg;
+
 	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
 		lun = &tpg->tpg_lun_list[i];
 		lun->iscsi_lun = i;
-- 
1.5.4.1


--=-D8QS6q2wN/EfO0NHPQ7F--

