From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Fri, 11 Dec 2015 15:17:49 +0100
Message-ID: <20151211141749.GA20201@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de> <1449521512-22921-8-git-send-email-hch@lst.de> <5669C78E.6070302@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5669C78E.6070302@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 10:42:22AM -0800, Bart Van Assche wrote:
>> +struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
>> +		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx)
>> +{
> > [ ... ]
>> +	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
>
> Why is the wc array allocated separately instead of being embedded in 
> struct ib_cq ? I think the faster completion queues can be created the 
> better so if it is possible to eliminate the above kmalloc() call I would 
> prefer that.

I originally allocated an embedded aray, but Sagi pointed out that
we'd waste memory for CQs not using the new API, so I changed it.
The embedded one would be quite a bit simpler indeed.

>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -457,10 +457,11 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
>>   static void srp_destroy_qp(struct srp_rdma_ch *ch)
>>   {
>>   	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
>> -	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
>> +	static struct ib_recv_wr wr = { 0 };
>>   	struct ib_recv_wr *bad_wr;
>>   	int ret;
>
> Is explicit initialization to "{ 0 }" really needed for static structures ?

It shouldn't be needed, but I can't see how it harms either.
