From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Avoid target_shutdown_sessions loop during queue_depth change
Date: Thu,  1 Jun 2017 06:54:06 +0000
Message-ID: <1496300046-21234-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

When target_shutdown_sessions() is invoked to shutdown all active
sessions associated with a se_node_acl when se_node_acl->queue_depth
is changed via core_tpg_set_initiator_node_queue_depth(), it's
possible that new connections reconnect immediately after explicit
shutdown occurs via target_shutdown_sessions().

Which means it's possible for the newly reconnected session with
the proper queue_depth can be shutdown multiple times when
target_shutdown_sessions() loops to drain all active sessions
for all cases.

This was regression was introduced by:

  commit bc6e6bb470eda42f44bcac96c261cff1216577b3
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Mon May 2 15:45:19 2016 +0200

      target: consolidate and fix session shutdown

To avoid this case, instead move sessions into a local list and
avoid draining the same session multiple times when invoked via
core_tpg_set_initiator_node_queue_depth(), but still loop during
normal se_node_acl delete until all associated sessions have
been shutdown.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 310d9e5..7a7c2b5 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -336,10 +336,11 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	return acl;
 }
 
-static void target_shutdown_sessions(struct se_node_acl *acl)
+static void target_shutdown_sessions(struct se_node_acl *acl, bool do_restart)
 {
 	struct se_session *sess;
 	unsigned long flags;
+	LIST_HEAD(tmp_list);
 
 restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
@@ -347,14 +348,22 @@ static void target_shutdown_sessions(struct se_node_acl *acl)
 		if (sess->sess_tearing_down)
 			continue;
 
+		list_move_tail(&sess->sess_acl_list, &tmp_list);
+	}
+	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
+
+	if (list_empty(&tmp_list))
+		return;
+
+	list_for_each_entry(sess, &tmp_list, sess_acl_list) {
 		list_del_init(&sess->sess_acl_list);
-		spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
 
 		if (acl->se_tpg->se_tpg_tfo->close_session)
 			acl->se_tpg->se_tpg_tfo->close_session(sess);
-		goto restart;
 	}
-	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
+
+	if (do_restart)
+		goto restart;
 }
 
 void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
@@ -367,7 +376,7 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	list_del(&acl->acl_list);
 	mutex_unlock(&tpg->acl_node_mutex);
 
-	target_shutdown_sessions(acl);
+	target_shutdown_sessions(acl, true);
 
 	target_put_nacl(acl);
 	/*
@@ -414,7 +423,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	/*
 	 * Shutdown all pending sessions to force session reinstatement.
 	 */
-	target_shutdown_sessions(acl);
+	target_shutdown_sessions(acl, false);
 
 	pr_debug("Successfully changed queue depth to: %d for Initiator"
 		" Node: %s on %s Target Portal Group: %u\n", acl->queue_depth,
-- 
1.9.1
