From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 30 Aug 2017 21:30:07 +0900
Message-ID: <20170830123007.GA6460@jagdpanzerIV.localdomain>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170830052037.GA432@jagdpanzerIV.localdomain>
 <20170830054334.GF3240@X58A-UD3R>
 <20170830061511.GA330@jagdpanzerIV.localdomain>
 <20170830084207.GL32112@worktop.programming.kicks-ass.net>
 <20170830084746.GC660@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170830084746.GC660@worktop.programming.kicks-ass.net>
Sender: linux-next-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Byungchul Park <byungchul.park@lge.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

Hello Peter,

On (08/30/17 10:47), Peter Zijlstra wrote:
[..]
> On Wed, Aug 30, 2017 at 10:42:07AM +0200, Peter Zijlstra wrote:
> > 
> > So the overhead looks to be spread out over all sorts, which makes it
> > harder to find and fix.
> > 
> > stack unwinding is done lots and is fairly expensive, I've not yet
> > checked if crossrelease does too much of that.
> 
> Aah, we do an unconditional stack unwind for every __lock_acquire() now.
> It keeps a trace in the xhlocks[].
> 
> Does the below cure most of that overhead?

thanks.

mostly yes. the kernel is not so dramatically slower now. it's still
seems to be a bit slower, which is expected I suppose, but over all
it's much better

	real	1m35.209s
	user	4m12.467s
	sys	0m49.457s

// approx 10 seconds slower.

	-ss
