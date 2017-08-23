From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 13:46:17 +0900
Message-ID: <20170823044617.GA22976@X58A-UD3R>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823034951.GG11771@tardis>
Sender: linux-block-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 23, 2017 at 11:49:51AM +0800, Boqun Feng wrote:
> Hi Byungchul,
> 
> On Wed, Aug 23, 2017 at 09:03:04AM +0900, Byungchul Park wrote:
> > On Tue, Aug 22, 2017 at 09:43:56PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-08-22 at 19:47 +0900, Sergey Senozhatsky wrote:
> > > > ======================================================
> > > > WARNING: possible circular locking dependency detected
> > > > 4.13.0-rc6-next-20170822-dbg-00020-g39758ed8aae0-dirty #1746 Not tainted
> > > > ------------------------------------------------------
> > > > fsck.ext4/148 is trying to acquire lock:
> > > >  (&bdev->bd_mutex){+.+.}, at: [<ffffffff8116e73e>] __blkdev_put+0x33/0x190
> > > > 
> > > >  but now in release context of a crosslock acquired at the following:
> > > >  ((complete)&wait#2){+.+.}, at: [<ffffffff812159e0>] blk_execute_rq+0xbb/0xda
> > > > 
> > > >  which lock already depends on the new lock.
> > > > 
> 
> I felt this message really misleading, because the deadlock is detected
> at the commit time of "((complete)&wait#2)" rather than the acquisition
> time of "(&bdev->bd_mutex)", so I made the following improvement.
> 
> Thoughts?
> 
> Regards,
> Boqun
> 
> ----------------------->8
> From: Boqun Feng <boqun.feng@gmail.com>
> Date: Wed, 23 Aug 2017 10:18:30 +0800
> Subject: [PATCH] lockdep: Improve the readibility of crossrelease related
>  splats
> 
> When a crossrelease related deadlock is detected in a commit, the
> current implemention makes splats like:
> 
> > fsck.ext4/148 is trying to acquire lock:
> >  (&bdev->bd_mutex){+.+.}, at: [<ffffffff8116e73e>] __blkdev_put+0x33/0x190
> >
> >  but now in release context of a crosslock acquired at the following:
> >  ((complete)&wait#2){+.+.}, at: [<ffffffff812159e0>] blk_execute_rq+0xbb/0xda
> >
> >  which lock already depends on the new lock.
> > ...
> 
> However, it could be misleading because the current task has got the
> lock already, and in fact the deadlock is detected when it is doing the
> commit of the crossrelease lock. So make the splats more accurate to
> describe the deadlock case.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  kernel/locking/lockdep.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 66011c9f5df3..642fb5362507 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -1195,17 +1195,23 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
>  	pr_warn("WARNING: possible circular locking dependency detected\n");
>  	print_kernel_ident();
>  	pr_warn("------------------------------------------------------\n");
> -	pr_warn("%s/%d is trying to acquire lock:\n",
> -		curr->comm, task_pid_nr(curr));
> -	print_lock(check_src);
>  
> -	if (cross_lock(check_tgt->instance))
> -		pr_warn("\nbut now in release context of a crosslock acquired at the following:\n");
> -	else
> +	if (cross_lock(check_tgt->instance)) {
> +		pr_warn("%s/%d is committing a crossrelease lock:\n",
> +			curr->comm, task_pid_nr(curr));

I think it would be better to print something in term of acquisition,
since the following print_lock() will print infromation of acquisition.

> +		print_lock(check_tgt);
> +		pr_warn("\n, with the following lock held:\n");

The lock does not have to be held at the commit.

> +		print_lock(check_src);
> +		pr_warn("\non which lock the crossrelease lock already depends.\n\n");
> +	} else {
> +		pr_warn("%s/%d is trying to acquire lock:\n",
> +			curr->comm, task_pid_nr(curr));
> +		print_lock(check_src);
>  		pr_warn("\nbut task is already holding lock:\n");
> +		print_lock(check_tgt);
> +		pr_warn("\nwhich lock already depends on the new lock.\n\n");
> +	}
>  
> -	print_lock(check_tgt);
> -	pr_warn("\nwhich lock already depends on the new lock.\n\n");
>  	pr_warn("\nthe existing dependency chain (in reverse order) is:\n");
>  
>  	print_circular_bug_entry(entry, depth);
> -- 
> 2.14.1
