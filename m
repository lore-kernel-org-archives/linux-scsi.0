From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Fix compare_and_write_callback handling for non GOOD status
Date: Wed,  3 May 2017 06:13:34 +0000
Message-ID: <1493792016-6435-2-git-send-email-nab@linux-iscsi.org>
References: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Gary Guo <ghg@datera.io>, Bill Borsari <wgb@datera.io>, Raghu Krishnamurthy <rk@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Following the bugfix for handling non SAM_STAT_GOOD COMPARE_AND_WRITE
status during COMMIT phase in commit 9b2792c3da1, the same bug exists
for the READ phase as well.

This would manifest first as a lost SCSI response, and eventual
hung task during fabric driver logout or re-login, as existing
shutdown logic waited for the COMPARE_AND_WRITE se_cmd->cmd_kref
to reach zero.

To address this bug, compare_and_write_callback() has been changed
to set post_ret = 1 and return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE
as necessary to signal failure status.

Reported-by: Bill Borsari <wgb@datera.io>
Cc: Bill Borsari <wgb@datera.io>
Tested-by: Gary Guo <ghg@datera.io>
Cc: Gary Guo <ghg@datera.io>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index f9250b3..a0ad618 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -507,8 +507,11 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * been failed with a non-zero SCSI status.
 	 */
 	if (cmd->scsi_status) {
-		pr_err("compare_and_write_callback: non zero scsi_status:"
+		pr_debug("compare_and_write_callback: non zero scsi_status:"
 			" 0x%02x\n", cmd->scsi_status);
+		*post_ret = 1;
+		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
+			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
 	}
 
-- 
1.9.1
