From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 28/32] target: Convert acl_pr_ref_count to kref
Date: Fri, 13 Dec 2013 15:59:16 -0800
Message-ID: <1386979160-6928-29-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In fabrics' drop_nodeacl function, do not kfree the nacl. We are
now calling fabrics' tpg_release_fabric_acl later when its refcount
goes to zero, which will kfree it.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/target/tcm_mod_builder.py      |    1 -
 drivers/infiniband/ulp/srpt/ib_srpt.c        |    1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    7 +----
 drivers/target/iscsi/iscsi_target_configfs.c |    2 -
 drivers/target/sbp/sbp_target.c              |    4 ---
 drivers/target/target_core_internal.h        |   22 ++++++++++++++++-
 drivers/target/target_core_pr.c              |   24 ++++++------------
 drivers/target/target_core_tpg.c             |   34 +++++--------------------
 drivers/target/target_core_transport.c       |   12 ++-------
 drivers/target/tcm_fc/tfc_conf.c             |    1 -
 drivers/usb/gadget/tcm_usb_gadget.c          |    3 --
 drivers/vhost/scsi.c                         |    3 --
 include/target/target_core_base.h            |    3 +-
 13 files changed, 41 insertions(+), 76 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 230ce71..c8e0572 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -285,7 +285,6 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
 	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
 	buf += "	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"
-	buf += "	kfree(nacl);\n"
 	buf += "}\n\n"
 
 	buf += "static struct se_portal_group *" + fabric_mod_name + "_make_tpg(\n"
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 520a7e5..4995b91 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3645,7 +3645,6 @@ static void srpt_drop_nodeacl(struct se_node_acl *se_nacl)
 	list_del(&nacl->list);
 	spin_unlock_irq(&sport->port_acl_lock);
 	core_tpg_del_initiator_node_acl(&sport->port_tpg_1, se_nacl, 1);
-	srpt_release_fabric_acl(NULL, se_nacl);
 }
 
 static ssize_t srpt_tpg_attrib_show_srp_max_rdma_size(
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7eb19be..4fe684a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -828,12 +828,7 @@ static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
 
 static void tcm_qla2xxx_drop_nodeacl(struct se_node_acl *se_acl)
 {
-	struct se_portal_group *se_tpg = se_acl->se_tpg;
-	struct tcm_qla2xxx_nacl *nacl = container_of(se_acl,
-				struct tcm_qla2xxx_nacl, se_node_acl);
-
-	core_tpg_del_initiator_node_acl(se_tpg, se_acl, 1);
-	kfree(nacl);
+	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
 }
 
 /* Start items for tcm_qla2xxx_tpg_attrib_cit */
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index e3318ed..bd05ab5 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -916,7 +916,6 @@ static struct se_node_acl *lio_target_make_nodeacl(
 		pr_err("Unable to allocate memory for"
 				" stats_cg->default_groups\n");
 		core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
-		kfree(acl);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -947,7 +946,6 @@ static void lio_target_drop_nodeacl(
 	kfree(stats_cg->default_groups);
 
 	core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
-	kfree(acl);
 }
 
 /* End items for lio_target_acl_cit */
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 103998c..6fabd9c 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2126,11 +2126,7 @@ static struct se_node_acl *sbp_make_nodeacl(
 
 static void sbp_drop_nodeacl(struct se_node_acl *se_acl)
 {
-	struct sbp_nacl *nacl =
-		container_of(se_acl, struct sbp_nacl, se_node_acl);
-
 	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
-	kfree(nacl);
 }
 
 static int sbp_post_link_lun(
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 5b232a7..65a4de9 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -82,10 +82,11 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 /* target_core_tpg.c */
 extern struct se_device *g_lun0_dev;
 
+void core_clear_initiator_node_from_tpg(struct se_node_acl *,
+					struct se_portal_group *);
 struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		const char *);
 void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
-void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
@@ -115,6 +116,25 @@ static inline void release_lun(struct kref *kref)
 #define get_lun(x) kref_get(&x->refcount)
 #define put_lun(x) kref_put(&x->refcount, release_lun)
 
+static inline void target_release_nacl(struct kref *kref)
+{
+	struct se_node_acl *nacl = container_of(kref,
+						struct se_node_acl, refcount);
+	struct se_portal_group *tpg = nacl->se_tpg;
+
+	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
+		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), nacl->queue_depth,
+		tpg->se_tpg_tfo->get_fabric_name(), nacl->initiatorname);
+
+	core_clear_initiator_node_from_tpg(nacl, tpg);
+	core_free_device_list_for_node(nacl, tpg);
+	tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, nacl);
+}
+
+#define get_nacl(x) kref_get(&x->refcount)
+#define put_nacl(x) kref_put(&x->refcount, target_release_nacl)
+
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index e2b656b..835958b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1354,16 +1354,14 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 	struct se_portal_group *tpg = nacl->se_tpg;
 
 	if (nacl->dynamic_node_acl) {
-		atomic_dec(&nacl->acl_pr_ref_count);
-		smp_mb__after_atomic_dec();
+		put_nacl(nacl);
 		return;
 	}
 
 	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
 			&nacl->acl_group.cg_item);
 
