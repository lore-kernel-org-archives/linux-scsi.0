From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sat, 14 Nov 2015 08:13:44 +0100
Message-ID: <20151114071344.GE27738@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <20151113182513.GB21808@obsidianresearch.com> <564640C4.3000603@sandisk.com> <20151113220636.GA32133@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151113220636.GA32133-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 03:06:36PM -0700, Jason Gunthorpe wrote:
> Looking at that thread and then at the patch a bit more..
> 
> +void ib_process_cq_direct(struct ib_cq *cq)
> [..]
> +	__ib_process_cq(cq, INT_MAX);
> 
> INT_MAX is not enough, it needs to loop.
> This is missing a ib_req_notify also.

No.  Direct cases _never_ calls ib_req_notify.  Its for the case where
the SRP case polls the send CQ only from the same context it sends for
without any interrupt notification at al.

> +static int __ib_process_cq(struct ib_cq *cq, int budget)
> +	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
> 
> Does an unnecessary ib_poll_cq call in common cases. I'd suggest
> change the result to bool and do:
> 
> // true return means the caller should attempt ib_req_notify_cq
> while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
>  for (...)
>  if (n != IB_POLL_BATCH)
>    return true;
>  completed += n;
>  if (completed > budget)
>     return false;
> }
> return true;
> 
> And then change call site like:
> 
> static void ib_cq_poll_work(struct work_struct *work)
> {
>     if (__ib_process_cq(...))
>         if (ib_req_notify_cq(cq, IB_POLL_FLAGS) == 0)
> 	    return;
>     // Else we need to loop again.
>     queue_work(ib_comp_wq, &cq->work);
> }
> 
> Which avoids the rearm.
> 
> void ib_process_cq_direct(struct ib_cq *cq)
> {
>    while (1) {
>        if (__ib_process_cq(..) &&
>            ib_req_notify_cq(cq, IB_POLL_FLAGS) == 0)
>            return;
>    }
> }
> 
> Which adds the inf loop and rearm.
> 
> etc for softirq

For the workqueue and softirq cases this looks reasonable.  For the
direct case there is no rearming, though.

> Perhaps ib_req_notify_cq should be folded into __ib_process_cq, then
> it can trivially honour the budget on additional loops from
> IB_CQ_REPORT_MISSED_EVENTS.

Which also defeats this proposal.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
