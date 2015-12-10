From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Thu, 10 Dec 2015 10:42:22 -0800
Message-ID: <5669C78E.6070302@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-8-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/07/2015 12:51 PM, Christoph Hellwig wrote:
> This adds an abstraction that allows ULP to simply pass a completion
                                        ^^^

I think this should either be changed into either "an ULP" or "ULPs".

> +/**
> + * ib_process_direct_cq - process a CQ in caller context
> + * @cq:		CQ to process
> + * @budget:	number of CQEs to poll for
> + *
> + * This function is used to process all outstanding CQ entries on a
> + * %IB_POLL_DIRECT CQ.  It does not offload CQ processing to a different
> + * context and does not ask from completion interrupts from the HCA.
                                ^^^^

Should this perhaps be changed into "for" ?

> + *
> + * Note: for compatibility reasons -1 can be passed in %budget for unlimited
> + * polling.  Do not use this feature in new code, it will be remove soon.
                                                                 ^^^^^^

Did you perhaps intend "removed" ?


> +struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
> +		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx)
> +{
 > [ ... ]
> +	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);

Why is the wc array allocated separately instead of being embedded in 
struct ib_cq ? I think the faster completion queues can be created the 
better so if it is possible to eliminate the above kmalloc() call I 
would prefer that.

> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -457,10 +457,11 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
>   static void srp_destroy_qp(struct srp_rdma_ch *ch)
>   {
>   	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> -	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
> +	static struct ib_recv_wr wr = { 0 };
>   	struct ib_recv_wr *bad_wr;
>   	int ret;

Is explicit initialization to "{ 0 }" really needed for static structures ?

Bart.
