From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 7/7] target: Remove se_session.sess_wait_list
Date: Mon, 16 Jul 2012 11:04:42 -0700
Message-ID: <1342461882-5848-8-git-send-email-roland@kernel.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Since we set se_session.sess_tearing_down and stop new commands from
being added to se_session.sess_cmd_list before we wait for commands to
finish when freeing a session, there's no need for a separate
sess_wait_list -- if we let new commands be added to sess_cmd_list
after setting sess_tearing_down, that would be a bug that breaks the
logic of waiting in-flight commands.

Also rename target_splice_sess_cmd_list() to
target_sess_cmd_list_set_waiting(), since we are no longer splicing
onto a separate list.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
 drivers/target/target_core_transport.c |   22 ++++++++++------------
 include/target/target_core_base.h      |    1 -
 include/target/target_core_fabric.h    |    2 +-
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7db7ca7..72f3557 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -466,7 +466,7 @@ static int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
 	vha = sess->vha;
 
 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
-	target_splice_sess_cmd_list(se_sess);
+	target_sess_cmd_list_set_waiting(se_sess);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
 	return 1;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 23e6e2d..7b3359e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -244,7 +244,6 @@ struct se_session *transport_init_session(void)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
-	INIT_LIST_HEAD(&se_sess->sess_wait_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	kref_init(&se_sess->sess_kref);
 
@@ -3719,28 +3718,27 @@ int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 }
 EXPORT_SYMBOL(target_put_sess_cmd);
 
-/* target_splice_sess_cmd_list - Split active cmds into sess_wait_list
- * @se_sess:	session to split
+/* target_sess_cmd_list_set_waiting - Flag all commands in
+ *         sess_cmd_list to complete cmd_wait_comp.  Set
+ *         sess_tearing_down so no more commands are queued.
+ * @se_sess:	session to flag
  */
-void target_splice_sess_cmd_list(struct se_session *se_sess)
+void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd;
 	unsigned long flags;
 
-	WARN_ON(!list_empty(&se_sess->sess_wait_list));
-	INIT_LIST_HEAD(&se_sess->sess_wait_list);
-
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	se_sess->sess_tearing_down = 1;
 
-	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
+	WARN_ON(se_sess->sess_tearing_down);
+	se_sess->sess_tearing_down = 1;
 
-	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list)
+	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list)
 		se_cmd->cmd_wait_set = 1;
 
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 }
-EXPORT_SYMBOL(target_splice_sess_cmd_list);
+EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
 /* target_wait_for_sess_cmds - Wait for outstanding descriptors
  * @se_sess:    session to wait for active I/O
@@ -3754,7 +3752,7 @@ void target_wait_for_sess_cmds(
 	bool rc = false;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_wait_list, se_cmd_list) {
+				&se_sess->sess_cmd_list, se_cmd_list) {
 		list_del(&se_cmd->se_cmd_list);
 
 		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index dc35d86..5d8907e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -633,7 +633,6 @@ struct se_session {
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
-	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
 };
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 4f8e515..86d8a4a 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -130,7 +130,7 @@ int	transport_check_aborted_status(struct se_cmd *, int);
 int	transport_send_check_condition_and_sense(struct se_cmd *, u8, int);
 
 int	target_put_sess_cmd(struct se_session *, struct se_cmd *);
-void	target_splice_sess_cmd_list(struct se_session *);
+void	target_sess_cmd_list_set_waiting(struct se_session *);
 void	target_wait_for_sess_cmds(struct se_session *, int);
 
 int	core_alua_check_nonop_delay(struct se_cmd *);
-- 
1.7.10.4
