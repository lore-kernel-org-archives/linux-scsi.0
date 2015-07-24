From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/4] iscsi-target: Fix use-after-free during TPG session shutdown
Date: Fri, 24 Jul 2015 02:51:16 +0000
Message-ID: <1437706279-10580-2-git-send-email-nab@daterainc.com>
References: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Nicholas Bellinger <nab@linux-iscsi.org>, Sunilkumar Nadumuttlu <sjn@datera.io>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a use-after-free bug in iscsit_release_sessions_for_tpg()
where se_portal_group->session_lock was incorrectly released/re-acquired
while walking the active se_portal_group->tpg_sess_list.

The can result in a NULL pointer dereference when iscsit_close_session()
shutdown happens in the normal path asynchronously to this code, causing
a bogus dereference of an already freed list entry to occur.

To address this bug, walk the session list checking for the same state
as before, but move entries to a local list to avoid dropping the lock
while walking the active list.

As before, signal using iscsi_session->session_restatement=1 for those
list entries to be released locally by iscsit_free_session() code.

Reported-by: Sunilkumar Nadumuttlu <sjn@datera.io>
Cc: Sunilkumar Nadumuttlu <sjn@datera.io>
Cc: <stable@vger.kernel.org> # v3.1+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4e68b62..afab323 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4765,6 +4765,7 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	struct iscsi_session *sess;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 	struct se_session *se_sess, *se_sess_tmp;
+	LIST_HEAD(free_list);
 	int session_count = 0;
 
 	spin_lock_bh(&se_tpg->session_lock);
@@ -4786,14 +4787,17 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 		}
 		atomic_set(&sess->session_reinstatement, 1);
 		spin_unlock(&sess->conn_lock);
-		spin_unlock_bh(&se_tpg->session_lock);
 
-		iscsit_free_session(sess);
-		spin_lock_bh(&se_tpg->session_lock);
+		list_move_tail(&se_sess->sess_list, &free_list);
+	}
+	spin_unlock_bh(&se_tpg->session_lock);
 
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
+		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
+
+		iscsit_free_session(sess);
 		session_count++;
 	}
-	spin_unlock_bh(&se_tpg->session_lock);
 
 	pr_debug("Released %d iSCSI Session(s) from Target Portal"
 			" Group: %hu\n", session_count, tpg->tpgt);
-- 
1.9.1
