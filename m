Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05348C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbiBIIL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbiBIILW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:11:22 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BD2C05CB86
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:11:25 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B19E2210DE;
        Wed,  9 Feb 2022 08:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWWQ6HxSU7AgozRGlwcVGr94un0X5LgEoDwebu2OC2g=;
        b=kvqeJtVnAC0aF9AiDcaF/NxSn9PH6ywbJnPBgH2e9kE41nR8d1+4JIP1zbMqnrEPSmJURC
        VoRXMpWSsL/0Jgp0isi6d9u41s1ROUinQmkR1tw/qEOwc/t8wZjp0Ud4YM9TV1NsGgbZUk
        qXdIEdOL9IJcogGS46O7gZGxIGCCC90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394284;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWWQ6HxSU7AgozRGlwcVGr94un0X5LgEoDwebu2OC2g=;
        b=tW6U4XhIuu0R2UXyW5+dM//JnnfP/w0CcC+7Q2c5UB1BYXFG1zoWjW+mBZ24+a0wlERKoh
        VRhvTPtzedS6gUDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63839139D1;
        Wed,  9 Feb 2022 08:11:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oEyJDyx3A2JoHAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:11:24 +0000
Message-ID: <f003e500-a63d-5332-6122-0019cdcae1be@suse.de>
Date:   Wed, 9 Feb 2022 09:11:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 26/44] mac53c94: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-27-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-27-bvanassche@acm.org>
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
>   drivers/scsi/mac53c94.c | 24 +++++++++++++-----------
>   drivers/scsi/mac53c94.h | 11 +++++++++++
>   2 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index afa08309de36..f3005b38931f 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -193,7 +193,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
>   	struct fsc_state *state = (struct fsc_state *) dev_id;
>   	struct mac53c94_regs __iomem *regs = state->regs;
>   	struct dbdma_regs __iomem *dma = state->dma;
> -	struct scsi_cmnd *cmd = state->current_req;
> +	struct scsi_cmnd *const cmd = state->current_req;
> +	struct scsi_pointer *const scsi_pointer = mac53c94_scsi_pointer(cmd);
>   	int nb, stat, seq, intr;
>   	static int mac53c94_errors;
>   
> @@ -263,10 +264,10 @@ static void mac53c94_interrupt(int irq, void *dev_id)
>   		/* set DMA controller going if any data to transfer */
>   		if ((stat & (STAT_MSG|STAT_CD)) == 0
>   		    && (scsi_sg_count(cmd) > 0 || scsi_bufflen(cmd))) {
> -			nb = cmd->SCp.this_residual;
> +			nb = scsi_pointer->this_residual;
>   			if (nb > 0xfff0)
>   				nb = 0xfff0;
> -			cmd->SCp.this_residual -= nb;
> +			scsi_pointer->this_residual -= nb;
>   			writeb(nb, &regs->count_lo);
>   			writeb(nb >> 8, &regs->count_mid);
>   			writeb(CMD_DMA_MODE + CMD_NOP, &regs->command);
> @@ -293,13 +294,13 @@ static void mac53c94_interrupt(int irq, void *dev_id)
>   			cmd_done(state, DID_ERROR << 16);
>   			return;
>   		}
> -		if (cmd->SCp.this_residual != 0
> +		if (scsi_pointer->this_residual != 0
>   		    && (stat & (STAT_MSG|STAT_CD)) == 0) {
>   			/* Set up the count regs to transfer more */
> -			nb = cmd->SCp.this_residual;
> +			nb = scsi_pointer->this_residual;
>   			if (nb > 0xfff0)
>   				nb = 0xfff0;
> -			cmd->SCp.this_residual -= nb;
> +			scsi_pointer->this_residual -= nb;
>   			writeb(nb, &regs->count_lo);
>   			writeb(nb >> 8, &regs->count_mid);
>   			writeb(CMD_DMA_MODE + CMD_NOP, &regs->command);
> @@ -321,8 +322,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
>   			cmd_done(state, DID_ERROR << 16);
>   			return;
>   		}
> -		cmd->SCp.Status = readb(&regs->fifo);
> -		cmd->SCp.Message = readb(&regs->fifo);
> +		scsi_pointer->Status = readb(&regs->fifo);
> +		scsi_pointer->Message = readb(&regs->fifo);
>   		writeb(CMD_ACCEPT_MSG, &regs->command);
>   		state->phase = busfreeing;
>   		break;
> @@ -330,8 +331,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
>   		if (intr != INTR_DISCONNECT) {
>   			printk(KERN_DEBUG "got intr %x when expected disconnect\n", intr);
>   		}
> -		cmd_done(state, (DID_OK << 16) + (cmd->SCp.Message << 8)
> -			 + cmd->SCp.Status);
> +		cmd_done(state, (DID_OK << 16) + (scsi_pointer->Message << 8)
> +			 + scsi_pointer->Status);
>   		break;
>   	default:
>   		printk(KERN_DEBUG "don't know about phase %d\n", state->phase);
> @@ -389,7 +390,7 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
>   	dma_cmd += OUTPUT_LAST - OUTPUT_MORE;
>   	dcmds[-1].command = cpu_to_le16(dma_cmd);
>   	dcmds->command = cpu_to_le16(DBDMA_STOP);
> -	cmd->SCp.this_residual = total;
> +	mac53c94_scsi_pointer(cmd)->this_residual = total;
>   }
>   
>   static struct scsi_host_template mac53c94_template = {
> @@ -401,6 +402,7 @@ static struct scsi_host_template mac53c94_template = {
>   	.this_id	= 7,
>   	.sg_tablesize	= SG_ALL,
>   	.max_segment_size = 65535,
> +	.cmd_size	= sizeof(struct mac53c94_cmd_priv),
>   };
>   
>   static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *match)
> diff --git a/drivers/scsi/mac53c94.h b/drivers/scsi/mac53c94.h
> index 5df6e81f78a8..37d7d30f42ef 100644
> --- a/drivers/scsi/mac53c94.h
> +++ b/drivers/scsi/mac53c94.h
> @@ -212,4 +212,15 @@ struct mac53c94_regs {
>   #define CF4_TEST	0x02
>   #define CF4_BBTE	0x01
>   
> +struct mac53c94_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *mac53c94_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct mac53c94_cmd_priv *mcmd = scsi_cmd_priv(cmd);
> +
> +	return &mcmd->scsi_pointer;
> +}
> +
>   #endif /* _MAC53C94_H */

Also here: Why not use 'struct scsi_pointer' directly as command payload?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
