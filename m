From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/4] qla2xxx: Look up LUN for abort requests
Date: Fri, 16 Nov 2012 08:06:17 -0800
Message-ID: <1353081979-29474-3-git-send-email-roland@kernel.org>
References: <1353081979-29474-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353081979-29474-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Steve Hodgson <steve@purestorage.com>

Search through the list of pending commands on the session list to find
the command the initiator is actually aborting, so that we can pass the
correct LUN to the core TMR handling code.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 62aa558..79fbdd7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1264,9 +1264,26 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
+	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
+	struct se_cmd *se_cmd;
+	u32 lun = 0;
 	int rc;
 
+	spin_lock(&se_sess->sess_cmd_lock);
+	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
+		struct qla_tgt_cmd *cmd =
+			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+		if (cmd->tag == abts->exchange_addr_to_abort) {
+			lun = cmd->unpacked_lun;
+			break;
+		}
+	}
+	spin_unlock(&se_sess->sess_cmd_lock);
+
+	if (!lun)
+		return -ENOENT;
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
 	    vha->vp_idx, abts->exchange_addr_to_abort);
@@ -1283,7 +1300,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, TMR_ABORT_TASK,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
-- 
1.7.10.4
