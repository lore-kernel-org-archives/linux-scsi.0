From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V4 10/16] block: mq-deadline: Add zoned block device data
Date: Sun, 24 Sep 2017 18:48:54 +0200
Message-ID: <23ed2822-74e5-b562-7666-767e730947c1@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
 <20170924070247.25560-11-damien.lemoal@wdc.com>
 <20170924151452.GG14806@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924151452.GG14806@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 9/24/17 17:14, Christoph Hellwig wrote:
>> +
>> +	struct request_queue *q;
> 
> Do you really need the queue backpointer?  At least as far as this
> patch is concerned we could just pass the queue on to
> deadline_enable_zones_wlock and be fine.  And in general we should
> always passing the q, as we can trivial go from queue to deadline_data
> using queue->elevator->elevator_data.

This is for the sysfs zones_wlock store function which does not give the
queue. Instead of this backpointer, I can copy the queue node, number of
zones and zone model so that cdeadline_enable_zones_wlock() can be
called equally from init_queue context and from the sysfs zones_wlock
store context.

>> +static int deadline_zoned_init_queue(struct request_queue *q,
>> +				     struct deadline_data *dd)
>> +{
>> +	if (!blk_queue_is_zoned(q) ||
>> +	    !blk_queue_nr_zones(q)) {
> 
> Shouldn't !blk_queue_nr_zones(q) be enough?  If not both conditionals
> could easily fit into the same line, and I'd be tempted to move them
> to the caller and call deadline_enable_zones_wlock straight from there.

OK. Will update.

>> @@ -341,6 +387,15 @@ static int dd_init_queue(struct request_queue *q, struct elevator_type *e)
>>  	spin_lock_init(&dd->lock);
>>  	INIT_LIST_HEAD(&dd->dispatch);
>>  
>> +	dd->q = q;
>> +	spin_lock_init(&dd->zone_lock);
>> +	ret = deadline_zoned_init_queue(q, dd);
>> +	if (ret) {
>> +		kfree(dd);
>> +		kobject_put(&eq->kobj);
>> +		return ret;
>> +	}
>> +
>>  	q->elevator = eq;
>>  	return 0;
> 
> This should probably grow goto based unwinding, e.g.

OK. Will update.

Thanks !

-- 
Damien Le Moal
Western Digital Research
