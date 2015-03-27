From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 09/22] target/pr: Convert registration check to RCU pointer
Date: Fri, 27 Mar 2015 08:04:59 +0000
Message-ID: <1427443512-8925-10-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts core_scsi3_pr_seq_non_holder() check for non
reservation holding registrations to use se_deve->pr_reg as an RCU
protected pointer.

It also includes associated rcu_assign_pointer() + synchronize_rcu()
in __core_scsi3_add_registration() and __core_scsi3_free_registration()
for the RCU updater path.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |  1 +
 drivers/target/target_core_pr.c     | 69 +++++++++++++++++++++++++++----------
 include/target/target_core_base.h   |  6 ++--
 3 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 473543e..670b1b5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -432,6 +432,7 @@ int core_disable_device_list_for_node(
 	 */
 	spin_lock_irq(&nacl->lun_entry_lock);
 	core_scsi3_ua_release_all(deve);
+	rcu_assign_pointer(deve->pr_reg, NULL);
 	rcu_assign_pointer(deve->se_lun, NULL);
 	rcu_assign_pointer(deve->se_lun_acl, NULL);
 	deve->lun_flags = 0;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 123e449..e23fe68 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -312,9 +312,12 @@ static int core_scsi3_pr_seq_non_holder(
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
+	bool registered;
 
 	rcu_read_lock();
 	se_deve = rcu_dereference(nacl->lun_entry_hlist[cmd->orig_fe_lun]);
+	registered = (se_deve->pr_reg != NULL);
+	rcu_read_unlock();
 	/*
 	 * Determine if the registration should be ignored due to
 	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
@@ -331,7 +334,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for the persistent reservation
 		 * holder.
 		 */
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
@@ -341,7 +344,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for registered I_T Nexuses.
 		 */
 		reg_only = 1;
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
@@ -351,14 +354,12 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Each registered I_T Nexus is a reservation holder.
 		 */
 		all_reg = 1;
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	default:
-		rcu_read_unlock();
 		return -EINVAL;
 	}
-	rcu_read_unlock();
 	/*
 	 * Referenced from spc4r17 table 45 for *NON* PR holder access
 	 */
@@ -996,10 +997,6 @@ static void __core_scsi3_dump_registration(
 		pr_reg->pr_reg_aptpl);
 }
 
-/*
- * this function can be called with struct se_device->dev_reservation_lock
- * when register_move = 1
- */
 static void __core_scsi3_add_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
