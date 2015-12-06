From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 21/72] ncr5380: Sleep when polling, if possible
Date: Sun, 6 Dec 2015 11:18:04 +0100
Message-ID: <CAMuHMdVYVHShsnghK4rOvvCy8ab3yGaxO-Vm44xhE4LMbfGcww@mail.gmail.com>
References: <20151206013126.995379403@telegraphics.com.au>
	<20151206013132.155478463@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151206013132.155478463@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Dec 6, 2015 at 2:31 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> When in process context, sleep during polling if doing so won't add
> significant latency. In interrupt context or if the lock is held, poll
> briefly then give up. Keep both core drivers in sync.
>
> Calibrate busy-wait iterations to allow for variation in chip register
> access times between different 5380 hardware implementations.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>
> Changed since v1:
> - Don't rely on loops_per_jiffy to estimate register access speed, measure
>   it instead.
>
> ---
>  drivers/scsi/NCR5380.c       |   77 +++++++++++++++++++++++++------------------
>  drivers/scsi/NCR5380.h       |    1
>  drivers/scsi/atari_NCR5380.c |   59 ++++++++++++++++++++------------
>  3 files changed, 84 insertions(+), 53 deletions(-)
>
> Index: linux/drivers/scsi/NCR5380.c
> ===================================================================
> --- linux.orig/drivers/scsi/NCR5380.c   2015-12-06 12:29:51.000000000 +1100
> +++ linux/drivers/scsi/NCR5380.c        2015-12-06 12:29:54.000000000 +1100
> @@ -293,44 +293,48 @@ static inline void initialize_SCp(struct
>  }
>
>  /**
> - *     NCR5380_poll_politely   -       wait for NCR5380 status bits
> - *     @instance: controller to poll
> - *     @reg: 5380 register to poll
> - *     @bit: Bitmask to check
> - *     @val: Value required to exit
> - *
> - *     Polls the NCR5380 in a reasonably efficient manner waiting for
> - *     an event to occur, after a short quick poll we begin giving the
> - *     CPU back in non IRQ contexts
> + * NCR5380_poll_politely - wait for chip register value
> + * @instance: controller to poll
> + * @reg: 5380 register to poll
> + * @bit: Bitmask to check
> + * @val: Value required to exit
> + * @wait: Time-out in jiffies
> + *
> + * Polls the chip in a reasonably efficient manner waiting for an
> + * event to occur. After a short quick poll we begin to yield the CPU
> + * (if possible). In irq contexts the time-out is arbitrarily limited.
> + * Callers may hold locks as long as they are held in irq mode.
>   *
> - *     Returns the value of the register or a negative error code.
> + * Returns 0 if event occurred otherwise -ETIMEDOUT.
>   */
> -
> -static int NCR5380_poll_politely(struct Scsi_Host *instance, int reg, int bit, int val, int t)
> +
> +static int NCR5380_poll_politely(struct Scsi_Host *instance,
> +                                 int reg, int bit, int val, int wait)
>  {
> -       int n = 500;            /* At about 8uS a cycle for the cpu access */
> -       unsigned long end = jiffies + t;
> -       int r;
> -
> -       while( n-- > 0)
> -       {
> -               r = NCR5380_read(reg);
> -               if((r & bit) == val)
> +       struct NCR5380_hostdata *hostdata = shost_priv(instance);
> +       unsigned long deadline = jiffies + wait;
> +       unsigned long n;
> +
> +       /* Busy-wait for up to 10 ms */
> +       n = min(10000U, jiffies_to_usecs(wait));
> +       n *= hostdata->accesses_per_ms;
> +       n /= 1000;
> +       do {
> +               if ((NCR5380_read(reg) & bit) == val)
>                         return 0;
>                 cpu_relax();
> -       }

> @@ -773,6 +777,7 @@ static int NCR5380_init(struct Scsi_Host
>  {
>         int i;
>         struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
> +       unsigned long deadline;
>
>         if(in_interrupt())
>                 printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
> @@ -812,6 +817,16 @@ static int NCR5380_init(struct Scsi_Host
>         NCR5380_write(MODE_REG, MR_BASE);
>         NCR5380_write(TARGET_COMMAND_REG, 0);
>         NCR5380_write(SELECT_ENABLE_REG, 0);
> +
> +       /* Calibrate register polling loop */
> +       i = 0;
> +       deadline = jiffies + msecs_to_jiffies(100) + 1;
> +       do {
> +               NCR5380_read(STATUS_REG);
> +               ++i;
> +       } while (time_is_after_jiffies(deadline));
> +       hostdata->accesses_per_ms = i / 100;

As the caller of NCR5380_poll_politely() passes a timeout value in jiffies,
calculations may become simpler if you store the number of accesses per jiffy
instead of per ms.

Unlike the historical calibrating-delay-loop code, you don't wait for a jiffy
change before starting the calibration. At first I thought that was OK, but on
some platforms, HZ can be as low as 24, which means the result can vary by 33%
(based on 100 ms -> 3 jiffies).

The same change is made to atari_NCR5380.c.
I guess you plan to deduplicate this code when merging the drivers, i.e.
after this series?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
