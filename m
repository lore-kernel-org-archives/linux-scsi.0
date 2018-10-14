From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 2/6] esp_scsi: Track residual for PIO transfers
Date: Sun, 14 Oct 2018 12:55:43 +0200
Message-ID: <CAMuHMdV-VUCeO_uOwOtF2Cu-eXria2n-wEaj1qMMnnFWcOSFeg@mail.gmail.com>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <11a3a80e74a006040460fa051747e6a79c6382ce.1539497520.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11a3a80e74a006040460fa051747e6a79c6382ce.1539497520.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Oct 14, 2018 at 8:36 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> If a target disconnects during a PIO data transfer the command may
> fail when the target reconnects:
>
> scsi host1: DMA length is zero!
> scsi host1: cur adr[04380000] len[00000000]
>
> The scsi bus is then reset. This happens because the residual reached
> zero before the transfer was completed.
>
> The usual residual calculation relies on the Transfer Count registers
> which works for DMA transfers but not for PIO transfers. Fix the problem
> by storing the PIO transfer residual and using that to correctly
> calculate bytes_sent.

Thanks for yur patch!

> Fixes: 6fe07aaffbf0

Fixes: 6fe07aaffbf0 ("[SCSI] m68k: new mac_esp scsi driver")

> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>

> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -540,6 +540,8 @@ struct esp {
>
>         void                    *dma;
>         int                     dmarev;
> +
> +       int                     send_cmd_residual;

unsigned int?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
