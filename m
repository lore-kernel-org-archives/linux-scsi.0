From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 13/25] tcm_qla2xxx: Do not allow aborted cmd to advance.
Date: Fri, 19 May 2017 14:53:32 -0700
Message-ID: <20170519215344.2168-14-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:21419
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756672AbdESVyM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:12 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

In case of hardware queue full, commands can loop between
TCM stack and tcm_qla2xx shim layers for retry. While command
is waiting for retry, task mgmt can get ahead and abort the
cmmand that encountered queue full condition. Fix this by
dropping the command, if task mgmt has already started the
command free process.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7443e4efa3ae..07f8ad001bcb 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -686,6 +686,20 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 				struct qla_tgt_cmd, se_cmd);
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
+	if (cmd->aborted) {
+		/*
+		 * Cmd can loop during Q-full. tcm_qla2xxx_aborted_task
+		 * can get ahead of this cmd. tcm_qla2xxx_aborted_task
+		 * already kick start the free.
+		 */
+		pr_debug(
+		    "queue_data_in aborted cmd[%p] refcount %d transport_state %x, t_state %x, se_cmd_flags %x\n",
+		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
+		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
+		    cmd->se_cmd.se_cmd_flags);
+		return 0;
+	}
+
 	cmd->bufflen = se_cmd->data_length;
 	cmd->sg = NULL;
 	cmd->sg_cnt = 0;
-- 
2.12.0
