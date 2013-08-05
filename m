From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Mon, 05 Aug 2013 16:43:09 -0700
Message-ID: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com>
References: <1375740121-23350-1-git-send-email-roland@kernel.org>
	 <1375745462.18481.22.camel@dabdike.int.hansenpartnership.com>
	 <CAG4TOxP6H9isOHYJN=oKgHPna=wWqfOgg2Zh5cpvNFsgNkh8xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxP6H9isOHYJN=oKgHPna=wWqfOgg2Zh5cpvNFsgNkh8xA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-08-05 at 16:38 -0700, Roland Dreier wrote:
> On Mon, Aug 5, 2013 at 4:31 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > I agree with the analysis.  The fix is a bit draconian, though.  A
> > workqueue actually runs in a kernel thread and there's a simple test for
> > that (!current->mm), so how about this instead (which is much less
> > intrusive)
> 
> > ---
> 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 94bbc04..e2ab39c 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1045,12 +1045,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
> >  int bio_uncopy_user(struct bio *bio)
> >  {
> >         struct bio_map_data *bmd = bio->bi_private;
> > -       int ret = 0;
> > +       struct bio_vec *bvec;
> > +       int ret = 0, i;
> >
> > -       if (!bio_flagged(bio, BIO_NULL_MAPPED))
> > -               ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> > -                                    bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> > -                                    0, bmd->is_our_pages);
> > +       if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
> > +               /*
> > +                * if we're in a workqueue, the request is orphaned, so
> > +                * don't copy into the kernel address space, just free
> > +                */
> > +               if (current->mm)
> > +                       ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> > +                                            bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> > +                                            0, bmd->is_our_pages);
> > +               else if (bmd->is_our_pages)
> > +                       bio_for_each_segment_all(bvec, bio, i)
> > +                               __free_page(bvec->bv_page);
> > +       }
> >         bio_free_map_data(bmd);
> >         bio_put(bio);
> >         return ret;
> 
> Yes, looks reasonable -- I can't think of any reason why anyone would
> ever want the bio code to copy to a random userspace address space.
> 
> Acked-by: Roland Dreier <roland@purestorage.com>

You did all the work ... just replace this patch with your previous one
and keep the original tags. (test it first, of course ...)

James
