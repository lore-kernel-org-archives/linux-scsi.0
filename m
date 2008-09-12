From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sg: disable interrupts inside sg_copy_buffer
Date: Fri, 12 Sep 2008 23:12:54 +0900
Message-ID: <20080912231254I.fujita.tomonori@lab.ntt.co.jp>
References: <20080912060544.GF20055@kernel.dk>
	<20080912152554R.fujita.tomonori@lab.ntt.co.jp>
	<1221227319.3265.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:39613 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYILOIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 10:08:36 -0400
In-Reply-To: <1221227319.3265.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Fri, 12 Sep 2008 08:48:39 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2008-09-12 at 15:26 +0900, FUJITA Tomonori wrote:
> > On Fri, 12 Sep 2008 08:05:46 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Fri, Sep 12 2008, FUJITA Tomonori wrote:
> > > > On Thu, 11 Sep 2008 18:33:03 +0200
> > > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > On Thu, Sep 11 2008, FUJITA Tomonori wrote:
> > > > > > The callers of sg_copy_buffer must disable interrupts before calling
> > > > > > it (since it uses kmap_atomic). Some callers use it on
> > > > > > interrupt-disabled code but some need to take the trouble to disable
> > > > > > interrupts just for this. No wonder they forget about it and we hit a
> > > > > > bug like:
> > > > > > 
> > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=11529
> > > > > > 
> > > > > > James said that it might be better to disable interrupts inside the
> > > > > > function rather than risk the callers getting it wrong.
> > > > > > 
> > > > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > > ---
> > > > > >  lib/scatterlist.c |    5 +++++
> > > > > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > > > > 
> > > > > > diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> > > > > > index 876ba6d..dd52cd5 100644
> > > > > > --- a/lib/scatterlist.c
> > > > > > +++ b/lib/scatterlist.c
> > > > > > @@ -422,6 +422,9 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
> > > > > >  {
> > > > > >  	unsigned int offset = 0;
> > > > > >  	struct sg_mapping_iter miter;
> > > > > > +	unsigned long flags;
> > > > > > +
> > > > > > +	local_irq_save(flags);
> > > > > >  
> > > > > >  	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
> > > > > >  
> > > > > > @@ -442,6 +445,8 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
> > > > > >  
> > > > > >  	sg_miter_stop(&miter);
> > > > > >  
> > > > > > +	local_irq_restore(flags);
> > > > > > +
> > > > > >  	return offset;
> > > > > >  }
> > > > > 
> > > > > Agreed and applied.
> > > > 
> > > > Jens, this won't go to 2.6.27 (goes to 2.6.28)?
> > > > 
> > > > If so, I need to ask James to apply this workaround to 2.6.27:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=122106973807028&w=2
> > > 
> > > It will go into 2.6.27, it's already upstream since ~10 hours or so.
> > 
> > Thanks, I've just found it.
> 
> You forgot to add the cc: stable@kernel.org tag.  You'll have to send
> this to stable manually quoting the upsream commit id.

You forgot that Tejun rewrote the sg copy code after 2.6.26. This
patch can't be applied to 2.6.26.X.

I need to push a patch that is not in mainline to stable trees. Can I
do that ?


