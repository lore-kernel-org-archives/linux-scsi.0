From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 21:57:43 +0100
Message-ID: <20151123205743.GA18910@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <20151113182513.GB21808@obsidianresearch.com> <20151114070849.GD27738@lst.de> <20151123200136.GA5640@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123200136.GA5640-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2015 at 01:01:36PM -0700, Jason Gunthorpe wrote:
> Okay, having now read the whole thing, I think I see the flow now. I don't
> see any holes in the above, other than it is doing a bit more work
> than it needs in some edges cases because it doesn't know if the CQ is
> actually empty or not.
> 
> > > > +	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
> > > > +	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
> > > > +	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> > > > +		queue_work(ib_comp_wq, &cq->work);
> > > 
> > > Same comment here..
> > 
> > Same here - we only requeue the work item if either we processed all of
> > our budget, or ib_req_notify_cq with IB_CQ_REPORT_MISSED_EVENTS told
> > us that we need to poll again.
> 
> I find the if construction hard to read, but yes, it looks OK.

If you're got suggestions to improve the flow please send them my way.
I'm not entirely happy with it, but couldn't come up with a better idea.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
