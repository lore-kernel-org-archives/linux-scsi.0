From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 22/29] atari_scsi: Fix atari_scsi deadlocks on Falcon
Date: Fri, 3 Oct 2014 11:19:02 +0200
Message-ID: <CAMuHMdWb7UwgmcSZCuvyRYFXX3UBg_V6Lm1yawJMZWX-MLretg@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065633.526173012@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065633.526173012@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> --- linux.orig/arch/m68k/atari/stdma.c  2014-10-02 16:55:28.000000000 +1000
> +++ linux/arch/m68k/atari/stdma.c       2014-10-02 16:56:20.000000000 +1000

> -int stdma_others_waiting(void)
> +int stdma_is_locked_by(irq_handler_t handler)
>  {
> -       return waitqueue_active(&stdma_wait);
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       if (stdma_locked && (stdma_isr == handler)) {
> +               local_irq_restore(flags);
> +               return 1;
> +       }
> +       local_irq_restore(flags);
> +       return 0;
>  }

This can be written shorter:

int stdma_is_locked_by(irq_handler_t handler)
{
        unsigned long flags;
        int res;

        local_irq_save(flags);
        res = stdma_locked && (stdma_isr == handler);
        local_irq_restore(flags);

        return res;
}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
