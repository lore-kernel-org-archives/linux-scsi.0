From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/3] target: Fix recursive COMPARE_AND_WRITE callback failure
Date: Wed,  2 Oct 2013 00:13:15 +0000
Message-ID: <1380672796-437-3-git-send-email-nab@daterainc.com>
References: <1380672796-437-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1380672796-437-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug when compare_and_write_callback() invoked from
target_complete_ok_work() hits an failure from __target_execute_cmd() ->
cmd->execute_cmd(), that ends up calling transport_generic_request_failure()
-> compare_and_write_post(), thus causing SCF_COMPARE_AND_WRITE_POST to
incorrectly be set.

The result of this bug is that target_complete_ok_work() no longer hits
the if (!rc && !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST) check
that forces an immediate return, and instead double completes the se_cmd
in question, triggering an OOPs in the process.

This patch changes compare_and_write_post() to only set this bit when a
failure has not already occured to ensure the immediate return from within
target_complete_ok_work(), and thus allow transport_generic_request_failure()
to handle the sending of the CHECK_CONDITION exception status.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a9dca11..1393d0e 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -349,7 +349,16 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
-	cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
+	/*
+	 * Only set SCF_COMPARE_AND_WRITE_POST to force a response fall-through
+	 * within target_complete_ok_work() if the command was successfully
+	 * sent to the backend driver.
+	 */
+	spin_lock_irq(&cmd->t_state_lock);
+	if ((cmd->transport_state & CMD_T_SENT) && !cmd->scsi_status)
+		cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
+	spin_unlock_irq(&cmd->t_state_lock);
+
 	/*
 	 * Unlock ->caw_sem originally obtained during sbc_compare_and_write()
 	 * before the original READ I/O submission.
-- 
1.8.4.rc3
