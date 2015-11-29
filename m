From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Sun, 29 Nov 2015 10:27:25 +0100
Message-ID: <CAMuHMdWt5Vf=iOg0BcqTwE-Md75dTmygVOmw45MXVhKuDDQXxA@mail.gmail.com>
References: <20151118083455.331768508@telegraphics.com.au>
	<201511252259.26792.linux@rainbow-software.org>
	<alpine.LNX.2.00.1511261130120.12333@nippy.intranet>
	<201511262035.40920.linux@rainbow-software.org>
	<alpine.LNX.2.00.1511270930280.723@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511270930280.723@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Thu, Nov 26, 2015 at 11:32 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> The timekeeping warning does not appear when all 71 patches are applied.
>> Reverse-bisected it - the warning disappears after:
>> [PATCH 50/71] ncr5380: Change instance->host_lock to hostdata->lock
>>
>
> Makes sense. I think that this should solve the problem:
>
> Index: linux/drivers/scsi/NCR5380.c
> ===================================================================
> --- linux.orig/drivers/scsi/NCR5380.c   2015-11-27 09:21:40.000000000 +1100
> +++ linux/drivers/scsi/NCR5380.c        2015-11-27 09:25:36.000000000 +1100
> @@ -230,7 +230,7 @@ static int NCR5380_poll_politely2(struct
>         unsigned long n;
>
>         /* Busy-wait for up to 1 jiffy */
> -       n = loops_per_jiffy;
> +       n = 1 + loops_per_jiffy / 10;
>         do {
>                 if ((NCR5380_read(reg1) & bit1) == val1)
>                         return 0;

This still heavily depends on the processing time spent in NCR5380_read().
You should never use a value derived from loops_per_jiffy for a non-empty loop,
as it may take much longer. Always compare with an maximum end time instead.

E.g.:

        end = jiffies + 2;        /* 1 jiffie + 1 safeguard */
        do {
                 if ((NCR5380_read(reg1) & bit1) == val1)
                         return 0;
                 cpu_relax();
        } while (time_before(jiffies, end);

And a similar loop for "Busy-wait for up to 20 ms".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
