From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/ConfigFS 14/14]: Convert to use generic
	target_core_mod v3.0 logic
Date: Fri, 19 Dec 2008 15:38:28 -0800
Message-ID: <1229729908.4560.128.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:22920 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751891AbYLSXjD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:39:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>

>From 32da6bbe407bb242e7fba2c8b2f7e164e1ac2038 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:45:45 -0800
Subject: [PATCH] [LIO-Target/ConfigFS]: Convert to use generic target_core_mod v3.0 logic

This patch converts the following ConfigFS code to use logic that is
now generic in Target_Core_Mod v3.0

iscsi_dev_add_lun() -> core_dev_add_lun()
iscsi_dev_del_lun() -> core_dev_del_lun()
iscsi_get_lun_from_tpg() -> core_get_lun_from_tpg()
iscsi_dev_add_initiator_node_lun_acl() -> core_dev_add_initiator_node_lun_acl()
iscsi_dev_del_initiator_node_lun_acl() -> core_dev_del_initiator_node_lun_acl()
iscsi_update_device_list_access() -> core_update_device_list_access()
iscsi_dev_init_initiator_node_lun_acl() -> core_dev_init_initiator_node_lun_acl()
iscsi_dev_free_initiator_node_lun_acl() -> core_dev_free_initiator_node_lun_acl()

It also converts DEF_NACL_PARAM(), lacl_[store,show]_attrib_*(), and
lio_target_initiator_nacl_*() to use se_node_acl_t.

Also in iscsi_target_register_configfs(), updated usage of struct target_core_fabric_ops
function pointers.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |  157 +++++++++++++++++-------------
 1 files changed, 90 insertions(+), 67 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 4699502..6e71822 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -33,10 +33,14 @@
 #include <iscsi_linux_os.h>
 #include <iscsi_linux_defs.h>
 
-#include <iscsi_debug.h>
-#include <iscsi_lists.h>
+#include <target_core_base.h>
+#include <target_core_transport.h>
+#include <target_core_fabric_ops.h>
+#include <target_core_device.h>
+#include <target_core_configfs.h>
+#include <configfs_macros.h>
+
 #include <iscsi_protocol.h>
-#include <iscsi_debug_opcodes.h>
 #include <iscsi_target_core.h>
 #include <target_core_base.h>
 #include <iscsi_target_error.h>
@@ -45,16 +49,11 @@
 #include <iscsi_target_nodeattrib.h>
 #include <iscsi_target_tpg.h>
 #include <iscsi_target_util.h>
-#include <target_core_transport.h>
 #include <iscsi_target.h>
 #ifdef SNMP_SUPPORT
 #include <iscsi_target_mib.h>
 #endif /* SNMP_SUPPORT */
-
-#include <target_core_fabric_ops.h>
-#include <target_core_configfs.h>
 #include <iscsi_target_configfs.h>
-#include <configfs_macros.h>
 
 struct target_fabric_configfs *lio_target_fabric_configfs = NULL;
 
@@ -521,8 +520,9 @@ static int lio_target_port_link (struct config_item *lun_ci, struct config_item
 		goto out;
 	}
 
-	if (!(lun_p = iscsi_dev_add_lun(tpg, dev->iscsi_hba, dev, lun->iscsi_lun, &ret))) {
-		printk(KERN_ERR "iscsi_dev_add_lun() failed: %d\n", ret);
+	if (!(lun_p = core_dev_add_lun(tpg->tpg_se_tpg, dev->se_hba, dev,
+			lun->unpacked_lun, &ret))) {
+		printk(KERN_ERR "core_dev_add_lun() failed: %d\n", ret);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -567,7 +567,7 @@ static int lio_target_port_unlink (struct config_item *lun_ci, struct config_ite
 				&tiqn, tpgt, 0)))
 		return(-EINVAL);
 
-	ret = iscsi_dev_del_lun(tpg, lun->iscsi_lun);
+	ret = core_dev_del_lun(tpg->tpg_se_tpg, lun->unpacked_lun);
 	iscsi_put_tpg(tpg);
 
 	printk("LIO_Target_ConfigFS: Removed Port Symlink %s -> %s\n",
@@ -640,7 +640,7 @@ static struct config_group *lio_target_lun_make_group (
                                 &tiqn, tpgt, 0)))
 		return(NULL);
 
