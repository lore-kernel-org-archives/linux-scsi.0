Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D404AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbiBIHlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238892AbiBIHlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:41:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4995CC0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:41:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 061E9210DF;
        Wed,  9 Feb 2022 07:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644392499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcCzS0tONj4Ysp6tqr7wQtdN/4ZsgbpCxehJ/GYVqMI=;
        b=hp6ACH5tSfjEumpWE5AxRgzVVY0mGOrCN6Sc/9eZrlDm328ERDgGhsyGZV/meWmnd+FKzz
        sC4IgiJnv7iehRtaJ65DziZp7oUFVHvue2SxtqsN9HlCRw53CdlWCRB6QvlJWwf3geQRMY
        oQYe7bjjpXbGEF5zSrKYr6q04MQfwHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644392499;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcCzS0tONj4Ysp6tqr7wQtdN/4ZsgbpCxehJ/GYVqMI=;
        b=syQBBJles7NSbo+bpUWvahw/YDDziKnpiQWg6mLOR7xjC4ly1xehxGsfP9t487xQpaL2Su
        737TtREuuMXmt+DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A6CE113216;
        Wed,  9 Feb 2022 07:41:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YnK9JjJwA2KLDQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:41:38 +0000
Message-ID: <05e32b50-fad4-fc03-0d05-6c09e0d469f2@suse.de>
Date:   Wed, 9 Feb 2022 08:41:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 14/44] csio: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-15-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-15-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
> from struct scsi_cmnd.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/csiostor/csio_scsi.c | 20 +++++++++++---------
>   drivers/scsi/csiostor/csio_scsi.h | 10 ++++++++++
>   2 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 55db02521221..9aafe0002ab1 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -166,7 +166,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
>   	struct scsi_cmnd *scmnd = csio_scsi_cmnd(req);
>   
>   	/* Check for Task Management */
> -	if (likely(scmnd->SCp.Message == 0)) {
> +	if (likely(csio_priv(scmnd)->fc_tm_flags == 0)) {
>   		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
>   		fcp_cmnd->fc_tm_flags = 0;
>   		fcp_cmnd->fc_cmdref = 0;
> @@ -185,7 +185,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
>   	} else {
>   		memset(fcp_cmnd, 0, sizeof(*fcp_cmnd));
>   		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
> -		fcp_cmnd->fc_tm_flags = (uint8_t)scmnd->SCp.Message;
> +		fcp_cmnd->fc_tm_flags = csio_priv(scmnd)->fc_tm_flags;
>   	}
>   }
>   
> @@ -1855,7 +1855,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
>   
>   	/* Needed during abort */
>   	cmnd->host_scribble = (unsigned char *)ioreq;
> -	cmnd->SCp.Message = 0;
> +	csio_priv(cmnd)->fc_tm_flags = 0;
>   
>   	/* Kick off SCSI IO SM on the ioreq */
>   	spin_lock_irqsave(&hw->lock, flags);
> @@ -2026,7 +2026,7 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
>   		      req, req->wr_status);
>   
>   	/* Cache FW return status */
> -	cmnd->SCp.Status = req->wr_status;
> +	csio_priv(cmnd)->wr_status = req->wr_status;
>   
>   	/* Special handling based on FCP response */
>   
> @@ -2049,7 +2049,7 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
>   		/* Modify return status if flags indicate success */
>   		if (flags & FCP_RSP_LEN_VAL)
>   			if (rsp_info->rsp_code == FCP_TMF_CMPL)
> -				cmnd->SCp.Status = FW_SUCCESS;
> +				csio_priv(cmnd)->wr_status = FW_SUCCESS;
>   
>   		csio_dbg(hw, "TM FCP rsp code: %d\n", rsp_info->rsp_code);
>   	}
> @@ -2125,9 +2125,9 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>   
>   	csio_scsi_cmnd(ioreq)	= cmnd;
>   	cmnd->host_scribble	= (unsigned char *)ioreq;
> -	cmnd->SCp.Status	= 0;
> +	csio_priv(cmnd)->wr_status = 0;
>   
> -	cmnd->SCp.Message	= FCP_TMF_LUN_RESET;
> +	csio_priv(cmnd)->fc_tm_flags = FCP_TMF_LUN_RESET;
>   	ioreq->tmo		= CSIO_SCSI_LUNRST_TMO_MS / 1000;
>   
>   	/*
> @@ -2178,9 +2178,10 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>   	}
>   
>   	/* LUN reset returned, check cached status */
> -	if (cmnd->SCp.Status != FW_SUCCESS) {
> +	if (csio_priv(cmnd)->wr_status != FW_SUCCESS) {
>   		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
> -			 cmnd->device->id, cmnd->device->lun, cmnd->SCp.Status);
> +			 cmnd->device->id, cmnd->device->lun,
> +			 csio_priv(cmnd)->wr_status);
>   		goto fail;
>   	}
>   
> @@ -2271,6 +2272,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
>   	.name			= CSIO_DRV_DESC,
>   	.proc_name		= KBUILD_MODNAME,
>   	.queuecommand		= csio_queuecommand,
> +	.cmd_size		= sizeof(struct csio_cmd_priv),
>   	.eh_timed_out		= fc_eh_timed_out,
>   	.eh_abort_handler	= csio_eh_abort_handler,
>   	.eh_device_reset_handler = csio_eh_lun_reset_handler,
> diff --git a/drivers/scsi/csiostor/csio_scsi.h b/drivers/scsi/csiostor/csio_scsi.h
> index 2257c3dcf724..39dda3c88f0d 100644
> --- a/drivers/scsi/csiostor/csio_scsi.h
> +++ b/drivers/scsi/csiostor/csio_scsi.h
> @@ -188,6 +188,16 @@ struct csio_scsi_level_data {
>   	uint64_t		oslun;
>   };
>   
> +struct csio_cmd_priv {
> +	uint8_t fc_tm_flags;	/* task management flags */
> +	uint16_t wr_status;
> +};
> +
> +static inline struct csio_cmd_priv *csio_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
>   static inline struct csio_ioreq *
>   csio_get_scsi_ioreq(struct csio_scsim *scm)
>   {

Similar comments to the bfa driver: if you allocate a command payload it 
would make sense to move the 'host_scribble' contents in there, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
