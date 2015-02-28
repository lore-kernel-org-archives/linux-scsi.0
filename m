From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 6/9] target: Move cmd->prot_op check into target_check_read_prot
Date: Sat, 28 Feb 2015 10:36:03 +0000
Message-ID: <1425119766-11878-7-git-send-email-nab@daterainc.com>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the existing target_complete_ok_work() check for
cmd->prot_op into it's own function, so it's easier to add future
support for READ INSERT.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1b74006..3b9923f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1956,16 +1956,22 @@ static void transport_handle_queue_full(
 	schedule_work(&cmd->se_dev->qf_work_queue);
 }
 
-static bool target_check_read_strip(struct se_cmd *cmd)
+static bool target_check_read_prot(struct se_cmd *cmd)
 {
 	sense_reason_t rc;
 
-	if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
-		rc = sbc_dif_read_strip(cmd);
-		if (rc) {
-			cmd->pi_err = rc;
-			return true;
+	switch (cmd->prot_op) {
+	case TARGET_PROT_DIN_STRIP:
+		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
+			rc = sbc_dif_read_strip(cmd);
+			if (rc) {
+				cmd->pi_err = rc;
+				return true;
+			}
 		}
+		break;
+	default:
+		break;
 	}
 
 	return false;
@@ -2040,8 +2046,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		 * backend had PI enabled, if the transport will not be
 		 * performing hardware READ_STRIP offload.
 		 */
-		if (cmd->prot_op == TARGET_PROT_DIN_STRIP &&
-		    target_check_read_strip(cmd)) {
+		if (target_check_read_prot(cmd)) {
 			ret = transport_send_check_condition_and_sense(cmd,
 						cmd->pi_err, 0);
 			if (ret == -EAGAIN || ret == -ENOMEM)
-- 
1.9.1
