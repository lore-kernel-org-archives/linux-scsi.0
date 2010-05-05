From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/9] blk: Do not abort requests if queue is stopped
Date: Tue, 4 May 2010 21:52:31 -0700
Message-ID: <20100505045231.GA25395@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
 <1272944228-30511-2-git-send-email-andmike@linux.vnet.ibm.com>
 <20100504104537.GN27497@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47186 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0EEEwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2010 00:52:33 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o454kfNp004646
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 22:46:41 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o454qWR1129656
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 22:52:32 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o44LqVUG028729
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 15:52:32 -0600
Content-Disposition: inline
In-Reply-To: <20100504104537.GN27497@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, May 03 2010, Mike Anderson wrote:
> > If the queue is stopped it could be an indication that other recovery is
> > happening in this case skip the blk_abort_request.
> > 
> > Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> > Cc: Jens Axobe <jens.axboe@oracle.com>
> > ---
> >  block/blk-timeout.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/block/blk-timeout.c b/block/blk-timeout.c
> > index 1ba7e0a..89fbe0a 100644
> > --- a/block/blk-timeout.c
> > +++ b/block/blk-timeout.c
> > @@ -224,7 +224,8 @@ void blk_abort_queue(struct request_queue *q)
> >  	list_splice_init(&q->timeout_list, &list);
> >  
> >  	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
> > -		blk_abort_request(rq);
> > +		if (!blk_queue_stopped(q))
> > +			blk_abort_request(rq);
> >  
> >  	/*
> >  	 * Occasionally, blk_abort_request() will return without
> 
> That seems like a bit of a mixup, what ties a stopped queue to recovery?

This was coding to SCSI behavior again. I tried to reduce the case of
waking the eh if the transport moved the target into a blocked state. It
might be redundant as FC has eh blocking and timer_reset. iSCSI has
blocking but not eh blocking.

> To take one example, the cciss driver stops the queue when it can't
> queue more at the hw level and starts it on completion to queue more. If
> recovery triggers when the hw queue has been filled, then timeouts will
> fail?
> 
> It would be better to mark the queue as already doing abort. That state
> could be in the queue, or it could be at the driver level.

ok. I will look into this.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
