From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/7] target: Drop inlining of se_tmr_req from se_cmd
Date: Sat, 25 Feb 2012 21:05:53 +0000
Message-ID: <1330203959-6170-2-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45526 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BYVON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:13 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes back target core + fabric code to use core_tmr_alloc_req()
instead of inlining se_tmr_req into se_cmd for normal fast path operations.
This patch was originally merged into lio-core here:

commit edea87ca1c79ff493badeb16c92a11bf909d5432
Author: Andy Grover <agrover@redhat.com>
Date:   Thu Jan 19 13:39:17 2012 -0800

    target: Inline struct se_tmr_req into se_cmd

For the moment this patch is being dropped for mainline in favor of
a proper union converson, so use core_tmr_alloc_req() and change back
the internal/external se_tmr_req pointer usage.

This patch keeps the SCF_SCSI_TMR_CDB from the original patch for
future usage.

Also, core_tmr_alloc_req() failure in new target_submit_tmr() code
still has a FIXME, and these failures need to be handled properly..

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |   14 +++++++++-----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |   14 ++++++++------
 drivers/target/iscsi/iscsi_target.c      |    4 ++--
 drivers/target/iscsi/iscsi_target_tmr.c  |    6 +++---
 drivers/target/iscsi/iscsi_target_util.c |    7 +++++--
 drivers/target/loopback/tcm_loop.c       |   13 ++++++-------
 drivers/target/target_core_device.c      |    2 +-
 drivers/target/target_core_tmr.c         |   21 +++++++++++++++++----
 drivers/target/target_core_transport.c   |   15 +++++++++++----
 drivers/target/tcm_fc/tfc_cmd.c          |    2 +-
 include/target/target_core_base.h        |    2 +-
 include/target/target_core_fabric.h      |    2 +-
 12 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 57dbedc..262b61e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1794,22 +1794,26 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	tcm_tmr = srp_tmr_to_tcm(srp_tsk->tsk_mgmt_func);
 	if (tcm_tmr < 0) {
 		send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		send_ioctx->cmd.se_tmr_req.response =
+		send_ioctx->cmd.se_tmr_req->response =
 			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		goto process_tmr;
 	}
 	transport_init_se_cmd(&send_ioctx->cmd, &srpt_target->tf_ops, ch->sess,
 			0, DMA_NONE, MSG_SIMPLE_TAG, send_ioctx->sense_data);
 
-	core_tmr_req_init(cmd, NULL, tcm_tmr);
-
+	res = core_tmr_alloc_req(cmd, NULL, tcm_tmr, GFP_KERNEL);
+	if (res < 0) {
+		send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
+		goto process_tmr;
+	}
 	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_tsk->lun,
 				       sizeof(srp_tsk->lun));
 	res = transport_lookup_tmr_lun(&send_ioctx->cmd, unpacked_lun);
 	if (res) {
 		pr_debug("rejecting TMR for LUN %lld\n", unpacked_lun);
 		send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		send_ioctx->cmd.se_tmr_req.response = TMR_LUN_DOES_NOT_EXIST;
+		send_ioctx->cmd.se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 		goto process_tmr;
 	}
 
@@ -3003,7 +3007,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
 					      cmd->scsi_status);
 	else {
 		srp_tm_status
-			= tcm_to_srp_tsk_mgmt_status(cmd->se_tmr_req.response);
+			= tcm_to_srp_tsk_mgmt_status(cmd->se_tmr_req->response);
 		resp_len = srpt_build_tskmgmt_rsp(ch, ioctx, srp_tm_status,
 						 ioctx->tag);
 	}
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 5456af2..c25e7db 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -675,20 +675,22 @@ int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	struct se_session *se_sess = sess->se_sess;
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
+	int rc;
 	/*
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
 				DMA_NONE, 0, NULL);
-	/*
-	 * Initialize the TCM TMR
-	 */
-	core_tmr_req_init(se_cmd, mcmd, tmr_func);
 
+	rc = core_tmr_alloc_req(se_cmd, mcmd, tmr_func, GFP_ATOMIC);
+	if (rc < 0) {
+		transport_generic_free_cmd(se_cmd, 1);
+		return -ENOMEM;
+	}
 	/*
 	 * Save the se_tmr_req for qla_tgt_xmit_tm_rsp() callback into LLD code
 	 */
