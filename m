From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 18/22] target: Rename TPG initiator_node_acl to target_* prefix
Date: Fri, 27 Mar 2015 08:05:08 +0000
Message-ID: <1427443512-8925-19-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This includes + fabric driver changes:

  - target_check_initiator_node_acl
  - target_add_initiator_node_acl
  - target_del_initiator_node_acl
  - target_set_initiator_node_queue_depth
  - target_del_initiator_node_acl
  - target_get_initiator_node_acl
  - target_clear_initiator_node_from_tpg

Also, update fabric drivers for loopback, tcm_fc, iscsi/iser-target,
ib_srpt, sbp-target, usb-gadget, tcm_qla2xxx, vhost-scsi and xen-scsiback.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  8 ++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 12 +++----
 drivers/target/iscsi/iscsi_target.c          |  2 +-
 drivers/target/iscsi/iscsi_target_configfs.c | 13 ++++---
 drivers/target/iscsi/iscsi_target_nego.c     |  4 +--
 drivers/target/iscsi/iscsi_target_tpg.c      |  2 +-
 drivers/target/loopback/tcm_loop.c           |  4 +--
 drivers/target/sbp/sbp_target.c              | 10 +++---
 drivers/target/target_core_internal.h        |  2 +-
 drivers/target/target_core_pr.c              |  4 +--
 drivers/target/target_core_tpg.c             | 54 ++++++++++++++--------------
 drivers/target/tcm_fc/tfc_conf.c             |  6 ++--
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   | 14 ++++----
 drivers/vhost/scsi.c                         | 12 +++----
 include/target/target_core_fabric.h          | 12 +++----
 15 files changed, 79 insertions(+), 80 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6e0a477..c2f833d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3626,11 +3626,11 @@ static struct se_node_acl *srpt_make_nodeacl(struct se_portal_group *tpg,
 		goto err;
 	}
 	/*
-	 * nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * nacl_new may be released by target_add_initiator_node_acl()
 	 * when converting a node ACL from demo mode to explict
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(tpg, se_nacl_new, name,
-						  nexus_depth);
+	se_nacl = target_add_initiator_node_acl(tpg, se_nacl_new, name,
+						nexus_depth);
 	if (IS_ERR(se_nacl)) {
 		ret = PTR_ERR(se_nacl);
 		goto err;
@@ -3665,7 +3665,7 @@ static void srpt_drop_nodeacl(struct se_node_acl *se_nacl)
 	spin_lock_irq(&sport->port_acl_lock);
 	list_del(&nacl->list);
 	spin_unlock_irq(&sport->port_acl_lock);
-	core_tpg_del_initiator_node_acl(&sport->port_tpg_1, se_nacl, 1);
+	target_del_initiator_node_acl(&sport->port_tpg_1, se_nacl, 1);
 	srpt_release_fabric_acl(NULL, se_nacl);
 }
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 65a683c..e29515b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -865,11 +865,11 @@ static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
 	qla2xxx_nexus_depth = 1;
 
 	/*
-	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * se_nacl_new may be released by target_add_initiator_node_acl()
 	 * when converting a NodeACL from demo mode -> explict
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
-				name, qla2xxx_nexus_depth);
+	se_nacl = target_add_initiator_node_acl(se_tpg, se_nacl_new,
+						name, qla2xxx_nexus_depth);
 	if (IS_ERR(se_nacl)) {
 		tcm_qla2xxx_release_fabric_acl(se_tpg, se_nacl_new);
 		return se_nacl;
@@ -890,7 +890,7 @@ static void tcm_qla2xxx_drop_nodeacl(struct se_node_acl *se_acl)
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_acl,
 				struct tcm_qla2xxx_nacl, se_node_acl);
 
-	core_tpg_del_initiator_node_acl(se_tpg, se_acl, 1);
+	target_del_initiator_node_acl(se_tpg, se_acl, 1);
 	kfree(nacl);
 }
 
@@ -1575,8 +1575,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * Locate our struct se_node_acl either from an explict NodeACL created
 	 * via ConfigFS, or via running in TPG demo mode.
 	 */
