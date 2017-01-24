From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/16] dm: always defer request allocation to the owner
        of the request_queue
Date: Tue, 24 Jan 2017 15:20:54 +0100
Message-ID: <20170124142054.GA26473@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de> <1485185361-29786-6-git-send-email-hch@lst.de> <20170124100538.GA6991@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54991 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750811AbdAXOU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 09:20:56 -0500
Content-Disposition: inline
In-Reply-To: <20170124100538.GA6991@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Tue, Jan 24, 2017 at 05:05:39AM -0500, Mike Snitzer wrote:
> possible and is welcomed cleanup.  The only concern I have is that using
> get_request() for the old request_fn request_queue eliminates the
> guaranteed availability of requests to allow for forward progress (on
> path failure or for the purposes of swap over mpath, etc).  This isn't a
> concern for blk-mq because as you know we have a fixed set of tags (and
> associated preallocated requests).
> 
> So I'm left unconvinced old request_fn request-based DM multipath isn't
> regressing in how request resubmission can be assured a request will be
> available when needed on retry in the face of path failure.

Mempool only need a size where we can make guaranteed requests, so for
get_request based drivers under dm the theoretical minimum size would be
one as we never rely on a second request to finish the first one,
and each request_queue has it's own mempool(s) to start with.

> dm_mod's 'reserved_rq_based_ios' module_param governs the minimum number
> of requests in the md->rq_pool (and defaults to 256 requests per
> request-based DM request_queue).  Whereas blk_init_rl()'s
> mempool_create_node() uses BLKDEV_MIN_RQ (4) yet q->nr_requests =
> BLKDEV_MAX_RQ (128).  Also, this patch eliminates the utility of
> 'reserved_rq_based_ios' module_param without actually removing it.

It's still used for the bio pool, so I couldn't simply remove it.

> Anyway, should blk-core evolve to allow drivers to specify a custom
> min_nr of requests in the old request_fn request_queue's mempool?  Or is
> my concern overblown?

Thanks to mempool_resize we could add that functionality.  I just don't
see an actual need for it.

> p.s. dm.c:dm_alloc_md_mempools() could be cleaned up a bit more since
> only bio-based DM will have a pools->io_pool moving forward; but I can
> circle back to that cleanup after.

If you're fine with doing more than the necessary changes in a patch
that needs to got into the block tree I'd be happy to apply my usual
cleanup magic to it.
