From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] target: Wait RCU grace-period before backend/fabric
 unload
Date: Thu, 30 Jul 2015 06:07:54 -0700
Message-ID: <20150730130754.GB27280@linux.vnet.ibm.com>
References: <1438236923-17889-1-git-send-email-nab@daterainc.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438236923-17889-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2015 at 06:15:23AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch addresses a v4.2-rc1 regression where backend driver
> struct module unload immediately after ->free_device() has done
> an internal call_rcu(), results in IRQ rcu_process_callbacks()
> use-after-free paging OOPsen.
> 
> It adds a explicit synchronize_rcu() in target_backend_unregister()
> to wait a full RCU grace period before releasing target_backend_ops
> memory, and allowing TBO->module exit to proceed.

Good catch, but...

You need rcu_barrier() rather than synchronize_rcu() in this case.
All that synchronize_rcu() does is wait for pre-existing RCU readers,
when what is needed is to wait for all pre-existing RCU callbacks
to be invoked.

So please replace the two synchronize_rcu() calls with rcu_barrier().

							Thanx, Paul

> Also, go ahead and do the same for target_unregister_template()
> to ensure se_deve_entry->rcu_head -> kfree_rcu() grace period has
> passed, before allowing target_core_fabric_ops->owner module exit
> to proceed.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_configfs.c | 10 +++++++++-
>  drivers/target/target_core_hba.c      | 10 +++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index c2e9fea..b4c3ae0 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -457,8 +457,16 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
>  		if (!strcmp(t->tf_ops->name, fo->name)) {
>  			BUG_ON(atomic_read(&t->tf_access_cnt));
>  			list_del(&t->tf_list);
> +			mutex_unlock(&g_tf_lock);
> +			/*
> +			 * Allow any outstanding fabric se_deve_entry->rcu_head
> +			 * grace periods to expire post kfree_rcu(), before allowing
> +			 * fabric driver unload of target_core_fabric_ops->module
> +			 * to proceed.
> +			 */
> +			synchronize_rcu();
>  			kfree(t);
> -			break;
> +			return;
>  		}
>  	}
>  	mutex_unlock(&g_tf_lock);
> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> index 62ea4e8..0fb830b 100644
> --- a/drivers/target/target_core_hba.c
> +++ b/drivers/target/target_core_hba.c
> @@ -84,8 +84,16 @@ void target_backend_unregister(const struct target_backend_ops *ops)
>  	list_for_each_entry(tb, &backend_list, list) {
>  		if (tb->ops == ops) {
>  			list_del(&tb->list);
> +			mutex_unlock(&backend_mutex);
> +			/*
> +			 * Allow any outstanding backend driver ->rcu_head grace
> +			 * period to expire post ->free_device() -> call_rcu(),
> +			 * before allowing backend driver module unload of
> +			 * target_backend_ops->owner to proceed.
> +			 */
> +			synchronize_rcu();
>  			kfree(tb);
> -			break;
> +			return;
>  		}
>  	}
>  	mutex_unlock(&backend_mutex);
> -- 
> 1.9.1
> 
