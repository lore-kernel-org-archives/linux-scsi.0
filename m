From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 3/3] scsi/ncr5380: Improve interrupt latency during PIO
 tranfers
Date: Mon, 29 Aug 2016 14:06:09 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1608291219110.20939@nippy.intranet>
References: <20160827022958.983743612@telegraphics.com.au> <20160827022959.303563262@telegraphics.com.au> <CAMuHMdUwLAJJUO6L9gKYU4w_RO4s38xzjpRehnNBJPQ7s1+MkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUwLAJJUO6L9gKYU4w_RO4s38xzjpRehnNBJPQ7s1+MkA@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org


On Sun, 28 Aug 2016, Geert Uytterhoeven wrote:

> Hi Finn,
> 
> On Sat, Aug 27, 2016 at 4:30 AM, Finn Thain <fthain@telegraphics.com.au> 
> wrote:
> > Large PIO transfers are broken up into chunks to try to avoid 
> > disabling local IRQs for long periods. But IRQs are still disabled for 
> > too long and this causes SCC FIFO overruns during serial port 
> > transfers. This patch fixes the problem by halving the PIO chunk size.
> >
> > Testing with mac_scsi shows that the extra NCR5380_main() loop 
> > iterations have negligible performance impact on SCSI transfers (about 
> > 1% slower). On a faster system (using the dmx3191d module) transfers 
> > showed no measurable change.
> >
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> >
> > ---
> >  drivers/scsi/NCR5380.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > Index: linux/drivers/scsi/NCR5380.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/NCR5380.c   2016-08-27 12:29:57.000000000 +1000
> > +++ linux/drivers/scsi/NCR5380.c        2016-08-27 12:29:58.000000000 +1000
> > @@ -1847,11 +1847,11 @@ static void NCR5380_information_transfer
> >                                                 /* XXX - need to source or sink data here, as appropriate */
> >                                         }
> >                                 } else {
> > -                                       /* Break up transfer into 3 ms chunks,
> > -                                        * presuming 6 accesses per handshake.
> > +                                       /* Transfer a small chunk so that the
> > +                                        * irq mode lock is not held too long.
> >                                          */
> >                                         transfersize = min((unsigned long)cmd->SCp.this_residual,
> > -                                                          hostdata->accesses_per_ms / 2);
> > +                                                          hostdata->accesses_per_ms >> 2);
> 
> I think it's easier to read if you use "/ 4".

I think the factor, "1/4 byte milliseconds per access" is not very 
meaningful. The PIO transfersize can be understood as,

        pio_bytes_until_scc_fifo_overflow = accesses_per_ms /
                         (accesses_per_pio_byte / ms_until_fifo_overflow)

This loop seemed like a good place to avoid a DIV instruction (though I 
didn't try to confirm that) and so I used a bit shift to indicate that 
intention.

The shift amount was an empirical result that happened to work for the 
hardware I tested it on, at the baud rate I was using. Admittedly, if we 
want to avoid further tweaks to this then I'll have to do more testing and 
find a better approximation.

-- 

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
