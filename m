From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-for-4.6 6/6] ib_srpt: Convert to target_alloc_session usage
Date: Sun, 10 Jan 2016 20:44:28 +0000
Message-ID: <1452458668-11034-7-git-send-email-nab@daterainc.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Vu Pham <vu@mellanox.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2ef6466..44878a3 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2387,7 +2387,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srp_login_rej *rej;
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
-	struct se_node_acl *se_acl;
 	u32 it_iu_len;
 	int i, ret = 0;
 	unsigned char *p;
@@ -2553,19 +2552,12 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	pr_debug("registering session %s\n", ch->sess_name);
 	p = &ch->sess_name[0];
 
-	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
-	if (IS_ERR(ch->sess)) {
-		rej->reason = cpu_to_be32(
-				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_debug("Failed to create session\n");
-		goto destroy_ib;
-	}
-
 try_again:
-	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, p);
-	if (!se_acl) {
+	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+					TARGET_PROT_NORMAL, p, ch, NULL);
+	if (IS_ERR(ch->sess)) {
 		pr_info("Rejected login because no ACL has been"
-			" configured yet for initiator %s.\n", ch->sess_name);
+			" configured yet for initiator %s.\n", p);
 		/*
 		 * XXX: Hack to retry of ch->i_port_id without leading '0x'
 		 */
@@ -2573,14 +2565,11 @@ try_again:
 			p += 2;
 			goto try_again;
 		}
-		rej->reason = cpu_to_be32(
+		rej->reason = cpu_to_be32((PTR_ERR(ch->sess) == -ENOMEM) ?
+				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES :
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
-		transport_free_session(ch->sess);
 		goto destroy_ib;
 	}
-	ch->sess->se_node_acl = se_acl;
-
-	transport_register_session(&sport->port_tpg_1, se_acl, ch->sess, ch);
 
 	pr_debug("Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
 		 ch->sess_name, ch->cm_id);
-- 
1.9.1
