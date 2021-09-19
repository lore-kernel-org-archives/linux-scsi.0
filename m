Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBB8C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Sep 2021 08:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5706960ED7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Sep 2021 08:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhISIPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Sep 2021 04:15:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40378 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhISIPr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Sep 2021 04:15:47 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 49C721FFE6;
        Sun, 19 Sep 2021 08:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632039261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NpgLEnzLN/DUVWck5mKN9UgUoDGNKkPNaxWySDFuBD4=;
        b=sQmcBr10sIrID5hQfECHJILipaIfD+p73pWR3EGV1HR/91p//2coxg/57iuCKGIX0ifAhV
        BtJjmB9uKOY9Rx2MScY2zrO3z0TdHKeEe+qN01KHNYP7EuvBWYP8mgXigQC7A8SueXV20b
        3WJst3H6S7kZPivZKxVQKy0RB833v7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632039261;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NpgLEnzLN/DUVWck5mKN9UgUoDGNKkPNaxWySDFuBD4=;
        b=5rwqeGE5yTdWTGYBCgtDjV+ILUFfGiZ1QLDizuQeR4giVqpTLsl+7nq1kuw3O25R+tK4uP
        VO89hAWqDZ4uZlCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 15C2213A6C;
        Sun, 19 Sep 2021 08:14:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gjjuA13xRmGpTgAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 19 Sep 2021 08:14:21 +0000
Subject: Re: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210917212314.2362324-1-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4a91c052-3d60-6fe4-bf4c-50487ef562b7@suse.de>
Date:   Sun, 19 Sep 2021 10:14:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210917212314.2362324-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 11:23 PM, Bart Van Assche wrote:
> This patch addresses the following Coverity report about the
> zno * sdkp->zone_blocks expression:
> 
> CID 1475514 (#1 of 1): Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
> overflow_before_widen: Potentially overflowing expression zno *
> sdkp->zone_blocks with type unsigned int (32 bits, unsigned) is evaluated
> using 32-bit arithmetic, and then used in a context that expects an
> expression of type sector_t (64 bits, unsigned).
> 
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/sd_zbc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index b9757f24b0d6..ded4d7a070a0 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -280,7 +280,7 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
>   {
>   	struct scsi_disk *sdkp;
>   	unsigned long flags;
> -	unsigned int zno;
> +	sector_t zno;
>   	int ret;
>   
>   	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
> 
Of course.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
