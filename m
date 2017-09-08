From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 10/12] scsi: sd_zbc: Disable zone write locking with
 scsi-mq
Date: Fri, 8 Sep 2017 09:53:53 -0700
Message-ID: <8c23a8c8-e945-fd4c-ee6c-da9b097de30b@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-11-damien.lemoal@wdc.com>
 <20170908124329.GA18932@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33753 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756216AbdIHQyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2017 12:54:39 -0400
In-Reply-To: <20170908124329.GA18932@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Ming,

On 9/8/17 05:43, Ming Lei wrote:
> Hi Damien,
> 
> On Fri, Sep 08, 2017 at 01:16:38AM +0900, Damien Le Moal wrote:
>> In the case of a ZBC disk used with scsi-mq, zone write locking does
>> not prevent write reordering in sequential zones. Unlike the legacy
>> case, zone locking can only be done after the command request is
>> removed from the scheduler dispatch queue. That is, at the time of
>> zone locking, the write command may already be out of order.
> 
> Per my understanding, for legacy case, it can be quite tricky to let
> the existed I/O scheduler guarantee the write order for ZBC disk.
> I guess requeue still might cause write reorder even in legacy path,
> since requeue can happen in both scsi_request_fn() and scsi_io_completion()
> with q->queue_lock released, meantime new rq belonging to the same
> zone can come and be inserted to queue.

Yes, the write ordering will always depend on the scheduler doing the
right thing. But both cfq, deadline and even noop do the right thing
there, even considering the aging case. The next write for a zone will
always be the oldest in the queue for that zone, if it is not, it means
that the application did not write sequentially. Extensive testing in
the legacy case never showed a problem due to the scheduler itself.

scsi_requeue_command() does the unprep (zone unlock) and requeue while
holding the queue lock. So this is atomic with new write command
insertion. Requeued commands are added to the dispatch queue head, and
since a zone will only have a single write in-flight, there is no
reordering possible. The next write command for a zone to go again is
the last requeued one or the next in lba order. It works.

Note that for write commands that failed due to an unaligned write
error, there is no retry done, so no requeue. The requeue case for
writes would only happen for other conditions (a dead drive being the
most likely in this case).

>> Disable zone write locking in sd_zbc_write_lock_zone() if the disk is
>> used with scsi-mq. Write order guarantees can be provided by an
>> adapted I/O scheduler.
> 
> Sounds a good idea to enhance the order in a new scheduler, will
> look at the following patch.

For blk-mq, I only tried mq-deadline. The zoned scheduler I posted is
based on it. There is no fundamental change to the ordering on
insertion. Only different choices on dispatch (using the zone lock).

For rotating rust and blk-mq, I think that getting calls to dispatch
serialized would naturally enhance ordering and also merging to some
extent. Ordering really gets killed when multiple context try to push
down requests, which each context ending up each with only a few
requests in their local dispatch lists. Some initial patch I wrote for
zbc that attacked the problem from within blk-mq did that serialization.
That is not mandatory anymore with the zoned scheduler, but I think
would still be benefitial to both ZBC disks and standard disks too.

Best regards.


-- 
Damien Le Moal,
Western Digital Research
