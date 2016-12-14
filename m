From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND v2 1/2] blk-mq: Fix failed allocation path when
 mapping queues
Date: Wed, 14 Dec 2016 08:13:53 -0700
Message-ID: <8e73a861-ad57-be0a-2a58-da8aae38f06c@kernel.dk>
References: <1481038304-22502-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1481038304-22502-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: wenxiong@linux.vnet.ibm.com, gpiccoli@linux.vnet.ibm.com, hch@infradead.org, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/06/2016 08:31 AM, Gabriel Krisman Bertazi wrote:
> This should apply cleanly on top of Jen's for-next branch.

Jens, not Jen.

> @@ -1893,6 +1893,15 @@ static void blk_mq_map_swqueue(struct request_queue *q,
>  		if (!cpumask_test_cpu(i, online_mask))
>  			continue;
>  
> +		hctx_idx = q->mq_map[i];
> +		/* unmapped hw queue can be remapped after CPU topo changed */
> +		if (!set->tags[hctx_idx]) {
> +			set->tags[hctx_idx] = blk_mq_init_rq_map(set, hctx_idx);
> +
> +			if (!set->tags[hctx_idx])
> +				q->mq_map[i] = 0;
> +		}

This needs a comment on why you're assigning mq_map[i] - because we keep
queue 0, in case the rest fail allocating.

> @@ -1917,11 +1929,8 @@ static void blk_mq_map_swqueue(struct request_queue *q,
>  			continue;
>  		}
>  
> -		/* unmapped hw queue can be remapped after CPU topo changed */
> -		if (!set->tags[i])
> -			set->tags[i] = blk_mq_init_rq_map(set, i);
>  		hctx->tags = set->tags[i];
> -		WARN_ON(!hctx->tags);
> +		BUG_ON(!hctx->tags);

No BUG_ON(), please, it's not necessary to take down the machine if this fails.
It might be game over for that machine, if the driver is hosting the data
or root fs, but it might not be.

-- 
Jens Axboe