-	mcmd->se_tmr_req = &se_cmd->se_tmr_req;
+	mcmd->se_tmr_req = se_cmd->se_tmr_req;
 
 	if (tmr_func == TMR_ABORT_TASK)
 		mcmd->se_tmr_req->ref_task_tag = tag;
@@ -758,7 +760,7 @@ int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 
 int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	struct se_tmr_req *se_tmr = &se_cmd->se_tmr_req;
+	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
 				struct qla_tgt_mgmt_cmd, se_cmd);
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 973dde6..3e18efd 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1740,7 +1740,7 @@ static int iscsit_handle_task_mgt_cmd(
 	cmd->targ_xfer_tag	= 0xFFFFFFFF;
 	cmd->cmd_sn		= hdr->cmdsn;
 	cmd->exp_stat_sn	= hdr->exp_statsn;
-	se_tmr			= &cmd->se_cmd.se_tmr_req;
+	se_tmr			= cmd->se_cmd.se_tmr_req;
 	tmr_req			= cmd->tmr_req;
 	/*
 	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
@@ -3120,7 +3120,7 @@ static int iscsit_send_task_mgt_rsp(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm_rsp *hdr;
 	u32 tx_size = 0;
 
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 438fa67..e01da9d 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -42,7 +42,7 @@ u8 iscsit_tmr_abort_task(
 	struct iscsi_cmd *ref_cmd;
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
@@ -122,7 +122,7 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_conn_recovery *cr = NULL;
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	int ret;
 
@@ -459,7 +459,7 @@ static int iscsit_task_reassign_complete(
 extern int iscsit_tmr_post_handler(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
-	struct se_tmr_req *se_tmr = &cmd->se_cmd.se_tmr_req;
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 
 	if (tmr_req->task_reassign &&
 	   (se_tmr->response == ISCSI_TMF_RSP_COMPLETE))
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 2a15d02..4eba86d 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -229,6 +229,7 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 {
 	struct iscsi_cmd *cmd;
 	struct se_cmd *se_cmd;
+	int rc;
 	u8 tcm_function;
 
 	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
@@ -286,9 +287,11 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 		goto out;
 	}
 
-	core_tmr_req_init(se_cmd, cmd->tmr_req, tcm_function);
+	rc = core_tmr_alloc_req(se_cmd, cmd->tmr_req, tcm_function, GFP_KERNEL);
+	if (rc < 0)
+		goto out;
 
-	cmd->tmr_req->se_tmr_req = &se_cmd->se_tmr_req;
+	cmd->tmr_req->se_tmr_req = se_cmd->se_tmr_req;
 
 	return cmd;
 out:
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 97f51df..bb4b763 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -301,7 +301,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_tmr *tl_tmr = NULL;
 	struct tcm_loop_tpg *tl_tpg;
-	int ret = FAILED;
+	int ret = FAILED, rc;
 	/*
 	 * Locate the tcm_loop_hba_t pointer
 	 */
@@ -342,11 +342,10 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
 				DMA_NONE, MSG_SIMPLE_TAG,
 				&tl_cmd->tl_sense_buf[0]);
-	/*
-	 * Initialize the LUN_RESET TMR
-	 */
-	core_tmr_req_init(se_cmd, tl_tmr, TMR_LUN_RESET);
 
+	rc = core_tmr_alloc_req(se_cmd, tl_tmr, TMR_LUN_RESET, GFP_KERNEL);
+	if (rc < 0)
+		goto release;
 	/*
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
@@ -362,7 +361,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * The TMR LUN_RESET has completed, check the response status and
 	 * then release allocations.
 	 */
-	ret = (se_cmd->se_tmr_req.response == TMR_FUNCTION_COMPLETE) ?
+	ret = (se_cmd->se_tmr_req->response == TMR_FUNCTION_COMPLETE) ?
 		SUCCESS : FAILED;
 release:
 	if (se_cmd)
@@ -867,7 +866,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 
 static int tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	struct se_tmr_req *se_tmr = &se_cmd->se_tmr_req;
