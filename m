Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0FEC4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 11:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A43223122
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 11:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgLFLce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 06:32:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:42466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLFLce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Dec 2020 06:32:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C43EEAB63;
        Sun,  6 Dec 2020 11:31:52 +0000 (UTC)
Subject: Re: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from
 __blkdev_issue_zero_pages()
To:     Tom Yan <tom.ty89@gmail.com>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <20201206055332.3144-3-tom.ty89@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2eb8f838-0ec6-3e70-356b-8c04baba2fc4@suse.de>
Date:   Sun, 6 Dec 2020 12:31:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201206055332.3144-3-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 6:53 AM, Tom Yan wrote:
> Mimicking blkdev_issue_flush(). Seems like a right thing to do, as
> they are a bunch of REQ_OP_WRITE.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>   block/blk-lib.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 354dcab760c7..5579fdea893d 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -422,6 +422,8 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>   	} else if (!(flags & BLKDEV_ZERO_NOFALLBACK)) {
>   		ret = __blkdev_issue_zero_pages(bdev, sector, nr_sects,
>   						gfp_mask, &bio);
> +		if (bio)
> +			bio->bi_opf |= REQ_PREFLUSH;
>   	} else {
>   		/* No zeroing offload support */
>   		ret = -EOPNOTSUPP;
> 
PREFLUSH is for the 'flush' machinery (cf blk-flush.c). Which is okay 
for blkdev_issue_flush(), but certainly not for zeroout.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
