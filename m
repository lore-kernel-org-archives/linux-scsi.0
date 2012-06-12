From: Roland Dreier <roland@kernel.org>
Subject: [NOT A REAL PATCH] deal with adapter resets in qla_target code
Date: Mon, 11 Jun 2012 18:41:43 -0700
Message-ID: <1339465303-26289-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi guys, here's one more patch (which is against our mongrel internal
tree and so I'm sure won't apply upstream), mainly here to provoke the
QLogic guys to tell me the right way to fix this.

The problem is that if we hit a FW crash or anything that causes us to
do an ISP abort with CTIOs for target commands in flight, the target
code will eventually wait forever for the CTIOs to complete.  And of
course any CTIOs that are in the request ring when we reset the
hardware will never come back.

The symptom here will be that we'll try to free a target session and
end up stuck waiting for the session command list to drain, and this
will cause hung task warnings (and possibly panics if you have
panic-on-hung-task set).

To fix this, I added a somewhat ugly call from the core qla2xxx code
into the target code, just before we bring the adapter back online.
In this hook in qla_target, I go through the set of pending target
commands and forcibly fail them.

I'd be happy to merge properly upstream, but not sure if this is
viewed as the best way forward...

NOT-Signed-off-by: Roland Dreier <roland@purestorage.com>

--- linux-2.6.git.orig/drivers/scsi/qla2xxx/qla_init.c
+++ linux-2.6.git/drivers/scsi/qla2xxx/qla_init.c
@@ -4306,15 +4306,20 @@ qla2x00_restart_isp(scsi_qla_host_t *vha
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
 
+			lock_hardware(ha, &flags);
+
 			vha->flags.online = 1;
 
+			if (vha->hw->tgt_ops)
+				qla_tgt_flush_ctio(vha);
+
 			/*
 			 * Process any ATIO queue entries that came in
 			 * while we weren't online.
 			 */
-			lock_hardware(ha, &flags);
 			if (qla_tgt_mode_enabled(vha))
 				qla_tgt_24xx_process_atio_queue(vha);
+
 			unlock_hardware(ha, &flags);
 
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
--- linux-2.6.git.orig/drivers/scsi/qla2xxx/qla_target.c
+++ linux-2.6.git/drivers/scsi/qla2xxx/qla_target.c
@@ -2397,6 +2397,42 @@ void qla_tgt_ctio_completion(struct scsi
 	tgt->irq_cmd_count--;
 }
 
+void qla_tgt_flush_ctio(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_tgt_cmd *cmd;
+	uint32_t h;
+
+	assert_hardware_locked(ha);
+
+	for (h = 0; h < MAX_OUTSTANDING_COMMANDS; ++h) {
+		cmd = ha->cmds[h];
+
+		if (cmd) {
+			if (cmd->sg_mapped)
+				qla_tgt_unmap_sg(vha, cmd);
+
+			switch (cmd->state) {
+			case QLA_TGT_STATE_PROCESSED:
+				vha->hw->tgt_ops->free_cmd(cmd);
+				break;
+
+			case QLA_TGT_STATE_NEED_DATA:
+				cmd->write_data_transferred = 0;
+				vha->hw->tgt_ops->handle_data(cmd);
+				break;
+
+			default:
+				dev_info(&ha->pdev->dev, "pending cmd %p in state %d\n",
+					 cmd, cmd->state);
+				break;
+			}
+
+			ha->cmds[h] = NULL;
+		}
+	}
+}
+
 static inline int qla_tgt_get_fcp_task_attr(uint8_t task_codes)
 {
 	int fcp_task_attr;
--- linux-2.6.git.orig/drivers/scsi/qla2xxx/qla_target.h
+++ linux-2.6.git/drivers/scsi/qla2xxx/qla_target.h
@@ -970,6 +970,7 @@ extern void qla_tgt_free_mcmd(struct qla
 extern void qla_tgt_free_cmd(struct qla_tgt_cmd *cmd);
 extern void qla_tgt_dump_error_ctio(struct scsi_qla_host *vha, uint32_t handle, void *ctio);
 extern void qla_tgt_ctio_completion(struct scsi_qla_host *, uint32_t);
+extern void qla_tgt_flush_ctio(scsi_qla_host_t *vha);
 extern void qla_tgt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qla_tgt_enable_vha(struct scsi_qla_host *);
 extern void qla_tgt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
