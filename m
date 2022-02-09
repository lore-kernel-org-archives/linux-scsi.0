Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEABC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiBIIKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240921AbiBIIKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:10:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2B1C05CB97
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:10:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 64F11210F0;
        Wed,  9 Feb 2022 08:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ONMgIkRz5nuxL5bd+sj7QKRV4CRYcJDGBbvwMb33x4=;
        b=WaE7FEkMbOJqf34KiiTAouBa/n+Uta5/1c+gBgVe0d8hyIndvht66Quq7KGvZovuTTEfhY
        rL8QtLuOW65+3GSaI3Ov6PkFQkkV1C72Bz1Uhp/TuCleuEwm+R9TTz8FxgirGOfXkhHC+V
        akYdj/j2goGIDRrsf2hJUNbiX2HJkkE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394241;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ONMgIkRz5nuxL5bd+sj7QKRV4CRYcJDGBbvwMb33x4=;
        b=iCp9GX7i3VK4bMaUcRcPSwSNSak6tAzTr5LDb6zVNeNEy4aSjnIF7hRdH91iFDx/jceB3H
        ODm2R3CDjJSAAvCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3686E139D1;
        Wed,  9 Feb 2022 08:10:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iDOvCwF3A2IDHAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:10:41 +0000
Message-ID: <06656275-c56d-0a20-6267-190210489eab@suse.de>
Date:   Wed, 9 Feb 2022 09:10:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 25/44] mac53c94: Fix a set-but-not-used compiler
 warning
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-26-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-26-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Fix the following compiler warning:
> 
>     drivers/scsi/mac53c94.c: In function 'mac53c94_init':
>     drivers/scsi/mac53c94.c:128:13: warning: variable 'x' set but not used [-Wunused-but-set-variable]
>       128 |         int x;
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/mac53c94.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index 3976a18f6333..afa08309de36 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -125,7 +125,6 @@ static void mac53c94_init(struct fsc_state *state)
>   {
>   	struct mac53c94_regs __iomem *regs = state->regs;
>   	struct dbdma_regs __iomem *dma = state->dma;
> -	int x;
>   
>   	writeb(state->host->this_id | CF1_PAR_ENABLE, &regs->config1);
>   	writeb(TIMO_VAL(250), &regs->sel_timeout);	/* 250ms */
> @@ -134,7 +133,7 @@ static void mac53c94_init(struct fsc_state *state)
>   	writeb(0, &regs->config3);
>   	writeb(0, &regs->sync_period);
>   	writeb(0, &regs->sync_offset);
> -	x = readb(&regs->interrupt);
> +	(void)readb(&regs->interrupt);
>   	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
>   }
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
