From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 07/13] target: Inline struct se_tmr_req into se_cmd
Date: Thu, 19 Jan 2012 13:39:17 -0800
Message-ID: <1327009163-10177-8-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

This saves all fabrics from calling core_tmr_alloc_req() and
having to check the result. The downside is se_cmd gets bigger for all
requests, but hopefully later patches will reduce it.

Change the test for if a cmd is a tmr request to checking if
SCF_SCSI_TMR_CDB (a new flag) is set in cmd->se_cmd_flags.

Fixup fabric accesses of se_tmr_req

Change core_tmr_alloc_req into core_tmr_req_init

Remove se_tmr_req_cache

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |   13 +++------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |   15 +++++------
 drivers/target/iscsi/iscsi_target.c      |    4 +-
 drivers/target/iscsi/iscsi_target_tmr.c  |    6 ++--
 drivers/target/iscsi/iscsi_target_util.c |    8 +----
 drivers/target/loopback/tcm_loop.c       |   14 ++++------
 drivers/target/target_core_device.c      |    2 +-
 drivers/target/target_core_internal.h    |    2 -
 drivers/target/target_core_tmr.c         |   20 +++-----------
 drivers/target/target_core_transport.c   |   30 +++++++--------------
 drivers/target/tcm_fc/tfc_cmd.c          |   11 +------
 include/target/target_core_base.h        |   41 +++++++++++++++--------------
 include/target/target_core_fabric.h      |    2 +-
 13 files changed, 64 insertions(+), 104 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ecd2076..5ec4f9d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1797,19 +1797,14 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	tcm_tmr = srp_tmr_to_tcm(srp_tsk->tsk_mgmt_func);
 	if (tcm_tmr < 0) {
 		send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		send_ioctx->cmd.se_tmr_req->response =
+		send_ioctx->cmd.se_tmr_req.response =
 			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		goto process_tmr;
 	}
 	transport_init_se_cmd(&send_ioctx->cmd, &srpt_target->tf_ops, ch->sess,
 			0, DMA_NONE, MSG_SIMPLE_TAG, send_ioctx->sense_data);
 
-	cmd->se_tmr_req = core_tmr_alloc_req(cmd, NULL, tcm_tmr, GFP_KERNEL);
-	if (!cmd->se_tmr_req) {
-		send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
-		goto process_tmr;
-	}
+	core_tmr_req_init(cmd, NULL, tcm_tmr);
 
 	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_tsk->lun,
 				       sizeof(srp_tsk->lun));
@@ -1817,7 +1812,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	if (res) {
 		pr_debug("rejecting TMR for LUN %lld\n", unpacked_lun);
 		send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		send_ioctx->cmd.se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
+		send_ioctx->cmd.se_tmr_req.response = TMR_LUN_DOES_NOT_EXIST;
 		goto process_tmr;
 	}
 
@@ -3011,7 +3006,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
 					      cmd->scsi_status);
 	else {
 		srp_tm_status
-			= tcm_to_srp_tsk_mgmt_status(cmd->se_tmr_req->response);
+			= tcm_to_srp_tsk_mgmt_status(cmd->se_tmr_req.response);
 		resp_len = srpt_build_tskmgmt_rsp(ch, ioctx, srp_tm_status,
 						 ioctx->tag);
 	}
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index f92f64b..7132c1c 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -410,7 +410,7 @@ void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
  */
 int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 {
-	if (se_cmd->se_tmr_req) {
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
 		struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
 				struct qla_tgt_mgmt_cmd, se_cmd);
 		/*
@@ -431,7 +431,7 @@ void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd;
 
-	if (se_cmd->se_tmr_req != NULL)
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		return;
 
 	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
@@ -684,15 +684,14 @@ int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun, uint8_t
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
 				DMA_NONE, 0, NULL);
 	/*
-	 * Allocate the TCM TMR
+	 * Initialize the TCM TMR
 	 */
-	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, mcmd, tmr_func, GFP_ATOMIC);
-	if (!se_cmd->se_tmr_req)
-		return -ENOMEM;
+	core_tmr_req_init(se_cmd, mcmd, tmr_func);
+
 	/*
 	 * Save the se_tmr_req for qla_tgt_xmit_tm_rsp() callback into LLD code
 	 */
