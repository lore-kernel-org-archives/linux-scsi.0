From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 3/3] target: Fix TAS handling for multi-session se_node_acls
Date: Sat, 23 Jan 2016 01:37:47 +0000
Message-ID: <1453513067-23169-4-git-send-email-nab@daterainc.com>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33733 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbcAWBk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 20:40:27 -0500
Received: by mail-ob0-f169.google.com with SMTP id is5so77201757obc.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 17:40:27 -0800 (PST)
In-Reply-To: <1453513067-23169-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in TMR task aborted status (TAS)
handling when multiple sessions are connected to the
same target WWPN endpoint and se_node_acl descriptor,
resulting in TASK_ABORTED status to not be generated
for aborted se_cmds on the remote port.

This is due to core_tmr_handle_tas_abort() incorrectly
comparing se_node_acl instead of se_session, for which
the multi-session case is expected to be sharing the
same se_node_acl.

Instead, go ahead and update core_tmr_handle_tas_abort()
to compare tmr_sess + cmd->se_sess in order to determine
if the LUN_RESET was received on a different I_T nexus,
and TASK_ABORTED status response needs to be generated.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index d4f30aa..3eff563 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -76,7 +76,7 @@ void core_tmr_release_req(struct se_tmr_req *tmr)
 }
 
 static void core_tmr_handle_tas_abort(
-	struct se_node_acl *tmr_nacl,
+	struct se_session *tmr_sess,
 	struct se_cmd *cmd,
 	int tas)
 {
@@ -84,7 +84,7 @@ static void core_tmr_handle_tas_abort(
 	/*
 	 * TASK ABORTED status (TAS) bit support
 	 */
-	if ((tmr_nacl && (tmr_nacl != cmd->se_sess->se_node_acl)) && tas) {
+	if ((tmr_sess && (tmr_sess != cmd->se_sess)) && tas) {
 		remove = false;
 		transport_send_task_abort(cmd);
 	}
@@ -111,7 +111,7 @@ static bool __target_check_io_state(struct se_cmd *se_cmd)
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&se_session->sess_cmd_lock);
+	assert_spin_locked(&sess->sess_cmd_lock);
 	WARN_ON_ONCE(!irqs_disabled());
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
@@ -272,7 +272,7 @@ static void core_tmr_drain_tmr_list(
 static void core_tmr_drain_state_list(
 	struct se_device *dev,
 	struct se_cmd *prout_cmd,
-	struct se_node_acl *tmr_nacl,
+	struct se_session *tmr_sess,
 	int tas,
 	struct list_head *preempt_and_abort_list)
 {
@@ -364,7 +364,7 @@ static void core_tmr_drain_state_list(
 		cancel_work_sync(&cmd->work);
 		transport_wait_for_tasks(cmd);
 
-		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas);
+		core_tmr_handle_tas_abort(tmr_sess, cmd, tas);
 		target_put_sess_cmd(cmd);
 	}
 }
@@ -377,6 +377,7 @@ int core_tmr_lun_reset(
 {
 	struct se_node_acl *tmr_nacl = NULL;
 	struct se_portal_group *tmr_tpg = NULL;
+	struct se_session *tmr_sess = NULL;
 	int tas;
         /*
 	 * TASK_ABORTED status bit, this is configurable via ConfigFS
@@ -395,8 +396,9 @@ int core_tmr_lun_reset(
 	 * or struct se_device passthrough..
 	 */
 	if (tmr && tmr->task_cmd && tmr->task_cmd->se_sess) {
-		tmr_nacl = tmr->task_cmd->se_sess->se_node_acl;
-		tmr_tpg = tmr->task_cmd->se_sess->se_tpg;
+		tmr_sess = tmr->task_cmd->se_sess;
+		tmr_nacl = tmr_sess->se_node_acl;
+		tmr_tpg = tmr_sess->se_tpg;
 		if (tmr_nacl && tmr_tpg) {
 			pr_debug("LUN_RESET: TMR caller fabric: %s"
 				" initiator port %s\n",
@@ -409,7 +411,7 @@ int core_tmr_lun_reset(
 		dev->transport->name, tas);
 
 	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
-	core_tmr_drain_state_list(dev, prout_cmd, tmr_nacl, tas,
+	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
 
 	/*
-- 
1.9.1

