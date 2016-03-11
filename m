From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 05/14] tcm_fc: Convert to target_alloc_session usage
Date: Fri, 11 Mar 2016 06:30:01 +0000
Message-ID: <1457677810-2478-6-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mark Rustad <mark.d.rustad@intel.com>, Robert Love <robert.w.love@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts tcm_fc target mode addition of tf_sess->hash to
port_id hlist_head using the new alloc_session callback().

Cc: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_sess.c | 44 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index e19f4c5..d0c3e18 100644
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
@@ -194,7 +208,6 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 				      struct fc_rport_priv *rdata)
 {
 	struct se_portal_group *se_tpg = &tport->tpg->se_tpg;
-	struct se_node_acl *se_acl;
 	struct ft_sess *sess;
 	struct hlist_head *head;
 	unsigned char initiatorname[TRANSPORT_IQN_LEN];
@@ -210,31 +223,18 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
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
 
-	se_acl = core_tpg_get_initiator_node_acl(se_tpg, &initiatorname[0]);
-	if (!se_acl) {
-		transport_free_session(sess->se_sess);
+	sess->se_sess = target_alloc_session(se_tpg, TCM_FC_DEFAULT_TAGS,
+					     sizeof(struct ft_cmd),
+					     TARGET_PROT_NORMAL, &initiatorname[0],
+					     sess, ft_sess_alloc_cb);
+	if (IS_ERR(sess->se_sess)) {
 		kfree(sess);
 		return NULL;
 	}
-	sess->se_sess->se_node_acl = se_acl;
-	sess->tport = tport;
-	sess->port_id = port_id;
-	kref_init(&sess->kref);	/* ref for table entry */
-	hlist_add_head_rcu(&sess->hash, head);
-	tport->sess_count++;
-
-	pr_debug("port_id %x sess %p\n", port_id, sess);
-
-	transport_register_session(&tport->tpg->se_tpg, se_acl,
-				   sess->se_sess, sess);
 	return sess;
 }
 
-- 
1.9.1
