From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 19/29] mac_scsi: Add module option to Kconfig
Date: Fri, 3 Oct 2014 10:44:01 +0200
Message-ID: <CAMuHMdUKQ8z6=jo5DH_Rg6kUrCw6Ap6VyHg9n14J41GXVHdykQ@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065632.816184892@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065632.816184892@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Allow mac_scsi to be built as a module. Replace the old validation of
> __setup options with code that validates both module and __setup options.

> --- linux.orig/drivers/scsi/mac_scsi.c  2014-10-02 16:56:17.000000000 +1000
> +++ linux/drivers/scsi/mac_scsi.c       2014-10-02 16:56:17.000000000 +1000

> @@ -219,15 +179,15 @@ int __init macscsi_detect(struct scsi_ho
>         return 0;
>
>      if (macintosh_config->ident == MAC_MODEL_IIFX) {
> -       mac_scsi_regp  = via1+0x8000;
> -       mac_scsi_drq   = via1+0xE000;
> -       mac_scsi_nodrq = via1+0xC000;
> +       mac_scsi_regp  = (unsigned char *) VIA1_BASE + 0x8000;
> +       mac_scsi_drq   = (unsigned char *) VIA1_BASE + 0xE000;
> +       mac_scsi_nodrq = (unsigned char *) VIA1_BASE + 0xC000;
>         /* The IIFX should be able to do true DMA, but pseudo-dma doesn't work */
>         flags = FLAG_NO_PSEUDO_DMA;
>      } else {
> -       mac_scsi_regp  = via1+0x10000;
> -       mac_scsi_drq   = via1+0x6000;
> -       mac_scsi_nodrq = via1+0x12000;
> +       mac_scsi_regp  = (unsigned char *) VIA1_BASE + 0x10000;
> +       mac_scsi_drq   = (unsigned char *) VIA1_BASE + 0x6000;
> +       mac_scsi_nodrq = (unsigned char *) VIA1_BASE + 0x12000;
>      }
>
>      if (! setup_use_pdma)

I don't think the above chunk belongs in this patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
