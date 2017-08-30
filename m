From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 30 Aug 2017 10:42:07 +0200
Message-ID: <20170830084207.GL32112@worktop.programming.kicks-ass.net>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170830052037.GA432@jagdpanzerIV.localdomain>
 <20170830054334.GF3240@X58A-UD3R>
 <20170830061511.GA330@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170830061511.GA330@jagdpanzerIV.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Byungchul Park <byungchul.park@lge.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 30, 2017 at 03:15:11PM +0900, Sergey Senozhatsky wrote:
> Hi,
> 
> On (08/30/17 14:43), Byungchul Park wrote:
> [..]
> > > notably slower than earlier 4.13 linux-next. (e.g. scrolling in vim
> > > is irritatingly slow)
> > 
> > To Ingo,
> > 
> > I cannot decide if we have to roll back CONFIG_LOCKDEP_CROSSRELEASE
> > dependency on CONFIG_PROVE_LOCKING in Kconfig. With them enabled,
> > lockdep detection becomes strong but has performance impact. But,
> > it's anyway a debug option so IMHO we don't have to take case of the
> > performance impact. Please let me know your decision.
> 
> well, I expected it :)
> 
> I've been running lockdep enabled kernels for years, and was OK with
> the performance. but now it's just too much and I'm looking at disabling
> lockdep.
> 
> a more relevant test -- compilation of a relatively small project
> 
>   LOCKDEP -CROSSRELEASE -COMPLETIONS     LOCKDEP +CROSSRELEASE +COMPLETIONS
> 
>    real    1m23.722s                      real    2m9.969s
>    user    4m11.300s                      user    4m15.458s
>    sys     0m49.386s                      sys     2m3.594s
> 
> 
> you don't want to know how much time now it takes to recompile the
> kernel ;)

Right,.. so when I look at perf annotate for __lock_acquire and
lock_release (the two most expensive lockdep functions in a kernel
profile) I don't actually see much cross-release stuff.

So the overhead looks to be spread out over all sorts, which makes it
harder to find and fix.

stack unwinding is done lots and is fairly expensive, I've not yet
checked if crossrelease does too much of that.

The below saved about 50% of my __lock_acquire() time, not sure it made
a significant difference over all though.

---
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 44c8d0d17170..f8db1ead1c48 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3386,7 +3386,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		if (!class)
 			return 0;
 	}
-	atomic_inc((atomic_t *)&class->ops);
+	/* atomic_inc((atomic_t *)&class->ops); */
 	if (very_verbose(class)) {
 		printk("\nacquire class [%p] %s", class->key, class->name);
 		if (class->name_version > 1)