-	mcmd->se_tmr_req = se_cmd->se_tmr_req;
+	mcmd->se_tmr_req = &se_cmd->se_tmr_req;
 	/*
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
@@ -759,7 +758,7 @@ int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 
 int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
+	struct se_tmr_req *se_tmr = &se_cmd->se_tmr_req;
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
 				struct qla_tgt_mgmt_cmd, se_cmd);
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c1a5e09..9cd2837 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1740,7 +1740,7 @@ static int iscsit_handle_task_mgt_cmd(
 	cmd->targ_xfer_tag	= 0xFFFFFFFF;
 	cmd->cmd_sn		= hdr->cmdsn;
 	cmd->exp_stat_sn	= hdr->exp_statsn;
-	se_tmr			= cmd->se_cmd.se_tmr_req;
+	se_tmr			= &cmd->se_cmd.se_tmr_req;
 	tmr_req			= cmd->tmr_req;
 	/*
 	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
@@ -3120,7 +3120,7 @@ static int iscsit_send_task_mgt_rsp(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm_rsp *hdr;
 	u32 tx_size = 0;
 
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index e01da9d..438fa67 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -42,7 +42,7 @@ u8 iscsit_tmr_abort_task(
 	struct iscsi_cmd *ref_cmd;
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
@@ -122,7 +122,7 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_conn_recovery *cr = NULL;
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	int ret;
 
@@ -459,7 +459,7 @@ static int iscsit_task_reassign_complete(
 extern int iscsit_tmr_post_handler(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
 
 	if (tmr_req->task_reassign &&
 	   (se_tmr->response == ISCSI_TMF_RSP_COMPLETE))
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 11287e1..2a15d02 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -286,13 +286,9 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 		goto out;
 	}
 
-	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd,
-				cmd->tmr_req, tcm_function,
-				GFP_KERNEL);
-	if (!se_cmd->se_tmr_req)
-		goto out;
+	core_tmr_req_init(se_cmd, cmd->tmr_req, tcm_function);
 
-	cmd->tmr_req->se_tmr_req = se_cmd->se_tmr_req;
+	cmd->tmr_req->se_tmr_req = &se_cmd->se_tmr_req;
 
 	return cmd;
 out:
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 5f69594..8302f01 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -187,7 +187,7 @@ static int tcm_loop_check_stop_free(struct se_cmd *se_cmd)
 	 * pointer.  These will be released directly in tcm_loop_device_reset()
 	 * with transport_generic_free_cmd().
 	 */
-	if (se_cmd->se_tmr_req)
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
 		return 0;
 	/*
 	 * Release the struct se_cmd, which will make a callback to release
@@ -366,12 +366,10 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 				DMA_NONE, MSG_SIMPLE_TAG,
 				&tl_cmd->tl_sense_buf[0]);
 	/*
-	 * Allocate the LUN_RESET TMR
+	 * Initialize the LUN_RESET TMR
 	 */
-	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, tl_tmr,
-						TMR_LUN_RESET, GFP_KERNEL);
-	if (IS_ERR(se_cmd->se_tmr_req))
-		goto release;
+	core_tmr_req_init(se_cmd, tl_tmr, TMR_LUN_RESET);
+
 	/*
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
@@ -387,7 +385,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * The TMR LUN_RESET has completed, check the response status and
 	 * then release allocations.
 	 */
-	ret = (se_cmd->se_tmr_req->response == TMR_FUNCTION_COMPLETE) ?
+	ret = (se_cmd->se_tmr_req.response == TMR_FUNCTION_COMPLETE) ?
 		SUCCESS : FAILED;
 release:
 	if (se_cmd)
@@ -886,7 +884,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 
 static int tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
