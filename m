From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper function
Date: Sun, 10 Jan 2016 20:44:23 +0000
Message-ID: <1452458668-11034-2-git-send-email-nab@daterainc.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35526 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbcAJUql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2016 15:46:41 -0500
Received: by mail-ob0-f182.google.com with SMTP id py5so17099864obc.2
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jan 2016 12:46:41 -0800 (PST)
In-Reply-To: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Based on HCH's original patch, this adds a full version to
support percpu-ida tag pre-allocation and callback function
pointer into fabric driver code to complete session setup.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 55 ++++++++++++++++++++++++++++++++++
 include/target/target_core_fabric.h    |  6 ++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c5035b9..fd4404f6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -374,6 +374,61 @@ void transport_register_session(
 }
 EXPORT_SYMBOL(transport_register_session);
 
+struct se_session *
+target_alloc_session(struct se_portal_group *tpg,
+		     unsigned int tag_num, unsigned int tag_size,
+		     enum target_prot_op prot_op,
+		     const char *initiatorname, void *private,
+		     int (*callback)(struct se_portal_group *,
+				     struct se_session *, void *))
+{
+	struct se_session *sess;
+
+	if (tag_num != 0 && !tag_size) {
+		pr_err("target_alloc_session called with percpu-ida tag_num:"
+		       " %u, but zero tag_size\n", tag_num);
+		return ERR_PTR(-EINVAL);
+	}
+	if (!tag_num && tag_size) {
+		pr_err("target_alloc_session called with percpu-ida tag_size:"
+		       " %u, but zero tag_num\n", tag_size);
+		return ERR_PTR(-EINVAL);
+	}
+	/*
+	 * If the fabric driver is using percpu-ida based pre allocation
+	 * of I/O descriptor tags, go ahead and perform that setup now..
+	 */
+	if (tag_num != 0)
+		sess = transport_init_session_tags(tag_num, tag_size, prot_op);
+	else
+		sess = transport_init_session(prot_op);
+
+	if (IS_ERR(sess))
+		return sess;
+
+	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
+					(unsigned char *)initiatorname);
+	if (!sess->se_node_acl) {
+		transport_free_session(sess);
+		return ERR_PTR(-EACCES);
+	}
+	/*
+	 * Go ahead and perform any remaining fabric setup that is
+	 * required before transport_register_session().
+	 */
+	if (callback != NULL) {
+		int rc = callback(tpg, sess, private);
+		if (rc) {
+			transport_free_session(sess);
+			return ERR_PTR(rc);
+		}
+	}
+
+	transport_register_session(tpg, sess->se_node_acl, sess, private);
+	return sess;
+}
+EXPORT_SYMBOL(target_alloc_session);
+
 static void target_release_session(struct kref *kref)
 {
 	struct se_session *se_sess = container_of(kref,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index dc6b09e..7d59273 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -108,6 +108,12 @@ void target_unregister_template(const struct target_core_fabric_ops *fo);
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
 
+struct se_session *target_alloc_session(struct se_portal_group *,
+		unsigned int, unsigned int, enum target_prot_op prot_op,
+		const char *, void *,
+		int (*callback)(struct se_portal_group *,
+				struct se_session *, void *));
+
 struct se_session *transport_init_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
1.9.1

