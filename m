From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Tue, 11 Sep 2012 08:42:28 +0200
Message-ID: <504EDD54.9000408@acm.org>
References: <5044BAD2.7060901@acm.org> <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu> <5048E45E.1070302@acm.org> <5048E80B.5010101@cs.wisc.edu> <5048F0D9.6080403@acm.org> <20120906232031.GU29092@google.com> <50499AC6.1050008@acm.org> <20120910233843.GI7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:52321 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab2IKGma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2012 02:42:30 -0400
In-Reply-To: <20120910233843.GI7677@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 09/11/12 01:38, Tejun Heo wrote:
> On Fri, Sep 07, 2012 at 08:57:10AM +0200, Bart Van Assche wrote:
>> Also, as far as I can see the functions that can insert a request into
>> the queue (blk_insert_cloned_request(), queue_unplugged(),
>> blk_execute_rq_nowait()) all check whether the queue is dead before
>> inserting a request. That should be sufficient to prevent that new
>> requests are queued after QUEUE_FLAG_DEAD has been set.
> 
> Yes, but does that guarantee that none would call into ->request_fn()?
> If so, fine; otherwise, we may need to add another state to prevent
> that.

Good question. As far as I can see calling request_queue.request_fn() is
fine as long as the caller holds a reference on the queue. If e.g.
scsi_request_fn() would get invoked after blk_drain_queue() finished it
will return immediately because it was invoked with an empty request
queue. So we should be fine as long as all blk_run_queue() callers
either hold a reference on the request queue itself or on the sdev that
owns the request queue. As far as I can see if patch
http://marc.info/?l=linux-scsi&m=134453905402413 gets accepted then all
callers in the SCSI core of blk_run_queue() will hold a (direct or
indirect) reference on the request_queue before invoking blk_run_queue()
or __blk_run_queue().

Bart.
