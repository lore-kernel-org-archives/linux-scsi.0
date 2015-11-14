From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sat, 14 Nov 2015 08:08:49 +0100
Message-ID: <20151114070849.GD27738@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <20151113182513.GB21808@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151113182513.GB21808-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 11:25:13AM -0700, Jason Gunthorpe wrote:
> For instance, like this, not fulling draining the cq and then doing:
> 
> > +	completed = __ib_process_cq(cq, budget);
> > +	if (completed < budget) {
> > +		irq_poll_complete(&cq->iop);
> > +		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0) {
> 
> Doesn't seem entirely right? There is no point in calling
> ib_req_notify_cq if the code knows there is still stuff in the CQ and
> has already, independently, arranged for ib_poll_hander to be
> guarenteed called.

The code only calls ib_req_notify_cq if it knowns we finished earlier than
our budget.

> > +	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
> > +	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
> > +	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> > +		queue_work(ib_comp_wq, &cq->work);
> 
> Same comment here..


Same here - we only requeue the work item if either we processed all of
our budget, or ib_req_notify_cq with IB_CQ_REPORT_MISSED_EVENTS told
us that we need to poll again.

> I understand several drivers are not using a hard irq context for the
> comp_handler call back. Is there any way to exploit that in this new
> API so we don't have to do so many context switches? Ie if the driver
> already is using a softirq when calling comp_handler can we somehow
> just rig ib_poll_handler directly and avoid the overhead? (Future)

Let's say this API makes it possible.  I still don't think moving the
whole budget and rearm logic into the LLD is necessarily a good idea
if we can avoid it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
