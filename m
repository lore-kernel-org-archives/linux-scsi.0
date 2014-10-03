From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 21/29] mac_scsi: Convert to platform device
Date: Fri, 3 Oct 2014 11:08:33 +0200
Message-ID: <CAMuHMdUN-FdTro7wQWXbGmqrKe=dec1xJNgAkQGhFw7CEVRUsQ@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065633.296184897@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065633.296184897@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Convert mac_scsi to platform device and eliminate scsi_register().
>
> Platform resources for chip registers now follow the documentation. This
> should fix issues with the Mac IIci (and possibly other models too).
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>
> The new hwreg_present() call is not protected by local_irq_save/restore.
> This assumes Geert's patch, "Disable/restore interrupts in
> hwreg_present()/hwreg_write()":
> http://marc.info/?l=linux-kernel&m=141189640826704&w=2

OK, so this cannot go in before v3.18-rc1.

> --- linux.orig/drivers/scsi/mac_scsi.c  2014-10-02 16:56:18.000000000 +1000
> +++ linux/drivers/scsi/mac_scsi.c       2014-10-02 16:56:19.000000000 +1000

> @@ -480,7 +380,117 @@ static struct scsi_host_template driver_
>         .use_clustering                 = DISABLE_CLUSTERING
>  };
>
> +static int __init mac_scsi_probe(struct platform_device *pdev)
> +{
> +       struct Scsi_Host *instance;
> +       int error;
> +       int host_flags = 0;
> +       struct resource *irq, *pio_mem, *pdma_mem = NULL;
> +
> +       if (!MACH_IS_MAC)
> +               return -ENODEV;

This check is not needed, asuming you'll only instantiate the platform
device when running on a Mac.

> --- linux.orig/arch/m68k/mac/config.c   2014-10-02 16:55:28.000000000 +1000
> +++ linux/arch/m68k/mac/config.c        2014-10-02 16:56:19.000000000 +1000

> @@ -929,6 +929,36 @@ static struct platform_device swim_pdev
>         .resource       = &swim_rsrc,
>  };
>
> +static struct resource mac_scsi_0_rsrc[] = {
> +       {
> +               .flags = IORESOURCE_IRQ,
> +               .start = IRQ_MAC_SCSI,
> +               .end   = IRQ_MAC_SCSI,
> +       },
> +       { .flags = IORESOURCE_MEM },
> +       { .flags = IORESOURCE_MEM },
> +};
> +
> +static struct resource mac_scsi_1_rsrc[] = {
> +       /* IRQ_NUBUS_E maybe? */
> +       { .flags = IORESOURCE_MEM },
> +       { .flags = IORESOURCE_MEM },
> +};
> +
> +static struct platform_device mac_scsi_0_pdev = {
> +       .name           = "mac_scsi",
> +       .id             = 0,
> +       .resource       = mac_scsi_0_rsrc,
> +       .num_resources  = ARRAY_SIZE(mac_scsi_0_rsrc),
> +};
> +
> +static struct platform_device mac_scsi_1_pdev = {
> +       .name           = "mac_scsi",
> +       .id             = 1,
> +       .resource       = mac_scsi_1_rsrc,
> +       .num_resources  = ARRAY_SIZE(mac_scsi_1_rsrc),
> +};
> +
>  static struct platform_device esp_0_pdev = {
>         .name           = "mac_esp",
>         .id             = 0,
> @@ -1000,6 +1030,53 @@ int __init mac_platform_init(void)
>                     (macintosh_config->ident == MAC_MODEL_Q950))
>                         platform_device_register(&esp_1_pdev);
>                 break;
> +       case MAC_SCSI_IIFX:
> +               /* Addresses from The Guide to Mac Family Hardware. */
> +               mac_scsi_0_rsrc[1].start = 0x50008000; /* SCSI DMA */
> +               mac_scsi_0_rsrc[1].end = mac_scsi_0_rsrc[1].start + 0x1FFF;
> +               /* $5000 E000 - $5000 FFFF: Alternate SCSI (Hsk) */
> +               /* $5000 C000 - $5000 DFFF: Alternate SCSI (DMA) */
> +               /* The SCSI DMA custom IC embeds the 53C80 core. mac_scsi does
> +                * not make use of its DMA or hardware handshaking logic.
> +                */
> +               mac_scsi_0_pdev.num_resources--;
> +               platform_device_register(&mac_scsi_0_pdev);

What about removing the static mac_scsi_0_pdev and mac_scsi_1_pdev,
and calling platform_device_register_simple() instead?
That way you
(a) don't have to fiddle with mac_scsi_0_pdev.num_resources, and
(b) the resources can become const and __initconst, as a copy will be
    allocated dynamically.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
