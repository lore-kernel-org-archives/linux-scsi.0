From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] target: Wait RCU grace-period before backend/fabric
 unload
Date: Thu, 30 Jul 2015 21:10:08 -0700
Message-ID: <20150731041008.GM27280@linux.vnet.ibm.com>
References: <1438236923-17889-1-git-send-email-nab@daterainc.com>
 <20150730130754.GB27280@linux.vnet.ibm.com>
 <1438302223.32325.7.camel@haakon3.risingtidesystems.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438302223.32325.7.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2015 at 05:23:43PM -0700, Nicholas A. Bellinger wrote:
> On Thu, 2015-07-30 at 06:07 -0700, Paul E. McKenney wrote:
> > On Thu, Jul 30, 2015 at 06:15:23AM +0000, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > This patch addresses a v4.2-rc1 regression where backend driver
> > > struct module unload immediately after ->free_device() has done
> > > an internal call_rcu(), results in IRQ rcu_process_callbacks()
> > > use-after-free paging OOPsen.
> > > 
> > > It adds a explicit synchronize_rcu() in target_backend_unregister()
> > > to wait a full RCU grace period before releasing target_backend_ops
> > > memory, and allowing TBO->module exit to proceed.
> > 
> > Good catch, but...
> > 
> > You need rcu_barrier() rather than synchronize_rcu() in this case.
> > All that synchronize_rcu() does is wait for pre-existing RCU readers,
> > when what is needed is to wait for all pre-existing RCU callbacks
> > to be invoked.
> > 
> 
> Ah, was getting confused by rcu_barrier_tasks() being specific to
> CONFIG_TASKS_RCU in update.c code, and missing rcu_barrier() in
> tree_plugin.h.
> 
> Should have taken a look at Documentation/RCU/rcubarrier.txt..
> 
> > So please replace the two synchronize_rcu() calls with rcu_barrier().
> > 
> 
> <nod>, below is the updated version.
> 
> Thanks for the review!

Much better!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> --nab
> 
> >From 9721910116f9883c7afded613ec88dc2de12339a Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Wed, 29 Jul 2015 22:27:13 -0700
> Subject: [PATCH] target: Perform RCU callback barrier before backend/fabric
>  unload
> 
> This patch addresses a v4.2-rc1 regression where backend driver
> module unload happening immediately after TBO->free_device()
> does internal call_rcu(), will currently result in IRQ context
> rcu_process_callbacks() use-after-free paging OOPsen.
> 
> It adds the missing rcu_barrier() in target_backend_unregister()
> to perform an explicit RCU barrier waiting for all RCU callbacks
> to complete before releasing target_backend_ops memory, and
> allowing TBO->module exit to proceed.
> 
> Also, do the same for fabric drivers in target_unregister_template()
> to ensure se_deve_entry->rcu_head -> kfree_rcu() callbacks have
> completed, before allowing target_core_fabric_ops->owner module
> exit to proceed.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_configfs.c |  9 ++++++++-
>  drivers/target/target_core_hba.c      | 10 +++++++++-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index c2e9fea..860e840 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -457,8 +457,15 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
>  		if (!strcmp(t->tf_ops->name, fo->name)) {
>  			BUG_ON(atomic_read(&t->tf_access_cnt));
>  			list_del(&t->tf_list);
> +			mutex_unlock(&g_tf_lock);
> +			/*
> +			 * Wait for any outstanding fabric se_deve_entry->rcu_head
> +			 * callbacks to complete post kfree_rcu(), before allowing
> +			 * fabric driver unload of TFO->module to proceed.
> +			 */
> +			rcu_barrier();
>  			kfree(t);
> -			break;
> +			return;
>  		}
>  	}
>  	mutex_unlock(&g_tf_lock);
> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> index 62ea4e8..be9cefc 100644
> --- a/drivers/target/target_core_hba.c
> +++ b/drivers/target/target_core_hba.c
> @@ -84,8 +84,16 @@ void target_backend_unregister(const struct target_backend_ops *ops)
>  	list_for_each_entry(tb, &backend_list, list) {
>  		if (tb->ops == ops) {
>  			list_del(&tb->list);
> +			mutex_unlock(&backend_mutex);
> +			/*
> +			 * Wait for any outstanding backend driver ->rcu_head
> +			 * callbacks to complete post TBO->free_device() ->
> +			 * call_rcu(), before allowing backend driver module
> +			 * unload of target_backend_ops->owner to proceed.
> +			 */
> +			rcu_barrier();
>  			kfree(tb);
> -			break;
> +			return;
>  		}
>  	}
>  	mutex_unlock(&backend_mutex);
> -- 
> 1.9.1
> 
