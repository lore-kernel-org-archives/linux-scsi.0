From: scameron@beardog.cce.hp.com
Subject: Re: PATCH [1/1] cciss: auto engage scsi subsystem for tape support
Date: Fri, 30 Sep 2011 08:52:32 -0500
Message-ID: <20110930135232.GB20956@beardog.cce.hp.com>
References: <20110916213200.GA24786@beardog.cce.hp.com> <20110929165417.59fc03c7.akpm00@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110929165417.59fc03c7.akpm00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm00@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzel@redhat.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 29, 2011 at 04:54:17PM -0700, Andrew Morton wrote:
> On Fri, 16 Sep 2011 16:32:00 -0500
> Mike Miller <mike.miller@hp.com> wrote:
> 
> > 
> > commit 608b0262ce818901b931d7e6534aad375c698924
> > Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > Date:   Mon Aug 29 13:27:46 2011 -0500
> > 
> >     cciss: auto engage scsi mid-layer
> > 
> > Acked-by: Mike Miller <mike.miller@hp.com>
> 
> Nobody seems to have applied this to anything.
> 
> The patch has no signoffs.
> 
> The changelog is awful.  What are the end-user-visible effects of this
> change?  How is anyone supposed to tell?

Eh, Mike sent that one up for me and I guess I hadn't updated
the change log (actually, looking around, it seems like I never
made a patch for kernel.org, so I guess he pulled the patch out of
our local HP repository here.)

I can resend it with a changelog that makes more sense.

The history of this thing goes like this:

Back in 2000 or so, when we were first adding tape drive support
to cciss, one of the distros, or maybe more than one, would load
the block drivers before the scsi mid layer was loaded.  Consequently,
if the block driver tried to call scsi_add_host (or anything from the
scsi mid layer) it would panic.  So we delayed this until after
the scsi mid layer was up, and by poking at the driver from userland,
after the scsi mid layer was up and running we would get it to engage
the scsi mid layer .  That's what this whole

echo engage scsi > /proc/driver/cciss/cciss0

nonsense was about.

At some point along the way (probably a long time ago now) this
ceased to be a problem, and the cciss driver could safely rely
on the scsi mid layer being present straight away, thus removing
the need for this "echo engage scsi > /proc/driver/cciss/cciss0"
nonsense.  So we want to take it out.

The user visible effect is that tape drives and medium changers
show up at driver load time without user intervention or the need
for any scripts in /etc/rc.d to poke at the driver.

> 
> > --- a/drivers/block/cciss_scsi.c
> > +++ b/drivers/block/cciss_scsi.c
> > @@ -1720,5 +1720,6 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
> >  /* If no tape support, then these become defined out of existence */
> >  
> >  #define cciss_scsi_setup(cntl_num)
> > +#define cciss_engage_scsi(h)
> >  
> >  #endif /* CONFIG_CISS_SCSI_TAPE */
> 
> cciss #includes .c files?  I can't believe you did that :(

That's been that way for 10 years or so, from the very
beginning.  The rationale, for what it's worth, was that
cciss was originally a block driver, but then a scsi
driver was grafted into it for tape drive support.  It
wasn't at all clear to me at the time that grafting a
scsi driver onto the side of a block driver would be acceptable,
so I wanted to keep them more or less separate, so I could
throw it all away easily if need be.  You might also notice
that cciss_scsi.c and cciss_scsi.h are ancestors of
drivers/scsi/hpsa.c and drivers/scsi/hpsa.h (though enough
changes have occurred by now that they are quite different now,
though still recognizably related, and quite often patches still
are almost compatible with both.)  I probably have an ancient
(2007) patch set lying around somewhere that shows the beginning part
of that evolution, transforming cciss_scsi.[ch] into a working
scsi Smart Array driver.  So keeping those parts separated was
ultimately not without its benefits, despite being a bit
unconventionally ugly.

If it makes you feel any better cciss should be more or less
fading off into irrelevancy in a few years as that hardware ages.

-- steve
