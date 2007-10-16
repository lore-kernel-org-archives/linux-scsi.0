From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.24
Date: Tue, 16 Oct 2007 21:21:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710162121330.29643@anakin>
References: <1192421381.3429.6.camel@localhost.localdomain>
 <Pine.LNX.4.64.0710160846030.16889@anakin> <4714762B.5040401@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965445AbXJPTWR@vger.kernel.org>
In-Reply-To: <4714762B.5040401@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 16 Oct 2007, Boaz Harrosh wrote:
> On Tue, Oct 16 2007 at 8:49 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, 15 Oct 2007, James Bottomley wrote:
> >> This is the accumulated updates queued for 2.6.24.  It contains the
> >> usual slew of driver updates, plus some gdth and advansys rewrites.  We
> >> still have some outstanding bugs in gdth and fc4 for which I'm hoping to
> >> sweep fixes into the next update.
> > 
> >> Boaz Harrosh (12):
> >>       NCR5380: Use scsi_eh API for REQUEST_SENSE invocation
> > 
> > This change broke compilation of the mac_scsi.c driver:
> > 
> > | linux/drivers/scsi/NCR5380.c: In function 'NCR5380_information_transfer':
> > | linux/drivers/scsi/NCR5380.c:2282: error: 'struct NCR5380_hostdata' has no member named 'ses'
> > | linux/drivers/scsi/NCR5380.c:2283: error: 'struct NCR5380_hostdata' has no member named 'ses'
> > | linux/drivers/scsi/NCR5380.c:2284: error: 'struct NCR5380_hostdata' has no member named 'ses'
> > | linux/drivers/scsi/NCR5380.c:2288: error: 'struct NCR5380_hostdata' has no member named 'ses'
> > 
> fix below, Sorry.
> ----
> >From 1e10cf1a39ff4909696a5c7950367261b38b3345 Mon Sep 17 00:00:00 2001
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Tue, 16 Oct 2007 10:25:01 +0200
> Subject: [PATCH] scsi_mac.h: Define AUTOSENSE before include of NCR5380.h
> 
>   - Previese patch to NCR5380 broke scsi_mac because
>     AUTOSENSE was defined after the inclusion of
>     NCR5380.h. Fix it
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/scsi/mac_scsi.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index cdbcaa5..abe2bda 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -53,6 +53,11 @@
>  #include "scsi.h"
>  #include <scsi/scsi_host.h>
>  #include "mac_scsi.h"
> +
> +/* These control the behaviour of the generic 5380 core */
> +#define AUTOSENSE
> +#define PSEUDO_DMA
> +
>  #include "NCR5380.h"
>  
>  #if 0
> @@ -571,10 +576,6 @@ static int macscsi_pwrite (struct Scsi_Host *instance,
>  }
>  
>  
> -/* These control the behaviour of the generic 5380 core */
> -#define AUTOSENSE
> -#define PSEUDO_DMA
> -
>  #include "NCR5380.c"
>  
>  static struct scsi_host_template driver_template = {
> -- 
> 1.5.3.1
> 
> 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
