From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 09:53:00 +0200
Message-ID: <20170823075300.xhdwevdnvncezlol@hirez.programming.kicks-ass.net>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823000304.GK20323@X58A-UD3R>
Sender: linux-kernel-owner@vger.kernel.org
To: Byungchul Park <byungchul.park@lge.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 23, 2017 at 09:03:04AM +0900, Byungchul Park wrote:
> On Tue, Aug 22, 2017 at 09:43:56PM +0000, Bart Van Assche wrote:

> The report is talking about the following lockup:
> 
> A work in a worker                     A task work on exit to user
> ------------------                     ---------------------------
> mutex_lock(&bdev->bd_mutex)
>                                        mutext_lock(&bdev->bd_mutex)
> blk_execute_rq()
>    wait_for_completion_io_timeout(&A)
>                                        complete(&A)
> 
> Is this impossible?
> 
> To Peterz,
> 
> Anyway I wanted to avoid lockdep reports in the case using a timeout
> interface. Do you think it's still worth reporting the kind of lockup?

Yes, people might not have expected to hit the timeout on this. They
might think timeout means a dead device or something like that.

I'd like to heard from the block folks if this was constructed thus on
purpose though.
