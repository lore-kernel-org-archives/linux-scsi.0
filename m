From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] tcm_fc: Convert to use pre-allocated struct se_cmd descriptors
Date: Fri, 10 Sep 2010 02:27:03 -0700
Message-ID: <1284110823-384-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:40904 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751345Ab0IJJ1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 05:27:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joe Eykholt <jeykholt@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the Open-FCoE.org / TCM_FC fabric module to use pre-allocated
struct se_cmd descriptors and sense data buffer located at struct ft_cmd->se_cmd
and struct ft_cmd->ft_sense_buffer respectively.

This includes updating ft_send_cmd() to use transport_init_se_cmd() for the main
FCoE CDB RX side entry point.  It also includes the conversion of a number of
functions to use container_of() instead of struct se_cmd->se_fabric_cmd_ptr to
locate the struct ft_cmd, and the addition of the assignment operator when
accessing struct ft_cmd->se_cmd within per I/O context operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tcm_fc.h  |    3 +-
 drivers/target/tcm_fc/tfc_cmd.c |   59 ++++++++++++++++++--------------------
 drivers/target/tcm_fc/tfc_io.c  |    4 +-
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 8d59800..210c33e 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -147,11 +147,12 @@ struct ft_cmd {
 	u16 lun;			/* LUN from request */
 	struct ft_sess *sess;		/* session held for cmd */
 	struct fc_seq *seq;		/* sequence in exchange mgr */
-	struct se_cmd *se_cmd;
+	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
 	struct fc_frame *req_frame;
 	unsigned char *cdb;		/* pointer to CDB inside frame */
 	u32 write_data_len;		/* data received on writes */
 	struct se_queue_req se_req;
+	unsigned char ft_sense_buffer[TRANSPORT_SENSE_BUFFER]; /* Local sense buffer */
 };
 
 extern struct list_head ft_lport_list;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 7c3340e..a3a3e78 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -64,7 +64,7 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	if (!(ft_debug_logging & FT_DEBUG_IO))
 		return;
 
-	se_cmd = cmd->se_cmd;
+	se_cmd = &cmd->se_cmd;
 	printk(KERN_INFO "%s: cmd %p state %d sess %p seq %p se_cmd %p\n",
 		caller, cmd, cmd->state, cmd->sess, cmd->seq, se_cmd);
 	printk(KERN_INFO "%s: cmd %p cdb %p\n",
@@ -113,7 +113,7 @@ static int ft_get_lun_for_cmd(struct ft_cmd *cmd, u8 *lunp)
 	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return -1;
 	cmd->lun = lun;
-	return transport_get_lun_for_cmd(cmd->se_cmd, NULL, lun);
+	return transport_get_lun_for_cmd(&cmd->se_cmd, NULL, lun);
 }
 
 static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
@@ -164,7 +164,7 @@ static void ft_free_cmd(struct ft_cmd *cmd)
 
 void ft_release_cmd(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
 	ft_free_cmd(cmd);
 }
@@ -179,7 +179,7 @@ void ft_check_stop_free(struct se_cmd *se_cmd)
  */
 int ft_queue_status(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 	struct fc_frame *fp;
 	struct fcp_resp_with_ext *fcp;
 	struct fc_lport *lport;
@@ -232,7 +232,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
 
 int ft_write_pending_status(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
 	return cmd->write_data_len != se_cmd->data_length;
 }
@@ -242,7 +242,7 @@ int ft_write_pending_status(struct se_cmd *se_cmd)
  */
 int ft_write_pending(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 	struct fc_frame *fp;
 	struct fcp_txrdy *txrdy;
 	struct fc_lport *lport;
@@ -270,14 +270,14 @@ int ft_write_pending(struct se_cmd *se_cmd)
 
 u32 ft_get_task_tag(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
 	return fc_seq_exch(cmd->seq)->rxid;
 }
 
 int ft_get_cmd_state(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
 	return cmd->state;
 }
@@ -303,9 +303,9 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 	if (IS_ERR(fp)) {
 		/* XXX need to find cmd if queued */
-		cmd->se_cmd->t_state = TRANSPORT_REMOVE;
+		cmd->se_cmd.t_state = TRANSPORT_REMOVE;
 		cmd->seq = NULL;
-		transport_generic_free_cmd(cmd->se_cmd, 0, 1, 0);
+		transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
 		return;
 	}
 
@@ -322,7 +322,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		printk(KERN_INFO "%s: unhandled frame r_ctl %x\n",
 		       __func__, fh->fh_r_ctl);
 		fc_frame_free(fp);
-		transport_generic_free_cmd(cmd->se_cmd, 0, 1, 0);
+		transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
 		break;
 	}
 }
