From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] target: use 'se_dev_entry' when allocating UAs
Date: Thu, 11 Jun 2015 10:01:26 +0200
Message-ID: <1434009689-112909-4-git-send-email-hare@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbbFKIBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 04:01:34 -0400
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

We need to use 'se_dev_entry' as argument when allocating
UAs, otherwise we'll never see any UAs for an implicit
ALUA state transition triggered from userspace.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c      | 27 ++++++++++++++++++---------
 drivers/target/target_core_pr.c        | 31 +++++++++++++++++++++++++------
 drivers/target/target_core_transport.c | 18 ++++++++++++------
 drivers/target/target_core_ua.c        | 23 +++--------------------
 drivers/target/target_core_ua.h        |  2 +-
 5 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 228a3c7..aa2e4b1 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -972,23 +972,32 @@ static void core_alua_queue_state_change_ua(struct t10_alua_tg_pt_gp *tg_pt_gp)
 		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link) {
 			lacl = rcu_dereference_check(se_deve->se_lun_acl,
 					lockdep_is_held(&lun->lun_deve_lock));
+
 			/*
-			 * se_deve->se_lun_acl pointer may be NULL for a
-			 * entry created without explicit Node+MappedLUN ACLs
+			 * spc4r37 p.242:
+			 * After an explicit target port asymmetric access
+			 * state change, a device server shall establish a
+			 * unit attention condition with the additional sense
+			 * code set to ASYMMETRIC ACCESS STATE CHANGED for
+			 * the initiator port associated with every I_T nexus
+			 * other than the I_T nexus on which the SET TARGET
+			 * PORT GROUPS command was received.
 			 */
-			if (!lacl)
-				continue;
-
 			if ((tg_pt_gp->tg_pt_gp_alua_access_status ==
 			     ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
-			   (tg_pt_gp->tg_pt_gp_alua_nacl != NULL) &&
-			    (tg_pt_gp->tg_pt_gp_alua_nacl == lacl->se_lun_nacl) &&
 			   (tg_pt_gp->tg_pt_gp_alua_lun != NULL) &&
 			    (tg_pt_gp->tg_pt_gp_alua_lun == lun))
 				continue;
 
-			core_scsi3_ua_allocate(lacl->se_lun_nacl,
-				se_deve->mapped_lun, 0x2A,
+			/*
+			 * se_deve->se_lun_acl pointer may be NULL for a
+			 * entry created without explicit Node+MappedLUN ACLs
+			 */
+			if (lacl && (tg_pt_gp->tg_pt_gp_alua_nacl != NULL) &&
+			    (tg_pt_gp->tg_pt_gp_alua_nacl == lacl->se_lun_nacl))
+				continue;
+
+			core_scsi3_ua_allocate(se_deve, 0x2A,
 				ASCQ_2AH_ASYMMETRIC_ACCESS_STATE_CHANGED);
 		}
 		spin_unlock_bh(&lun->lun_deve_lock);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 436e30b..bb28a97 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -125,6 +125,25 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(struct se_device *,
 					struct se_node_acl *, struct se_session *);
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
 
+static void core_scsi3_pr_ua_allocate(struct se_node_acl *nacl,
+				      u32 unpacked_lun, u8 asc, u8 ascq)
+{
+	struct se_dev_entry *deve;
+
+	if (!nacl)
+		return;
+
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return;
+	}
+
+	core_scsi3_ua_allocate(deve, asc, ascq);
+	rcu_read_unlock();
+}
+
 static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 {
 	struct se_session *se_sess = cmd->se_sess;
@@ -2197,7 +2216,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					&pr_tmpl->registration_list,
 					pr_reg_list) {
 
-				core_scsi3_ua_allocate(
+				core_scsi3_pr_ua_allocate(
 					pr_reg_p->pr_reg_nacl,
 					pr_reg_p->pr_res_mapped_lun,
 					0x2A,
@@ -2624,7 +2643,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 		if (pr_reg_p == pr_reg)
 			continue;
 
-		core_scsi3_ua_allocate(pr_reg_p->pr_reg_nacl,
+		core_scsi3_pr_ua_allocate(pr_reg_p->pr_reg_nacl,
 				pr_reg_p->pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_RELEASED);
 	}
@@ -2709,7 +2728,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 		 *    additional sense code set to RESERVATIONS PREEMPTED.
 		 */
 		if (!calling_it_nexus)
-			core_scsi3_ua_allocate(pr_reg_nacl, pr_res_mapped_lun,
+			core_scsi3_pr_ua_allocate(pr_reg_nacl, pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
@@ -2918,7 +2937,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 						NULL, 0);
 			}
 			if (!calling_it_nexus)
-				core_scsi3_ua_allocate(pr_reg_nacl,
+				core_scsi3_pr_ua_allocate(pr_reg_nacl,
 					pr_res_mapped_lun, 0x2A,
 					ASCQ_2AH_REGISTRATIONS_PREEMPTED);
 		}
@@ -3024,7 +3043,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		 *    persistent reservation and/or registration, with the
 		 *    additional sense code set to REGISTRATIONS PREEMPTED;
 		 */
-		core_scsi3_ua_allocate(pr_reg_nacl, pr_res_mapped_lun, 0x2A,
+		core_scsi3_pr_ua_allocate(pr_reg_nacl, pr_res_mapped_lun, 0x2A,
 				ASCQ_2AH_REGISTRATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
@@ -3057,7 +3076,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 			if (calling_it_nexus)
 				continue;
 
-			core_scsi3_ua_allocate(pr_reg->pr_reg_nacl,
+			core_scsi3_pr_ua_allocate(pr_reg->pr_reg_nacl,
 					pr_reg->pr_res_mapped_lun, 0x2A,
 					ASCQ_2AH_RESERVATIONS_RELEASED);
 		}
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3da2386..a0e0d3a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1700,13 +1700,19 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		 * See spc4r17, section 7.4.6 Control Mode Page, Table 349
 		 */
 		if (cmd->se_sess &&
-		    cmd->se_dev->dev_attrib.emulate_ua_intlck_ctrl == 2)
-			core_scsi3_ua_allocate(cmd->se_sess->se_node_acl,
-				cmd->orig_fe_lun, 0x2C,
-				ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
-
+		    cmd->se_dev->dev_attrib.emulate_ua_intlck_ctrl == 2) {
+			struct se_dev_entry *deve;
+
+			rcu_read_lock();
+			deve = target_nacl_find_deve(cmd->se_sess->se_node_acl,
+						     cmd->orig_fe_lun);
+			if (deve)
+				core_scsi3_ua_allocate(deve, 0x2C,
+					ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
+			rcu_read_unlock();
+		}
 		trace_target_cmd_complete(cmd);
-		ret = cmd->se_tfo-> queue_status(cmd);
+		ret = cmd->se_tfo->queue_status(cmd);
 		if (ret == -EAGAIN || ret == -ENOMEM)
 			goto queue_full;
 		goto check_stop;
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index e506224..e97a708 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -87,18 +87,11 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 }
 
 int core_scsi3_ua_allocate(
-	struct se_node_acl *nacl,
-	u64 unpacked_lun,
+	struct se_dev_entry *deve,
 	u8 asc,
 	u8 ascq)
 {
-	struct se_dev_entry *deve;
 	struct se_ua *ua, *ua_p, *ua_tmp;
-	/*
-	 * PASSTHROUGH OPS
-	 */
-	if (!nacl)
-		return -EINVAL;
 
 	ua = kmem_cache_zalloc(se_ua_cache, GFP_ATOMIC);
 	if (!ua) {
@@ -110,12 +103,6 @@ int core_scsi3_ua_allocate(
 	ua->ua_asc = asc;
 	ua->ua_ascq = ascq;
 
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, unpacked_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
 	spin_lock(&deve->ua_lock);
 	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_list) {
 		/*
@@ -123,7 +110,6 @@ int core_scsi3_ua_allocate(
 		 */
 		if ((ua_p->ua_asc == asc) && (ua_p->ua_ascq == ascq)) {
 			spin_unlock(&deve->ua_lock);
-			rcu_read_unlock();
 			kmem_cache_free(se_ua_cache, ua);
 			return 0;
 		}
@@ -170,19 +156,16 @@ int core_scsi3_ua_allocate(
 		spin_unlock(&deve->ua_lock);
 
 		atomic_inc_mb(&deve->ua_count);
-		rcu_read_unlock();
 		return 0;
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
 
-	pr_debug("[%s]: Allocated UNIT ATTENTION, mapped LUN: %llu, ASC:"
-		" 0x%02x, ASCQ: 0x%02x\n",
-		nacl->se_tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
+	pr_debug("Allocated UNIT ATTENTION, mapped LUN: %llu, ASC:"
+		" 0x%02x, ASCQ: 0x%02x\n", deve->mapped_lun,
 		asc, ascq);
 
 	atomic_inc_mb(&deve->ua_count);
-	rcu_read_unlock();
 	return 0;
 }
 
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 6e592b1..a9c4693 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -28,7 +28,7 @@
 extern struct kmem_cache *se_ua_cache;
 
 extern sense_reason_t target_scsi3_ua_check(struct se_cmd *);
-extern int core_scsi3_ua_allocate(struct se_node_acl *, u64, u8, u8);
+extern int core_scsi3_ua_allocate(struct se_dev_entry *, u8, u8);
 extern void core_scsi3_ua_release_all(struct se_dev_entry *);
 extern void core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *);
 extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *,
-- 
1.8.5.2

