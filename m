From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 4/4] target: Clean up flow in transport_check_aborted_status()
Date: Fri, 16 Nov 2012 08:06:19 -0800
Message-ID: <1353081979-29474-5-git-send-email-roland@kernel.org>
References: <1353081979-29474-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:38277 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752255Ab2KPQGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2012 11:06:31 -0500
Received: by mail-pa0-f70.google.com with SMTP id fb10so5129259pad.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Nov 2012 08:06:30 -0800 (PST)
In-Reply-To: <1353081979-29474-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0f29d70..f225f90 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3042,23 +3042,19 @@ EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
 int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 {
-	int ret = 0;
+	if (!(cmd->transport_state & CMD_T_ABORTED))
+		return 0;
 
-	if (cmd->transport_state & CMD_T_ABORTED) {
-		if (!send_status ||
-		     (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
-			return 1;
+	if (!send_status || (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
+		return 1;
 
-		pr_debug("Sending delayed SAM_STAT_TASK_ABORTED"
-			" status for CDB: 0x%02x ITT: 0x%08x\n",
-			cmd->t_task_cdb[0],
-			cmd->se_tfo->get_task_tag(cmd));
+	pr_debug("Sending delayed SAM_STAT_TASK_ABORTED status for CDB: 0x%02x ITT: 0x%08x\n",
+		 cmd->t_task_cdb[0], cmd->se_tfo->get_task_tag(cmd));
 
-		cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
-		cmd->se_tfo->queue_status(cmd);
-		ret = 1;
-	}
-	return ret;
+	cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
+	cmd->se_tfo->queue_status(cmd);
+
+	return 1;
 }
 EXPORT_SYMBOL(transport_check_aborted_status);
 
-- 
1.7.10.4

