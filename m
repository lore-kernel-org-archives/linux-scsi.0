From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 2/4] ib_srpt: Convert acl lookup to modern get_initiator_node_acl usage
Date: Sun, 10 Jan 2016 20:28:42 +0000
Message-ID: <1452457724-10629-3-git-send-email-nab@daterainc.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35347 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbcAJUa6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2016 15:30:58 -0500
Received: by mail-oi0-f52.google.com with SMTP id p187so22886264oia.2
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jan 2016 12:30:58 -0800 (PST)
In-Reply-To: <1452457724-10629-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch does a simple conversion of ib_srpt code to use
proper modern core_tpg_get_initiator_node_acl() lookup using
se_node_acl->acl_kref, and drops the legacy internal list
usage from srpt_lookup_acl().

This involves doing transport_init_session() earlier, and
making sure transport_free_session() is called during
a se_node_acl lookup failure to drop the last ->acl_kref.

Also, it adds a minor backwards-compat hack to avoid the
potential for user-space wrt node-acl WWPN formatting by
simply stripping off '0x' prefix from ch->sess_name, and
retrying once if core_tpg_get_initiator_node_acl() fails.

Finally, go ahead and drop port_acl_list port_acl_lock
since they are no longer used.

Cc: Vu Pham <vu@mellanox.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 95 +++++++++++------------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 -
 2 files changed, 30 insertions(+), 67 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2e2fe81..2ef6466 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2370,31 +2370,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 	kfree(ch);
 }
 
-static struct srpt_node_acl *__srpt_lookup_acl(struct srpt_port *sport,
-					       u8 i_port_id[16])
-{
-	struct srpt_node_acl *nacl;
-
-	list_for_each_entry(nacl, &sport->port_acl_list, list)
-		if (memcmp(nacl->i_port_id, i_port_id,
-			   sizeof(nacl->i_port_id)) == 0)
-			return nacl;
-
-	return NULL;
-}
-
-static struct srpt_node_acl *srpt_lookup_acl(struct srpt_port *sport,
-					     u8 i_port_id[16])
-{
-	struct srpt_node_acl *nacl;
-
-	spin_lock_irq(&sport->port_acl_lock);
-	nacl = __srpt_lookup_acl(sport, i_port_id);
-	spin_unlock_irq(&sport->port_acl_lock);
-
-	return nacl;
-}
-
 /**
  * srpt_cm_req_recv() - Process the event IB_CM_REQ_RECEIVED.
  *
@@ -2412,10 +2387,10 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srp_login_rej *rej;
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
-	struct srpt_node_acl *nacl;
+	struct se_node_acl *se_acl;
 	u32 it_iu_len;
-	int i;
-	int ret = 0;
+	int i, ret = 0;
+	unsigned char *p;
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -2565,33 +2540,47 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		       " RTR failed (error code = %d)\n", ret);
 		goto destroy_ib;
 	}
+
 	/*
-	 * Use the initator port identifier as the session name.
+	 * Use the initator port identifier as the session name, when
+	 * checking against se_node_acl->initiatorname[] this can be
+	 * with or without preceeding '0x'.
 	 */
 	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
 
 	pr_debug("registering session %s\n", ch->sess_name);
+	p = &ch->sess_name[0];
 
