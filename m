From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take 2
Date: Sun, 2 Jun 2019 11:07:08 +0200
Message-ID: <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com>
References: <cover.1559438652.git.fthain@telegraphics.com.au> <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
Sender: stable-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Jun 2, 2019 at 3:29 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> A system bus error during a PDMA transfer can mess up the calculation of
> the transfer residual (the PDMA handshaking hardware lacks a byte
> counter). This results in data corruption.
>
> The algorithm in this patch anticipates a bus error by starting each
> transfer with a MOVE.B instruction. If a bus error is caught the transfer
> will be retried. If a bus error is caught later in the transfer (for a
> MOVE.W instruction) the transfer gets failed and subsequent requests for
> that target will use PIO instead of PDMA.
>
> This avoids the "!REQ and !ACK" error so the severity level of that
> message is reduced to KERN_DEBUG.
>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org # v4.14+
> Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
> Reported-by: Chris Jones <chris@martin-jones.com>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Thanks for your patch!

> ---
>  arch/m68k/include/asm/mac_pdma.h | 179 +++++++++++++++++++++++++++
>  drivers/scsi/mac_scsi.c          | 201 ++++++++-----------------------

Why have you moved the PDMA implementation to a header file under
arch/m68k/? Do you intend to reuse it by other drivers?

If not, please keep it in the driver, so (a) you don't need an ack from
me ;-), and (b) your change may be easier to review.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
