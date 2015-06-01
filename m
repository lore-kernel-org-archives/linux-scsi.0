From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 02/10] target/pr: Use atomic bitop for se_dev_entry->deve_flags reservation check
Date: Mon,  1 Jun 2015 08:07:37 +0000
Message-ID: <1433146066-19798-3-git-send-email-nab@daterainc.com>
References: <1433146066-19798-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32847 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbFAIKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2015 04:10:53 -0400
Received: by oiww2 with SMTP id w2so95684224oiw.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jun 2015 01:10:53 -0700 (PDT)
In-Reply-To: <1433146066-19798-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the core_scsi3_pr_seq_non_holder() check for non
reservation holding registrations to use an atomic bitop in ->deve_flags
to determine if a registration is currently active.

It also includes associated a set_bit() in __core_scsi3_add_registration()
and clear_bit() in __core_scsi3_free_registration(), if se_dev_entry still
exists, and has not already been released via se_dev_entry shutdown path
in core_disable_device_list_for_node().

Also, clear_bit in core_disable_device_list_for_node as well to ensure
the read-critical path in core_scsi3_pr_seq_non_holder() picks up the
new state, preceeding the final kfree_rcu() call.

Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |  1 +
 drivers/target/target_core_pr.c     | 58 +++++++++++++++++++++++++------------
 include/target/target_core_base.h   |  3 +-
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e44e6bd..97792cc 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -413,6 +413,7 @@ void core_disable_device_list_for_node(
 	core_scsi3_ua_release_all(orig);
 
 	hlist_del_rcu(&orig->link);
+	clear_bit(DEF_PR_REG_ACTIVE, &orig->deve_flags);
 	rcu_assign_pointer(orig->se_lun, NULL);
 	rcu_assign_pointer(orig->se_lun_acl, NULL);
 	orig->lun_flags = 0;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 909573a..66e686b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -327,9 +327,13 @@ static int core_scsi3_pr_seq_non_holder(
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
+	bool registered = false;
 
 	rcu_read_lock();
 	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (se_deve)
+		registered = test_bit(DEF_PR_REG_ACTIVE, &se_deve->deve_flags);
+	rcu_read_unlock();
 	/*
 	 * Determine if the registration should be ignored due to
 	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
@@ -346,7 +350,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for the persistent reservation
 		 * holder.
 		 */
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
@@ -356,7 +360,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for registered I_T Nexuses.
 		 */
 		reg_only = 1;
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
@@ -366,14 +370,12 @@ static int core_scsi3_pr_seq_non_holder(
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
@@ -1009,10 +1011,6 @@ static void __core_scsi3_dump_registration(
 		pr_reg->pr_reg_aptpl);
 }
 
-/*
- * this function can be called with struct se_device->dev_reservation_lock
- * when register_move = 1
- */
 static void __core_scsi3_add_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
@@ -1023,6 +1021,7 @@ static void __core_scsi3_add_registration(
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
+	struct se_dev_entry *deve;
 
 	/*
 	 * Increment PRgeneration counter for struct se_device upon a successful
@@ -1039,10 +1038,16 @@ static void __core_scsi3_add_registration(
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
-	pr_reg->pr_reg_deve->def_pr_registered = 1;
 
 	__core_scsi3_dump_registration(tfo, dev, nacl, pr_reg, register_type);
 	spin_unlock(&pr_tmpl->registration_lock);
+
+	rcu_read_lock();
+	deve = pr_reg->pr_reg_deve;
+	if (deve)
+		set_bit(DEF_PR_REG_ACTIVE, &deve->deve_flags);
+	rcu_read_unlock();
+
 	/*
 	 * Skip extra processing for ALL_TG_PT=0 or REGISTER_AND_MOVE.
 	 */
@@ -1054,6 +1059,8 @@ static void __core_scsi3_add_registration(
 	 */
 	list_for_each_entry_safe(pr_reg_tmp, pr_reg_tmp_safe,
 			&pr_reg->pr_reg_atp_list, pr_reg_atp_mem_list) {
+		struct se_node_acl *nacl_tmp = pr_reg_tmp->pr_reg_nacl;
+
 		list_del(&pr_reg_tmp->pr_reg_atp_mem_list);
 
 		pr_reg_tmp->pr_res_generation = core_scsi3_pr_generation(dev);
@@ -1061,12 +1068,17 @@ static void __core_scsi3_add_registration(
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
+		rcu_read_lock();
+		deve = pr_reg_tmp->pr_reg_deve;
+		if (deve)
+			set_bit(DEF_PR_REG_ACTIVE, &deve->deve_flags);
+		rcu_read_unlock();
+
 		/*
 		 * Drop configfs group dependency reference from
 		 * __core_scsi3_alloc_registration()
@@ -1242,13 +1254,13 @@ static void __core_scsi3_free_registration(
 	const struct target_core_fabric_ops *tfo =
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
@@ -1257,6 +1269,8 @@ static void __core_scsi3_free_registration(
 	 */
 	if (dec_holders)
 		core_scsi3_put_pr_reg(pr_reg);
+
+	spin_unlock(&pr_tmpl->registration_lock);
 	/*
 	 * Wait until all reference from any other I_T nexuses for this
 	 * *pr_reg have been released.  Because list_del() is called above,
@@ -1264,13 +1278,18 @@ static void __core_scsi3_free_registration(
 	 * count back to zero, and we release *pr_reg.
 	 */
 	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
-		spin_unlock(&pr_tmpl->registration_lock);
 		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
 				tfo->get_fabric_name());
 		cpu_relax();
-		spin_lock(&pr_tmpl->registration_lock);
 	}
 
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, pr_reg->pr_res_mapped_lun);
+	if (deve)
+		clear_bit(DEF_PR_REG_ACTIVE, &deve->deve_flags);
+	rcu_read_unlock();
+
+	spin_lock(&pr_tmpl->registration_lock);
 	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
 		" Node: %s%s\n", tfo->get_fabric_name(),
 		pr_reg->pr_reg_nacl->initiatorname,
@@ -3421,13 +3440,14 @@ after_iport_check:
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
index b518523..508528a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -638,7 +638,6 @@ struct se_lun_acl {
 };
 
 struct se_dev_entry {
-	bool			def_pr_registered;
 	/* See transport_lunflags_table */
 	u32			lun_flags;
 	u32			mapped_lun;
@@ -655,6 +654,8 @@ struct se_dev_entry {
 	struct se_lun_acl __rcu	*se_lun_acl;
 	spinlock_t		ua_lock;
 	struct se_lun __rcu	*se_lun;
+#define DEF_PR_REG_ACTIVE		1
+	unsigned long		deve_flags;
 	struct list_head	alua_port_list;
 	struct list_head	ua_list;
 	struct hlist_node	link;
-- 
1.9.1