+	struct se_tmr_req *se_tmr = &se_cmd->se_tmr_req;
 	struct tcm_loop_tmr *tl_tmr = se_tmr->fabric_tmr_ptr;
 	/*
 	 * The SCSI EH thread will be sleeping on se_tmr->tl_tmr_wait, go ahead
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6432685..d94f99c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -173,7 +173,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
-	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
+	struct se_tmr_req *se_tmr = &se_cmd->se_tmr_req;
 	unsigned long flags;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 4500136..e414c90 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -94,8 +94,6 @@ struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
 int	core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
-extern struct kmem_cache *se_tmr_req_cache;
-
 int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index a5c2e41..4c91ad0 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -40,27 +40,20 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 
-struct se_tmr_req *core_tmr_alloc_req(
+void core_tmr_req_init(
 	struct se_cmd *se_cmd,
 	void *fabric_tmr_ptr,
-	u8 function,
-	gfp_t gfp_flags)
+	u8 function)
 {
-	struct se_tmr_req *tmr;
+	struct se_tmr_req *tmr = &se_cmd->se_tmr_req;
 
-	tmr = kmem_cache_zalloc(se_tmr_req_cache, gfp_flags);
-	if (!tmr) {
-		pr_err("Unable to allocate struct se_tmr_req\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	se_cmd->se_cmd_flags |= SCF_SCSI_TMR_CDB;
 	tmr->task_cmd = se_cmd;
 	tmr->fabric_tmr_ptr = fabric_tmr_ptr;
 	tmr->function = function;
 	INIT_LIST_HEAD(&tmr->tmr_list);
-
-	return tmr;
 }
-EXPORT_SYMBOL(core_tmr_alloc_req);
+EXPORT_SYMBOL(core_tmr_req_init);
 
 void core_tmr_release_req(
 	struct se_tmr_req *tmr)
@@ -69,15 +62,12 @@ void core_tmr_release_req(
 	unsigned long flags;
 
 	if (!dev) {
-		kmem_cache_free(se_tmr_req_cache, tmr);
 		return;
 	}
 
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
 	list_del(&tmr->tmr_list);
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
-
-	kmem_cache_free(se_tmr_req_cache, tmr);
 }
 
 static void core_tmr_handle_tas_abort(
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5d8867c..314567a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -58,7 +58,6 @@ static int sub_api_initialized;
 
 static struct workqueue_struct *target_completion_wq;
 static struct kmem_cache *se_sess_cache;
-struct kmem_cache *se_tmr_req_cache;
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
@@ -82,21 +81,13 @@ static void target_complete_ok_work(struct work_struct *work);
 
 int init_se_kmem_caches(void)
 {
-	se_tmr_req_cache = kmem_cache_create("se_tmr_cache",
-			sizeof(struct se_tmr_req), __alignof__(struct se_tmr_req),
-			0, NULL);
-	if (!se_tmr_req_cache) {
-		pr_err("kmem_cache_create() for struct se_tmr_req"
-				" failed\n");
-		goto out;
-	}
 	se_sess_cache = kmem_cache_create("se_sess_cache",
 			sizeof(struct se_session), __alignof__(struct se_session),
 			0, NULL);
 	if (!se_sess_cache) {
 		pr_err("kmem_cache_create() for struct se_session"
 				" failed\n");
-		goto out_free_tmr_req_cache;
+		goto out;
 	}
 	se_ua_cache = kmem_cache_create("se_ua_cache",
 			sizeof(struct se_ua), __alignof__(struct se_ua),
@@ -169,8 +160,6 @@ out_free_ua_cache:
 	kmem_cache_destroy(se_ua_cache);
 out_free_sess_cache:
 	kmem_cache_destroy(se_sess_cache);
-out_free_tmr_req_cache:
-	kmem_cache_destroy(se_tmr_req_cache);
 out:
 	return -ENOMEM;
 }
@@ -178,7 +167,6 @@ out:
 void release_se_kmem_caches(void)
 {
 	destroy_workqueue(target_completion_wq);
-	kmem_cache_destroy(se_tmr_req_cache);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_ua_cache);
 	kmem_cache_destroy(t10_pr_reg_cache);
@@ -555,7 +543,7 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	if (!cmd->se_tmr_req)
+	if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 		transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
@@ -3942,8 +3930,8 @@ void transport_release_cmd(struct se_cmd *cmd)
 {
 	BUG_ON(!cmd->se_tfo);
 
-	if (cmd->se_tmr_req)
-		core_tmr_release_req(cmd->se_tmr_req);
+	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		core_tmr_release_req(&cmd->se_tmr_req);
 	if (cmd->t_task_cdb != cmd->__t_task_cdb)
 		kfree(cmd->t_task_cdb);
 	/*
@@ -3961,7 +3949,7 @@ EXPORT_SYMBOL(transport_release_cmd);
 void transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
-		if (wait_for_tasks && cmd->se_tmr_req)
+		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 			 transport_wait_for_tasks(cmd);
 
 		transport_release_cmd(cmd);
@@ -4287,7 +4275,8 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) && !(cmd->se_tmr_req)) {
+	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
+	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return false;
 	}
@@ -4295,7 +4284,8 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 	 * Only perform a possible wait_for_tasks if SCF_SUPPORTED_SAM_OPCODE
 	 * has been set in transport_set_supported_SAM_opcode().
 	 */
