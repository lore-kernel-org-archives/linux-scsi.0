From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Fri, 3 Oct 2014 11:34:21 +0200
Message-ID: <CAMuHMdWmxEUMabRrbQpjhWTE1W4WD4CDkmXZNem06C0ScnKkFw@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065633.766165263@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065633.766165263@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Convert atari_scsi to platform device and eliminate scsi_register().
>
> Validate __setup options later on so that module options are checked as well.
>
> Remove the comment about the scsi mid-layer disabling the host irq as it
> is no longer true (AFAICT). Also remove the obsolete slow interrupt stuff
> (IRQ_TYPE_SLOW == 0 anyway).

> --- linux.orig/drivers/scsi/atari_scsi.c        2014-10-02 16:56:20.000000000 +1000
> +++ linux/drivers/scsi/atari_scsi.c     2014-10-02 16:56:21.000000000 +1000

> +static int __init atari_scsi_probe(struct platform_device *pdev)
> +{
> +       struct Scsi_Host *instance;
> +       int error;
> +
> +       if (!MACH_IS_ATARI)
> +               return -ENODEV;

This test is not needed.

> +       if (ATARIHW_PRESENT(TT_SCSI)) {
> +               atari_scsi_reg_read  = atari_scsi_tt_reg_read;
> +               atari_scsi_reg_write = atari_scsi_tt_reg_write;
> +       } else if (ATARIHW_PRESENT(ST_SCSI)) {
> +               atari_scsi_reg_read  = atari_scsi_falcon_reg_read;
> +               atari_scsi_reg_write = atari_scsi_falcon_reg_write;

Can these be handled through the platform_device's resources?

> +       } else
> +               return -ENODEV;

This branch should not be there.

> +       /* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary.
> +        * Higher values should work, too; try it!
> +        * (But cmd_per_lun costs memory!)
> +        *
> +        * But there seems to be a bug somewhere that requires CAN_QUEUE to be
> +        * 2*CMD_PER_LUN. At least on a TT, no spurious timeouts seen since
> +        * changed CMD_PER_LUN...
> +        *
> +        * Note: The Falcon currently uses 8/1 setting due to unsolved problems
> +        * with cmd_per_lun != 1
> +        */
> +       if (IS_A_TT()) {
> +               atari_scsi_template.can_queue    = 16;
> +               atari_scsi_template.cmd_per_lun  = 8;
> +               atari_scsi_template.sg_tablesize = SG_ALL;
> +       } else {
> +               atari_scsi_template.can_queue    = 8;
> +               atari_scsi_template.cmd_per_lun  = 1;
> +               atari_scsi_template.sg_tablesize = SG_NONE;
> +       }

Shouldn't this be in platform data?

> +       /* Leave sg_tablesize at 0 on a Falcon! */
> +       if (IS_A_TT() && setup_sg_tablesize >= 0)
> +               atari_scsi_template.sg_tablesize = setup_sg_tablesize;

I think the IS_A_TT() check can just be removed.

> +#ifdef REAL_DMA
> +       /* If running on a Falcon and if there's TT-Ram (i.e., more than one
> +        * memory block, since there's always ST-Ram in a Falcon), then
> +        * allocate a STRAM_BUFFER_SIZE byte dribble buffer for transfers
> +        * from/to alternative Ram.
> +        */
> +       if (ATARIHW_PRESENT(ST_SCSI) && !ATARIHW_PRESENT(EXTD_DMA) &&
> +           m68k_num_memory > 1) {
> +               atari_dma_buffer = atari_stram_alloc(STRAM_BUFFER_SIZE, "SCSI");
> +               if (!atari_dma_buffer) {
> +                       pr_err(PFX "can't allocate ST-RAM double buffer\n");
> +                       return -ENOMEM;
> +               }
> +               atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
> +               atari_dma_orig_addr = 0;
> +       }
> +#endif

More platform data?

> +       if (IS_A_TT())
> +               instance->irq = IRQ_TT_MFP_SCSI;
> +       else
> +               instance->irq = IRQ_NONE;

platform_device resource?

(and IRQ_NONE is wrong, you should use 0)

> +       if (IS_A_TT()) {

Check for instance->irq instead?

> +               error = request_irq(instance->irq, scsi_tt_intr, 0,
> +                                   "NCR5380", instance);
> +               if (error) {
> +                       pr_err(PFX "request irq %d failed, aborting\n",
> +                              instance->irq);
> +                       goto fail_irq;
> +               }
> +               tt_mfp.active_edge |= 0x80;     /* SCSI int on L->H */
> +#ifdef REAL_DMA
> +               tt_scsi_dma.dma_ctrl = 0;
> +               atari_dma_residual = 0;
> +
> +               /* While the read overruns (described by Drew Eckhardt in
> +                * NCR5380.c) never happened on TTs, they do in fact on the
> +                * Medusa (This was the cause why SCSI didn't work right for
> +                * so long there.) Since handling the overruns slows down
> +                * a bit, I turned the #ifdef's into a runtime condition.
> +                *
> +                * In principle it should be sufficient to do max. 1 byte with
> +                * PIO, but there is another problem on the Medusa with the DMA
> +                * rest data register. So 'atari_read_overruns' is currently set
> +                * to 4 to avoid having transfers that aren't a multiple of 4.
> +                * If the rest data bug is fixed, this can be lowered to 1.
> +                */
> +               if (MACH_IS_MEDUSA)
> +                       atari_read_overruns = 4;
> +#endif
> +       } else {
> +               /* Nothing to do for the interrupt: the ST-DMA is initialized
> +                * already.
> +                */
> +#ifdef REAL_DMA
> +               atari_dma_residual = 0;
> +               atari_dma_active = 0;
> +               atari_dma_stram_mask = (ATARIHW_PRESENT(EXTD_DMA) ? 0x00000000
> +                                       : 0xff000000);
> +#endif
> +       }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
