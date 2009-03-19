From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add implict
	PR RELEASE+UNREGISTER for LUN acl removal
Date: Thu, 19 Mar 2009 01:56:29 -0700
Message-ID: <1237452989.4138.38.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759565AbZCSI4s@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

>From 368bf27a4c577cfdadb743ea987c971c6f70ee5d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Mar 2009 00:37:48 -0700
Subject: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add implict PR RELEASE+UNREGISTER for LUN acl removal

This patch adds support for removing existing reservations and/or registrations from a
given se_lun_t mapped se_device_t for a given LUN ACL.   This patch fixes the existing
logic where reservations/registrations where being released at se_device_t shutdown time,
instead of each time a LUN ACL was explict removed through configfs. The function that
handles this logic is called, core_scsi3_free_pr_reg_from_nacl(), and is used in
target_core_device.c code.

This patch also adds reference counting to t10_pr_registration_t->pr_res_holders
using core_scsi3_locate_pr_reg() and core_scsi3_put_pr_reg().  It also updates
core_scsi3_emulate_pro_register(), core_scsi3_pro_reserve(), and
core_scsi3_emulate_pro_release() to use core_scsi3_put_pr_reg().
__core_scsi3_free_registration() is the last caller to wait on returning to
zero, and then releases t10_pr_registration_t.

Finally, this patch adds __core_scsi3_free_registration() and
__core_scsi3_complete_pro_release() functions from existing code that
was being duplicated in more than one location.  These functions are
held by their respective spinlocks when being called, and their
orginally callers have been updated to use the new __* prefixed functions.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h   |    1 +
 drivers/lio-core/target_core_device.c |   14 ++-
 drivers/lio-core/target_core_pr.c     |  225 ++++++++++++++++++++++++---------
 drivers/lio-core/target_core_pr.h     |    2 +
 4 files changed, 178 insertions(+), 64 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 55c38c2..f16e002 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -286,6 +286,7 @@ typedef struct t10_pr_registration_s {
 	int pr_res_scope;
 	u32 pr_res_generation;
 	u64 pr_res_key;
+	atomic_t pr_res_holders;
 	struct se_node_acl_s *pr_reg_nacl;
 	struct se_dev_entry_s *pr_reg_deve;
 	struct se_lun_s *pr_reg_tg_pt_lun;
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 84bb3e9..293b557 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -482,13 +482,19 @@ void core_update_device_list_for_node(
 		deve->creation_time = get_jiffies_64();
 		deve->attach_count++;
 #endif /* SNMP_SUPPORT */
-	} else {
-		deve->se_lun = NULL;
-		deve->lun_flags = 0;
-		deve->creation_time = 0;
+		spin_unlock_bh(&nacl->device_list_lock);
+
+		return;
 	}
+	/*
+	 * Disable se_dev_entry_t LUN ACL mapping
+	 */
+	deve->se_lun = NULL;
+	deve->lun_flags = 0;
+	deve->creation_time = 0;
 	spin_unlock_bh(&nacl->device_list_lock);
 
+	core_scsi3_free_pr_reg_from_nacl(lun->se_dev, nacl);
 	return;
 }
 
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 82dde64..cce50dc 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -44,6 +44,9 @@
 
 #undef TARGET_CORE_PR_C
 
