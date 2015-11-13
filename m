From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Fri, 13 Nov 2015 11:25:13 -0700
Message-ID: <20151113182513.GB21808@obsidianresearch.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447422410-20891-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 02:46:43PM +0100, Christoph Hellwig wrote:
> This adds an abstraction that allows ULP to simply pass a completion
> object and completion callback with each submitted WR and let the RDMA
> core handle the nitty gritty details of how to handle completion
> interrupts and poll the CQ.

This looks pretty nice, I'd really like to look it over carefully
after SC|15..

I know Bart and others have attempted to have switching between event
and polling driven operation, but there were problems resolving the
races. Would be nice to review that conversation.. Do you remember the
details Bart?

> +static int __ib_process_cq(struct ib_cq *cq, int budget)
> +{
> +	int i, n, completed = 0;
> +
> +	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
> +		completed += n;
> +		if (completed >= budget)
> +			break;

For instance, like this, not fulling draining the cq and then doing:

> +	completed = __ib_process_cq(cq, budget);
> +	if (completed < budget) {
> +		irq_poll_complete(&cq->iop);
> +		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0) {

Doesn't seem entirely right? There is no point in calling
ib_req_notify_cq if the code knows there is still stuff in the CQ and
has already, independently, arranged for ib_poll_hander to be
guarenteed called.

> +			if (!irq_poll_sched_prep(&cq->iop))
> +				irq_poll_sched(&cq->iop);

Which, it seems, is what this is doing.

Assuming irq_poll_sched is safe to call from a hard irq context, this
looks sane, at first glance.

> +	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
> +	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
> +	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> +		queue_work(ib_comp_wq, &cq->work);

Same comment here..

> +static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
> +{
> +	queue_work(ib_comp_wq, &cq->work);

> +	switch (cq->poll_ctx) {
> +	case IB_POLL_DIRECT:
> +		cq->comp_handler = ib_cq_completion_direct;
> +		break;
> +	case IB_POLL_SOFTIRQ:
> +		cq->comp_handler = ib_cq_completion_softirq;
> +
> +		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
> +		irq_poll_enable(&cq->iop);
> +		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
> +		break;

I understand several drivers are not using a hard irq context for the
comp_handler call back. Is there any way to exploit that in this new
API so we don't have to do so many context switches? Ie if the driver
already is using a softirq when calling comp_handler can we somehow
just rig ib_poll_handler directly and avoid the overhead? (Future)

At first glance this seems so much saner than what we have..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
