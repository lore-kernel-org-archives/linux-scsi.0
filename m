From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 09/12] usb-gadget/tcm: Conversion to percpu_ida tag pre-allocation
Date: Mon, 25 Jan 2016 08:11:03 +0000
Message-ID: <1453709466-6308-10-git-send-email-nab@daterainc.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33701 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbcAYIOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 03:14:10 -0500
Received: by mail-ob0-f180.google.com with SMTP id is5so109902939obc.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2016 00:14:10 -0800 (PST)
In-Reply-To: <1453709466-6308-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/usb/gadget/function/f_tcm.c | 95 ++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 2e8b91d..8773572 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1073,39 +1073,65 @@ out:
 	usbg_cleanup_cmd(cmd);
 }
 
+static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
+		struct tcm_usbg_nexus *tv_nexus, u32 scsi_tag)
+{
+	struct se_session *se_sess = tv_nexus->tvn_se_sess;
+	struct usbg_cmd *cmd;
+	int tag;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	if (tag < 0)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = &((struct usbg_cmd *)se_sess->sess_cmd_map)[tag];
+	cmd->se_cmd.map_tag = tag;
+	cmd->se_cmd.tag = cmd->tag = scsi_tag;
+	cmd->fu = fu;
+
+	return cmd;
+}
+
+static void usbg_release_cmd(struct se_cmd *);
+
 static int usbg_submit_command(struct f_uas *fu,
 		void *cmdbuf, unsigned int len)
 {
 	struct command_iu *cmd_iu = cmdbuf;
 	struct usbg_cmd *cmd;
-	struct usbg_tpg *tpg;
-	struct tcm_usbg_nexus *tv_nexus;
+	struct usbg_tpg *tpg = fu->tpg;
+	struct tcm_usbg_nexus *tv_nexus = tpg->tpg_nexus;
 	u32 cmd_len;
+	u16 scsi_tag;
 
 	if (cmd_iu->iu_id != IU_ID_COMMAND) {
 		pr_err("Unsupported type %d\n", cmd_iu->iu_id);
 		return -EINVAL;
 	}
 
-	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
-	if (!cmd)
-		return -ENOMEM;
+	tv_nexus = tpg->tpg_nexus;
+	if (!tv_nexus) {
+		pr_err("Missing nexus, ignoring command\n");
+		return -EINVAL;
+	}
 
-	cmd->fu = fu;
+	cmd_len = (cmd_iu->len & ~0x3) + 16;
+	if (cmd_len > USBG_MAX_CMD)
+		return -EINVAL;
+
+	scsi_tag = be16_to_cpup(&cmd_iu->tag);
+	cmd = usbg_get_cmd(fu, tv_nexus, scsi_tag);
+	if (IS_ERR(cmd)) {
+		pr_err("usbg_get_cmd failed\n");
+		return -ENOMEM;
+	}
 
 	/* XXX until I figure out why I can't free in on complete */
 	kref_init(&cmd->ref);
 	kref_get(&cmd->ref);
 
-	tpg = fu->tpg;
-	cmd_len = (cmd_iu->len & ~0x3) + 16;
-	if (cmd_len > USBG_MAX_CMD)
-		goto err;
-
 	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
 
-	cmd->tag = be16_to_cpup(&cmd_iu->tag);
-	cmd->se_cmd.tag = cmd->tag;
 	if (fu->flags & USBG_USE_STREAMS) {
 		if (cmd->tag > UASP_SS_EP_COMP_NUM_STREAMS)
 			goto err;
@@ -1117,12 +1143,6 @@ static int usbg_submit_command(struct f_uas *fu,
 		cmd->stream = &fu->stream[0];
 	}
 
-	tv_nexus = tpg->tpg_nexus;
-	if (!tv_nexus) {
-		pr_err("Missing nexus, ignoring command\n");
-		goto err;
-	}
-
 	switch (cmd_iu->prio_attr & 0x7) {
 	case UAS_HEAD_TAG:
 		cmd->prio_attr = TCM_HEAD_TAG;
@@ -1148,7 +1168,7 @@ static int usbg_submit_command(struct f_uas *fu,
 
 	return 0;
 err:
-	kfree(cmd);
+	usbg_release_cmd(&cmd->se_cmd);
 	return -EINVAL;
 }
 
@@ -1190,7 +1210,7 @@ static int bot_submit_command(struct f_uas *fu,
 {
 	struct bulk_cb_wrap *cbw = cmdbuf;
 	struct usbg_cmd *cmd;
-	struct usbg_tpg *tpg;
+	struct usbg_tpg *tpg = fu->tpg;
 	struct tcm_usbg_nexus *tv_nexus;
 	u32 cmd_len;
 
@@ -1207,28 +1227,25 @@ static int bot_submit_command(struct f_uas *fu,
 	if (cmd_len < 1 || cmd_len > 16)
 		return -EINVAL;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
-	if (!cmd)
-		return -ENOMEM;
+	tv_nexus = tpg->tpg_nexus;
+	if (!tv_nexus) {
+		pr_err("Missing nexus, ignoring command\n");
+		return -ENODEV;
+	}
 
-	cmd->fu = fu;
+	cmd = usbg_get_cmd(fu, tv_nexus, cbw->Tag);
+	if (IS_ERR(cmd)) {
+		pr_err("usbg_get_cmd failed\n");
+		return -ENOMEM;
+	}
 
 	/* XXX until I figure out why I can't free in on complete */
 	kref_init(&cmd->ref);
 	kref_get(&cmd->ref);
 
-	tpg = fu->tpg;
-
 	memcpy(cmd->cmd_buf, cbw->CDB, cmd_len);
 
 	cmd->bot_tag = cbw->Tag;
-
-	tv_nexus = tpg->tpg_nexus;
-	if (!tv_nexus) {
-		pr_err("Missing nexus, ignoring command\n");
-		goto err;
-	}
-
 	cmd->prio_attr = TCM_SIMPLE_TAG;
 	cmd->unpacked_lun = cbw->Lun;
 	cmd->is_read = cbw->Flags & US_BULK_FLAG_IN ? 1 : 0;
@@ -1239,9 +1256,6 @@ static int bot_submit_command(struct f_uas *fu,
 	queue_work(tpg->workqueue, &cmd->work);
 
 	return 0;
-err:
-	kfree(cmd);
-	return -EINVAL;
 }
 
 /* Start fabric.c code */
@@ -1294,8 +1308,10 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
 {
 	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd,
 			se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
+
 	kfree(cmd->data_buf);
-	kfree(cmd);
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 static int usbg_shutdown_session(struct se_session *se_sess)
@@ -1597,7 +1613,8 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 		goto out_unlock;
 	}
 
-	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, 0, 0,
+	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, 128,
+						     sizeof(struct usbg_cmd),
 						     TARGET_PROT_NORMAL, name,
 						     tv_nexus, NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
-- 
1.9.1