+static void __core_scsi3_complete_pro_release(se_device_t *, se_node_acl_t *,
+			t10_pr_registration_t *g, int);
+
 int core_scsi2_reservation_seq_non_holder(
 	se_cmd_t *cmd,
 	unsigned char *cdb,
@@ -333,9 +336,11 @@ static int core_scsi3_pr_seq_non_holder(
 	 * statement.
 	 */
 	if (!(ret) && !(other_cdb)) {
-		printk("Allowing explict CDB: 0x%02x for %s reservation"
-			" holder\n", cdb[0],
+#if 0
+		printk(KERN_INFO "Allowing explict CDB: 0x%02x for %s"
+			" reservation holder\n", cdb[0],
 			core_scsi3_pr_dump_type(pr_reg_type));
+#endif
 		return ret;
 	}
 	/*
@@ -448,7 +453,7 @@ static int core_scsi3_legacy_release(se_cmd_t *cmd)
 	return core_scsi2_reservation_release(cmd);
 }
 
-static t10_pr_registration_t *core_scsi3_alloc_registration(
+static int core_scsi3_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
@@ -463,10 +468,11 @@ static t10_pr_registration_t *core_scsi3_alloc_registration(
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "Unable to allocate t10_pr_registration_t\n");
-		return NULL;
+		return -1;
 	}
 
 	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
+	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
 	pr_reg->pr_res_key = sa_res_key;
@@ -481,9 +487,8 @@ static t10_pr_registration_t *core_scsi3_alloc_registration(
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
-	spin_unlock(&pr_tmpl->registration_lock);
-
 	deve->deve_flags |= DEF_PR_REGISTERED;
+
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
 		" Node: %s\n", tfo->get_fabric_name(), (ignore_key) ?
 		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname);
@@ -494,8 +499,9 @@ static t10_pr_registration_t *core_scsi3_alloc_registration(
 	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
+	spin_unlock(&pr_tmpl->registration_lock);
 
-	return pr_reg;
+	return 0;
 }
 
 static t10_pr_registration_t *core_scsi3_locate_pr_reg(
@@ -508,8 +514,9 @@ static t10_pr_registration_t *core_scsi3_locate_pr_reg(
 	spin_lock(&pr_tmpl->registration_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
-		if (!(strcmp(pr_reg->pr_reg_nacl->initiatorname,
-				nacl->initiatorname))) {
+		if (pr_reg->pr_reg_nacl == nacl) {
+			atomic_inc(&pr_reg->pr_res_holders);
+			smp_mb__after_atomic_inc();
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
 		}
@@ -519,18 +526,22 @@ static t10_pr_registration_t *core_scsi3_locate_pr_reg(
 	return NULL;
 }
 
-static void core_scsi3_free_registration(
+static void core_scsi3_put_pr_reg(t10_pr_registration_t *pr_reg)
+{
+	atomic_dec(&pr_reg->pr_res_holders);
+	smp_mb__after_atomic_dec();
+}
+
+static void core_scsi3_check_implict_release(
 	se_device_t *dev,
 	t10_pr_registration_t *pr_reg)
 {
 	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
-	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	t10_pr_registration_t *pr_res_holder;
-	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
-	if (pr_res_holder == pr_reg) {
+	if ((pr_res_holder != NULL) && (pr_res_holder == pr_reg)) {
 		/*
 		 * Perform an implict RELEASE if the registration that
 		 * is being released is holding the reservation.
@@ -544,27 +555,50 @@ static void core_scsi3_free_registration(
 		 *    service action with the SERVICE ACTION RESERVATION KEY
 		 *    field set to zero (see 5.7.11.3).
 		 */
-		dev->dev_pr_res_holder = NULL;
-
-		printk(KERN_INFO "SPC-3 PR [%s] Service Action: implict"
-			" RELEASE cleared reservation holder TYPE: %s"
-			" ALL_TG_PT: %d\n", tfo->get_fabric_name(),
-			core_scsi3_pr_dump_type(pr_reg->pr_res_type),
-			(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-		printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s\n",
-			tfo->get_fabric_name(), nacl->initiatorname);
-	
-		pr_reg->pr_res_holder = pr_reg->pr_res_type = 0;
-		pr_reg->pr_res_scope = 0;
+		__core_scsi3_complete_pro_release(dev, nacl, pr_reg, 0);
 #warning FIXME: Registrants only, UA + RESERVATIONS RELEASED
 #warning FIXME: All Registrants, only release reservation when last registration is freed.
 	}
 	spin_unlock(&dev->dev_reservation_lock);
+}
+
+/*
+ * Called with t10_reservation_template_t->registration_lock held.
+ */
+static void __core_scsi3_free_registration(
+	se_device_t *dev,
+	t10_pr_registration_t *pr_reg,
+	int dec_holders)
+{
+	struct target_core_fabric_ops *tfo =
+			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 
 	pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
+	list_del(&pr_reg->pr_reg_list);
+	/*
+	 * Caller accessing *pr_reg using core_scsi3_locate_pr_reg(),
+	 * so call core_scsi3_put_pr_reg() to decrement our reference.
+	 */
+	if (dec_holders)
+		core_scsi3_put_pr_reg(pr_reg);
+	/*
+	 * Wait until all reference from any other I_T nexuses for this
+	 * *pr_reg have been released.  Because list_del() is called above,
+	 * the last core_scsi3_put_pr_reg(pr_reg) will release this reference
+	 * count back to zero, and we release *pr_reg.
+	 */
+	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
+		spin_unlock(&pr_tmpl->registration_lock);
+		printk("SPC-3 PR [%s] waiting for pr_res_holders\n",
+				tfo->get_fabric_name());
+		msleep(10);
+		spin_lock(&pr_tmpl->registration_lock);
+	}
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
-		" Node: %s\n", tfo->get_fabric_name(), nacl->initiatorname);
+		" Node: %s\n", tfo->get_fabric_name(),
+		pr_reg->pr_reg_nacl->initiatorname);
 	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n", tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
