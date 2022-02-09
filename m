Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC01C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiBIHpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiBIHpK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:45:10 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98218C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:45:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 55D461F390;
        Wed,  9 Feb 2022 07:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644392712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GlaAuRCyCi8/RFHckX1zOQN8CO3WYxKnp3LR5iC8EzI=;
        b=td6/V+NcLE3iUGLwuUnrfHJ3hQv5rTuHmu9RuF3NVLg/pteAYsVPqt/sURwrqcLcWmKBK0
        saGpTx+W4sZxqmiwUB20zu3R88TQEA/4caewSn/Z0+G01aYfGb9fXlDbErwjaQsX2ayCzK
        4v7xHzsg63GK+ZWWRKsRjRBtTunXESk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644392712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GlaAuRCyCi8/RFHckX1zOQN8CO3WYxKnp3LR5iC8EzI=;
        b=FGmy6YVZtuMBcJ11hupvQKaGeP7LxfacbCFIx5DGTuaQM2Mk+lS8StbJyzZ2hIeEOt0t4g
        B7oL9vQT+gpntUDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2F76C139D1;
        Wed,  9 Feb 2022 07:45:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mDU1CAhxA2INDwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:45:12 +0000
Message-ID: <d2a549c8-2b4b-3b1d-0493-02c46c98f8a4@suse.de>
Date:   Wed, 9 Feb 2022 08:45:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 16/44] esp_scsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-17-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-17-bvanassche@acm.org>
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
>   drivers/scsi/esp_scsi.c | 4 +---
>   drivers/scsi/esp_scsi.h | 3 ++-
>   2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 57787537285a..64ec6bb84550 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2678,6 +2678,7 @@ struct scsi_host_template scsi_esp_template = {
>   	.sg_tablesize		= SG_ALL,
>   	.max_sectors		= 0xffff,
>   	.skip_settle_delay	= 1,
> +	.cmd_size		= sizeof(struct esp_cmd_priv),
>   };
>   EXPORT_SYMBOL(scsi_esp_template);
>   
> @@ -2739,9 +2740,6 @@ static struct spi_function_template esp_transport_ops = {
>   
>   static int __init esp_init(void)
>   {
> -	BUILD_BUG_ON(sizeof(struct scsi_pointer) <
> -		     sizeof(struct esp_cmd_priv));
> -
>   	esp_transport_template = spi_attach_transport(&esp_transport_ops);
>   	if (!esp_transport_template)
>   		return -ENODEV;
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index 446a3d18c022..c73760d3cf83 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -262,7 +262,8 @@ struct esp_cmd_priv {
>   	struct scatterlist	*cur_sg;
>   	int			tot_residue;
>   };
> -#define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
> +
> +#define ESP_CMD_PRIV(cmd)	((struct esp_cmd_priv *)scsi_cmd_priv(cmd))
>   
>   /* NOTE: this enum is ordered based on chip features! */
>   enum esp_rev {

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
