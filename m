Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AA7CCA480
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 09:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiGHJHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiGHJHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 05:07:12 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057F620F4A;
        Fri,  8 Jul 2022 02:07:09 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A5721400F6;
        Fri,  8 Jul 2022 09:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657271226; x=1659085627; bh=6iLO3vvMORouyjy5JBRkhBNXVAeAU52/cZb
        H0ZsdDWw=; b=bFNyTQVjoEFw6YPe3Gr5+wmoEoRs4OqW7GCymyvoqJl3seAlrKW
        qbp7NP89gs1Xh0Wd573Gf2Or8+AvUDRVF5jSEGe9hMnVkFMJv9s/4DeKCJpZ+qnD
        0U+flIGp7a0tePwuE/G4w1KJ7ehC+YBrjrkRKg8/OtVyAAF0AwKmq9pM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dhbVUPrigG0p; Fri,  8 Jul 2022 12:07:06 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C3B74411F8;
        Fri,  8 Jul 2022 12:07:05 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 8 Jul 2022 12:07:05 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 8 Jul 2022
 12:07:04 +0300
Date:   Fri, 8 Jul 2022 12:07:04 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 35/36] usb: gadget: f_tcm: Handle TASK_MANAGEMENT commands
Message-ID: <20220708090704.GM23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <70aa4f59a7f9d9d0c770bf42a0723825fa564548.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <70aa4f59a7f9d9d0c770bf42a0723825fa564548.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:38:01PM -0700, Thinh Nguyen wrote:
> Handle target_core_fabric_ops TASK MANAGEMENT functions and their
> response. If a TASK MANAGEMENT command is received, the driver will
> interpret the function TMF_*, translate to TMR_*, and fire off a command
> work executing target_submit_tmr(). On completion, it will handle the
> TASK MANAGEMENT response through uasp_send_tm_response().
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
> NOTE: I appologize for this big patch. I feel that this feature needs to be
> viewed in its entirety to see the whole picture and easier review.
> 
> 
>  drivers/usb/gadget/function/f_tcm.c | 260 +++++++++++++++++++++++++---
>  drivers/usb/gadget/function/tcm.h   |   7 +-
>  2 files changed, 241 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index fa09999adda7..a68436f97f91 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -12,6 +12,7 @@
>  #include <linux/string.h>
>  #include <linux/configfs.h>
>  #include <linux/ctype.h>
> +#include <linux/delay.h>
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/composite.h>
>  #include <linux/usb/gadget.h>
> @@ -462,6 +463,53 @@ static int usbg_bot_setup(struct usb_function *f,
>  
>  /* Start uas.c code */
>  
> +static int tcm_to_uasp_response(enum tcm_tmrsp_table code)
> +{
> +	switch (code) {
> +	case TMR_FUNCTION_FAILED:
> +		return RC_TMF_FAILED;
> +	case TMR_FUNCTION_COMPLETE:
> +		return RC_TMF_COMPLETE;
> +	case TMR_FUNCTION_REJECTED:
> +		return RC_TMF_NOT_SUPPORTED;
> +	case TMR_LUN_DOES_NOT_EXIST:
> +		return RC_INCORRECT_LUN;
> +	case TMR_OVERLAPPED_TAG_ATTEMPTED:
> +		return RC_OVERLAPPED_TAG;
> +	case TMR_TASK_DOES_NOT_EXIST:
> +		return RC_INVALID_INFO_UNIT;
> +	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
> +	default:
> +		return RC_TMF_NOT_SUPPORTED;
> +	}
> +}
> +
> +static unsigned char uasp_to_tcm_func(int code)
> +{
> +	switch (code) {
> +	case TMF_ABORT_TASK:
> +		return TMR_ABORT_TASK;
> +	case TMF_ABORT_TASK_SET:
> +		return TMR_ABORT_TASK_SET;
> +	case TMF_CLEAR_TASK_SET:
> +		return TMR_CLEAR_TASK_SET;
> +	case TMF_LOGICAL_UNIT_RESET:
> +		return TMR_LUN_RESET;
> +	case TMF_I_T_NEXUS_RESET:
> +		return TMR_I_T_NEXUS_RESET;
> +	case TMF_CLEAR_ACA:
> +		return TMR_CLEAR_ACA;
> +	case TMF_QUERY_TASK:
> +		return TMR_QUERY_TASK;
> +	case TMF_QUERY_TASK_SET:
> +		return TMR_QUERY_TASK_SET;
> +	case TMF_QUERY_ASYNC_EVENT:
> +		return TMR_QUERY_ASYNC_EVENT;
> +	default:
> +		return TMR_UNKNOWN;
> +	}
> +}
> +
>  static void uasp_cleanup_one_stream(struct f_uas *fu, struct uas_stream *stream)
>  {
>  	/* We have either all three allocated or none */
> @@ -506,6 +554,11 @@ static void uasp_cleanup_old_alt(struct f_uas *fu)
>  	uasp_free_cmdreq(fu);
>  }
>  
> +static struct uas_stream *uasp_get_stream_by_tag(struct f_uas *fu, u16 tag)
> +{
> +	return &fu->stream[tag % USBG_NUM_CMDS];
> +}
> +
>  static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req);
>  
>  static int uasp_prepare_r_request(struct usbg_cmd *cmd)
> @@ -513,7 +566,7 @@ static int uasp_prepare_r_request(struct usbg_cmd *cmd)
>  	struct se_cmd *se_cmd = &cmd->se_cmd;
>  	struct f_uas *fu = cmd->fu;
>  	struct usb_gadget *gadget = fuas_to_gadget(fu);
> -	struct uas_stream *stream = cmd->stream;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
>  
>  	if (!gadget->sg_supported) {
>  		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_ATOMIC);
> @@ -546,7 +599,7 @@ static void uasp_prepare_status(struct usbg_cmd *cmd)
>  {
>  	struct se_cmd *se_cmd = &cmd->se_cmd;
>  	struct sense_iu *iu = &cmd->sense_iu;
> -	struct uas_stream *stream = cmd->stream;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
>  
>  	cmd->state = UASP_QUEUE_COMMAND;
>  	iu->iu_id = IU_ID_STATUS;
> @@ -565,11 +618,36 @@ static void uasp_prepare_status(struct usbg_cmd *cmd)
>  	stream->req_status->complete = uasp_status_data_cmpl;
>  }
>  
> +static void uasp_prepare_response(struct usbg_cmd *cmd)
> +{
> +	struct se_cmd *se_cmd = &cmd->se_cmd;
> +	struct response_iu *rsp_iu = &cmd->response_iu;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
> +
> +	cmd->state = UASP_QUEUE_COMMAND;
> +	rsp_iu->iu_id = IU_ID_RESPONSE;
> +	rsp_iu->tag = cpu_to_be16(cmd->tag);
> +
> +	if (cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN)
> +		rsp_iu->response_code =
> +			tcm_to_uasp_response(cmd->tmr_rsp);
> +	else
> +		rsp_iu->response_code =
> +			tcm_to_uasp_response(se_cmd->se_tmr_req->response);
> +
> +	stream->req_status->is_last = 1;
> +	stream->req_status->stream_id = cmd->tag;
> +	stream->req_status->context = cmd;
> +	stream->req_status->length = sizeof(struct response_iu);
> +	stream->req_status->buf = rsp_iu;
> +	stream->req_status->complete = uasp_status_data_cmpl;
> +}
> +
>  static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
>  {
>  	struct usbg_cmd *cmd = req->context;
> -	struct uas_stream *stream = cmd->stream;
>  	struct f_uas *fu = cmd->fu;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
>  	struct se_session *se_sess = cmd->se_cmd.se_sess;
>  	int ret;
>  
> @@ -604,6 +682,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
>  		break;
>  
>  	case UASP_QUEUE_COMMAND:
> +		stream->cmd = NULL;
>  
>  		target_free_tag(se_sess, &cmd->se_cmd);
>  		transport_generic_free_cmd(&cmd->se_cmd, 0);
> @@ -617,6 +696,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
>  	return;
>  
>  cleanup:
> +	stream->cmd = NULL;
>  	target_free_tag(se_sess, &cmd->se_cmd);
>  	transport_generic_free_cmd(&cmd->se_cmd, 0);
>  }
> @@ -624,7 +704,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
>  static int uasp_send_status_response(struct usbg_cmd *cmd)
>  {
>  	struct f_uas *fu = cmd->fu;
> -	struct uas_stream *stream = cmd->stream;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
>  	struct sense_iu *iu = &cmd->sense_iu;
>  
>  	iu->tag = cpu_to_be16(cmd->tag);
> @@ -633,10 +713,22 @@ static int uasp_send_status_response(struct usbg_cmd *cmd)
>  	return usb_ep_queue(fu->ep_status, stream->req_status, GFP_ATOMIC);
>  }
>  
> +static int uasp_send_tm_response(struct usbg_cmd *cmd)
> +{
> +	struct f_uas *fu = cmd->fu;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
> +	struct response_iu *iu = &cmd->response_iu;
> +
> +	iu->tag = cpu_to_be16(cmd->tag);
> +	cmd->fu = fu;
> +	uasp_prepare_response(cmd);
> +	return usb_ep_queue(fu->ep_status, stream->req_status, GFP_ATOMIC);
> +}
> +
>  static int uasp_send_read_response(struct usbg_cmd *cmd)
>  {
>  	struct f_uas *fu = cmd->fu;
> -	struct uas_stream *stream = cmd->stream;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
>  	struct sense_iu *iu = &cmd->sense_iu;
>  	int ret;
>  
> @@ -682,7 +774,7 @@ static int uasp_send_read_response(struct usbg_cmd *cmd)
>  static int uasp_send_write_request(struct usbg_cmd *cmd)
>  {
>  	struct f_uas *fu = cmd->fu;
> -	struct uas_stream *stream = cmd->stream;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
>  	struct sense_iu *iu = &cmd->sense_iu;
>  	int ret;
>  
> @@ -943,8 +1035,10 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
>  {
>  	struct usbg_cmd *cmd = req->context;
>  	struct se_cmd *se_cmd = &cmd->se_cmd;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
>  
>  	if (req->status == -ESHUTDOWN) {
> +		stream->cmd = NULL;
>  		target_free_tag(se_cmd->se_sess, se_cmd);
>  		transport_generic_free_cmd(&cmd->se_cmd, 0);
>  		return;
> @@ -962,6 +1056,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
>  				se_cmd->data_length);
>  	}
>  
> +	cmd->state = UASP_QUEUE_COMMAND;
>  	target_execute_cmd(se_cmd);
>  	return;
>  
> @@ -1042,9 +1137,66 @@ static int usbg_send_read_response(struct se_cmd *se_cmd)
>  		return uasp_send_read_response(cmd);
>  }
>  
> -static void usbg_cmd_work(struct work_struct *work)
> +static void usbg_submit_tmr(struct usbg_cmd *cmd)
> +{
> +	struct se_cmd *se_cmd;
> +	struct tcm_usbg_nexus *tv_nexus;
> +	struct uas_stream *stream;
> +	int flags = TARGET_SCF_ACK_KREF;
> +
> +	se_cmd = &cmd->se_cmd;
> +	tv_nexus = cmd->fu->tpg->tpg_nexus;
> +	stream = uasp_get_stream_by_tag(cmd->fu, cmd->tag);
> +
> +	/* Failure detected by f_tcm */
> +	if (cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN) {
> +		if (cmd->tmr_rsp == TMR_OVERLAPPED_TAG_ATTEMPTED) {
> +			/*
> +			 * There's no guarantee of a matching completion order
> +			 * between different endpoints. i.e. The device may
> +			 * receive a new (CDB) command request completion of the
> +			 * command endpoint before it gets notified of the
> +			 * previous command status completion from a status
> +			 * endpoint. The driver still needs to detect
> +			 * misbehaving host and respond with an overlap command
> +			 * tag. To prevent false overlapped tag failure, give
> +			 * the active and matching stream id a short time (1ms)
> +			 * to complete before respond with overlapped command
> +			 * failure.
> +			 */
> +			msleep(1);
> +
> +			/* If the stream is completed, retry the command */
> +			if (!stream->cmd) {
> +				usbg_submit_command(cmd->fu, cmd->req);
> +				return;
> +			}
> +
> +			/* Overlap command tag detected. Abort command. */
> +			cmd->state = UASP_QUEUE_COMMAND;
> +			stream->cmd->se_cmd.transport_state |= CMD_T_ABORTED;
> +			target_get_sess_cmd(&stream->cmd->se_cmd, true);
> +
> +			/* This will trigger command abort handler */
> +			target_execute_cmd(&stream->cmd->se_cmd);
> +			transport_generic_free_cmd(&stream->cmd->se_cmd, 1);
> +		}
> +
> +
> +		target_submit_tmr_fail_response(se_cmd, cmd->tmr_rsp,
> +				tv_nexus->tvn_se_sess, cmd->unpacked_lun,
> +				GFP_ATOMIC, cmd->tag, flags);
I think there is no reason to reject TMR via Core, you may use
your uasp_send_tm_response(cmd) directly like other fabric drivers does.
That will need some coding to distinguish a completion of the response
initiated from Core and from fabric driver.
> +		return;
> +	}
> +
> +	target_submit_tmr(se_cmd, tv_nexus->tvn_se_sess,
> +			  cmd->response_iu.add_response_info,
> +			  cmd->unpacked_lun, NULL, cmd->tmr_func,
> +			  GFP_ATOMIC, cmd->tag, flags);
> +}
> +
> +static void usbg_submit_cmd(struct usbg_cmd *cmd)
>  {
> -	struct usbg_cmd *cmd = container_of(work, struct usbg_cmd, work);
>  	struct se_cmd *se_cmd;
>  	struct tcm_usbg_nexus *tv_nexus;
>  	struct usbg_tpg *tpg;
> @@ -1073,6 +1225,16 @@ static void usbg_cmd_work(struct work_struct *work)
>  			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
>  }
>  
> +static void usbg_cmd_work(struct work_struct *work)
> +{
> +	struct usbg_cmd *cmd = container_of(work, struct usbg_cmd, work);
> +
> +	if (cmd->tmr_func || cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN)
> +		usbg_submit_tmr(cmd);
That looks very strange - in response of received SCSI command you will
send a TMR response???
I am about cmd->tmr_rsp != TMR_RESPONSE_UNKNOWN case.
> +	else
> +		usbg_submit_cmd(cmd);
> +}
> +
>  static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
>  		struct tcm_usbg_nexus *tv_nexus, u32 scsi_tag)
>  {
> @@ -1099,37 +1261,84 @@ static void usbg_release_cmd(struct se_cmd *);
>  
>  static int usbg_submit_command(struct f_uas *fu, struct usb_request *req)
>  {
> -	struct command_iu *cmd_iu = req->buf;
> +	struct iu *iu = req->buf;
>  	struct usbg_cmd *cmd;
>  	struct usbg_tpg *tpg = fu->tpg;
>  	struct tcm_usbg_nexus *tv_nexus;
> +	struct uas_stream *stream;
> +	struct command_iu *cmd_iu;
>  	u32 cmd_len;
>  	u16 scsi_tag;
>  
> -	if (cmd_iu->iu_id != IU_ID_COMMAND) {
> -		pr_err("Unsupported type %d\n", cmd_iu->iu_id);
> -		return -EINVAL;
> -	}
> -
>  	tv_nexus = tpg->tpg_nexus;
>  	if (!tv_nexus) {
>  		pr_err("Missing nexus, ignoring command\n");
>  		return -EINVAL;
>  	}
>  
> -	cmd_len = (cmd_iu->len & ~0x3) + 16;
> -	if (cmd_len > USBG_MAX_CMD)
> -		return -EINVAL;
> -
> -	scsi_tag = be16_to_cpup(&cmd_iu->tag);
> +	scsi_tag = be16_to_cpup(&iu->tag);
>  	cmd = usbg_get_cmd(fu, tv_nexus, scsi_tag);
>  	if (IS_ERR(cmd)) {
>  		pr_err("usbg_get_cmd failed\n");
>  		return -ENOMEM;
>  	}
> -	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
>  
> -	cmd->stream = &fu->stream[cmd->tag % USBG_NUM_CMDS];
> +	cmd->req = req;
> +	cmd->fu = fu;
> +	cmd->tag = scsi_tag;
> +	cmd->se_cmd.tag = scsi_tag;
> +	cmd->tmr_func = 0;
> +	cmd->tmr_rsp = TMR_RESPONSE_UNKNOWN;
TMR_* constant are fabric agnostic enum. Better use RC_TMF_* values in
variables of this driver.
> +
> +	cmd_iu = (struct command_iu *)iu;
> +
> +	/* Command and Task Management IUs share the same LUN offset */
> +	cmd->unpacked_lun = scsilun_to_int(&cmd_iu->lun);
> +
> +	if (iu->iu_id != IU_ID_COMMAND && iu->iu_id != IU_ID_TASK_MGMT) {
> +		cmd->tmr_rsp = TMR_TASK_DOES_NOT_EXIST;
> +		goto skip;
> +	}
> +
> +	/*
> +	 * For simplicity, we use mod operation to quickly find an in-progress
> +	 * matching command tag and respond with overlapped command. The
> +	 * assumption is that the UASP class driver will limit to using tag id
> +	 * from 1 to USBG_NUM_CMDS. This is based on observation from the
> +	 * Windows and Linux UASP storage class driver behavior. If an unusual
> +	 * UASP class driver uses a tag greater than USBG_NUM_CMDS, then this
> +	 * method may no longer work due to possible stream id collision. In
> +	 * that case, we need to use a proper algorithm to fetch the stream (or
> +	 * simply walk through all active streams to check for overlap).
> +	 */
> +	stream = uasp_get_stream_by_tag(fu, scsi_tag);
> +	if (stream->cmd) {
> +		WARN_ONCE(stream->cmd->tag != scsi_tag,
WARN is used to indicate a non fatal bug in the code. May be you want to
use pr_warn/pr_err here?
> +			  "Command tag %d collided with Stream id %d\n",
> +			  scsi_tag, stream->cmd->tag);
> +
> +		cmd->tmr_rsp = TMR_OVERLAPPED_TAG_ATTEMPTED;
> +		goto skip;
> +	}
> +
> +	stream->cmd = cmd;
> +
> +	if (iu->iu_id == IU_ID_TASK_MGMT) {
> +		struct task_mgmt_iu *tm_iu;
> +
> +		tm_iu = (struct task_mgmt_iu *)iu;
> +		cmd->tmr_func = uasp_to_tcm_func(tm_iu->function);
> +		goto skip;
> +	}
> +
> +	cmd_len = (cmd_iu->len & ~0x3) + 16;
> +	if (cmd_len > USBG_MAX_CMD) {
> +		pr_err("invalid len %d\n", cmd_len);
> +		target_free_tag(tv_nexus->tvn_se_sess, &cmd->se_cmd);
> +		stream->cmd = NULL;
> +		return -EINVAL;
> +	}
> +	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
>  
>  	switch (cmd_iu->prio_attr & 0x7) {
>  	case UAS_HEAD_TAG:
> @@ -1150,9 +1359,7 @@ static int usbg_submit_command(struct f_uas *fu, struct usb_request *req)
>  		break;
>  	}
>  
> -	cmd->unpacked_lun = scsilun_to_int(&cmd_iu->lun);
> -	cmd->req = req;
> -
> +skip:
>  	INIT_WORK(&cmd->work, usbg_cmd_work);
>  	queue_work(tpg->workqueue, &cmd->work);
>  
> @@ -1298,13 +1505,16 @@ static int usbg_get_cmd_state(struct se_cmd *se_cmd)
>  
>  static void usbg_queue_tm_rsp(struct se_cmd *se_cmd)
>  {
> +	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd, se_cmd);
> +
> +	uasp_send_tm_response(cmd);
>  }
>  
>  static void usbg_aborted_task(struct se_cmd *se_cmd)
>  {
>  	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd, se_cmd);
>  	struct f_uas *fu = cmd->fu;
> -	struct uas_stream *stream = cmd->stream;
> +	struct uas_stream *stream = uasp_get_stream_by_tag(fu, cmd->tag);
>  	int ret = 0;
>  
>  	if (stream->req_out->status == -EINPROGRESS)
> diff --git a/drivers/usb/gadget/function/tcm.h b/drivers/usb/gadget/function/tcm.h
> index 5157af1b166b..f1cd2399fd69 100644
> --- a/drivers/usb/gadget/function/tcm.h
> +++ b/drivers/usb/gadget/function/tcm.h
> @@ -82,8 +82,11 @@ struct usbg_cmd {
>  	u16 tag;
>  	u16 prio_attr;
>  	struct sense_iu sense_iu;
> +	struct response_iu response_iu;
>  	enum uas_state state;
> -	struct uas_stream *stream;
> +	int tmr_func;
> +	int tmr_rsp;
> +#define	TMR_RESPONSE_UNKNOWN 0xff
>  
>  	/* BOT only */
>  	__le32 bot_tag;
> @@ -96,6 +99,8 @@ struct uas_stream {
>  	struct usb_request	*req_in;
>  	struct usb_request	*req_out;
>  	struct usb_request	*req_status;
> +
> +	struct usbg_cmd		*cmd;
>  };
>  
>  struct usbg_cdb {
