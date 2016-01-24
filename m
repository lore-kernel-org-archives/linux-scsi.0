From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 34/78] atari_NCR5380: Use arbitration timeout
Date: Sun, 24 Jan 2016 11:38:46 +0100
Message-ID: <CAMuHMdXKDwfEE0J2xjan2vhO3gyfBwaeRMa3Vh4-ewUrW61pvA@mail.gmail.com>
References: <20160103050501.042035135@telegraphics.com.au>
	<20160103050510.031796194@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160103050510.031796194@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Jan 3, 2016 at 6:05 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Allow target selection to fail with a timeout instead of waiting in
> infinite loops. This gets rid of the unused NCR_TIMEOUT macro, it is more
> defensive and has proved helpful in debugging.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Ondrej Zary <linux@rainbow-software.org>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>

This patch (commit 55500d9b08295e3b6016b53879dea1cb7787f1b0) causes a hang
on ARAnyM with atari_defconfig after:

    scsi host0: Atari native SCSI, io_port 0x0, n_io_port 0, base 0x0,
irq 15, can_queue 8, cmd_per_lun 1, sg_tablesize 0, this_id 7, flags {
}, options { REAL_DMA SUPPORT_TAGS }
    blk_queue_max_segments: set to minimum 1

> --- linux.orig/drivers/scsi/atari_NCR5380.c     2016-01-03 16:03:43.000000000 +1100
> +++ linux/drivers/scsi/atari_NCR5380.c  2016-01-03 16:03:44.000000000 +1100
> @@ -1436,42 +1437,28 @@ static int NCR5380_select(struct Scsi_Ho
>         NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
>         NCR5380_write(MODE_REG, MR_ARBITRATE);
>
> -       local_irq_restore(flags);
> +       /* The chip now waits for BUS FREE phase. Then after the 800 ns
> +        * Bus Free Delay, arbitration will begin.
> +        */
>
> -       /* Wait for arbitration logic to complete */
> -#if defined(NCR_TIMEOUT)
> -       {
> -               unsigned long timeout = jiffies + 2*NCR_TIMEOUT;
> -
> -               while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS) &&
> -                      time_before(jiffies, timeout) && !hostdata->connected)
> -                       ;
> -               if (time_after_eq(jiffies, timeout)) {
> -                       printk("scsi : arbitration timeout at %d\n", __LINE__);
> +       local_irq_restore(flags);
> +       timeout = jiffies + HZ;
> +       while (1) {
> +               if (time_is_before_jiffies(timeout)) {
>                         NCR5380_write(MODE_REG, MR_BASE);
> -                       NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> +                       shost_printk(KERN_ERR, instance,
> +                                    "select: arbitration timeout\n");
>                         return -1;
>                 }
> +               if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {

This newly added check always triggers, causing an infinite loop calling
NCR5380_select().
Perhaps this is an ARAnyM quirk?
If not, does it trigger (on some hardware) with drivers/scsi/NCR5380.c, too?

> +                       /* Reselection interrupt */
> +                       return -1;
> +               }
> +               if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS)
> +                       break;
>         }
> -#else /* NCR_TIMEOUT */
> -       while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS) &&
> -              !hostdata->connected)
> -               ;
> -#endif
> -
> -       dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOSTNO);
> -
> -       if (hostdata->connected) {
> -               NCR5380_write(MODE_REG, MR_BASE);
> -               return -1;
> -       }
> -       /*
> -        * The arbitration delay is 2.2us, but this is a minimum and there is
> -        * no maximum so we can safely sleep for ceil(2.2) usecs to accommodate
> -        * the integral nature of udelay().
> -        *
> -        */
>
> +       /* The SCSI-2 arbitration delay is 2.4 us */
>         udelay(3);
>
>         /* Check for lost arbitration */

On current mainline, this (whitespace-damaged) patch fixed the issue for me:

--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -1253,10 +1253,6 @@ static struct scsi_cmnd *NCR5380_select(struct
Scsi_Host *instance,
                        INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
                                               ICR_ARBITRATION_PROGRESS, HZ);
        spin_lock_irq(&hostdata->lock);
-       if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
-               /* Reselection interrupt */
-               goto out;
-       }
        if (err < 0) {
                NCR5380_write(MODE_REG, MR_BASE);
                shost_printk(KERN_ERR, instance,
@@ -1297,10 +1293,6 @@ static struct scsi_cmnd *NCR5380_select(struct
Scsi_Host *instance,

        spin_lock_irq(&hostdata->lock);

-       /* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
-       if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
-               goto out;
-
        if (!hostdata->selecting) {
                NCR5380_write(MODE_REG, MR_BASE);
                NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);

Gr{oetje,eeting}s,

                        Geert
