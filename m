From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/6] iscsi-target: Make TASK_REASSIGN use proper se_cmd->cmd_kref
Date: Wed,  8 Nov 2017 04:31:51 +0000
Message-ID: <1510115512-15617-6-git-send-email-nab@linux-iscsi.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54050 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdKHEVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 23:21:40 -0500
In-Reply-To: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Donald White <dew@datera.io>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Since commit 59b6986dbf fixed a potential NULL pointer dereference
by allocating a se_tmr_req for ISCSI_TM_FUNC_TASK_REASSIGN, the
se_tmr_req is currently leaked by iscsit_free_cmd() because no
iscsi_cmd->se_cmd.se_tfo was associated.

To address this, treat ISCSI_TM_FUNC_TASK_REASSIGN like any other
TMR and call transport_init_se_cmd() + target_get_sess_cmd() to
setup iscsi_cmd->se_cmd.se_tfo with se_cmd->cmd_kref of 2.

This will ensure normal release operation once se_cmd->cmd_kref
reaches zero and target_release_cmd_kref() is invoked, se_tmr_req
will be released via existing target_free_cmd_mem() and
core_tmr_release_req() code.

Reported-by: Donald White <dew@datera.io>
Cc: Donald White <dew@datera.io>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 541f66a..048d422 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1955,7 +1955,6 @@ static enum tcm_tmreq_table iscsit_convert_tmf(u8 iscsi_tmf)
 	struct iscsi_tmr_req *tmr_req;
 	struct iscsi_tm *hdr;
 	int out_of_order_cmdsn = 0, ret;
-	bool sess_ref = false;
 	u8 function, tcm_function = TMR_UNKNOWN;
 
 	hdr			= (struct iscsi_tm *) buf;
@@ -1988,22 +1987,23 @@ static enum tcm_tmreq_table iscsit_convert_tmf(u8 iscsi_tmf)
 
 	cmd->data_direction = DMA_NONE;
 	cmd->tmr_req = kzalloc(sizeof(*cmd->tmr_req), GFP_KERNEL);
-	if (!cmd->tmr_req)
+	if (!cmd->tmr_req) {
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_NO_RESOURCES,
 					     buf);
+	}
+
+	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
+			      conn->sess->se_sess, 0, DMA_NONE,
+			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
+
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
 	 * LIO-Target $FABRIC_MOD
 	 */
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
-		transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
-				      conn->sess->se_sess, 0, DMA_NONE,
-				      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
-
-		target_get_sess_cmd(&cmd->se_cmd, true);
-		sess_ref = true;
 		tcm_function = iscsit_convert_tmf(function);
 		if (tcm_function == TMR_UNKNOWN) {
 			pr_err("Unknown iSCSI TMR Function:"
@@ -2119,12 +2119,8 @@ static enum tcm_tmreq_table iscsit_convert_tmf(u8 iscsi_tmf)
 	 * For connection recovery, this is also the default action for
 	 * TMR TASK_REASSIGN.
 	 */
-	if (sess_ref) {
-		pr_debug("Handle TMR, using sess_ref=true check\n");
-		target_put_sess_cmd(&cmd->se_cmd);
-	}
-
 	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+	target_put_sess_cmd(&cmd->se_cmd);
 	return 0;
 }
 EXPORT_SYMBOL(iscsit_handle_task_mgt_cmd);
-- 
1.9.1
