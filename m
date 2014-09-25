From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 09/19] qla2xxx: Add Host reset handling in target mode.
Date: Thu, 25 Sep 2014 04:10:02 -0400
Message-ID: <1411632612-7320-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2528 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbaIYIoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:19 -0400
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |    1 +
 drivers/scsi/qla2xxx/qla_os.c     |    2 +
 drivers/scsi/qla2xxx/qla_target.c |   74 +++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f3b6570..09b335e 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -68,7 +68,7 @@
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
  * | Target Mode		  |	  0xe078       |		|
- * | Target Mode Management	  |	  0xf072       | 0xf002-0xf003	|
+ * | Target Mode Management	  |	  0xf072       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000b      |		|
  * ----------------------------------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index cc9e088..8257a27 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -765,4 +765,5 @@ extern void qla82xx_mbx_completion(scsi_qla_host_t *, uint16_t);
 extern int qla8044_abort_isp(scsi_qla_host_t *);
 extern int qla8044_check_fw_alive(struct scsi_qla_host *);
 
+extern void qlt_host_reset_handler(struct qla_hw_data *ha);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 70445bc..437dc90 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1362,6 +1362,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 
+	qlt_host_reset_handler(ha);
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (que = 0; que < ha->max_req_queues; que++) {
 		req = ha->req_q_map[que];
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4989bf7..edd9d1b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2838,6 +2838,80 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 	return cmd;
 }
 
+/* hardware_lock should be held by caller. */
+static void
+qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t handle;
+
+	if (cmd->sg_mapped)
+		qlt_unmap_sg(vha, cmd);
+
+	handle = qlt_make_handle(vha);
+
+	/* TODO: fix debug message type and ids. */
+	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
+		ql_dbg(ql_dbg_io, vha, 0xff00,
+		    "HOST-ABORT: handle=%d, state=PROCESSED.\n", handle);
+	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
+		cmd->write_data_transferred = 0;
+		cmd->state = QLA_TGT_STATE_DATA_IN;
+
+		ql_dbg(ql_dbg_io, vha, 0xff01,
+		    "HOST-ABORT: handle=%d, state=DATA_IN.\n", handle);
+
+		ha->tgt.tgt_ops->handle_data(cmd);
+		return;
+	} else if (cmd->state == QLA_TGT_STATE_ABORTED) {
+		ql_dbg(ql_dbg_io, vha, 0xff02,
+		    "HOST-ABORT: handle=%d, state=ABORTED.\n", handle);
+	} else {
+		ql_dbg(ql_dbg_io, vha, 0xff03,
+		    "HOST-ABORT: handle=%d, state=BAD(%d).\n", handle,
+		    cmd->state);
+		dump_stack();
+	}
+
+	ha->tgt.tgt_ops->free_cmd(cmd);
+}
+
+void
+qlt_host_reset_handler(struct qla_hw_data *ha)
+{
+	struct qla_tgt_cmd *cmd;
+	unsigned long flags;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+	scsi_qla_host_t *vha = NULL;
+	struct qla_tgt *tgt = base_vha->vha_tgt.qla_tgt;
+	uint32_t i;
+
+	if (!base_vha->hw->tgt.tgt_ops)
+		return;
+
+	if (!tgt || qla_ini_mode_enabled(base_vha)) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf003,
+			"Target mode disabled\n");
+		return;
+	}
+
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xff10,
+	    "HOST-ABORT-HNDLR: base_vha->dpc_flags=%lx.\n",
+	    base_vha->dpc_flags);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (i = 1; i < DEFAULT_OUTSTANDING_COMMANDS + 1; i++) {
+		cmd = qlt_get_cmd(base_vha, i);
+		if (!cmd)
+			continue;
+		/* ha->tgt.cmds entry is cleared by qlt_get_cmd. */
+		vha = cmd->vha;
+		qlt_abort_cmd_on_host_reset(vha, cmd);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
-- 
1.7.7

