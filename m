Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8529C7EE24
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 08:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjFEIEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 04:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjFEIEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 04:04:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BAFA9;
        Mon,  5 Jun 2023 01:04:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0AF5D1F8AB;
        Mon,  5 Jun 2023 08:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685952275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11ypo9zueCD1RWPZj98NCGALjzrhP1G7VSkBxzi0R8U=;
        b=r+/ByeLbAVzngXYwfz21RLY9Zj3TXZF3XB3HZUfqTL30R2s7cY5RHxC/6HNq2ZgB57+Mfp
        laJHgMBcZqnRisUeP9UQppeOFtgk3tBs6N7x9NfParhtDjwB65pUGGoqBwFPbr2xjWNRVH
        /Dw8g5SfQJ4HS8naeublflCR9L3Ex+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685952275;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11ypo9zueCD1RWPZj98NCGALjzrhP1G7VSkBxzi0R8U=;
        b=NOPfSy9BpHntlgC6dkFffHBAoD5nM5hr+Tv8bWa5BJJKePReiDrsL9g1hYiZpUgqtDKsri
        j1WrHjAI4mMu3aBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDDA3139C8;
        Mon,  5 Jun 2023 08:04:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wW1bNRKXfWR+fQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 05 Jun 2023 08:04:34 +0000
Message-ID: <801bad24-7423-225a-52ec-177df0da0006@suse.de>
Date:   Mon, 5 Jun 2023 10:04:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-4-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230605013212.573489-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 03:32, Damien Le Moal wrote:
> In ata_scsi_dev_config(), instead of hardconing the test to check if
> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
> ata_ncq_supported().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 8ce90284eb34..22e2e9ab6b60 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1122,7 +1122,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>   	if (dev->flags & ATA_DFLAG_AN)
>   		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
>   
> -	if (dev->flags & ATA_DFLAG_NCQ)
> +	if (ata_ncq_supported(dev))
>   		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>   	depth = min(ATA_MAX_QUEUE, depth);
>   	scsi_change_queue_depth(sdev, depth);

Argh. ATA NCQ flags. We have ATA_DFLAG_NCQ, ATA_DFLAG_PIO, 
ATA_DFLAG_NCQ_OFF (and maybe even more which I forgot about).
Can we please move them into some more descriptive, ie which flags
are for the drive capabilities (ie _can_ the drive do NCQ) and
the current current drive status (ie _does_ the drive do NCQ)?
As it stands it's quite confusing.

But probably not a problem with this patch, so:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

