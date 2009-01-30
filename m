From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] [Target_Core_Mod/PERSISTENT_RESERVATION]: Change logic
	for all_tg_pt=[1,0]
Date: Fri, 30 Jan 2009 01:32:12 -0800
Message-ID: <1233307932.6442.250.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37295 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752733AbZA3JdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 04:33:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>, "Lawrence E. Rosen" <lrosen@pyxtechnologies.com>, Arne Redlich <agr@powerkom-dd.de>, Ming Zhang <blackmagic02881@gmail.com>

>From 0da66cb2dfcc45e56bbbb4d314e5f5437e5bb04f Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 29 Jan 2009 19:11:13 -0800
Subject: [PATCH 1/4] [Target_Core_Mod/PERSISTENT_RESERVATION]: Change logic for all_tg_pt=[1,0]

This patch renames t10_pr_registration_t->pr_reg_lun_single_tg_pt to
t10_pr_registration_t->pr_reg_tg_pt_lun and changes the previously incorrect
assumption that all_tg_pt= had something to do with how the se_device_t (the
SCSI device server) was accessed across multiple se_lun_t target ports.

In fact, all_tg_pt=[1,0] has nothing to do with the RESERVE Service Action,
but the REGISTER Service Action.  That is, the main idea is that if a
RESERVE Service Action was not received on the *SAME* se_lun_t target port,
then the RESERVE Service Action must fail.  This logic is added in this patch
in core_scsi3_pro_reserve():

       /*
        * For a given ALL_TG_PT=0 PR registration, a recevied PR reserve must
        * be on the same matching se_portal_group_t + se_lun_t.
        */
       if (!(pr_reg->pr_reg_all_tg_pt) &&
            (pr_reg->pr_reg_tg_pt_lun != se_lun)) {
               printk(KERN_ERR "SPC-3 PR: Unable to handle RESERVE because"
                       " ALL_TG_PT=0 and RESERVE was not received on same "
                       " target port as REGISTER\n");
               return(PYX_TRANSPORT_RESERVATION_CONFLICT);
       }

Tested using the same se_device_t across two se_lun_t (attached to
LIO-Target v3.0 target ports) using sg_persist.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h |    3 +-
 drivers/lio-core/target_core_pr.c   |   37 +++++++++++++++-------------------
 2 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index e10538e..c773c13 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -231,7 +231,7 @@ typedef struct t10_pr_registration_s {
 	u64 pr_res_key;
 	struct se_node_acl_s *pr_reg_nacl;
 	struct se_dev_entry_s *pr_reg_deve;
-	struct se_lun_s *pr_reg_lun_single_tg_pt; /* Used when pr_reg_all_tg_pt=0 */
+	struct se_lun_s *pr_reg_tg_pt_lun;
 	struct list_head pr_reg_list;
 } t10_pr_registration_t;
 
@@ -571,7 +571,6 @@ typedef struct se_device_s {
 	spinlock_t		se_port_lock;
 	struct se_node_acl_s	*dev_reserved_node_acl; /* Used for legacy SPC-2 reservationsa */
 	struct t10_pr_registration_s *dev_pr_res_holder; /* Used for SPC-3 Persistent Reservations */
-	struct se_lun_s		*dev_pr_tg_port_res_lun; /* Used for PR all_tgt_pt=0 */
 	struct list_head	dev_sep_list;
 	struct timer_list		dev_status_timer;
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index 051d678..f48b092 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -331,12 +331,7 @@ static t10_pr_registration_t *core_scsi3_alloc_registration (
 	pr_reg->pr_reg_deve = deve;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
-	/*
-	 * See All Target Ports (ALL_TG_PT) bit in spcr17, section 6.14.3
-	 * Basic PERSISTENT RESERVER OUT parameter list, page 290
-	 */
-	if (!(pr_reg->pr_reg_all_tg_pt)) 
-		pr_reg->pr_reg_lun_single_tg_pt = deve->se_lun; 
+	pr_reg->pr_reg_tg_pt_lun = deve->se_lun; 
 
 	/*
 	 * Increment PRgeneration counter for se_device_t upon a successful
@@ -371,7 +366,8 @@ static t10_pr_registration_t *core_scsi3_locate_pr_reg (
 	spin_lock(&pr_tmpl->registration_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
-		if (pr_reg->pr_reg_nacl == nacl) {
+		if (!(strcmp(pr_reg->pr_reg_nacl->initiatorname,
+				nacl->initiatorname))) {
 			spin_unlock(&pr_tmpl->registration_lock);
 			return(pr_reg);
 		}
@@ -591,6 +587,17 @@ static int core_scsi3_pro_reserve (
 		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
 	}
 	/*
+	 * For a given ALL_TG_PT=0 PR registration, a recevied PR reserve must
+	 * be on the same matching se_portal_group_t + se_lun_t.
+	 */
+	if (!(pr_reg->pr_reg_all_tg_pt) &&
+	     (pr_reg->pr_reg_tg_pt_lun != se_lun)) {
+		printk(KERN_ERR "SPC-3 PR: Unable to handle RESERVE because"
+			" ALL_TG_PT=0 and RESERVE was not received on same "
+			" target port as REGISTER\n");
+		return(PYX_TRANSPORT_RESERVATION_CONFLICT);
+	}
+	/*
 	 * From spc4r17 Section 5.7.9: Reserving:
 	 *
 	 * An application client creates a persistent reservation by issuing
@@ -692,13 +699,7 @@ static int core_scsi3_pro_reserve (
 	pr_reg->pr_res_scope = scope;
 	pr_reg->pr_res_type = type;
 	dev->dev_pr_res_holder = pr_reg;
-	/*
-	 * See All Target Ports (ALL_TG_PT) bit in spcr17, section 6.14.3
-	 * Basic PERSISTENT RESERVER OUT parameter list, page 290
-	 */
-	if (!(pr_reg->pr_reg_all_tg_pt)) {
-		dev->dev_pr_tg_port_res_lun = pr_reg->pr_reg_lun_single_tg_pt;
-	}
+
 	printk("SPC-3 PR [%s] Service Action: RESERVE created new reservation"
 		" holder TYPE: %s ALL_TG_PT: %d\n",
 		CMD_TFO(cmd)->get_fabric_name(), core_scsi3_pr_dump_type(type),
@@ -864,13 +865,7 @@ static int core_scsi3_emulate_pro_release (
 	 * Go ahead and release the current PR reservation holder.
 	 */
 	dev->dev_pr_res_holder = NULL;
-	/*
-	 * If All Target Ports (ALL_TG_PT) bit == 0, clear the
-	 * se_lun_t pointer as well..
-	 */
-	if (!(pr_reg->pr_reg_all_tg_pt)) {
-		dev->dev_pr_tg_port_res_lun = NULL;
-	}
+
 	printk("SPC-3 PR [%s] Service Action: RELEASE cleared reservation holder"
 		" TYPE: %s ALL_TG_PT: %d\n", CMD_TFO(cmd)->get_fabric_name(),
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
-- 
1.5.4.1



