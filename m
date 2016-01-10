From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-for-4.6 5/6] tcm_fc: Convert to target_alloc_session usage
Date: Sun, 10 Jan 2016 20:44:27 +0000
Message-ID: <1452458668-11034-6-git-send-email-nab@daterainc.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Vasu Dev <vasu.dev@linux.intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_sess.c | 47 +++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index b3db638..19bfbda 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -186,6 +186,20 @@ out:
 	return NULL;
 }
 
+static int ft_sess_alloc_cb(struct se_portal_group *se_tpg,
+			    struct se_session *se_sess, void *p)
+{
+	struct ft_sess *sess = p;
+	struct ft_tport *tport = sess->tport;
+	struct hlist_head *head = &tport->hash[ft_sess_hash(sess->port_id)];
+
+	pr_debug("port_id %x sess %p\n", sess->port_id, sess);
+	hlist_add_head_rcu(&sess->hash, head);
+	tport->sess_count++;
+
+	return 0;
+}
+
 /*
  * Allocate session and enter it in the hash for the local port.
  * Caller holds ft_lport_lock.
@@ -193,9 +207,10 @@ out:
 static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 				      struct fc_rport_priv *rdata)
 {
+	struct se_portal_group *se_tpg = &tport->tpg->se_tpg;
 	struct ft_sess *sess;
-	struct ft_node_acl *acl;
 	struct hlist_head *head;
+	unsigned char iname[TRANSPORT_IQN_LEN];
 
 	head = &tport->hash[ft_sess_hash(port_id)];
 	hlist_for_each_entry_rcu(sess, head, hash)
@@ -206,32 +221,20 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	if (!sess)
 		return NULL;
 
-	sess->se_sess = transport_init_session_tags(TCM_FC_DEFAULT_TAGS,
-						    sizeof(struct ft_cmd),
-						    TARGET_PROT_NORMAL);
-	if (IS_ERR(sess->se_sess)) {
-		kfree(sess);
-		return NULL;
-	}
+	kref_init(&sess->kref); /* ref for table entry */
+	sess->tport = tport;
+	sess->port_id = port_id;
+	ft_format_wwn(&iname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
 
-	acl = ft_acl_get(tport->tpg, rdata);
-	if (!acl) {
-		transport_free_session(sess->se_sess);
+	sess->se_sess = target_alloc_session(se_tpg, TCM_FC_DEFAULT_TAGS,
+					     sizeof(struct ft_cmd),
+					     TARGET_PROT_NORMAL, &iname[0],
+					     sess, ft_sess_alloc_cb);
+	if (IS_ERR(sess->se_sess)) {
 		kfree(sess);
 		return NULL;
 	}
 
-	sess->se_sess->se_node_acl = &acl->se_node_acl;
-	sess->tport = tport;
-	sess->port_id = port_id;
-	kref_init(&sess->kref);	/* ref for table entry */
-	hlist_add_head_rcu(&sess->hash, head);
-	tport->sess_count++;
-
-	pr_debug("port_id %x sess %p\n", port_id, sess);
-
-	transport_register_session(&tport->tpg->se_tpg, &acl->se_node_acl,
-				   sess->se_sess, sess);
 	return sess;
 }
 
-- 
1.9.1