-	atomic_dec(&nacl->acl_pr_ref_count);
-	smp_mb__after_atomic_dec();
+	put_nacl(nacl);
 }
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
@@ -1553,10 +1551,8 @@ core_scsi3_decode_spec_i_port(
 			spin_lock_irq(&tmp_tpg->acl_node_lock);
 			dest_node_acl = __core_tpg_get_initiator_node_acl(
 						tmp_tpg, i_str);
-			if (dest_node_acl) {
-				atomic_inc(&dest_node_acl->acl_pr_ref_count);
-				smp_mb__after_atomic_inc();
-			}
+			if (dest_node_acl)
+				get_nacl(dest_node_acl);
 			spin_unlock_irq(&tmp_tpg->acl_node_lock);
 
 			if (!dest_node_acl) {
@@ -1568,8 +1564,7 @@ core_scsi3_decode_spec_i_port(
 			if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
 				pr_err("configfs_depend_item() failed"
 					" for dest_node_acl->acl_group\n");
-				atomic_dec(&dest_node_acl->acl_pr_ref_count);
-				smp_mb__after_atomic_dec();
+				put_nacl(dest_node_acl);
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
@@ -3253,10 +3248,8 @@ after_iport_check:
 	spin_lock_irq(&dest_se_tpg->acl_node_lock);
 	dest_node_acl = __core_tpg_get_initiator_node_acl(dest_se_tpg,
 				initiator_str);
-	if (dest_node_acl) {
-		atomic_inc(&dest_node_acl->acl_pr_ref_count);
-		smp_mb__after_atomic_inc();
-	}
+	if (dest_node_acl)
+		get_nacl(dest_node_acl);
 	spin_unlock_irq(&dest_se_tpg->acl_node_lock);
 
 	if (!dest_node_acl) {
@@ -3270,8 +3263,7 @@ after_iport_check:
 	if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
 		pr_err("core_scsi3_nodeacl_depend_item() for"
 			" dest_node_acl\n");
-		atomic_dec(&dest_node_acl->acl_pr_ref_count);
-		smp_mb__after_atomic_dec();
+		put_nacl(dest_node_acl);
 		dest_node_acl = NULL;
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 0e30ced..6aaf50f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -53,7 +53,7 @@ static LIST_HEAD(tpg_list);
  *
  *
  */
-static void core_clear_initiator_node_from_tpg(
+void core_clear_initiator_node_from_tpg(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
@@ -251,7 +251,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	init_completion(&acl->acl_free_comp);
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
-	atomic_set(&acl->acl_pr_ref_count, 0);
+	kref_init(&acl->refcount);
 	acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
@@ -264,8 +264,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	acl->rb_device_list = RB_ROOT;
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
-		core_free_device_list_for_node(acl, tpg);
-		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
+		put_nacl(acl);
 		return NULL;
 	}
 	/*
@@ -291,12 +290,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 }
 EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
 
-void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
-{
-	while (atomic_read(&nacl->acl_pr_ref_count) != 0)
-		cpu_relax();
-}
-
 void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 {
 	struct rb_node *node;
@@ -374,7 +367,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	init_completion(&acl->acl_free_comp);
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
-	atomic_set(&acl->acl_pr_ref_count, 0);
+	kref_init(&acl->refcount);
 	acl->queue_depth = queue_depth;
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
@@ -386,8 +379,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	acl->rb_device_list = RB_ROOT;
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
-		core_free_device_list_for_node(acl, tpg);
-		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
+		put_nacl(acl);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -457,14 +449,7 @@ int core_tpg_del_initiator_node_acl(
 	 */
 	wait_for_completion(&acl->acl_free_comp);
 
-	core_tpg_wait_for_nacl_pr_ref(acl);
-	core_clear_initiator_node_from_tpg(acl, tpg);
-	core_free_device_list_for_node(acl, tpg);
-
-	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
-		tpg->se_tpg_tfo->get_fabric_name(), acl->initiatorname);
+	put_nacl(acl);
 
 	return 0;
 }
@@ -693,13 +678,8 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 			acl_node) {
 		list_del(&nacl->acl_node);
 		se_tpg->num_node_acls--;
-		spin_unlock_irq(&se_tpg->acl_node_lock);
-
-		core_tpg_wait_for_nacl_pr_ref(nacl);
-		core_free_device_list_for_node(nacl, se_tpg);
-		se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg, nacl);
 
-		spin_lock_irq(&se_tpg->acl_node_lock);
+		put_nacl(nacl);
 	}
 	spin_unlock_irq(&se_tpg->acl_node_lock);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a6ef32a..51e294b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -433,7 +433,6 @@ void transport_deregister_session(struct se_session *se_sess)
 	struct target_core_fabric_ops *se_tfo;
 	struct se_node_acl *se_nacl;
 	unsigned long flags;
-	bool comp_nacl = true;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
@@ -458,13 +457,8 @@ void transport_deregister_session(struct se_session *se_sess)
 		if (!se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
 			list_del(&se_nacl->acl_node);
 			se_tpg->num_node_acls--;
-			spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
-			core_tpg_wait_for_nacl_pr_ref(se_nacl);
-			core_free_device_list_for_node(se_nacl, se_tpg);
-			se_tfo->tpg_release_fabric_acl(se_tpg, se_nacl);
-
-			comp_nacl = false;
-			spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
+			put_nacl(se_nacl);
+			se_nacl = NULL;
 		}
 	}
 	spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
