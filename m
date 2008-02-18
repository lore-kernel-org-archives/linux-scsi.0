From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Mon, 18 Feb 2008 23:37:16 +0900
Message-ID: <20080218233719R.tomof@acm.org>
References: <20080212204024.GA13643@osc.edu>
	<1202850758.3137.135.camel@localhost.localdomain>
	<20080218125508.GA23197@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52795 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYBROhn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 09:37:43 -0500
In-Reply-To: <20080218125508.GA23197@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: James.Bottomley@HansenPartnership.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Mon, 18 Feb 2008 13:55:08 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Feb 12 2008, James Bottomley wrote:
> > On Tue, 2008-02-12 at 15:40 -0500, Pete Wyckoff wrote:
> > > If blk_rq_map_user requires more than one bio, and fails mapping
> > > somewhere after the first bio, it will return with rq->bio set to
> > > non-NULL, but it will have already unmapped the partial bio.  The
> > > "out:" error exit section will see the non-null bio and try to unmap
> > > it again, triggering a mapcount bug via bad_page().
> > > 
> > > Signed-off-by: Pete Wyckoff <pw@osc.edu>
> > > ---
> > >  block/bsg.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/block/bsg.c b/block/bsg.c
> > > index 3337125..bba7154 100644
> > > --- a/block/bsg.c
> > > +++ b/block/bsg.c
> > > @@ -295,8 +295,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
> > >  
> > >  		dxferp = (void*)(unsigned long)hdr->din_xferp;
> > >  		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
> > > -		if (ret)
> > > +		if (ret) {
> > > +			next_rq->bio = NULL;  /* do not unmap twice */
> > 
> > Nice ... that's a nasty asymmetry of the blk_rq_map_user API.  The map
> > takes a request gets a ref and fills in the bio.  The unmap has to be
> > called on the bio leaving you to clear the now removed bio reference
> > manually.
> 
> It is nasty, how about fixing that instead?

Yeah, looks better for me though the blk_rq_map_user API is still a
bit hacky, as James said.

James, Pete's patch is still in scsi-fixes, so how about dropping it
and sending this patch via the block?


> diff --git a/block/blk-map.c b/block/blk-map.c
> index 955d75c..bc5ce60 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -143,6 +143,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>  	return 0;
>  unmap_rq:
>  	blk_rq_unmap_user(bio);
> +	rq->bio = NULL;
>  	return ret;
>  }
>  EXPORT_SYMBOL(blk_rq_map_user);
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
