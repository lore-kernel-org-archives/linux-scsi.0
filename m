From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 10/12] scsi: sd_zbc: Disable zone write locking with
 scsi-mq
Date: Sun, 10 Sep 2017 13:10:12 +0800
Message-ID: <20170910051010.GB11628@ming.t460p>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-11-damien.lemoal@wdc.com>
 <20170908124329.GA18932@ming.t460p>
 <8c23a8c8-e945-fd4c-ee6c-da9b097de30b@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdIJFKX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Sep 2017 01:10:23 -0400
Content-Disposition: inline
In-Reply-To: <8c23a8c8-e945-fd4c-ee6c-da9b097de30b@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

On Fri, Sep 08, 2017 at 09:53:53AM -0700, Damien Le Moal wrote:
> Ming,
> 
> On 9/8/17 05:43, Ming Lei wrote:
> > Hi Damien,
> > 
> > On Fri, Sep 08, 2017 at 01:16:38AM +0900, Damien Le Moal wrote:
> >> In the case of a ZBC disk used with scsi-mq, zone write locking does
> >> not prevent write reordering in sequential zones. Unlike the legacy
> >> case, zone locking can only be done after the command request is
> >> removed from the scheduler dispatch queue. That is, at the time of
> >> zone locking, the write command may already be out of order.
> > 
> > Per my understanding, for legacy case, it can be quite tricky to let
> > the existed I/O scheduler guarantee the write order for ZBC disk.
> > I guess requeue still might cause write reorder even in legacy path,
> > since requeue can happen in both scsi_request_fn() and scsi_io_completion()
> > with q->queue_lock released, meantime new rq belonging to the same
> > zone can come and be inserted to queue.
> 
> Yes, the write ordering will always depend on the scheduler doing the
> right thing. But both cfq, deadline and even noop do the right thing
> there, even considering the aging case. The next write for a zone will
> always be the oldest in the queue for that zone, if it is not, it means
> that the application did not write sequentially. Extensive testing in
> the legacy case never showed a problem due to the scheduler itself.

OK, I suggest to document this guarantee of no write reorder for ZBC
somewhere, so that people will keep it in mind when trying to change
the current code.

> 
> scsi_requeue_command() does the unprep (zone unlock) and requeue while
> holding the queue lock. So this is atomic with new write command
> insertion. Requeued commands are added to the dispatch queue head, and
> since a zone will only have a single write in-flight, there is no
> reordering possible. The next write command for a zone to go again is
> the last requeued one or the next in lba order. It works.

One special case is write with FLUSH/FUA, which may be added to
front of q->queue_head directly. Suppose one write with FUA is
just comes between requeue and run queue, write reorder may be
triggered.

If this assumption is true, there might be such issue on blk-mq
too.

-- 
Ming
