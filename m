From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] Revert "target: Fix residual overflow handling in target_complete_cmd_with_length"
Date: Tue, 18 Oct 2016 04:54:37 +0000
Message-ID: <1476766477-11595-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Rai <sumitrai96@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This reverts commit c1ccbfe0311e2380a6d2dcb0714b36904f5d586f.

Reverting this patch, as it incorrectly assumes the additional length
for INQUIRY in target_complete_cmd_with_length() is SCSI allocation
length, which breaks existing user-space code when SCSI allocation
length is smaller than additional length.

  root@scsi-mq:~# sg_inq --len=4 -vvvv /dev/sdb
  found bsg_major=253
  open /dev/sdb with flags=0x800
      inquiry cdb: 12 00 00 00 04 00
        duration=0 ms
      inquiry: pass-through requested 4 bytes (data-in) but got -28 bytes
      inquiry: pass-through can't get negative bytes, say it got none
      inquiry: got too few bytes (0)
  INQUIRY resid (32) should never exceed requested len=4
      inquiry: failed requesting 4 byte response: Malformed response to
               SCSI command [resid=32]

AFAICT the original change was not to address a specific host issue,
so go ahead and revert to original logic for now.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sumit Rai <sumitrai96@gmail.com>
Cc: stable@vger.kernel.org # 4.8+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 000bc6d..e825d58 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -754,15 +754,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
 {
-	if (scsi_status != SAM_STAT_GOOD) {
-		return;
-	}
-
-	/*
-	 * Calculate new residual count based upon length of SCSI data
-	 * transferred.
-	 */
-	if (length < cmd->data_length) {
+	if (scsi_status == SAM_STAT_GOOD && length < cmd->data_length) {
 		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			cmd->residual_count += cmd->data_length - length;
 		} else {
@@ -771,12 +763,6 @@ void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int len
 		}
 
 		cmd->data_length = length;
-	} else if (length > cmd->data_length) {
-		cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
-		cmd->residual_count = length - cmd->data_length;
-	} else {
-		cmd->se_cmd_flags &= ~(SCF_OVERFLOW_BIT | SCF_UNDERFLOW_BIT);
-		cmd->residual_count = 0;
 	}
 
 	target_complete_cmd(cmd, scsi_status);
-- 
1.9.1