-	nacl = srpt_lookup_acl(sport, ch->i_port_id);
-	if (!nacl) {
-		pr_info("Rejected login because no ACL has been"
-			" configured yet for initiator %s.\n", ch->sess_name);
+	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
+	if (IS_ERR(ch->sess)) {
 		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
+				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_debug("Failed to create session\n");
 		goto destroy_ib;
 	}
 
-	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
-	if (IS_ERR(ch->sess)) {
+try_again:
+	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, p);
+	if (!se_acl) {
+		pr_info("Rejected login because no ACL has been"
+			" configured yet for initiator %s.\n", ch->sess_name);
+		/*
+		 * XXX: Hack to retry of ch->i_port_id without leading '0x'
+		 */
+		if (p == &ch->sess_name[0]) {
+			p += 2;
+			goto try_again;
+		}
 		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_debug("Failed to create session\n");
-		goto deregister_session;
+				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
+		transport_free_session(ch->sess);
+		goto destroy_ib;
 	}
-	ch->sess->se_node_acl = &nacl->nacl;
-	transport_register_session(&sport->port_tpg_1, &nacl->nacl, ch->sess, ch);
+	ch->sess->se_node_acl = se_acl;
+
+	transport_register_session(&sport->port_tpg_1, se_acl, ch->sess, ch);
 
 	pr_debug("Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
 		 ch->sess_name, ch->cm_id);
@@ -2635,8 +2624,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 release_channel:
 	srpt_set_ch_state(ch, CH_RELEASING);
 	transport_deregister_session_configfs(ch->sess);
-
-deregister_session:
 	transport_deregister_session(ch->sess);
 	ch->sess = NULL;
 
@@ -3273,8 +3260,6 @@ static void srpt_add_one(struct ib_device *device)
 		sport->port_attrib.srp_max_rsp_size = DEFAULT_MAX_RSP_SIZE;
 		sport->port_attrib.srp_sq_size = DEF_SRPT_SQ_SIZE;
 		INIT_WORK(&sport->work, srpt_refresh_port_work);
-		INIT_LIST_HEAD(&sport->port_acl_list);
-		spin_lock_init(&sport->port_acl_lock);
 
 		if (srpt_refresh_port(sport)) {
 			pr_err("MAD registration failed for %s-%d.\n",
@@ -3522,28 +3507,9 @@ static int srpt_init_nodeacl(struct se_node_acl *se_nacl, const char *name)
 	memcpy(&nacl->i_port_id[0], &i_port_id[0], 16);
 	nacl->sport = sport;
 
-	spin_lock_irq(&sport->port_acl_lock);
-	list_add_tail(&nacl->list, &sport->port_acl_list);
-	spin_unlock_irq(&sport->port_acl_lock);
-
 	return 0;
 }
 
-/*
- * configfs callback function invoked for
- * rmdir /sys/kernel/config/target/$driver/$port/$tpg/acls/$i_port_id
- */
-static void srpt_cleanup_nodeacl(struct se_node_acl *se_nacl)
-{
-	struct srpt_node_acl *nacl =
-		container_of(se_nacl, struct srpt_node_acl, nacl);
-	struct srpt_port *sport = nacl->sport;
-
-	spin_lock_irq(&sport->port_acl_lock);
-	list_del(&nacl->list);
-	spin_unlock_irq(&sport->port_acl_lock);
-}
-
 static ssize_t srpt_tpg_attrib_srp_max_rdma_size_show(struct config_item *item,
 		char *page)
 {
@@ -3820,7 +3786,6 @@ static const struct target_core_fabric_ops srpt_template = {
 	.fabric_make_tpg		= srpt_make_tpg,
 	.fabric_drop_tpg		= srpt_drop_tpg,
 	.fabric_init_nodeacl		= srpt_init_nodeacl,
-	.fabric_cleanup_nodeacl		= srpt_cleanup_nodeacl,
 
 	.tfc_wwn_attrs			= srpt_wwn_attrs,
 	.tfc_tpg_base_attrs		= srpt_tpg_attrs,
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 5faad8ac..bb4fbe2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -364,11 +364,9 @@ struct srpt_port {
 	u16			sm_lid;
 	u16			lid;
 	union ib_gid		gid;
-	spinlock_t		port_acl_lock;
 	struct work_struct	work;
 	struct se_portal_group	port_tpg_1;
 	struct se_wwn		port_wwn;
-	struct list_head	port_acl_list;
 	struct srpt_port_attrib port_attrib;
 };
 
-- 
1.9.1

