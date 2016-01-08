From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/4] tcm_fc: Convert acl lookup to modern get_initiator_node_acl usage
Date: Fri,  8 Jan 2016 07:15:47 +0000
Message-ID: <1452237348-2277-4-git-send-email-nab@daterainc.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch does a simple conversion of tcm_fc code to use
proper modern core_tpg_get_initiator_node_acl() lookup using
se_node_acl->acl_kref, and drops the legacy list walk from
ft_acl_get().

Note the original lookup also took node_name into account,
but since ft_init_nodeacl() only ever sets port_name for
se_node_acl->acl_group within configfs, this is purely
a mechanical change.

Cc: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_conf.c | 26 ++++++++------------------
 drivers/target/tcm_fc/tfc_sess.c | 18 +++++++++++-------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 9cdb2ac..9389ba3 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -222,27 +222,17 @@ static int ft_init_nodeacl(struct se_node_acl *nacl, const char *name)
 
 struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 {
-	struct ft_node_acl *found = NULL;
-	struct ft_node_acl *acl;
 	struct se_portal_group *se_tpg = &tpg->se_tpg;
 	struct se_node_acl *se_acl;
+	unsigned char initiatorname[TRANSPORT_IQN_LEN];
 
-	mutex_lock(&se_tpg->acl_node_mutex);
-	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
-		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
-		pr_debug("acl %p port_name %llx\n",
-			acl, (unsigned long long)acl->node_auth.port_name);
-		if (acl->node_auth.port_name == rdata->ids.port_name ||
-		    acl->node_auth.node_name == rdata->ids.node_name) {
-			pr_debug("acl %p port_name %llx matched\n", acl,
-				    (unsigned long long)rdata->ids.port_name);
-			found = acl;
-			/* XXX need to hold onto ACL */
-			break;
-		}
-	}
-	mutex_unlock(&se_tpg->acl_node_mutex);
-	return found;
+	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
+
+	se_acl = core_tpg_get_initiator_node_acl(se_tpg, &initiatorname[0]);
+	if (!se_acl)
+		return NULL;
+
+	return container_of(se_acl, struct ft_node_acl, se_node_acl);
 }
 
 /*
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 45947e2..b3db638 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -191,9 +191,10 @@ out:
  * Caller holds ft_lport_lock.
  */
 static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
-				      struct ft_node_acl *acl)
+				      struct fc_rport_priv *rdata)
 {
 	struct ft_sess *sess;
+	struct ft_node_acl *acl;
 	struct hlist_head *head;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
@@ -212,6 +213,14 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 		kfree(sess);
 		return NULL;
 	}
+
+	acl = ft_acl_get(tport->tpg, rdata);
+	if (!acl) {
+		transport_free_session(sess->se_sess);
+		kfree(sess);
+		return NULL;
+	}
+
 	sess->se_sess->se_node_acl = &acl->se_node_acl;
 	sess->tport = tport;
 	sess->port_id = port_id;
@@ -349,17 +358,12 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 {
 	struct ft_tport *tport;
 	struct ft_sess *sess;
-	struct ft_node_acl *acl;
 	u32 fcp_parm;
 
 	tport = ft_tport_get(rdata->local_port);
 	if (!tport)
 		goto not_target;	/* not a target for this local port */
 
-	acl = ft_acl_get(tport->tpg, rdata);
-	if (!acl)
-		goto not_target;	/* no target for this remote */
-
 	if (!rspp)
 		goto fill;
 
@@ -381,7 +385,7 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 		spp->spp_flags |= FC_SPP_EST_IMG_PAIR;
 		if (!(fcp_parm & FCP_SPPF_INIT_FCN))
 			return FC_SPP_RESP_CONF;
-		sess = ft_sess_create(tport, rdata->ids.port_id, acl);
+		sess = ft_sess_create(tport, rdata->ids.port_id, rdata);
 		if (!sess)
 			return FC_SPP_RESP_RES;
 		if (!sess->params)
-- 
1.9.1
