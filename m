From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 12/32] target: Convert t10_pr_registration to kref
Date: Fri, 13 Dec 2013 15:59:00 -0800
Message-ID: <1386979160-6928-13-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3LMX7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:31 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Free struct when kref becomes 0.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_pr.c   |   99 +++++++++++++++---------------------
 include/target/target_core_base.h |    2 +-
 2 files changed, 42 insertions(+), 59 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 9155df0..17a4c3b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -75,6 +75,17 @@ enum preempt_type {
 	PREEMPT_AND_ABORT,
 };
 
+static void release_pr_reg(struct kref *kref)
+{
+	struct t10_pr_registration *pr_reg = container_of(kref,
+							  struct t10_pr_registration, refcount);
+
+	kmem_cache_free(t10_pr_reg_cache, pr_reg);
+}
+
+#define get_pr_reg(x) kref_get(&x->refcount)
+#define put_pr_reg(x) kref_put(&x->refcount, release_pr_reg)
+
 static void __core_scsi3_complete_pro_release(struct se_device *, struct se_node_acl *,
 			struct t10_pr_registration *, int);
 
@@ -109,7 +120,6 @@ target_scsi2_reservation_check(struct se_cmd *cmd)
 
 static struct t10_pr_registration *core_scsi3_locate_pr_reg(struct se_device *,
 					struct se_node_acl *, struct se_session *);
-static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
 
 static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 {
@@ -144,17 +154,17 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 		 * as defined in SPC-2.
 		 */
 		if (pr_reg->pr_res_holder) {
-			core_scsi3_put_pr_reg(pr_reg);
+			put_pr_reg(pr_reg);
 			return 1;
 		}
 		if ((pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY) ||
 		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY) ||
 		    (pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
 		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
-			core_scsi3_put_pr_reg(pr_reg);
+			put_pr_reg(pr_reg);
 			return 1;
 		}
-		core_scsi3_put_pr_reg(pr_reg);
+		put_pr_reg(pr_reg);
 		conflict = 1;
 	} else {
 		/*
@@ -611,7 +621,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
-	atomic_set(&pr_reg->pr_res_holders, 0);
+	kref_init(&pr_reg->refcount);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
 	pr_reg->pr_res_mapped_lun = deve->mapped_lun;
@@ -795,7 +805,7 @@ int core_scsi3_alloc_aptpl_registration(
 	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
-	atomic_set(&pr_reg->pr_res_holders, 0);
+	kref_init(&pr_reg->refcount);
 	pr_reg->pr_reg_nacl = NULL;
 	pr_reg->pr_reg_deve = NULL;
 	pr_reg->pr_res_mapped_lun = mapped_lun;
@@ -1102,8 +1112,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 				if (dev->dev_attrib.enforce_pr_isids)
 					continue;
 			}
-			atomic_inc(&pr_reg->pr_res_holders);
-			smp_mb__after_atomic_inc();
+			get_pr_reg(pr_reg);
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
 		}
@@ -1117,8 +1126,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 		if (strcmp(isid, pr_reg->pr_reg_isid))
 			continue;
 
-		atomic_inc(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_inc();
+		get_pr_reg(pr_reg);
 		spin_unlock(&pr_tmpl->registration_lock);
 		return pr_reg;
 	}
@@ -1145,12 +1153,6 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 	return __core_scsi3_locate_pr_reg(dev, nacl, isid_ptr);
 }
 
-static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
-{
-	atomic_dec(&pr_reg->pr_res_holders);
-	smp_mb__after_atomic_dec();
-}
-
 static int core_scsi3_check_implicit_release(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg)
@@ -1213,7 +1215,6 @@ static void __core_scsi3_free_registration(
 {
 	struct target_core_fabric_ops *tfo =
 			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
-	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	char i_buf[PR_REG_ISID_ID_LEN];
 
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
@@ -1227,20 +1228,7 @@ static void __core_scsi3_free_registration(
 	 * so call core_scsi3_put_pr_reg() to decrement our reference.
 	 */
 	if (dec_holders)
-		core_scsi3_put_pr_reg(pr_reg);
-	/*
-	 * Wait until all reference from any other I_T nexuses for this
-	 * *pr_reg have been released.  Because list_del() is called above,
-	 * the last core_scsi3_put_pr_reg(pr_reg) will release this reference
-	 * count back to zero, and we release *pr_reg.
-	 */
-	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
-		spin_unlock(&pr_tmpl->registration_lock);
-		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
-				tfo->get_fabric_name());
-		cpu_relax();
-		spin_lock(&pr_tmpl->registration_lock);
-	}
+		put_pr_reg(pr_reg);
 
 	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
 		" Node: %s%s\n", tfo->get_fabric_name(),
@@ -1254,17 +1242,14 @@ static void __core_scsi3_free_registration(
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
-	if (!preempt_and_abort_list) {
-		pr_reg->pr_reg_deve = NULL;
-		pr_reg->pr_reg_nacl = NULL;
-		kmem_cache_free(t10_pr_reg_cache, pr_reg);
-		return;
-	}
 	/*
 	 * For PREEMPT_AND_ABORT, the list of *pr_reg in preempt_and_abort_list
 	 * are released once the ABORT_TASK_SET has completed..
 	 */
-	list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
+	if (preempt_and_abort_list)
+		list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
+	else
+		put_pr_reg(pr_reg);
 }
 
 void core_scsi3_free_pr_reg_from_nacl(
@@ -1653,7 +1638,7 @@ core_scsi3_decode_spec_i_port(
 		pr_reg_e = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 					iport_ptr);
 		if (pr_reg_e) {
-			core_scsi3_put_pr_reg(pr_reg_e);
+			put_pr_reg(pr_reg_e);
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -2181,7 +2166,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	ret = core_scsi3_update_and_write_aptpl(dev, aptpl);
 
 out:
-	core_scsi3_put_pr_reg(pr_reg);
+	put_pr_reg(pr_reg);
 	return ret;
 }
 
@@ -2359,7 +2344,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 
 	ret = 0;
 out_put_pr_reg:
-	core_scsi3_put_pr_reg(pr_reg);
+	put_pr_reg(pr_reg);
 	return ret;
 }
 