@@ -476,7 +470,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
 	 * removal context.
 	 */
-	if (se_nacl && comp_nacl == true)
+	if (se_nacl)
 		target_put_nacl(se_nacl);
 
 	transport_free_session(se_sess);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 47d0038..2a44ad6 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -239,7 +239,6 @@ static void ft_del_acl(struct se_node_acl *se_acl)
 		    acl, se_acl, tpg, &tpg->se_tpg);
 
 	core_tpg_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
-	kfree(acl);
 }
 
 struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 6c3d795..2cedb4b 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1526,10 +1526,7 @@ static struct se_node_acl *usbg_make_nodeacl(
 
 static void usbg_drop_nodeacl(struct se_node_acl *se_acl)
 {
-	struct usbg_nacl *nacl = container_of(se_acl,
-				struct usbg_nacl, se_node_acl);
 	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
-	kfree(nacl);
 }
 
 struct usbg_tpg *the_only_tpg_I_currently_have;
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f175629..a93169b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1687,10 +1687,7 @@ tcm_vhost_make_nodeacl(struct se_portal_group *se_tpg,
 
 static void tcm_vhost_drop_nodeacl(struct se_node_acl *se_acl)
 {
-	struct tcm_vhost_nacl *nacl = container_of(se_acl,
-				struct tcm_vhost_nacl, se_node_acl);
 	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
-	kfree(nacl);
 }
 
 static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index dc8bf39..393bcfd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -513,8 +513,7 @@ struct se_node_acl {
 	u64			read_bytes;
 	u64			write_bytes;
 	spinlock_t		stats_lock;
-	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
-	atomic_t		acl_pr_ref_count;
+	struct kref		refcount;
 	struct rb_root		rb_device_list;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
-- 
1.7.1
