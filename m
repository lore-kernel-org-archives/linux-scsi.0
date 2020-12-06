Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28ECEC4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 11:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7ED23122
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 11:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgLFLaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 06:30:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:41804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgLFLaG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Dec 2020 06:30:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F55BABE9;
        Sun,  6 Dec 2020 11:29:24 +0000 (UTC)
Subject: Re: [PATCH 2/3] block: make __blkdev_issue_zero_pages() less
 confusing
To:     Tom Yan <tom.ty89@gmail.com>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <20201206055332.3144-2-tom.ty89@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ed132ef1-b4d0-6e3f-2c7c-a9292bccbfe2@suse.de>
Date:   Sun, 6 Dec 2020 12:29:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201206055332.3144-2-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 6:53 AM, Tom Yan wrote:
> Instead of using the same check for the two layers of loops, count
> bio pages in the inner loop instead.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>   block/blk-lib.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index c1e9388a8fb8..354dcab760c7 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -318,7 +318,7 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
>   	struct request_queue *q = bdev_get_queue(bdev);
>   	struct bio *bio = *biop;
>   	int bi_size = 0;
> -	unsigned int sz;
> +	unsigned int sz, bio_nr_pages;
>   
>   	if (!q)
>   		return -ENXIO;
> @@ -327,19 +327,18 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
>   		return -EPERM;
>   
>   	while (nr_sects != 0) {
> -		bio = blk_next_bio(bio, __blkdev_sectors_to_bio_pages(nr_sects),
> -				   gfp_mask);
> +		bio_nr_pages = __blkdev_sectors_to_bio_pages(nr_sects);
> +		bio = blk_next_bio(bio, bio_nr_pages, gfp_mask);
>   		bio->bi_iter.bi_sector = sector;
>   		bio_set_dev(bio, bdev);
>   		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
>   
> -		while (nr_sects != 0) {
> +		while (bio_nr_pages != 0) {
>   			sz = min((sector_t) PAGE_SIZE, nr_sects << 9);

nr_sects will need to be modified, too, if we iterate over bio_nr_pages 
instead of nr_sects.

>   			bi_size = bio_add_page(bio, ZERO_PAGE(0), sz, 0);
>   			nr_sects -= bi_size >> 9;
>   			sector += bi_size >> 9;
> -			if (bi_size < sz)
> -				break;
> +			bio_nr_pages--;
>   		}
>   		cond_resched();
>   	}
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
