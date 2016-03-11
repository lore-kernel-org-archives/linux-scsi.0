From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 07/14] sbp-target: Conversion to percpu_ida tag pre-allocation
Date: Fri, 11 Mar 2016 06:30:03 +0000
Message-ID: <1457677810-2478-8-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33883 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbcCKGem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 01:34:42 -0500
Received: by mail-oi0-f50.google.com with SMTP id m82so78982116oif.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 22:34:42 -0800 (PST)
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts sbp-target to use struct sbp_target_request
descriptor tag pre-allocation using percpu_ida.

(Fix sbp_mgt_get_req() IS_ERR failure checking - Dan Carpenter)
(Add missing sbp_target_request tag memset - Chris Boot)

Acked-by: Chris Boot <bootc@bootc.net>
Tested-by: Chris Boot <bootc@bootc.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/sbp_target.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index ddd3398..627044f2 100644
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
@@ -921,6 +923,25 @@ static inline bool tgt_agent_check_active(struct sbp_target_agent *agent)
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
+	memset(req, 0, sizeof(*req));
+	req->se_cmd.map_tag = tag;
+	req->se_cmd.tag = next_orb;
+
+	return req;
+}
+
 static void tgt_agent_fetch_work(struct work_struct *work)
 {
 	struct sbp_target_agent *agent =
@@ -932,8 +953,8 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 	u64 next_orb = agent->orb_pointer;
 
 	while (next_orb && tgt_agent_check_active(agent)) {
-		req = kzalloc(sizeof(*req), GFP_KERNEL);
-		if (!req) {
+		req = sbp_mgt_get_req(sess, sess->card, next_orb);
+		if (IS_ERR(req)) {
 			spin_lock_bh(&agent->lock);
 			agent->state = AGENT_STATE_DEAD;
 			spin_unlock_bh(&agent->lock);
@@ -1430,9 +1451,13 @@ static int sbp_send_sense(struct sbp_target_request *req)
 
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
@@ -1592,7 +1617,6 @@ static void sbp_mgt_agent_rw(struct fw_card *card,
 			rcode = RCODE_CONFLICT_ERROR;
 			goto out;
 		}
-
 		req = kzalloc(sizeof(*req), GFP_ATOMIC);
 		if (!req) {
 			rcode = RCODE_CONFLICT_ERROR;
-- 
1.9.1