@@ -573,11 +607,39 @@ static void core_scsi3_free_registration(
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
-	spin_lock(&pr_tmpl->registration_lock);
-	list_del(&pr_reg->pr_reg_list);
 	pr_reg->pr_reg_deve = NULL;
 	pr_reg->pr_reg_nacl = NULL;
 	kmem_cache_free(t10_pr_reg_cache, pr_reg);
+}
+
+void core_scsi3_free_pr_reg_from_nacl(
+	se_device_t *dev,
+	se_node_acl_t *nacl)
+{
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_res_holder;
+	/*
+	 * If the passed se_node_acl matches the reservation holder,
+	 * release the reservation.
+	 */
+	spin_lock(&dev->dev_reservation_lock);
+	pr_res_holder = dev->dev_pr_res_holder;
+	if ((pr_res_holder != NULL) &&
+	    (pr_res_holder->pr_reg_nacl == nacl))
+		__core_scsi3_complete_pro_release(dev, nacl, pr_res_holder, 0);
+	spin_unlock(&dev->dev_reservation_lock);
+	/*
+	 * Release any registration associated with the se_node_acl_t.
+	 */
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+
+		if (pr_reg->pr_reg_nacl != nacl)
+			continue;
+
+		__core_scsi3_free_registration(dev, pr_reg, 0);
+	}
 	spin_unlock(&pr_tmpl->registration_lock);
 }
 
@@ -585,17 +647,22 @@ void core_scsi3_free_all_registrations(
 	se_device_t *dev)
 {
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
-	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_res_holder;
+
+	spin_lock(&dev->dev_reservation_lock);
+	pr_res_holder = dev->dev_pr_res_holder;
+	if (pr_res_holder != NULL) {
+		se_node_acl_t *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
+				pr_res_holder, 0);
+	}
+	spin_unlock(&dev->dev_reservation_lock);
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
-		list_del(&pr_reg->pr_reg_list);
 
