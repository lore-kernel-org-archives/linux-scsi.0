From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V6 13/14] block: mq-deadline: Limit write request dispatch
 for zoned block devices
Date: Tue, 3 Oct 2017 09:19:25 +0900
Message-ID: <c506126b-a491-30bc-11f1-cd1df29f78c3@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
 <20171002071535.8007-14-damien.lemoal@wdc.com>
 <1506987846.3368.69.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1506987846.3368.69.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Bart,

On 10/3/17 08:44, Bart Van Assche wrote:
> On Mon, 2017-10-02 at 16:15 +0900, Damien Le Moal wrote:
>> When dispatching write requests to a zoned block device, only allow
>> requests targeting an unlocked zone. Requests targeting a locked zone
>> are left in the scheduler queue to preserve the initial write order.
>> If no write request can be dispatched, allow reads to be dispatched
>> even if the write batch is not done.
>>
>> To ensure that the search for an appropriate write request is atomic
>> in deadline_fifo_request() and deadline_next_request() with reagrd to
>                                                               ^^^^^^
>                                                               regard?

Will fix.

>> write requests zone lock state, introduce the spinlock zone_lock.
>> Holding this lock while doing the search in these functions as well as
>> when unlocking the target zone of a completed write request in
>> dd_completed_request() ensure that the search does not pickup a write
>> request in the middle of a zone queued write sequence.
> 
> Since there is already a spinlock in the mq-deadline scheduler that serializes
> most operations, do we really need a new spinlock?

The dd->lock spinlock is used without IRQ disabling. So it does not
protect against request completion method calls. That spinlock being a
"big lock", I did not want to use it with IRQ disabled.

>>  /*
>>   * Write unlock the target zone of a write request.
>> + * Clearing the target zone write lock bit is done with the scheduler zone_lock
>> + * spinlock held so that deadline_next_request() and deadline_fifo_request()
>> + * cannot see the lock state of a zone change due to a request completion during
>> + * their eventual search for an appropriate write request. Otherwise, for a zone
>> + * with multiple write requests queued, a non sequential write request
>> + * can be chosen.
>>   */
>>  static void deadline_wunlock_zone(struct deadline_data *dd,
>>  				  struct request *rq)
>>  {
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&dd->zone_lock, flags);
>> +
>>  	WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq), dd->zones_wlock));
>>  	deadline_clear_request_zone_wlock(rq);
>> +
>> +	spin_unlock_irqrestore(&dd->zone_lock, flags);
>>  }
> 
> Is a request removed from the sort and fifo lists before being dispatched? If so,
> does that mean that obtaining zone_lock in the above function is not necessary?

Yes, a request is removed from the sort tree and fifo list before
dispatching. But the dd->zone_lock spinlock is not there to protect
that, dd->lock protects the sort tree and fifo list. dd->zone_lock was
added to prevent the completed_request() method from changing a zone
lock state while deadline_fifo_requests() or deadline_next_request() are
running. Ex:

Imagine this case: write request A for a zone Z is being executed (it
was dispatched) so Z is locked. Dispatch runs and inspects the next
requests in sort order. Let say we have the sequential writes B, C, D, E
queued for the same zone Z. First B is inspected and cannot be
dispatched (zone locked). Inspection move on to C, but before the that,
A completes and Z is unlocked. Then C will be OK to go as the zone is
now unlocked. But it is the wrong choice as it will result in out of
order write. B must be the next request dispatched after A.

dd->zone_lock prevents this from happening. Without this spinlock, the
bad example case above happens very easily.

>>  static struct request *
>>  deadline_fifo_request(struct deadline_data *dd, int data_dir)
>>  {
>> +	struct request *rq;
>> +	unsigned long flags;
>> +
>>  	if (WARN_ON_ONCE(data_dir != READ && data_dir != WRITE))
>>  		return NULL;
>>  
>>  	if (list_empty(&dd->fifo_list[data_dir]))
>>  		return NULL;
>>  
>> -	return rq_entry_fifo(dd->fifo_list[data_dir].next);
>> +	if (!dd->zones_wlock || data_dir == READ)
>> +		return rq_entry_fifo(dd->fifo_list[data_dir].next);
>> +
>> +	spin_lock_irqsave(&dd->zone_lock, flags);
>> +
>> +	list_for_each_entry(rq, &dd->fifo_list[WRITE], queuelist) {
>> +		if (deadline_can_dispatch_request(dd, rq))
>> +			goto out;
>> +	}
>> +	rq = NULL;
>> +
>> +out:
>> +	spin_unlock_irqrestore(&dd->zone_lock, flags);
>> +
>> +	return rq;
>>  }
> 
> Same question here: is it really necessary to obtain zone_lock?

See above. Same comment.

Best regards.

-- 
Damien Le Moal,
Western Digital
