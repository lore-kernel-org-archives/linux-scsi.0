From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 21/22] target: Rename se_node_acl->lun_entry_hlist to target_* prefix
Date: Fri, 27 Mar 2015 08:05:11 +0000
Message-ID: <1427443512-8925-22-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This includes:

  - target_add_node_to_devs
  - target_get_deve_from_rtpi
  - target_create_device_list_for_node
  - target_free_device_list_for_node
  - target_enable_device_list_for_node
  - target_disable_device_list_for_node

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    | 22 +++++++++++-----------
 drivers/target/target_core_internal.h  | 12 ++++++------
 drivers/target/target_core_pr.c        |  6 +++---
 drivers/target/target_core_tpg.c       | 28 ++++++++++++++--------------
 drivers/target/target_core_transport.c |  2 +-
 5 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3647e7c..5b225d8 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -207,7 +207,7 @@ EXPORT_SYMBOL(target_lookup_tmr_lun);
  * and core_scsi3_decode_spec_i_port(), and will increment &deve->pr_ref_count
  * when a matching rtpi is found.
  */
-struct se_dev_entry *core_get_se_deve_from_rtpi(
+struct se_dev_entry *target_get_deve_from_rtpi(
 	struct se_node_acl *nacl,
 	u16 rtpi)
 {
@@ -257,7 +257,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	return NULL;
 }
 
-int core_free_device_list_for_node(
+int target_free_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
@@ -287,7 +287,7 @@ int core_free_device_list_for_node(
 		mapped_lun = deve->mapped_lun;
 		rcu_read_unlock();
 
-		core_disable_device_list_for_node(lun, NULL, mapped_lun,
+		target_disable_device_list_for_node(lun, NULL, mapped_lun,
 					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 	}
 
@@ -325,11 +325,11 @@ static void target_pr_ref_release(struct percpu_ref *ref)
 	complete(&deve->pr_comp);
 }
 
-/*      core_enable_device_list_for_node():
+/*      target_enable_device_list_for_node():
  *
  *
  */
-int core_enable_device_list_for_node(
+int target_enable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl,
 	u32 mapped_lun,
@@ -394,11 +394,11 @@ int core_enable_device_list_for_node(
 	return 0;
 }
 
-/*      core_disable_device_list_for_node():
+/*      target_disable_device_list_for_node():
  *
  *
  */
-int core_disable_device_list_for_node(
+int target_disable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl,
 	u32 mapped_lun,
@@ -479,7 +479,7 @@ void target_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 			mapped_lun = deve->mapped_lun;
 			rcu_read_unlock();
 
-			core_disable_device_list_for_node(lun, NULL, mapped_lun,
+			target_disable_device_list_for_node(lun, NULL, mapped_lun,
 					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 		}
 	}
@@ -1232,7 +1232,7 @@ struct se_lun *core_dev_add_lun(
 			if (acl->dynamic_node_acl &&
 			    (!tpg->se_tpg_tfo->tpg_check_demo_mode_login_only ||
 			     !tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg))) {
-				core_tpg_add_node_to_devs(acl, tpg);
+				target_add_node_to_devs(acl, tpg);
 			}
 		}
 		mutex_unlock(&tpg->acl_node_mutex);
@@ -1374,7 +1374,7 @@ int core_dev_add_initiator_node_lun_acl(
 
 	lacl->se_lun = lun;
 
-	if (core_enable_device_list_for_node(lun, lacl, lacl->mapped_lun,
+	if (target_enable_device_list_for_node(lun, lacl, lacl->mapped_lun,
 			lun_access, nacl, tpg) < 0)
 		return -EINVAL;
 
@@ -1407,7 +1407,7 @@ int core_dev_del_initiator_node_lun_acl(
 	if (!nacl)
 		return -EINVAL;
 
-	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
+	target_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
 		TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 
 	lacl->se_lun = NULL;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 70190e2..6c8b7fb 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -5,13 +5,13 @@
 extern struct t10_alua_lu_gp *default_lu_gp;
 
 /* target_core_device.c */
-struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
-int	core_free_device_list_for_node(struct se_node_acl *,
+struct se_dev_entry *target_get_deve_from_rtpi(struct se_node_acl *, u16);
+int	target_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
 void	core_update_device_list_access(u32, u32, struct se_node_acl *);
-int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
-		u32, u32, struct se_node_acl *, struct se_portal_group *);
-int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
+int	target_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
+			u32, u32, struct se_node_acl *, struct se_portal_group *);
+int	target_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, u32, struct se_node_acl *, struct se_portal_group *);
 void	target_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
 int	core_dev_export(struct se_device *, struct se_portal_group *,
@@ -50,7 +50,7 @@ extern struct se_device *g_lun0_dev;
 
 struct se_node_acl *__target_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
-void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
+void	target_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	target_add_lun(struct se_portal_group *, struct se_lun *,
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3a5ee0b..29c2fc7 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1669,8 +1669,8 @@ core_scsi3_decode_spec_i_port(
 		 * RELATIVE TARGET PORT IDENTIFIER on the receiving I_T Nexus
 		 * Target Port.
 		 */
-		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
-					dest_rtpi);
+		dest_se_deve = target_get_deve_from_rtpi(dest_node_acl,
+							 dest_rtpi);
 		if (!dest_se_deve) {
 			pr_err("Unable to locate %s dest_se_deve"
 				" from destination RTPI: %hu\n",
@@ -3374,7 +3374,7 @@ after_iport_check:
 	 * Locate the struct se_dev_entry pointer for the matching RELATIVE TARGET
 	 * PORT IDENTIFIER.
 	 */
-	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
+	dest_se_deve = target_get_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!dest_se_deve) {
 		pr_err("Unable to locate %s dest_se_deve from RTPI:"
 			" %hu\n",  dest_tf_ops->get_fabric_name(), rtpi);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 9d31434..b10071d 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -78,7 +78,7 @@ static void target_clear_initiator_node_from_tpg(
 		mapped_lun = deve->mapped_lun;
 		rcu_read_unlock();
 
-		core_disable_device_list_for_node(lun, NULL, mapped_lun,
+		target_disable_device_list_for_node(lun, NULL, mapped_lun,
 					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 	}
 }
@@ -119,11 +119,11 @@ struct se_node_acl *target_get_initiator_node_acl(
 }
 EXPORT_SYMBOL(target_get_initiator_node_acl);
 
-/*	core_tpg_add_node_to_devs():
+/*	target_add_node_to_devs():
  *
  *
  */
-void core_tpg_add_node_to_devs(
+void target_add_node_to_devs(
 	struct se_node_acl *acl,
 	struct se_portal_group *tpg)
 {
@@ -163,8 +163,8 @@ void core_tpg_add_node_to_devs(
 			(lun_access == TRANSPORT_LUNFLAGS_READ_WRITE) ?
 			"READ-WRITE" : "READ-ONLY");
 
-		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
-						 lun_access, acl, tpg);
+		target_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
+						   lun_access, acl, tpg);
 		/*
 		 * Check to see if there are any existing persistent reservation
 		 * APTPL pre-registrations that need to be enabled for this dynamic
@@ -222,11 +222,11 @@ static void *array_zalloc(int n, size_t size, gfp_t flags)
 	return a;
 }
 
-/*      core_create_device_list_for_node():
+/*      target_create_device_list_for_node():
  *
  *
  */
-static int core_create_device_list_for_node(struct se_node_acl *nacl)
+static int target_create_device_list_for_node(struct se_node_acl *nacl)
 {
 	struct se_dev_entry *deve;
 	int i;
@@ -286,13 +286,13 @@ struct se_node_acl *target_check_initiator_node_acl(
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0) {
+	if (target_create_device_list_for_node(acl) < 0) {
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return NULL;
 	}
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
-		core_free_device_list_for_node(acl, tpg);
+		target_free_device_list_for_node(acl, tpg);
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return NULL;
 	}
@@ -303,7 +303,7 @@ struct se_node_acl *target_check_initiator_node_acl(
 	 */
 	if ((tpg->se_tpg_tfo->tpg_check_demo_mode_login_only == NULL) ||
 	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) != 1))
-		core_tpg_add_node_to_devs(acl, tpg);
+		target_add_node_to_devs(acl, tpg);
 
 	mutex_lock(&tpg->acl_node_mutex);
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
@@ -391,13 +391,13 @@ struct se_node_acl *target_add_initiator_node_acl(
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0) {
+	if (target_create_device_list_for_node(acl) < 0) {
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
-		core_free_device_list_for_node(acl, tpg);
+		target_free_device_list_for_node(acl, tpg);
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return ERR_PTR(-EINVAL);
 	}
@@ -470,7 +470,7 @@ int target_del_initiator_node_acl(
 
 	core_tpg_wait_for_nacl_pr_ref(acl);
 	target_clear_initiator_node_from_tpg(acl, tpg);
-	core_free_device_list_for_node(acl, tpg);
+	target_free_device_list_for_node(acl, tpg);
 
 	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
@@ -739,7 +739,7 @@ int target_deregister_tpg(struct se_portal_group *se_tpg)
 		se_tpg->num_node_acls--;
 
 		core_tpg_wait_for_nacl_pr_ref(nacl);
-		core_free_device_list_for_node(nacl, se_tpg);
+		target_free_device_list_for_node(nacl, se_tpg);
 		se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg, nacl);
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86d4aeb..64f2f87 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -505,7 +505,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 	if (drop_nacl) {
 		core_tpg_wait_for_nacl_pr_ref(se_nacl);
-		core_free_device_list_for_node(se_nacl, se_tpg);
+		target_free_device_list_for_node(se_nacl, se_tpg);
 		se_tfo->tpg_release_fabric_acl(se_tpg, se_nacl);
 		comp_nacl = false;
 	}
-- 
1.9.1
