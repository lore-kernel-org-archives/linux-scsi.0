From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] tcm_loop: separate out tcm_loop_issue_tmr
Date: Wed, 16 Oct 2013 09:12:54 +0200
Message-ID: <1381907576-81857-4-git-send-email-hare@suse.de>
References: <1381907576-81857-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381907576-81857-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 83 +++++++++++++++++++++++---------------
 include/target/target_core_base.h  |  1 +
 2 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index f81ebe4..7232976 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -245,41 +245,21 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
  * Called from SCSI EH process context to issue a LUN_RESET TMR
  * to struct scsi_device
  */
-static int tcm_loop_device_reset(struct scsi_cmnd *sc)
+static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
+			      struct tcm_loop_nexus *tl_nexus,
+			      int lun, enum tcm_tmreq_table tmr)
 {
 	struct se_cmd *se_cmd = NULL;
-	struct se_portal_group *se_tpg;
 	struct se_session *se_sess;
+	struct se_portal_group *se_tpg;
 	struct tcm_loop_cmd *tl_cmd = NULL;
-	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_tmr *tl_tmr = NULL;
-	struct tcm_loop_tpg *tl_tpg;
-	int ret = FAILED, rc;
-	/*
-	 * Locate the tcm_loop_hba_t pointer
-	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
-	/*
-	 * Locate the tl_nexus and se_sess pointers
-	 */
-	tl_nexus = tl_hba->tl_nexus;
-	if (!tl_nexus) {
-		pr_err("Unable to perform device reset without"
-				" active I_T Nexus\n");
-		return FAILED;
-	}
-	se_sess = tl_nexus->se_sess;
-	/*
-	 * Locate the tl_tpg and se_tpg pointers from TargetID in sc->device->id
-	 */
-	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	se_tpg = &tl_tpg->tl_se_tpg;
+	int ret = TMR_FUNCTION_FAILED, rc;
 
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_KERNEL);
 	if (!tl_cmd) {
 		pr_err("Unable to allocate memory for tl_cmd\n");
-		return FAILED;
+		return ret;
 	}
 
 	tl_tmr = kzalloc(sizeof(struct tcm_loop_tmr), GFP_KERNEL);
@@ -290,6 +270,8 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	init_waitqueue_head(&tl_tmr->tl_tmr_wait);
 
 	se_cmd = &tl_cmd->tl_se_cmd;
+	se_tpg = &tl_tpg->tl_se_tpg;
+	se_sess = tl_nexus->se_sess;
 	/*
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
@@ -297,17 +279,20 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 				DMA_NONE, MSG_SIMPLE_TAG,
 				&tl_cmd->tl_sense_buf[0]);
 
-	rc = core_tmr_alloc_req(se_cmd, tl_tmr, TMR_LUN_RESET, GFP_KERNEL);
+	rc = core_tmr_alloc_req(se_cmd, tl_tmr, tmr, GFP_KERNEL);
 	if (rc < 0)
 		goto release;
+
 	/*
-	 * Locate the underlying TCM struct se_lun from sc->device->lun
+	 * Locate the underlying TCM struct se_lun
 	 */
-	if (transport_lookup_tmr_lun(se_cmd, sc->device->lun) < 0)
+	if (transport_lookup_tmr_lun(se_cmd, lun) < 0) {
+		ret = TMR_LUN_DOES_NOT_EXIST;
 		goto release;
+	}
 	/*
-	 * Queue the TMR to TCM Core and sleep waiting for tcm_loop_queue_tm_rsp()
-	 * to wake us up.
+	 * Queue the TMR to TCM Core and sleep waiting for
+	 * tcm_loop_queue_tm_rsp() to wake us up.
 	 */
 	transport_generic_handle_tmr(se_cmd);
 	wait_event(tl_tmr->tl_tmr_wait, atomic_read(&tl_tmr->tmr_complete));
@@ -315,8 +300,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * The TMR LUN_RESET has completed, check the response status and
 	 * then release allocations.
 	 */
-	ret = (se_cmd->se_tmr_req->response == TMR_FUNCTION_COMPLETE) ?
-		SUCCESS : FAILED;
+	ret = se_cmd->se_tmr_req->response;
 release:
 	if (se_cmd)
 		transport_generic_free_cmd(se_cmd, 1);
@@ -326,6 +310,39 @@ release:
 	return ret;
 }
 
+/*
+ * Called from SCSI EH process context to issue a LUN_RESET TMR
+ * to struct scsi_device
+ */
+static int tcm_loop_device_reset(struct scsi_cmnd *sc)
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
+	/*
+	 * Locate the tl_tpg pointer from TargetID in sc->device->id
+	 */
+	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
+	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus,
+				 sc->device->lun, TMR_LUN_RESET);
+	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
+}
+
 static int tcm_loop_slave_alloc(struct scsi_device *sd)
 {
 	set_bit(QUEUE_FLAG_BIDI, &sd->request_queue->queue_flags);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 34181ad..637ea73 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -227,6 +227,7 @@ enum tcm_tmreq_table {
 
 /* fabric independent task management response values */
 enum tcm_tmrsp_table {
+	TMR_FUNCTION_FAILED		= 0,
 	TMR_FUNCTION_COMPLETE		= 1,
 	TMR_TASK_DOES_NOT_EXIST		= 2,
 	TMR_LUN_DOES_NOT_EXIST		= 3,
-- 
1.7.12.4
