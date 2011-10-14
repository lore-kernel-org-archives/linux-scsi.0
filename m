From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 14/37] target: remove transport_generic_remove
Date: Fri, 14 Oct 2011 00:41:46 +0000
Message-ID: <1318552929-13341-15-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

All callers that never have the session_reinstatement flag set can trivially
be converted to transport_put_cmd.  Opencode the session reinstatement code
in transport_generic_free_cmd, which was the only caller ever asking for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   44 +++++++++++---------------------
 1 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a650100..4f21b88 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -86,8 +86,6 @@ static u32 transport_allocate_tasks(struct se_cmd *cmd,
 		enum dma_data_direction data_direction,
 		struct scatterlist *sgl, unsigned int nents);
 static int transport_generic_get_mem(struct se_cmd *cmd);
-static int transport_generic_remove(struct se_cmd *cmd,
-		int session_reinstatement);
 static bool transport_put_cmd(struct se_cmd *cmd);
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		struct se_queue_obj *qobj);
@@ -599,7 +597,7 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 		return;
 	if (remove) {
 		transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
-		transport_generic_remove(cmd, 0);
+		transport_put_cmd(cmd);
 	}
 }
 
@@ -610,7 +608,7 @@ void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
 
-	transport_generic_remove(cmd, 0);
+	transport_put_cmd(cmd);
 }
 
 static void transport_add_cmd_to_queue(
@@ -2072,7 +2070,7 @@ static void transport_generic_request_timeout(struct se_cmd *cmd)
 	unsigned long flags;
 
 	/*
-	 * Reset cmd->t_se_count to allow transport_generic_remove()
+	 * Reset cmd->t_se_count to allow transport_put_cmd()
 	 * to allow last call to free memory resources.
 	 */
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
@@ -2083,7 +2081,7 @@ static void transport_generic_request_timeout(struct se_cmd *cmd)
 	}
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	transport_generic_remove(cmd, 0);
+	transport_put_cmd(cmd);
 }
 
 static inline u32 transport_lba_21(unsigned char *cdb)
@@ -3772,24 +3770,6 @@ out_busy:
 	return false;
 }
 
-static int
-transport_generic_remove(struct se_cmd *cmd, int session_reinstatement)
-{
-	unsigned long flags;
-
-	if (!transport_put_cmd(cmd)) {
-		if (session_reinstatement) {
-			spin_lock_irqsave(&cmd->t_state_lock, flags);
-			transport_all_task_dev_remove_state(cmd);
-			spin_unlock_irqrestore(&cmd->t_state_lock,
-					flags);
-		}
-		return 1;
-	}
-
-	return 0;
-}
-
 /*
  * transport_generic_map_mem_to_cmd - Use fabric-alloced pages instead of
  * allocating in the core.
@@ -4379,7 +4359,13 @@ void transport_generic_free_cmd(
 
 		transport_free_dev_tasks(cmd);
 
-		transport_generic_remove(cmd, session_reinstatement);
+		if (!transport_put_cmd(cmd) && session_reinstatement) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			transport_all_task_dev_remove_state(cmd);
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		}
 	}
 }
 EXPORT_SYMBOL(transport_generic_free_cmd);
@@ -5066,7 +5052,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 				transport_lun_remove_cmd(cmd);
 
 				if (transport_cmd_check_stop(cmd, 1, 0))
-					transport_generic_remove(cmd, 0);
+					transport_put_cmd(cmd);
 			}
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -5094,7 +5080,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			transport_lun_remove_cmd(cmd);
 
 			if (transport_cmd_check_stop(cmd, 1, 0))
-				transport_generic_remove(cmd, 0);
+				transport_put_cmd(cmd);
 		}
 
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -5117,7 +5103,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 		} else {
 			transport_lun_remove_cmd(cmd);
 			if (transport_cmd_check_stop(cmd, 1, 0))
-				transport_generic_remove(cmd, 0);
+				transport_put_cmd(cmd);
 		}
 	}
 }
@@ -5192,7 +5178,7 @@ get_cmd:
 			transport_generic_complete_ok(cmd);
 			break;
 		case TRANSPORT_REMOVE:
-			transport_generic_remove(cmd, 0);
+			transport_put_cmd(cmd);
 			break;
 		case TRANSPORT_FREE_CMD_INTR:
 			transport_generic_free_cmd(cmd, 0, 0);
-- 
1.5.6.5
