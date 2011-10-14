From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 06/37] target: Prevent transport_send_task_abort when CHECK_CONDITION status
Date: Fri, 14 Oct 2011 00:41:38 +0000
Message-ID: <1318552929-13341-7-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug where transport_send_task_abort() could be called
during LUN_RESET to return SAM_STAT_TASK_ABORTED + tfo->queue_status(), when
SCF_SENT_CHECK_CONDITION -> tfo->queue_status() has already been sent from
within another context via transport_send_check_condition_and_sense().

Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
---
 drivers/target/target_core_transport.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 009547b..af1e0a5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4919,6 +4919,15 @@ EXPORT_SYMBOL(transport_check_aborted_status);
 
 void transport_send_task_abort(struct se_cmd *cmd)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
 	/*
 	 * If there are still expected incoming fabric WRITEs, we wait
 	 * until until they have completed before sending a TASK_ABORTED
-- 
1.5.6.5
