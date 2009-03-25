From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Add UNIT
	ATTENTION support for PROUT SAs
Date: Tue, 24 Mar 2009 23:07:26 -0700
Message-ID: <1237961246.4138.421.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:47935 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757833AbZCYGHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 02:07:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>From d3aed0204976bffa99505e606f2909fd61b3b8f3 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 24 Mar 2009 22:25:36 -0700
Subject: [PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Add UNIT ATTENTION support for PROUT SAs

This patch adds support for SAM4 defined UNIT ATTENTION conditions in SPC-3 compliant
Persistent Reservations PROUT Service Actions REGISTER + SARK=0 (UNREGISTER), RELEASE,
and CLEAR.

The respective UNIT ATTENTION ASCQs for the non PROUT SA calling I_T Nexus
ports are ASCQ_2AH_RESERVATIONS_RELEASED, ASCQ_2AH_RESERVATIONS_RELEASED,
and ASCQ_2AH_RESERVATIONS_PREEMPTED.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |  107 +++++++++++++++++++++++++++++++++---
 1 files changed, 98 insertions(+), 9 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index d733bae..0ddf54c 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -38,6 +38,7 @@
 #include <target_core_hba.h>
 #include <target_core_transport.h>
 #include <target_core_pr.h>
+#include <target_core_ua.h>
 #include <target_core_transport_plugin.h>
 #include <target_core_fabric_ops.h>
 #include <target_core_configfs.h>
@@ -532,12 +533,13 @@ static void core_scsi3_put_pr_reg(t10_pr_registration_t *pr_reg)
 	smp_mb__after_atomic_dec();
 }
 
