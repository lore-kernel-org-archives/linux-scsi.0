Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E848BEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 05:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjGTFtI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 01:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjGTFtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 01:49:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352951724;
        Wed, 19 Jul 2023 22:49:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E1C6322852;
        Thu, 20 Jul 2023 05:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689832144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a76sDczioy04Jw43uE+SA3jdqHb/0YHga7z5CjMc80U=;
        b=oehow6bwsmXJD11l6K8+HCalRfgly3PQ+m2dl+S6B3PYr4YW1Rg1TjmgDG5Hi8L2JlVKfV
        /A2A3c+lIq2tIGuNpqpZ6/NGz89Py613yNvfjeGnHS7dzkq20aOG1W9BMv8mgPK/SEA8YT
        8rSB/OD7Bj9+cyQHQ/lvY00cX/wUe9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689832144;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a76sDczioy04Jw43uE+SA3jdqHb/0YHga7z5CjMc80U=;
        b=3ZjUuAXWmdpq7uJyXXruMnHr0mf0j12qaVvjm5eKySIJKdn02YkVY4WgU28qSxvT2+7Bhw
        EpH0i1bJGrNHFRBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B91CF1361C;
        Thu, 20 Jul 2023 05:49:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sS8zKtDKuGTSVwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 20 Jul 2023 05:49:04 +0000
Message-ID: <99c1d56f-452d-5c3b-1c80-57adb60cb79e@suse.de>
Date:   Thu, 20 Jul 2023 07:49:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 7/8] ata: sata_sx4: drop already completed TODO
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-8-nks@flawful.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230720004257.307031-8-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/23 02:42, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The TODO claims that the pdc_20621_ops should set the .inherits
> function pointer to &ata_base_port_ops after it has been converted
> to use the new EH.
> 
> However, the driver was converted to use the new EH a long time ago,
> in commit 67651ee5710c ("[libata] sata_sx4: convert to new exception
> handling methods"), which also did set .inherits function pointer to
> &ata_sff_port_ops (and ata_sff_port_ops itself has .inherits set to
> &ata_base_port_ops).
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/sata_sx4.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
> index ccc016072637..b51d7a9d0d90 100644
> --- a/drivers/ata/sata_sx4.c
> +++ b/drivers/ata/sata_sx4.c
> @@ -232,7 +232,6 @@ static const struct scsi_host_template pdc_sata_sht = {
>   	.dma_boundary		= ATA_DMA_BOUNDARY,
>   };
>   
> -/* TODO: inherit from base port_ops after converting to new EH */
>   static struct ata_port_operations pdc_20621_ops = {
>   	.inherits		= &ata_sff_port_ops,
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

