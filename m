From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 27/37] target: Merge transport_cmd_finish_abort_tmr into transport_cmd_finish_abort
Date: Fri, 14 Oct 2011 00:41:59 +0000
Message-ID: <1318552929-13341-28-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33482 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1JNApW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:45:22 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch merges transport_cmd_finish_abort_tmr() logic into a single
transport_cmd_finish_abort() function by adding a cmd->se_tmr_req check
around transport_lun_remove_cmd(), and updates the single caller within
core_tmr_drain_tmr_list().

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |    2 +-
 drivers/target/target_core_transport.c |   13 ++-----------
 include/target/target_core_transport.h |    1 -
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index efc5ec7..b8dc10f 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -161,7 +161,7 @@ static void core_tmr_drain_tmr_list(
 			(preempt_and_abort_list) ? "Preempt" : "", tmr,
 			tmr->function, tmr->response, cmd->t_state);
 
-		transport_cmd_finish_abort_tmr(cmd);
+		transport_cmd_finish_abort(cmd, 1);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f8de042..36fb39c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -591,7 +591,8 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_lun_remove_cmd(cmd);
+	if (!cmd->se_tmr_req)
+		transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
@@ -601,16 +602,6 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 	}
 }
 
-void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
-{
-	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
-
-	if (transport_cmd_check_stop_to_fabric(cmd))
-		return;
-
-	transport_put_cmd(cmd);
-}
-
 static void transport_add_cmd_to_queue(
 	struct se_cmd *cmd,
 	int t_state)
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 371c24a..c915169 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -134,7 +134,6 @@ extern void transport_free_session(struct se_session *);
 extern void transport_deregister_session_configfs(struct se_session *);
 extern void transport_deregister_session(struct se_session *);
 extern void transport_cmd_finish_abort(struct se_cmd *, int);
-extern void transport_cmd_finish_abort_tmr(struct se_cmd *);
 extern void transport_complete_sync_cache(struct se_cmd *, int);
 extern void transport_complete_task(struct se_task *, int);
 extern void transport_add_task_to_execute_queue(struct se_task *,
-- 
1.5.6.5

