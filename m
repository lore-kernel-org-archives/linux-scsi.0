From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 30 Aug 2017 14:43:34 +0900
Message-ID: <20170830054334.GF3240@X58A-UD3R>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170830052037.GA432@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170830052037.GA432@jagdpanzerIV.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 30, 2017 at 02:20:37PM +0900, Sergey Senozhatsky wrote:
> Byungchul, a quick question.

Hello Sergey,

> have you measured the performance impact? somehow my linux-next is

Yeah, it might have performance impact inevitably.

> notably slower than earlier 4.13 linux-next. (e.g. scrolling in vim
> is irritatingly slow)

To Ingo,

I cannot decide if we have to roll back CONFIG_LOCKDEP_CROSSRELEASE
dependency on CONFIG_PROVE_LOCKING in Kconfig. With them enabled,
lockdep detection becomes strong but has performance impact. But,
it's anyway a debug option so IMHO we don't have to take case of the
performance impact. Please let me know your decision.

> `time dmesg' shows some difference, but probably that's not a good
> test.
> 
> 	!LOCKDEP	LOCKDEP		LOCKDEP -CROSSRELEASE -COMPLETIONS
> 	real 0m0.661s	0m2.290s	0m1.920s
> 	user 0m0.010s	0m0.105s	0m0.000s
> 	sys  0m0.636s	0m2.224s	0m1.888s
> 
> anyone else "sees"/"can confirm" the slow down?
> 
> 
> it gets back to "usual normal" when I disable CROSSRELEASE and COMPLETIONS.
> 
> ---
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index b19c491cbc4e..cdc30ef81c5e 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1091,8 +1091,6 @@ config PROVE_LOCKING
>         select DEBUG_MUTEXES
>         select DEBUG_RT_MUTEXES if RT_MUTEXES
>         select DEBUG_LOCK_ALLOC
> -       select LOCKDEP_CROSSRELEASE
> -       select LOCKDEP_COMPLETIONS
>         select TRACE_IRQFLAGS
>         default n
>         help
> 
> ---
> 
> 	-ss
