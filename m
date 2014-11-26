From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] tcm_loop: Wrong I_T nexus association
Date: Wed, 26 Nov 2014 14:58:57 +0100
Message-ID: <1417010337-74779-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaKZN7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 08:59:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

tcm_loop has the I_T nexus associated with the HBA. This causes
commands to become misdirected if the HBA has more than one
target portal group; any command is then being sent to the
first target portal group instead of the correct one.

The nexus needs to be associated with the target portal group
instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 66 +++++++++++++-------------------------
 drivers/target/loopback/tcm_loop.h |  7 +---
 2 files changed, 24 insertions(+), 49 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4d1b722..7172a71 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -138,7 +138,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
 		goto out_done;
 	}
-	tl_nexus = tl_hba->tl_nexus;
+	tl_nexus = tl_tpg->tl_nexus;
 	if (!tl_nexus) {
 		scmd_printk(KERN_ERR, sc, "TCM_Loop I_T Nexus"
 				" does not exist\n");
@@ -218,16 +218,26 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
  * to struct scsi_device
  */
 static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
-			      struct tcm_loop_nexus *tl_nexus,
 			      int lun, int task, enum tcm_tmreq_table tmr)
 {
 	struct se_cmd *se_cmd = NULL;
 	struct se_session *se_sess;
 	struct se_portal_group *se_tpg;
+	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_cmd *tl_cmd = NULL;
 	struct tcm_loop_tmr *tl_tmr = NULL;
 	int ret = TMR_FUNCTION_FAILED, rc;
 
+	/*
+	 * Locate the tl_nexus and se_sess pointers
+	 */
+	tl_nexus = tl_tpg->tl_nexus;
+	if (!tl_nexus) {
+		pr_err("Unable to perform device reset without"
+				" active I_T Nexus\n");
+		return ret;
+	}
+
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_KERNEL);
 	if (!tl_cmd) {
 		pr_err("Unable to allocate memory for tl_cmd\n");
@@ -243,7 +253,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 
 	se_cmd = &tl_cmd->tl_se_cmd;
 	se_tpg = &tl_tpg->tl_se_tpg;
-	se_sess = tl_nexus->se_sess;
+	se_sess = tl_tpg->tl_nexus->se_sess;
 	/*
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
@@ -288,7 +298,6 @@ release:
 static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 {
 	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_tpg *tl_tpg;
 	int ret = FAILED;
 
@@ -296,21 +305,8 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	 * Locate the tcm_loop_hba_t pointer
 	 */
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
-	/*
-	 * Locate the tl_nexus and se_sess pointers
-	 */
-	tl_nexus = tl_hba->tl_nexus;
-	if (!tl_nexus) {
-		pr_err("Unable to perform device reset without"
-				" active I_T Nexus\n");
-		return FAILED;
-	}
-
-	/*
-	 * Locate the tl_tpg pointer from TargetID in sc->device->id
-	 */
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus, sc->device->lun,
+	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
 				 sc->request->tag, TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
@@ -322,7 +318,6 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 {
 	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_tpg *tl_tpg;
 	int ret = FAILED;
 
@@ -330,20 +325,9 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * Locate the tcm_loop_hba_t pointer
 	 */
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
-	/*
-	 * Locate the tl_nexus and se_sess pointers
-	 */
-	tl_nexus = tl_hba->tl_nexus;
-	if (!tl_nexus) {
-		pr_err("Unable to perform device reset without"
-				" active I_T Nexus\n");
-		return FAILED;
-	}
-	/*
-	 * Locate the tl_tpg pointer from TargetID in sc->device->id
-	 */
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus, sc->device->lun,
+
+	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
 				 0, TMR_LUN_RESET);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
@@ -940,8 +924,8 @@ static int tcm_loop_make_nexus(
 	struct tcm_loop_nexus *tl_nexus;
 	int ret = -ENOMEM;
 
-	if (tl_tpg->tl_hba->tl_nexus) {
-		pr_debug("tl_tpg->tl_hba->tl_nexus already exists\n");
+	if (tl_tpg->tl_nexus) {
+		pr_debug("tl_tpg->tl_nexus already exists\n");
 		return -EEXIST;
 	}
 	se_tpg = &tl_tpg->tl_se_tpg;
@@ -976,7 +960,7 @@ static int tcm_loop_make_nexus(
 	 */
 	__transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
 			tl_nexus->se_sess, tl_nexus);
-	tl_tpg->tl_hba->tl_nexus = tl_nexus;
+	tl_tpg->tl_nexus = tl_nexus;
 	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
 		name);
@@ -992,12 +976,8 @@ static int tcm_loop_drop_nexus(
 {
 	struct se_session *se_sess;
 	struct tcm_loop_nexus *tl_nexus;
-	struct tcm_loop_hba *tl_hba = tpg->tl_hba;
 
-	if (!tl_hba)
-		return -ENODEV;
-
-	tl_nexus = tl_hba->tl_nexus;
+	tl_nexus = tpg->tl_nexus;
 	if (!tl_nexus)
 		return -ENODEV;
 
@@ -1013,13 +993,13 @@ static int tcm_loop_drop_nexus(
 	}
 
 	pr_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
-		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
+		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tpg->tl_hba),
 		tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated SAS Target Port
 	 */
 	transport_deregister_session(tl_nexus->se_sess);
-	tpg->tl_hba->tl_nexus = NULL;
+	tpg->tl_nexus = NULL;
 	kfree(tl_nexus);
 	return 0;
 }
@@ -1035,7 +1015,7 @@ static ssize_t tcm_loop_tpg_show_nexus(
 	struct tcm_loop_nexus *tl_nexus;
 	ssize_t ret;
 
-	tl_nexus = tl_tpg->tl_hba->tl_nexus;
+	tl_nexus = tl_tpg->tl_nexus;
 	if (!tl_nexus)
 		return -ENODEV;
 
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index 54c59d0..6ae49f2 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -27,11 +27,6 @@ struct tcm_loop_tmr {
 };
 
 struct tcm_loop_nexus {
-	int it_nexus_active;
-	/*
-	 * Pointer to Linux/SCSI HBA from linux/include/scsi_host.h
-	 */
-	struct scsi_host *sh;
 	/*
 	 * Pointer to TCM session for I_T Nexus
 	 */
@@ -51,6 +46,7 @@ struct tcm_loop_tpg {
 	atomic_t tl_tpg_port_count;
 	struct se_portal_group tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_nexus *tl_nexus;
 };
 
 struct tcm_loop_hba {
@@ -59,7 +55,6 @@ struct tcm_loop_hba {
 	struct se_hba_s *se_hba;
 	struct se_lun *tl_hba_lun;
 	struct se_port *tl_hba_lun_sep;
-	struct tcm_loop_nexus *tl_nexus;
 	struct device dev;
 	struct Scsi_Host *sh;
 	struct tcm_loop_tpg tl_hba_tpgs[TL_TPGS_PER_HBA];
-- 
1.8.5.2

