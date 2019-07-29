From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] scsi: sun3_scsi: Mark expected switch fall-throughs
Date: Mon, 29 Jul 2019 17:39:49 +0200
Message-ID: <CAMuHMdXEU4eUEdNyY=K2B_Tj=unJV2eSJo1BQ8vDwZ-D-2wDWg@mail.gmail.com>
References: <20190729143007.GA8067@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729143007.GA8067@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Hi Gustavo,

On Mon, Jul 29, 2019 at 4:32 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> Mark switch cases where we are expecting to fall through.
>
> This patch fixes the following warnings:
>
> drivers/scsi/sun3_scsi.c: warning: this statement may fall through
> [-Wimplicit-fallthrough=]:  => 399:9, 403:9
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks!
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -397,10 +397,12 @@ static int sun3scsi_dma_finish(int write_flag)
>                 case CSR_LEFT_3:
>                         *vaddr = (dregs->bpack_lo & 0xff00) >> 8;
>                         vaddr--;
> +                       /* Fall through */
>
>                 case CSR_LEFT_2:
>                         *vaddr = (dregs->bpack_hi & 0x00ff);
>                         vaddr--;
> +                       /* Fall through */
>

I think it would be clearer if you would drop the blank lines.

>                 case CSR_LEFT_1:
>                         *vaddr = (dregs->bpack_hi & 0xff00) >> 8;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
