From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 13:37:12 -0700
Message-ID: <20151123203712.GB5640@obsidianresearch.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com>
 <564640C4.3000603@sandisk.com>
 <20151113220636.GA32133@obsidianresearch.com>
 <20151114071344.GE27738@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151114071344.GE27738-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 14, 2015 at 08:13:44AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 13, 2015 at 03:06:36PM -0700, Jason Gunthorpe wrote:
> > Looking at that thread and then at the patch a bit more..
> > 
> > +void ib_process_cq_direct(struct ib_cq *cq)
> > [..]
> > +	__ib_process_cq(cq, INT_MAX);
> > 
> > INT_MAX is not enough, it needs to loop.
> > This is missing a ib_req_notify also.
> 
> No.  Direct cases _never_ calls ib_req_notify.  Its for the case where
> the SRP case polls the send CQ only from the same context it sends for
> without any interrupt notification at al.

Hurm, okay, that is not at all what I was thinking this was for..

So the only use of this function is to drain a send cq, in a state
where it is guarenteed no new entries can be added, and only if the cq
is not already event driven. I'd stick those notes in the comment..

Hum. I wonder if this is even a reasonable way to run a ULP. It is
important that rx completions are not used to drive reaping of
resources that are still committed to the send queue. ie do not
trigger send buffer reuse based on a rx completion.

So, if a ULP uses this API, how does it handle the sendq becoming
full? As above, a ULP cannot use recvs to infer available sendq
space. It must directly reap the sendq. So a correct ULP would have to
spin calling ib_process_direct_cq until it makes enough progress to
add more things to the sendq. I don't obviously see that in SRP - so
I'm guessing it has buggered up sendq flow control?

NFS had similar problems lately too, I wrote a long explanation to
Chuck on this subject.

That said, the demand poll almost seems like a reasonable way for a
ULP to run the sendq, do the polls on send occasionally or when more
space is needed to better amortize the reaping overhead at the cost of
send latency. But API wise it needs to be able to switch over to a
sleep if enough progress hasn't been made.

So.. maybe also add to the comment that ib_process_cq_direct is
deprecated and should not be used in new code until SRP gets sorted?

> > Perhaps ib_req_notify_cq should be folded into __ib_process_cq, then
> > it can trivially honour the budget on additional loops from
> > IB_CQ_REPORT_MISSED_EVENTS.
> 
> Which also defeats this proposal.

Just ignore my remarks here, someone should do a benchmark to see if
we are hitting the edge cases of extra spins around the various loops
before reworking this. Can't trivially hoist ib_req_notify_cq into
__ib_process_cq because of how it needs to be ordered with
irq_poll_complete

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
