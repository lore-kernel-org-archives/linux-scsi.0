From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 08/22] target/pr: Convert se_dev_entry to percpu-refcount for RCU
Date: Fri, 27 Mar 2015 08:04:58 +0000
Message-ID: <1427443512-8925-9-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34980 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbbC0IGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:13 -0400
Received: by obcjt1 with SMTP id jt1so65620220obc.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:12 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts se_dev_entry->pr_ref_count access to use modern
percpu reference counting.

It updates core_enable_device_list_for_node() to percpu_ref_init()
when se_dev_entry is being enabled.

It also updates core_disable_device_list_for_node() to percpu_ref_kill()
and now waits for outstanding PR references to drop to zero.

Also, go ahead and convert core_get_se_deve_from_rtpi code to RCU read
path for RELATIVE TARGET PORT IDENTIFIER lookup.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 54 ++++++++++++++++++---------
 drivers/target/target_core_pr.c     | 73 +++++++++++++++++++++++--------------
 drivers/target/target_core_tpg.c    |  1 -
 include/target/target_core_base.h   |  3 +-
 4 files changed, 85 insertions(+), 46 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1053a2d..473543e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -217,18 +217,23 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	struct se_portal_group *tpg = nacl->se_tpg;
 	u32 i;
 
-	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		rcu_read_lock();
+		deve = rcu_dereference(nacl->lun_entry_hlist[i]);
+		if (!deve) {
+			rcu_read_unlock();
 			continue;
-
+		}
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)) {
+			rcu_read_unlock();
+			continue;
+		}
 		lun = deve->se_lun;
 		if (!lun) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
+			rcu_read_unlock();
 			continue;
 		}
 		port = lun->lun_sep;
@@ -236,17 +241,18 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
+			rcu_read_unlock();
 			continue;
 		}
-		if (port->sep_rtpi != rtpi)
+		if (port->sep_rtpi != rtpi) {
+			rcu_read_unlock();
 			continue;
-
-		atomic_inc_mb(&deve->pr_ref_count);
-		spin_unlock_irq(&nacl->device_list_lock);
+		}
+		percpu_ref_get(&deve->pr_ref);
+		rcu_read_unlock();
 
 		return deve;
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
 
 	return NULL;
 }
@@ -312,6 +318,13 @@ void core_update_device_list_access(
 	synchronize_rcu();
 }
 
+static void target_pr_ref_release(struct percpu_ref *ref)
+{
+	struct se_dev_entry *deve = container_of(ref, struct se_dev_entry,
+						 pr_ref);
+	complete(&deve->pr_comp);
+}
+
 /*      core_enable_device_list_for_node():
  *
  *
@@ -352,6 +365,9 @@ int core_enable_device_list_for_node(
 		return 0;
 	}
 
+	percpu_ref_init(&deve->pr_ref, target_pr_ref_release, 0, GFP_KERNEL);
+	init_completion(&deve->pr_comp);
+
 	deve->mapped_lun = mapped_lun;
 	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
 
@@ -412,13 +428,6 @@ int core_disable_device_list_for_node(
 	list_del(&deve->alua_port_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 	/*
-	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
-	 * PR operation to complete.
-	 */
-	while (atomic_read(&deve->pr_ref_count) != 0)
-		cpu_relax();
-
-	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
 	spin_lock_irq(&nacl->lun_entry_lock);