@@ -397,8 +397,8 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		tm_func = LUN_RESET;
 		if (ft_get_lun_for_cmd(cmd, fcp->fc_lun) < 0) {
 			ft_dump_cmd(cmd, __func__);
-			transport_send_check_condition_and_sense(cmd->se_cmd,
-				cmd->se_cmd->scsi_sense_reason, 0);
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
+				cmd->se_cmd.scsi_sense_reason, 0);
 			ft_sess_put(cmd->sess);
 			return;
 		}
@@ -426,14 +426,14 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	}
 
 	FT_TM_DBG("alloc tm cmd fn %d\n", tm_func);
-	tmr = core_tmr_alloc_req(cmd->se_cmd, cmd, tm_func);
+	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func);
 	if (!tmr) {
 		FT_TM_DBG("alloc failed\n");
 		ft_send_resp_code(cmd, FCP_TMF_FAILED);
 		return;
 	}
-	cmd->se_cmd->se_tmr_req = tmr;
-	transport_generic_handle_tmr(cmd->se_cmd);
+	cmd->se_cmd.se_tmr_req = tmr;
+	transport_generic_handle_tmr(&cmd->se_cmd);
 }
 
 /*
@@ -441,7 +441,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
  */
 int ft_queue_tm_resp(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 	struct se_tmr_req *tmr = se_cmd->se_tmr_req;
 	enum fcp_resp_rsp_codes code;
 
@@ -570,18 +570,15 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 		cmd->cdb = fcp->fc_cdb;
 	}
 
-	se_cmd = transport_alloc_se_cmd(&ft_configfs->tf_ops,
-					cmd->sess->se_sess, cmd, data_len,
-					data_dir, task_attr);
-	if (!se_cmd) {
-		FT_IO_DBG("se_cmd allocation failure - sending BUSY\n");
-		ft_send_resp_status(cmd->sess->tport->lport, cmd->req_frame,
-				    SAM_STAT_BUSY, 0);
-		ft_free_cmd(cmd);
-		return;
-	}
-	cmd->se_cmd = se_cmd;
-
+	se_cmd = &cmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
+	 */
+	transport_init_se_cmd(se_cmd, &ft_configfs->tf_ops, cmd->sess->se_sess,
+			data_len, data_dir, task_attr, &cmd->ft_sense_buffer[0]);
+	/*
+	 * Check for FCP task management flags
+	 */
 	if (fcp->fc_tm_flags) {
 		ft_send_tm(cmd);
 		return;
@@ -592,8 +589,8 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 	ret = ft_get_lun_for_cmd(cmd, fcp->fc_lun);
 	if (ret < 0) {
 		ft_dump_cmd(cmd, __func__);
-		transport_send_check_condition_and_sense(cmd->se_cmd,
-			cmd->se_cmd->scsi_sense_reason, 0);
+		transport_send_check_condition_and_sense(&cmd->se_cmd,
+			cmd->se_cmd.scsi_sense_reason, 0);
 		return;
 	}
 
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index f473782..2080891 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -64,7 +64,7 @@
  */
 int ft_queue_data_in(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = se_cmd->se_fabric_cmd_ptr;
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 	struct se_transport_task *task;
 	struct fc_frame *fp = NULL;
 	struct fc_exch *ep;
@@ -187,7 +187,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
  */
 void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 {
-	struct se_cmd *se_cmd = cmd->se_cmd;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct se_transport_task *task;
 	struct fc_frame_header *fh;
 	struct se_mem *mem;
-- 
1.5.6.5

