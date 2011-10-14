From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 15/37] target: push session reinstatement out of transport_generic_free_cmd
Date: Fri, 14 Oct 2011 00:41:47 +0000
Message-ID: <1318552929-13341-16-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Push session reinstatement out of transport_generic_free_cmd into the only
caller that actually needs it.  Clean up transport_generic_free_cmd a bit,
and remove the useless comment.  I'd love to add a more useful kerneldoc
comment for it, but as this point I'm still a bit confused in where it
stands in the command release stack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c    |    2 +-
 drivers/target/loopback/tcm_loop.c     |    4 +-
 drivers/target/target_core_transport.c |   37 +++++++++++--------------------
 drivers/target/tcm_fc/tfc_cmd.c        |   12 +++++-----
 include/target/target_core_transport.h |    2 +-
 5 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6a4ea29..7dc2cfe 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3547,7 +3547,7 @@ get_immediate:
 					iscsit_release_cmd(cmd);
 				else
 					transport_generic_free_cmd(&cmd->se_cmd,
-								1, 0);
+								1);
 				goto get_immediate;
 			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
 				spin_unlock_bh(&cmd->istate_lock);
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index aa2d679..f0e701d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -200,7 +200,7 @@ static void tcm_loop_check_stop_free(struct se_cmd *se_cmd)
 	 * Release the struct se_cmd, which will make a callback to release
 	 * struct tcm_loop_cmd * in tcm_loop_deallocate_core_cmd()
 	 */
-	transport_generic_free_cmd(se_cmd, 0, 0);
+	transport_generic_free_cmd(se_cmd, 0);
 }
 
 static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
@@ -388,7 +388,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 		SUCCESS : FAILED;
 release:
 	if (se_cmd)
-		transport_generic_free_cmd(se_cmd, 1, 0);
+		transport_generic_free_cmd(se_cmd, 1);
 	else
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	kfree(tl_tmr);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4f21b88..db2f898 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4331,42 +4331,25 @@ void transport_release_cmd(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_release_cmd);
 
-/*	transport_generic_free_cmd():
- *
- *	Called from processing frontend to release storage engine resources
- */
-void transport_generic_free_cmd(
-	struct se_cmd *cmd,
-	int wait_for_tasks,
-	int session_reinstatement)
+bool transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD))
 		transport_release_cmd(cmd);
 	else {
 		core_dec_lacl_count(cmd->se_sess->se_node_acl, cmd);
 
-		if (cmd->se_lun) {
-#if 0
-			pr_debug("cmd: %p ITT: 0x%08x contains"
-				" cmd->se_lun\n", cmd,
-				cmd->se_tfo->get_task_tag(cmd));
-#endif
+		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
-		}
 
 		if (wait_for_tasks && cmd->transport_wait_for_tasks)
 			cmd->transport_wait_for_tasks(cmd, 0, 0);
 
 		transport_free_dev_tasks(cmd);
 
-		if (!transport_put_cmd(cmd) && session_reinstatement) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&cmd->t_state_lock, flags);
-			transport_all_task_dev_remove_state(cmd);
-			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		}
+		return transport_put_cmd(cmd);
 	}
+
+	return true;
 }
 EXPORT_SYMBOL(transport_generic_free_cmd);
 
@@ -4631,7 +4614,13 @@ remove:
 	if (!remove_cmd)
 		return;
 
-	transport_generic_free_cmd(cmd, 0, session_reinstatement);
+	if (!transport_generic_free_cmd(cmd, 0) && session_reinstatement) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
+		transport_all_task_dev_remove_state(cmd);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	}
 }
 
 static int transport_get_sense_codes(
@@ -5181,7 +5170,7 @@ get_cmd:
 			transport_put_cmd(cmd);
 			break;
 		case TRANSPORT_FREE_CMD_INTR:
-			transport_generic_free_cmd(cmd, 0, 0);
+			transport_generic_free_cmd(cmd, 0);
 			break;
 		case TRANSPORT_PROCESS_TMR:
 			transport_generic_do_tmr(cmd);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index c2d148d..7f2ee5a 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -114,7 +114,7 @@ void ft_release_cmd(struct se_cmd *se_cmd)
 
 void ft_check_stop_free(struct se_cmd *se_cmd)
 {
-	transport_generic_free_cmd(se_cmd, 0, 0);
+	transport_generic_free_cmd(se_cmd, 0);
 }
 
 /*
@@ -269,7 +269,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		/* XXX need to find cmd if queued */
 		cmd->se_cmd.t_state = TRANSPORT_REMOVE;
 		cmd->seq = NULL;
-		transport_generic_free_cmd(&cmd->se_cmd, 0, 0);
+		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		return;
 	}
 
@@ -287,7 +287,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		       __func__, fh->fh_r_ctl);
 		ft_invl_hw_context(cmd);
 		fc_frame_free(fp);
-		transport_generic_free_cmd(&cmd->se_cmd, 0, 0);
+		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		break;
 	}
 }
@@ -420,7 +420,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 			sess = cmd->sess;
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
 				cmd->se_cmd.scsi_sense_reason, 0);
-			transport_generic_free_cmd(&cmd->se_cmd, 0, 0);
+			transport_generic_free_cmd(&cmd->se_cmd, 0);
 			ft_sess_put(sess);
 			return;
 		}
@@ -627,7 +627,7 @@ static void ft_send_work(struct work_struct *work)
 	if (ret == -ENOMEM) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0, 0);
+		transport_generic_free_cmd(se_cmd, 0);
 		return;
 	}
 	if (ret == -EINVAL) {
@@ -636,7 +636,7 @@ static void ft_send_work(struct work_struct *work)
 		else
 			transport_send_check_condition_and_sense(se_cmd,
 					se_cmd->scsi_sense_reason, 0);
-		transport_generic_free_cmd(se_cmd, 0, 0);
+		transport_generic_free_cmd(se_cmd, 0);
 		return;
 	}
 	transport_handle_cdb_direct(se_cmd);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 99a671e..a113129 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -184,7 +184,7 @@ extern int transport_check_aborted_status(struct se_cmd *, int);
 extern int transport_send_check_condition_and_sense(struct se_cmd *, u8, int);
 extern void transport_send_task_abort(struct se_cmd *);
 extern void transport_release_cmd(struct se_cmd *);
-extern void transport_generic_free_cmd(struct se_cmd *, int, int);
+extern bool transport_generic_free_cmd(struct se_cmd *, int);
 extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
 extern int transport_init_task_sg(struct se_task *, struct se_mem *, u32);
 extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
-- 
1.5.6.5
