From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 13:01:36 -0700
Message-ID: <20151123200136.GA5640@obsidianresearch.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com>
 <20151114070849.GD27738@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151114070849.GD27738@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 14, 2015 at 08:08:49AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 13, 2015 at 11:25:13AM -0700, Jason Gunthorpe wrote:
> > For instance, like this, not fulling draining the cq and then doing:
> > 
> > > +	completed = __ib_process_cq(cq, budget);
> > > +	if (completed < budget) {
> > > +		irq_poll_complete(&cq->iop);
> > > +		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0) {
> > 
> > Doesn't seem entirely right? There is no point in calling
> > ib_req_notify_cq if the code knows there is still stuff in the CQ and
> > has already, independently, arranged for ib_poll_hander to be
> > guarenteed called.
> 
> The code only calls ib_req_notify_cq if it knowns we finished earlier than
> our budget.

Okay, having now read the whole thing, I think I see the flow now. I don't
see any holes in the above, other than it is doing a bit more work
than it needs in some edges cases because it doesn't know if the CQ is
actually empty or not.

> > > +	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
> > > +	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
> > > +	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> > > +		queue_work(ib_comp_wq, &cq->work);
> > 
> > Same comment here..
> 
> Same here - we only requeue the work item if either we processed all of
> our budget, or ib_req_notify_cq with IB_CQ_REPORT_MISSED_EVENTS told
> us that we need to poll again.

I find the if construction hard to read, but yes, it looks OK.

Jason
