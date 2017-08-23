From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 11:36:49 +0900
Message-ID: <20170823023649.GD10329@jagdpanzerIV.localdomain>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823000304.GK20323@X58A-UD3R>
Sender: linux-next-owner@vger.kernel.org
To: Byungchul Park <byungchul.park@lge.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On (08/23/17 09:03), Byungchul Park wrote:
[..]

aha, ok

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

I was really confused how this "unlock" may lead to a deadlock

> > >  other info that might help us debug this:
> > >  Possible unsafe locking scenario by crosslock:
> > >        CPU0                    CPU1
> > >        ----                    ----
> > >   lock(&bdev->bd_mutex);
> > >   lock((complete)&wait#2);
> > >                                lock(&bdev->bd_mutex);
> > >                                unlock((complete)&wait#2);


any chance the report can be improved? mention timeout, etc?
// well, if this functionality will stay.


p.s.
Bart Van Assche, thanks for Cc-ing Park Byungchul, I was really
sure I didn't enabled the cross-release, but apparently I was wrong:
 CONFIG_LOCKDEP_CROSSRELEASE=y
 CONFIG_LOCKDEP_COMPLETIONS=y

	-ss