-	if (!(cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) && !cmd->se_tmr_req) {
+	if (!(cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) &&
+	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return false;
 	}
@@ -4639,7 +4629,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 static int transport_generic_do_tmr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_tmr_req *tmr = cmd->se_tmr_req;
+	struct se_tmr_req *tmr = &cmd->se_tmr_req;
 	int ret;
 
 	switch (tmr->function) {
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 6884b0f..f7dad73 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -353,7 +353,6 @@ static void ft_send_resp_code_and_free(struct ft_cmd *cmd,
  */
 static void ft_send_tm(struct ft_cmd *cmd)
 {
-	struct se_tmr_req *tmr;
 	struct fcp_cmnd *fcp;
 	struct ft_sess *sess;
 	u8 tm_func;
@@ -392,13 +391,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	}
 
 	pr_debug("alloc tm cmd fn %d\n", tm_func);
-	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func, GFP_KERNEL);
-	if (!tmr) {
-		pr_debug("alloc failed\n");
-		ft_send_resp_code_and_free(cmd, FCP_TMF_FAILED);
-		return;
-	}
-	cmd->se_cmd.se_tmr_req = tmr;
+	core_tmr_req_init(&cmd->se_cmd, cmd, tm_func);
 
 	switch (fcp->fc_tm_flags) {
 	case FCP_TMF_LUN_RESET:
@@ -436,7 +429,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 int ft_queue_tm_resp(struct se_cmd *se_cmd)
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
-	struct se_tmr_req *tmr = se_cmd->se_tmr_req;
+	struct se_tmr_req *tmr = &se_cmd->se_tmr_req;
 	enum fcp_resp_rsp_codes code;
 
 	switch (tmr->response) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bb739f9..7ee42d1 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -168,7 +168,8 @@ enum se_cmd_flags_table {
 	SCF_EMULATED_TASK_SENSE		= 0x00000004,
 	SCF_SCSI_DATA_SG_IO_CDB		= 0x00000008,
 	SCF_SCSI_CONTROL_SG_IO_CDB	= 0x00000010,
-	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
+	SCF_SCSI_NON_DATA_CDB		= 0x00000020,
+	SCF_SCSI_TMR_CDB		= 0x00000040,
 	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
 	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,
 	SCF_FUA				= 0x00000200,
@@ -497,6 +498,24 @@ struct se_task {
 	struct completion	task_stop_comp;
 };
 
+struct se_tmr_req {
+	/* Task Management function to be performed */
+	u8			function;
+	/* Task Management response to send */
+	u8			response;
+	int			call_transport;
+	/* Reference to ITT that Task Mgmt should be performed */
+	u32			ref_task_tag;
+	/* 64-bit encoded SAM LUN from $FABRIC_MOD TMR header */
+	u64			ref_task_lun;
+	void 			*fabric_tmr_ptr;
+	struct se_cmd		*task_cmd;
+	struct se_cmd		*ref_cmd;
+	struct se_device	*tmr_dev;
+	struct se_lun		*tmr_lun;
+	struct list_head	tmr_list;
+};
+
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
@@ -536,7 +555,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
-	struct se_tmr_req	*se_tmr_req;
+	struct se_tmr_req	se_tmr_req;
 	struct list_head	se_queue_node;
 	struct list_head	se_cmd_list;
 	struct completion	cmd_wait_comp;
@@ -585,24 +604,6 @@ struct se_cmd {
 
 };
 
-struct se_tmr_req {
-	/* Task Management function to be performed */
-	u8			function;
-	/* Task Management response to send */
-	u8			response;
-	int			call_transport;
-	/* Reference to ITT that Task Mgmt should be performed */
-	u32			ref_task_tag;
-	/* 64-bit encoded SAM LUN from $FABRIC_MOD TMR header */
-	u64			ref_task_lun;
-	void 			*fabric_tmr_ptr;
-	struct se_cmd		*task_cmd;
-	struct se_cmd		*ref_cmd;
-	struct se_device	*tmr_dev;
-	struct se_lun		*tmr_lun;
-	struct list_head	tmr_list;
-};
-
 struct se_ua {
 	u8			ua_asc;
 	u8			ua_ascq;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 3dac347..9684f32 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -144,7 +144,7 @@ void	target_wait_for_sess_cmds(struct se_session *, int);
 
 int	core_alua_check_nonop_delay(struct se_cmd *);
 
-struct se_tmr_req *core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
+void	core_tmr_req_init(struct se_cmd *, void *, u8);
 void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 int	transport_lookup_tmr_lun(struct se_cmd *, u32);
-- 
1.7.1
