From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 7/6] target: Do not allocate device_list and tpg_lun_list arrays separately
Date: Fri,  7 Mar 2014 09:50:22 -0800
Message-ID: <1394214622-2924-1-git-send-email-agrover@redhat.com>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Instead of allocing these dynamically, include them in their parent
structures.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c |  6 -----
 drivers/target/target_core_tpg.c    | 44 +++----------------------------------
 include/target/target_core_base.h   |  4 ++--
 3 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index afa7f6b..173c4f0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -242,9 +242,6 @@ int core_free_device_list_for_node(
 	struct se_lun *lun;
 	u32 i;
 
-	if (!nacl->device_list)
-		return 0;
-
 	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = nacl->device_list[i];
@@ -267,9 +264,6 @@ int core_free_device_list_for_node(
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	kfree(nacl->device_list);
-	nacl->device_list = NULL;
-
 	return 0;
 }
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 522b325..38a6d1b 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -189,23 +189,6 @@ static int core_set_queue_depth_for_node(
 	return 0;
 }
 
-/*      core_create_device_list_for_node():
- *
- *
- */
-static int core_create_device_list_for_node(struct se_node_acl *nacl)
-{
-	nacl->device_list = kzalloc(TRANSPORT_MAX_LUNS_PER_TPG * sizeof(void*),
-				    GFP_KERNEL);
-	if (!nacl->device_list) {
-		pr_err("Unable to allocate memory for"
-			" struct se_node_acl->device_list\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 /*	core_tpg_check_initiator_node_acl()
  *
  *
@@ -242,11 +225,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0) {
-		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
-		return NULL;
-	}
-
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
@@ -367,11 +345,6 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0) {
-		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
@@ -628,14 +601,6 @@ int core_tpg_register(
 	void *tpg_fabric_ptr,
 	int se_tpg_type)
 {
-	se_tpg->tpg_lun_list = kzalloc(TRANSPORT_MAX_LUNS_PER_TPG * sizeof(void*),
-				       GFP_KERNEL);
-	if (!se_tpg->tpg_lun_list) {
-		pr_err("Unable to allocate struct se_portal_group->"
-				"tpg_lun_list\n");
-		return -ENOMEM;
-	}
-
 	se_tpg->se_tpg_type = se_tpg_type;
 	se_tpg->se_tpg_fabric_ptr = tpg_fabric_ptr;
 	se_tpg->se_tpg_tfo = tfo;
@@ -648,12 +613,9 @@ int core_tpg_register(
 	spin_lock_init(&se_tpg->session_lock);
 	spin_lock_init(&se_tpg->tpg_lun_lock);
 
-	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
-		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
-			kfree(se_tpg->tpg_lun_list);
+	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
+		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
 			return -ENOMEM;
-		}
-	}
 
 	spin_lock_bh(&tpg_lock);
 	list_add_tail(&se_tpg->se_tpg_node, &tpg_list);
@@ -710,7 +672,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
 
 	se_tpg->se_tpg_fabric_ptr = NULL;
-	kfree(se_tpg->tpg_lun_list);
+
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6981642..c0d93c5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -577,7 +577,7 @@ struct se_node_acl {
 	char			acl_tag[MAX_ACL_TAG_SIZE];
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
-	struct se_dev_entry	**device_list;
+	struct se_dev_entry	*device_list[TRANSPORT_MAX_LUNS_PER_TPG];
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
 	spinlock_t		device_list_lock;
@@ -864,7 +864,7 @@ struct se_portal_group {
 	struct list_head	se_tpg_node;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
-	struct se_lun		**tpg_lun_list;
+	struct se_lun		*tpg_lun_list[TRANSPORT_MAX_LUNS_PER_TPG];
 	struct se_lun		tpg_virt_lun0;
 	/* List of TCM sessions associated wth this TPG */
 	struct list_head	tpg_sess_list;
-- 
1.8.5.3
