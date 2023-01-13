Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4119FC54EBE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 12:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbjAMMHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 07:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjAMMGh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 07:06:37 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E916E373BA;
        Fri, 13 Jan 2023 03:56:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 44BEB6AEB0;
        Fri, 13 Jan 2023 11:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673611000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQ+LvMVDEcgI9TeFtKsyFoqtLWbl/j3EONFmJj0jiUQ=;
        b=S4/3+XXpAI/9KIdZr/Mcdp/Gd5Ykp7DnblynHKk48Ts7LNn628gbiDH+BatkzGrHAx3ypB
        KtjKH7S5HZUm5YRcjVgFlQvydXSr6p4P87HJYydWrHI4+3eS6P6QAgS9nVziAX+v5OBsSr
        Kr4QufILIThJtJre1pADGcyniKJJe0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673611000;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQ+LvMVDEcgI9TeFtKsyFoqtLWbl/j3EONFmJj0jiUQ=;
        b=1gT4kXi7dFHGHyL/opS9ibKPBHjnXsEZLI232iwkPdF5/yVHfDCJYpCOOAtmnIvNHkw5Q2
        We9ZZg6F+Vs28iDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 325A61358A;
        Fri, 13 Jan 2023 11:56:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xLb1C/hGwWN3RAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Jan 2023 11:56:40 +0000
Message-ID: <bd26aca3-2773-a080-ee87-0598fb6d47d1@suse.de>
Date:   Fri, 13 Jan 2023 12:56:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 08/18] block: introduce BLK_STS_DURATION_LIMIT
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-9-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230112140412.667308-9-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/23 15:03, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
> report command that failed due to a command duration limit being
> exceeded. This new status is mapped to the ETIME error code to allow
> users to differentiate "soft" duration limit failures from other more
> serious hardware related errors.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   block/blk-core.c          | 3 +++
>   include/linux/blk_types.h | 6 ++++++
>   2 files changed, 9 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b5098355d8b2..67b0b24aa171 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -170,6 +170,9 @@ static const struct {
>   	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
>   	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
>   
> +	/* Command duration limit device-side timeout */
> +	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
> +
>   	/* everything else not covered above: */
>   	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
>   };
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 99be590f952f..cde997590765 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -166,6 +166,12 @@ typedef u16 blk_short_t;
>    */
>   #define BLK_STS_OFFLINE		((__force blk_status_t)17)
>   
> +/*
> + * BLK_STS_DURATION_LIMIT is returned from the driver when the target device
> + * aborted the command because it exceeded one of its Command Duration Limits.
> + */
> +#define BLK_STS_DURATION_LIMIT	((__force blk_status_t)18)
> +
>   /**
>    * blk_path_error - returns true if error may be path related
>    * @error: status the request was completed with

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

