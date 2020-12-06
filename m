Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133D6C19425
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 11:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D275222D01
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 11:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgLFL0W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 06:26:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:40874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLFL0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Dec 2020 06:26:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1E5BAAB63;
        Sun,  6 Dec 2020 11:25:40 +0000 (UTC)
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going
 further
To:     Tom Yan <tom.ty89@gmail.com>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
References: <20201206055332.3144-1-tom.ty89@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7987f7f1-d608-26d0-3f2f-86a7bd7cc03d@suse.de>
Date:   Sun, 6 Dec 2020 12:25:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201206055332.3144-1-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 6:53 AM, Tom Yan wrote:
> At least the SCSI disk driver is "benevolent" when it try to decide
> whether the device actually supports write zeroes, i.e. unless the
> device explicity report otherwise, it assumes it does at first.
> 
> Therefore before we pile up bios that would fail at the end, we try
> the command/request once, as not doing so could trigger quite a
> disaster in at least certain case. For example, the host controller
> can be messed up entirely when one does `blkdiscard -z` a UAS drive.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>   block/blk-lib.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e90614fd8d6a..c1e9388a8fb8 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -250,6 +250,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>   	struct bio *bio = *biop;
>   	unsigned int max_write_zeroes_sectors;
>   	struct request_queue *q = bdev_get_queue(bdev);
> +	int i = 0;
>   
>   	if (!q)
>   		return -ENXIO;
> @@ -264,7 +265,17 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>   		return -EOPNOTSUPP;
>   
>   	while (nr_sects) {
> -		bio = blk_next_bio(bio, 0, gfp_mask);
> +		if (i != 1) {
> +			bio = blk_next_bio(bio, 0, gfp_mask);
> +		} else {
> +			submit_bio_wait(bio);
> +			bio_put(bio);
> +
> +			if (bdev_write_zeroes_sectors(bdev) == 0)
> +				return -EOPNOTSUPP;
> +			else
> +				bio = bio_alloc(gfp_mask, 0);
> +		}
>   		bio->bi_iter.bi_sector = sector;
>   		bio_set_dev(bio, bdev);
>   		bio->bi_opf = REQ_OP_WRITE_ZEROES;
> @@ -280,6 +291,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>   			nr_sects = 0;
>   		}
>   		cond_resched();
> +		i++;
>   	}
>   
>   	*biop = bio;
> 
We do want to keep the chain of bios intact such that end_io processing 
will recurse back to the original end_io callback.
As such we need to call bio_chain on the first bio, submit that 
(possibly with submit_bio_wait()), and then decide whether we can / 
should continue.
With your patch we'll lose the information that indeed other bios might 
be linked to the original one.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
