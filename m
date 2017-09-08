From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 10/12] scsi: sd_zbc: Disable zone write locking with
 scsi-mq
Date: Fri, 8 Sep 2017 20:43:30 +0800
Message-ID: <20170908124329.GA18932@ming.t460p>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755012AbdIHMnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Sep 2017 08:43:39 -0400
Content-Disposition: inline
In-Reply-To: <20170907161640.30465-11-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Hi Damien,

On Fri, Sep 08, 2017 at 01:16:38AM +0900, Damien Le Moal wrote:
> In the case of a ZBC disk used with scsi-mq, zone write locking does
> not prevent write reordering in sequential zones. Unlike the legacy
> case, zone locking can only be done after the command request is
> removed from the scheduler dispatch queue. That is, at the time of
> zone locking, the write command may already be out of order.

Per my understanding, for legacy case, it can be quite tricky to let
the existed I/O scheduler guarantee the write order for ZBC disk.
I guess requeue still might cause write reorder even in legacy path,
since requeue can happen in both scsi_request_fn() and scsi_io_completion()
with q->queue_lock released, meantime new rq belonging to the same
zone can come and be inserted to queue.

> 
> Disable zone write locking in sd_zbc_write_lock_zone() if the disk is
> used with scsi-mq. Write order guarantees can be provided by an
> adapted I/O scheduler.

Sounds a good idea to enhance the order in a new scheduler, will
look at the following patch.

-- 
Ming
