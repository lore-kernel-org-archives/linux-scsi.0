Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0A2C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 19:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0E423D5A
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 19:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgLKSGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 13:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbgLKSFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Dec 2020 13:05:40 -0500
Date:   Sat, 12 Dec 2020 03:04:51 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607709900;
        bh=Ib27xs5IAcJ0qL2DAfNKgNMEdNLfkeQEpcKwRi5G7mA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kr+OWHANq+KjPZyzOGZUSiSgISj2y2/sM3LVsR+TeJNbyhdOL5EPWLwqo3LgfIz0J
         iZT1rjJMfVaRNo+Ll3fmlXWFWu7OFedFVeINgnAOFETfIhgwFcfhadAg7uOGxlLNcb
         FraBSV2iiM+YEzGBDvclal9L8zJ2hwW6UbQX2eV2EluwptM99dVpO3mJ0pKVuYK6mJ
         izig/qX+Var2q3VcIYh0RTphDxuSJX5vJmKCyB3kOcjbg+Cj7uQaFkWlJ709U4DeDK
         2MsWIicLLhd+VS2Elg7zMfuCCn3IKTxb4Nu6EsgNsP4vHyL4gprdLYPaBB89v5g8mo
         d2ff2xkWDbhng==
From:   Keith Busch <kbusch@kernel.org>
To:     SelvaKumar S <selvakuma.s1@samsung.com>
Cc:     linux-nvme@lists.infradead.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, Johannes.Thumshirn@wdc.com, hch@lst.de,
        sagi@grimberg.me, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org,
        mpatocka@redhat.com, hare@suse.de, dm-devel@redhat.com,
        snitzer@redhat.com, selvajove@gmail.com, nj.shetty@samsung.com,
        joshi.k@samsung.com, javier.gonz@samsung.com
Subject: Re: [RFC PATCH v3 1/2] block: add simple copy support
Message-ID: <20201211180451.GA9103@redsun51.ssa.fujisawa.hgst.com>
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
 <CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
 <20201211135139.49232-2-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211135139.49232-2-selvakuma.s1@samsung.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 11, 2020 at 07:21:38PM +0530, SelvaKumar S wrote:
> +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
> +		gfp_t gfp_mask)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	struct bio *bio;
> +	void *buf = NULL;
> +	int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
> +
> +	nr_srcs = payload->copy_range;
> +	max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;

The default value for this limit is 0, and this is the function for when
the device doesn't support copy. Are we expecting drivers to set this
value to something else for that case?

> +	cur_dest = payload->dest;
> +	buf = kvmalloc(max_range_len, GFP_ATOMIC);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_srcs; i++) {
> +		bio = bio_alloc(gfp_mask, 1);
> +		bio->bi_iter.bi_sector = payload->range[i].src;
> +		bio->bi_opf = REQ_OP_READ;
> +		bio_set_dev(bio, bdev);
> +
> +		cur_size = payload->range[i].len << SECTOR_SHIFT;
> +		ret = bio_add_page(bio, virt_to_page(buf), cur_size,
> +						   offset_in_page(payload));

'buf' is vmalloc'ed, so we don't necessarily have congituous pages. I
think you need to allocate the bio with bio_map_kern() or something like
that instead with that kind of memory.

> +		if (ret != cur_size) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
> +		ret = submit_bio_wait(bio);
> +		bio_put(bio);
> +		if (ret)
> +			goto out;
> +
> +		bio = bio_alloc(gfp_mask, 1);
> +		bio_set_dev(bio, bdev);
> +		bio->bi_opf = REQ_OP_WRITE;
> +		bio->bi_iter.bi_sector = cur_dest;
> +		ret = bio_add_page(bio, virt_to_page(buf), cur_size,
> +						   offset_in_page(payload));
> +		if (ret != cur_size) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
> +		ret = submit_bio_wait(bio);
> +		bio_put(bio);
> +		if (ret)
> +			goto out;
> +
> +		cur_dest += payload->range[i].len;
> +	}

I think this would be a faster implementation if the reads were
asynchronous with a payload buffer allocated specific to that read, and
the callback can enqueue the write part. This would allow you to
accumulate all the read data and write it in a single call. 
