From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/3] rcu: Introduce rcu_swap_protected()
Date: Mon, 28 Aug 2017 14:58:47 -0700
Message-ID: <20170828215847.GE11320@linux.vnet.ibm.com>
References: <20170828204615.29455-1-bart.vanassche@wdc.com>
 <20170828204615.29455-2-bart.vanassche@wdc.com>
 <20170828212649.GD11320@linux.vnet.ibm.com>
 <1503956357.2841.68.camel@wdc.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45259 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750841AbdH1V6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 17:58:37 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7SLrnxZ014821
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2017 17:58:37 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cmndg4mrk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2017 17:58:37 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 28 Aug 2017 17:58:36 -0400
Content-Disposition: inline
In-Reply-To: <1503956357.2841.68.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

On Mon, Aug 28, 2017 at 09:39:18PM +0000, Bart Van Assche wrote:
> On Mon, 2017-08-28 at 14:26 -0700, Paul E. McKenney wrote:
> > On Mon, Aug 28, 2017 at 01:46:13PM -0700, Bart Van Assche wrote:
> > > A common pattern in RCU code is to assign a new value to an RCU
> > > pointer after having read and stored the old value. Introduce a
> > > macro for this pattern.
> > > 
> > > Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Hannes Reinecke <hare@suse.de>
> > > Cc: Johannes Thumshirn <jthumshirn@suse.de>
> > > Cc: Shane M Seymour <shane.seymour@hpe.com>
> > > ---
> > >  include/linux/rcupdate.h | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index f816fc72b51e..555815ce2e57 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -561,6 +561,26 @@ static inline void rcu_preempt_sleep_check(void) { }
> > >   */
> > >  #define rcu_pointer_handoff(p) (p)
> > > 
> > > +/**
> > > + * rcu_swap_protected() - swap an RCU and a regular pointer
> > > + * @rcu_ptr: RCU pointer
> > > + * @ptr: regular pointer
> > > + * @c: the conditions under which the dereference will take place
> > > + *
> > > + * Perform swap(@rcu_ptr, @ptr) where @rcu_ptr is an RCU-annotated pointer and
> > > + * @c is the argument that is passed to the rcu_dereference_protected() call
> > > + * used to read that pointer.
> > > + */
> > > +#define rcu_swap_protected(rcu_ptr, ptr, c) do {			\
> > > +	typeof(ptr) __tmp;						\
> > > +									\
> > > +	BUILD_BUG_ON(!__same_type(typeof(rcu_ptr), typeof(*(ptr)) __rcu *)); \
> > > +	BUILD_BUG_ON(!__same_type(typeof(ptr), typeof(*(rcu_ptr)) *));	\
> > 
> > Hmmm...
> > 
> > What kinds of bugs have these two BUILD_BUG_ON() instances have caught
> > that would not be caught by the assignments below?
> 
> Hello Paul,
> 
> These two BUILD_BUG_ON() statements can be left out. The purpose of these
> statements is to complain as early as possible if the type of rcu_ptr and/or
> ptr is incorrect. As we all know error messages that are triggered by macros
> used inside a macro definition can be hard to read. My hope is that these
> two BUILD_BUG_ON() macros will cause the compiler to report easier to read
> diagnostic messages.
> 
> > > +	__tmp = rcu_dereference_protected((rcu_ptr), (c));		\
> > > +	rcu_assign_pointer((rcu_ptr), (ptr));				\
> > > +	(ptr) = __tmp;							\
> > > +} while (0)
> > > +
> > 
> > Could you please put this after rcu_assign_pointer() and before
> > rcu_access_pointer()?  That way the things that assign to RCU-protected
> > pointers are together.
> 
> Something like the patch below (compile-tested only)?

Looks good!

I suspect that you would like to push this with your changes, so,
assuming 0day test robot and -next are OK with it:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I am not necessarily inalterably opposed to the extra BUILD_BUG_ON()
statements, and in fact I do like improved diagnostics, but those need to
go up via my tree as a separate patch.  That way, any unexpected gotchas
can be handled without risking your rcu_swap_protected() functionality.

							Thanx, Paul

> Thanks,
> 
> Bart.
> 
> 
> [PATCH] rcu: Introduce rcu_swap_protected()
> ---
>  include/linux/rcupdate.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index f816fc72b51e..8e920f0ecb07 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -407,6 +407,22 @@ static inline void rcu_preempt_sleep_check(void) { }
>  	_r_a_p__v;							      \
>  })
>  
> +/**
> + * rcu_swap_protected() - swap an RCU and a regular pointer
> + * @rcu_ptr: RCU pointer
> + * @ptr: regular pointer
> + * @c: the conditions under which the dereference will take place
> + *
> + * Perform swap(@rcu_ptr, @ptr) where @rcu_ptr is an RCU-annotated pointer and
> + * @c is the argument that is passed to the rcu_dereference_protected() call
> + * used to read that pointer.
> + */
> +#define rcu_swap_protected(rcu_ptr, ptr, c) do {			\
> +	typeof(ptr) __tmp = rcu_dereference_protected((rcu_ptr), (c));	\
> +	rcu_assign_pointer((rcu_ptr), (ptr));				\
> +	(ptr) = __tmp;							\
> +} while (0)
> +
>  /**
>   * rcu_access_pointer() - fetch RCU pointer with no dereferencing
>   * @p: The pointer to read
