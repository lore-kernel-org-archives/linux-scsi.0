From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 05/16] dm: always defer request allocation to the owner
 of the request_queue
Date: Tue, 24 Jan 2017 05:05:39 -0500
Message-ID: <20170124100538.GA6991@redhat.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750720AbdAXKFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 05:05:39 -0500
Content-Disposition: inline
In-Reply-To: <1485185361-29786-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Mon, Jan 23 2017 at 10:29am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> DM already calls blk_mq_alloc_request on the request_queue of the
> underlying device if it is a blk-mq device.  But now that we allow drivers
> to allocate additional data and initialize it ahead of time we need to do
> the same for all drivers.   Doing so and using the new cmd_size
> infrastructure in the block layer greatly simplifies the dm-rq and mpath
> code, and should also make arbitrary combinations of SQ and MQ devices
> with SQ or MQ device mapper tables easily possible as a further step.

Thanks for working (and suffering) through all of this request-based DM
code.  Nice to have someone else be painfully aware of the complexity in
request-based DM's old request_fn support.

The queue->cmd_size (per request data) definitely makes this more
possible and is welcomed cleanup.  The only concern I have is that using
get_request() for the old request_fn request_queue eliminates the
guaranteed availability of requests to allow for forward progress (on
path failure or for the purposes of swap over mpath, etc).  This isn't a
concern for blk-mq because as you know we have a fixed set of tags (and
associated preallocated requests).

So I'm left unconvinced old request_fn request-based DM multipath isn't
regressing in how request resubmission can be assured a request will be
available when needed on retry in the face of path failure.

dm_mod's 'reserved_rq_based_ios' module_param governs the minimum number
of requests in the md->rq_pool (and defaults to 256 requests per
request-based DM request_queue).  Whereas blk_init_rl()'s
mempool_create_node() uses BLKDEV_MIN_RQ (4) yet q->nr_requests =
BLKDEV_MAX_RQ (128).  Also, this patch eliminates the utility of
'reserved_rq_based_ios' module_param without actually removing it.

Anyway, should blk-core evolve to allow drivers to specify a custom
min_nr of requests in the old request_fn request_queue's mempool?  Or is
my concern overblown?

Seems we're very close to making this request-based DM cleanup doable.
Just would like some extra eyes and care/thought/guidance from yourself
and likely Jens.

Thanks,
Mike

p.s. dm.c:dm_alloc_md_mempools() could be cleaned up a bit more since
only bio-based DM will have a pools->io_pool moving forward; but I can
circle back to that cleanup after.
