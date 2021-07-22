Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9764C63798
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30A961279
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhGVQyC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:54:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51324 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGVQyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 12:54:01 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 50B49226BC;
        Thu, 22 Jul 2021 17:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626975275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVNEB66lw00LZyjfdJubG4hiEl41mccx3vM8iqlnI0w=;
        b=hXm2tvvB5f0k/HICDgBCVx77TSqhxhbWpzCQABH92Y2gXhT+8gp+i6SnWqLEg2luNEuIYo
        fdiSZyQbG49YB0j8tOUtUWsbBR8DSfbgYSBrQzhvU6k2DV9n0lqcGJz7JuCfqevm/9X293
        QxYRDaid1yFrLBFCTSpy+1ZdjDHYMkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626975275;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVNEB66lw00LZyjfdJubG4hiEl41mccx3vM8iqlnI0w=;
        b=uhiAxtW+A/GqLvhE4ZOGyMwubnlAU1B2xDO7msm1mzOrHuEePeTg3gG7UkxXo5LyPqpzv5
        nMxg1b0icELnQyBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 27CD113C49;
        Thu, 22 Jul 2021 17:34:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id zcsECCus+WArNQAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 22 Jul 2021 17:34:35 +0000
Subject: Re: [PATCH 3/4] libata: support concurrent positioning ranges log
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
 <20210721104205.885115-4-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a53b07da-f012-ccfe-05a9-88a79abe6721@suse.de>
Date:   Thu, 22 Jul 2021 19:34:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210721104205.885115-4-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/21 12:42 PM, Damien Le Moal wrote:
> Add support to discover if an ATA device supports the Concurrent
> Positioning Ranges Log (address 0x47), indicating that the device is
> capable of seeking to multiple different locations in parallel using
> multiple actuators serving different LBA ranges.
> 
> Also add support to translate the concurrent positioning ranges log
> into its equivalent Concurrent Positioning Ranges VPD page B9h in
> libata-scsi.c.
> 
> The format of the Concurrent Positioning Ranges Log is defined in ACS-5
> r9.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/ata/libata-core.c | 57 +++++++++++++++++++++++++++++++++++++++
>   drivers/ata/libata-scsi.c | 46 ++++++++++++++++++++++++-------
>   include/linux/ata.h       |  1 +
>   include/linux/libata.h    | 11 ++++++++
>   4 files changed, 106 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
