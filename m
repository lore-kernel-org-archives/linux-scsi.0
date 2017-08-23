From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 14:44:16 +0900
Message-ID: <20170823054416.GB22976@X58A-UD3R>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
 <20170823043813.GH11771@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823043813.GH11771@tardis>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 23, 2017 at 12:38:13PM +0800, Boqun Feng wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
> Date: Wed, 23 Aug 2017 12:12:16 +0800
> Subject: [PATCH] lockdep: Print proper scenario if cross deadlock detected at
>  acquisition time
> 
> For a potential deadlock about CROSSRELEASE as follow:
> 
> 	P1		P2
> 	===========	=============
> 	lock(A)
> 	lock(X)
> 			lock(A)
> 			commit(X)
> 
> 	A: normal lock, X: cross lock
> 
> , we could detect it at two places:
> 
> 1. commit time:
> 
> 	We have run P1 first, and have dependency A --> X in graph, and
> 	then we run P2, and find the deadlock.
> 
> 2. acquisition time:
> 
> 	We have run P2 first, and have dependency A --> X, in

X -> A

> 	graph(because another P3 may run previously and is acquiring for

".. another P3 may have run previously and was holding .."
            ^
    Additionally, not only P3 but also P2 like:

	lock(A)
	lock(X)
			lock(X) // I mean it's at _P2_
			lock(A)
			commit(X)

> 	lock X), and then we run P1 and find the deadlock.
>
> In current print_circular_lock_scenario(), for 1) we could print the
> right scenario and note that's a deadlock related to CROSSRELEASE,
> however for 2) we print the scenario as a normal lockdep deadlock.
> 
> It's better to print a proper scenario related to CROSSRELEASE to help
> users find their bugs more easily, so improve this.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  kernel/locking/lockdep.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 642fb5362507..a3709e15f609 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -1156,6 +1156,23 @@ print_circular_lock_scenario(struct held_lock *src,
>  		__print_lock_name(target);
>  		printk(KERN_CONT ");\n");
>  		printk("\n *** DEADLOCK ***\n\n");
> +	} else if (cross_lock(src->instance)) {
> +		printk(" Possible unsafe locking scenario by crosslock:\n\n");
> +		printk("       CPU0                    CPU1\n");
> +		printk("       ----                    ----\n");
> +		printk("  lock(");
> +		__print_lock_name(target);
> +		printk(KERN_CONT ");\n");
> +		printk("  lock(");
> +		__print_lock_name(source);
> +		printk(KERN_CONT ");\n");
> +		printk("                               lock(");
> +		__print_lock_name(parent == source ? target : parent);
> +		printk(KERN_CONT ");\n");
> +		printk("                               unlock(");
> +		__print_lock_name(source);
> +		printk(KERN_CONT ");\n");
> +		printk("\n *** DEADLOCK ***\n\n");
>  	} else {
>  		printk(" Possible unsafe locking scenario:\n\n");
>  		printk("       CPU0                    CPU1\n");

I need time to be sure if it's correct.
