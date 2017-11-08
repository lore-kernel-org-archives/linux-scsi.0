From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 3/8] block: mq-deadline: Introduce zone locking support
Date: Wed, 08 Nov 2017 18:36:40 -0500
Message-ID: <yq1inekxrzr.fsf@oracle.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
        <20171108081118.7632-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108081118.7632-4-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 8 Nov 2017 17:11:13 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Damien,

> Introduce zone write locking to avoid write request reordering with
> zoned block devices. This is achieved using a finer selection of the
> next request to dispatch:
> 1) Any non-write request is always allowed to proceed.
> 2) Any write to a conventional zone is always allowed to proceed.
> 3) For a write to a sequential zone, the zone lock is first checked.
>    a) If the zone is not locked, the write is allowed to proceed after
>       its target zone is locked.
>    b) If the zone is locked, the write request is skipped and the next
>       request in the dispatch queue tested (back to step 1).
>
> For a write request that has locked its target zone, the zone is
> unlocked either when the request completes with a call to the method
> deadline_request_completed() or when the request is requeued using
> dd_insert_request().
>
> Requests targeting a locked zone are always left in the scheduler queue
> to preserve the lba ordering for write requests. If no write request
> can be dispatched, allow reads to be dispatched even if the write batch
> is not done.
>
> If the device used is not a zoned block device, or if zoned block device
> support is disabled, this patch does not modify mq-deadline behavior.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
