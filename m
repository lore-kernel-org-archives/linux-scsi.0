From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 06 Sep 2012 13:14:35 -0500
Message-ID: <5048E80B.5010101@cs.wisc.edu>
References: <5044BAD2.7060901@acm.org> <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu> <5048E45E.1070302@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37943 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933Ab2IFSPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2012 14:15:05 -0400
In-Reply-To: <5048E45E.1070302@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 09/06/2012 12:58 PM, Bart Van Assche wrote:
> _suOn 09/06/12 18:27, Michael Christie wrote:
>> On Sep 3, 2012, at 9:12 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>>> If the put_device() call in scsi_request_fn() drops the sdev refcount
>>> to zero then the spin_lock() call after the put_device() call triggers
>>> a use-after-free. Avoid that by making sure that blk_cleanup_queue()
>>> can only finish after all active scsi_request_fn() calls have returned.
>>
>> If we have this patch http://marc.info/?l=linux-scsi&m=134453905402413&w=2
>> it seems we have all the scsi layer callers of the request_fn/
>> *blk_run_queue holding a reference to the device when they make the call.
>> Right, or are there some other places missing?
>>
>> What are the other places we can call the request_fn without already
>> holding a reference to the device? Is it the block layer? Is that why we
>> need this patch?
> 
> Hello Mike,
> 
> The purpose of this patch is indeed to make *blk_run_queue() calls from
> the block layer safe. There are several direct or indirect
> *blk_run_queue() calls in the block layer where a reference on the queue
> is held but not on the sdev, e.g. in the md, dm and bsg drivers.
> 

Is there a race still? If some blk code is calling blk_run_queue
(waiting on the queue lock) but no IO is queued,
blk_drain_queue/blk_cleanup_queue could complete since the drain
counters are zero. Then blk_run_queue could grab the queue lock and call
the request_fn on a freed scsi_device (sdev pointed to by q->queuedata
would be freed so scsi_reuqest_fn would be freed).

Do we need a check in __blk_run_queue for QUEUE_FLAG_DEAD (if dead then
fail IO?), or do we need a check in scsi_request_fn for this. A dead
queue check or maybe null q->queuedata in
scsi_device_dev_release_usercontext (do this with the queue lock held),
then check for null q->queuedata in scsi_request_fn?
