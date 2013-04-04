From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v3 1/9] target: Add export of target_get_sess_cmd symbol
Date: Thu,  4 Apr 2013 07:24:08 +0000
Message-ID: <1365060256-21506-2-git-send-email-nab@linux-iscsi.org>
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Export target_get_sess_cmd() symbol so that it can be used by
iscsi-target.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    4 ++--
 include/target/target_core_fabric.h    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 493e9e5..f8388b4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -65,7 +65,6 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev);
 static int transport_generic_get_mem(struct se_cmd *cmd);
-static int target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
 static void transport_put_cmd(struct se_cmd *cmd);
 static void target_complete_ok_work(struct work_struct *work);
 
@@ -2179,7 +2178,7 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  * @se_cmd:	command descriptor to add
  * @ack_kref:	Signal that fabric will perform an ack target_put_sess_cmd()
  */
-static int target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
+int target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
 			       bool ack_kref)
 {
 	unsigned long flags;
@@ -2208,6 +2207,7 @@ out:
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(target_get_sess_cmd);
 
 static void target_release_cmd_kref(struct kref *kref)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index aaa1ee6..ba3471b 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -120,7 +120,7 @@ bool	transport_wait_for_tasks(struct se_cmd *);
 int	transport_check_aborted_status(struct se_cmd *, int);
 int	transport_send_check_condition_and_sense(struct se_cmd *,
 		sense_reason_t, int);
-
+int	target_get_sess_cmd(struct se_session *, struct se_cmd *, bool);
 int	target_put_sess_cmd(struct se_session *, struct se_cmd *);
 void	target_sess_cmd_list_set_waiting(struct se_session *);
 void	target_wait_for_sess_cmds(struct se_session *, int);
-- 
1.7.2.5
