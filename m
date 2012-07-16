From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/7] target: Un-export target_get_sess_cmd()
Date: Mon, 16 Jul 2012 11:04:37 -0700
Message-ID: <1342461882-5848-3-git-send-email-roland@kernel.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

There are no in-tree users of target_get_sess_cmd() outside of
target_core_transport.c.  Any new code should use the higher-level
target_submit_cmd() interface.  So let's un-export target_get_sess_cmd()
and make it static to the one file where it's actually used.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c |    6 +++---
 include/target/target_core_fabric.h    |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 634d0f3..82e40e1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -73,6 +73,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev);
 static int transport_generic_get_mem(struct se_cmd *cmd);
+static void target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
 static void transport_put_cmd(struct se_cmd *cmd);
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd);
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
@@ -3648,8 +3649,8 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  * @se_cmd:	command descriptor to add
  * @ack_kref:	Signal that fabric will perform an ack target_put_sess_cmd()
  */
-void target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
-			bool ack_kref)
+static void target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
+				bool ack_kref)
 {
 	unsigned long flags;
 
@@ -3669,7 +3670,6 @@ void target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
 	se_cmd->check_release = 1;
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 }
-EXPORT_SYMBOL(target_get_sess_cmd);
 
 static void target_release_cmd_kref(struct kref *kref)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index c78a233..1e68882 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -129,7 +129,6 @@ bool	transport_wait_for_tasks(struct se_cmd *);
 int	transport_check_aborted_status(struct se_cmd *, int);
 int	transport_send_check_condition_and_sense(struct se_cmd *, u8, int);
 
-void	target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
 int	target_put_sess_cmd(struct se_session *, struct se_cmd *);
 void	target_splice_sess_cmd_list(struct se_session *);
 void	target_wait_for_sess_cmds(struct se_session *, int);
-- 
1.7.10.4
