From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of queue
Date: Thu, 22 Jan 2009 13:46:41 +0100
Message-ID: <20090122124640.GQ30821@kernel.dk>
References: <4976F067.8000501@panasas.com> <20090122082314G.fujita.tomonori@lab.ntt.co.jp> <20090122111302.GG30821@kernel.dk> <49786A1E.3070707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:22616 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZAVMsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 07:48:15 -0500
Content-Disposition: inline
In-Reply-To: <49786A1E.3070707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Thu, Jan 22 2009, Boaz Harrosh wrote:
> Jens Axboe wrote:
> > On Thu, Jan 22 2009, FUJITA Tomonori wrote:
> >> On Wed, 21 Jan 2009 11:52:39 +0200
> >> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>
> >>> Currently inherited from sg.c bsg will submit asynchronous request
> >>> at the head-of-the-queue, (using "at_head" set in the call to
> >>> blk_execute_rq_nowait()). This is bad in situation where we want
> >>> to keep the queues full but need the requests to execute in order.
> >> As I wrote, I think that blk_execute_rq_nowait inserts a request and
> >> plugs a queue. So how can you keep the queue full? On the completion
> >> of blk_execute_rq_nowait, the queue is empty.
> > 
> > That's not true at all. If you submit more than one request, request 2
> > and up would be queued according to the orientation given. It may even
> > include request 1 as well, what if the queue is busy doing work for
> > someone else already?
> > 
> > I think the patch makes sense, I also wish that the default would have
> > been reversed so that at_back would be the default. at_back is more
> > complex though, since it impacts existing requests for the device (it
> > drains the scheduler queue).
> > 
> 
> bsg only sends BLOCK_PC commands, I think these are not held in the
> scheduler queue, right? 

They are not, correct. But that queue may have other requests pending,
which may be "normal" file system requests. Then an at_back bsg command
would act almost like a barrier, draining the entire queue to dispatch.

> I think like you at_back is the default to use, but this is historic
> compatibility with SG that had problems with ABORT and such not. With
> my patch I give the user a choice and be done with it.

at_head is definitely useful and required for some situations, but that
doesn't mean it's a good default :-). But yes, we are stuck with it. I
think the patch makes sense.

-- 
Jens Axboe

