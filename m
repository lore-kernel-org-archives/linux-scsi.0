From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 07/14] sbp-target: Conversion to percpu_ida tag pre-allocation
Date: Sat, 30 Jan 2016 07:05:51 +0000
Message-ID: <1454137558-30396-8-git-send-email-nab@daterainc.com>
References: <1454137558-30396-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454137558-30396-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Chris Boot <bootc@bootc.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/sbp_target.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index ddd3398..756e87f 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -209,8 +209,10 @@ static struct sbp_session *sbp_session_create(
 	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
 	sess->guid = guid;
 
-	sess->se_sess = target_alloc_session(&tpg->se_tpg, 0, 0, TARGET_PROT_NORMAL,
-					     guid_str, sess, NULL);
+	sess->se_sess = target_alloc_session(&tpg->se_tpg, 128,
+					     sizeof(struct sbp_target_request),
+					     TARGET_PROT_NORMAL, guid_str,
+					     sess, NULL);
 	if (IS_ERR(sess->se_sess)) {
 		pr_err("failed to init se_session\n");
 		ret = PTR_ERR(sess->se_sess);
@@ -921,6 +923,24 @@ static inline bool tgt_agent_check_active(struct sbp_target_agent *agent)
 	return active;
 }
 
+static struct sbp_target_request *sbp_mgt_get_req(struct sbp_session *sess,
+	struct fw_card *card, u64 next_orb)
+{
+	struct se_session *se_sess = sess->se_sess;
+	struct sbp_target_request *req;
+	int tag;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	if (tag < 0)
+		return ERR_PTR(-ENOMEM);
+
+	req = &((struct sbp_target_request *)se_sess->sess_cmd_map)[tag];
+	req->se_cmd.map_tag = tag;
+	req->se_cmd.tag = next_orb;
+
+	return req;
+}
+
 static void tgt_agent_fetch_work(struct work_struct *work)
 {
 	struct sbp_target_agent *agent =
@@ -932,7 +952,7 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 	u64 next_orb = agent->orb_pointer;
 
 	while (next_orb && tgt_agent_check_active(agent)) {
-		req = kzalloc(sizeof(*req), GFP_KERNEL);
+		req = sbp_mgt_get_req(sess, sess->card, next_orb);
 		if (!req) {
 			spin_lock_bh(&agent->lock);
 			agent->state = AGENT_STATE_DEAD;
@@ -1430,9 +1450,13 @@ static int sbp_send_sense(struct sbp_target_request *req)
 
 static void sbp_free_request(struct sbp_target_request *req)
 {
+	struct se_cmd *se_cmd = &req->se_cmd;
+	struct se_session *se_sess = se_cmd->se_sess;
+
 	kfree(req->pg_tbl);
 	kfree(req->cmd_buf);
-	kfree(req);
+
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 static void sbp_mgt_agent_process(struct work_struct *work)
@@ -1592,8 +1616,12 @@ static void sbp_mgt_agent_rw(struct fw_card *card,
 			rcode = RCODE_CONFLICT_ERROR;
 			goto out;
 		}
-
+		// XXX:
+#if 0
+		req = sbp_mgt_get_req(agent->login->sess, card);
+#else
 		req = kzalloc(sizeof(*req), GFP_ATOMIC);
+#endif
 		if (!req) {
 			rcode = RCODE_CONFLICT_ERROR;
 			goto out;
-- 
1.9.1
