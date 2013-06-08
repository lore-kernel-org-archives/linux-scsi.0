From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Add transport_init_session_tagpool using per-cpu command map
Date: Sat,  8 Jun 2013 02:42:17 +0000
Message-ID: <1370659338-23841-3-git-send-email-nab@linux-iscsi.org>
References: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57550 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3FHCzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 22:55:50 -0400
In-Reply-To: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds lib/tag.c based transport_init_session_tagpool() logic
that allows fabric drivers to setup a per-cpu se_sess->sess_tag_pool
and associated se_sess->sess_cmd_map for basic tagged pre-allocation
of fabric descriptor sized memory.

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Asias He <asias@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   33 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    5 ++++
 include/target/target_core_fabric.h    |    1 +
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index abb7e40..4715f97 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,6 +228,35 @@ struct se_session *transport_init_session(void)
 }
 EXPORT_SYMBOL(transport_init_session);
 
+struct se_session *transport_init_session_tagpool(unsigned int tag_num,
+					          unsigned int tag_size)
+{
+	struct se_session *se_sess;
+	int rc;
+
+	se_sess = transport_init_session();
+	if (IS_ERR(se_sess))
+		return se_sess;
+
+	se_sess->sess_cmd_map = kzalloc(tag_num * tag_size, GFP_KERNEL);
+	if (!se_sess->sess_cmd_map) {
+		pr_err("Unable to allocate se_sess->sess_cmd_map\n");
+		transport_free_session(se_sess);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rc = tag_pool_init(&se_sess->sess_tag_pool, tag_num);
+	if (rc < 0) {
+		pr_err("Unable to init se_sess->sess_tag_pool,"
+			" tag_num: %u\n", tag_num);
+		transport_free_session(se_sess);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return se_sess;
+}
+EXPORT_SYMBOL(transport_init_session_tagpool);
+
 /*
  * Called with spin_lock_irqsave(&struct se_portal_group->session_lock called.
  */
@@ -363,6 +392,10 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 
 void transport_free_session(struct se_session *se_sess)
 {
+	if (se_sess->sess_cmd_map) {
+		tag_pool_free(&se_sess->sess_tag_pool);
+		kfree(se_sess->sess_cmd_map);
+	}
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a5c97db..8afd995 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -5,6 +5,7 @@
 #include <linux/configfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
+#include <linux/tags.h>
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -422,6 +423,8 @@ struct se_cmd {
 	enum dma_data_direction	data_direction;
 	/* For SAM Task Attribute */
 	int			sam_task_attr;
+	/* Used for se_sess->sess_tag_pool */
+	unsigned int		map_tag;
 	/* Transport protocol dependent state, see transport_state_table */
 	enum transport_state_table t_state;
 	unsigned		cmd_wait_set:1;
@@ -542,6 +545,8 @@ struct se_session {
 	struct list_head	sess_cmd_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
+	void			*sess_cmd_map;
+	struct tag_pool		sess_tag_pool;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index ba3471b..318520b 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -84,6 +84,7 @@ struct target_core_fabric_ops {
 };
 
 struct se_session *transport_init_session(void);
+struct se_session *transport_init_session_tagpool(unsigned int, unsigned int);
 void	__transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 void	transport_register_session(struct se_portal_group *,
-- 
1.7.2.5

