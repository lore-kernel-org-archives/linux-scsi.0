From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V2 1/2] blk-mq: add callback of .cleanup_rq
Date: Mon, 22 Jul 2019 09:51:27 -0700
Message-ID: <4ffe9dd8-9e86-fd93-828e-78c1e5931c5f@acm.org>
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190720030637.14447-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190720030637.14447-2-ming.lei@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/19/19 8:06 PM, Ming Lei wrote:
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b038ec680e84..fc38d95c557f 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -502,6 +502,9 @@ void blk_mq_free_request(struct request *rq)
>   	struct blk_mq_ctx *ctx = rq->mq_ctx;
>   	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
>   
> +	if (q->mq_ops->cleanup_rq)
> +		q->mq_ops->cleanup_rq(rq);
> +
>   	if (rq->rq_flags & RQF_ELVPRIV) {
>   		if (e && e->type->ops.finish_request)
>   			e->type->ops.finish_request(rq);

I'm concerned about the performance impact of this change. How about not 
introducing .cleanup_rq() and adding a call to
scsi_mq_uninit_cmd() in scsi_queue_rq() just before that function 
returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE?

Thanks,

Bart.
