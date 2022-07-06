Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE78CCA47C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiGFXiI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiGFXiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:38:04 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397472CCAF;
        Wed,  6 Jul 2022 16:38:03 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1A4844077F;
        Wed,  6 Jul 2022 23:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150683; bh=Q6RKjzlpKY/DTJrLNk3ezhXEqIY0VjZFy7Ipg44oqLA=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=TgPcVvdyv8RE0Mjxd3NN1HzRELvzRUuixCLdeLvBE97dgEp/hiKucjdGfsWBIwSUG
         uTW36zWkz9lpxf2hDVfPED4Qk9jr49Kk1kkvoM/ANQvswpciJChHGBI85d80xZJHHP
         xyteju73wfICiLMH7r1Xe35mFu0npkV7keTddhx0/GwF4GwOAvATawPUUzz2HPLLef
         lYgH0gt4VsNvbQWhkcGkQAWHzuWUSfJA8N0k2Jwd4AMFWMGqChonbQFkQ+nCmXqgVL
         HrjjH28Ku4JOFamGjGY1n1Kwm6X2cPGwKhtu7Yr8whEyDpQOx5vPES02vRHIJ67eqC
         0CRjqDTy5ueTA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id E68AEA0063;
        Wed,  6 Jul 2022 23:38:01 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:38:01 -0700
Date:   Wed, 06 Jul 2022 16:38:01 -0700
Message-Id: <70aa4f59a7f9d9d0c770bf42a0723825fa564548.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 35/36] usb: gadget: f_tcm: Handle TASK_MANAGEMENT commands
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Handle target_core_fabric_ops TASK MANAGEMENT functions and their
response. If a TASK MANAGEMENT command is received, the driver will
interpret the function TMF_*, translate to TMR_*, and fire off a command
work executing target_submit_tmr(). On completion, it will handle the
TASK MANAGEMENT response through uasp_send_tm_response().

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
NOTE: I appologize for this big patch. I feel that this feature needs to be
viewed in its entirety to see the whole picture and easier review.


 drivers/usb/gadget/function/f_tcm.c | 260 +++++++++++++++++++++++++---
 drivers/usb/gadget/function/tcm.h   |   7 +-
 2 files changed, 241 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index fa09999adda7..a68436f97f91 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/configfs.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/composite.h>
 #include <linux/usb/gadget.h>
@@ -462,6 +463,53 @@ static int usbg_bot_setup(struct usb_function *f,
 
 /* Start uas.c code */
 
+static int tcm_to_uasp_response(enum tcm_tmrsp_table code)
+{
+	switch (code) {
+	case TMR_FUNCTION_FAILED:
+		return RC_TMF_FAILED;
+	case TMR_FUNCTION_COMPLETE:
+		return RC_TMF_COMPLETE;
+	case TMR_FUNCTION_REJECTED:
+		return RC_TMF_NOT_SUPPORTED;
+	case TMR_LUN_DOES_NOT_EXIST:
+		return RC_INCORRECT_LUN;
+	case TMR_OVERLAPPED_TAG_ATTEMPTED:
+		return RC_OVERLAPPED_TAG;
+	case TMR_TASK_DOES_NOT_EXIST:
+		return RC_INVALID_INFO_UNIT;
+	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
+	default:
+		return RC_TMF_NOT_SUPPORTED;
+	}
+}
+
+static unsigned char uasp_to_tcm_func(int code)
+{
+	switch (code) {
+	case TMF_ABORT_TASK:
+		return TMR_ABORT_TASK;
+	case TMF_ABORT_TASK_SET:
+		return TMR_ABORT_TASK_SET;
+	case TMF_CLEAR_TASK_SET:
+		return TMR_CLEAR_TASK_SET;
+	case TMF_LOGICAL_UNIT_RESET:
+		return TMR_LUN_RESET;
+	case TMF_I_T_NEXUS_RESET:
+		return TMR_I_T_NEXUS_RESET;
+	case TMF_CLEAR_ACA:
+		return TMR_CLEAR_ACA;
+	case TMF_QUERY_TASK:
+		return TMR_QUERY_TASK;
+	case TMF_QUERY_TASK_SET:
+		return TMR_QUERY_TASK_SET;
+	case TMF_QUERY_ASYNC_EVENT:
+		return TMR_QUERY_ASYNC_EVENT;
+	default:
+		return TMR_UNKNOWN;
+	}
+}
+
 static void uasp_cleanup_one_stream(struct f_uas *fu, struct uas_stream *stream)
 {
 	/* We have either all three allocated or none */
@@ -506,6 +554,11 @@ static void uasp_cleanup_old_alt(struct f_uas *fu)
 	uasp_free_cmdreq(fu);
 }
 
+static struct uas_stream *uasp_get_stream_by_tag(struct f_uas *fu, u16 tag)
+{
+	return &fu->stream[tag % USBG_NUM_CMDS];
+}
+
 static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req);
 
 static int uasp_prepare_r_request(struct usbg_cmd *cmd)
