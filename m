Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84935C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiBIH5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBIH5h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:57:37 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30045C0613CA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:57:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E0DFA1F391;
        Wed,  9 Feb 2022 07:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644393459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pbNQP+sBL3B4wPsLvUtA2QnoWZ6drsH9noVER/Fbuzw=;
        b=gNb/Fi/Oo0AUj6DLuoSc6Ej7Ejndy1rdm5KIVQAJK+QEL5HcTBZZJscbNithss78LAnK7M
        eaAdU2jHv1eOypaAcIBvSuEL7ZMaOv/vmB3lLHLf8w6dwdUVbJj1TFDxG/AUApiUE/2WdL
        MWwK2zQqfibt7/cj2tCsMcCOBgwHntU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644393459;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pbNQP+sBL3B4wPsLvUtA2QnoWZ6drsH9noVER/Fbuzw=;
        b=k9HpROGknQkaH0U+PMjz5FEUW+1ZnV33EhtAhxdG/czu78XttO6RMOmRIL/NVhdlFdksLE
        BBKqTKwlLAsEcHCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF228139D1;
        Wed,  9 Feb 2022 07:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FcavKfNzA2LTEwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:57:39 +0000
Message-ID: <726f470b-0262-7416-e2dc-8b68424fb74b@suse.de>
Date:   Wed, 9 Feb 2022 08:57:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 20/44] hptiop: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-21-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-21-bvanassche@acm.org>
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
>   drivers/scsi/hptiop.c | 1 +
>   drivers/scsi/hptiop.h | 4 ++--
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index d04245e379d7..f18b770626e6 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1174,6 +1174,7 @@ static struct scsi_host_template driver_template = {
>   	.slave_configure            = hptiop_slave_config,
>   	.this_id                    = -1,
>   	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
> +	.cmd_size		    = sizeof(struct hpt_cmd_priv),
>   };
>   
>   static int hptiop_internal_memalloc_itl(struct hptiop_hba *hba)
> diff --git a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
> index 35184c2008af..363d5a16243f 100644
> --- a/drivers/scsi/hptiop.h
> +++ b/drivers/scsi/hptiop.h
> @@ -251,13 +251,13 @@ struct hptiop_request {
>   	int                   index;
>   };
>   
> -struct hpt_scsi_pointer {
> +struct hpt_cmd_priv {

Why not keep the name? You have been using 'struct scsi_pointer' with 
all the other drivers ...

>   	int mapped;
>   	int sgcnt;
>   	dma_addr_t dma_handle;
>   };
>   
> -#define HPT_SCP(scp) ((struct hpt_scsi_pointer *)&(scp)->SCp)
> +#define HPT_SCP(scp) ((struct hpt_cmd_priv *)scsi_cmd_priv(scp))
>   
>   enum hptiop_family {
>   	UNKNOWN_BASED_IOP,

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
