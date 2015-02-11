From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: fix double-free in error path
Date: Wed, 11 Feb 2015 09:43:49 -0700
Message-ID: <54DB86C5.4090607@kernel.dk>
References: <54DB841E.6030108@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DB841E.6030108@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/11/2015 09:32 AM, Tony Battersby wrote:
> If the allocation of bt->bs fails, then bt->map can be freed twice, once
> in blk_mq_init_bitmap_tags() -> bt_alloc(), and once in
> blk_mq_init_bitmap_tags() -> bt_free().  Fix by setting the pointer to
> NULL after the first free.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>
> For inclusion in kernel 3.20.
>
> --- linux-3.19.0/block/blk-mq-tag.c.orig	2015-02-08 21:54:22.000000000 -0500
> +++ linux-3.19.0/block/blk-mq-tag.c	2015-02-10 09:42:38.000000000 -0500
> @@ -509,6 +509,7 @@ static int bt_alloc(struct blk_mq_bitmap
>   	bt->bs = kzalloc(BT_WAIT_QUEUES * sizeof(*bt->bs), GFP_KERNEL);
>   	if (!bt->bs) {
>   		kfree(bt->map);
> +		bt->map = NULL;
>   		return -ENOMEM;
>   	}

Thanks Tony, applied.


-- 
Jens Axboe
