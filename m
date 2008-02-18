From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Mon, 18 Feb 2008 15:46:52 +0100
Message-ID: <20080218144652.GE23197@kernel.dk>
References: <20080212204024.GA13643@osc.edu> <1202850758.3137.135.camel@localhost.localdomain> <20080218125508.GA23197@kernel.dk> <20080218233719R.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2986 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYBROq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 09:46:57 -0500
Content-Disposition: inline
In-Reply-To: <20080218233719R.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Mon, Feb 18 2008, FUJITA Tomonori wrote:
> On Mon, 18 Feb 2008 13:55:08 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Feb 12 2008, James Bottomley wrote:
> > > On Tue, 2008-02-12 at 15:40 -0500, Pete Wyckoff wrote:
> > > > If blk_rq_map_user requires more than one bio, and fails mapping
> > > > somewhere after the first bio, it will return with rq->bio set to
> > > > non-NULL, but it will have already unmapped the partial bio.  The
> > > > "out:" error exit section will see the non-null bio and try to unmap
> > > > it again, triggering a mapcount bug via bad_page().
> > > > 
> > > > Signed-off-by: Pete Wyckoff <pw@osc.edu>
> > > > ---
> > > >  block/bsg.c |    4 +++-
> > > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/block/bsg.c b/block/bsg.c
> > > > index 3337125..bba7154 100644
> > > > --- a/block/bsg.c
> > > > +++ b/block/bsg.c
> > > > @@ -295,8 +295,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
> > > >  
> > > >  		dxferp = (void*)(unsigned long)hdr->din_xferp;
> > > >  		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
> > > > -		if (ret)
> > > > +		if (ret) {
> > > > +			next_rq->bio = NULL;  /* do not unmap twice */
> > > 
> > > Nice ... that's a nasty asymmetry of the blk_rq_map_user API.  The map
> > > takes a request gets a ref and fills in the bio.  The unmap has to be
> > > called on the bio leaving you to clear the now removed bio reference
> > > manually.
> > 
> > It is nasty, how about fixing that instead?
> 
> Yeah, looks better for me though the blk_rq_map_user API is still a
> bit hacky, as James said.

Seems symmetric to me now, either we fail and everything is cleaned up,
or return success. What remains?

-- 
Jens Axboe

