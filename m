From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi: address leak in the error path of discard page allocation
Date: Mon, 5 Jul 2010 13:00:21 +0900
Message-ID: <20100705130000S.fujita.tomonori@lab.ntt.co.jp>
References: <20100702135300U.fujita.tomonori@lab.ntt.co.jp>
	<20100702105241.GD26318@lst.de>
	<20100702130855.GA6058@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100702130855.GA6058@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: hch@lst.de, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2 Jul 2010 09:08:56 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jul 02 2010 at  6:52am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Fri, Jul 02, 2010 at 01:53:14PM +0900, FUJITA Tomonori wrote:
> > > Seems that scsi-ml calls scsi_unprep_request() for not-prepped
> > > requests in scsi_init_io error path. So we could move that
> > > scsi_unprep_request() to the error path in scsi_prep_return(). Then we
> > > can free discard page in the single place.
> > > 
> > > Applying the rule strictly is fine by me too; we remove
> > > scsi_unprep_request() in scsi_init_io error path and clean up things
> > > in each prep function's error path.
> > 
> > That would be my preference.  Making sure a function cleans up all
> > allocations / state changes on errors means code is a lot fragile and
> > easier to understand.
> > 
> > > Btw, blk_clear_request_payload() is necessary?
> > > 
> > > Making sure that a request is clean is not a bad idea but if we hit
> > > BLKPREP_KILL or BLKPREP_DEFER, we call
> > > blk_end_request(). blk_end_request() can free a request properly even
> > > if we don't do something like blk_clear_request_payload?
> > 
> > For BLKPREP_KILL we do call __blk_end_request_all, but for
> > BLKPREP_DEFER we don't.  In that case we just leave it on the queue for
> > a later retry.  So we either have to clean it up, or leave the detect
> > the case of a partially constructed command in ->prep_fn.  I think
> > cleaning up properly and having defined state when entering ->prep_fn is
> > the better variant.

I think that as long as we free an allocated page for discard,
scsi_setup_discard_cmnd or the block layer don't need to detect the
case of a partially constructed command.


> Right, I shared the same opinion earlier in this thread, so please let
> your ACKs fly now that we seem to all be in agreement.

As I wrote earlier, I think that we need to clean up (and fix) the
error handling of the prep path. Currently, it's just messy. Some
errors are handled in the prep functions while some are in
scsi_prep_return().

- we call scsi_put_command in two places (scsi_init_io and scsi_prep_return).

- scsi_init_io calls scsi_put_command directly for BLKPREP_KILL but
  calls it indirectly via scsi_unprep_request for BLKPREP_DEFER.

- If scsi_init_io() hits BLKPREP_KILL internally, we hit kernel oops
  in scsi_prep_return since we call scsi_put_command twice. (luckily,
  scsi_init_sgtable and scsi_alloc_sgtable in scsi_init_io return only
  DEFER).

you could add more if you like.

I think that handling all the errors in scsi_prep_return() is
cleaner. I'll send a patch.

If we prefer to make sure that a request is completely reset (as
blk_clear_request_payload does), then we can add it on the top of the
patch.
