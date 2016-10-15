From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] target: Don't override EXTENDED_COPY xcopy_pt_cmd SCSI status code
Date: Sat, 15 Oct 2016 05:34:32 +0000
Message-ID: <1476509672-27182-4-git-send-email-nab@linux-iscsi.org>
References: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Vaibhav Tandon <vst@datera.io>, Dinesh Israni <ddi@datera.io>, Nixon Vincent <nixon.vincent@calsoftinc.com>
List-Id: linux-scsi@vger.kernel.org

From: Dinesh Israni <ddi@datera.io>

This patch addresses a bug where a local EXTENDED_COPY WRITE or READ
backend I/O request would always return SAM_STAT_CHECK_CONDITION,
even if underlying xcopy_pt_cmd->se_cmd generated a different
SCSI status code.

ESX host environments expect to hit SAM_STAT_RESERVATION_CONFLICT
for certain scenarios, and SAM_STAT_CHECK_CONDITION results in
non-retriable status for these cases.

Tested on v4.1.y with ESX v5.5u2+ with local IBLOCK backend copy.

Reported-by: Nixon Vincent <nixon.vincent@calsoftinc.com>
Tested-by: Nixon Vincent <nixon.vincent@calsoftinc.com>
Cc: Nixon Vincent <nixon.vincent@calsoftinc.com>
Tested-by: Dinesh Israni <ddi@datera.io>
Signed-off-by: Dinesh Israni <ddi@datera.io>
Cc: Dinesh Israni <ddi@datera.io>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index f2a1443..094a144 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -662,6 +662,7 @@ static int target_xcopy_read_source(
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port, true);
 	if (rc < 0) {
+		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
 	}
@@ -673,6 +674,7 @@ static int target_xcopy_read_source(
 
 	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
 	if (rc < 0) {
+		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
 	}
@@ -723,6 +725,7 @@ static int target_xcopy_write_destination(
 				remote_port, false);
 	if (rc < 0) {
 		struct se_cmd *src_cmd = &xop->src_pt_cmd->se_cmd;
+		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
 		/*
 		 * If the failure happened before the t_mem_list hand-off in
 		 * target_xcopy_setup_pt_cmd(), Reset memory + clear flag so that
@@ -738,6 +741,7 @@ static int target_xcopy_write_destination(
 
 	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
 	if (rc < 0) {
+		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
 		se_cmd->se_cmd_flags &= ~SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
@@ -824,10 +828,14 @@ static void target_xcopy_do_work(struct work_struct *work)
 out:
 	xcopy_pt_undepend_remotedev(xop);
 	kfree(xop);
-
-	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, Setting X-COPY CHECK_CONDITION"
-			    " -> sending response\n", rc);
-	ec_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+	/*
+	 * Don't override an error scsi status if it has already been set
+	 */
+	if (ec_cmd->scsi_status == SAM_STAT_GOOD) {
+		pr_warn_ratelimited("target_xcopy_do_work: rc: %d, Setting X-COPY"
+			" CHECK_CONDITION -> sending response\n", rc);
+		ec_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+	}
 	target_complete_cmd(ec_cmd, SAM_STAT_CHECK_CONDITION);
 }
 
-- 
1.9.1
