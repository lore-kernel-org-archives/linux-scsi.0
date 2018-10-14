From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 1/6] zorro_esp: Limit DMA transfers to 65535 bytes
Date: Sun, 14 Oct 2018 12:55:21 +0200
Message-ID: <CAMuHMdUNyfq00ugz-LifqmKwA4Mau6Vi-z5wCX_a=_jq1yZT_g@mail.gmail.com>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <022a8c581d228f3f01dfa783aadd183a53169daa.1539497520.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <022a8c581d228f3f01dfa783aadd183a53169daa.1539497520.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Oct 14, 2018 at 8:36 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> The core driver, esp_scsi, does not use the ESP_CONFIG2_FENAB bit, so
> the chip's Transfer Counter register is only 16 bits wide (not 24).
> A larger transfer cannot work and will theoretically result in a failed
> command and a "DMA length is zero" error.

Thanks for your patch!

> Fixes: 3109e5ae0311

Fixes: 3109e5ae0311 ("scsi: zorro_esp: New driver for Amiga Zorro
NCR53C9x boards")

$ git help fixes
'fixes' is aliased to 'show --format='Fixes: %h ("%s")' -s'

BTW, if you use vim, add

    noremap ;gs "zyiw:exe "new \| setlocal buftype=nofile
bufhidden=hide noswapfile syntax=git \| 0r ! git show ".@z."" \|
:0<CR><CR>

to .vimrc, and type ";gs" when the cursor is positioned on a commit ID.

> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>

> --- a/drivers/scsi/zorro_esp.c
> +++ b/drivers/scsi/zorro_esp.c
> @@ -245,7 +245,7 @@ static int fastlane_esp_irq_pending(struct esp *esp)
>  static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
>                                         u32 dma_len)
>  {
> -       return dma_len > 0xFFFFFF ? 0xFFFFFF : dma_len;
> +       return dma_len > 0xFFFF ? 0xFFFF : dma_len;
>  }
>
>  static void zorro_esp_reset_dma(struct esp *esp)
> @@ -484,7 +484,6 @@ static void zorro_esp_send_blz1230_dma_cmd(struct esp *esp, u32 addr,
>         scsi_esp_cmd(esp, ESP_CMD_DMA);
>         zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
>         zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
> -       zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);

Since all these sub-drivers seem to support 24-bit transfers, perhaps this is
something to be fixed in the esp_scsi core?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
