From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 10/29] ncr5380: Fix SCSI_IRQ_NONE bugs
Date: Fri, 3 Oct 2014 10:22:20 +0200
Message-ID: <CAMuHMdWHkGFamsnxJAi++WFqx8OAZ-qyuQDQN66Gi8JJunB0dw@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065630.639025422@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065630.639025422@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Oak scsi doesn't use any IRQ, but it sets irq = IRQ_NONE rather than
> SCSI_IRQ_NONE. Problem is, the core NCR5380 driver expects SCSI_IRQ_NONE
> if it is to issue IDENTIFY commands that prevent target disconnection.
>
> Other drivers, when they can't get an IRQ or can't use one, will set
> host->irq = SCSI_IRQ_NONE (that is, 255). But when they exit they will
> attempt to free IRQ 255 which was never requested.
>
> Fix these bugs by using IRQ_NONE in place of SCSI_IRQ_NONE. This means
> IRQ 0 is no longer probed by ISA drivers but I don't think this matters.

IRQ_NONE is part of enum irqreturn. I guess you meant NO_IRQ?

But NO_IRQ is deprecated, and not available on all architectures.
The recommended way is to just use 0, like in "if (instance->irq) ...".

Note that some drivers do

#ifndef NO_IRQ
#define NO_IRQ  (-1)
#endif

and others do

#ifndef NO_IRQ
#define NO_IRQ  0
#endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
