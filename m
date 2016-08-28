From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 3/3] scsi/ncr5380: Improve interrupt latency during PIO tranfers
Date: Sun, 28 Aug 2016 10:08:45 +0200
Message-ID: <CAMuHMdUwLAJJUO6L9gKYU4w_RO4s38xzjpRehnNBJPQ7s1+MkA@mail.gmail.com>
References: <20160827022958.983743612@telegraphics.com.au> <20160827022959.303563262@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160827022959.303563262@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sat, Aug 27, 2016 at 4:30 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Large PIO transfers are broken up into chunks to try to avoid disabling
> local IRQs for long periods. But IRQs are still disabled for too long
> and this causes SCC FIFO overruns during serial port transfers. This
> patch fixes the problem by halving the PIO chunk size.
>
> Testing with mac_scsi shows that the extra NCR5380_main() loop iterations
> have negligible performance impact on SCSI transfers (about 1% slower).
> On a faster system (using the dmx3191d module) transfers showed no
> measurable change.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>  drivers/scsi/NCR5380.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux/drivers/scsi/NCR5380.c
> ===================================================================
> --- linux.orig/drivers/scsi/NCR5380.c   2016-08-27 12:29:57.000000000 +1000
> +++ linux/drivers/scsi/NCR5380.c        2016-08-27 12:29:58.000000000 +1000
> @@ -1847,11 +1847,11 @@ static void NCR5380_information_transfer
>                                                 /* XXX - need to source or sink data here, as appropriate */
>                                         }
>                                 } else {
> -                                       /* Break up transfer into 3 ms chunks,
> -                                        * presuming 6 accesses per handshake.
> +                                       /* Transfer a small chunk so that the
> +                                        * irq mode lock is not held too long.
>                                          */
>                                         transfersize = min((unsigned long)cmd->SCp.this_residual,
> -                                                          hostdata->accesses_per_ms / 2);
> +                                                          hostdata->accesses_per_ms >> 2);

I think it's easier to read if you use "/ 4".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