-	if (!(lun_p = iscsi_get_lun_from_tpg(tpg, lun)))
+	if (!(lun_p = core_get_lun_from_tpg(tpg->tpg_se_tpg, lun)))
 		goto out;
 
 	config_group_init_type_name(&lun_p->lun_group, name, &lio_target_port_cit);
@@ -679,7 +679,7 @@ static void lio_target_lun_drop_item (
 		return;
 
 	printk("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu LUN: %u\n",
-			config_item_name(tiqn_ci), tpgt, lun->iscsi_lun);
+		config_item_name(tiqn_ci), tpgt, lun->unpacked_lun);
 
 	config_item_put(item);
 	return;
@@ -814,26 +814,28 @@ static struct config_item_type lio_target_nacl_attrib_cit = {
 
 #define DEF_NACL_PARAM(name)						\
 static ssize_t lio_target_show_nacl_param_##name (			\
-	struct iscsi_node_acl_s *nacl,					\
+	struct se_node_acl_s *se_nacl,					\
 	char *page)							\
 {									\
 	iscsi_session_t *sess;						\
+	se_session_t *se_sess;						\
 	ssize_t rb;							\
 									\
-	spin_lock_bh(&nacl->nacl_sess_lock);				\
-	if (!(sess = nacl->nacl_sess)) {				\
+	spin_lock_bh(&se_nacl->nacl_sess_lock);				\
+	if (!(se_sess = se_nacl->nacl_sess)) {				\
 		rb = snprintf(page, PAGE_SIZE,				\
 			"No Active iSCSI Session\n");			\
 	} else {							\
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;	\
 		rb = snprintf(page, PAGE_SIZE, "%u\n",			\
 			(u32)SESS_OPS(sess)->name);			\
 	}								\
-	spin_unlock_bh(&nacl->nacl_sess_lock);				\
+	spin_unlock_bh(&se_nacl->nacl_sess_lock);			\
 									\
 	return(rb);							\
 }
 
-CONFIGFS_EATTR_STRUCT(iscsi_nacl_param, iscsi_node_acl_s);
+CONFIGFS_EATTR_STRUCT(iscsi_nacl_param, se_node_acl_s);
 #define NACL_PARAM_ATTR(_name)						\
 static struct iscsi_nacl_param_attribute iscsi_nacl_param_##_name =	\
                 __CONFIGFS_EATTR_RO(_name,				\
@@ -872,7 +874,7 @@ NACL_PARAM_ATTR(DataSequenceInOrder);
 DEF_NACL_PARAM(ErrorRecoveryLevel);
 NACL_PARAM_ATTR(ErrorRecoveryLevel);
 
-CONFIGFS_EATTR_OPS_RO(iscsi_nacl_param, iscsi_node_acl_s, acl_param_group);
+CONFIGFS_EATTR_OPS_RO(iscsi_nacl_param, se_node_acl_s, acl_param_group);
 
 static struct configfs_attribute *lio_target_nacl_param_attrs[] = {
 	&iscsi_nacl_param_MaxConnections.attr,
@@ -977,11 +979,11 @@ static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struc
 	 */
 	spin_lock_bh(&lacl->se_lun_nacl->device_list_lock);
 	deve = &lacl->se_lun_nacl->device_list[lacl->mapped_lun];
-	if (deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS)
+	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
 		lun_access = deve->lun_flags;
 	else
 		lun_access = (ISCSI_TPG_ATTRIB(tpg)->prod_mode_write_protect) ?
-			ISCSI_LUNFLAGS_READ_ONLY : ISCSI_LUNFLAGS_READ_WRITE;
+			TRANSPORT_LUNFLAGS_READ_ONLY : TRANSPORT_LUNFLAGS_READ_WRITE;
 	spin_unlock_bh(&lacl->se_lun_nacl->device_list_lock);
 
 	/*
@@ -990,14 +992,14 @@ static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struc
 	 * This value is what the iSCSI Initiator actually sees the
 	 * iscsi/$IQN/$TPGT/lun/lun_* as on their iSCSI Initiator Ports.
 	 */
-	if ((ret = iscsi_dev_add_initiator_node_lun_acl(tpg, lacl,
-				lun->iscsi_lun, lun_access)) < 0)
+	if ((ret = core_dev_add_initiator_node_lun_acl(tpg->tpg_se_tpg, lacl,
+				lun->unpacked_lun, lun_access)) < 0)
 		goto out;
 
 	printk("LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: %s TPG LUN: %s"
 		" Mapped LUN: %s Write Protect: %s\n", lacl->initiatorname,
 		config_item_name(lun_ci), config_item_name(lun_acl_ci),
-		(lun_access & ISCSI_LUNFLAGS_READ_ONLY) ? "ON" : "OFF");
+		(lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ? "ON" : "OFF");
 
 	iscsi_put_tpg(tpg);
 	return(0);
@@ -1045,7 +1047,7 @@ static int lio_target_initiator_lacl_unlink (struct config_item *lun_acl_ci, str
 				&tiqn, tpgt, 0)))
 		return(-EINVAL);
 
-	if ((ret = iscsi_dev_del_initiator_node_lun_acl(tpg, lun, lacl)) < 0)
+	if ((ret = core_dev_del_initiator_node_lun_acl(tpg->tpg_se_tpg, lun, lacl)) < 0)
 		goto out;
 
 	printk("LIO_Target_ConfigFS: Removed Initiator LUN ACL Symlink: %s TPG LUN: %s"
@@ -1072,13 +1074,13 @@ static ssize_t lacl_show_attrib_write_protect (
 	struct se_lun_acl_s *lacl,
 	char *page)
 {
-	iscsi_node_acl_t *nacl = lacl->se_lun_nacl;
+	se_node_acl_t *nacl = lacl->se_lun_nacl;
 	se_dev_entry_t *deve;
 	ssize_t len;
 
 	spin_lock_bh(&nacl->device_list_lock);
 	deve = &nacl->device_list[lacl->mapped_lun];
-	len = sprintf(page, "%d\n", (deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY) ?
+	len = sprintf(page, "%d\n", (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
 				   1 : 0);
 	spin_unlock_bh(&nacl->device_list_lock);
 
@@ -1098,8 +1100,8 @@ static ssize_t lacl_store_attrib_write_protect (
 		printk(KERN_ERR "Illegal value for access: %u\n", op);
 		return(-EINVAL);
 	}
-	iscsi_update_device_list_access(lacl->mapped_lun, (op) ?
-			ISCSI_LUNFLAGS_READ_ONLY : ISCSI_LUNFLAGS_READ_WRITE,
+	core_update_device_list_access(lacl->mapped_lun, (op) ?
+			TRANSPORT_LUNFLAGS_READ_ONLY : TRANSPORT_LUNFLAGS_READ_WRITE,
 			lacl->se_lun_nacl);
 
 	printk("LIO_Target_ConfigFS: Changed Initiator ACL: %s Mapped LUN: %u"
@@ -1188,8 +1190,8 @@ static struct config_group *lio_target_initiator_lacl_make_group (
 	 */
 	mapped_lun = simple_strtoul(ptr, &endptr, 0);
 
-	if (!(lacl = iscsi_dev_init_initiator_node_lun_acl(tpg, mapped_lun,
-				config_item_name(acl_ci), &ret)))
+	if (!(lacl = core_dev_init_initiator_node_lun_acl(tpg->tpg_se_tpg,
+			mapped_lun, config_item_name(acl_ci), &ret)))
 		goto out;
 
 	config_group_init_type_name(&lacl->se_lun_group, name,
@@ -1247,7 +1249,7 @@ static void lio_target_initiator_lacl_drop_item (
 	printk("LIO_Target_ConfigFS: Freeing Initiator LUN ACL: %s Mapped LUN:"
 			" %s\n", lacl->initiatorname, config_item_name(item));
 
-	iscsi_dev_free_initiator_node_lun_acl(tpg, lacl);
+	core_dev_free_initiator_node_lun_acl(tpg->tpg_se_tpg, lacl);
 
 	config_item_put(item);
 	iscsi_put_tpg(tpg);
@@ -1256,17 +1258,20 @@ static void lio_target_initiator_lacl_drop_item (
 
 static ssize_t lio_target_initiator_nacl_info (void *p, char *page)
 {
-	iscsi_node_acl_t *nacl = (iscsi_node_acl_t *)p;
 	iscsi_session_t *sess;
 	iscsi_conn_t *conn;
+	se_node_acl_t *se_nacl = (se_node_acl_t *)p;
+	se_session_t *se_sess;
 	unsigned char *ip, buf_ipv4[IPV4_BUF_SIZE];
 	ssize_t rb = 0;
 
-	spin_lock_bh(&nacl->nacl_sess_lock);
-	if (!(sess = nacl->nacl_sess))
+	spin_lock_bh(&se_nacl->nacl_sess_lock);
+	if (!(se_sess = se_nacl->nacl_sess))
 		rb += sprintf(page+rb, "No active iSCSI Session for Initiator"
-			" Endpoint: %s\n", nacl->initiatorname);
+			" Endpoint: %s\n", se_nacl->initiatorname);
 	else {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+
 		if (SESS_OPS(sess)->InitiatorName)
 			rb += sprintf(page+rb, "InitiatorName: %s\n",
 				SESS_OPS(sess)->InitiatorName);
@@ -1283,8 +1288,6 @@ static ssize_t lio_target_initiator_nacl_info (void *p, char *page)
 		rb += sprintf(page+rb, "SessionType: %s\n",
 				(SESS_OPS(sess)->SessionType) ?
 				"Discovery" : "Normal");
-		rb += sprintf(page+rb, "Cmds in Session Pool: %d  ",
-				atomic_read(&sess->pool_count));
 		rb += sprintf(page+rb, "Session State: ");
 		switch (sess->session_state) {
 		case TARG_SESS_STATE_FREE:
@@ -1357,7 +1360,7 @@ static ssize_t lio_target_initiator_nacl_info (void *p, char *page)
 		}
 		spin_unlock(&sess->conn_lock);
 	}
-	spin_unlock_bh(&nacl->nacl_sess_lock);
+	spin_unlock_bh(&se_nacl->nacl_sess_lock);
 
 	return(rb);
 }
@@ -1372,16 +1375,16 @@ static struct lio_target_configfs_attribute lio_target_attr_initiator_info = {
 
 static ssize_t lio_target_initiator_nacl_cmdsn_window_show (void *p, char *page)
 {
-	iscsi_node_acl_t *nacl = (iscsi_node_acl_t *)p;
+	se_node_acl_t *se_nacl = (se_node_acl_t *)p;
 
-	return(sprintf(page, "%u\n", nacl->queue_depth));
+	return(sprintf(page, "%u\n", se_nacl->queue_depth));
 }
 
 static ssize_t lio_target_initiator_nacl_cmdsn_window_store (void *p, const char *page, size_t count)
 {
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
-	iscsi_node_acl_t *nacl = (iscsi_node_acl_t *)p;
+	se_node_acl_t *se_nacl = (se_node_acl_t *)p;
 	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
 	char *endptr;
 	u32 cmdsn_depth = 0;
@@ -1395,7 +1398,7 @@ static ssize_t lio_target_initiator_nacl_cmdsn_window_store (void *p, const char
 			TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return(-EINVAL);
 	}
-	if (!(acl_ci = &nacl->acl_group.cg_item)) {
+	if (!(acl_ci = &se_nacl->acl_group.cg_item)) {
 		printk(KERN_ERR "Unable to locatel acl_ci\n");
 		return(-EINVAL);
 	}
@@ -1415,8 +1418,9 @@ static ssize_t lio_target_initiator_nacl_cmdsn_window_store (void *p, const char
 	if (!(tpg = core_get_tpg_from_iqn(config_item_name(tiqn_ci),
 				&tiqn, tpgt, 0)))
 		return(-EINVAL);
-
-#warning setnodequeuedepth assumes force=1
+	/*
+	 * iscsi_tpg_set_initiator_node_queue_depth() assumes force=1
+	 */
 	ret = iscsi_tpg_set_initiator_node_queue_depth(tpg,
 				config_item_name(acl_ci), cmdsn_depth, 1);
 
@@ -1440,30 +1444,30 @@ static ssize_t lio_target_initiator_nacl_show (struct config_item *item,
 				    struct configfs_attribute *attr,
 				    char *page)
 {
-	iscsi_node_acl_t *nacl = container_of(
-			to_config_group(item), iscsi_node_acl_t, acl_group);
+	se_node_acl_t *se_nacl = container_of(
+			to_config_group(item), se_node_acl_t, acl_group);
 	struct lio_target_configfs_attribute *lt_attr = container_of(
 			attr, struct lio_target_configfs_attribute, attr);
 
 	if (!(lt_attr->show))
 		return(-EINVAL);
 
-	return(lt_attr->show((void *)nacl, page));
+	return(lt_attr->show((void *)se_nacl, page));
 }
 
 static ssize_t lio_target_initiator_nacl_store (struct config_item *item,
 				     struct configfs_attribute *attr,
 				     const char *page, size_t count)
 {
-	iscsi_node_acl_t *nacl = container_of(
-			to_config_group(item), iscsi_node_acl_t, acl_group);
+	se_node_acl_t *se_nacl = container_of(
+			to_config_group(item), se_node_acl_t, acl_group);
 	struct lio_target_configfs_attribute *lt_attr = container_of(
 			attr, struct lio_target_configfs_attribute, attr);
 
 	if (!(lt_attr->store))
 		return(-EINVAL);
 
-	return(lt_attr->store((void *)nacl, page, count));
+	return(lt_attr->store((void *)se_nacl, page, count));
 }
 
 static struct configfs_attribute *lio_target_initiator_attrs[] = {
@@ -1501,6 +1505,7 @@ static struct config_group *lio_target_call_addnodetotpg (
 	iscsi_node_attrib_t *nattr;
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
+	se_node_acl_t *se_nacl;
 	struct config_group *nacl_cg;
 	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
 	u32 cmdsn_depth;
@@ -1538,8 +1543,10 @@ static struct config_group *lio_target_call_addnodetotpg (
 				cmdsn_depth, &ret)))
 		goto out;
 
-	nacl_cg = &acl->acl_group;
+	se_nacl = acl->se_node_acl;
+	nacl_cg = &se_nacl->acl_group;
 	nattr = &acl->node_attrib;
+
 	/*
 	 * Create the default groups for iscsi_node_acl_t
 	 */
@@ -1547,18 +1554,22 @@ static struct config_group *lio_target_call_addnodetotpg (
 			GFP_KERNEL)))
 		goto node_out;
 
-	config_group_init_type_name(&acl->acl_group, name, &lio_target_initiator_cit);
-	config_group_init_type_name(&acl->acl_param_group, "param", &lio_target_nacl_param_cit);
-	config_group_init_type_name(&nattr->acl_attrib_group, "attrib", &lio_target_nacl_attrib_cit);
-	nacl_cg->default_groups[0] = &acl->acl_param_group;
+	config_group_init_type_name(&se_nacl->acl_group, name,
+			&lio_target_initiator_cit);
+	config_group_init_type_name(&se_nacl->acl_param_group, "param",
+			&lio_target_nacl_param_cit);
+	config_group_init_type_name(&nattr->acl_attrib_group, "attrib",
+			&lio_target_nacl_attrib_cit);
+	nacl_cg->default_groups[0] = &se_nacl->acl_param_group;
 	nacl_cg->default_groups[1] = &nattr->acl_attrib_group;
 	nacl_cg->default_groups[2] = NULL;
 
-	printk("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu Initiator: %s CmdSN Depth: %u\n",
-		config_item_name(tiqn_ci), tpgt, name, acl->queue_depth);
+	printk("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu Initiator: %s"
+		" CmdSN Depth: %u\n", config_item_name(tiqn_ci), tpgt, name,
+		se_nacl->queue_depth);
 
 	iscsi_put_tpg(tpg);
-	return(&acl->acl_group);
+	return(&se_nacl->acl_group);
 node_out:
 	iscsi_tpg_del_initiator_node_acl(tpg, name, 1);
 out:
@@ -1596,7 +1607,9 @@ static void lio_target_call_delnodefromtpg (
 	if (!(tpg = core_get_tpg_from_iqn(config_item_name(tiqn_ci),
 				&tiqn, tpgt, 0)))
 		return;
-#warning FIXME: delnodefromtpg assumes force=1
+	/*
+	 * iscsi_tpg_del_initiator_node_acl() assumes force=1
+	 */
 	if ((ret = iscsi_tpg_del_initiator_node_acl(tpg,
 				config_item_name(item), 1)) < 0)
 		goto out;
@@ -1969,7 +1982,9 @@ static ssize_t lio_target_store_tpg_enable (void *p, const char *page, size_t co
 		if ((ret = iscsi_tpg_enable_portal_group(tpg)) < 0)
 			goto out;
 	} else {
-#warning FIXME: For disabletpg, sssumes force=1 for now..
+		/*
+		 * iscsi_tpg_disable_portal_group() assumes force=1
+		 */
 		if ((ret = iscsi_tpg_disable_portal_group(tpg, 1)) < 0)
 			goto out;
 	}
@@ -2148,8 +2163,9 @@ static void lio_target_tiqn_deltpg (
 	 * Does the last config_item_put() also release a groups->default_groups..?
 	 */
 	config_item_put(item);
-
-#warning FIXME: For deltpg, Assming force=1
+	/*
+	 * iscsi_tpg_del_portal_group() assumes force=1
+	 */
 	printk("LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n");
 	if ((ret = iscsi_tpg_del_portal_group(tiqn, tpg, 1)) < 0) {
 		iscsi_put_tpg(tpg);
@@ -2271,13 +2287,20 @@ extern int iscsi_target_register_configfs (void)
 	/*
 	 * Temporary OPs function pointers used by target_core_mod..
 	 */
+	fabric->tf_ops.get_fabric_name = &iscsi_get_fabric_name;
+	fabric->tf_ops.tpg_get_wwn = &lio_tpg_get_endpoint_wwn;
+	fabric->tf_ops.tpg_get_tag = &lio_tpg_get_tag;
+	fabric->tf_ops.tpg_get_default_depth = &lio_tpg_get_default_depth;
+	fabric->tf_ops.tpg_check_demo_mode = &lio_tpg_check_demo_mode;
+	fabric->tf_ops.tpg_check_demo_mode_cache = &lio_tpg_check_demo_mode_cache;
+	fabric->tf_ops.tpg_check_demo_mode_write_protect = &lio_tpg_check_demo_mode_write_protect;
+	fabric->tf_ops.tpg_release_node_acl = &lio_tpg_release_node_acl;
 	fabric->tf_ops.release_cmd_to_pool = &lio_release_cmd_to_pool;
 	fabric->tf_ops.release_cmd_direct = &lio_release_cmd_direct;
-	fabric->tf_ops.dev_del_lun = &iscsi_dev_del_lun;
-	fabric->tf_ops.stop_session = &iscsi_stop_session;
-	fabric->tf_ops.fall_back_to_erl0 = &iscsi_fall_back_to_erl0;
+	fabric->tf_ops.stop_session = &lio_tpg_stop_session;
+	fabric->tf_ops.fall_back_to_erl0 = &lio_tpg_fall_back_to_erl0;
 	fabric->tf_ops.write_pending = &lio_write_pending;
-	fabric->tf_ops.dec_nacl_count = &iscsi_dec_nacl_count;
+	fabric->tf_ops.set_default_node_attributes = &lio_set_default_node_attributes;
 	fabric->tf_ops.scsi_auth_intr_seq_start = &lio_scsi_auth_intr_seq_start;
 	fabric->tf_ops.scsi_auth_intr_seq_next = &lio_scsi_auth_intr_seq_next;
 	fabric->tf_ops.scsi_auth_intr_seq_show = &lio_scsi_auth_intr_seq_show;
-- 
1.5.4.1



