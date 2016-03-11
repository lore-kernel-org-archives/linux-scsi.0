From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 09/14] usb-gadget/tcm: Conversion to percpu_ida tag pre-allocation
Date: Fri, 11 Mar 2016 06:30:05 +0000
Message-ID: <1457677810-2478-10-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts usb-gadget target to use percpu_ida tag
pre-allocation for struct usbg_cmd descriptor, in order to
avoid fast-path struct usbg_cmd memory allocations.

Note by default this is currently hardcoded to 128.

Tested-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/usb/gadget/function/f_tcm.c | 97 ++++++++++++++++++++++---------------
 drivers/usb/gadget/function/tcm.h   |  2 +
 2 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index e803724..cd2ef37 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1073,39 +1073,66 @@ out:
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
+	memset(cmd, 0, sizeof(*cmd));
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
@@ -1117,12 +1144,6 @@ static int usbg_submit_command(struct f_uas *fu,
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
@@ -1148,7 +1169,7 @@ static int usbg_submit_command(struct f_uas *fu,
 
 	return 0;
 err:
-	kfree(cmd);
+	usbg_release_cmd(&cmd->se_cmd);
 	return -EINVAL;
 }
 
@@ -1190,7 +1211,7 @@ static int bot_submit_command(struct f_uas *fu,
 {
 	struct bulk_cb_wrap *cbw = cmdbuf;
 	struct usbg_cmd *cmd;
-	struct usbg_tpg *tpg;
+	struct usbg_tpg *tpg = fu->tpg;
 	struct tcm_usbg_nexus *tv_nexus;
 	u32 cmd_len;
 
@@ -1207,28 +1228,25 @@ static int bot_submit_command(struct f_uas *fu,
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
@@ -1239,9 +1257,6 @@ static int bot_submit_command(struct f_uas *fu,
 	queue_work(tpg->workqueue, &cmd->work);
 
 	return 0;
-err:
-	kfree(cmd);
-	return -EINVAL;
 }
 
 /* Start fabric.c code */
@@ -1294,8 +1309,10 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
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
@@ -1607,7 +1624,9 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 		goto out_unlock;
 	}
 
-	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, 0, 0,
+	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg,
+						     USB_G_DEFAULT_SESSION_TAGS,
+						     sizeof(struct usbg_cmd),
 						     TARGET_PROT_NORMAL, name,
 						     tv_nexus, usbg_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
diff --git a/drivers/usb/gadget/function/tcm.h b/drivers/usb/gadget/function/tcm.h
index b75c6f3..a27e6e3 100644
--- a/drivers/usb/gadget/function/tcm.h
+++ b/drivers/usb/gadget/function/tcm.h
@@ -23,6 +23,8 @@ enum {
 #define USB_G_ALT_INT_BBB       0
 #define USB_G_ALT_INT_UAS       1
 
+#define USB_G_DEFAULT_SESSION_TAGS	128
+
 struct tcm_usbg_nexus {
 	struct se_session *tvn_se_sess;
 };
-- 
1.9.1
