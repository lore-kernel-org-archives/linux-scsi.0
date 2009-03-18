From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Release
	reservation when freeing registration
Date: Tue, 17 Mar 2009 18:49:43 -0700
Message-ID: <1237340983.4214.49.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756367AbZCRBvZ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

>From ce2c29593fe895a293e4b983739abf424ad3a862 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 17 Mar 2009 16:18:05 -0700
Subject: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Release reservation when freeing registration

This patch fixes a bug a PROOUT REGISTER or REGISTER_AND_IGNORE_EXIST_KEY with a
Service Action Reservation Key == 0, was not releasing the reservation if the
registrant was the reservation holder.  This is known as a implict RELEASE,
where handling a PROUT RELEASE (what the existing code expected) is known as a
explict RELEASE.

This logic is mandated in spc4r17, section 5.7.11.1:

e) If the I_T nexus is the persistent reservation holder and the persistent reservation is not an all registrants
   type, then a PERSISTENT RESERVE OUT command with REGISTER service action or REGISTER AND
   IGNORE EXISTING KEY service action with the SERVICE ACTION RESERVATION KEY field set to zero (see
   5.7.11.3).

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |   38 +++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 839aa49..a76535f 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -515,8 +515,42 @@ static void core_scsi3_free_registration(
 {
 	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	t10_pr_registration_t *pr_res_holder;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 
+	spin_lock(&dev->dev_reservation_lock);
+	pr_res_holder = dev->dev_pr_res_holder;
+	if (pr_res_holder == pr_reg) {
+		/*
+		 * Perform an implict RELEASE if the registration that
+		 * is being released is holding the reservation.
+		 *
+		 * From spc4r17, section 5.7.11.1:
+		 *
+		 * e) If the I_T nexus is the persistent reservation holder
+		 *    and the persistent reservation is not an all registrants
+		 *    type, then a PERSISTENT RESERVE OUT command with REGISTER
+		 *    service action or REGISTER AND  IGNORE EXISTING KEY
+		 *    service action with the SERVICE ACTION RESERVATION KEY
+		 *    field set to zero (see 5.7.11.3).
+		 */
+		dev->dev_pr_res_holder = NULL;
+
+		printk(KERN_INFO "SPC-3 PR [%s] Service Action: implict"
+			" RELEASE cleared reservation holder TYPE: %s"
+			" ALL_TG_PT: %d\n", tfo->get_fabric_name(),
+			core_scsi3_pr_dump_type(pr_reg->pr_res_type),
+			(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+		printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s\n",
+			tfo->get_fabric_name(), nacl->initiatorname);
+	
+		pr_reg->pr_res_holder = pr_reg->pr_res_type = 0;
+		pr_reg->pr_res_scope = 0;
+#warning FIXME: Registrants only, UA + RESERVATIONS RELEASED
+#warning FIXME: All Registrants, only release reservation when last registration is freed.
+	}
+	spin_unlock(&dev->dev_reservation_lock);
+
 	pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
@@ -526,7 +560,7 @@ static void core_scsi3_free_registration(
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		TRANSPORT(dev)->name);
 	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x\n", tfo->get_fabric_name(),  pr_reg->pr_res_key,
+		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
 	spin_lock(&pr_tmpl->registration_lock);
@@ -980,7 +1014,7 @@ static int core_scsi3_emulate_pro_release(
 	 */
 	dev->dev_pr_res_holder = NULL;
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: RELEASE cleared"
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: explict RELEASE cleared"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		CMD_TFO(cmd)->get_fabric_name(),
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
-- 
1.5.4.1
