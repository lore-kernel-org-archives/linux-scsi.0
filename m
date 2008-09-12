From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] sg: disable interrupts inside sg_copy_buffer
Date: Fri, 12 Sep 2008 08:05:46 +0200
Message-ID: <20080912060544.GF20055@kernel.dk>
References: <20080911235215U.fujita.tomonori@lab.ntt.co.jp> <20080911163302.GV20055@kernel.dk> <20080912110422A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:56839 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYILGFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 02:05:49 -0400
Content-Disposition: inline
In-Reply-To: <20080912110422A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Fri, Sep 12 2008, FUJITA Tomonori wrote:
> On Thu, 11 Sep 2008 18:33:03 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Sep 11 2008, FUJITA Tomonori wrote:
> > > The callers of sg_copy_buffer must disable interrupts before calling
> > > it (since it uses kmap_atomic). Some callers use it on
> > > interrupt-disabled code but some need to take the trouble to disable
> > > interrupts just for this. No wonder they forget about it and we hit a
> > > bug like:
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=11529
> > > 
> > > James said that it might be better to disable interrupts inside the
> > > function rather than risk the callers getting it wrong.
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  lib/scatterlist.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> > > index 876ba6d..dd52cd5 100644
> > > --- a/lib/scatterlist.c
> > > +++ b/lib/scatterlist.c
> > > @@ -422,6 +422,9 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
> > >  {
> > >  	unsigned int offset = 0;
> > >  	struct sg_mapping_iter miter;
> > > +	unsigned long flags;
> > > +
> > > +	local_irq_save(flags);
> > >  
> > >  	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
> > >  
> > > @@ -442,6 +445,8 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
> > >  
> > >  	sg_miter_stop(&miter);
> > >  
> > > +	local_irq_restore(flags);
> > > +
> > >  	return offset;
> > >  }
> > 
> > Agreed and applied.
> 
> Jens, this won't go to 2.6.27 (goes to 2.6.28)?
> 
> If so, I need to ask James to apply this workaround to 2.6.27:
> 
> http://marc.info/?l=linux-scsi&m=122106973807028&w=2

It will go into 2.6.27, it's already upstream since ~10 hours or so.

-- 
Jens Axboe

