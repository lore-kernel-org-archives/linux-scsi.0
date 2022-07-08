Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AE6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 07:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbiGHHAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiGHHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 03:00:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9E07392B;
        Fri,  8 Jul 2022 00:00:32 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7927F4131B;
        Fri,  8 Jul 2022 07:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657263629; x=1659078030; bh=MBV3TvvM1n5Hc7FOwTH/MwMmBFNpICLgwiz
        WYtOUXYg=; b=sPmy7Bo5cSdbzcKaeuUM1e7Lzp90HoEfT/Irp/Ekys9rajfqABR
        LPUlBb7gNBOwweAvup+6HIiyzf4453FMofV1sdV1PyZzk5n2K06vPiEbB4og31VB
        pQ21wrlYPXf7t1DfJTExGVh4daSuiVyhOjSo2iqmrIBFQcI78PwDnBB4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fZ_XuRx9ayFh; Fri,  8 Jul 2022 10:00:29 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4D84A41301;
        Fri,  8 Jul 2022 10:00:27 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 8 Jul 2022 10:00:27 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 8 Jul 2022
 10:00:26 +0300
Date:   Fri, 8 Jul 2022 10:00:26 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 18/36] usb: gadget: f_tcm: Don't set static stream_id
Message-ID: <20220708070026.GK23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d9863f8d7065cd9d5f6923ce002a86f6ee6509a9.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d9863f8d7065cd9d5f6923ce002a86f6ee6509a9.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:36:15PM -0700, Thinh Nguyen wrote:
> Host can assign stream ID value greater than number of streams
> allocated. The tcm function needs to keep track of which stream is
> available to assign the stream ID. This patch doesn't track that, but at
> least it makes sure that there's no Oops if the host send tag with a
> value greater than the number of supported streams.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/usb/gadget/function/f_tcm.c | 32 +++++------------------------
>  1 file changed, 5 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 270ec631481d..7721216dc9bc 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -532,6 +532,7 @@ static int uasp_prepare_r_request(struct usbg_cmd *cmd)
>  	}
>  
>  	stream->req_in->is_last = 1;
> +	stream->req_in->stream_id = cmd->tag;
>  	stream->req_in->complete = uasp_status_data_cmpl;
>  	stream->req_in->length = se_cmd->data_length;
>  	stream->req_in->context = cmd;
> @@ -556,6 +557,7 @@ static void uasp_prepare_status(struct usbg_cmd *cmd)
>  	iu->len = cpu_to_be16(se_cmd->scsi_sense_length);
>  	iu->status = se_cmd->scsi_status;
>  	stream->req_status->is_last = 1;
> +	stream->req_status->stream_id = cmd->tag;
>  	stream->req_status->context = cmd;
>  	stream->req_status->length = se_cmd->scsi_sense_length + 16;
>  	stream->req_status->buf = iu;
> @@ -786,19 +788,6 @@ static int uasp_alloc_cmd(struct f_uas *fu)
>  	return -ENOMEM;
>  }
>  
> -static void uasp_setup_stream_res(struct f_uas *fu, int max_streams)
> -{
> -	int i;
> -
> -	for (i = 0; i < max_streams; i++) {
> -		struct uas_stream *s = &fu->stream[i];
> -
> -		s->req_in->stream_id = i + 1;
> -		s->req_out->stream_id = i + 1;
> -		s->req_status->stream_id = i + 1;
> -	}
> -}
> -
>  static int uasp_prepare_reqs(struct f_uas *fu)
>  {
>  	int ret;
> @@ -819,7 +808,6 @@ static int uasp_prepare_reqs(struct f_uas *fu)
>  	ret = uasp_alloc_cmd(fu);
>  	if (ret)
>  		goto err_free_stream;
> -	uasp_setup_stream_res(fu, max_streams);
>  
>  	ret = usb_ep_queue(fu->ep_cmd, fu->cmd.req, GFP_ATOMIC);
>  	if (ret)
> @@ -995,6 +983,7 @@ static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
>  	}
>  
>  	req->is_last = 1;
> +	req->stream_id = cmd->tag;
>  	req->complete = usbg_data_write_cmpl;
>  	req->length = se_cmd->data_length;
>  	req->context = cmd;
> @@ -1125,16 +1114,8 @@ static int usbg_submit_command(struct f_uas *fu,
>  	}
>  	memcpy(cmd->cmd_buf, cmd_iu->cdb, cmd_len);
>  
> -	if (fu->flags & USBG_USE_STREAMS) {
> -		if (cmd->tag > UASP_SS_EP_COMP_NUM_STREAMS)
> -			goto err;
> -		if (!cmd->tag)
> -			cmd->stream = &fu->stream[0];
> -		else
> -			cmd->stream = &fu->stream[cmd->tag - 1];
> -	} else {
> -		cmd->stream = &fu->stream[0];
> -	}
> +	cmd->stream = &fu->stream[cmd->tag %
> +		UASP_SS_EP_COMP_NUM_STREAMS];
Use USBG_NUM_CMDS instead of UASP_SS_EP_COMP_NUM_STREAMS like in other
places.
>  
>  	switch (cmd_iu->prio_attr & 0x7) {
>  	case UAS_HEAD_TAG:
> @@ -1161,9 +1142,6 @@ static int usbg_submit_command(struct f_uas *fu,
>  	queue_work(tpg->workqueue, &cmd->work);
>  
>  	return 0;
> -err:
> -	usbg_release_cmd(&cmd->se_cmd);
> -	return -EINVAL;
>  }
>  
>  static void bot_cmd_work(struct work_struct *work)
