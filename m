From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Tue, 12 May 2015 13:58:23 -0700
Message-ID: <5552696F.8080904@redhat.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbbELU6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 16:58:25 -0400
In-Reply-To: <1431422736-29125-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 05/12/2015 02:25 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch converts se_node_acl->device_list[] table for mappedluns
> to modern RCU hlist_head usage in order to support an arbitrary number
> of node_acl lun mappings.
>
> This includes changes to core_[enable,disable]_device_list_for_node()
> rcu_assign_pointer() and invokes call_rcu() for releasing memory, along
> with a number of RCU read path conversions in target_core_device.c code.
>
> Required for subsequent conversion of transport_lookup_cmd() to lock-less
> RCU read path.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_device.c   | 218 +++++++++++++++++++---------------
>   drivers/target/target_core_internal.h |   1 +
>   drivers/target/target_core_tpg.c      |  23 ++--
>   include/target/target_core_base.h     |   7 +-
>   4 files changed, 137 insertions(+), 112 deletions(-)
>
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 6e58976..1df14ce 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -198,12 +198,9 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
>   	struct se_lun *lun;
>   	struct se_port *port;
>   	struct se_portal_group *tpg = nacl->se_tpg;
> -	u32 i;
> -
> -	spin_lock_irq(&nacl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
>
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
>   		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
>   			continue;
>
> @@ -225,11 +222,11 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
>   			continue;
>
>   		atomic_inc_mb(&deve->pr_ref_count);
> -		spin_unlock_irq(&nacl->device_list_lock);
> +		rcu_read_unlock();
>
>   		return deve;
>   	}
> -	spin_unlock_irq(&nacl->device_list_lock);
> +	rcu_read_unlock();
>
>   	return NULL;
>   }
> @@ -240,18 +237,12 @@ int core_free_device_list_for_node(
>   {
>   	struct se_dev_entry *deve;
>   	struct se_lun *lun;
> -	u32 i;
> -
> -	if (!nacl->device_list)
> -		return 0;
> -
> -	spin_lock_irq(&nacl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
> +	u32 mapped_lun;
>
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
>   		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
>   			continue;
> -
>   		if (!deve->se_lun) {
>   			pr_err("%s device entries device pointer is"
>   				" NULL, but Initiator has access.\n",
> @@ -259,16 +250,14 @@ int core_free_device_list_for_node(
>   			continue;
>   		}
>   		lun = deve->se_lun;
> +		mapped_lun = deve->mapped_lun;
> +		rcu_read_unlock();
>
> -		spin_unlock_irq(&nacl->device_list_lock);
> -		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
> -			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> -		spin_lock_irq(&nacl->device_list_lock);
> +		core_disable_device_list_for_node(lun, NULL, mapped_lun,
> +					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> +		rcu_read_lock();
>   	}
> -	spin_unlock_irq(&nacl->device_list_lock);
> -
> -	array_free(nacl->device_list, TRANSPORT_MAX_LUNS_PER_TPG);
> -	nacl->device_list = NULL;
> +	rcu_read_unlock();
>
>   	return 0;
>   }
> @@ -280,18 +269,44 @@ void core_update_device_list_access(
>   {
>   	struct se_dev_entry *deve;
>
> -	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[mapped_lun];
> -	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> -	} else {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +	spin_lock_irq(&nacl->lun_entry_lock);
> +	deve = target_nacl_find_deve(nacl, mapped_lun);
> +	if (deve) {
> +		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> +			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> +			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> +		} else {
> +			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> +			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +		}
>   	}
> -	spin_unlock_irq(&nacl->device_list_lock);
> +	spin_unlock_irq(&nacl->lun_entry_lock);
> +
> +	synchronize_rcu();
> +}
> +
> +static void target_nacl_deve_callrcu(struct rcu_head *head)
> +{
> +	struct se_dev_entry *deve = container_of(head, struct se_dev_entry,
> +						 rcu_head);
> +	kfree(deve);
>   }
>
> +/*
> + * Called with rcu_read_lock or nacl->device_list_lock held.
> + */
> +struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u32 mapped_lun)
> +{
> +	struct se_dev_entry *deve;
> +
> +	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
> +		if (deve->mapped_lun == mapped_lun)
> +			return deve;
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(target_nacl_find_deve);
> +
>   /*      core_enable_device_list_for_node():
>    *
>    *
> @@ -305,67 +320,61 @@ int core_enable_device_list_for_node(
>   	struct se_portal_group *tpg)
>   {
>   	struct se_port *port = lun->lun_sep;
> -	struct se_dev_entry *deve;
> +	struct se_dev_entry *orig, *new;
>
> -	spin_lock_irq(&nacl->device_list_lock);
> +	new = kzalloc(sizeof(*new), GFP_KERNEL);
> +	if (!new) {
> +		pr_err("Unable to allocate se_dev_entry memory\n");
> +		return -ENOMEM;
> +	}
>
> -	deve = nacl->device_list[mapped_lun];
> +	new->se_node_acl = nacl;
> +	atomic_set(&new->ua_count, 0);
> +	spin_lock_init(&new->ua_lock);
> +	INIT_LIST_HEAD(&new->alua_port_list);
> +	INIT_LIST_HEAD(&new->ua_list);
>
> -	/*
> -	 * Check if the call is handling demo mode -> explicit LUN ACL
> -	 * transition.  This transition must be for the same struct se_lun
> -	 * + mapped_lun that was setup in demo mode..
> -	 */
> -	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> -		if (deve->se_lun_acl != NULL) {
> -			pr_err("struct se_dev_entry->se_lun_acl"
> -			       " already set for demo mode -> explicit"
> -			       " LUN ACL transition\n");
> -			spin_unlock_irq(&nacl->device_list_lock);
> -			return -EINVAL;
> -		}
> -		if (deve->se_lun != lun) {
> -			pr_err("struct se_dev_entry->se_lun does"
> -			       " match passed struct se_lun for demo mode"
> -			       " -> explicit LUN ACL transition\n");
> -			spin_unlock_irq(&nacl->device_list_lock);
> -			return -EINVAL;
> -		}
> -		deve->se_lun_acl = lun_acl;
> +	new->mapped_lun = mapped_lun;
> +	new->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
>
> -		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> -			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> -			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> -		} else {
> -			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> -			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> -		}
> +	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
> +		new->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> +	else
> +		new->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +
> +	new->creation_time = get_jiffies_64();
> +	new->attach_count++;
>
> +	spin_lock_irq(&nacl->device_list_lock);
> +	orig = target_nacl_find_deve(nacl, mapped_lun);
> +	if (orig && orig->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> +		BUG_ON(orig->se_lun_acl != NULL);
> +		BUG_ON(orig->se_lun != lun);
> +
> +		rcu_assign_pointer(new->se_lun, lun);
> +		rcu_assign_pointer(new->se_lun_acl, lun_acl);
> +		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
>   		spin_unlock_irq(&nacl->device_list_lock);
> -		return 0;
> -	}
>
> -	deve->se_lun = lun;
> -	deve->se_lun_acl = lun_acl;
> -	deve->mapped_lun = mapped_lun;
> -	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
> +		spin_lock_bh(&port->sep_alua_lock);
> +		list_del(&orig->alua_port_list);
> +		list_add_tail(&new->alua_port_list, &port->sep_alua_list);
> +		spin_unlock_bh(&port->sep_alua_lock);
>
> -	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> -	} else {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +		call_rcu(&orig->rcu_head, target_nacl_deve_callrcu);
> +		return 0;
>   	}
>
> -	deve->creation_time = get_jiffies_64();
> -	deve->attach_count++;
> +	rcu_assign_pointer(new->se_lun, lun);
> +	rcu_assign_pointer(new->se_lun_acl, lun_acl);
> +	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
>   	spin_unlock_irq(&nacl->device_list_lock);
>
>   	spin_lock_bh(&port->sep_alua_lock);
> -	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
> +	list_add_tail(&new->alua_port_list, &port->sep_alua_list);
>   	spin_unlock_bh(&port->sep_alua_lock);
>
> +	synchronize_rcu();
>   	return 0;
>   }
>
> @@ -382,8 +391,14 @@ int core_disable_device_list_for_node(
>   	struct se_portal_group *tpg)
>   {
>   	struct se_port *port = lun->lun_sep;
> -	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
> +	struct se_dev_entry *orig;
>
> +	spin_lock_irq(&nacl->device_list_lock);
> +	orig = target_nacl_find_deve(nacl, mapped_lun);
> +	if (!orig) {
> +		spin_unlock_irq(&nacl->device_list_lock);
> +		return 0;
> +	}
>   	/*
>   	 * If the MappedLUN entry is being disabled, the entry in
>   	 * port->sep_alua_list must be removed now before clearing the
> @@ -398,27 +413,33 @@ int core_disable_device_list_for_node(
>   	 * MappedLUN *deve will be released below..
>   	 */
>   	spin_lock_bh(&port->sep_alua_lock);
> -	list_del(&deve->alua_port_list);
> +	list_del(&orig->alua_port_list);
>   	spin_unlock_bh(&port->sep_alua_lock);
>   	/*
>   	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
>   	 * PR operation to complete.
>   	 */
> -	while (atomic_read(&deve->pr_ref_count) != 0)
> +	while (atomic_read(&orig->pr_ref_count) != 0)
>   		cpu_relax();
>
> -	spin_lock_irq(&nacl->device_list_lock);
>   	/*
>   	 * Disable struct se_dev_entry LUN ACL mapping
>   	 */
> -	core_scsi3_ua_release_all(deve);
> -	deve->se_lun = NULL;
> -	deve->se_lun_acl = NULL;
> -	deve->lun_flags = 0;
> -	deve->creation_time = 0;
> -	deve->attach_count--;
> +	core_scsi3_ua_release_all(orig);
> +	rcu_assign_pointer(orig->se_lun, NULL);
> +	rcu_assign_pointer(orig->se_lun_acl, NULL);
> +	orig->lun_flags = 0;
> +	orig->creation_time = 0;
> +	orig->attach_count--;
> +	hlist_del_rcu(&orig->link);
>   	spin_unlock_irq(&nacl->device_list_lock);
>
> +	/*
> +	 * Fire off RCU callback to wait for any in process SPEC_I_PT=1
> +	 * or REGISTER_AND_MOVE PR operation to complete.
> +	 */
> +	call_rcu(&orig->rcu_head, target_nacl_deve_callrcu);
> +
>   	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
>   	return 0;
>   }
> @@ -431,26 +452,25 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
>   {
>   	struct se_node_acl *nacl;
>   	struct se_dev_entry *deve;
> -	u32 i;
> +	u32 mapped_lun;
>
>   	spin_lock_irq(&tpg->acl_node_lock);
>   	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
>   		spin_unlock_irq(&tpg->acl_node_lock);
>
> -		spin_lock_irq(&nacl->device_list_lock);
> -		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -			deve = nacl->device_list[i];
> +		rcu_read_lock();
> +		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
>   			if (lun != deve->se_lun)
>   				continue;
> -			spin_unlock_irq(&nacl->device_list_lock);
>
> -			core_disable_device_list_for_node(lun, NULL,
> -				deve->mapped_lun, TRANSPORT_LUNFLAGS_NO_ACCESS,
> -				nacl, tpg);
> +			mapped_lun = deve->mapped_lun;
> +			rcu_read_unlock();
>
> -			spin_lock_irq(&nacl->device_list_lock);
> +			core_disable_device_list_for_node(lun, NULL, mapped_lun,
> +					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> +			rcu_read_lock();
>   		}
> -		spin_unlock_irq(&nacl->device_list_lock);
> +		rcu_read_unlock();
>
>   		spin_lock_irq(&tpg->acl_node_lock);
>   	}
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index d0344ad..9c4bce0 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -12,6 +12,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
>   int	core_free_device_list_for_node(struct se_node_acl *,
>   		struct se_portal_group *);
>   void	core_update_device_list_access(u32, u32, struct se_node_acl *);
> +struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *, u32);
>   int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
>   		u32, u32, struct se_node_acl *, struct se_portal_group *);
>   int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index c0c1f67..dbdd3e3 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -55,32 +55,29 @@ static void core_clear_initiator_node_from_tpg(
>   	struct se_node_acl *nacl,
>   	struct se_portal_group *tpg)
>   {
> -	int i;
>   	struct se_dev_entry *deve;
>   	struct se_lun *lun;
> +	u32 mapped_lun;
>
> -	spin_lock_irq(&nacl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
> -
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
>   		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
>   			continue;
> -
>   		if (!deve->se_lun) {
>   			pr_err("%s device entries device pointer is"
>   				" NULL, but Initiator has access.\n",
>   				tpg->se_tpg_tfo->get_fabric_name());
>   			continue;
>   		}
> -
>   		lun = deve->se_lun;
> -		spin_unlock_irq(&nacl->device_list_lock);
> -		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
> -			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> +		mapped_lun = deve->mapped_lun;
> +		rcu_read_unlock();
>
> -		spin_lock_irq(&nacl->device_list_lock);
> +		core_disable_device_list_for_node(lun, NULL, mapped_lun,
> +					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> +		rcu_read_lock();
>   	}
> -	spin_unlock_irq(&nacl->device_list_lock);
> +	rcu_read_unlock();
>   }
>
>   /*	__core_tpg_get_initiator_node_acl():
> @@ -266,10 +263,12 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
>
>   	INIT_LIST_HEAD(&acl->acl_list);
>   	INIT_LIST_HEAD(&acl->acl_sess_list);
> +	INIT_HLIST_HEAD(&acl->lun_entry_hlist);
>   	kref_init(&acl->acl_kref);
>   	init_completion(&acl->acl_free_comp);
>   	spin_lock_init(&acl->device_list_lock);
>   	spin_lock_init(&acl->nacl_sess_lock);
> +	spin_lock_init(&acl->lun_entry_lock);
>   	atomic_set(&acl->acl_pr_ref_count, 0);
>   	if (tpg->se_tpg_tfo->tpg_get_default_depth)
>   		acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 042a734..6fb38df 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -584,10 +584,12 @@ struct se_node_acl {
>   	char			acl_tag[MAX_ACL_TAG_SIZE];
>   	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
>   	atomic_t		acl_pr_ref_count;
> +	struct hlist_head	lun_entry_hlist;
>   	struct se_dev_entry	**device_list;

Very nice to see all this posted!

Patch 6 is where device_list is finally removed. Suggest squashing 1-6, 
maybe after review, I'm guessing they're not bisectable.

-- Andy

