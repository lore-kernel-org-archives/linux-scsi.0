From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V6 13/14] block: mq-deadline: Limit write request dispatch
 for zoned block devices
Date: Wed, 4 Oct 2017 08:03:34 +0900
Message-ID: <dd8953a0-b28c-3a0f-cc9c-2ce207cf4063@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
 <20171002071535.8007-14-damien.lemoal@wdc.com>
 <1506987846.3368.69.camel@wdc.com>
 <c506126b-a491-30bc-11f1-cd1df29f78c3@wdc.com>
 <1507064168.2567.33.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43716 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdJCXDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 19:03:42 -0400
In-Reply-To: <1507064168.2567.33.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

Bart,

On 10/4/17 05:56, Bart Van Assche wrote:
> On Tue, 2017-10-03 at 09:19 +0900, Damien Le Moal wrote:
>> On 10/3/17 08:44, Bart Van Assche wrote:
>>> On Mon, 2017-10-02 at 16:15 +0900, Damien Le Moal wrote:
>>>>  static void deadline_wunlock_zone(struct deadline_data *dd,
>>>>  				  struct request *rq)
>>>>  {
>>>> +	unsigned long flags;
>>>> +
>>>> +	spin_lock_irqsave(&dd->zone_lock, flags);
>>>> +
>>>>  	WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq), dd->zones_wlock));
>>>>  	deadline_clear_request_zone_wlock(rq);
>>>> +
>>>> +	spin_unlock_irqrestore(&dd->zone_lock, flags);
>>>>  }
>>>
>>> Is a request removed from the sort and fifo lists before being dispatched? If so,
>>> does that mean that obtaining zone_lock in the above function is not necessary?
>>
>> Yes, a request is removed from the sort tree and fifo list before
>> dispatching. But the dd->zone_lock spinlock is not there to protect
>> that, dd->lock protects the sort tree and fifo list. dd->zone_lock was
>> added to prevent the completed_request() method from changing a zone
>> lock state while deadline_fifo_requests() or deadline_next_request() are
>> running. Ex:
>>
>> Imagine this case: write request A for a zone Z is being executed (it
>> was dispatched) so Z is locked. Dispatch runs and inspects the next
>> requests in sort order. Let say we have the sequential writes B, C, D, E
>> queued for the same zone Z. First B is inspected and cannot be
>> dispatched (zone locked). Inspection move on to C, but before the that,
>> A completes and Z is unlocked. Then C will be OK to go as the zone is
>> now unlocked. But it is the wrong choice as it will result in out of
>> order write. B must be the next request dispatched after A.
>>
>> dd->zone_lock prevents this from happening. Without this spinlock, the
>> bad example case above happens very easily.
> 
> Hello Damien,
> 
> Thanks for the detailed and really clear reply. I hope you do not mind that I
> have a few further questions about this patch?
> - Does the zone_lock spinlock have to be acquired by both deadline_wunlock_zone()
>   callers or only by the call from the request completion path?

Not really. Only the completion path is strongly needed as the insert
path unlock is under dd->lock, which prevents concurrent execution of
the sort or fifo request search. So the zone_lock lock/unlock could be
moved out of deadline_wunlock_zone() and done directly in
dd_completed_request().

> - Why do both the mq-deadline and the sd driver each have their own instance of
>   the zones_wlock bitmap? Has it been considered to convert both bitmaps into a
>   single bitmap that is shared by both kernel components and that exists e.g. at
>   the request queue level?

The sd driver level zone locking handles only the legacy path. Hence the
zone lock bitmap attached to the scsi disk struct. For scsi-mq/blk-mq,
mq-deadline does the zone locking. Both bitmaps do not exist at the same
time.

Indeed we could move the zone lock bitmap in the request queue so that
it is common between legacy and mq cases. Christoph has a series doing
that, and going further by doing the zone locking directly within the
block layer dispatch code for both legacy and mq path. So the scsi level
locking and mq-deadline locking become unnecessary. Working on that new
series right now.

Best regards.

-- 
Damien Le Moal,
Western Digital
