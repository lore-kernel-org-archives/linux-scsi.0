From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Fri, 07 Sep 2012 08:57:10 +0200
Message-ID: <50499AC6.1050008@acm.org>
References: <5044BAD2.7060901@acm.org> <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu> <5048E45E.1070302@acm.org> <5048E80B.5010101@cs.wisc.edu> <5048F0D9.6080403@acm.org> <20120906232031.GU29092@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:36644 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2IGG5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2012 02:57:13 -0400
In-Reply-To: <20120906232031.GU29092@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 09/07/12 01:20, Tejun Heo wrote:
> I think Mike is wondering whether your patch in isolation is enough or
> we also need to have DEAD check there too.  The proposed patch can't
> handle the case where q->request_fn() is invoked after drain is
> complete.  I'm not really sure whether that can happen tho.

Hello Tejun,

I'm not sure it would be a good idea to add a blk_queue_dead() check in
any of the __blk_run_queue() variants since blk_drain_queue() can invoke
__blk_run_queue() to drain the queue.

Also, as far as I can see the functions that can insert a request into
the queue (blk_insert_cloned_request(), queue_unplugged(),
blk_execute_rq_nowait()) all check whether the queue is dead before
inserting a request. That should be sufficient to prevent that new
requests are queued after QUEUE_FLAG_DEAD has been set.

Bart.

