From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 06/12] target/pr: Convert se_dev_entry to kref for RCU
Date: Tue, 12 May 2015 09:25:30 +0000
Message-ID: <1431422736-29125-7-git-send-email-nab@daterainc.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts se_dev_entry->pr_ref_count access to use modern
struct kref counting.

It updates core_enable_device_list_for_node() to kref_init() when se_dev_entry
is being enabled, and updates core_disable_device_list_for_node() to kref_put()
and blocks on ->pr_comp waiting for outstanding PR references to drop.

Also, go ahead and convert core_get_se_deve_from_rtpi() code to use pr_kref
for RELATIVE TARGET PORT IDENTIFIER lookup.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c   | 27 ++++++++----
 drivers/target/target_core_internal.h |  1 +
 drivers/target/target_core_pr.c       | 78 ++++++++++++++++++++++-------------
 include/target/target_core_base.h     |  4 +-
 4 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 36e7d13..911758b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -203,7 +203,7 @@ EXPORT_SYMBOL(transport_lookup_tmr_lun);
 
 /*
  * This function is called from core_scsi3_emulate_pro_register_and_move()
- * and core_scsi3_decode_spec_i_port(), and will increment &deve->pr_ref_count
+ * and core_scsi3_decode_spec_i_port(), and will increment &deve->pr_kref
  * when a matching rtpi is found.
  */
 struct se_dev_entry *core_get_se_deve_from_rtpi(
@@ -237,7 +237,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 		if (port->sep_rtpi != rtpi)
 			continue;
 
-		atomic_inc_mb(&deve->pr_ref_count);
+		kref_get(&deve->pr_kref);
 		rcu_read_unlock();
 
 		return deve;
@@ -323,6 +323,13 @@ struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u32 mapped_
 }
 EXPORT_SYMBOL(target_nacl_find_deve);
 
+void target_pr_kref_release(struct kref *kref)
+{
+	struct se_dev_entry *deve = container_of(kref, struct se_dev_entry,
+						 pr_kref);
+	complete(&deve->pr_comp);
+}
+
 /*      core_enable_device_list_for_node():
  *
  *
@@ -353,6 +360,9 @@ int core_enable_device_list_for_node(
 	new->mapped_lun = mapped_lun;
 	new->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
 
+	kref_init(&new->pr_kref);
+	init_completion(&new->pr_comp);
+
 	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
 		new->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
 	else
@@ -377,6 +387,9 @@ int core_enable_device_list_for_node(
 		list_add_tail(&new->alua_port_list, &port->sep_alua_list);
 		spin_unlock_bh(&port->sep_alua_lock);
 
+		kref_put(&orig->pr_kref, target_pr_kref_release);
+		wait_for_completion(&orig->pr_comp);
+
 		call_rcu(&orig->rcu_head, target_nacl_deve_callrcu);
 		return 0;
 	}
@@ -432,13 +445,6 @@ int core_disable_device_list_for_node(
 	list_del(&orig->alua_port_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 	/*
-	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
-	 * PR operation to complete.
-	 */
-	while (atomic_read(&orig->pr_ref_count) != 0)
-		cpu_relax();
-
-	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
 	core_scsi3_ua_release_all(orig);
