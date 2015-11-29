From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Sun, 29 Nov 2015 21:25:53 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511292106140.32336@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511252259.26792.linux@rainbow-software.org> <alpine.LNX.2.00.1511261130120.12333@nippy.intranet> <201511262035.40920.linux@rainbow-software.org> <alpine.LNX.2.00.1511270930280.723@nippy.intranet>
 <CAMuHMdWt5Vf=iOg0BcqTwE-Md75dTmygVOmw45MXVhKuDDQXxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWt5Vf=iOg0BcqTwE-Md75dTmygVOmw45MXVhKuDDQXxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Sun, 29 Nov 2015, Geert Uytterhoeven wrote:

> This still heavily depends on the processing time spent in 
> NCR5380_read(). You should never use a value derived from 
> loops_per_jiffy for a non-empty loop,

Sure but the time-out condition isn't supposed to be precise.
Plus/minus a jiffy is no problem. Plus/minus a second is no good.

> as it may take much longer. Always compare with an maximum end time 
> instead.

That can't work with interrupts disabled, which was the problem I was 
trying to solve by use of loops_per_jiffy.

NCR5380_poll_politely() in mainline doesn't work with interrupts disabled 
either, hence patch 21.

> 
> E.g.:
> 
>         end = jiffies + 2;        /* 1 jiffie + 1 safeguard */
>         do {
>                  if ((NCR5380_read(reg1) & bit1) == val1)
>                          return 0;
>                  cpu_relax();
>         } while (time_before(jiffies, end);
> 
> And a similar loop for "Busy-wait for up to 20 ms".

Interrupts may be disabled during that loop also. Please refer to (and/or 
respond to) patch 21, "ncr5380: Sleep when polling, if possible", in which 
these changes were made.

-- 

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
