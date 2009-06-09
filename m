From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
	potential bio leak"
Date: Tue, 9 Jun 2009 15:18:27 +0200
Message-ID: <20090609131827.GL11363@kernel.dk>
References: <20090609194338S.fujita.tomonori@lab.ntt.co.jp> <4A2E4D4F.90901@panasas.com> <20090609221019A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:58469 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758421AbZFINS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jun 2009 09:18:26 -0400
Content-Disposition: inline
In-Reply-To: <20090609221019A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Tue, Jun 09 2009, FUJITA Tomonori wrote:
> On Tue, 09 Jun 2009 14:53:51 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > On 06/09/2009 01:44 PM, FUJITA Tomonori wrote:
> > > This reverts commit 1cd96c242a829d52f7a5ae98f554ca9775429685.
> > > 
> > > commit 1cd96c242a829d52f7a5ae98f554ca9775429685
> > > Author: Boaz Harrosh <bharrosh@panasas.com>
> > > Date:   Tue Mar 24 12:35:07 2009 +0100
> > > 
> > >     block: WARN in __blk_put_request() for potential bio leak
> > > 
> > >     Put a WARN_ON in __blk_put_request if it is about to
> > >     leak bio(s). This is a serious bug that can happen in error
> > >     handling code paths.
> > > 
> > >     For this to work I have fixed a couple of places in block/ where
> > >     request->bio != NULL ownership was not honored. And a small cleanup
> > >     at sg_io() while at it.
> > > 
> > > 
> > > With 2.6.30-rc, BSG SMP requests get the following warnings:
> > > 
> > > WARNING: at block/blk-core.c:1068 __blk_put_request+0x52/0xc0()
> > > 
> > > However, this is false. There is no bio leak wrt BSG SMP
> > > requests. Probably the better fix is calling blk_end_request_all() in
> > > the BSG SMP path.
> > > 
> > > blk_end_request_all() is not very useful for the BSG SMP path (we call
> > > it to just unlink rq->bio) however calling blk_end_request_all() in
> > > all bio users is consistent.
> > > 
> > > blk_end_request_all() is not available in 2.6.30-rc so seems that the
> > > simplest fix is removing WARN_ON for now.
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 
> > Please do not revert. This is the point of all this.
> > 
> > If there is no leak, You should NULL out the req->bio
> > for now, and for 2.6.31 change the code to do 
> > blk_end_request_all(). That's what blk_end_request does,
> > since you are doing your own completion then set req->bio
> > to null after you're done. (And before put_request)
> > 
> > This stuff is good for error paths to catch leaks, please
> > leave it?
> 
> Has this your good stuff found any bio leak bugs in mainline? In
> addition, breaking working code is not a proper development style.

That was my original question either, code like this has an ugly
tendency to cause unnecessary problems while never catching any bad
usage.

> Anyway, setting req->bio in bsg works. Either is fine by me.
> 
> 
> Jens, can you please send either patch to Linus now?

Sure, I'll push it out now. There's nothing pending for 2.6.30 ATM.

-- 
Jens Axboe