@@ -513,7 +566,7 @@ static int uasp_prepare_r_request(struct usbg_cmd *cmd)
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct f_uas *fu = cmd->fu;
 	struct usb_gadget *gadget = fuas_to_gadget(fu);
-	struct uas_stream *stream = cmd->stream;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
 
 	if (!gadget->sg_supported) {
 		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_ATOMIC);
@@ -546,7 +599,7 @@ static void uasp_prepare_status(struct usbg_cmd *cmd)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct sense_iu *iu = &cmd->sense_iu;
-	struct uas_stream *stream = cmd->stream;
+	struct uas_stream *stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
 
 	cmd->state = UASP_QUEUE_COMMAND;
 	iu->iu_id = IU_ID_STATUS;
@@ -565,11 +618,36 @@ static void uasp_prepare_status(struct usbg_cmd *cmd)
 	stream->req_status->complete = uasp_status_data_cmpl;
 }
 
+static void uasp_prepare_response(struct usbg_cmd *cmd)
+{
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct response_iu *rsp_iu = &cmd->response_iu;
+	struct uas_stream *stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
+
+	cmd->state = UASP_QUEUE_COMMAND;
+	rsp_iu->iu_id = IU_ID_RESPONSE;
+	rsp_iu->tag = cpu_to_be16(cmd->tag);
+
+	if (cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN)
+		rsp_iu->response_code =
+			tcm_to_uasp_response(cmd->tmr_rsp);
+	else
+		rsp_iu->response_code =
+			tcm_to_uasp_response(se_cmd->se_tmr_req->response);
+
+	stream->req_status->is_last = 1;
+	stream->req_status->stream_id = cmd->tag;
+	stream->req_status->context = cmd;
+	stream->req_status->length = sizeof(struct response_iu);
+	stream->req_status->buf = rsp_iu;
+	stream->req_status->complete = uasp_status_data_cmpl;
+}
+
 static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 {
 	struct usbg_cmd *cmd = req->context;
-	struct uas_stream *stream = cmd->stream;
 	struct f_uas *fu = cmd->fu;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
 	struct se_session *se_sess = cmd->se_cmd.se_sess;
 	int ret;
 
@@ -604,6 +682,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 		break;
 
 	case UASP_QUEUE_COMMAND:
+		stream->cmd = NULL;
 
 		target_free_tag(se_sess, &cmd->se_cmd);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -617,6 +696,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 	return;
 
 cleanup:
+	stream->cmd = NULL;
 	target_free_tag(se_sess, &cmd->se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
@@ -624,7 +704,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 static int uasp_send_status_response(struct usbg_cmd *cmd)
 {
 	struct f_uas *fu = cmd->fu;
-	struct uas_stream *stream = cmd->stream;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
 	struct sense_iu *iu = &cmd->sense_iu;
 
 	iu->tag = cpu_to_be16(cmd->tag);
@@ -633,10 +713,22 @@ static int uasp_send_status_response(struct usbg_cmd *cmd)
 	return usb_ep_queue(fu->ep_status, stream->req_status, GFP_ATOMIC);
 }
 
+static int uasp_send_tm_response(struct usbg_cmd *cmd)
+{
+	struct f_uas *fu = cmd->fu;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
+	struct response_iu *iu = &cmd->response_iu;
+
+	iu->tag = cpu_to_be16(cmd->tag);
+	cmd->fu = fu;
+	uasp_prepare_response(cmd);
+	return usb_ep_queue(fu->ep_status, stream->req_status, GFP_ATOMIC);
+}
+
 static int uasp_send_read_response(struct usbg_cmd *cmd)
 {
 	struct f_uas *fu = cmd->fu;
-	struct uas_stream *stream = cmd->stream;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
 	struct sense_iu *iu = &cmd->sense_iu;
 	int ret;
 
@@ -682,7 +774,7 @@ static int uasp_send_read_response(struct usbg_cmd *cmd)
 static int uasp_send_write_request(struct usbg_cmd *cmd)
 {
 	struct f_uas *fu = cmd->fu;
-	struct uas_stream *stream = cmd->stream;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
 	struct sense_iu *iu = &cmd->sense_iu;
 	int ret;
 
@@ -943,8 +1035,10 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 {
 	struct usbg_cmd *cmd = req->context;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct uas_stream *stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
 
 	if (req->status == -ESHUTDOWN) {
+		stream->cmd = NULL;
 		target_free_tag(se_cmd->se_sess, se_cmd);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		return;
@@ -962,6 +1056,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 				se_cmd->data_length);
 	}
 
+	cmd->state = UASP_QUEUE_COMMAND;
 	target_execute_cmd(se_cmd);
 	return;
 
@@ -1042,9 +1137,66 @@ static int usbg_send_read_response(struct se_cmd *se_cmd)
 		return uasp_send_read_response(cmd);
 }
 
-static void usbg_cmd_work(struct work_struct *work)
+static void usbg_submit_tmr(struct usbg_cmd *cmd)
+{
+	struct se_cmd *se_cmd;
+	struct tcm_usbg_nexus *tv_nexus;
+	struct uas_stream *stream;
+	int flags = TARGET_SCF_ACK_KREF;
+
+	se_cmd = &cmd->se_cmd;
+	tv_nexus = cmd->fu->tpg->tpg_nexus;
+	stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
+
+	/* Failure detected by f_tcm */
+	if (cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN) {
+		if (cmd->tmr_rsp == TMR_OVERLAPPED_TAG_ATTEMPTED) {
+			/*
+			 * There's no guarantee of a matching completion order
+			 * between different endpoints. i.e. The device may
+			 * receive a new (CDB) command request completion of the
+			 * command endpoint before it gets notified of the
+			 * previous command status completion from a status
+			 * endpoint. The driver still needs to detect
+			 * misbehaving host and respond with an overlap command
+			 * tag. To prevent false overlapped tag failure, give
+			 * the active and matching stream id a short time (1ms)
+			 * to complete before respond with overlapped command
+			 * failure.
+			 */
+			msleep(1);
+
+			/* If the stream is completed, retry the command */
+			if (!stream->cmd) {
+				usbg_submit_command(cmd->fu, cmd->req);
+				return;
+			}
+
+			/* Overlap command tag detected. Abort command. */
+			cmd->state = UASP_QUEUE_COMMAND;
+			stream->cmd->se_cmd.transport_state |= CMD_T_ABORTED;
+			target_get_sess_cmd(&stream->cmd->se_cmd, true);
+
+			/* This will trigger command abort handler */
+			target_execute_cmd(&stream->cmd->se_cmd);
+			transport_generic_free_cmd(&stream->cmd->se_cmd, 1);
+		}
+
+
+		target_submit_tmr_fail_response(se_cmd, cmd->tmr_rsp,
+				tv_nexus->tvn_se_sess, cmd->unpacked_lun,
+				GFP_ATOMIC, cmd->tag, flags);
+		return;
+	}
+
+	target_submit_tmr(se_cmd, tv_nexus->tvn_se_sess,
+			  cmd->response_iu.add_response_info,
+			  cmd->unpacked_lun, NULL, cmd->tmr_func,
+			  GFP_ATOMIC, cmd->tag, flags);
+}
+
+static void usbg_submit_cmd(struct usbg_cmd *cmd)
 {
-	struct usbg_cmd *cmd = container_of(work, struct usbg_cmd, work);
 	struct se_cmd *se_cmd;
 	struct tcm_usbg_nexus *tv_nexus;
 	struct usbg_tpg *tpg;
@@ -1073,6 +1225,16 @@ static void usbg_cmd_work(struct work_struct *work)
 			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
+static void usbg_cmd_work(struct work_struct *work)
+{
+	struct usbg_cmd *cmd = container_of(work, struct usbg_cmd, work);
+
+	if (cmd->tmr_func || cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN)
+		usbg_submit_tmr(cmd);
+	else
+		usbg_submit_cmd(cmd);
+}
+
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
 		struct tcm_usbg_nexus *tv_nexus, u32 scsi_tag)
 {
@@ -1099,37 +1261,84 @@ static void usbg_release_cmd(struct se_cmd *);
 
 static int usbg_submit_command(struct f_uas *fu, struct usb_request *req)
 {
-	struct command_iu *cmd_iu = req->buf;
+	struct iu *iu = req->buf;
 	struct usbg_cmd *cmd;
 	struct usbg_tpg *tpg = fu->tpg;
 	struct tcm_usbg_nexus *tv_nexus;
+	struct uas_stream *stream;
+	struct command_iu *cmd_iu;
 	u32 cmd_len;
 	u16 scsi_tag;
 
-	if (cmd_iu->iu_id != IU_ID_COMMAND) {
-		pr_err("Unsupported type %d\n", cmd_iu->iu_id);
-		return -EINVAL;
-	}
-
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
 		pr_err("Missing nexus, ignoring command\n");
 		return -EINVAL;
 	}
 
-	cmd_len = (cmd_iu->len & ~0x3) + 16;
-	if (cmd_len > USBG_MAX_CMD)
-		return -EINVAL;
-
-	scsi_tag = be16_to_cpup(&cmd_iu->tag);
+	scsi_tag = be16_to_cpup(&iu->tag);
 	cmd = usbg_get_cmd(fu, tv_nexus, scsi_tag);
 	if (IS_ERR(cmd)) {
 		pr_err("usbg_get_cmd failed\n");
 		return -ENOMEM;
 	}
-	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
 
-	cmd->stream = &fu->stream[cmd->tag % USBG_NUM_CMDS];
+	cmd->req = req;
+	cmd->fu = fu;
+	cmd->tag = scsi_tag;
+	cmd->se_cmd.tag = scsi_tag;
+	cmd->tmr_func = 0;
+	cmd->tmr_rsp = TMR_RESPONSE_UNKNOWN;
+
+	cmd_iu = (struct command_iu *)iu;
+
+	/* Command and Task Management IUs share the same LUN offset */
+	cmd->unpacked_lun = scsilun_to_int(&cmd_iu->lun);
+
+	if (iu->iu_id != IU_ID_COMMAND && iu->iu_id != IU_ID_TASK_MGMT) {
+		cmd->tmr_rsp = TMR_TASK_DOES_NOT_EXIST;
+		goto skip;
+	}
+
+	/*
+	 * For simplicity, we use mod operation to quickly find an in-progress
+	 * matching command tag and respond with overlapped command. The
+	 * assumption is that the UASP class driver will limit to using tag id
+	 * from 1 to USBG_NUM_CMDS. This is based on observation from the
+	 * Windows and Linux UASP storage class driver behavior. If an unusual
+	 * UASP class driver uses a tag greater than USBG_NUM_CMDS, then this
+	 * method may no longer work due to possible stream id collision. In
+	 * that case, we need to use a proper algorithm to fetch the stream (or
+	 * simply walk through all active streams to check for overlap).
+	 */
+	stream = uasp_get_stream_by_tag(fu, scsi_tag);
+	if (stream->cmd) {
+		WARN_ONCE(stream->cmd->tag != scsi_tag,
+			  "Command tag %d collided with Stream id %d\n",
+			  scsi_tag, stream->cmd->tag);
+
+		cmd->tmr_rsp = TMR_OVERLAPPED_TAG_ATTEMPTED;
+		goto skip;
+	}
+
+	stream->cmd = cmd;
+
+	if (iu->iu_id == IU_ID_TASK_MGMT) {
+		struct task_mgmt_iu *tm_iu;
+
+		tm_iu = (struct task_mgmt_iu *)iu;
+		cmd->tmr_func = uasp_to_tcm_func(tm_iu->function);
+		goto skip;
+	}
+
+	cmd_len = (cmd_iu->len & ~0x3) + 16;
+	if (cmd_len > USBG_MAX_CMD) {
+		pr_err("invalid len %d\n", cmd_len);
+		target_free_tag(tv_nexus->tvn_se_sess, &cmd->se_cmd);
+		stream->cmd = NULL;
+		return -EINVAL;
+	}
+	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
 
 	switch (cmd_iu->prio_attr & 0x7) {
 	case UAS_HEAD_TAG:
@@ -1150,9 +1359,7 @@ static int usbg_submit_command(struct f_uas *fu, struct usb_request *req)
 		break;
 	}
 
-	cmd->unpacked_lun = scsilun_to_int(&cmd_iu->lun);
-	cmd->req = req;
-
+skip:
 	INIT_WORK(&cmd->work, usbg_cmd_work);
 	queue_work(tpg->workqueue, &cmd->work);
 
@@ -1298,13 +1505,16 @@ static int usbg_get_cmd_state(struct se_cmd *se_cmd)
 
 static void usbg_queue_tm_rsp(struct se_cmd *se_cmd)
 {
+	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd, se_cmd);
+
+	uasp_send_tm_response(cmd);
 }
 
 static void usbg_aborted_task(struct se_cmd *se_cmd)
 {
 	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd, se_cmd);
 	struct f_uas *fu = cmd->fu;
-	struct uas_stream *stream = cmd->stream;
+	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
 	int ret = 0;
 
 	if (stream->req_out->status == -EINPROGRESS)
diff --git a/drivers/usb/gadget/function/tcm.h b/drivers/usb/gadget/function/tcm.h
index 5157af1b166b..f1cd2399fd69 100644
--- a/drivers/usb/gadget/function/tcm.h
+++ b/drivers/usb/gadget/function/tcm.h
@@ -82,8 +82,11 @@ struct usbg_cmd {
 	u16 tag;
 	u16 prio_attr;
 	struct sense_iu sense_iu;
+	struct response_iu response_iu;
 	enum uas_state state;
-	struct uas_stream *stream;
+	int tmr_func;
+	int tmr_rsp;
+#define	TMR_RESPONSE_UNKNOWN 0xff
 
 	/* BOT only */
 	__le32 bot_tag;
@@ -96,6 +99,8 @@ struct uas_stream {
 	struct usb_request	*req_in;
 	struct usb_request	*req_out;
 	struct usb_request	*req_status;
+
+	struct usbg_cmd		*cmd;
 };
 
 struct usbg_cdb {
-- 
2.28.0

