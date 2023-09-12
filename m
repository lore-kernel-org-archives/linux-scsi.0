Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93B1CA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 06:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjILGON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 02:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjILGOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 02:14:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB2AF;
        Mon, 11 Sep 2023 23:14:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4B0B91F381;
        Tue, 12 Sep 2023 06:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694499247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1VLriqg3O3jmQYK++s89PmQhcS6DmrIJVLO/ZjRICxE=;
        b=vnpsOQUwRLqyOHYjrXTrVp/Ogp2ESjvZ+h7VqfYYkJtBOtM/tPbWRSN8WOXCOt5sXoyyAG
        zYIhIYEk77t+R2JIjS4TYJaVtTSLo7DC6pwNZvZ4CSzw7Nif/5Q8V27WzkoLHLrSut+iks
        xYE1ITPZ+W6I+tDLuspx8z95AFcVDBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694499247;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1VLriqg3O3jmQYK++s89PmQhcS6DmrIJVLO/ZjRICxE=;
        b=6RG5AWfBKX6HwIY0UdaFttvDonkqUn+105qzI2x5I+0ZPLhS+9GkdThmZscSTMw2LiCer2
        z7NI8bc5jdT6/jBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0ED8613A39;
        Tue, 12 Sep 2023 06:14:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6s12Aq8BAGX5WQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 12 Sep 2023 06:14:07 +0000
Message-ID: <57456b6f-5e6c-41ea-beac-25f1eb21bdf0@suse.de>
Date:   Tue, 12 Sep 2023 08:14:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/21] ata: libata-core: Fix compilation warning in
 ata_dev_config_ncq()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230912005655.368075-1-dlemoal@kernel.org>
 <20230912005655.368075-9-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230912005655.368075-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 02:56, Damien Le Moal wrote:
> The 24 bytes length allocated to the ncq_desc string in
> ata_dev_config_lba() for ata_dev_config_ncq() to use is too short,
> causing the following gcc compilation warnings when compiling with W=1:
> 
> drivers/ata/libata-core.c: In function ‘ata_dev_configure’:
> drivers/ata/libata-core.c:2378:56: warning: ‘%d’ directive output may be truncated writing between 1 and 2 bytes into a region of size between 1 and 11 [-Wformat-truncation=]
>   2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
>        |                                                        ^~
> In function ‘ata_dev_config_ncq’,
>      inlined from ‘ata_dev_config_lba’ at drivers/ata/libata-core.c:2649:8,
>      inlined from ‘ata_dev_configure’ at drivers/ata/libata-core.c:2952:9:
> drivers/ata/libata-core.c:2378:41: note: directive argument in the range [1, 32]
>   2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
>        |                                         ^~~~~~~~~~~~~~~~~~~~~
> drivers/ata/libata-core.c:2378:17: note: ‘snprintf’ output between 16 and 31 bytes into a destination of size 24
>   2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
>        |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   2379 |                         ddepth, aa_desc);
>        |                         ~~~~~~~~~~~~~~~~
> 
> Avoid these warnings and the potential truncation by changing the size
> of the ncq_desc string to 32 characters.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 18b2a0da9e54..2405ac8b53f0 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2619,7 +2619,7 @@ static int ata_dev_config_lba(struct ata_device *dev)
>   {
>   	const u16 *id = dev->id;
>   	const char *lba_desc;
> -	char ncq_desc[24];
> +	char ncq_desc[32];
>   	int ret;
>   
>   	dev->flags |= ATA_DFLAG_LBA;
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

