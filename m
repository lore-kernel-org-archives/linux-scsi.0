Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388A1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiBIIpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:45:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiBIIpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:45:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6C9DF28ACF
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:44:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 41DCF210F8;
        Wed,  9 Feb 2022 08:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644395665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOcfaB40svCx9QY2wOntt5njkEKsgOxhy32a+cbifQg=;
        b=qiL0CVPmXTHJXoTUs/nfMwhKb60nS/mJFQIBrtEIH/mD1eP20d9uF2ML22fcbGHdMvmNzw
        pavNNjziPGmYuQBLj3sUyjjwhwDbTy6fnrxvPNOwa5GhSGOW7iVOVZ9Bj6EV+Fb3zaUjU0
        0zx8Csjg3F540EsHHsMCvZDqWPmsh2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644395665;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOcfaB40svCx9QY2wOntt5njkEKsgOxhy32a+cbifQg=;
        b=N2QggDGsKwWA0hJGMrFQ9H156rir6Q/4h5MTBkNHU+lueh44Zm+YXHyTly88njXDc+NCDl
        JQDW3gH9n+abYuAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B28013A7C;
        Wed,  9 Feb 2022 08:34:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id usW2AZF8A2JRJwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:34:25 +0000
Message-ID: <1fdea9be-4485-ad75-11fc-1d069feb9821@suse.de>
Date:   Wed, 9 Feb 2022 09:34:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 39/44] sym53c8xx_2: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "Reviewed-by : Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-40-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-40-bvanassche@acm.org>
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
> Cc: Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index b04bfde65e3f..2e2852bd5860 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -118,7 +118,7 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
>   	struct completion *eh_done;		/* SCSI error handling */
>   };
>   
> -#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
> +#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)scsi_cmd_priv(cmd))
>   #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
>   
>   /*
> @@ -127,7 +127,6 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
>   void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
>   {
>   	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
> -	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
>   
>   	if (ucmd->eh_done)
>   		complete(ucmd->eh_done);
> @@ -1630,6 +1629,7 @@ static struct scsi_host_template sym2_template = {
>   	.module			= THIS_MODULE,
>   	.name			= "sym53c8xx",
>   	.info			= sym53c8xx_info,
> +	.cmd_size		= sizeof(struct sym_ucmd),
>   	.queuecommand		= sym53c8xx_queue_command,
>   	.slave_alloc		= sym53c8xx_slave_alloc,
>   	.slave_configure	= sym53c8xx_slave_configure,

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
