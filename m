From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Tue, 17 Nov 2015 09:52:58 -0800
Message-ID: <564B697A.2020601@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447422410-20891-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
> + * context and does not ask from completion interrupts from the HCA.
                                ^^^^
Should this perhaps be changed into "for" ?

> + */
> +void ib_process_cq_direct(struct ib_cq *cq)
> +{
> +	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
> +
> +	__ib_process_cq(cq, INT_MAX);
> +}
> +EXPORT_SYMBOL(ib_process_cq_direct);

My proposal is to drop this function and to export __ib_process_cq() 
instead (with or without renaming). That will allow callers of this 
function to compare the poll budget with the number of completions that 
have been processed and use that information to decide whether or not to 
call this function again.

> +static void ib_cq_poll_work(struct work_struct *work)
> +{
> +	struct ib_cq *cq = container_of(work, struct ib_cq, work);
> +	int completed;
> +
> +	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
> +	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
> +	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> +		queue_work(ib_comp_wq, &cq->work);
> +}
> +
> +static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
> +{
> +	queue_work(ib_comp_wq, &cq->work);
> +}

The above code will cause all polling to occur on the context of the CPU 
that received the completion interrupt. This approach is not powerful 
enough. For certain workloads throughput is higher if work completions 
are processed by another CPU core on the same CPU socket. Has it been 
considered to make the CPU core on which work completions are processed 
configurable ?

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 62b6cba..3027824 100644
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

Since the 'wr' structure is static I don't think it needs to be 
zero-initialized explicitly.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