-	se_sess->se_node_acl = core_tpg_check_initiator_node_acl(se_tpg,
-					port_name);
+	se_sess->se_node_acl = target_check_initiator_node_acl(se_tpg,
+							       port_name);
 	if (!se_sess->se_node_acl) {
 		transport_free_session(se_sess);
 		return -EINVAL;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 935cc05..75e24ef 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3443,7 +3443,7 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 
 			if ((tpg->tpg_attrib.generate_node_acls == 0) &&
 			    (tpg->tpg_attrib.demo_mode_discovery == 0) &&
-			    (!core_tpg_get_initiator_node_acl(&tpg->tpg_se_tpg,
+			    (!target_get_initiator_node_acl(&tpg->tpg_se_tpg,
 				cmd->conn->sess->sess_ops->InitiatorName))) {
 				continue;
 			}
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 48384b6..167782a 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -847,8 +847,7 @@ static ssize_t lio_target_nacl_store_tag(
 {
 	int ret;
 
-	ret = core_tpg_set_initiator_node_tag(se_nacl->se_tpg, se_nacl, page);
-
+	ret = target_set_initiator_node_tag(se_nacl->se_tpg, se_nacl, page);
 	if (ret < 0)
 		return ret;
 	return count;
@@ -895,11 +894,11 @@ static struct se_node_acl *lio_target_make_nodeacl(
 
 	cmdsn_depth = tpg->tpg_attrib.default_cmdsn_depth;
 	/*
-	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * se_nacl_new may be released by target_add_initiator_node_acl()
 	 * when converting a NdoeACL from demo mode -> explict
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
-				name, cmdsn_depth);
+	se_nacl = target_add_initiator_node_acl(se_tpg, se_nacl_new,
+						name, cmdsn_depth);
 	if (IS_ERR(se_nacl))
 		return se_nacl;
 
@@ -911,7 +910,7 @@ static struct se_node_acl *lio_target_make_nodeacl(
 	if (!stats_cg->default_groups) {
 		pr_err("Unable to allocate memory for"
 				" stats_cg->default_groups\n");
-		core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
+		target_del_initiator_node_acl(se_tpg, se_nacl, 1);
 		kfree(acl);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -942,7 +941,7 @@ static void lio_target_drop_nodeacl(
 	}
 	kfree(stats_cg->default_groups);
 
-	core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
+	target_del_initiator_node_acl(se_tpg, se_nacl, 1);
 	kfree(acl);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8c02fa3..ce326cd 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1175,8 +1175,8 @@ get_target:
 	/*
 	 * Locate incoming Initiator IQN reference from Storage Node.
 	 */
-	sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-			&conn->tpg->tpg_se_tpg, i_buf);
+	sess->se_sess->se_node_acl = target_check_initiator_node_acl(
+					&conn->tpg->tpg_se_tpg, i_buf);
 	if (!sess->se_sess->se_node_acl) {
 		pr_err("iSCSI Initiator Node: %s is not authorized to"
 			" access iSCSI target portal group: %hu.\n",
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 2261c8c..4ebc20b 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -598,7 +598,7 @@ int iscsit_tpg_set_initiator_node_queue_depth(
 	u32 queue_depth,
 	int force)
 {
-	return core_tpg_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
+	return target_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
 		initiatorname, queue_depth, force);
 }
 
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 696c2ca..b271624 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -991,8 +991,8 @@ static int tcm_loop_make_nexus(
 	 * struct se_node_acl for the tcm_loop struct se_portal_group with the SCSI
 	 * Initiator port name of the passed configfs group 'name'.
 	 */
-	tl_nexus->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-				se_tpg, (unsigned char *)name);
+	tl_nexus->se_sess->se_node_acl = target_check_initiator_node_acl(
+					se_tpg, (unsigned char *)name);
 	if (!tl_nexus->se_sess->se_node_acl) {
 		transport_free_session(tl_nexus->se_sess);
 		goto out;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index ec46968..f433d56 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -221,7 +221,7 @@ static struct sbp_session *sbp_session_create(
 
 	snprintf(guid_str, sizeof(guid_str), "%016llx", guid);
 
-	se_nacl = core_tpg_check_initiator_node_acl(&tpg->se_tpg, guid_str);
+	se_nacl = target_check_initiator_node_acl(&tpg->se_tpg, guid_str);
 	if (!se_nacl) {
 		pr_warn("Node ACL not found for %s\n", guid_str);
 
@@ -2115,11 +2115,11 @@ static struct se_node_acl *sbp_make_nodeacl(
 		return ERR_PTR(-ENOMEM);
 
 	/*
-	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * se_nacl_new may be released by target_add_initiator_node_acl()
 	 * when converting a NodeACL from demo mode -> explict
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
-			name, nexus_depth);
+	se_nacl = target_add_initiator_node_acl(se_tpg, se_nacl_new,
+						name, nexus_depth);
 	if (IS_ERR(se_nacl)) {
 		sbp_release_fabric_acl(se_tpg, se_nacl_new);
 		return se_nacl;
@@ -2137,7 +2137,7 @@ static void sbp_drop_nodeacl(struct se_node_acl *se_acl)
 	struct sbp_nacl *nacl =
 		container_of(se_acl, struct sbp_nacl, se_node_acl);
 
-	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
+	target_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
 	kfree(nacl);
 }
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 60381db..574b396 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -48,7 +48,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 /* target_core_tpg.c */
 extern struct se_device *g_lun0_dev;
 
-struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
+struct se_node_acl *__target_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
 void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 93e109e..3a5ee0b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1612,7 +1612,7 @@ core_scsi3_decode_spec_i_port(
 			 * at *i_str.
 			 */
 			mutex_lock(&tmp_tpg->acl_node_mutex);
-			dest_node_acl = __core_tpg_get_initiator_node_acl(
+			dest_node_acl = __target_get_initiator_node_acl(
 						tmp_tpg, i_str);
 			if (dest_node_acl)
 				atomic_inc_mb(&dest_node_acl->acl_pr_ref_count);
@@ -3343,7 +3343,7 @@ after_iport_check:
 	 * Locate the destination struct se_node_acl from the received Transport ID
 	 */
 	mutex_lock(&dest_se_tpg->acl_node_mutex);
-	dest_node_acl = __core_tpg_get_initiator_node_acl(dest_se_tpg,
+	dest_node_acl = __target_get_initiator_node_acl(dest_se_tpg,
 				initiator_str);
 	if (dest_node_acl)
 		atomic_inc_mb(&dest_node_acl->acl_pr_ref_count);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index f197618..86dda22 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -47,11 +47,11 @@ extern struct se_device *g_lun0_dev;
 static DEFINE_SPINLOCK(tpg_lock);
 static LIST_HEAD(tpg_list);
 
-/*	core_clear_initiator_node_from_tpg():
+/*	target_clear_initiator_node_from_tpg():
  *
  *
  */
-static void core_clear_initiator_node_from_tpg(
+static void target_clear_initiator_node_from_tpg(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
@@ -83,11 +83,11 @@ static void core_clear_initiator_node_from_tpg(
 	}
 }
 
-/*	__core_tpg_get_initiator_node_acl():
+/*	__target_get_initiator_node_acl():
  *
  *	mutex_lock(&tpg->acl_node_mutex); must be held when calling
  */
-struct se_node_acl *__core_tpg_get_initiator_node_acl(
+struct se_node_acl *__target_get_initiator_node_acl(
 	struct se_portal_group *tpg,
 	const char *initiatorname)
 {
@@ -101,23 +101,23 @@ struct se_node_acl *__core_tpg_get_initiator_node_acl(
 	return NULL;
 }
 
-/*	core_tpg_get_initiator_node_acl():
+/*	target_get_initiator_node_acl():
  *
  *
  */
-struct se_node_acl *core_tpg_get_initiator_node_acl(
+struct se_node_acl *target_get_initiator_node_acl(
 	struct se_portal_group *tpg,
 	unsigned char *initiatorname)
 {
 	struct se_node_acl *acl;
 
 	mutex_lock(&tpg->acl_node_mutex);
-	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
+	acl = __target_get_initiator_node_acl(tpg, initiatorname);
 	mutex_unlock(&tpg->acl_node_mutex);
 
 	return acl;
 }
-EXPORT_SYMBOL(core_tpg_get_initiator_node_acl);
+EXPORT_SYMBOL(target_get_initiator_node_acl);
 
 /*	core_tpg_add_node_to_devs():
  *
@@ -250,17 +250,17 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 	return 0;
 }
 
-/*	core_tpg_check_initiator_node_acl()
+/*	target_check_initiator_node_acl()
  *
  *
  */
-struct se_node_acl *core_tpg_check_initiator_node_acl(
+struct se_node_acl *target_check_initiator_node_acl(
 	struct se_portal_group *tpg,
 	unsigned char *initiatorname)
 {
 	struct se_node_acl *acl;
 
-	acl = core_tpg_get_initiator_node_acl(tpg, initiatorname);
+	acl = target_get_initiator_node_acl(tpg, initiatorname);
 	if (acl)
 		return acl;
 
@@ -317,7 +317,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 
 	return acl;
 }
-EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
+EXPORT_SYMBOL(target_check_initiator_node_acl);
 
 void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 {
@@ -325,11 +325,11 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 		cpu_relax();
 }
 
-/*	core_tpg_add_initiator_node_acl():
+/*	target_tadd_initiator_node_acl():
  *
  *
  */
-struct se_node_acl *core_tpg_add_initiator_node_acl(
+struct se_node_acl *target_add_initiator_node_acl(
 	struct se_portal_group *tpg,
 	struct se_node_acl *se_nacl,
 	const char *initiatorname,
@@ -338,7 +338,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	struct se_node_acl *acl = NULL;
 
 	mutex_lock(&tpg->acl_node_mutex);
-	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
+	acl = __target_get_initiator_node_acl(tpg, initiatorname);
 	if (acl) {
 		if (acl->dynamic_node_acl) {
 			acl->dynamic_node_acl = 0;
@@ -415,13 +415,13 @@ done:
 
 	return acl;
 }
-EXPORT_SYMBOL(core_tpg_add_initiator_node_acl);
+EXPORT_SYMBOL(target_add_initiator_node_acl);
 
-/*	core_tpg_del_initiator_node_acl():
+/*	target_del_initiator_node_acl():
  *
  *
  */
-int core_tpg_del_initiator_node_acl(
+int target_del_initiator_node_acl(
 	struct se_portal_group *tpg,
 	struct se_node_acl *acl,
 	int force)
@@ -469,7 +469,7 @@ int core_tpg_del_initiator_node_acl(
 	wait_for_completion(&acl->acl_free_comp);
 
 	core_tpg_wait_for_nacl_pr_ref(acl);
-	core_clear_initiator_node_from_tpg(acl, tpg);
+	target_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
 	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
@@ -479,13 +479,13 @@ int core_tpg_del_initiator_node_acl(
 
 	return 0;
 }
-EXPORT_SYMBOL(core_tpg_del_initiator_node_acl);
+EXPORT_SYMBOL(target_del_initiator_node_acl);
 
-/*	core_tpg_set_initiator_node_queue_depth():
+/*	target_set_initiator_node_queue_depth():
  *
  *
  */
-int core_tpg_set_initiator_node_queue_depth(
+int target_set_initiator_node_queue_depth(
 	struct se_portal_group *tpg,
 	unsigned char *initiatorname,
 	u32 queue_depth,
@@ -497,7 +497,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	int dynamic_acl = 0;
 
 	mutex_lock(&tpg->acl_node_mutex);
-	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
+	acl = __target_get_initiator_node_acl(tpg, initiatorname);
 	if (!acl) {
 		pr_err("Access Control List entry for %s Initiator"
 			" Node %s does not exists for TPG %hu, ignoring"
@@ -590,15 +590,15 @@ int core_tpg_set_initiator_node_queue_depth(
 
 	return 0;
 }
-EXPORT_SYMBOL(core_tpg_set_initiator_node_queue_depth);
+EXPORT_SYMBOL(target_set_initiator_node_queue_depth);
 
-/*	core_tpg_set_initiator_node_tag():
+/*	target_set_initiator_node_tag():
  *
  *	Initiator nodeacl tags are not used internally, but may be used by
  *	userspace to emulate aliases or groups.
  *	Returns length of newly-set tag or -EINVAL.
  */
-int core_tpg_set_initiator_node_tag(
+int target_set_initiator_node_tag(
 	struct se_portal_group *tpg,
 	struct se_node_acl *acl,
 	const char *new_tag)
@@ -613,7 +613,7 @@ int core_tpg_set_initiator_node_tag(
 
 	return snprintf(acl->acl_tag, MAX_ACL_TAG_SIZE, "%s", new_tag);
 }
-EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
+EXPORT_SYMBOL(target_set_initiator_node_tag);
 
 static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 {
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 72187c6..85dde28 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -220,8 +220,8 @@ static struct se_node_acl *ft_add_acl(
 	acl->node_auth.port_name = wwpn;
 
 	q_depth = 32;		/* XXX bogus default - get from tpg? */
-	return core_tpg_add_initiator_node_acl(&tpg->se_tpg,
-				&acl->se_node_acl, name, q_depth);
+	return target_add_initiator_node_acl(&tpg->se_tpg,
+					     &acl->se_node_acl, name, q_depth);
 }
 
 static void ft_del_acl(struct se_node_acl *se_acl)
@@ -238,7 +238,7 @@ static void ft_del_acl(struct se_node_acl *se_acl)
 	pr_debug("del acl %p se_acl %p tpg %p se_tpg %p\n",
 		    acl, se_acl, tpg, &tpg->se_tpg);
 
-	core_tpg_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
+	target_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
 	kfree(acl);
 }
 
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 6e0a019..81a8b07 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -1509,11 +1509,11 @@ static struct se_node_acl *usbg_make_nodeacl(
 
 	nexus_depth = 1;
 	/*
-	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * se_nacl_new may be released by target_add_initiator_node_acl()
 	 * when converting a NodeACL from demo mode -> explict
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
-				name, nexus_depth);
+	se_nacl = target_add_initiator_node_acl(se_tpg, se_nacl_new,
+						name, nexus_depth);
 	if (IS_ERR(se_nacl)) {
 		usbg_release_fabric_acl(se_tpg, se_nacl_new);
 		return se_nacl;
@@ -1531,7 +1531,7 @@ static void usbg_drop_nodeacl(struct se_node_acl *se_acl)
 {
 	struct usbg_nacl *nacl = container_of(se_acl,
 				struct usbg_nacl, se_node_acl);
-	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
+	target_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
 	kfree(nacl);
 }
 
@@ -1732,10 +1732,10 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 	 * struct se_node_acl for the tcm_vhost struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
-	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-			se_tpg, name);
+	tv_nexus->tvn_se_sess->se_node_acl = target_check_initiator_node_acl(
+							se_tpg, name);
 	if (!tv_nexus->tvn_se_sess->se_node_acl) {
-		pr_debug("core_tpg_check_initiator_node_acl() failed"
+		pr_debug("target_check_initiator_node_acl() failed"
 				" for %s\n", name);
 		goto err_session;
 	}
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 71df240..7e745fd 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1834,11 +1834,11 @@ vhost_scsi_make_nodeacl(struct se_portal_group *se_tpg,
 
 	nexus_depth = 1;
 	/*
-	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * se_nacl_new may be released by target_add_initiator_node_acl()
 	 * when converting a NodeACL from demo mode -> explict
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
-				name, nexus_depth);
+	se_nacl = target_add_initiator_node_acl(se_tpg, se_nacl_new,
+						name, nexus_depth);
 	if (IS_ERR(se_nacl)) {
 		vhost_scsi_release_fabric_acl(se_tpg, se_nacl_new);
 		return se_nacl;
@@ -1856,7 +1856,7 @@ static void vhost_scsi_drop_nodeacl(struct se_node_acl *se_acl)
 {
 	struct vhost_scsi_nacl *nacl = container_of(se_acl,
 				struct vhost_scsi_nacl, se_node_acl);
-	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
+	target_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
 	kfree(nacl);
 }
 
@@ -1947,11 +1947,11 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
-	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
+	tv_nexus->tvn_se_sess->se_node_acl = target_check_initiator_node_acl(
 				se_tpg, (unsigned char *)name);
 	if (!tv_nexus->tvn_se_sess->se_node_acl) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_debug("core_tpg_check_initiator_node_acl() failed"
+		pr_debug("target_check_initiator_node_acl() failed"
 				" for %s\n", name);
 		goto out;
 	}
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 578fc93..e33c67b 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -148,17 +148,17 @@ void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
 void	__target_execute_cmd(struct se_cmd *);
 int	transport_lookup_tmr_lun(struct se_cmd *, u32);
 
-struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
+struct se_node_acl *target_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
-struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
+struct se_node_acl *target_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
-struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *,
+struct se_node_acl *target_add_initiator_node_acl(struct se_portal_group *,
 		struct se_node_acl *, const char *, u32);
-int	core_tpg_del_initiator_node_acl(struct se_portal_group *,
+int	target_del_initiator_node_acl(struct se_portal_group *,
 		struct se_node_acl *, int);
-int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
+int	target_set_initiator_node_queue_depth(struct se_portal_group *,
 		unsigned char *, u32, int);
-int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
+int	target_set_initiator_node_tag(struct se_portal_group *,
 		struct se_node_acl *, const char *);
 int	core_tpg_register(struct target_core_fabric_ops *, struct se_wwn *,
 		struct se_portal_group *, void *, int);
-- 
1.9.1
