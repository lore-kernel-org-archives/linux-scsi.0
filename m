From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: address leak in the error path of discard page allocation
Date: Fri, 2 Jul 2010 09:08:56 -0400
Message-ID: <20100702130855.GA6058@redhat.com>
References: <20100701130328.GB19605@redhat.com>
 <20100701201508.GA28546@redhat.com>
 <1278015548.2813.147.camel@mulgrave.site>
 <20100702135300U.fujita.tomonori@lab.ntt.co.jp>
 <20100702105241.GD26318@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab0GBNJL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2010 09:09:11 -0400
Content-Disposition: inline
In-Reply-To: <20100702105241.GD26318@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org

On Fri, Jul 02 2010 at  6:52am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Jul 02, 2010 at 01:53:14PM +0900, FUJITA Tomonori wrote:
> > Seems that scsi-ml calls scsi_unprep_request() for not-prepped
> > requests in scsi_init_io error path. So we could move that
> > scsi_unprep_request() to the error path in scsi_prep_return(). Then we
> > can free discard page in the single place.
> > 
> > Applying the rule strictly is fine by me too; we remove
> > scsi_unprep_request() in scsi_init_io error path and clean up things
> > in each prep function's error path.
> 
> That would be my preference.  Making sure a function cleans up all
> allocations / state changes on errors means code is a lot fragile and
> easier to understand.
> 
> > Btw, blk_clear_request_payload() is necessary?
> > 
> > Making sure that a request is clean is not a bad idea but if we hit
> > BLKPREP_KILL or BLKPREP_DEFER, we call
> > blk_end_request(). blk_end_request() can free a request properly even
> > if we don't do something like blk_clear_request_payload?
> 
> For BLKPREP_KILL we do call __blk_end_request_all, but for
> BLKPREP_DEFER we don't.  In that case we just leave it on the queue for
> a later retry.  So we either have to clean it up, or leave the detect
> the case of a partially constructed command in ->prep_fn.  I think
> cleaning up properly and having defined state when entering ->prep_fn is
> the better variant.

Right, I shared the same opinion earlier in this thread, so please let
your ACKs fly now that we seem to all be in agreement.

I'd like Jens to pick this patch up now-ish ;)

Mike
