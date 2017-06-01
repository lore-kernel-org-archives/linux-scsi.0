From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: Avoid target_shutdown_sessions loop during
        queue_depth change
Date: Thu, 1 Jun 2017 08:57:15 +0200
Message-ID: <20170601065715.GA17147@lst.de>
References: <1496300046-21234-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496300046-21234-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

How about this slightly easier to read version?

---
>From 75276cd521ccecba244c1ee6c1100e27518c628d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 1 Jun 2017 06:54:06 +0000
Subject: target: Avoid target_shutdown_sessions loop during queue_depth change

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
 drivers/target/target_core_tpg.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 310d9e55c6eb..74893acb8b5e 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -336,25 +336,32 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	return acl;
 }
 
-static void target_shutdown_sessions(struct se_node_acl *acl)
+static bool target_shutdown_sessions(struct se_node_acl *acl)
 {
 	struct se_session *sess;
 	unsigned long flags;
+	LIST_HEAD(tmp_list);
 
-restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
 		if (sess->sess_tearing_down)
 			continue;
 
+		list_move_tail(&sess->sess_acl_list, &tmp_list);
+	}
+	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
+
+	if (list_empty(&tmp_list))
+		return true;
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
+	return false;
 }
 
 void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
@@ -367,7 +374,8 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	list_del(&acl->acl_list);
 	mutex_unlock(&tpg->acl_node_mutex);
 
-	target_shutdown_sessions(acl);
+	while (!target_shutdown_sessions(acl))
+		;
 
 	target_put_nacl(acl);
 	/*
-- 
2.11.0
