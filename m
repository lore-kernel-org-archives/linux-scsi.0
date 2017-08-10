From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Thu, 10 Aug 2017 12:09:45 +0900
Message-ID: <b2f536a0-658d-e039-2ed3-819f7ae12061@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
 <1502204867.2250.1.camel@wdc.com>
 <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
 <cea78872-8e58-549d-87fc-2897e640c31c@wdc.com>
 <1502251037.2784.2.camel@wdc.com>
 <122fbf61-0de5-fa7e-2024-a0763ad70b13@wdc.com>
 <1502252111.2784.4.camel@wdc.com>
 <0e79dcda-29d8-58e3-ed20-b7b6e8db4b10@wdc.com>
 <1502292282.2356.3.camel@wdc.com>
 <466a3303-a4e4-8998-4d52-91ce6e925992@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56010 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbdHJDKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2017 23:10:39 -0400
In-Reply-To: <466a3303-a4e4-8998-4d52-91ce6e925992@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>



On 8/10/17 11:14, Damien Le Moal wrote:
> Bart,
> 
> On 8/10/17 00:24, Bart Van Assche wrote:
>> On Wed, 2017-08-09 at 14:15 +0900, Damien Le Moal wrote:
>>> Overall, yes, that is possible. However, considering only write commands
>>> to a single zone, since at any time only one command is dequeued (the
>>> one holding the zone lock), having the "lock+dequeue" and
>>> "unlock+requeue" both atomic prevent any reordering of write commands
>>> directed to that zone. The first command in the queue for the zone will
>>> either (1) get the zone lock and be dequeued OR (2) stay in the queue.
>>> In case (1), the next write for the zone will hit case (2) until the
>>> dispatch command completes. If the dispatch command is requeued (at the
>>> dispatch queue head), we hit back again the (1) or (2) cases, without
>>> any change in the order. Isnt't it ?
>>
>> Hello Damien,
>>
>> Commands that get requeued are not reinserted at their original position
>> in the request queue but usually at a different position. This is what makes
>> requeueing cause request reordering. Anyway, can you check whether replacing
>> patch "sd_zbc: Write unlock zone from sd_uninit_cmnd()" with the (untested)
>> patch below does not trigger any lockups and prevents request reordering?
>> Since that patch keeps the zone lock across requeuing attempts it should
>> prevent request reordering.
> 
> Your patch will indeed prevent deadlock for the case where the write
> command that acquired the lock gets re-queued before running/completing.
> If after re-queueing the command end ups being *before* any following
> sequential write to the same zone, it will be fine as the flag indicates
> that the zone lock is already acquired. So the command prep will not
> cause deadlocking.
> 
> However, the failure pattern I have seen most of the time is a write
> command never tried before ending up at the head of the dispatch queue,
> trying to acquire the zone lock and failing to do so because the lock
> owning command is behind in the queue.
> 
> Ex: The dispatch queue has sequential write commands A at the head and
> write B following.
> (1) A is dequeued and prep-ed, the zone lock is acquired.
> (2) For whatever reason, A gets requeued, still holding the zone lock.
> (3) Between (1) and (2), another context tries to push command B and
> dequeues it. Zone lock fails and (B) goes for requeue (using a
> workqueue, so different context)
> (4) If the requeue work for A runs before the one for B (instead of both
> A and B ending up in the same work), then B ends up at the head of the
> queue.
> (5) From here, B fails systematically. Requests behind B are not tried
> since the device is marked busy. So B stays at the head and the failure
> persists.

Correction: At step (3), since command B is not issued to the HBA, it
goes for requeue in the same context as scsi_queue_rq() call.
At step (4), since A was issued, requeue is done with the requeue list
workqueue. But A can still end up behind B because initially, B is only
requeued at the head of the dispatch local list, which is itself spliced
into the dispatch queue after that. A requeue may still be done before B
goes back in the dispatch queue.

> 
> The patch I sent is not about solving the ordering problem. Never was.
> It just avoids all possible deadlock situations.
> 
> There are more reordering situations possible higher up in the stack.
> Ex: without a scheduler, blk-mq simply moves all submitted requests from
> the CPU context queues into the hctx dispatch queue, in CPU order. This
> means that a thread cleanly writing sequentially to a zone but moved
> from one CPU to another half-way through the sequence can see its write
> reordered in the dispatch queue. Same for the actual dispatch code
> calling scsi_queue_rq(). This code loops over a local list, not the hctx
> queue. So this code running from 2 different contexts with the second
> one starting half way through our well behaving thread sequence will end
> up splitting the sequence into 2 different local lists and so loosing
> the sequential ordering.
> 
> The no-scheduler case is a little special but needs handling. As for the
> blk-mq dispatch code, we need that serialized/single threaded for zoned
> block devices. I am inclined to say that this should be the case for any
> HDD anyway as performance can only be better. Ming's series already
> brings improvements, but no ordering guarantees for zoned devices.
> 
> I am currently trying different approaches for this. In the mean time, I
> would like to see the unlock change patch be applied to fix the deadlock
> problem.
> 
> Best.
> 
>>
>> Thanks,
>>
>> Bart.
>>
>> ---
>>  drivers/scsi/sd_zbc.c    | 8 ++++++++
>>  include/scsi/scsi_cmnd.h | 3 +++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index 96855df9f49d..6d18b1bd3b26 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -290,10 +290,15 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
>>  	 * threads running on different CPUs write to the same
>>  	 * zone (with a synchronized sequential pattern).
>>  	 */
>> +	if (cmd->flags & SCMD_IN_PROGRESS)
>> +		return BLKPREP_OK;
>> +
>>  	if (sdkp->zones_wlock &&
>>  	    test_and_set_bit(zno, sdkp->zones_wlock))
>>  		return BLKPREP_DEFER;
>>  
>> +	cmd->flags |= SCMD_IN_PROGRESS;
>> +
>>  	return BLKPREP_OK;
>>  }
>>  
>> @@ -302,6 +307,9 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
>>  	struct request *rq = cmd->request;
>>  	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
>>  
>> +	WARN_ON_ONCE(!(cmd->flags & SCMD_IN_PROGRESS));
>> +	cmd->flags &= ~SCMD_IN_PROGRESS;
>> +
>>  	if (sdkp->zones_wlock) {
>>  		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
>>  		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index a1266d318c85..f18c812094b5 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -57,6 +57,9 @@ struct scsi_pointer {
>>  /* for scmd->flags */
>>  #define SCMD_TAGGED		(1 << 0)
>>  #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +#define SCMD_IN_PROGRESS	(1 << 2)
>> +#endif
>>  
>>  struct scsi_cmnd {
>>  	struct scsi_request req;
>>
> 

-- 
Damien Le Moal, Ph.D.
Sr Manager, System Software Group,
Western Digital Research
Damien.LeMoal@wdc.com
Tel: (+81) 0466-98-3593 (Ext. 51-3593)
1 kirihara-cho, Fujisawa, Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