+	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	struct tcm_loop_tmr *tl_tmr = se_tmr->fabric_tmr_ptr;
 	/*
 	 * The SCSI EH thread will be sleeping on se_tmr->tl_tmr_wait, go ahead
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c8e4e52..c5e4972 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -173,7 +173,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
-	struct se_tmr_req *se_tmr = &se_cmd->se_tmr_req;
+	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	unsigned long flags;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index eb4ea0c..18abdfe 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -40,20 +40,30 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 
-void core_tmr_req_init(
+int core_tmr_alloc_req(
 	struct se_cmd *se_cmd,
 	void *fabric_tmr_ptr,
-	u8 function)
+	u8 function,
+	gfp_t gfp_flags)
 {
-	struct se_tmr_req *tmr = &se_cmd->se_tmr_req;
+	struct se_tmr_req *tmr;
 
+	tmr = kzalloc(sizeof(struct se_tmr_req), gfp_flags);
+	if (!tmr) {
+		pr_err("Unable to allocate struct se_tmr_req\n");
+		return -ENOMEM;
+	}
+	
 	se_cmd->se_cmd_flags |= SCF_SCSI_TMR_CDB;
+	se_cmd->se_tmr_req = tmr;
 	tmr->task_cmd = se_cmd;
 	tmr->fabric_tmr_ptr = fabric_tmr_ptr;
 	tmr->function = function;
 	INIT_LIST_HEAD(&tmr->tmr_list);
+
+	return 0;
 }
-EXPORT_SYMBOL(core_tmr_req_init);
+EXPORT_SYMBOL(core_tmr_alloc_req);
 
 void core_tmr_release_req(
 	struct se_tmr_req *tmr)
@@ -62,12 +72,15 @@ void core_tmr_release_req(
 	unsigned long flags;
 
 	if (!dev) {
+		kfree(tmr);
 		return;
 	}
 
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
 	list_del(&tmr->tmr_list);
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
+
+	kfree(tmr);
 }
 
 static void core_tmr_handle_tas_abort(
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d9efb1..4988899 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1712,7 +1712,7 @@ EXPORT_SYMBOL(target_submit_cmd);
  * @fabric_context: fabric context for TMR req
  * @tm_type: Type of TM request
  *
- * Callable from all contexts.
+ * Callable from process context
  **/
 
 void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
@@ -1724,6 +1724,7 @@ void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
+	BUG_ON(in_interrupt());
 
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 			      0, DMA_NONE, MSG_SIMPLE_TAG, sense);
@@ -1731,13 +1732,19 @@ void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	/* See target_submit_cmd for commentary */
 	target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
 
-	core_tmr_req_init(se_cmd, fabric_tmr_ptr, tm_type);
+	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, GFP_KERNEL);
+	if (ret < 0) {
+		dump_stack();
+		/* FIXME XXX */
+		return;
+	}
 
 	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
 	if (ret) {
 		transport_send_check_condition_and_sense(se_cmd,
 			se_cmd->scsi_sense_reason, 0);
 		transport_generic_free_cmd(se_cmd, 0);
+		return;
 	}
 	transport_generic_handle_tmr(se_cmd);
 }
@@ -3996,7 +4003,7 @@ void transport_release_cmd(struct se_cmd *cmd)
 	BUG_ON(!cmd->se_tfo);
 
 	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-		core_tmr_release_req(&cmd->se_tmr_req);
+		core_tmr_release_req(cmd->se_tmr_req);
 	if (cmd->t_task_cdb != cmd->__t_task_cdb)
 		kfree(cmd->t_task_cdb);
 	/*
@@ -4695,7 +4702,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 static int transport_generic_do_tmr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_tmr_req *tmr = &cmd->se_tmr_req;
+	struct se_tmr_req *tmr = cmd->se_tmr_req;
 	int ret;
 
 	switch (tmr->function) {
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 938240b..1baee28 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -394,7 +394,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 int ft_queue_tm_resp(struct se_cmd *se_cmd)
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
-	struct se_tmr_req *tmr = &se_cmd->se_tmr_req;
+	struct se_tmr_req *tmr = se_cmd->se_tmr_req;
 	enum fcp_resp_rsp_codes code;
 
 	switch (tmr->response) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 30a688a..4bf3845 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -560,7 +560,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
-	struct se_tmr_req	se_tmr_req;
+	struct se_tmr_req	*se_tmr_req;
 	struct list_head	se_queue_node;
 	struct list_head	se_cmd_list;
 	struct completion	cmd_wait_comp;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index fc793c1..aefa435 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -147,7 +147,7 @@ void	target_wait_for_sess_cmds(struct se_session *, int);
 
 int	core_alua_check_nonop_delay(struct se_cmd *);
 
-void	core_tmr_req_init(struct se_cmd *, void *, u8);
+int	core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
 void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *);
-- 
1.7.2.5