-static void core_scsi3_check_implict_release(
+static int core_scsi3_check_implict_release(
 	se_device_t *dev,
 	t10_pr_registration_t *pr_reg)
 {
 	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
 	t10_pr_registration_t *pr_res_holder;
+	int ret = 0;
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
@@ -556,10 +558,12 @@ static void core_scsi3_check_implict_release(
 		 *    field set to zero (see 5.7.11.3).
 		 */
 		__core_scsi3_complete_pro_release(dev, nacl, pr_reg, 0);
-#warning FIXME: Registrants only, UA + RESERVATIONS RELEASED
+		ret = 1;
 #warning FIXME: All Registrants, only release reservation when last registration is freed.
 	}
 	spin_unlock(&dev->dev_reservation_lock);
+
+	return ret;
 }
 
 /*
@@ -681,9 +685,9 @@ static int core_scsi3_emulate_pro_register(
 	se_dev_entry_t *se_deve;
 	se_lun_t *se_lun = SE_LUN(cmd);
 	se_portal_group_t *se_tpg;
-	t10_pr_registration_t *pr_reg;
+	t10_pr_registration_t *pr_reg, *pr_reg_p;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
-	int ret = 0;
+	int pr_holder = 0, ret = 0, type;
 
 	if (!(se_sess) || !(se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
@@ -748,6 +752,8 @@ static int core_scsi3_emulate_pro_register(
 			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
+		type = pr_reg->pr_res_type;
+
 		if (!(ignore_key)) {
 			if (res_key != pr_reg->pr_res_key) {
 				printk(KERN_ERR "SPC-3 PR REGISTER: Received"
@@ -771,9 +777,38 @@ static int core_scsi3_emulate_pro_register(
 		 * Nexus.
 		 */
 		if (!(sa_res_key)) {
-			core_scsi3_check_implict_release(SE_DEV(cmd), pr_reg);
+			pr_holder = core_scsi3_check_implict_release(
+					SE_DEV(cmd), pr_reg);
+
 			spin_lock(&pr_tmpl->registration_lock);
+			/*
+			 * Release the calling I_T Nexus registration now..
+			 */
 			__core_scsi3_free_registration(SE_DEV(cmd), pr_reg, 1);
+			/*
+			 * From spc4r17, section 5.7.11.3 Unregistering
+			 *
+			 * If the persistent reservation is a registrants only
+			 * type, the device server shall establish a unit
+			 * attention condition for the initiator port associated
+			 * with every registered I_T nexus except for the I_T
+			 * nexus on which the PERSISTENT RESERVE OUT command was
+			 * received, with the additional sense code set to
+			 * RESERVATIONS RELEASED.
+			 */
+			if (pr_holder &&
+			   ((type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY) ||
+			    (type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY))) {
+				list_for_each_entry(pr_reg_p,
+						&pr_tmpl->registration_list,
+						pr_reg_list) {
+
+					core_scsi3_ua_allocate(
+						pr_reg_p->pr_reg_nacl,
+						cmd->orig_fe_lun, 0x2A,
+						ASCQ_2AH_RESERVATIONS_RELEASED);
+				}
+			}
 			spin_unlock(&pr_tmpl->registration_lock);
 		} else {
 			/*
@@ -1047,7 +1082,8 @@ static int core_scsi3_emulate_pro_release(
 	se_device_t *dev = cmd->se_dev;
 	se_session_t *se_sess = SE_SESS(cmd);
 	se_lun_t *se_lun = SE_LUN(cmd);
-	t10_pr_registration_t *pr_reg, *pr_res_holder;
+	t10_pr_registration_t *pr_reg, *pr_reg_p, *pr_res_holder;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 
 	if (!(se_sess) || !(se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
@@ -1137,10 +1173,50 @@ static int core_scsi3_emulate_pro_release(
 		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
+	/*
+	 * In response to a persistent reservation release request from the
+	 * persistent reservation holder the device server shall perform a
+	 * release by doing the following as an uninterrupted series of actions:
+	 * a) Release the persistent reservation;
+	 * b) Not remove any registration(s);
+	 * c) If the released persistent reservation is a registrants only type
+	 * or all registrants type persistent reservation,
+	 *    the device server shall establish a unit attention condition for
+	 *    the initiator port associated with every regis-
+	 *    tered I_T nexus other than I_T nexus on which the PERSISTENT
+	 *    RESERVE OUT command with RELEASE service action was received,
+	 *    with the additional sense code set to RESERVATIONS RELEASED; and
+	 * d) If the persistent reservation is of any other type, the device
+	 *    server shall not establish a unit attention condition.
+	 */
 	__core_scsi3_complete_pro_release(dev, se_sess->se_node_acl,
 			pr_reg, 1);
+
+	if ((type != PR_TYPE_WRITE_EXCLUSIVE_REGONLY) &&
+	    (type != PR_TYPE_EXCLUSIVE_ACCESS_REGONLY) &&
+	    (type != PR_TYPE_WRITE_EXCLUSIVE_ALLREG) &&
+	    (type != PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
+		spin_unlock(&dev->dev_reservation_lock);
+		core_scsi3_put_pr_reg(pr_reg);
+		return 0;
+	}
 	spin_unlock(&dev->dev_reservation_lock);
 
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry(pr_reg_p, &pr_tmpl->registration_list,
+			pr_reg_list) {
+		/*
+		 * Do not establish a UNIT ATTENTION condition
+		 * for the calling I_T Nexus
+		 */
+		if (pr_reg_p == pr_reg)
+			continue;
+
+		core_scsi3_ua_allocate(pr_reg_p->pr_reg_nacl, cmd->orig_fe_lun,
+				0x2A, ASCQ_2AH_RESERVATIONS_RELEASED);
+	}
+	spin_unlock(&pr_tmpl->registration_lock);
+
 	core_scsi3_put_pr_reg(pr_reg);
 	return 0;
 }
@@ -1150,9 +1226,11 @@ static int core_scsi3_emulate_pro_clear(
 	u64 res_key)
 {
 	se_device_t *dev = cmd->se_dev;
+	se_node_acl_t *pr_reg_nacl;
 	se_session_t *se_sess = SE_SESS(cmd);
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
+	int calling_it_nexus = 0;
 	/*
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
 	 */
@@ -1199,9 +1277,20 @@ static int core_scsi3_emulate_pro_clear(
 	spin_lock(&pr_tmpl->registration_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
-#warning FIXME: UA + RESERVATIONS PREEMPTED for all other registered I_T nexuses
-		__core_scsi3_free_registration(dev, pr_reg,
-					(pr_reg_n == pr_reg) ? 1 : 0);
+
+		calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
+		pr_reg_nacl = pr_reg->pr_reg_nacl;
+		__core_scsi3_free_registration(dev, pr_reg, calling_it_nexus);
+		/*
+		 * e) Establish a unit attention condition for the initiator
+		 *    port associated with every registered I_T nexus other
+		 *    than the I_T nexus on which the PERSISTENT RESERVE OUT
+		 *    command with CLEAR service action was received, with the
+		 *    additional sense code set to RESERVATIONS PREEMPTED.
+		 */
+		if (!(calling_it_nexus))
+			core_scsi3_ua_allocate(pr_reg_nacl, cmd->orig_fe_lun,
+				0x2A, ASCQ_2AH_RESERVATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 
-- 
1.5.4.1