@@ -2573,7 +2558,7 @@ write_aptpl:
 		core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
 
 out_put_pr_reg:
-	core_scsi3_put_pr_reg(pr_reg);
+	put_pr_reg(pr_reg);
 	return ret;
 }
 
@@ -2613,7 +2598,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 			" res_key: 0x%016Lx does not match"
 			" existing SA REGISTER res_key:"
 			" 0x%016Lx\n", res_key, pr_reg_n->pr_res_key);
-		core_scsi3_put_pr_reg(pr_reg_n);
+		put_pr_reg(pr_reg_n);
 		return TCM_RESERVATION_CONFLICT;
 	}
 	/*
@@ -2757,12 +2742,12 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		return TCM_RESERVATION_CONFLICT;
 	}
 	if (pr_reg_n->pr_res_key != res_key) {
-		core_scsi3_put_pr_reg(pr_reg_n);
+		put_pr_reg(pr_reg_n);
 		return TCM_RESERVATION_CONFLICT;
 	}
 	if (scope != PR_SCOPE_LU_SCOPE) {
 		pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
-		core_scsi3_put_pr_reg(pr_reg_n);
+		put_pr_reg(pr_reg_n);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
@@ -2775,7 +2760,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 
 	if (!all_reg && !sa_res_key) {
 		spin_unlock(&dev->dev_reservation_lock);
-		core_scsi3_put_pr_reg(pr_reg_n);
+		put_pr_reg(pr_reg_n);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 	/*
@@ -2869,7 +2854,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		 */
 		if (!released_regs) {
 			spin_unlock(&dev->dev_reservation_lock);
-			core_scsi3_put_pr_reg(pr_reg_n);
+			put_pr_reg(pr_reg_n);
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
@@ -2891,7 +2876,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		if (pr_tmpl->pr_aptpl_active)
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
 
-		core_scsi3_put_pr_reg(pr_reg_n);
+		put_pr_reg(pr_reg_n);
 		core_scsi3_pr_generation(cmd->se_dev);
 		return 0;
 	}
@@ -3020,7 +3005,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	if (pr_tmpl->pr_aptpl_active)
 		core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
 
-	core_scsi3_put_pr_reg(pr_reg_n);
+	put_pr_reg(pr_reg_n);
 	core_scsi3_pr_generation(cmd->se_dev);
 	return 0;
 }
@@ -3442,13 +3427,13 @@ after_iport_check:
 		__core_scsi3_free_registration(dev, pr_reg, NULL, 1);
 		spin_unlock(&pr_tmpl->registration_lock);
 	} else
-		core_scsi3_put_pr_reg(pr_reg);
+		put_pr_reg(pr_reg);
 
 	core_scsi3_update_and_write_aptpl(cmd->se_dev, aptpl);
 
 	transport_kunmap_data_sg(cmd);
 
-	core_scsi3_put_pr_reg(dest_pr_reg);
+	put_pr_reg(dest_pr_reg);
 	return 0;
 out:
 	if (buf)
@@ -3460,7 +3445,7 @@ out:
 	core_scsi3_tpg_undepend_item(dest_se_tpg);
 
 out_put_pr_reg:
-	core_scsi3_put_pr_reg(pr_reg);
+	put_pr_reg(pr_reg);
 	return ret;
 }
 
@@ -3862,8 +3847,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		se_tpg = pr_reg->pr_reg_nacl->se_tpg;
 		add_desc_len = 0;
 
-		atomic_inc(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_inc();
+		get_pr_reg(pr_reg);
 		spin_unlock(&pr_tmpl->registration_lock);
 		/*
 		 * Determine expected length of $FABRIC_MOD specific
@@ -3876,8 +3860,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
 				" out of buffer: %d\n", cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
-			atomic_dec(&pr_reg->pr_res_holders);
-			smp_mb__after_atomic_dec();
+			put_pr_reg(pr_reg);
 			break;
 		}
 		/*
@@ -3938,8 +3921,8 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 				se_nacl, pr_reg, &format_code, &buf[off+4]);
 
 		spin_lock(&pr_tmpl->registration_lock);
-		atomic_dec(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_dec();
+		put_pr_reg(pr_reg);
+
 		/*
 		 * Set the ADDITIONAL DESCRIPTOR LENGTH
 		 */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6bf1da9..513429a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -363,7 +363,7 @@ struct t10_pr_registration {
 	u32 pr_res_generation;
 	u64 pr_reg_bin_isid;
 	u64 pr_res_key;
-	atomic_t pr_res_holders;
+	struct kref refcount;
 	struct se_node_acl *pr_reg_nacl;
 	struct se_dev_entry *pr_reg_deve;
 	struct se_lun *pr_reg_tg_pt_lun;
-- 
1.7.1

