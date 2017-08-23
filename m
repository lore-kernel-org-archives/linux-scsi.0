From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 12:38:13 +0800
Message-ID: <20170823043813.GH11771@tardis>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823034951.GG11771@tardis>
Sender: linux-next-owner@vger.kernel.org
To: Byungchul Park <byungchul.park@lge.com>
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

While I'm on this one, I think we should also add a case in @check_src
is a cross lock, i.e. we detect cross deadlock at the acquisition time
of the cross lock. How about the following?

Regards,
Boqun

--------------------------------------->8
From: Boqun Feng <boqun.feng@gmail.com>
Date: Wed, 23 Aug 2017 12:12:16 +0800
Subject: [PATCH] lockdep: Print proper scenario if cross deadlock detected at
 acquisition time

For a potential deadlock about CROSSRELEASE as follow:

	P1		P2
	===========	=============
	lock(A)
	lock(X)
			lock(A)
			commit(X)

	A: normal lock, X: cross lock

, we could detect it at two places:

1. commit time:

	We have run P1 first, and have dependency A --> X in graph, and
	then we run P2, and find the deadlock.

2. acquisition time:

	We have run P2 first, and have dependency A --> X, in
	graph(because another P3 may run previously and is acquiring for
	lock X), and then we run P1 and find the deadlock.

In current print_circular_lock_scenario(), for 1) we could print the
right scenario and note that's a deadlock related to CROSSRELEASE,
however for 2) we print the scenario as a normal lockdep deadlock.

It's better to print a proper scenario related to CROSSRELEASE to help
users find their bugs more easily, so improve this.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/locking/lockdep.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 642fb5362507..a3709e15f609 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1156,6 +1156,23 @@ print_circular_lock_scenario(struct held_lock *src,
 		__print_lock_name(target);
 		printk(KERN_CONT ");\n");
 		printk("\n *** DEADLOCK ***\n\n");
+	} else if (cross_lock(src->instance)) {
+		printk(" Possible unsafe locking scenario by crosslock:\n\n");
+		printk("       CPU0                    CPU1\n");
+		printk("       ----                    ----\n");
+		printk("  lock(");
+		__print_lock_name(target);
+		printk(KERN_CONT ");\n");
+		printk("  lock(");
+		__print_lock_name(source);
+		printk(KERN_CONT ");\n");
+		printk("                               lock(");
+		__print_lock_name(parent == source ? target : parent);
+		printk(KERN_CONT ");\n");
+		printk("                               unlock(");
+		__print_lock_name(source);
+		printk(KERN_CONT ");\n");
+		printk("\n *** DEADLOCK ***\n\n");
 	} else {
 		printk(" Possible unsafe locking scenario:\n\n");
 		printk("       CPU0                    CPU1\n");
-- 
2.14.1
