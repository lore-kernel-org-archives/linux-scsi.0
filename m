From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Fix delayed Task Aborted Status (TAS) handling bug
Date: Wed, 13 Nov 2013 22:27:50 +0000
Message-ID: <1384381670-23670-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47374 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KMWqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2013 17:46:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in delayed Task Aborted Status (TAS) handling,
where transport_send_task_abort() was not returning for the case
when the se_tfo->write_pending() callback indicated that last fabric
specific WRITE PDU had not yet been received.

It also adds an explicit cmd->scsi_status = SAM_STAT_TASK_ABORTED
assignment within transport_check_aborted_status() to avoid the case
where se_tfo->queue_status() is called when the SAM_STAT_TASK_ABORTED
assignment + ->queue_status() in transport_send_task_abort() does not
occur once SCF_SENT_DELAYED_TAS has been set.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 71f79f6..46d8229 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2682,6 +2682,7 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 		 cmd->t_task_cdb[0], cmd->se_tfo->get_task_tag(cmd));
 
 	cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
+	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 	trace_target_cmd_complete(cmd);
 	cmd->se_tfo->queue_status(cmd);
 
@@ -2710,6 +2711,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			cmd->transport_state |= CMD_T_ABORTED;
 			smp_mb__after_atomic_inc();
+			return;
 		}
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-- 
1.7.10.4

