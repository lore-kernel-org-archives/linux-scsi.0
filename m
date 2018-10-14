From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Sun, 14 Oct 2018 12:55:57 +0200
Message-ID: <CAMuHMdV6cuXngfmCBbqPsyAZDcFo9sO=F-TYy+OyS5vEOou0eQ@mail.gmail.com>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Oct 14, 2018 at 8:35 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> As a temporary measure, the code to implement PIO transfers was
> duplicated in zorro_esp and mac_esp. Now that it has stabilized
> move the common code into the core driver but don't build it unless
> needed.
>
> This replaces the inline assembler with more portable writesb() calls.
> Optimizing the m68k writesb() implementation is a separate patch.
>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>

Thanks for your patch!

> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -42,6 +42,10 @@ config SCSI_DMA
>         bool
>         default n
>
> +config SCSI_ESP_PIO
> +       bool
> +       default n

"default n" is the default, so please drop this line.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
