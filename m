From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 5/8] block: deadline-iosched: Introduce zone locking support
Date: Wed, 08 Nov 2017 18:38:30 -0500
Message-ID: <yq1a7zwxrwp.fsf@oracle.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
        <20171108081118.7632-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18079 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752892AbdKHXih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 18:38:37 -0500
In-Reply-To: <20171108081118.7632-6-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 8 Nov 2017 17:11:15 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>


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
> unlocked either when the request completes and the method
> deadline_request_completed() is called, or when the request is requeued
> using the method deadline_add_request().
>
> Requests targeting a locked zone are always left in the scheduler queue
> to preserve the initial write order. If no write request can be
> dispatched, allow reads to be dispatched even if the write batch is not
> done.
>
> If the device used is not a zoned block device, or if zoned block device
> support is disabled, this patch does not modify deadline behavior.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
