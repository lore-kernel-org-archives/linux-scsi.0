Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7B1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiBIISQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiBIISP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:18:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D665C0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:18:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CAE41210E9;
        Wed,  9 Feb 2022 08:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=73EbN/Zr/O4gStpTOw15DhSk9oCSW/+0n1UqOkkymCg=;
        b=gCO9YCz9CxoPI+11do560B71hBicyFt5eEG1X3Ykm1VmwvZs7hzQqLNCH/KUcP7tPOO7qD
        33R3tHwU0FPRuHrXWXBVNItKNUDa7xaa6s6mEc34xBh5oeDiRFUMRDvqyuOIdcKsXfw9Al
        +GPsdVFQcHllUi17K5Nj7kN6ysFDMfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394697;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=73EbN/Zr/O4gStpTOw15DhSk9oCSW/+0n1UqOkkymCg=;
        b=8suAc078cnY9DvvdoaPJtPJCdQ/WR65nVKj7ry4KHEh+MqTzMYP+u0VfDQPHsBfUs1RUkN
        8Gn7SaKZyhnPj+Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3AAAE139D1;
        Wed,  9 Feb 2022 08:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0HrmC8l4A2IIIAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:18:17 +0000
Message-ID: <3df20d94-a9d6-2256-dba6-80107cb4cfa4@suse.de>
Date:   Wed, 9 Feb 2022 09:18:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 31/44] mvumi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-32-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-32-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
> from struct scsi_cmnd.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/mvumi.c | 9 +++++----
>   drivers/scsi/mvumi.h | 9 +++++++++
>   2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 904de62c974c..05d3ce9b72db 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1302,7 +1302,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
>   {
>   	struct scsi_cmnd *scmd = cmd->scmd;
>   
> -	cmd->scmd->SCp.ptr = NULL;
> +	mvumi_priv(cmd->scmd)->cmd_priv = NULL;
>   	scmd->result = ob_frame->req_status;
>   
>   	switch (ob_frame->req_status) {
> @@ -2097,7 +2097,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
>   		goto out_return_cmd;
>   
>   	cmd->scmd = scmd;
> -	scmd->SCp.ptr = (char *) cmd;
> +	mvumi_priv(scmd)->cmd_priv = cmd;
>   	mhba->instancet->fire_cmd(mhba, cmd);
>   	spin_unlock_irqrestore(shost->host_lock, irq_flags);
>   	return 0;
> @@ -2111,7 +2111,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
>   
>   static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
>   {
> -	struct mvumi_cmd *cmd = (struct mvumi_cmd *) scmd->SCp.ptr;
> +	struct mvumi_cmd *cmd = mvumi_priv(scmd)->cmd_priv;
>   	struct Scsi_Host *host = scmd->device->host;
>   	struct mvumi_hba *mhba = shost_priv(host);
>   	unsigned long flags;
> @@ -2128,7 +2128,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
>   		atomic_dec(&mhba->fw_outstanding);
>   
>   	scmd->result = (DID_ABORT << 16);
> -	scmd->SCp.ptr = NULL;
> +	mvumi_priv(scmd)->cmd_priv = NULL;
>   	if (scsi_bufflen(scmd)) {
>   		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
>   			     scsi_sg_count(scmd),
> @@ -2179,6 +2179,7 @@ static struct scsi_host_template mvumi_template = {
>   	.bios_param = mvumi_bios_param,
>   	.dma_boundary = PAGE_SIZE - 1,
>   	.this_id = -1,
> +	.cmd_size = sizeof(struct mvumi_cmd_priv),
>   };
>   
>   static int mvumi_cfg_hw_reg(struct mvumi_hba *mhba)
> diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
> index 60d5691fc4ab..a88c58787b68 100644
> --- a/drivers/scsi/mvumi.h
> +++ b/drivers/scsi/mvumi.h
> @@ -254,6 +254,15 @@ struct mvumi_cmd {
>   	unsigned char cmd_status;
>   };
>   
> +struct mvumi_cmd_priv {
> +	struct mvumi_cmd *cmd_priv;
> +};
> +
> +static inline struct mvumi_cmd_priv *mvumi_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
>   /*
>    * the function type of the in bound frame
>    */

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
