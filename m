From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/5] target: Fix COMPARE_AND_WRITE ref leak for non GOOD status
Date: Tue,  7 Feb 2017 13:17:50 +0000
Message-ID: <1486473470-15837-6-git-send-email-nab@linux-iscsi.org>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Donald White <dew@datera.io>, Gary Guo <ghg@datera.io>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a long standing bug where the commit phase
of COMPARE_AND_WRITE would result in a se_cmd->cmd_kref reference
leak if se_cmd->scsi_status returned non SAM_STAT_GOOD.

This would manifest first as a lost SCSI response, and eventual
hung task during fabric driver logout or re-login, as existing
shutdown logic waited for the COMPARE_AND_WRITE se_cmd->cmd_kref
to reach zero.

To address this bug, compare_and_write_post() has been changed
to drop the incorrect !cmd->scsi_status conditional that was
preventing *post_ret = 1 for being set during non SAM_STAT_GOOD
status.

This patch has been tested with SAM_STAT_CHECK_CONDITION status
from normal target_complete_cmd() callback path, as well as the
incoming __target_execute_cmd() submission failure path when
se_cmd->execute_cmd() returns non zero status.

Reported-by: Donald White <dew@datera.io>
Cc: Donald White <dew@datera.io>
Tested-by: Gary Guo <ghg@datera.io>
Cc: Gary Guo <ghg@datera.io>
Cc: <stable@vger.kernel.org> # v3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 4879e70..df7b6e9 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -451,6 +451,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 					     int *post_ret)
 {
 	struct se_device *dev = cmd->se_dev;
+	sense_reason_t ret = TCM_NO_SENSE;
 
 	/*
 	 * Only set SCF_COMPARE_AND_WRITE_POST to force a response fall-through
@@ -458,9 +459,12 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	 * sent to the backend driver.
 	 */
 	spin_lock_irq(&cmd->t_state_lock);
-	if ((cmd->transport_state & CMD_T_SENT) && !cmd->scsi_status) {
+	if (cmd->transport_state & CMD_T_SENT) {
 		cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
 		*post_ret = 1;
+
+		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
+			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	spin_unlock_irq(&cmd->t_state_lock);
 
@@ -470,7 +474,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	 */
 	up(&dev->caw_sem);
 
-	return TCM_NO_SENSE;
+	return ret;
 }
 
 static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool success,
-- 
1.9.1