-		pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
-		pr_reg->pr_reg_deve = NULL;
-		pr_reg->pr_reg_nacl = NULL;
-		kmem_cache_free(t10_pr_reg_cache, pr_reg);
+		__core_scsi3_free_registration(dev, pr_reg, 0);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 }
@@ -610,10 +677,13 @@ static int core_scsi3_emulate_pro_register(
 	int ignore_key)
 {
 	se_session_t *se_sess = SE_SESS(cmd);
+	se_device_t *dev = SE_DEV(cmd);
 	se_dev_entry_t *se_deve;
 	se_lun_t *se_lun = SE_LUN(cmd);
 	se_portal_group_t *se_tpg;
 	t10_pr_registration_t *pr_reg;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	int ret = 0;
 
 	if (!(se_sess) || !(se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
@@ -648,10 +718,10 @@ static int core_scsi3_emulate_pro_register(
 			 * Port Endpoint that the PRO was received from on the
 			 * Logical Unit of the SCSI device server.
 			 */
-			pr_reg = core_scsi3_alloc_registration(SE_DEV(cmd),
+			ret = core_scsi3_alloc_registration(SE_DEV(cmd),
 					se_sess->se_node_acl, se_deve,
 					sa_res_key, all_tg_pt, ignore_key);
-			if (!(pr_reg)) {
+			if (ret != 0) {
 				printk(KERN_ERR "Unable to allocate"
 					" t10_pr_registration_t\n");
 				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -675,6 +745,7 @@ static int core_scsi3_emulate_pro_register(
 		if (!(pr_reg)) {
 			printk(KERN_ERR "SPC-3 PR: Unable to locate"
 				" PR_REGISTERED *pr_reg for REGISTER\n");
+			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 		if (!(ignore_key)) {
@@ -684,12 +755,14 @@ static int core_scsi3_emulate_pro_register(
 					" existing SA REGISTER res_key:"
 					" 0x%016Lx\n", res_key,
 					pr_reg->pr_res_key);
+				core_scsi3_put_pr_reg(pr_reg);
 				return PYX_TRANSPORT_RESERVATION_CONFLICT;
 			}
 		}
 		if (spec_i_pt) {
 			printk(KERN_ERR "SPC-3 PR UNREGISTER: SPEC_I_PT"
 				" set while sa_res_key=0\n");
+			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		}
 		/*
@@ -697,9 +770,12 @@ static int core_scsi3_emulate_pro_register(
 		 * Nexus sa_res_key=1 Change Reservation Key for registered I_T
 		 * Nexus.
 		 */
-		if (!(sa_res_key))
-			core_scsi3_free_registration(SE_DEV(cmd), pr_reg);
-		else {
+		if (!(sa_res_key)) {
+			core_scsi3_check_implict_release(SE_DEV(cmd), pr_reg);
+			spin_lock(&pr_tmpl->registration_lock);
+			__core_scsi3_free_registration(SE_DEV(cmd), pr_reg, 1);
+			spin_unlock(&pr_tmpl->registration_lock);
+		} else {
 			/*
 			 * Increment PRgeneration counter for se_device_t"
 			 * upon a successful REGISTER, see spc4r17 section 6.3.2
@@ -714,6 +790,8 @@ static int core_scsi3_emulate_pro_register(
 				(ignore_key) ? "_AND_IGNORE_EXISTING_KEY" : "",
 				pr_reg->pr_reg_nacl->initiatorname,
 				pr_reg->pr_res_key, pr_reg->pr_res_generation);
+
+			core_scsi3_put_pr_reg(pr_reg);
 		}
 	}
 
@@ -779,6 +857,7 @@ static int core_scsi3_pro_reserve(
 		printk(KERN_ERR "SPC-3 PR: Unable to handle RESERVE because"
 			" ALL_TG_PT=0 and RESERVE was not received on same"
 			" target port as REGISTER\n");
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
 	/*
@@ -794,6 +873,7 @@ static int core_scsi3_pro_reserve(
 		printk(KERN_ERR "SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
 			" does not match existing SA REGISTER res_key:"
 			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
 	/*
@@ -808,6 +888,7 @@ static int core_scsi3_pro_reserve(
 	 */
 	if (scope != PR_SCOPE_LU_SCOPE) {
 		printk(KERN_ERR "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
 	/*
@@ -839,6 +920,7 @@ static int core_scsi3_pro_reserve(
 				pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
+			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_RESERVATION_CONFLICT;
 		}
 		/*
@@ -861,6 +943,7 @@ static int core_scsi3_pro_reserve(
 				pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
+			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_RESERVATION_CONFLICT;
 		}
 		/*
@@ -874,6 +957,7 @@ static int core_scsi3_pro_reserve(
 		 * shall completethe command with GOOD status.
 		 */
 		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 	}
 	/*
@@ -894,6 +978,7 @@ static int core_scsi3_pro_reserve(
 			se_sess->se_node_acl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
 
+	core_scsi3_put_pr_reg(pr_reg);
 	return 0;
 }
 
@@ -924,6 +1009,35 @@ static int core_scsi3_emulate_pro_reserve(
 	return ret;
 }
 
+/*
+ * Called with se_device_t->dev_reservation_lock held.
+ */
+static void __core_scsi3_complete_pro_release(
+	se_device_t *dev,
+	se_node_acl_t *se_nacl,
+	t10_pr_registration_t *pr_reg,
+	int explict)
+{
+	struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
+	/*
+	 * Go ahead and release the current PR reservation holder.
+	 */
+	dev->dev_pr_res_holder = NULL;
+
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: %s RELEASE cleared"
+		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		tfo->get_fabric_name(), (explict) ? "explict" : "implict",
+		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s\n",
+		tfo->get_fabric_name(),
+		se_nacl->initiatorname);
+	/*
+	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
+	 */
+	pr_reg->pr_res_holder = pr_reg->pr_res_type = pr_reg->pr_res_scope = 0;
+}
+
 static int core_scsi3_emulate_pro_release(
 	se_cmd_t *cmd,
 	int type,
@@ -967,6 +1081,7 @@ static int core_scsi3_emulate_pro_release(
 		 * No persistent reservation, return GOOD status.
 		 */
 		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 	}
 	if (pr_res_holder != pr_reg) {
@@ -975,6 +1090,7 @@ static int core_scsi3_emulate_pro_release(
 		 * persistent reservation holder. return GOOD status.
 		 */
 		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 	}
 	/*
@@ -996,6 +1112,7 @@ static int core_scsi3_emulate_pro_release(
 			" does not match existing SA REGISTER res_key:"
 			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
 		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
 	/*
@@ -1017,27 +1134,14 @@ static int core_scsi3_emulate_pro_release(
 			pr_res_holder->pr_reg_nacl->initiatorname);
 
 		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
-	/*
-	 * Go ahead and release the current PR reservation holder.
-	 */
-	dev->dev_pr_res_holder = NULL;
-
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: explict RELEASE cleared"
-		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		CMD_TFO(cmd)->get_fabric_name(),
-		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
-		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s\n",
-		CMD_TFO(cmd)->get_fabric_name(),
-		se_sess->se_node_acl->initiatorname);
-	/*
-	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
-	 */
-	pr_reg->pr_res_holder = pr_reg->pr_res_type = pr_reg->pr_res_scope = 0;
+	__core_scsi3_complete_pro_release(dev, se_sess->se_node_acl,
+			pr_reg, 1);
 	spin_unlock(&dev->dev_reservation_lock);
 
+	core_scsi3_put_pr_reg(pr_reg);
 	return 0;
 }
 
@@ -1144,8 +1248,7 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 			type, scope, res_key);
 #if 0
 	case PRO_CLEAR:
-		return core_scsi3_emulate_pro_clear(cmd,
-			res_key);
+		return core_scsi3_emulate_pro_clear(cmd, res_key);
 	case PRO_PREEMPT:
 		return core_scsi3_emulate_pro_preempt(cmd,
 			type, scope, res_key, sa_res_key);
@@ -1296,7 +1399,6 @@ static int core_scsi3_pri_read_reservation(se_cmd_t *cmd)
  */
 static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 {
-	se_device_t *se_dev = SE_DEV(cmd);
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
@@ -1513,7 +1615,10 @@ static int core_pt_release(se_cmd_t *cmd)
 	return 0;
 }
 
-static int core_pt_seq_non_holder(se_cmd_t *cmd, unsigned char *cdb, u32 pr_reg_type)
+static int core_pt_seq_non_holder(
+	se_cmd_t *cmd,
+	unsigned char *cdb,
+	u32 pr_reg_type)
 {
 	return 0;
 }
diff --git a/drivers/lio-core/target_core_pr.h b/drivers/lio-core/target_core_pr.h
index 917381e..9003ebb 100644
--- a/drivers/lio-core/target_core_pr.h
+++ b/drivers/lio-core/target_core_pr.h
@@ -42,6 +42,8 @@
 
 extern struct kmem_cache *t10_pr_reg_cache;
 
+extern void core_scsi3_free_pr_reg_from_nacl(struct se_device_s *,
+					     struct se_node_acl_s *);
 extern void core_scsi3_free_all_registrations(struct se_device_s *);
 extern unsigned char *core_scsi3_pr_dump_type(int);
 extern int core_scsi3_emulate_pr(struct se_cmd_s *);
-- 
1.5.4.1
