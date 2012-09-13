From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 13 Sep 2012 09:53:40 -0700
Message-ID: <20120913165340.GX7677@google.com>
References: <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
 <5048E45E.1070302@acm.org>
 <5048E80B.5010101@cs.wisc.edu>
 <5048F0D9.6080403@acm.org>
 <20120906232031.GU29092@google.com>
 <50499AC6.1050008@acm.org>
 <20120910233843.GI7677@google.com>
 <504EDD54.9000408@acm.org>
 <20120912205338.GV7677@google.com>
 <50518AC3.2070009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51977 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2IMQxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2012 12:53:45 -0400
Received: by pbbrr13 with SMTP id rr13so4243037pbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Sep 2012 09:53:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50518AC3.2070009@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello, Bart.

On Thu, Sep 13, 2012 at 09:26:59AM +0200, Bart Van Assche wrote:
> On 09/12/12 22:53, Tejun Heo wrote:
> > The problem at hand IIUC is ->request_fn() being invoked when
> > request_queue itself is alive but the underlying driver is gone.  We
> > already make sure that a new request is not queued once drain is
> > complete but there's no guarantee about calling into ->request_fn()
> > and this is what you want to fix, right?
> 
> Actually it's a slightly different issue that I want to address, namely
> that with the current implementation of the block layer and the SCSI
> core it's possible that blk_cleanup_queue() finishes after
> scsi_request_fn() has unlocked the queue lock and before it obtains the
> queue lock again.
> 
> The reason I'm proposing to add a counter in the block layer and not in
> the SCSI core is because I think it would be useful for other
> request-based block drivers too to be able to unlock the queue inside
> their ->request_fn(). That would allow to reduce lock contention on the
> request_queue lock for low-latency block drivers.

Oh yeah, I definitely think this is something which needs to be solved
from the block layer but I'm hoping this could cover the case Chanho
is trying to solve too.  They're different but similar problems - you
don't want blk_cleanup_queue() to finish while someone is executing
inside it and you don't want anyone to enter it after
blk_cleanup_queue() is finished, so I really think we should have
block layer solution which fixes both problems.  That should be
possible, right?

Thanks.

-- 
tejun
