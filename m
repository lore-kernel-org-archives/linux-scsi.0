From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/3] rcu: Introduce rcu_swap_protected()
Date: Mon, 28 Aug 2017 14:26:49 -0700
Message-ID: <20170828212649.GD11320@linux.vnet.ibm.com>
References: <20170828204615.29455-1-bart.vanassche@wdc.com>
 <20170828204615.29455-2-bart.vanassche@wdc.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751218AbdH1V0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 17:26:39 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7SLP8fW000824
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2017 17:26:38 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cmnpda55k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2017 17:26:38 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 28 Aug 2017 17:26:37 -0400
Content-Disposition: inline
In-Reply-To: <20170828204615.29455-2-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane M Seymour <shane.seymour@hpe.com>

On Mon, Aug 28, 2017 at 01:46:13PM -0700, Bart Van Assche wrote:
> A common pattern in RCU code is to assign a new value to an RCU
> pointer after having read and stored the old value. Introduce a
> macro for this pattern.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane M Seymour <shane.seymour@hpe.com>
> ---
>  include/linux/rcupdate.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index f816fc72b51e..555815ce2e57 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -561,6 +561,26 @@ static inline void rcu_preempt_sleep_check(void) { }
>   */
>  #define rcu_pointer_handoff(p) (p)
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
> +	typeof(ptr) __tmp;						\
> +									\
> +	BUILD_BUG_ON(!__same_type(typeof(rcu_ptr), typeof(*(ptr)) __rcu *)); \
> +	BUILD_BUG_ON(!__same_type(typeof(ptr), typeof(*(rcu_ptr)) *));	\

Hmmm...

What kinds of bugs have these two BUILD_BUG_ON() instances have caught
that would not be caught by the assignments below?

> +	__tmp = rcu_dereference_protected((rcu_ptr), (c));		\
> +	rcu_assign_pointer((rcu_ptr), (ptr));				\
> +	(ptr) = __tmp;							\
> +} while (0)
> +

Could you please put this after rcu_assign_pointer() and before
rcu_access_pointer()?  That way the things that assign to RCU-protected
pointers are together.

							Thanx, Paul

>  /**
>   * rcu_read_lock() - mark the beginning of an RCU read-side critical section
>   *
> -- 
> 2.14.1
> 
