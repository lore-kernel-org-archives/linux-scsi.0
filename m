From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] tcm_loop: TCQ and command abort support
Date: Wed, 16 Oct 2013 09:12:55 +0200
Message-ID: <1381907576-81857-5-git-send-email-hare@suse.de>
References: <1381907576-81857-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760093Ab3JPHND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 03:13:03 -0400
In-Reply-To: <1381907576-81857-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Implement TCQ support, which enables us to do proper command
abort, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 71 +++++++++++++++++++++++++++++++++++---
 drivers/target/loopback/tcm_loop.h |  2 ++
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 7232976..febe166 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -135,6 +135,21 @@ static int tcm_loop_change_queue_depth(
 	return sdev->queue_depth;
 }
 
+static int tcm_loop_change_queue_type(struct scsi_device *sdev, int tag)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag);
+
+		if (tag)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag = 0;
+
+	return tag;
+}
+
 /*
  * Locate the SAM Task Attr from struct scsi_cmnd *
  */
@@ -236,6 +251,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	}
 
 	tl_cmd->sc = sc;
+	tl_cmd->sc_cmd_tag = sc->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
 	queue_work(tcm_loop_workqueue, &tl_cmd->work);
 	return 0;
@@ -247,7 +263,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
  */
 static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 			      struct tcm_loop_nexus *tl_nexus,
-			      int lun, enum tcm_tmreq_table tmr)
+			      int lun, int task, enum tcm_tmreq_table tmr)
 {
 	struct se_cmd *se_cmd = NULL;
 	struct se_session *se_sess;
@@ -283,6 +299,9 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	if (rc < 0)
 		goto release;
 
+	if (tmr == TMR_ABORT_TASK)
+		se_cmd->se_tmr_req->ref_task_tag = task;
+
 	/*
 	 * Locate the underlying TCM struct se_lun
 	 */
@@ -310,6 +329,36 @@ release:
 	return ret;
 }
 
+static int tcm_loop_abort_task(struct scsi_cmnd *sc)
+{
+	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_nexus *tl_nexus;
+	struct tcm_loop_tpg *tl_tpg;
+	int ret = FAILED;
+
+	/*
+	 * Locate the tcm_loop_hba_t pointer
+	 */
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	/*
+	 * Locate the tl_nexus and se_sess pointers
+	 */
+	tl_nexus = tl_hba->tl_nexus;
+	if (!tl_nexus) {
+		pr_err("Unable to perform device reset without"
+				" active I_T Nexus\n");
+		return FAILED;
+	}
+
+	/*
+	 * Locate the tl_tpg pointer from TargetID in sc->device->id
+	 */
+	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
+	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus, sc->device->lun,
+				 sc->tag, TMR_ABORT_TASK);
+	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
+}
+
 /*
  * Called from SCSI EH process context to issue a LUN_RESET TMR
  * to struct scsi_device
@@ -338,8 +387,8 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * Locate the tl_tpg pointer from TargetID in sc->device->id
 	 */
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus,
-				 sc->device->lun, TMR_LUN_RESET);
+	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus, sc->device->lun,
+				 0, TMR_LUN_RESET);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
@@ -351,6 +400,15 @@ static int tcm_loop_slave_alloc(struct scsi_device *sd)
 
 static int tcm_loop_slave_configure(struct scsi_device *sd)
 {
+	if (sd->tagged_supported) {
+		scsi_activate_tcq(sd, sd->queue_depth);
+		scsi_adjust_queue_depth(sd, MSG_SIMPLE_TAG,
+					sd->host->cmd_per_lun);
+	} else {
+		scsi_adjust_queue_depth(sd, 0,
+					sd->host->cmd_per_lun);
+	}
+
 	return 0;
 }
 
@@ -360,6 +418,8 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.name			= "TCM_Loopback",
 	.queuecommand		= tcm_loop_queuecommand,
 	.change_queue_depth	= tcm_loop_change_queue_depth,
+	.change_queue_type	= tcm_loop_change_queue_type,
+	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
 	.can_queue		= 1024,
 	.this_id		= -1,
@@ -719,7 +779,10 @@ static void tcm_loop_set_default_node_attributes(struct se_node_acl *se_acl)
 
 static u32 tcm_loop_get_task_tag(struct se_cmd *se_cmd)
 {
-	return 1;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+			struct tcm_loop_cmd, tl_se_cmd);
+
+	return tl_cmd->sc_cmd_tag;
 }
 
 static int tcm_loop_get_cmd_state(struct se_cmd *se_cmd)
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index 56528f7..54c59d0 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -10,6 +10,8 @@
 struct tcm_loop_cmd {
 	/* State of Linux/SCSI CDB+Data descriptor */
 	u32 sc_cmd_state;
+	/* Tagged command queueing */
+	u32 sc_cmd_tag;
 	/* Pointer to the CDB+Data descriptor from Linux/SCSI subsystem */
 	struct scsi_cmnd *sc;
 	/* The TCM I/O descriptor that is accessed via container_of() */
-- 
1.7.12.4

