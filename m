From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi: address leak in the error path of discard page allocation
Date: Fri, 2 Jul 2010 13:53:14 +0900
Message-ID: <20100702135300U.fujita.tomonori@lab.ntt.co.jp>
References: <20100701130328.GB19605@redhat.com>
	<20100701201508.GA28546@redhat.com>
	<1278015548.2813.147.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44070 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0GBExn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2010 00:53:43 -0400
In-Reply-To: <1278015548.2813.147.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: snitzer@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk, hch@lst.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010 15:19:08 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2010-07-01 at 16:15 -0400, Mike Snitzer wrote:
> > On Thu, Jul 01 2010 at  9:03am -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > On Thu, Jul 01 2010 at  6:49am -0400,
> > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > This fixes discard page leak by using q->unprep_rq_fn facility.
> > > > 
> > > > q->unprep_rq_fn is called when all the data buffer (req->bio and
> > > > scsi_data_buffer) in the request is freed.
> > > > 
> > > > sd_unprep() uses rq->buffer to free discard page allocated in
> > > > sd_prepare_discard().
> > > > 
> > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > 
> > > Thanks for sorting this out Tomo, all 3 patches work great!
> > > 
> > > BTW, there is one remaining (rare) leak in the allocation path.
> > > 
> > > The following patch serves to fix it but I'm not sure if there is a more
> > > elegant way to address this.
> > 
> > I've continued to look at this to arrive at alternative implementation.
> > Here is a summary of the problem:
> > 
> > A 'scsi_setup_discard_cmnd' return other than BLKPREP_OK will not cause
> > a discard request to get completely stripped down ('blk_finish_request'
> > isn't calling 'blk_unprep_request' because REQ_DONTPREP is not set by
> > 'scsi_prep_return' for none BLKPREP_OK return).  Therefore the discard
> > request's page will _not_ get cleaned up.
> > 
> > Aside from code inspection, I confirmed this by adding some test code to
> > force a one-time initial BLKPREP_DEFER return from
> > 'scsi_setup_discard_cmnd'.
> > 
> > > An alternative would be to check if the page is already allocated
> > > (before allocating the page in scsi_setup_discard_cmnd)?
> > 
> > Unfortunatey this "alternative" won't work because it completely ignores
> > the case where BLKPREP_KILL is returned from scsi_setup_discard_cmnd'.
> >  
> > > Please advise, thanks.
> > 
> > In short, I'm not too happy that the following patch doesn't allow for
> > centralized cleanup of the discard request's page (via sd_unprep_fn).
> > But in order to do that we'd likely have to:
> > 1) relax blk_finish_request's REQ_DONTPREP constraint
> > 2) add other weird conditionals within blk_unprep_request because
> >    the discard request wasn't _really_ prepared?
> > 
> > So given this I'm inclined to stick with the following patch.
> > 
> > Jens and/or James, what do you think?
> 
> The rules are pretty clear:  Unprep is only called if the request gets
> prepped ... that means you have to return BLKPREP_OK.  Defer or kill
> assume there's no teardown to do, so the allocation (if it took place)
> must be reversed before returning them

Seems that scsi-ml calls scsi_unprep_request() for not-prepped
requests in scsi_init_io error path. So we could move that
scsi_unprep_request() to the error path in scsi_prep_return(). Then we
can free discard page in the single place.

Applying the rule strictly is fine by me too; we remove
scsi_unprep_request() in scsi_init_io error path and clean up things
in each prep function's error path.


Btw, blk_clear_request_payload() is necessary?

Making sure that a request is clean is not a bad idea but if we hit
BLKPREP_KILL or BLKPREP_DEFER, we call
blk_end_request(). blk_end_request() can free a request properly even
if we don't do something like blk_clear_request_payload?
