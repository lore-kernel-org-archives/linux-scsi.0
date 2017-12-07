From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the scsi-mkp tree
Date: Thu, 7 Dec 2017 09:40:38 -0800
Message-ID: <20171207174038.GQ7829@linux.vnet.ibm.com>
References: <20171207145728.57cd9ac4@canb.auug.org.au>
 <1512619169.3298.3.camel@wdc.com>
 <20171207152521.0036b131@canb.auug.org.au>
 <20171207044222.GK7829@linux.vnet.ibm.com>
 <1512667802.2624.20.camel@wdc.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512667802.2624.20.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 07, 2017 at 05:30:03PM +0000, Bart Van Assche wrote:
> On Wed, 2017-12-06 at 20:42 -0800, Paul E. McKenney wrote:
> > On Thu, Dec 07, 2017 at 03:25:21PM +1100, Stephen Rothwell wrote:
> > > On Thu, 7 Dec 2017 03:59:30 +0000 Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

[ . . . ]

> > commit cde4691a3a4591e7355295dd62610e3262159002
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Wed Dec 6 20:39:38 2017 -0800
> > 
> >     rcu: Export init_rcu_head() and destroy_rcu_head() to GPL modules
> >     
> >     Use of init_rcu_head() and destroy_rcu_head() from modules results in
> >     the following build-time error:
> >     
> >     	ERROR: "init_rcu_head" [drivers/scsi/scsi_mod.ko] undefined!
> >     	ERROR: "destroy_rcu_head" [drivers/scsi/scsi_mod.ko] undefined!
> >     
> >     This commit therefore adds EXPORT_SYMBOL_GPL() for each to allow them
> >     to be used by GPL-licensed kernel modules.
> >     
> >     Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> >     Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index 8d591d8411fe..4c4d26e9a67b 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -422,11 +422,13 @@ void init_rcu_head(struct rcu_head *head)
> >  {
> >  	debug_object_init(head, &rcuhead_debug_descr);
> >  }
> > +EXPORT_SYMBOL_GPL(init_rcu_head);
> >  
> >  void destroy_rcu_head(struct rcu_head *head)
> >  {
> >  	debug_object_free(head, &rcuhead_debug_descr);
> >  }
> > +EXPORT_SYMBOL_GPL(destroy_rcu_head);
> >  
> >  static bool rcuhead_is_static_object(void *addr)
> >  {
> 
> (+linux-scsi)
> 
> Hello Paul,
> 
> How about changing the commit message into "... fixes a build failure with
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y"? Otherwise the above patch looks fine to me
> and fixes the reported build failure on my setup.

I have updated it as shown below.

> However, what's not clear to me is through which tree this patch should be
> sent to Linus? Should the above patch be sent as a v4.15-rc fix or should
> Martin perhaps queue it in his tree for v4.16-rc1?

I have to defer to you guys on that one.  Left to myself, I will just
push it into the next merge window (as opposed to using my normal process,
which at this point would get it into the one following).

So please let me know how you would like to proceed.

							Thanx, Paul

------------------------------------------------------------------------

commit 193dffdf4354f14b4f3369a85128817e5ba74e58
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Wed Dec 6 20:39:38 2017 -0800

    rcu: Export init_rcu_head() and destroy_rcu_head() to GPL modules
    
    Use of init_rcu_head() and destroy_rcu_head() from modules results in
    the following build-time error with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y:
    
    	ERROR: "init_rcu_head" [drivers/scsi/scsi_mod.ko] undefined!
    	ERROR: "destroy_rcu_head" [drivers/scsi/scsi_mod.ko] undefined!
    
    This commit therefore adds EXPORT_SYMBOL_GPL() for each to allow them
    to be used by GPL-licensed kernel modules.
    
    Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 8d591d8411fe..4c4d26e9a67b 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -422,11 +422,13 @@ void init_rcu_head(struct rcu_head *head)
 {
 	debug_object_init(head, &rcuhead_debug_descr);
 }
+EXPORT_SYMBOL_GPL(init_rcu_head);
 
 void destroy_rcu_head(struct rcu_head *head)
 {
 	debug_object_free(head, &rcuhead_debug_descr);
 }
+EXPORT_SYMBOL_GPL(destroy_rcu_head);
 
 static bool rcuhead_is_static_object(void *addr)
 {
