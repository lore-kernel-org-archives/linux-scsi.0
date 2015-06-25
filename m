From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 04/11] qla2xxx: Abort stale cmds on qla_tgt_wq when plogi arrives
Date: Thu, 25 Jun 2015 12:33:44 -0400
Message-ID: <1435250031-20525-5-git-send-email-himanshu.madhani@qlogic.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:61094 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbbFYRSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 13:18:09 -0400
In-Reply-To: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

cancel any commands from initiator's s_id that are still waiting
on qla_tgt_wq when PLOGI arrives.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Acked-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 34f7f4d..74afe92 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4068,6 +4068,38 @@ qlt_find_sess_invalidate_other(struct qla_tgt *tgt, uint64_t wwn,
 	return sess;
 }
 
+/* Abort any commands for this s_id waiting on qla_tgt_wq workqueue */
+static int abort_cmds_for_s_id(struct scsi_qla_host *vha, port_id_t *s_id)
+{
+	struct qla_tgt_sess_op *op;
+	struct qla_tgt_cmd *cmd;
+	uint32_t key;
+	int count = 0;
+
+	key = (((u32)s_id->b.domain << 16) |
+	       ((u32)s_id->b.area   <<  8) |
+	       ((u32)s_id->b.al_pa));
+
+	spin_lock(&vha->cmd_list_lock);
+	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
+		uint32_t op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
+		if (op_key == key) {
+			op->aborted = true;
+			count++;
+		}
+	}
+	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
+		uint32_t cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
+		if (cmd_key == key) {
+			cmd->state = QLA_TGT_STATE_ABORTED;
+			count++;
+		}
+	}
+	spin_unlock(&vha->cmd_list_lock);
+
+	return count;
+}
+
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
@@ -4101,6 +4133,9 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	switch (iocb->u.isp24.status_subcode) {
 	case ELS_PLOGI:
 
+		/* Mark all stale commands in qla_tgt_wq for deletion */
+		abort_cmds_for_s_id(vha, &port_id);
+
 		if (wwn)
 			sess = qlt_find_sess_invalidate_other(tgt, wwn,
 			    port_id, loop_id);
-- 
1.7.7