@@ -431,7 +440,18 @@ int core_disable_device_list_for_node(
 	spin_unlock_irq(&nacl->lun_entry_lock);
 	rcu_read_unlock();
 
+	/*
+	 * Wait for RCU read critical sections to complete after
+	 * se_deve pointer reassignments.
+	 */
 	synchronize_rcu();
+	/*
+	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
+	 * PR operation to complete.
+	 */
+	percpu_ref_kill(&deve->pr_ref);
+	wait_for_completion(&deve->pr_comp);
+	percpu_ref_exit(&deve->pr_ref);
 
 	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
 	return 0;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2de6fb8..123e449 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -49,7 +49,7 @@ struct pr_transport_id_holder {
 	struct t10_pr_registration *dest_pr_reg;
 	struct se_portal_group *dest_tpg;
 	struct se_node_acl *dest_node_acl;
-	struct se_dev_entry *dest_se_deve;
+	struct se_dev_entry __rcu *dest_se_deve;
 	struct list_head dest_list;
 };
 
@@ -217,7 +217,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	tpg = sess->se_tpg;
 	pr_debug("SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
+		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
 out_unlock:
@@ -266,7 +266,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 			dev->dev_reserved_node_acl->initiatorname);
 		pr_err("Current attempt - LUN: %u -> MAPPED LUN: %u"
 			" from %s \n", cmd->se_lun->unpacked_lun,
-			cmd->se_deve->mapped_lun,
+			cmd->orig_fe_lun,
 			sess->se_node_acl->initiatorname);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_unlock;
@@ -280,7 +280,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	}
 	pr_debug("SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
 		" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
+		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
 out_unlock:
@@ -305,6 +305,7 @@ static int core_scsi3_pr_seq_non_holder(
 	unsigned char *cdb = cmd->t_task_cdb;
 	struct se_dev_entry *se_deve;
 	struct se_session *se_sess = cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	int other_cdb = 0, ignore_reg;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
 	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
@@ -312,7 +313,8 @@ static int core_scsi3_pr_seq_non_holder(
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
 
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	se_deve = rcu_dereference(nacl->lun_entry_hlist[cmd->orig_fe_lun]);
 	/*
 	 * Determine if the registration should be ignored due to
 	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
@@ -353,8 +355,10 @@ static int core_scsi3_pr_seq_non_holder(
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
@@ -720,7 +724,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (strcmp(nacl->initiatorname, nacl_tmp->initiatorname))
 				continue;
 
-			atomic_inc_mb(&deve_tmp->pr_ref_count);
+			percpu_ref_get(&deve_tmp->pr_ref);
 			spin_unlock_bh(&port->sep_alua_lock);
 			/*
 			 * Grab a configfs group dependency that is released
@@ -733,7 +737,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
-				atomic_dec_mb(&deve_tmp->pr_ref_count);
+				percpu_ref_put(&deve_tmp->pr_ref);
 				goto out;
 			}
 			/*
@@ -748,7 +752,6 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
-				atomic_dec_mb(&deve_tmp->pr_ref_count);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -881,7 +884,7 @@ static int __core_scsi3_check_aptpl_registration(
 	struct se_lun *lun,
 	u32 target_lun,
 	struct se_node_acl *nacl,
-	struct se_dev_entry *deve)
+	u32 mapped_lun)
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
@@ -909,13 +912,12 @@ static int __core_scsi3_check_aptpl_registration(
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
@@ -953,13 +955,14 @@ int core_scsi3_check_aptpl_registration(
 	struct se_node_acl *nacl,
 	u32 mapped_lun)
 {
-	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
+	struct se_dev_entry *deve;
 
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
 
 	return __core_scsi3_check_aptpl_registration(dev, tpg, lun,
-				lun->unpacked_lun, nacl, deve);
+						     lun->unpacked_lun, nacl,
+						     mapped_lun);
 }
 
 static void __core_scsi3_dump_registration(
@@ -1407,14 +1410,21 @@ static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 
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
+		percpu_ref_put(&se_deve->pr_ref);
 		return;
 	}
 	nacl = lun_acl->se_lun_nacl;
@@ -1423,13 +1433,14 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
 			&lun_acl->se_lun_group.cg_item);
 
-	atomic_dec_mb(&se_deve->pr_ref_count);
+	percpu_ref_put(&se_deve->pr_ref);
 }
 
 static sense_reason_t
 core_scsi3_decode_spec_i_port(
 	struct se_cmd *cmd,
 	struct se_portal_group *tpg,
+	struct se_dev_entry *local_se_deve,
 	unsigned char *l_isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -1440,7 +1451,7 @@ core_scsi3_decode_spec_i_port(
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *dest_node_acl = NULL;
-	struct se_dev_entry *dest_se_deve = NULL, *local_se_deve;
+	struct se_dev_entry __rcu *dest_se_deve = NULL;
 	struct t10_pr_registration *dest_pr_reg, *local_pr_reg, *pr_reg_e;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	LIST_HEAD(tid_dest_list);
@@ -1454,7 +1465,6 @@ core_scsi3_decode_spec_i_port(
 	int dest_local_nexus;
 	u32 dest_rtpi = 0;
 
-	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
 	 * local_node_acl and local_se_deve pointers and add to
@@ -1469,7 +1479,6 @@ core_scsi3_decode_spec_i_port(
 	INIT_LIST_HEAD(&tidh_new->dest_list);
 	tidh_new->dest_tpg = tpg;
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
-	tidh_new->dest_se_deve = local_se_deve;
 
 	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
@@ -1478,6 +1487,7 @@ core_scsi3_decode_spec_i_port(
 		kfree(tidh_new);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+	rcu_assign_pointer(tidh_new->dest_se_deve, local_se_deve);
 	tidh_new->dest_pr_reg = local_pr_reg;
 	/*
 	 * The local I_T nexus does not hold any configfs dependances,
@@ -1644,7 +1654,7 @@ core_scsi3_decode_spec_i_port(
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
-			atomic_dec_mb(&dest_se_deve->pr_ref_count);
+			percpu_ref_put(&dest_se_deve->pr_ref);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1999,6 +2009,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		bool aptpl, bool all_tg_pt, bool spec_i_pt, enum register_type register_type)
 {
 	struct se_session *se_sess = cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *se_deve;
 	struct se_lun *se_lun = cmd->se_lun;
@@ -2014,7 +2025,9 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+
+	rcu_read_lock();
+	se_deve = rcu_dereference(nacl->lun_entry_hlist[cmd->orig_fe_lun]);
 
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
@@ -2030,14 +2043,16 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
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
@@ -2050,6 +2065,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					register_type, 0)) {
 				pr_err("Unable to allocate"
 					" struct t10_pr_registration\n");
+				rcu_read_unlock();
 				return TCM_INVALID_PARAMETER_LIST;
 			}
 		} else {
@@ -2061,14 +2077,17 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
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
 
@@ -3345,7 +3364,7 @@ after_iport_check:
 
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 		pr_err("core_scsi3_lunacl_depend_item() failed\n");
-		atomic_dec_mb(&dest_se_deve->pr_ref_count);
+		percpu_ref_put(&dest_se_deve->pr_ref);
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 15a683b..2813bd4 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -245,7 +245,6 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 		deve = nacl->lun_entry_hlist[i];
 
 		atomic_set(&deve->ua_count, 0);
-		atomic_set(&deve->pr_ref_count, 0);
 		spin_lock_init(&deve->ua_lock);
 		INIT_LIST_HEAD(&deve->alua_port_list);
 		INIT_LIST_HEAD(&deve->ua_list);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a826e6f..c4d182f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -664,7 +664,8 @@ struct se_dev_entry {
 	u64			write_bytes;
 	atomic_t		ua_count;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
-	atomic_t		pr_ref_count;
+	struct percpu_ref	pr_ref;
+	struct completion	pr_comp;
 	struct se_lun_acl	*se_lun_acl;
 	spinlock_t		ua_lock;
 	struct se_lun		*se_lun;
-- 
1.9.1

