From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Fri, 17 Apr 2015 15:20:47 -0700
Message-ID: <1429309247.1079.56.camel@HansenPartnership.com>
References: <1429301471-5666-1-git-send-email-hch@lst.de>
			 <1429306960.1079.25.camel@HansenPartnership.com>
		 <55317EAE.10201@kernel.dk>
	 <1429307160.1079.27.camel@HansenPartnership.com>
		 <55317F86.7030509@kernel.dk>
	 <1429307850.1079.35.camel@HansenPartnership.com>
	 <5531843B.4070608@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34154 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbbDQWUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 18:20:48 -0400
In-Reply-To: <5531843B.4070608@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, 2015-04-17 at 16:07 -0600, Jens Axboe wrote:
> On 04/17/2015 03:57 PM, James Bottomley wrote:
> > On Fri, 2015-04-17 at 15:47 -0600, Jens Axboe wrote:
> >> On 04/17/2015 03:46 PM, James Bottomley wrote:
> >>> On Fri, 2015-04-17 at 15:44 -0600, Jens Axboe wrote:
> >>>> On 04/17/2015 03:42 PM, James Bottomley wrote:
> >>>>>> @@ -662,32 +662,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> >>>>>>      */
> >>>>>>     int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
> >>>>>>     {
> >>>>>> -	unsigned long flags;
> >>>>>> -
> >>>>>> -	if (depth <= 0)
> >>>>>> -		goto out;
> >>>>>> -
> >>>>>> -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> >>>>>> +	if (depth > 0) {
> >>>>>> +		unsigned long flags;
> >>>>>>
> >>>>>> -	/*
> >>>>>> -	 * Check to see if the queue is managed by the block layer.
> >>>>>> -	 * If it is, and we fail to adjust the depth, exit.
> >>>>>> -	 *
> >>>>>> -	 * Do not resize the tag map if it is a host wide share bqt,
> >>>>>> -	 * because the size should be the hosts's can_queue. If there
> >>>>>> -	 * is more IO than the LLD's can_queue (so there are not enuogh
> >>>>>> -	 * tags) request_fn's host queue ready check will handle it.
> >>>>>> -	 */
> >>>>>> -	if (!shost_use_blk_mq(sdev->host) && !sdev->host->bqt) {
> >>>>>> -		if (blk_queue_tagged(sdev->request_queue) &&
> >>>>>> -		    blk_queue_resize_tags(sdev->request_queue, depth) != 0)
> >>>>>> -			goto out_unlock;
> >>>>>> +		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> >>>>>> +		sdev->queue_depth = depth;
> >>>>>> +		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> >>>>>
> >>>>> This lock/unlock is a nasty global sync point which can be eliminated:
> >>>>> we can rely on the architectural atomicity of 32 bit writes (might need
> >>>>> to make sdev->queue_depth a u32 because I seem to remember 16 bit writes
> >>>>> had to be done as two byte stores on some architectures).
> >>>>
> >>>> It's not in a hot path (by any stretch), so doesn't really matter...
> >>>
> >>> Sure, but it's good practise not to do this, otherwise the pattern
> >>> lock/u32 store/unlock gets duplicated into hot paths by people who are
> >>> confused about whether locking is required.
> >>
> >> It's a lot saner default to lock/unlock and have people copy that, than
> >> have them misguidedly think that no locking is require for whatever
> >> reason.
> >
> > Moving to lockless coding is important for the small packet performance
> > we're all chasing.  I'd rather train people to think about the problem
> > than blindly introduce unnecessary locking and then have someone else
> > remove it in the name of performance improvement.  If they get it wrong
> > the other way (no locking where it was needed) our code review process
> > should spot that.
> 
> We're chasing cycles for the hot path, not for the init path. I'd much 
> rather keep it simple where we can, and keep the much harder problems 
> for the cases that really matter. Locking and ordering is _hard_, most 
> people get it wrong, most of the time. And spotting missing locking at 
> review time is a much harder problem. I would generally recommend people 
> get it right _first_, then later work on optimizing the crap out of it. 
> That's much easier to do with a stable base anyway.

OK, so I think we can agree to differ.  You're saying care only where it
matters because that's where you should concentrate and I'm saying care
everywhere because that disciplines you to be correct where it matters.

> > In this case, it is a problem because in theory the language ('C') makes
> > no such atomicity guarantees (which is why most people think you need a
> > lock here).  The atomicity guarantees are extrapolated from the platform
> > it's running on.
> >
> >>   The write itself might be atomic, but you still need to
> >> guarantee visibility.
> >
> > The function barrier guarantees mean it's visible by the time the
> > function returns.  However, I wouldn't object to a wmb here if you think
> > it's necessary ... it certainly serves as a marker for "something clever
> > is going on".
> 
> The sequence point means it's not reordered across it, it does not give 
> you any guarantees on visibility. And we're getting into semantics of C 
> here, but I believe or that even to be valid, you'd need to make 
> ->queue_depth volatile. And honestly, I'd hate to rely on that. Which 
> means you need proper barriers.

Actually, no, not at all.  Volatile is a compiler optimisation
primitive.  It means the compiler may not keep any assignment to this
location internally.  Visibility of stores depends on two types of
barrier:  One is influenced by the ability of the compiler to reorder
operations, which it may up to a barrier.  The other is the ability of
the architecture to reorder the execution pipelines, and so execute out
of order the instructions the compiler created, which it may up to a
barrier sync instruction.  wmb is a heavyweight barrier instruction that
would make sure all stores before this become visibile to everything in
the system.  In this case it's not necessary because a function return
is also a compile and execution barrier, so as long as we don't care
about visibility until the scsi_change_queue_depth() function returns
(which I think we don't), then no explicit barrier is required (and
certainly no volatile on the stored location).

There's a good treatise on this in Documentation/memory-barriers.txt but
I do find it over didactic for the simple issues.

James


