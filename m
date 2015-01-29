From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Date: Thu, 29 Jan 2015 17:56:37 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1501291636140.7510@nippy.intranet>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk> <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


I have one reservation about this patch series.

For example, the changes,

-	seq_printf(m, "%s", p);
+	seq_puts(m, p);

These calls are not equivalent because the bounds check is not the same. 
seq_puts will fail when m->count + strlen(p) == m->size.

seq_write() does the same check as seq_puts() but the other routines vary.

There's a similar situation with the changes,

-	seq_puts(m, "x");
+	seq_putc(m, 'x');

Have you considered what the implications might be? Are there any?

-- 

On Wed, 3 Dec 2014, Rasmus Villemoes wrote:

> These patches mostly replace seq_printf with simpler and faster
> equivalents, e.g. seq_printf(m, "something") => seq_puts(m,
> "something") and seq_printf(m, "\n") => seq_putc(m, '\n). But before
> my Coccinelle scripts could be unleashed I had to clean up an
> unnecessary macro.
> 
> The patches don't change the semantics of the code (well, that's the
> idea anyway), but should make it slightly smaller and faster.
> 
> v2: Redone on top of git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.19
> 
> Rasmus Villemoes (6):
>   scsi: Remove SPRINTF macro
>   scsi/advansys: Replace seq_printf with seq_puts
>   scsi/aha152x: Replace seq_printf with seq_puts
>   scsi: misc:  Replace seq_printf with seq_puts
>   scsi: misc: Merge consecutive seq_puts calls
>   scsi: misc: Print single-character strings with seq_putc
> 
>  drivers/scsi/BusLogic.c             |  10 +-
>  drivers/scsi/NCR5380.c              |  20 ++-
>  drivers/scsi/advansys.c             | 142 ++++++++---------
>  drivers/scsi/aha152x.c              | 295 ++++++++++++++++++------------------
>  drivers/scsi/aic7xxx/aic79xx_proc.c |  38 +++--
>  drivers/scsi/aic7xxx/aic7xxx_proc.c |  24 +--
>  drivers/scsi/arm/fas216.c           |   6 +-
>  drivers/scsi/atari_NCR5380.c        |   4 +-
>  drivers/scsi/atp870u.c              |   5 +-
>  drivers/scsi/dc395x.c               |  79 +++++-----
>  drivers/scsi/dpt_i2o.c              |   2 +-
>  drivers/scsi/eata_pio.c             |   2 +-
>  drivers/scsi/esas2r/esas2r_main.c   |   2 +-
>  drivers/scsi/gdth_proc.c            |  24 +--
>  drivers/scsi/in2000.c               |  18 +--
>  drivers/scsi/ips.c                  |   7 +-
>  drivers/scsi/megaraid.c             |   2 +-
>  drivers/scsi/nsp32.c                |  41 +++--
>  drivers/scsi/pcmcia/nsp_cs.c        |  50 +++---
>  drivers/scsi/qla2xxx/qla_dfs.c      |   8 +-
>  drivers/scsi/scsi_proc.c            |  22 +--
>  drivers/scsi/scsi_trace.c           |   6 +-
>  drivers/scsi/wd33c93.c              |  18 +--
>  drivers/scsi/wd7000.c               |  41 +++--
>  24 files changed, 412 insertions(+), 454 deletions(-)
> 
> 
