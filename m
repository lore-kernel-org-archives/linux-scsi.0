From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 9/9] target: Enable READ_STRIP emulation in target_complete_ok_work
Date: Thu,  3 Apr 2014 09:35:53 +0000
Message-ID: <1396517753-23546-10-git-send-email-nab@daterainc.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch enables the use of READ_STRIP software emulation in
target_complete_ok_work() code for I/O READs.

This is useful when the fabric does not support READ_STRIP hardware
offload, but would still like to interact with backend device
that have T10 PI enabled.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 530a9e8..a184103 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1905,6 +1905,24 @@ static void transport_handle_queue_full(
 	schedule_work(&cmd->se_dev->qf_work_queue);
 }
 
+static bool target_check_read_strip(struct se_cmd *cmd)
+{
+	sense_reason_t rc;
+
+	if (cmd->prot_op != TARGET_PROT_DIN_STRIP)
+		return false;
+
+	if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
+		rc = sbc_dif_read_strip(cmd);
+		if (rc) {
+			cmd->pi_err = rc;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void target_complete_ok_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
@@ -1969,6 +1987,21 @@ static void target_complete_ok_work(struct work_struct *work)
 					cmd->data_length;
 		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		/*
+		 * Perform READ_STRIP of PI using software emulation when
+		 * backend had PI enabled, if the transport will not be
+		 * performing hardware READ_STRIP offload.
+		 */
+		if (target_check_read_strip(cmd)) {
+			ret = transport_send_check_condition_and_sense(cmd,
+						cmd->pi_err, 0);
+			if (ret == -EAGAIN || ret == -ENOMEM)
+				goto queue_full;
+
+			transport_lun_remove_cmd(cmd);
+			transport_cmd_check_stop_to_fabric(cmd);
+			return;
+		}
 
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_data_in(cmd);
-- 
1.7.10.4
