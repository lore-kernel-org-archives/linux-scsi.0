From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] iscsi-target: Fix TMR reference leak during session shutdown
Date: Thu, 30 Mar 2017 08:29:53 +0000
Message-ID: <1490862594-2712-2-git-send-email-nab@linux-iscsi.org>
References: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47721 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752333AbdC3IaB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 04:30:01 -0400
In-Reply-To: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Rob Millner <rlm@daterainc.com>, Chu Yuan Lin <cyl@datera.io>, James Shen <jcs@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a iscsi-target specific TMR reference leak
during session shutdown, that could occur when a TMR was
quiesced before the hand-off back to iscsi-target code
via transport_cmd_check_stop_to_fabric().

The reference leak happens because iscsit_free_cmd() was
incorrectly skipping the final target_put_sess_cmd() for
TMRs when transport_generic_free_cmd() returned zero because
the se_cmd->cmd_kref did not reach zero, due to the missing
se_cmd assignment in original code.

The result was iscsi_cmd and it's associated se_cmd memory
would be freed once se_sess->sess_cmd_map where released,
but the associated se_tmr_req was leaked and remained part
of se_device->dev_tmr_list.

This bug would manfiest itself as kernel paging request
OOPsen in core_tmr_lun_reset(), when a left-over se_tmr_req
attempted to dereference it's se_cmd pointer that had
already been released during normal session shutdown.

To address this bug, go ahead and treat ISCSI_OP_SCSI_CMD
and ISCSI_OP_SCSI_TMFUNC the same when there is an extra
se_cmd->cmd_kref to drop in iscsit_free_cmd(), and use
op_scsi to signal __iscsit_free_cmd() when the former
needs to clear any further iscsi related I/O state.

Reported-by: Rob Millner <rlm@daterainc.com>
Cc: Rob Millner <rlm@daterainc.com>
Reported-by: Chu Yuan Lin <cyl@datera.io>
Cc: Chu Yuan Lin <cyl@datera.io>
Tested-by: Chu Yuan Lin <cyl@datera.io>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5041a9c..b464033 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -737,21 +737,23 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 {
 	struct se_cmd *se_cmd = NULL;
 	int rc;
+	bool op_scsi = false;
 	/*
 	 * Determine if a struct se_cmd is associated with
 	 * this struct iscsi_cmd.
 	 */
 	switch (cmd->iscsi_opcode) {
 	case ISCSI_OP_SCSI_CMD:
-		se_cmd = &cmd->se_cmd;
-		__iscsit_free_cmd(cmd, true, shutdown);
+		op_scsi = true;
 		/*
 		 * Fallthrough
 		 */
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = transport_generic_free_cmd(&cmd->se_cmd, shutdown);
-		if (!rc && shutdown && se_cmd && se_cmd->se_sess) {
-			__iscsit_free_cmd(cmd, true, shutdown);
+		se_cmd = &cmd->se_cmd;
+		__iscsit_free_cmd(cmd, op_scsi, shutdown);
+		rc = transport_generic_free_cmd(se_cmd, shutdown);
+		if (!rc && shutdown && se_cmd->se_sess) {
+			__iscsit_free_cmd(cmd, op_scsi, shutdown);
 			target_put_sess_cmd(se_cmd);
 		}
 		break;
-- 
1.9.1
