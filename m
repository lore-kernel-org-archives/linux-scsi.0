From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Mon, 18 Feb 2008 13:55:08 +0100
Message-ID: <20080218125508.GA23197@kernel.dk>
References: <20080212204024.GA13643@osc.edu> <1202850758.3137.135.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25740 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbYBRMzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 07:55:12 -0500
Content-Disposition: inline
In-Reply-To: <1202850758.3137.135.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pete Wyckoff <pw@osc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Tue, Feb 12 2008, James Bottomley wrote:
> On Tue, 2008-02-12 at 15:40 -0500, Pete Wyckoff wrote:
> > If blk_rq_map_user requires more than one bio, and fails mapping
> > somewhere after the first bio, it will return with rq->bio set to
> > non-NULL, but it will have already unmapped the partial bio.  The
> > "out:" error exit section will see the non-null bio and try to unmap
> > it again, triggering a mapcount bug via bad_page().
> > 
> > Signed-off-by: Pete Wyckoff <pw@osc.edu>
> > ---
> >  block/bsg.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 3337125..bba7154 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> > @@ -295,8 +295,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
> >  
> >  		dxferp = (void*)(unsigned long)hdr->din_xferp;
> >  		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
> > -		if (ret)
> > +		if (ret) {
> > +			next_rq->bio = NULL;  /* do not unmap twice */
> 
> Nice ... that's a nasty asymmetry of the blk_rq_map_user API.  The map
> takes a request gets a ref and fills in the bio.  The unmap has to be
> called on the bio leaving you to clear the now removed bio reference
> manually.

It is nasty, how about fixing that instead?

diff --git a/block/blk-map.c b/block/blk-map.c
index 955d75c..bc5ce60 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -143,6 +143,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	return 0;
 unmap_rq:
 	blk_rq_unmap_user(bio);
+	rq->bio = NULL;
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_user);

-- 
Jens Axboe

