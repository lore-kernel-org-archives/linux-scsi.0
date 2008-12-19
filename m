From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 4/6]: Updates for generic portal group
	functionality
Date: Fri, 19 Dec 2008 15:27:06 -0800
Message-ID: <1229729226.4560.90.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:38284 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755532AbYLSX1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:27:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 08d57bc6a705f5b9f03afa2fbbb50a607e69b985 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:21:59 -0800
Subject: [PATCH] [Target_Core_Mod]: Updates for generic portal group functionality

This patch exports symbols for core_tpg_check_initiator_node_acl() and
core_tpg_set_initiator_node_queue_depth().

It also adds 'int se_tpg_type' parameter to core_tpg_register().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_tpg.c |   20 +++++++++++++++-----
 drivers/lio-core/target_core_tpg.h |    4 ++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/lio-core/target_core_tpg.c b/drivers/lio-core/target_core_tpg.c
index 57dca83..768890a 100644
--- a/drivers/lio-core/target_core_tpg.c
+++ b/drivers/lio-core/target_core_tpg.c
@@ -309,6 +309,8 @@ extern se_node_acl_t *core_tpg_check_initiator_node_acl (
 	return(acl);
 }
 
+EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
+
 /*	core_tpg_free_node_acls():
  *
  *
@@ -409,6 +411,7 @@ extern se_node_acl_t *core_tpg_add_initiator_node_acl (
 	}
 
 	spin_lock_init(&acl->device_list_lock);
+	acl->fabric_acl_ptr = fabric_acl_ptr;
 	acl->queue_depth = queue_depth;
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
@@ -452,7 +455,7 @@ EXPORT_SYMBOL(core_tpg_add_initiator_node_acl);
  *
  *
  */
-#warning FIXME: core_tpg_del_initiator_node_acl() broken
+#warning FIXME: core_tpg_del_initiator_node_acl() force session shudown is broken
 extern int core_tpg_del_initiator_node_acl (
 	se_portal_group_t *tpg,
 	const char *initiatorname,
@@ -648,9 +651,12 @@ extern int core_tpg_set_initiator_node_queue_depth (
 	return(0);
 }
 
+EXPORT_SYMBOL(core_tpg_set_initiator_node_queue_depth);
+
 extern se_portal_group_t *core_tpg_register (
 	struct target_core_fabric_ops *tfo,
-	void *tpg_fabric_ptr)
+	void *tpg_fabric_ptr,
+	int se_tpg_type)
 {
 	se_lun_t *lun;
 	se_portal_group_t *se_tpg;
@@ -682,17 +688,21 @@ extern se_portal_group_t *core_tpg_register (
 		spin_lock_init(&lun->lun_sep_lock);
 	}
 
+	se_tpg->se_tpg_type = se_tpg_type;
 	se_tpg->se_tpg_fabric_ptr = tpg_fabric_ptr;
 	se_tpg->se_tpg_tfo = tfo;
 	INIT_LIST_HEAD(&se_tpg->se_tpg_list);
+	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
 	spin_lock_init(&se_tpg->tpg_lun_lock);
 #warning FIXME: Add se_portal_group to list..
 
-	printk("TARGET_CORE[%s]: Allocated se_portal_group_t for endpoint %s %u\n",
-		tfo->get_fabric_name(), tfo->tpg_get_wwn(se_tpg),
-		tfo->tpg_get_tag(se_tpg));
+	printk("TARGET_CORE[%s]: Allocated %s se_portal_group_t for endpoint:"
+		" %s, Portal Tag: %u\n", tfo->get_fabric_name(),
+		(se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
+		"Normal" : "Discovery", (tfo->tpg_get_wwn(se_tpg) == NULL) ?
+		"None" : tfo->tpg_get_wwn(se_tpg), tfo->tpg_get_tag(se_tpg));
 
 	return(se_tpg);
 }
diff --git a/drivers/lio-core/target_core_tpg.h b/drivers/lio-core/target_core_tpg.h
index d3a3523..b898450 100644
--- a/drivers/lio-core/target_core_tpg.h
+++ b/drivers/lio-core/target_core_tpg.h
@@ -35,10 +35,10 @@ extern void core_tpg_add_node_to_devs (struct se_node_acl_s *, struct se_portal_
 extern struct se_node_acl_s *core_tpg_check_initiator_node_acl (struct se_portal_group_s *, unsigned char *);
 extern void core_tpg_free_node_acls (struct se_portal_group_s *);
 extern void core_tpg_clear_object_luns (struct se_portal_group_s *);
-extern se_node_acl_t *core_tpg_add_initiator_node_acl (se_portal_group_t *, const char *, u32, int *);
+extern se_node_acl_t *core_tpg_add_initiator_node_acl (se_portal_group_t *, void *, const char *, u32, int *);
 extern int core_tpg_del_initiator_node_acl (se_portal_group_t *, const char *, int);
 extern int core_tpg_set_initiator_node_queue_depth (se_portal_group_t *, unsigned char *, u32, int);
-extern se_portal_group_t *core_tpg_register (struct target_core_fabric_ops *, void *);
+extern se_portal_group_t *core_tpg_register (struct target_core_fabric_ops *, void *, int);
 extern int core_tpg_deregister (struct se_portal_group_s *);
 extern se_lun_t *core_tpg_pre_addlun (se_portal_group_t *, u32, int *);
 extern int core_tpg_post_addlun (se_portal_group_t *, se_lun_t *, int, u32, void *, struct se_obj_lun_type_s *);
-- 
1.5.4.1