@@ -1010,6 +1007,7 @@ static void __core_scsi3_add_registration(
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
+	struct se_dev_entry *deve;
 
 	/*
 	 * Increment PRgeneration counter for struct se_device upon a successful
@@ -1026,10 +1024,20 @@ static void __core_scsi3_add_registration(
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
-	pr_reg->pr_reg_deve->def_pr_registered = 1;
 
 	__core_scsi3_dump_registration(tfo, dev, nacl, pr_reg, register_type);
 	spin_unlock(&pr_tmpl->registration_lock);
+
+	spin_lock(&nacl->lun_entry_lock);
+	deve = nacl->lun_entry_hlist[pr_reg->pr_res_mapped_lun];
+	rcu_assign_pointer(deve->pr_reg, pr_reg);
+	spin_unlock(&nacl->lun_entry_lock);
+	/*
+	 * Wait for read path critical RCU in core_scsi3_pr_seq_non_holder()
+	 * conditional checks for deve->pr_reg pointer access complete.
+	 */
+	synchronize_rcu();
+
 	/*
 	 * Skip extra processing for ALL_TG_PT=0 or REGISTER_AND_MOVE.
 	 */
@@ -1041,6 +1049,8 @@ static void __core_scsi3_add_registration(
 	 */
 	list_for_each_entry_safe(pr_reg_tmp, pr_reg_tmp_safe,
 			&pr_reg->pr_reg_atp_list, pr_reg_atp_mem_list) {
+		struct se_node_acl *nacl_tmp = pr_reg_tmp->pr_reg_nacl;
+
 		list_del(&pr_reg_tmp->pr_reg_atp_mem_list);
 
 		pr_reg_tmp->pr_res_generation = core_scsi3_pr_generation(dev);
@@ -1048,12 +1058,21 @@ static void __core_scsi3_add_registration(
 		spin_lock(&pr_tmpl->registration_lock);
 		list_add_tail(&pr_reg_tmp->pr_reg_list,
 			      &pr_tmpl->registration_list);
-		pr_reg_tmp->pr_reg_deve->def_pr_registered = 1;
 
-		__core_scsi3_dump_registration(tfo, dev,
-				pr_reg_tmp->pr_reg_nacl, pr_reg_tmp,
-				register_type);
+		__core_scsi3_dump_registration(tfo, dev, nacl_tmp, pr_reg_tmp,
+					       register_type);
 		spin_unlock(&pr_tmpl->registration_lock);
+
+		spin_lock(&nacl->lun_entry_lock);
+		deve = nacl_tmp->lun_entry_hlist[pr_reg_tmp->pr_res_mapped_lun];
+		rcu_assign_pointer(deve->pr_reg, pr_reg_tmp);
+		spin_unlock(&nacl->lun_entry_lock);
+		/*
+		 * Wait for read path critical RCU in core_scsi3_pr_seq_non_holder()
+		 * conditional checks for deve->pr_reg pointer access complete.
+		 */
+		synchronize_rcu();
+
 		/*
 		 * Drop configfs group dependency reference from
 		 * __core_scsi3_alloc_registration()
@@ -1227,13 +1246,13 @@ static void __core_scsi3_free_registration(
 	struct target_core_fabric_ops *tfo =
 			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
+	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
+	struct se_dev_entry *deve;
 	char i_buf[PR_REG_ISID_ID_LEN];
 
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	pr_reg->pr_reg_deve->def_pr_registered = 0;
-	pr_reg->pr_reg_deve->pr_res_key = 0;
 	if (!list_empty(&pr_reg->pr_reg_list))
 		list_del(&pr_reg->pr_reg_list);
 	/*
@@ -1242,6 +1261,8 @@ static void __core_scsi3_free_registration(
 	 */
 	if (dec_holders)
 		core_scsi3_put_pr_reg(pr_reg);
+
+	spin_unlock(&pr_tmpl->registration_lock);
 	/*
 	 * Wait until all reference from any other I_T nexuses for this
 	 * *pr_reg have been released.  Because list_del() is called above,
@@ -1249,13 +1270,22 @@ static void __core_scsi3_free_registration(
 	 * count back to zero, and we release *pr_reg.
 	 */
 	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
-		spin_unlock(&pr_tmpl->registration_lock);
 		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
 				tfo->get_fabric_name());
 		cpu_relax();
-		spin_lock(&pr_tmpl->registration_lock);
 	}
 
+	spin_lock(&nacl->lun_entry_lock);
+	deve = nacl->lun_entry_hlist[pr_reg->pr_res_mapped_lun];
+	rcu_assign_pointer(deve->pr_reg, NULL);
+	spin_unlock(&nacl->lun_entry_lock);
+	/*
+	 * Wait for read path critical RCU in core_scsi3_pr_seq_non_holder()
+	 * conditional checks for deve->pr_reg pointer access complete.
+	 */
+	synchronize_rcu();
+
+	spin_lock(&pr_tmpl->registration_lock);
 	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
 		" Node: %s%s\n", tfo->get_fabric_name(),
 		pr_reg->pr_reg_nacl->initiatorname,
@@ -3448,13 +3478,14 @@ after_iport_check:
 	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 					iport_ptr);
 	if (!dest_pr_reg) {
+		spin_unlock(&dev->dev_reservation_lock);
 		if (core_scsi3_alloc_registration(cmd->se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, 0, aptpl, 2, 1)) {
-			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_INVALID_PARAMETER_LIST;
 			goto out;
 		}
+		spin_lock(&dev->dev_reservation_lock);
 		dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 						iport_ptr);
 		new_reg = 1;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d182f..2566ce5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -652,7 +652,6 @@ struct se_lun_acl {
 };
 
 struct se_dev_entry {
-	bool			def_pr_registered;
 	/* See transport_lunflags_table */
 	u32			lun_flags;
 	u32			mapped_lun;
@@ -666,9 +665,10 @@ struct se_dev_entry {
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	struct percpu_ref	pr_ref;
 	struct completion	pr_comp;
-	struct se_lun_acl	*se_lun_acl;
+	struct se_lun_acl __rcu	*se_lun_acl;
 	spinlock_t		ua_lock;
-	struct se_lun		*se_lun;
+	struct se_lun __rcu	*se_lun;
+	struct t10_pr_registration __rcu *pr_reg;
 	struct list_head	alua_port_list;
 	struct list_head	ua_list;
 };
-- 
1.9.1
