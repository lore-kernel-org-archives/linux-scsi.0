From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 19/32] target: Convert to rbtree for se_dev_entry in
 se_node_acl
Date: Mon, 16 Dec 2013 13:40:41 -0800
Message-ID: <1387230041.20247.237.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-20-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-20-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Instead of an array, use a rbtree. Less memory use on average, and
> can allow >255 entries. We go from O(1) to O(log n) on lookups. If this
> shows up on profiling (it won't) then transition to other kernel lookup
> methods is straightforward from here.
> 

Ugh.

There is no reason to be using rbtrees in a performance critical path
here.

The number of pointer lookups is what ends up hurting the most vs. a
flat array, so given that 256 LUNs per endpoint is currently not an
issue, and there is no hard limit on the number of endpoints with
virtual addressing, I don't see the benefit of this patch.

NAK.

--nab

> Change core_disable_device_list_for_node to be called with device_list_lock
> held, and tweaked params a little.
> 
> TRANSPORT_LUNFLAGS_INITIATOR_ACCESS no longer needed, presence in the
> rbtree is equivalent to this being set.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c          |  213 ++++++++++++++-----------
>  drivers/target/target_core_fabric_configfs.c |   24 ++--
>  drivers/target/target_core_internal.h        |   15 +-
>  drivers/target/target_core_pr.c              |   25 +++-
>  drivers/target/target_core_spc.c             |   11 +-
>  drivers/target/target_core_stat.c            |   72 +++++-----
>  drivers/target/target_core_tpg.c             |   53 +------
>  drivers/target/target_core_ua.c              |   18 ++-
>  include/target/target_core_base.h            |    8 +-
>  9 files changed, 222 insertions(+), 217 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index af12456..a18724b 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -54,6 +54,51 @@ static struct se_hba *lun0_hba;
>  /* not static, needed by tpg.c */
>  struct se_device *g_lun0_dev;
>  
> +bool transport_insert_deve(struct se_node_acl *nacl, struct se_dev_entry *deve)
> +{
> +	struct rb_root *root = &nacl->rb_device_list;
> +	struct rb_node **new = &(root->rb_node), *parent = NULL;
> +
> +	/* Figure out where to put new node */
> +	while (*new) {
> +		struct se_dev_entry *this = rb_entry(*new, struct se_dev_entry, rb_node);
> +
> +		parent = *new;
> +		if (deve->mapped_lun < this->mapped_lun)
> +			new = &((*new)->rb_left);
> +		else if (deve->mapped_lun > this->mapped_lun)
> +			new = &((*new)->rb_right);
> +		else
> +			return false;
> +	}
> +
> +	/* Add new node and rebalance tree. */
> +	rb_link_node(&deve->rb_node, parent, new);
> +	rb_insert_color(&deve->rb_node, root);
> +
> +	return true;
> +}
> +
> +
> +struct se_dev_entry *transport_search_deve(struct se_node_acl *nacl, u32 mapped_lun)
> +{
> +	struct rb_root *root = &nacl->rb_device_list;
> +	struct rb_node *node = root->rb_node;
> +
> +	while (node) {
> +		struct se_dev_entry *deve = rb_entry(node, struct se_dev_entry, rb_node);
> +
> +		if (mapped_lun < deve->mapped_lun)
> +			node = node->rb_left;
> +		else if (mapped_lun > deve->mapped_lun)
> +			node = node->rb_right;
> +		else
> +			return deve;
> +	}
> +	return NULL;
> +}
> +
> +
>  sense_reason_t
>  transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  {
> @@ -66,8 +111,8 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  		return TCM_NON_EXISTENT_LUN;
>  
>  	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
> -	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
> -	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> +	se_cmd->se_deve = transport_search_deve(se_sess->se_node_acl, unpacked_lun);
> +	if (se_cmd->se_deve) {
>  		struct se_dev_entry *deve = se_cmd->se_deve;
>  
>  		deve->total_cmds++;
> @@ -153,10 +198,10 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  		return -ENODEV;
>  
>  	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
> -	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
> -	deve = se_cmd->se_deve;
> +	se_cmd->se_deve = transport_search_deve(se_sess->se_node_acl, unpacked_lun);
> +	if (se_cmd->se_deve) {
> +		deve = se_cmd->se_deve;
>  
> -	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
>  		se_tmr->tmr_lun = deve->se_lun;
>  		se_cmd->se_lun = deve->se_lun;
>  		se_lun = deve->se_lun;
> @@ -187,25 +232,22 @@ EXPORT_SYMBOL(transport_lookup_tmr_lun);
>  
>  /*
>   * This function is called from core_scsi3_emulate_pro_register_and_move()
> - * and core_scsi3_decode_spec_i_port(), and will increment &deve->pr_ref_count
> + * and core_scsi3_decode_spec_i_port(), and will increment deve->refcount
>   * when a matching rtpi is found.
>   */
>  struct se_dev_entry *core_get_se_deve_from_rtpi(
>  	struct se_node_acl *nacl,
>  	u16 rtpi)
>  {
> -	struct se_dev_entry *deve;
>  	struct se_lun *lun;
>  	struct se_port *port;
>  	struct se_portal_group *tpg = nacl->se_tpg;
> -	u32 i;
> +	struct rb_node *node;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
> -
> -		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
> -			continue;
> +	for (node = rb_first(&nacl->rb_device_list); node; node = rb_next(node))
> +	{
> +		struct se_dev_entry *deve = rb_entry(node, struct se_dev_entry, rb_node);
>  
>  		lun = deve->se_lun;
>  		if (!lun) {
> @@ -234,43 +276,24 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
>  	return NULL;
>  }
>  
> -int core_free_device_list_for_node(
> +void core_free_device_list_for_node(
>  	struct se_node_acl *nacl,
>  	struct se_portal_group *tpg)
>  {
> -	struct se_dev_entry *deve;
> -	struct se_lun *lun;
> -	u32 i;
> -
> -	if (!nacl->device_list)
> -		return 0;
> +	struct se_dev_entry *deve, *_tmp;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
> -
> -		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
> -			continue;
> -
> -		if (!deve->se_lun) {
> +	rbtree_postorder_for_each_entry_safe(deve, _tmp, &nacl->rb_device_list, rb_node) {
> +		if (deve->se_lun) {
> +			core_disable_device_list_for_node(deve->se_lun, deve,
> +				TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> +		} else {
>  			pr_err("%s device entries device pointer is"
>  				" NULL, but Initiator has access.\n",
>  				tpg->se_tpg_tfo->get_fabric_name());
> -			continue;
>  		}
> -		lun = deve->se_lun;
> -
> -		spin_unlock_irq(&nacl->device_list_lock);
> -		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
> -			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> -		spin_lock_irq(&nacl->device_list_lock);
>  	}
>  	spin_unlock_irq(&nacl->device_list_lock);
> -
> -	array_free(nacl->device_list, TRANSPORT_MAX_LUNS_PER_TPG);
> -	nacl->device_list = NULL;
> -
> -	return 0;
>  }
>  
>  void core_update_device_list_access(
> @@ -281,13 +304,15 @@ void core_update_device_list_access(
>  	struct se_dev_entry *deve;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[mapped_lun];
> -	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> -	} else {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +	deve = transport_search_deve(nacl, mapped_lun);
> +	if (deve) {
> +		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> +			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> +			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> +		} else {
> +			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> +			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +		}
>  	}
>  	spin_unlock_irq(&nacl->device_list_lock);
>  }
> @@ -305,18 +330,30 @@ int core_enable_device_list_for_node(
>  	struct se_portal_group *tpg)
>  {
>  	struct se_port *port = lun->lun_sep;
> -	struct se_dev_entry *deve;
> +	struct se_dev_entry *deve, *new_deve;
>  
> -	spin_lock_irq(&nacl->device_list_lock);
> +	new_deve = kzalloc(sizeof(*deve), GFP_KERNEL);
> +	if (!new_deve)
> +		return -ENOMEM;
>  
> -	deve = nacl->device_list[mapped_lun];
> +	atomic_set(&new_deve->ua_count, 0);
> +	kref_init(&new_deve->refcount);
> +	spin_lock_init(&new_deve->ua_lock);
> +	INIT_LIST_HEAD(&new_deve->alua_port_node);
> +	INIT_LIST_HEAD(&new_deve->ua_list);
> +	new_deve->se_lun = lun;
> +	new_deve->se_lun_acl = lun_acl;
> +	new_deve->mapped_lun = mapped_lun;
>  
> +	spin_lock_irq(&nacl->device_list_lock);
>  	/*
>  	 * Check if the call is handling demo mode -> explicit LUN ACL
>  	 * transition.  This transition must be for the same struct se_lun
>  	 * + mapped_lun that was setup in demo mode..
>  	 */
> -	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> +	deve = transport_search_deve(nacl, mapped_lun);
> +	if (deve) {
> +		kfree(new_deve);
>  		if (deve->se_lun_acl != NULL) {
>  			pr_err("struct se_dev_entry->se_lun_acl"
>  			       " already set for demo mode -> explicit"
> @@ -345,25 +382,24 @@ int core_enable_device_list_for_node(
>  		return 0;
>  	}
>  
> -	deve->se_lun = lun;
> -	deve->se_lun_acl = lun_acl;
> -	deve->mapped_lun = mapped_lun;
> -	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
> -
> -	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> -	} else {
> -		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
> -		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +	if (!transport_insert_deve(nacl, new_deve)) {
> +		pr_err("Could not insert new deve for lun %d\n", mapped_lun);
> +		kfree(new_deve);
> +		spin_unlock_irq(&nacl->device_list_lock);
> +		return -EINVAL;
>  	}
>  
> -	deve->creation_time = get_jiffies_64();
> -	deve->attach_count++;
> +	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
> +		new_deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
> +	else
> +		new_deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
> +
> +	new_deve->creation_time = get_jiffies_64();
> +	new_deve->attach_count++;
>  	spin_unlock_irq(&nacl->device_list_lock);
>  
>  	spin_lock_bh(&port->sep_alua_lock);
> -	list_add_tail(&deve->alua_port_node, &port->sep_alua_list);
> +	list_add_tail(&new_deve->alua_port_node, &port->sep_alua_list);
>  	spin_unlock_bh(&port->sep_alua_lock);
>  
>  	return 0;
> @@ -371,18 +407,16 @@ int core_enable_device_list_for_node(
>  
>  /*      core_disable_device_list_for_node():
>   *
> - *
> + *	CALLED WITH device_list_lock HELD
>   */
> -int core_disable_device_list_for_node(
> +void core_disable_device_list_for_node(
>  	struct se_lun *lun,
> -	struct se_lun_acl *lun_acl,
> -	u32 mapped_lun,
> +	struct se_dev_entry *deve,
>  	u32 lun_access,
>  	struct se_node_acl *nacl,
>  	struct se_portal_group *tpg)
>  {
>  	struct se_port *port = lun->lun_sep;
> -	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
>  
>  	/*
>  	 * If the MappedLUN entry is being disabled, the entry in
> @@ -397,11 +431,10 @@ int core_disable_device_list_for_node(
>  	 * NodeACL context specific PR metadata for demo-mode
>  	 * MappedLUN *deve will be released below..
>  	 */
> -	spin_lock_bh(&port->sep_alua_lock);
> +	spin_lock(&port->sep_alua_lock);
>  	list_del(&deve->alua_port_node);
> -	spin_unlock_bh(&port->sep_alua_lock);
> +	spin_unlock(&port->sep_alua_lock);
>  
> -	spin_lock_irq(&nacl->device_list_lock);
>  	/*
>  	 * Disable struct se_dev_entry LUN ACL mapping
>  	 */
> @@ -411,13 +444,12 @@ int core_disable_device_list_for_node(
>  	deve->lun_flags = 0;
>  	deve->creation_time = 0;
>  	deve->attach_count--;
> -	spin_unlock_irq(&nacl->device_list_lock);
>  
>  	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
>  
> -	put_deve(deve);
> +	rb_erase(&deve->rb_node, &nacl->rb_device_list);
>  
> -	return 0;
> +	put_deve(deve);
>  }
>  
>  /*      core_clear_lun_from_tpg():
> @@ -427,25 +459,17 @@ int core_disable_device_list_for_node(
>  void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
>  {
>  	struct se_node_acl *nacl;
> -	struct se_dev_entry *deve;
> -	u32 i;
> +	struct se_dev_entry *deve, *_tmp;
>  
>  	spin_lock_irq(&tpg->acl_node_lock);
>  	list_for_each_entry(nacl, &tpg->acl_node_list, acl_node) {
>  		spin_unlock_irq(&tpg->acl_node_lock);
>  
>  		spin_lock_irq(&nacl->device_list_lock);
> -		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -			deve = nacl->device_list[i];
> -			if (lun != deve->se_lun)
> -				continue;
> -			spin_unlock_irq(&nacl->device_list_lock);
> -
> -			core_disable_device_list_for_node(lun, NULL,
> -				deve->mapped_lun, TRANSPORT_LUNFLAGS_NO_ACCESS,
> -				nacl, tpg);
> -
> -			spin_lock_irq(&nacl->device_list_lock);
> +		rbtree_postorder_for_each_entry_safe(deve, _tmp, &nacl->rb_device_list, rb_node) {
> +			if (lun == deve->se_lun)
> +				core_disable_device_list_for_node(lun, deve,
> +					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
>  		}
>  		spin_unlock_irq(&nacl->device_list_lock);
>  
> @@ -1301,16 +1325,17 @@ int core_dev_add_initiator_node_lun_acl(
>   *
>   *
>   */
> -int core_dev_del_initiator_node_lun_acl(
> +void core_dev_del_initiator_node_lun_acl(
>  	struct se_portal_group *tpg,
>  	struct se_lun *lun,
> -	struct se_lun_acl *lacl)
> +	struct se_lun_acl *lacl,
> +	struct se_dev_entry *deve)
>  {
>  	struct se_node_acl *nacl;
>  
>  	nacl = lacl->se_lun_nacl;
>  	if (!nacl)
> -		return -EINVAL;
> +		return;
>  
>  	spin_lock(&lun->lun_acl_lock);
>  	list_del(&lacl->lacl_list);
> @@ -1318,8 +1343,10 @@ int core_dev_del_initiator_node_lun_acl(
>  	smp_mb__after_atomic_dec();
>  	spin_unlock(&lun->lun_acl_lock);
>  
> -	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
> +	spin_lock_irq(&nacl->device_list_lock);
> +	core_disable_device_list_for_node(lun, deve,
>  		TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> +	spin_unlock_irq(&nacl->device_list_lock);
>  
>  	lacl->se_lun = NULL;
>  
> @@ -1328,8 +1355,6 @@ int core_dev_del_initiator_node_lun_acl(
>  		tpg->se_tpg_tfo->get_fabric_name(),
>  		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
>  		lacl->initiatorname, lacl->mapped_lun);
> -
> -	return 0;
>  }
>  
>  void core_dev_free_initiator_node_lun_acl(
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 64cc4dc..eaaed43 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -112,8 +112,8 @@ static int target_fabric_mappedlun_link(
>  	 * tpg_1/attrib/demo_mode_write_protect=1
>  	 */
>  	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
> -	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
> -	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
> +	deve = transport_search_deve(lacl->se_lun_nacl, lacl->mapped_lun);
> +	if (deve)
>  		lun_access = deve->lun_flags;
>  	else
>  		lun_access =
> @@ -140,19 +140,20 @@ static int target_fabric_mappedlun_unlink(
>  	struct se_lun *lun;
>  	struct se_lun_acl *lacl = container_of(to_config_group(lun_acl_ci),
>  			struct se_lun_acl, se_lun_group);
> -	struct se_node_acl *nacl = lacl->se_lun_nacl;
> -	struct se_dev_entry *deve = nacl->device_list[lacl->mapped_lun];
> +	struct se_dev_entry *deve;
>  	struct se_portal_group *se_tpg;
> +
>  	/*
>  	 * Determine if the underlying MappedLUN has already been released..
>  	 */
> -	if (!deve->se_lun)
> +	deve = transport_search_deve(lacl->se_lun_nacl, lacl->mapped_lun);
> +	if (!(deve && deve->se_lun))
>  		return 0;
>  
>  	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
>  	se_tpg = lun->lun_sep->sep_tpg;
>  
> -	core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl);
> +	core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl, deve);
>  	return 0;
>  }
>  
> @@ -169,13 +170,14 @@ static ssize_t target_fabric_mappedlun_show_write_protect(
>  {
>  	struct se_node_acl *se_nacl = lacl->se_lun_nacl;
>  	struct se_dev_entry *deve;
> -	ssize_t len;
> +	ssize_t len = 0;
>  
>  	spin_lock_irq(&se_nacl->device_list_lock);
> -	deve = se_nacl->device_list[lacl->mapped_lun];
> -	len = sprintf(page, "%d\n",
> -			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
> -			1 : 0);
> +	deve = transport_search_deve(se_nacl, lacl->mapped_lun);
> +	if (deve)
> +		len = sprintf(page, "%d\n",
> +			      (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
> +			      1 : 0);
>  	spin_unlock_irq(&se_nacl->device_list_lock);
>  
>  	return len;
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 5d1e4ec..3803dd8 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -5,14 +5,16 @@
>  extern struct t10_alua_lu_gp *default_lu_gp;
>  
>  /* target_core_device.c */
> +bool transport_insert_deve(struct se_node_acl *nacl, struct se_dev_entry *deve);
> +struct se_dev_entry *transport_search_deve(struct se_node_acl *nacl, u32 mapped_lun);
>  struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
> -int	core_free_device_list_for_node(struct se_node_acl *,
> +void	core_free_device_list_for_node(struct se_node_acl *,
>  		struct se_portal_group *);
>  void	core_update_device_list_access(u32, u32, struct se_node_acl *);
>  int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
>  		u32, u32, struct se_node_acl *, struct se_portal_group *);
> -int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
> -		u32, u32, struct se_node_acl *, struct se_portal_group *);
> +void	core_disable_device_list_for_node(struct se_lun *, struct se_dev_entry *,
> +		u32, struct se_node_acl *, struct se_portal_group *);
>  void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
>  int	core_dev_export(struct se_device *, struct se_portal_group *,
>  		struct se_lun *);
> @@ -50,8 +52,8 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *
>  		struct se_node_acl *, u32, int *);
>  int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
>  		struct se_lun_acl *, u32, u32);
> -int	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
> -		struct se_lun *, struct se_lun_acl *);
> +void	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
> +					    struct se_lun *, struct se_lun_acl *, struct se_dev_entry*);
>  void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
>  		struct se_lun_acl *lacl);
>  int	core_dev_setup_virtual_lun0(void);
> @@ -98,8 +100,7 @@ static inline void release_deve(struct kref *kref)
>  	struct se_dev_entry *deve = container_of(kref,
>  				struct se_dev_entry, refcount);
>  
> -	/* doesn't really get freed because device_list is a static array */
> -	deve->lun_flags &= ~TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
> +	kfree(deve);
>  }
>  
>  #define get_deve(x) kref_get(&x->refcount)
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 17a4c3b..0da6696 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -322,7 +322,11 @@ static int core_scsi3_pr_seq_non_holder(
>  	int legacy = 0; /* Act like a legacy device and return
>  			 * RESERVATION CONFLICT on some CDBs */
>  
> -	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
> +	se_deve = transport_search_deve(se_sess->se_node_acl, cmd->orig_fe_lun);
> +	/* no deve means no conflict */
> +	if (!se_deve)
> +		return 0;
> +
>  	/*
>  	 * Determine if the registration should be ignored due to
>  	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
> @@ -950,7 +954,11 @@ int core_scsi3_check_aptpl_registration(
>  	struct se_lun_acl *lun_acl)
>  {
>  	struct se_node_acl *nacl = lun_acl->se_lun_nacl;
> -	struct se_dev_entry *deve = nacl->device_list[lun_acl->mapped_lun];
> +	struct se_dev_entry *deve;
> +
> +	deve = transport_search_deve(nacl, lun_acl->mapped_lun);
> +	if (!deve)
> +		return 0;
>  
>  	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>  		return 0;
> @@ -1424,7 +1432,10 @@ core_scsi3_decode_spec_i_port(
>  
>  	memset(dest_iport, 0, 64);
>  
> -	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
> +	local_se_deve = transport_search_deve(se_sess->se_node_acl, cmd->orig_fe_lun);
> +	if (!local_se_deve)
> +		return 0;
> +
>  	/*
>  	 * Allocate a struct pr_transport_id_holder and setup the
>  	 * local_node_acl and local_se_deve pointers and add to
> @@ -1988,7 +1999,6 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
>  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  	}
>  	se_tpg = se_sess->se_tpg;
> -	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
>  
>  	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
>  		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
> @@ -2013,6 +2023,13 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
>  			return 0;
>  
>  		if (!spec_i_pt) {
> +
> +			se_deve = transport_search_deve(se_sess->se_node_acl, cmd->orig_fe_lun);
> +			if (!se_deve) {
> +				pr_err("se_deve not found\n");
> +				return TCM_INVALID_PARAMETER_LIST;
> +			}
> +
>  			/*
>  			 * Perform the Service Action REGISTER on the Initiator
>  			 * Port Endpoint that the PRO was received from on the
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 8f52974..0b678fc 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -1124,10 +1124,10 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
>  
>  sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
>  {
> -	struct se_dev_entry *deve;
>  	struct se_session *sess = cmd->se_sess;
>  	unsigned char *buf;
> -	u32 lun_count = 0, offset = 8, i;
> +	u32 lun_count = 0, offset = 8;
> +	struct rb_node *node;
>  
>  	if (cmd->data_length < 16) {
>  		pr_warn("REPORT LUNS allocation length %u too small\n",
> @@ -1151,10 +1151,9 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
>  	}
>  
>  	spin_lock_irq(&sess->se_node_acl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = sess->se_node_acl->device_list[i];
> -		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
> -			continue;
> +	for (node = rb_first(&sess->se_node_acl->rb_device_list); node; node = rb_next(node)) {
> +		struct se_dev_entry *deve = container_of(node, struct se_dev_entry, rb_node);
> +
>  		/*
>  		 * We determine the correct LUN LIST LENGTH even once we
>  		 * have reached the initial allocation length.
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index 0353899..ef03d51 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -1086,8 +1086,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_inst(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1111,8 +1111,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1135,8 +1135,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_port(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1158,8 +1158,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_indx(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1180,8 +1180,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev_or_port(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1202,8 +1202,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_intr_name(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1224,8 +1224,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_map_indx(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1246,8 +1246,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_att_count(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1268,8 +1268,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_num_cmds(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1290,8 +1290,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_read_mbytes(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1312,8 +1312,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_write_mbytes(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1334,8 +1334,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_hs_num_cmds(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1356,8 +1356,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_creation_time(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1379,8 +1379,8 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_row_status(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1452,8 +1452,8 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_inst(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1477,8 +1477,8 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_dev(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1501,8 +1501,8 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> @@ -1550,8 +1550,8 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port_auth_indx(
>  	ssize_t ret;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[lacl->mapped_lun];
> -	if (!deve->se_lun || !deve->se_lun_acl) {
> +	deve = transport_search_deve(nacl, lacl->mapped_lun);
> +	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -ENODEV;
>  	}
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index e6f9dfb..3efa7c1 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -54,17 +54,11 @@ static void core_clear_initiator_node_from_tpg(
>  	struct se_node_acl *nacl,
>  	struct se_portal_group *tpg)
>  {
> -	int i;
> -	struct se_dev_entry *deve;
>  	struct se_lun *lun;
> +	struct se_dev_entry *deve, *_tmp;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
> -
> -		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
> -			continue;
> -
> +	rbtree_postorder_for_each_entry_safe(deve, _tmp, &nacl->rb_device_list, rb_node) {
>  		if (!deve->se_lun) {
>  			pr_err("%s device entries device pointer is"
>  				" NULL, but Initiator has access.\n",
> @@ -73,11 +67,8 @@ static void core_clear_initiator_node_from_tpg(
>  		}
>  
>  		lun = deve->se_lun;
> -		spin_unlock_irq(&nacl->device_list_lock);
> -		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
> +		core_disable_device_list_for_node(lun, deve,
>  			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
> -
> -		spin_lock_irq(&nacl->device_list_lock);
>  	}
>  	spin_unlock_irq(&nacl->device_list_lock);
>  }
> @@ -217,34 +208,6 @@ static void *array_zalloc(int n, size_t size, gfp_t flags)
>  	return a;
>  }
>  
> -/*      core_create_device_list_for_node():
> - *
> - *
> - */
> -static int core_create_device_list_for_node(struct se_node_acl *nacl)
> -{
> -	struct se_dev_entry *deve;
> -	int i;
> -
> -	nacl->device_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
> -			sizeof(struct se_dev_entry), GFP_KERNEL);
> -	if (!nacl->device_list) {
> -		pr_err("Unable to allocate memory for"
> -			" struct se_node_acl->device_list\n");
> -		return -ENOMEM;
> -	}
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		deve = nacl->device_list[i];
> -
> -		atomic_set(&deve->ua_count, 0);
> -		kref_init(&deve->refcount);
> -		spin_lock_init(&deve->ua_lock);
> -		INIT_LIST_HEAD(&deve->alua_port_node);
> -		INIT_LIST_HEAD(&deve->ua_list);
> -	}
> -
> -	return 0;
> -}
>  
>  /*	core_tpg_check_initiator_node_acl()
>   *
> @@ -283,10 +246,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>  
>  	tpg->se_tpg_tfo->set_default_node_attributes(acl);
>  
> -	if (core_create_device_list_for_node(acl) < 0) {
> -		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
> -		return NULL;
> -	}
> +	acl->rb_device_list = RB_ROOT;
>  
>  	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
>  		core_free_device_list_for_node(acl, tpg);
> @@ -410,10 +370,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
>  
>  	tpg->se_tpg_tfo->set_default_node_attributes(acl);
>  
> -	if (core_create_device_list_for_node(acl) < 0) {
> -		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	acl->rb_device_list = RB_ROOT;
>  
>  	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
>  		core_free_device_list_for_node(acl, tpg);
> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
> index 2a1cbf9..5260442 100644
> --- a/drivers/target/target_core_ua.c
> +++ b/drivers/target/target_core_ua.c
> @@ -51,8 +51,8 @@ target_scsi3_ua_check(struct se_cmd *cmd)
>  	if (!nacl)
>  		return 0;
>  
> -	deve = nacl->device_list[cmd->orig_fe_lun];
> -	if (!atomic_read(&deve->ua_count))
> +	deve = transport_search_deve(nacl, cmd->orig_fe_lun);
> +	if (!deve || !atomic_read(&deve->ua_count))
>  		return 0;
>  	/*
>  	 * From sam4r14, section 5.14 Unit attention condition:
> @@ -105,7 +105,11 @@ int core_scsi3_ua_allocate(
>  	ua->ua_ascq = ascq;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[unpacked_lun];
> +	deve = transport_search_deve(nacl, unpacked_lun);
> +	if (!deve) {
> +		spin_unlock_irq(&nacl->device_list_lock);
> +		return 0;
> +	}
>  
>  	spin_lock(&deve->ua_lock);
>  	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_node) {
> @@ -215,8 +219,8 @@ void core_scsi3_ua_for_check_condition(
>  		return;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[cmd->orig_fe_lun];
> -	if (!atomic_read(&deve->ua_count)) {
> +	deve = transport_search_deve(nacl, cmd->orig_fe_lun);
> +	if (!deve || !atomic_read(&deve->ua_count)) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return;
>  	}
> @@ -284,8 +288,8 @@ int core_scsi3_ua_clear_for_request_sense(
>  		return -EINVAL;
>  
>  	spin_lock_irq(&nacl->device_list_lock);
> -	deve = nacl->device_list[cmd->orig_fe_lun];
> -	if (!atomic_read(&deve->ua_count)) {
> +	deve = transport_search_deve(nacl, cmd->orig_fe_lun);
> +	if (!deve || !atomic_read(&deve->ua_count)) {
>  		spin_unlock_irq(&nacl->device_list_lock);
>  		return -EPERM;
>  	}
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 513429a..3f54fee 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -171,9 +171,8 @@ enum se_cmd_flags_table {
>  /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
>  enum transport_lunflags_table {
>  	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
> -	TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	= 0x01,
> -	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x02,
> -	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x04,
> +	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x01,
> +	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x02,
>  };
>  
>  /*
> @@ -522,7 +521,7 @@ struct se_node_acl {
>  	spinlock_t		stats_lock;
>  	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
>  	atomic_t		acl_pr_ref_count;
> -	struct se_dev_entry	**device_list;
> +	struct rb_root		rb_device_list;
>  	struct se_session	*nacl_sess;
>  	struct se_portal_group *se_tpg;
>  	spinlock_t		device_list_lock;
> @@ -576,6 +575,7 @@ struct se_lun_acl {
>  };
>  
>  struct se_dev_entry {
> +	struct rb_node		rb_node;
>  	bool			def_pr_registered;
>  	/* See transport_lunflags_table */
>  	u32			lun_flags;
