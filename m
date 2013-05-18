From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Remove unused wait_for_tasks bit in target_wait_for_sess_cmds
Date: Sat, 18 May 2013 00:40:29 +0000
Message-ID: <1368837631-2239-2-git-send-email-nab@linux-iscsi.org>
References: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Joern Engel <joern@logfs.org>
List-Id: linux-scsi@vger.kernel.org

From: Joern Engel <joern@logfs.org>

Drop unused transport_wait_for_tasks() check in target_wait_for_sess_cmds
shutdown code, and convert tcm_qla2xxx + ib_srpt fabric drivers.

Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
 drivers/target/target_core_transport.c |   28 +++++-----------------------
 include/target/target_core_fabric.h    |    2 +-
 4 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c09d41b..c318f7c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2328,7 +2328,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	se_sess = ch->sess;
 	BUG_ON(!se_sess);
 
-	target_wait_for_sess_cmds(se_sess, 0);
+	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d182c96..7a3870f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1370,7 +1370,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 		dump_stack();
 		return;
 	}
-	target_wait_for_sess_cmds(se_sess, 0);
+	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(sess->se_sess);
 	transport_deregister_session(sess->se_sess);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4a79336..311c113 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2263,14 +2263,10 @@ EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
 /* target_wait_for_sess_cmds - Wait for outstanding descriptors
  * @se_sess:    session to wait for active I/O
- * @wait_for_tasks:	Make extra transport_wait_for_tasks call
  */
-void target_wait_for_sess_cmds(
-	struct se_session *se_sess,
-	int wait_for_tasks)
+void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
-	bool rc = false;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
 				&se_sess->sess_cmd_list, se_cmd_list) {
@@ -2280,24 +2276,10 @@ void target_wait_for_sess_cmds(
 			" %d\n", se_cmd, se_cmd->t_state,
 			se_cmd->se_tfo->get_cmd_state(se_cmd));
 
-		if (wait_for_tasks) {
-			pr_debug("Calling transport_wait_for_tasks se_cmd: %p t_state: %d,"
-				" fabric state: %d\n", se_cmd, se_cmd->t_state,
-				se_cmd->se_tfo->get_cmd_state(se_cmd));
-
-			rc = transport_wait_for_tasks(se_cmd);
-
-			pr_debug("After transport_wait_for_tasks se_cmd: %p t_state: %d,"
-				" fabric state: %d\n", se_cmd, se_cmd->t_state,
-				se_cmd->se_tfo->get_cmd_state(se_cmd));
-		}
-
-		if (!rc) {
-			wait_for_completion(&se_cmd->cmd_wait_comp);
-			pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
-				" fabric state: %d\n", se_cmd, se_cmd->t_state,
-				se_cmd->se_tfo->get_cmd_state(se_cmd));
-		}
+		wait_for_completion(&se_cmd->cmd_wait_comp);
+		pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
+			" fabric state: %d\n", se_cmd, se_cmd->t_state,
+			se_cmd->se_tfo->get_cmd_state(se_cmd));
 
 		se_cmd->se_tfo->release_cmd(se_cmd);
 	}
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index ba3471b..8a26f0d 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -123,7 +123,7 @@ int	transport_send_check_condition_and_sense(struct se_cmd *,
 int	target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
 int	target_put_sess_cmd(struct se_session *, struct se_cmd *);
 void	target_sess_cmd_list_set_waiting(struct se_session *);
-void	target_wait_for_sess_cmds(struct se_session *, int);
+void	target_wait_for_sess_cmds(struct se_session *);
 
 int	core_alua_check_nonop_delay(struct se_cmd *);
 
-- 
1.7.2.5
