From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Fri, 13 Nov 2015 15:06:36 -0700
Message-ID: <20151113220636.GA32133@obsidianresearch.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com>
 <564640C4.3000603@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564640C4.3000603@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 11:57:56AM -0800, Bart Van Assche wrote:

> I think this is the conversation you are referring to: "About a shortcoming
> of the verbs API" (http://thread.gmane.org/gmane.linux.drivers.rdma/5028).
> That conversation occurred five years ago, which means that you have an
> excellent memory :-)

Heh, the whole thread is interesting, but this message is what I was
thinking of

http://thread.gmane.org/gmane.linux.drivers.rdma/5028

And it looks like this patch is OK relative to that discussion.

> I doesn't seem to me like Christoph wanted to support dynamic switching
> between the IB_POLL_DIRECT, IB_POLL_SOFTIRQ and IB_POLL_WORKQUEUE polling
> modes. I think this should have been mentioned in the patch description.

Indeed. Which is probably OK.

> The implementation of this patch makes it clear that it is essential that
> all polling is serialized. The WC array that is used for polling is embedded
> in the CQ and is not protected against concurrent access. This means that it
> is essential that _ib_process_cq() calls are serialized. I need some more
> time to verify whether such serialization is always guaranteed by this
> patch.

Yes, the two big design/review checks 
 - ib_process_cq is fully serialized/etc
 - All re-arm cases are done properly - rearm is only called when the
   CQ is empty and all cases where it is not empty guarentee that the
   polling loop happens again.

Looking at that thread and then at the patch a bit more..

+void ib_process_cq_direct(struct ib_cq *cq)
[..]
+	__ib_process_cq(cq, INT_MAX);

INT_MAX is not enough, it needs to loop.
This is missing a ib_req_notify also.

And this structure:

+static int __ib_process_cq(struct ib_cq *cq, int budget)
+	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {

Does an unnecessary ib_poll_cq call in common cases. I'd suggest
change the result to bool and do:

// true return means the caller should attempt ib_req_notify_cq
while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
 for (...)
 if (n != IB_POLL_BATCH)
   return true;
 completed += n;
 if (completed > budget)
    return false;
}
return true;

And then change call site like:

static void ib_cq_poll_work(struct work_struct *work)
{
    if (__ib_process_cq(...))
        if (ib_req_notify_cq(cq, IB_POLL_FLAGS) == 0)
	    return;
    // Else we need to loop again.
    queue_work(ib_comp_wq, &cq->work);
}

Which avoids the rearm.

void ib_process_cq_direct(struct ib_cq *cq)
{
   while (1) {
       if (__ib_process_cq(..) &&
           ib_req_notify_cq(cq, IB_POLL_FLAGS) == 0)
           return;
   }
}

Which adds the inf loop and rearm.

etc for softirq

Perhaps ib_req_notify_cq should be folded into __ib_process_cq, then
it can trivially honour the budget on additional loops from
IB_CQ_REPORT_MISSED_EVENTS.

Jason
