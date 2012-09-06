From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 6 Sep 2012 16:20:31 -0700
Message-ID: <20120906232031.GU29092@google.com>
References: <5044BAD2.7060901@acm.org>
 <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
 <5048E45E.1070302@acm.org>
 <5048E80B.5010101@cs.wisc.edu>
 <5048F0D9.6080403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2IFXUg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 19:20:36 -0400
Received: by pbbrr13 with SMTP id rr13so3190458pbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 Sep 2012 16:20:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5048F0D9.6080403@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello, Bart, Mike.

On Thu, Sep 06, 2012 at 08:52:09PM +0200, Bart Van Assche wrote:
> >> The purpose of this patch is indeed to make *blk_run_queue() calls from
> >> the block layer safe. There are several direct or indirect
> >> *blk_run_queue() calls in the block layer where a reference on the queue
> >> is held but not on the sdev, e.g. in the md, dm and bsg drivers.

Yeah, while writing blk_drain_queue(), I was thinking only about
requests.  I didn't consider control reaching into driver.

> > Is there a race still? If some blk code is calling blk_run_queue
> > (waiting on the queue lock) but no IO is queued,
> > blk_drain_queue/blk_cleanup_queue could complete since the drain
> > counters are zero. Then blk_run_queue could grab the queue lock and call
> > the request_fn on a freed scsi_device (sdev pointed to by q->queuedata
> > would be freed so scsi_reuqest_fn would be freed).
> > 
> > Do we need a check in __blk_run_queue for QUEUE_FLAG_DEAD (if dead then
> > fail IO?), or do we need a check in scsi_request_fn for this. A dead
> > queue check or maybe null q->queuedata in
> > scsi_device_dev_release_usercontext (do this with the queue lock held),
> > then check for null q->queuedata in scsi_request_fn?
> 
> Yet another scenario is that scsi_remove_host() gets invoked and
> finishes after scsi_request_fn() has unlocked the queue and before it
> locks the queue again. That's a scenario that can't be handled by adding
> more checks at the start of __blk_run_queue() or scsi_request_fn().

I think Mike is wondering whether your patch in isolation is enough or
we also need to have DEAD check there too.  The proposed patch can't
handle the case where q->request_fn() is invoked after drain is
complete.  I'm not really sure whether that can happen tho.

Other than that, yeah, I think it's a real problem and we definitely
want to remove get/put_device() from scsi_request_fn().  Refcnting
oneself is often wrong (as shown here too) and generally just sad.

Thanks.

-- 
tejun
