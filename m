From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 21/72] ncr5380: Sleep when polling, if possible
Date: Mon, 7 Dec 2015 09:07:22 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512070906540.9090@nippy.intranet>
References: <20151206013126.995379403@telegraphics.com.au> <20151206013132.155478463@telegraphics.com.au> <CAMuHMdVYVHShsnghK4rOvvCy8ab3yGaxO-Vm44xhE4LMbfGcww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVYVHShsnghK4rOvvCy8ab3yGaxO-Vm44xhE4LMbfGcww@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 6 Dec 2015, Geert Uytterhoeven wrote:

> 
> As the caller of NCR5380_poll_politely() passes a timeout value in 
> jiffies, calculations may become simpler if you store the number of 
> accesses per jiffy instead of per ms.

Yes, I thought of that too. However, the number of accesses per jiffy 
could vanish or become imprecise depending on the speed of the hardware 
and the HZ setting. I chose milliseconds because it seemed to provide a 
good compromise between precision and range.

> 
> Unlike the historical calibrating-delay-loop code, you don't wait for a 
> jiffy change before starting the calibration. At first I thought that 
> was OK, but on some platforms, HZ can be as low as 24, which means the 
> result can vary by 33% (based on 100 ms -> 3 jiffies).

Oops. I shall have to fix that.

> 
> The same change is made to atari_NCR5380.c. I guess you plan to 
> deduplicate this code when merging the drivers, i.e. after this series?

One of the two forks will have to go. That churn is discussed in patch 0.

Thanks for your review.

-- 

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
