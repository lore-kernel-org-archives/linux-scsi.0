From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Mon, 10 Sep 2012 16:38:43 -0700
Message-ID: <20120910233843.GI7677@google.com>
References: <5044BAD2.7060901@acm.org>
 <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
 <5048E45E.1070302@acm.org>
 <5048E80B.5010101@cs.wisc.edu>
 <5048F0D9.6080403@acm.org>
 <20120906232031.GU29092@google.com>
 <50499AC6.1050008@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44376 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2IJXis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2012 19:38:48 -0400
Received: by dady13 with SMTP id y13so1702275dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 10 Sep 2012 16:38:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50499AC6.1050008@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Fri, Sep 07, 2012 at 08:57:10AM +0200, Bart Van Assche wrote:
> I'm not sure it would be a good idea to add a blk_queue_dead() check in
> any of the __blk_run_queue() variants since blk_drain_queue() can invoke
> __blk_run_queue() to drain the queue.

Right, we can't cancel requests from block layer which were already
seen by the driver.

> Also, as far as I can see the functions that can insert a request into
> the queue (blk_insert_cloned_request(), queue_unplugged(),
> blk_execute_rq_nowait()) all check whether the queue is dead before
> inserting a request. That should be sufficient to prevent that new
> requests are queued after QUEUE_FLAG_DEAD has been set.

Yes, but does that guarantee that none would call into ->request_fn()?
If so, fine; otherwise, we may need to add another state to prevent
that.

Thanks.

-- 
tejun
