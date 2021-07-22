Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7AFC63793
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 16:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F886128A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 16:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhGVPeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 11:34:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44112 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhGVPeT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 11:34:19 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B53451FF25;
        Thu, 22 Jul 2021 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626970493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ng5IfXWcOXMnGCxvCfLVT7wuMduhf0fLfHw2lU8tn4=;
        b=KrC85AGy0e2fIXGUostHedYczHE3OwfLcyb6+DqyuPhsewZhd8xZD+Z/T8wTIOHIj/vZs6
        wJkgToFzotOnz+2NlyhdfGWcUH6ar5TMLLJwswgfoZeK/I2j10rQp6yH4b5HHqWlPTgLiE
        9B4nitL9UDyOz6inOiSi5q12TzY8FpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626970493;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ng5IfXWcOXMnGCxvCfLVT7wuMduhf0fLfHw2lU8tn4=;
        b=BxGjnR3Iw+A/Zkb+YwWN90qaXrFry1Ff0Uu8bB7bhMfuxumwsguyiRbgkzhGB5foNy1h2r
        7QNFW58H0hEbacBQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 90F8613C49;
        Thu, 22 Jul 2021 16:14:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id n0rYIX2Z+WA7JwAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 22 Jul 2021 16:14:53 +0000
Subject: Re: [PATCH 2/4] scsi: sd: add concurrent positioning ranges support
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
 <20210721104205.885115-3-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c24e49dd-2605-aa9d-a6d7-47e519788d51@suse.de>
Date:   Thu, 22 Jul 2021 18:14:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210721104205.885115-3-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/21 12:42 PM, Damien Le Moal wrote:
> Add the sd_read_cpr() function to the sd scsi disk driver to discover
> if a device has multiple concurrent positioning ranges (i.e. multiple
> actuators on an HDD). This new function is called from
> sd_revalidate_disk() and uses the block layer functions
> blk_alloc_cranges() and blk_queue_set_cranges() to set a device
> cranges according to the information retrieved from log page B9h,
> if the device supports it.
> 
> The format of the Concurrent Positioning Ranges VPD page B9h is defined
> in section 6.6.6 of SBC-5.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/scsi/sd.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/sd.h |  1 +
>   2 files changed, 81 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b8d55af763f9..b1e767a01b9f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3125,6 +3125,85 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
>   		sdkp->security = 1;
>   }
>   
> +static inline sector_t sd64_to_sectors(struct scsi_disk *sdkp, u8 *buf)
> +{
> +	return logical_to_sectors(sdkp->device, get_unaligned_be64(buf));
> +}
> +
> +/**
> + * sd_read_cpr - Query concurrent positioning ranges
> + * @sdkp:	disk to query
> + */
> +static void sd_read_cpr(struct scsi_disk *sdkp)
> +{
> +	unsigned char *buffer, *desc;
> +	struct blk_cranges *cr = NULL;
> +	unsigned int nr_cpr = 0;
> +	int i, vpd_len, buf_len = SD_BUF_SIZE;
> +
> +	/*
> +	 * We need to have the capacity set first for the block layer to be
> +	 * able to check the ranges.
> +	 */
> +	if (sdkp->first_scan)
> +		return;
> +
> +	if (!sdkp->capacity)
> +		goto out;
> +
> +	/*
> +	 * Concurrent Positioning Ranges VPD: there can be at most 256 ranges,
> +	 * leading to a maximum page size of 64 + 256*32 bytes.
> +	 */
> +	buf_len = 64 + 256*32;
> +	buffer = kmalloc(buf_len, GFP_KERNEL);
> +	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
> +		goto out;
> +
> +	/* We must have at least a 64B header and one 32B range descriptor */
> +	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
> +	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Invalid Concurrent Positioning Ranges VPD page\n");
> +		goto out;
> +	}
> +
> +	nr_cpr = (vpd_len - 64) / 32;
> +	if (nr_cpr == 1) {
> +		nr_cpr = 0;
> +		goto out;
> +	}
> +
> +	cr = blk_alloc_cranges(sdkp->disk, nr_cpr);
> +	if (!cr) {
> +		nr_cpr = 0;
> +		goto out;
> +	}
> +
> +	desc = &buffer[64];
> +	for (i = 0; i < nr_cpr; i++, desc += 32) {
> +		if (desc[0] != i) {
> +			sd_printk(KERN_ERR, sdkp,
> +				"Invalid Concurrent Positioning Range number\n");
> +			nr_cpr = 0;
> +			break;
> +		}
> +
> +		cr->ranges[i].sector = sd64_to_sectors(sdkp, desc + 8);
> +		cr->ranges[i].nr_sectors = sd64_to_sectors(sdkp, desc + 16);
> +	}
> +
> +out:
> +	blk_queue_set_cranges(sdkp->disk, cr);

See? We are _are_ creating a new set of ranges.
So why bother updating the old ones?

> +	if (nr_cpr && sdkp->nr_actuators != nr_cpr) {
> +		sd_printk(KERN_NOTICE, sdkp,
> +			  "%u concurrent positioning ranges\n", nr_cpr);
> +		sdkp->nr_actuators = nr_cpr;
> +	}
> +
> +	kfree(buffer);
> +}
> +
>   /*
>    * Determine the device's preferred I/O size for reads and writes
>    * unless the reported value is unreasonably small, large, not a
> @@ -3240,6 +3319,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   		sd_read_app_tag_own(sdkp, buffer);
>   		sd_read_write_same(sdkp, buffer);
>   		sd_read_security(sdkp, buffer);
> +		sd_read_cpr(sdkp);
>   	}
>   
>   	/*
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index b59136c4125b..2e5932bde43d 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -106,6 +106,7 @@ struct scsi_disk {
>   	u8		protection_type;/* Data Integrity Field */
>   	u8		provisioning_mode;
>   	u8		zeroing_mode;
> +	u8		nr_actuators;		/* Number of actuators */
>   	unsigned	ATO : 1;	/* state of disk ATO bit */
>   	unsigned	cache_override : 1; /* temp override of WCE,RCD */
>   	unsigned	WCE : 1;	/* state of disk WCE bit */
> 
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
