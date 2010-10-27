From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: tune fc_exch_em_alloc() to be O(2)
Date: Wed, 27 Oct 2010 14:36:14 -0700
Message-ID: <1288215374.1431.21729.camel@fritz>
References: <AANLkTinpHyH31BsBKTHEg8CpbBYL1x7G3tMVu-1KGpy5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab0J0VgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 17:36:15 -0400
In-Reply-To: <AANLkTinpHyH31BsBKTHEg8CpbBYL1x7G3tMVu-1KGpy5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Fri, 2010-10-22 at 20:20 +0800, Hillf Danton wrote:
> For allocating new exch from pool,  scanning for free slot in exch
> array fluctuates when exch pool is close to exhaustion.
> 
> The fluctuation is smoothed, and the scan looks to be O(2).
> 
Hi Hillf,

   I think this patch is fine, aside from a few minor nits below. I'm
not sure how much this benefits us though. I don't think that it will
hurt us, but I'd like to leave it in the fcoe-next tree a bit to make
sure there aren't any adverse effects. I will fix the two issues I
mention below and check it into fcoe-next, unless there are objections.

Have you done any profiling with this patch to show the improvement?

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_exch.c	2010-10-22 20:02:54.000000000 +0800
> @@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workque
>  struct fc_exch_pool {
>  	u16		 next_index;
>  	u16		 total_exches;
> +
> +	/* two cache of free slot in exch array */
> +	u16		 left;
> +	u16		 right;
> +
>  	spinlock_t	 lock;
>  	struct list_head ex_list;
>  };
> @@ -397,13 +402,26 @@ static inline void fc_exch_ptr_set(struc
>  static void fc_exch_delete(struct fc_exch *ep)
>  {
>  	struct fc_exch_pool *pool;
> +	u16 index;
> 
>  	pool = ep->pool;
>  	spin_lock_bh(&pool->lock);
>  	WARN_ON(pool->total_exches <= 0);
>  	pool->total_exches--;
> -	fc_exch_ptr_set(pool, (ep->xid - ep->em->min_xid) >> fc_cpu_order,
> -			NULL);
> +
> +	/* update cache of free slot */
> +	index = (ep->xid - ep->em->min_xid) >> fc_cpu_order;
> +	if (pool->left == FC_XID_UNKNOWN)
> +		pool->left = index;
> +	else if (pool->right == FC_XID_UNKNOWN)
> +		pool->right = index;
> +	else
> +		/* XXX
> +		 * next = entropy(index, left, right);
> +		 **/

We can remove this comment, right?

> +		pool->next_index = index;
> +
> +	fc_exch_ptr_set(pool, index, NULL);
>  	list_del(&ep->ex_list);
>  	spin_unlock_bh(&pool->lock);
>  	fc_exch_release(ep);	/* drop hold for exch in mp */
> @@ -679,6 +697,19 @@ static struct fc_exch *fc_exch_em_alloc(
>  	pool = per_cpu_ptr(mp->pool, cpu);
>  	spin_lock_bh(&pool->lock);
>  	put_cpu();
> +
> +	/* peek cache of free slot */
> +	if (pool->left != FC_XID_UNKNOWN) {
> +		index = pool->left;
> +		pool->left = FC_XID_UNKNOWN;
> +		goto hit;
> +	}
> +	if (pool->right != FC_XID_UNKNOWN) {
> +		index = pool->right;
> +		pool->right = FC_XID_UNKNOWN;
> +		goto hit;
> +	}
> +
>  	index = pool->next_index;
>  	/* allocate new exch from pool */
>  	while (fc_exch_ptr_get(pool, index)) {
> @@ -687,7 +718,7 @@ static struct fc_exch *fc_exch_em_alloc(
>  			goto err;
>  	}
>  	pool->next_index = index == mp->pool_max_index ? 0 : index + 1;
> -
> +hit:
>  	fc_exch_hold(ep);	/* hold for exch in mp */
>  	spin_lock_init(&ep->ex_lock);
>  	/*
> @@ -2181,6 +2212,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(st
>  		goto free_mempool;
>  	for_each_possible_cpu(cpu) {
>  		pool = per_cpu_ptr(mp->pool, cpu);
> +		pool->left  =

I think we should initialize this without relying on the following line.

> +		pool->right = FC_XID_UNKNOWN;
>  		spin_lock_init(&pool->lock);
>  		INIT_LIST_HEAD(&pool->ex_list);
>  	}
> _______________________________________________
> devel mailing list
> devel@open-fcoe.org
> http://www.open-fcoe.org/mailman/listinfo/devel


