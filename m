From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [TCM/PR]: Replace usage of DEF_PR_REGISTERED with *core_scsi3_locate_pr_reg()
Date: Mon, 12 Apr 2010 22:49:12 -0700
Message-ID: <1271137752-23353-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:27582 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750882Ab0DMFIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 01:08:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch replaces the usage of (se_dev_entry_t->dev_flags & DEF_PR_REGISTERED)
with *core_scsi3_locate_pr_reg() in TCM/PR in order to determine registration status
of a given SCSI Initiator Port.  This was done to allow multiple I_T Nexues to hang
off a single se_node_acl_t in order to properly support ISID handling for SCSI
Initiator Port TransportIDs.

This patch changes the following areas to use *core_scsi3_locate_pr_reg()

*) SPEC_I_PT=1 TransportID processing logic in core_scsi3_decode_spec_i_port()
*) PRO_REGISTER for local I_T Nexus in core_scsi3_emulate_pro_register()
*) PRO_REGISTER_AND_MOVE for local and remote I_T Nexus in
   core_scsi3_emulate_pro_register_and_move()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |   44 ++++++++++++--------------------------
 1 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 7056530..f775db6 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1679,7 +1679,10 @@ static int core_scsi3_decode_spec_i_port(
 		 * Skip any TransportIDs that already have a registration for
 		 * this target port.
 		 */
-		if (dest_se_deve->deve_flags & DEF_PR_REGISTERED) {
+		pr_reg_e = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
+					iport_ptr);
+		if (pr_reg_e) { 
+			core_scsi3_put_pr_reg(pr_reg_e);	
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -2073,7 +2076,8 @@ static int core_scsi3_emulate_pro_register(
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
-	if (!(se_deve->deve_flags & DEF_PR_REGISTERED)) {
+	pr_reg_e = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
+	if (!(pr_reg_e)) {
 		if (res_key) {
 			printk(KERN_WARNING "SPC-3 PR: Reservation Key non-zero"
 				" for SA REGISTER, returning CONFLICT\n");
@@ -2146,13 +2150,7 @@ static int core_scsi3_emulate_pro_register(
 		/*
 		 * Locate the existing *pr_reg via se_node_acl_t pointers
 		 */
-		pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd),
-				se_sess->se_node_acl);
-		if (!(pr_reg)) {
-			printk(KERN_ERR "SPC-3 PR: Unable to locate"
-				" PR_REGISTERED *pr_reg for REGISTER\n");
-			return PYX_TRANSPORT_LU_COMM_FAILURE;
-		}
+		pr_reg = pr_reg_e;
 		type = pr_reg->pr_res_type;
 
 		if (!(ignore_key)) {
@@ -3306,13 +3304,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	/*
 	 * Follow logic from spc4r17 Section 5.7.8, Table 50 --
 	 *	Register behaviors for a REGISTER AND MOVE service action
-	 */
-	if (!(se_deve->deve_flags & DEF_PR_REGISTERED)) {
-		printk(KERN_WARNING "SPC-3 PR: Received REGISTER_AND_MOVE SA"
-				" from unregistered nexus\n");
-		return PYX_TRANSPORT_RESERVATION_CONFLICT;
-	}
-	/*
+	 *
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
@@ -3594,30 +3586,22 @@ after_iport_check:
 	 * register an I_T nexus that is already registered with the same
 	 * reservation key or a different reservation key.
 	 */
-	if (!(dest_se_deve->deve_flags & DEF_PR_REGISTERED)) {
+	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
+					iport_ptr);
+	if (!(dest_pr_reg)) {
 		ret = core_scsi3_alloc_registration(SE_DEV(cmd),
-				dest_node_acl, dest_se_deve,
+				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, 0, aptpl, 2, 1);
 		if (ret != 0) {
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			goto out;
 		}
+		dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
+						iport_ptr);
 		new_reg = 1;
 	}
 	/*
-	 * Locate the Destination registration where the reservation
-	 * is being moved.
-	 */
-	dest_pr_reg = core_scsi3_locate_pr_reg(dev, dest_node_acl);
-	if (!(dest_pr_reg)) {
-		printk(KERN_ERR "Unable to locate dest_pr_reg for"
-			" REGISTERED I_T Nexus for %s\n", initiator_str);
-		spin_unlock(&dev->dev_reservation_lock);
-		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
-		goto out;
-	}
-	/*
 	 * f) Release the persistent reservation for the persistent reservation
 	 *    holder (i.e., the I_T nexus on which the
 	 */
-- 
1.5.6.5

