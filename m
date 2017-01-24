From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 05/16] dm: always defer request allocation to the owner
 of the request_queue
Date: Tue, 24 Jan 2017 11:39:51 -0500
Message-ID: <20170124163951.GA9172@redhat.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-6-git-send-email-hch@lst.de>
 <20170124100538.GA6991@redhat.com>
 <20170124142054.GA26473@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124142054.GA26473@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24 2017 at  9:20am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Jan 24, 2017 at 05:05:39AM -0500, Mike Snitzer wrote:
> > possible and is welcomed cleanup.  The only concern I have is that using
> > get_request() for the old request_fn request_queue eliminates the
> > guaranteed availability of requests to allow for forward progress (on
> > path failure or for the purposes of swap over mpath, etc).  This isn't a
> > concern for blk-mq because as you know we have a fixed set of tags (and
> > associated preallocated requests).
> > 
> > So I'm left unconvinced old request_fn request-based DM multipath isn't
> > regressing in how request resubmission can be assured a request will be
> > available when needed on retry in the face of path failure.
> 
> Mempool only need a size where we can make guaranteed requests, so for
> get_request based drivers under dm the theoretical minimum size would be
> one as we never rely on a second request to finish the first one,
> and each request_queue has it's own mempool(s) to start with.

Fair enough.  Cc'ing Junichi just in case he sees anything we're
missing.
 
> > dm_mod's 'reserved_rq_based_ios' module_param governs the minimum number
> > of requests in the md->rq_pool (and defaults to 256 requests per
> > request-based DM request_queue).  Whereas blk_init_rl()'s
> > mempool_create_node() uses BLKDEV_MIN_RQ (4) yet q->nr_requests =
> > BLKDEV_MAX_RQ (128).  Also, this patch eliminates the utility of
> > 'reserved_rq_based_ios' module_param without actually removing it.
> 
> It's still used for the bio pool, so I couldn't simply remove it.

Ah, yeah, you're talking about:
pools->bs = bioset_create_nobvec(pool_size, front_pad);

Makes sense.

> > Anyway, should blk-core evolve to allow drivers to specify a custom
> > min_nr of requests in the old request_fn request_queue's mempool?  Or is
> > my concern overblown?
> 
> Thanks to mempool_resize we could add that functionality.  I just don't
> see an actual need for it.
> 
> > p.s. dm.c:dm_alloc_md_mempools() could be cleaned up a bit more since
> > only bio-based DM will have a pools->io_pool moving forward; but I can
> > circle back to that cleanup after.
> 
> If you're fine with doing more than the necessary changes in a patch
> that needs to got into the block tree I'd be happy to apply my usual
> cleanup magic to it.

I think this one example illustrates cleanup that makes sense even if
going through block.  While in there it is best to not leave extra
branching that just doesn't make sense to have anymore.  So if you do
another version of this patchset feel free to move this direct into
dm_alloc_md_mempools()'s BIO_BASED case:
pools->io_pool = mempool_create_slab_pool(pool_size, _io_cache);
And eliminate the cachep pointer.

But if not that is fine too.

Also:

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
