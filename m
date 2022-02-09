Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2522EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbiBIIQZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiBIIQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:16:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB75CC0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:16:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 716DE210E9;
        Wed,  9 Feb 2022 08:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyvAi57EINixIpyboCKNrx7QEkUlew8B7gkMnF60Zc4=;
        b=W1SxKQToNazAzFQ9DrSJ5NsmjAE4OkG/VNJSAukSnKDFhOWFpRYXvb+35N2ybjkTIbrc3G
        hyVfbsIP/plhhOsZjp/WjGJ499ccI/trGYon8egpdloOKYWJ+A1rev1ot0vA5Oj0T7h/Dz
        TAfiQUpX3B+9kQN14jz022XdKktvNXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394585;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyvAi57EINixIpyboCKNrx7QEkUlew8B7gkMnF60Zc4=;
        b=sPMose7MDp9wvhIf5Wm1Ttek7YayU35M+DfJnfC59CrjPURf53jmalRXLCbihc2ALcc4tl
        K6cxqN8FkHJBoWDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29D4D139D1;
        Wed,  9 Feb 2022 08:16:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LpEBCVl4A2IlHwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:16:25 +0000
Message-ID: <4793ed1c-e0dc-7a10-19a6-18f2d052fc92@suse.de>
Date:   Wed, 9 Feb 2022 09:16:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 28/44] megasas: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-29-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-29-bvanassche@acm.org>
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
>   drivers/scsi/megaraid/megaraid_sas.h        | 12 ++++++++++++
>   drivers/scsi/megaraid/megaraid_sas_base.c   |  8 ++++----
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 ++++++++-------
>   3 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 2c9d1b796475..611871ef15b5 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -18,6 +18,8 @@
>   #ifndef LSI_MEGARAID_SAS_H
>   #define LSI_MEGARAID_SAS_H
>   
> +#include <scsi/scsi_cmnd.h>
> +
>   /*
>    * MegaRAID SAS Driver meta data
>    */
> @@ -2594,6 +2596,16 @@ struct megasas_cmd {
>   	};
>   };
>   
> +struct megasas_cmd_priv {
> +	void	*cmd_priv;
> +	u8	status;
> +};
> +
> +static inline struct megasas_cmd_priv *megasas_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
>   #define MAX_MGMT_ADAPTERS		1024
>   #define MAX_IOCTL_SGE			16
>   
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 82e1e24257bc..8bf72dbc33b7 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1760,7 +1760,7 @@ megasas_build_and_issue_cmd(struct megasas_instance *instance,
>   		goto out_return_cmd;
>   
>   	cmd->scmd = scmd;
> -	scmd->SCp.ptr = (char *)cmd;
> +	megasas_priv(scmd)->cmd_priv = cmd;
>   
>   	/*
>   	 * Issue the command to the FW
> @@ -2992,11 +2992,10 @@ megasas_dump_reg_set(void __iomem *reg_set)
>   void
>   megasas_dump_fusion_io(struct scsi_cmnd *scmd)
>   {
> -	struct megasas_cmd_fusion *cmd;
> +	struct megasas_cmd_fusion *cmd = megasas_priv(scmd)->cmd_priv;
>   	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
>   	struct megasas_instance *instance;
>   
> -	cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
>   	instance = (struct megasas_instance *)scmd->device->host->hostdata;
>   
>   	scmd_printk(KERN_INFO, scmd,
> @@ -3518,6 +3517,7 @@ static struct scsi_host_template megasas_template = {
>   	.mq_poll = megasas_blk_mq_poll,
>   	.change_queue_depth = scsi_change_queue_depth,
>   	.max_segment_size = 0xffffffff,
> +	.cmd_size = sizeof(struct megasas_cmd_priv),
>   };
>   
>   /**
> @@ -3601,7 +3601,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
>   	cmd->retry_for_fw_reset = 0;
>   
>   	if (cmd->scmd)
> -		cmd->scmd->SCp.ptr = NULL;
> +		megasas_priv(cmd->scmd)->cmd_priv = NULL;
>   
>   	switch (hdr->cmd) {
>   	case MFI_CMD_INVALID:
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index fc90a0a687b5..c72364864bf4 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2915,7 +2915,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
>   				get_updated_dev_handle(instance,
>   					&fusion->load_balance_info[device_id],
>   					&io_info, local_map_ptr);
> -			scp->SCp.Status |= MEGASAS_LOAD_BALANCE_FLAG;
> +			megasas_priv(scp)->status |= MEGASAS_LOAD_BALANCE_FLAG;
>   			cmd->pd_r1_lb = io_info.pd_after_lb;
>   			if (instance->adapter_type >= VENTURA_SERIES)
>   				rctx_g35->span_arm = io_info.span_arm;
> @@ -2923,7 +2923,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
>   				rctx->span_arm = io_info.span_arm;
>   
>   		} else
> -			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
> +			megasas_priv(scp)->status &= ~MEGASAS_LOAD_BALANCE_FLAG;
>   
>   		if (instance->adapter_type >= VENTURA_SERIES)
>   			cmd->r1_alt_dev_handle = io_info.r1_alt_dev_handle;
> @@ -3293,7 +3293,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
>   	io_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
>   
>   	cmd->scmd = scp;
> -	scp->SCp.ptr = (char *)cmd;
> +	megasas_priv(scp)->cmd_priv = cmd;
>   
>   	return 0;
>   }
> @@ -3489,7 +3489,7 @@ megasas_complete_r1_command(struct megasas_instance *instance,
>   		if (instance->ldio_threshold &&
>   		    megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
>   			atomic_dec(&instance->ldio_outstanding);
> -		scmd_local->SCp.ptr = NULL;
> +		megasas_priv(scmd_local)->cmd_priv = NULL;
>   		megasas_return_cmd_fusion(instance, cmd);
>   		scsi_dma_unmap(scmd_local);
>   		megasas_sdev_busy_dec(instance, scmd_local);
> @@ -3613,12 +3613,13 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
>   		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
>   			/* Update load balancing info */
>   			if (fusion->load_balance_info &&
> -			    (cmd_fusion->scmd->SCp.Status &
> +			    (megasas_priv(cmd_fusion->scmd)->status &
>   			    MEGASAS_LOAD_BALANCE_FLAG)) {
>   				device_id = MEGASAS_DEV_INDEX(scmd_local);
>   				lbinfo = &fusion->load_balance_info[device_id];
>   				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
> -				cmd_fusion->scmd->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
> +				megasas_priv(cmd_fusion->scmd)->status &=
> +					~MEGASAS_LOAD_BALANCE_FLAG;
>   			}
>   			fallthrough;	/* and complete IO */
>   		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
> @@ -3630,7 +3631,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
>   				if (instance->ldio_threshold &&
>   				    (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO))
>   					atomic_dec(&instance->ldio_outstanding);
> -				scmd_local->SCp.ptr = NULL;
> +				megasas_priv(scmd_local)->cmd_priv = NULL;
>   				megasas_return_cmd_fusion(instance, cmd_fusion);
>   				scsi_dma_unmap(scmd_local);
>   				megasas_sdev_busy_dec(instance, scmd_local);

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
