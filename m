From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] target/tcm_fc: Update debugging statements to match libfc usage
Date: Mon, 22 Aug 2016 10:54:10 +0200
Message-ID: <1471856051-87398-6-git-send-email-hare@suse.de>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbcHVIyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 04:54:22 -0400
In-Reply-To: <1471856051-87398-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Update the debug statements to match those from libfc.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index cc8c261..fd5c3de 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -39,6 +39,11 @@
 
 #include "tcm_fc.h"
 
+#define TFC_SESS_DBG(lport, fmt, args...) \
+	pr_debug("host%u: rport %6.6x: " fmt,	   \
+		 (lport)->host->host_no,	   \
+		 (lport)->port_id, ##args )
+
 static void ft_sess_delete_all(struct ft_tport *);
 
 /*
@@ -167,24 +172,29 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	struct ft_tport *tport;
 	struct hlist_head *head;
 	struct ft_sess *sess;
+	char *reason = "no session created";
 
 	rcu_read_lock();
 	tport = rcu_dereference(lport->prov[FC_TYPE_FCP]);
-	if (!tport)
+	if (!tport) {
+		reason = "not an FCP port";
 		goto out;
+	}
 
 	head = &tport->hash[ft_sess_hash(port_id)];
 	hlist_for_each_entry_rcu(sess, head, hash) {
 		if (sess->port_id == port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
-			pr_debug("port_id %x found %p\n", port_id, sess);
+			TFC_SESS_DBG(lport, "port_id %x found %p\n",
+				     port_id, sess);
 			return sess;
 		}
 	}
 out:
 	rcu_read_unlock();
-	pr_debug("port_id %x not found\n", port_id);
+	TFC_SESS_DBG(lport, "port_id %x not found, %s\n",
+		     port_id, reason);
 	return NULL;
 }
 
@@ -195,7 +205,7 @@ static int ft_sess_alloc_cb(struct se_portal_group *se_tpg,
 	struct ft_tport *tport = sess->tport;
 	struct hlist_head *head = &tport->hash[ft_sess_hash(sess->port_id)];
 
-	pr_debug("port_id %x sess %p\n", sess->port_id, sess);
+	TFC_SESS_DBG(tport->lport, "port_id %x sess %p\n", sess->port_id, sess);
 	hlist_add_head_rcu(&sess->hash, head);
 	tport->sess_count++;
 
@@ -320,7 +330,7 @@ void ft_sess_close(struct se_session *se_sess)
 		mutex_unlock(&ft_lport_lock);
 		return;
 	}
-	pr_debug("port_id %x\n", port_id);
+	TFC_SESS_DBG(sess->tport->lport, "port_id %x close session\n", port_id);
 	ft_sess_unhash(sess);
 	mutex_unlock(&ft_lport_lock);
 	ft_close_sess(sess);
@@ -380,8 +390,13 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 		if (!(fcp_parm & FCP_SPPF_INIT_FCN))
 			return FC_SPP_RESP_CONF;
 		sess = ft_sess_create(tport, rdata->ids.port_id, rdata);
-		if (!sess)
-			return FC_SPP_RESP_RES;
+		if (IS_ERR(sess)) {
+			if (PTR_ERR(sess) == -EACCES) {
+				spp->spp_flags &= ~FC_SPP_EST_IMG_PAIR;
+				return FC_SPP_RESP_CONF;
+			} else
+				return FC_SPP_RESP_RES;
+		}
 		if (!sess->params)
 			rdata->prli_count++;
 		sess->params = fcp_parm;
@@ -424,8 +439,8 @@ static int ft_prli(struct fc_rport_priv *rdata, u32 spp_len,
 	mutex_lock(&ft_lport_lock);
 	ret = ft_prli_locked(rdata, spp_len, rspp, spp);
 	mutex_unlock(&ft_lport_lock);
-	pr_debug("port_id %x flags %x ret %x\n",
-	       rdata->ids.port_id, rspp ? rspp->spp_flags : 0, ret);
+	TFC_SESS_DBG(rdata->local_port, "port_id %x flags %x ret %x\n",
+		     rdata->ids.port_id, rspp ? rspp->spp_flags : 0, ret);
 	return ret;
 }
 
@@ -478,11 +493,11 @@ static void ft_recv(struct fc_lport *lport, struct fc_frame *fp)
 	struct ft_sess *sess;
 	u32 sid = fc_frame_sid(fp);
 
-	pr_debug("sid %x\n", sid);
+	TFC_SESS_DBG(lport, "recv sid %x\n", sid);
 
 	sess = ft_sess_get(lport, sid);
 	if (!sess) {
-		pr_debug("sid %x sess lookup failed\n", sid);
+		TFC_SESS_DBG(lport, "sid %x sess lookup failed\n", sid);
 		/* TBD XXX - if FCP_CMND, send PRLO */
 		fc_frame_free(fp);
 		return;
-- 
1.8.5.6