@@ -450,6 +456,9 @@ int core_disable_device_list_for_node(
 	hlist_del_rcu(&orig->link);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
+	kref_put(&orig->pr_kref, target_pr_kref_release);
+	wait_for_completion(&orig->pr_comp);
+
 	/*
 	 * Fire off RCU callback to wait for any in process SPEC_I_PT=1
 	 * or REGISTER_AND_MOVE PR operation to complete.
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 9c4bce0..f57bb61 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -9,6 +9,7 @@ extern struct mutex g_device_mutex;
 extern struct list_head g_device_list;
 
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
+void	target_pr_kref_release(struct kref *);
 int	core_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
 void	core_update_device_list_access(u32, u32, struct se_node_acl *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 721b664..c0b593a 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -48,7 +48,7 @@ struct pr_transport_id_holder {
 	struct t10_pr_registration *dest_pr_reg;
 	struct se_portal_group *dest_tpg;
 	struct se_node_acl *dest_node_acl;
-	struct se_dev_entry *dest_se_deve;
+	struct se_dev_entry __rcu *dest_se_deve;
 	struct list_head dest_list;
 };
 
@@ -232,7 +232,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	tpg = sess->se_tpg;
 	pr_debug("SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
+		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
 out_unlock:
@@ -281,7 +281,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 			dev->dev_reserved_node_acl->initiatorname);
 		pr_err("Current attempt - LUN: %u -> MAPPED LUN: %u"
 			" from %s \n", cmd->se_lun->unpacked_lun,
-			cmd->se_deve->mapped_lun,
+			cmd->orig_fe_lun,
 			sess->se_node_acl->initiatorname);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_unlock;
@@ -295,7 +295,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	}
 	pr_debug("SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
 		" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
+		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
 out_unlock:
@@ -320,6 +320,7 @@ static int core_scsi3_pr_seq_non_holder(
 	unsigned char *cdb = cmd->t_task_cdb;
 	struct se_dev_entry *se_deve;
 	struct se_session *se_sess = cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	int other_cdb = 0, ignore_reg;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
 	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
@@ -327,7 +328,8 @@ static int core_scsi3_pr_seq_non_holder(
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
 
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
 	/*
 	 * Determine if the registration should be ignored due to
 	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
@@ -368,8 +370,10 @@ static int core_scsi3_pr_seq_non_holder(
 			registered_nexus = 1;
 		break;
 	default:
+		rcu_read_unlock();
 		return -EINVAL;
 	}
+	rcu_read_unlock();
 	/*
 	 * Referenced from spc4r17 table 45 for *NON* PR holder access
 	 */
@@ -735,7 +739,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (strcmp(nacl->initiatorname, nacl_tmp->initiatorname))
 				continue;
 
-			atomic_inc_mb(&deve_tmp->pr_ref_count);
+			kref_get(&deve_tmp->pr_kref);
 			spin_unlock_bh(&port->sep_alua_lock);
 			/*
 			 * Grab a configfs group dependency that is released
@@ -748,7 +752,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
-				atomic_dec_mb(&deve_tmp->pr_ref_count);
+				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
 			}
 			/*
@@ -763,7 +767,6 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
-				atomic_dec_mb(&deve_tmp->pr_ref_count);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -896,7 +899,7 @@ static int __core_scsi3_check_aptpl_registration(
 	struct se_lun *lun,
 	u32 target_lun,
 	struct se_node_acl *nacl,
-	struct se_dev_entry *deve)
+	u32 mapped_lun)
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
@@ -924,13 +927,12 @@ static int __core_scsi3_check_aptpl_registration(
 				pr_reg_aptpl_list) {
 
 		if (!strcmp(pr_reg->pr_iport, i_port) &&
-		     (pr_reg->pr_res_mapped_lun == deve->mapped_lun) &&
+		     (pr_reg->pr_res_mapped_lun == mapped_lun) &&
 		    !(strcmp(pr_reg->pr_tport, t_port)) &&
 		     (pr_reg->pr_reg_tpgt == tpgt) &&
 		     (pr_reg->pr_aptpl_target_lun == target_lun)) {
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->pr_reg_deve = deve;
 			pr_reg->pr_reg_tg_pt_lun = lun;
 
 			list_del(&pr_reg->pr_reg_aptpl_list);
@@ -968,13 +970,12 @@ int core_scsi3_check_aptpl_registration(
 	struct se_node_acl *nacl,
 	u32 mapped_lun)
 {
-	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
-
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
 
 	return __core_scsi3_check_aptpl_registration(dev, tpg, lun,
-				lun->unpacked_lun, nacl, deve);
+						     lun->unpacked_lun, nacl,
+						     mapped_lun);
 }
 
 static void __core_scsi3_dump_registration(
@@ -1409,27 +1410,35 @@ static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 
 static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 {
-	struct se_lun_acl *lun_acl = se_deve->se_lun_acl;
+	struct se_lun_acl *lun_acl;
 	struct se_node_acl *nacl;
 	struct se_portal_group *tpg;
+
+	if (!se_deve) {
+		pr_err("core_scsi3_lunacl_undepend_item passed NULL se_deve\n");
+		dump_stack();
+		return;
+	}
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
+	lun_acl = se_deve->se_lun_acl;
 	if (!lun_acl) {
-		atomic_dec_mb(&se_deve->pr_ref_count);
+		kref_put(&se_deve->pr_kref, target_pr_kref_release);
 		return;
 	}
 	nacl = lun_acl->se_lun_nacl;
 	tpg = nacl->se_tpg;
 
 	target_undepend_item(&lun_acl->se_lun_group.cg_item);
-	atomic_dec_mb(&se_deve->pr_ref_count);
+	kref_put(&se_deve->pr_kref, target_pr_kref_release);
 }
 
 static sense_reason_t
 core_scsi3_decode_spec_i_port(
 	struct se_cmd *cmd,
 	struct se_portal_group *tpg,
+	struct se_dev_entry *local_se_deve,
 	unsigned char *l_isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -1440,7 +1449,7 @@ core_scsi3_decode_spec_i_port(
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *dest_node_acl = NULL;
-	struct se_dev_entry *dest_se_deve = NULL, *local_se_deve;
+	struct se_dev_entry __rcu *dest_se_deve = NULL;
 	struct t10_pr_registration *dest_pr_reg, *local_pr_reg, *pr_reg_e;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	LIST_HEAD(tid_dest_list);
@@ -1453,7 +1462,6 @@ core_scsi3_decode_spec_i_port(
 	int dest_local_nexus;
 	u32 dest_rtpi = 0;
 
-	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
 	 * local_node_acl and local_se_deve pointers and add to
@@ -1468,7 +1476,6 @@ core_scsi3_decode_spec_i_port(
 	INIT_LIST_HEAD(&tidh_new->dest_list);
 	tidh_new->dest_tpg = tpg;
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
-	tidh_new->dest_se_deve = local_se_deve;
 
 	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
@@ -1477,6 +1484,7 @@ core_scsi3_decode_spec_i_port(
 		kfree(tidh_new);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+	rcu_assign_pointer(tidh_new->dest_se_deve, local_se_deve);
 	tidh_new->dest_pr_reg = local_pr_reg;
 	/*
 	 * The local I_T nexus does not hold any configfs dependances,
@@ -1636,7 +1644,7 @@ core_scsi3_decode_spec_i_port(
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
-			atomic_dec_mb(&dest_se_deve->pr_ref_count);
+			kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1991,6 +1999,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		bool aptpl, bool all_tg_pt, bool spec_i_pt, enum register_type register_type)
 {
 	struct se_session *se_sess = cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *se_deve;
 	struct se_lun *se_lun = cmd->se_lun;
@@ -2006,7 +2015,14 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+
+	rcu_read_lock();
+	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!se_deve) {
+		pr_err("Unable to locate se_deve for PRO-REGISTER\n");
+		rcu_read_unlock();
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
 
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
@@ -2022,14 +2038,16 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		if (res_key) {
 			pr_warn("SPC-3 PR: Reservation Key non-zero"
 				" for SA REGISTER, returning CONFLICT\n");
+			rcu_read_unlock();
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
 		 * Do nothing but return GOOD status.
 		 */
-		if (!sa_res_key)
+		if (!sa_res_key) {
+			rcu_read_unlock();
 			return 0;
-
+		}
 		if (!spec_i_pt) {
 			/*
 			 * Perform the Service Action REGISTER on the Initiator
@@ -2042,6 +2060,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					register_type, 0)) {
 				pr_err("Unable to allocate"
 					" struct t10_pr_registration\n");
+				rcu_read_unlock();
 				return TCM_INVALID_PARAMETER_LIST;
 			}
 		} else {
@@ -2053,14 +2072,17 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			 * logic from of core_scsi3_alloc_registration() for
 			 * each TransportID provided SCSI Initiator Port/Device
 			 */
-			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg,
+			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg, se_deve,
 					isid_ptr, sa_res_key, all_tg_pt, aptpl);
-			if (ret != 0)
+			if (ret != 0) {
+				rcu_read_unlock();
 				return ret;
+			}
 		}
-
+		rcu_read_unlock();
 		return core_scsi3_update_and_write_aptpl(dev, aptpl);
 	}
+	rcu_read_unlock();
 
 	/* ok, existing registration */
 
@@ -3322,7 +3344,7 @@ after_iport_check:
 
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 		pr_err("core_scsi3_lunacl_depend_item() failed\n");
-		atomic_dec_mb(&dest_se_deve->pr_ref_count);
+		kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3057eff..1b06d27 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -585,7 +585,6 @@ struct se_node_acl {
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
 	struct hlist_head	lun_entry_hlist;
-	struct se_dev_entry	**device_list;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
 	struct mutex		lun_entry_mutex;
@@ -653,7 +652,8 @@ struct se_dev_entry {
 	u64			write_bytes;
 	atomic_t		ua_count;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
-	atomic_t		pr_ref_count;
+	struct kref		pr_kref;
+	struct completion	pr_comp;
 	struct se_node_acl	*se_node_acl;
 	struct se_lun_acl __rcu	*se_lun_acl;
 	spinlock_t		ua_lock;
-- 
1.9.1
