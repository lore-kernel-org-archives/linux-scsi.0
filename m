From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] block: add global timeout to requests
Date: Wed, 25 Mar 2009 16:19:11 +0900
Message-ID: <49C9DAEF.7000200@ct.jp.nec.com>
References: <1237407667.3350.43.camel@localhost.localdomain> <20090324114230.GO27476@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50639 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZCYHTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2009 03:19:21 -0400
In-Reply-To: <20090324114230.GO27476@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Jens, James,

On 2009/03/24 20:42 +0900, Jens Axboe wrote:
> On Wed, Mar 18 2009, James Bottomley wrote:
>> We can eliminate the SCSI command timed out check entirely if the block
>> layer does this for us.  The way to do this in block is to check how
>> long the request has been outstanding if a requeue is requested and
>> ending it if we've gone over retries * timeout.
>>
>> This will also eliminate many cases in SCSI where we evade the command
>> timeout for various reasons (like initial success converted to requeue)
>>
>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>
>> ---
>>
>> Index: linux-2.6/block/blk-core.c
>> ===================================================================
>> --- linux-2.6.orig/block/blk-core.c	2009-02-19 16:42:00.140427205 -0500
>> +++ linux-2.6/block/blk-core.c	2009-03-18 10:36:10.511526815 -0400
>> @@ -937,6 +937,8 @@ EXPORT_SYMBOL(blk_start_queueing);
>>   */
>>  void blk_requeue_request(struct request_queue *q, struct request *rq)
>>  {
>> +	unsigned long wait_for = (rq->retries + 1) * rq->timeout;
>> +
>>  	blk_delete_timer(rq);
>>  	blk_clear_rq_complete(rq);
>>  	trace_block_rq_requeue(q, rq);
>> @@ -944,7 +946,13 @@ void blk_requeue_request(struct request_
>>  	if (blk_rq_tagged(rq))
>>  		blk_queue_end_tag(q, rq);
>>  
>> -	elv_requeue_request(q, rq);
>> +	if (time_before(rq->start_time + wait_for, jiffies)) {
>> +		printk(KERN_ERR "%s: timing out command, waited %lus\n",
>> +		       rq->rq_disk ? rq->rq_disk->disk_name : "?",
>> +		       wait_for/HZ);
>> +		blk_end_request(rq, -EIO, blk_rq_bytes(rq));
>> +	} else
>> +		elv_requeue_request(q, rq);
>>  }
>>  EXPORT_SYMBOL(blk_requeue_request);
> 
> Applied, though I think a
> 
>         time_after(jiffies, time)
> 
> is usually much clearer, since we are checking for an expired event (not
> an early one) :-)

I have the following concerns on this patch.

o What if the driver doesn't use the generic timeout handling?
  This change means that all block drivers must appropriately set
  rq->retries and rq->timeout to use blk_requeue_request(),
  although there was no such rule.
  So some regressions may be caused in drivers which are not using
  rq->retries and rq->timeout for unconditional retry.
  (I also need some works in the request-based dm patch for this.)

  "!q->rq_timed_out_fn" check in addition to the "time_before()" check
  may resolve this issue?

o What if the driver doesn't set rq->retries but has its own logic
  to decide when to give up retries?
  This change means that drivers which don't use rq->retries
  must appropriately modify rq->timeout everytime they call
  blk_requeue_request() once timeout fires.

o Deadlock will occur on the blk_end_request() call, because
  blk_requeue_request() is called with queue_lock held.
  __blk_end_request() needs to be used at least, or other ways are
  needed (e.g. throw the request to softirq.)

Thanks,
Kiyoshi Ueda
