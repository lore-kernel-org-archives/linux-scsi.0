From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 06 Sep 2012 19:58:54 +0200
Message-ID: <5048E45E.1070302@acm.org>
References: <5044BAD2.7060901@acm.org> <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:54932 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2IFR65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 13:58:57 -0400
In-Reply-To: <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

_suOn 09/06/12 18:27, Michael Christie wrote:
> On Sep 3, 2012, at 9:12 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>> If the put_device() call in scsi_request_fn() drops the sdev refcount
>> to zero then the spin_lock() call after the put_device() call triggers
>> a use-after-free. Avoid that by making sure that blk_cleanup_queue()
>> can only finish after all active scsi_request_fn() calls have returned.
> 
> If we have this patch http://marc.info/?l=linux-scsi&m=134453905402413&w=2
> it seems we have all the scsi layer callers of the request_fn/
> *blk_run_queue holding a reference to the device when they make the call.
> Right, or are there some other places missing?
> 
> What are the other places we can call the request_fn without already
> holding a reference to the device? Is it the block layer? Is that why we
> need this patch?

Hello Mike,

The purpose of this patch is indeed to make *blk_run_queue() calls from
the block layer safe. There are several direct or indirect
*blk_run_queue() calls in the block layer where a reference on the queue
is held but not on the sdev, e.g. in the md, dm and bsg drivers.

Bart.



