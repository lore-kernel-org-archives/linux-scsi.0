From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/4] block: Fix race on request_queue.end_io invocations
Date: Wed, 06 Jun 2012 13:10:24 +0000
Message-ID: <4FCF56C0.50104@acm.org>
References: <4FCE3D20.4000205@acm.org> <4FCE3D77.8040909@acm.org> <4FCF50F7.2080008@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:39362 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2FFNKa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 09:10:30 -0400
In-Reply-To: <4FCF50F7.2080008@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

On 06/06/12 12:45, Jens Axboe wrote:

> On 06/05/2012 07:10 PM, Bart Van Assche wrote:
>> Some request_queue.end_io implementations can be called safely
>> without the queue lock held while several other implementations
>> assume that the queue lock is held. So let's play it safe and
>> make sure that the queue lock is held around end_io invocations.
>> Found this through source code review.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: <stable@kernel.org>
>> ---
>>  block/blk-exec.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/blk-exec.c b/block/blk-exec.c
>> index fb2cbd5..6724fab 100644
>> --- a/block/blk-exec.c
>> +++ b/block/blk-exec.c
>> @@ -54,10 +54,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
>>  	spin_lock_irq(q->queue_lock);
>>  
>>  	if (unlikely(blk_queue_dead(q))) {
>> -		spin_unlock_irq(q->queue_lock);
>>  		rq->errors = -ENXIO;
>>  		if (rq->end_io)
>>  			rq->end_io(rq, rq->errors);
>> +		spin_unlock_irq(q->queue_lock);
>>  		return;
>>  	}
> 
> I'm assuming you checked any in-kernel users of rq->end_io to ensure
> that it is fine? If so, patch looks fine to me. And I agree, it's not
> stable material.


The in-tree request.end_io implementations can be found as follows:
$ git grep -nHE 'end_io\(struct request .*[^;]$'
block/blk-flush.c:194:static void flush_end_io(struct request *flush_rq, int error)
block/blk-flush.c:275:static void flush_data_end_io(struct request *rq, int error)
block/bsg.c:336:static void bsg_rq_end_io(struct request *rq, int uptodate)
drivers/scsi/sg.c:1279:static void sg_rq_end_io(struct request *rq, int uptodate)

To me it looks like flush_end_io() and flush_data_end_io() need to be
called with the queue lock held since these access the queue state. For
bsg_rq_end_io() and sg_rq_end_io() this patch will trigger nested
locking. As far as I can see that should be fine though.

Bart.
