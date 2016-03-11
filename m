From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 10/14] usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs
Date: Fri, 11 Mar 2016 06:30:06 +0000
Message-ID: <1457677810-2478-11-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35208 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbcCKGet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 01:34:49 -0500
Received: by mail-oi0-f54.google.com with SMTP id c203so78906926oia.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 22:34:49 -0800 (PST)
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops struct usbg_cmd->kref internal kref-erence
usage, for proper TARGET_SCF_ACK_KREF conversion.

Tested-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/usb/gadget/function/f_tcm.c | 51 ++++++++-----------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index cd2ef37..7e7227b 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -41,13 +41,6 @@ static inline struct f_uas *to_f_uas(struct usb_function *f)
 	return container_of(f, struct f_uas, function);
 }
 
-static void usbg_cmd_release(struct kref *);
-
-static inline void usbg_cleanup_cmd(struct usbg_cmd *cmd)
-{
-	kref_put(&cmd->ref, usbg_cmd_release);
-}
-
 /* Start bot.c code */
 
 static int bot_enqueue_cmd_cbw(struct f_uas *fu)
@@ -68,7 +61,7 @@ static void bot_status_complete(struct usb_ep *ep, struct usb_request *req)
 	struct usbg_cmd *cmd = req->context;
 	struct f_uas *fu = cmd->fu;
 
-	usbg_cleanup_cmd(cmd);
+	transport_generic_free_cmd(&cmd->se_cmd, 0);
 	if (req->status < 0) {
 		pr_err("ERR %s(%d)\n", __func__, __LINE__);
 		return;
@@ -605,7 +598,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 		break;
 
 	case UASP_QUEUE_COMMAND:
-		usbg_cleanup_cmd(cmd);
+		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		usb_ep_queue(fu->ep_cmd, fu->cmd.req, GFP_ATOMIC);
 		break;
 
@@ -615,7 +608,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 	return;
 
 cleanup:
-	usbg_cleanup_cmd(cmd);
+	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static int uasp_send_status_response(struct usbg_cmd *cmd)
@@ -977,7 +970,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 	return;
 
 cleanup:
-	usbg_cleanup_cmd(cmd);
+	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
@@ -1046,7 +1039,7 @@ static void usbg_cmd_work(struct work_struct *work)
 	struct se_cmd *se_cmd;
 	struct tcm_usbg_nexus *tv_nexus;
 	struct usbg_tpg *tpg;
-	int dir;
+	int dir, flags = (TARGET_SCF_UNKNOWN_SIZE | TARGET_SCF_ACK_KREF);
 
 	se_cmd = &cmd->se_cmd;
 	tpg = cmd->fu->tpg;
@@ -1060,9 +1053,9 @@ static void usbg_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-			0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE) < 0)
+	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
+			      cmd->sense_iu.sense, cmd->unpacked_lun, 0,
+			      cmd->prio_attr, dir, flags) < 0)
 		goto out;
 
 	return;
@@ -1070,7 +1063,7 @@ static void usbg_cmd_work(struct work_struct *work)
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	usbg_cleanup_cmd(cmd);
+	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1126,11 +1119,6 @@ static int usbg_submit_command(struct f_uas *fu,
 		pr_err("usbg_get_cmd failed\n");
 		return -ENOMEM;
 	}
-
-	/* XXX until I figure out why I can't free in on complete */
-	kref_init(&cmd->ref);
-	kref_get(&cmd->ref);
-
 	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
 
 	if (fu->flags & USBG_USE_STREAMS) {
@@ -1203,7 +1191,7 @@ static void bot_cmd_work(struct work_struct *work)
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	usbg_cleanup_cmd(cmd);
+	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,
@@ -1239,11 +1227,6 @@ static int bot_submit_command(struct f_uas *fu,
 		pr_err("usbg_get_cmd failed\n");
 		return -ENOMEM;
 	}
-
-	/* XXX until I figure out why I can't free in on complete */
-	kref_init(&cmd->ref);
-	kref_get(&cmd->ref);
-
 	memcpy(cmd->cmd_buf, cbw->CDB, cmd_len);
 
 	cmd->bot_tag = cbw->Tag;
@@ -1297,14 +1280,6 @@ static u32 usbg_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static void usbg_cmd_release(struct kref *ref)
-{
-	struct usbg_cmd *cmd = container_of(ref, struct usbg_cmd,
-			ref);
-
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
-}
-
 static void usbg_release_cmd(struct se_cmd *se_cmd)
 {
 	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd,
@@ -1745,11 +1720,7 @@ static void usbg_port_unlink(struct se_portal_group *se_tpg,
 
 static int usbg_check_stop_free(struct se_cmd *se_cmd)
 {
-	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd,
-			se_cmd);
-
-	kref_put(&cmd->ref, usbg_cmd_release);
-	return 1;
+	return target_put_sess_cmd(se_cmd);
 }
 
 static const struct target_core_fabric_ops usbg_ops = {
-- 
1.9.1

