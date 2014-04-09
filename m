From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct blk_mq_tags
Date: Wed, 9 Apr 2014 10:23:32 -0600
Message-ID: <53457404.5070800@fb.com>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396277175-21382-4-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/31/2014 08:46 AM, Christoph Hellwig wrote:
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 238379a..eca3a47 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -1,6 +1,24 @@
>   #ifndef INT_BLK_MQ_H
>   #define INT_BLK_MQ_H
>
> +#include <linux/percpu_ida.h>
> +
> +/*
> + * Tag address space map.
> + */
> +struct blk_mq_tags {
> +	unsigned int nr_tags;
> +	unsigned int nr_reserved_tags;
> +	unsigned int nr_batch_move;
> +	unsigned int nr_max_cache;
> +
> +	struct percpu_ida free_tags;
> +	struct percpu_ida reserved_tags;
> +
> +	struct request **rqs;
> +	struct list_head page_list;
> +};
> +

This should go into block/blk-mq-tag.h.


> -static inline struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx,
> -					       unsigned int tag)
> -{
> -	return hctx->rqs[tag];
> -}

We might as well leave this, the mtip32xx conversion ends up using it. 
So if we pull it now, it'll just be reintroduced shortly.

-- 
Jens Axboe
