From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 20/32] target: Convert to rbtree for se_lun list in
 se_portal_group
Date: Mon, 16 Dec 2013 13:42:12 -0800
Message-ID: <1387230132.20247.239.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-21-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52153 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3LPVlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:41:19 -0500
In-Reply-To: <1386979160-6928-21-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> As with previous commit, this results in less average memory use, and
> allows lun count to no longer be restrained by the array size.
> 

NAK for the same reasons as the previous patch.  rbtree introduces many
extra memory addresses for pointer chasing during lookup vs. a flat
array, so for a performance critical path this needs to be avoided.

--nab

> Remove array_free and array_zalloc.
> 
> For some reason, sbp fabric needs core_search lun, so export it for now.
> 
> Remove core_alloc_lun, it duplicates core_tpg_alloc_lun.
> 
> Change core_dev_add_lun to take a se_lun and return int
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/sbp/sbp_target.c              |   25 ++---
>  drivers/target/target_core_device.c          |   79 +-----------
>  drivers/target/target_core_fabric_configfs.c |   27 ++---
>  drivers/target/target_core_internal.h        |    5 +-
>  drivers/target/target_core_tpg.c             |  168 ++++++++++++-------------
>  include/target/target_core_base.h            |   11 +--
>  include/target/target_core_fabric.h          |    3 +
>  7 files changed, 116 insertions(+), 202 deletions(-)
> 
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index e1ceae5..103998c 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -185,9 +185,8 @@ static struct se_lun *sbp_get_lun_from_tpg(struct sbp_tpg *tpg, int lun)
>  		return ERR_PTR(-EINVAL);
>  
>  	spin_lock(&se_tpg->tpg_lun_lock);
> -	se_lun = se_tpg->tpg_lun_list[lun];
> -
> -	if (se_lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
> +	se_lun = core_search_lun(se_tpg, lun);
> +	if (!se_lun)
>  		se_lun = ERR_PTR(-ENODEV);
>  
>  	spin_unlock(&se_tpg->tpg_lun_lock);
> @@ -1936,15 +1935,11 @@ static char *sbp_parse_pr_out_transport_id(
>  
>  static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
>  {
> -	int i, count = 0;
> +	int count = 0;
> +	struct rb_node *node;
>  
>  	spin_lock(&tpg->tpg_lun_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		struct se_lun *se_lun = tpg->tpg_lun_list[i];
> -
> -		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
> -			continue;
> -
> +	for (node = rb_first(&tpg->rb_tpg_lun_list); node; node = rb_next(node)) {
>  		count++;
>  	}
>  	spin_unlock(&tpg->tpg_lun_lock);
> @@ -1954,8 +1949,9 @@ static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
>  
>  static int sbp_update_unit_directory(struct sbp_tport *tport)
>  {
> -	int num_luns, num_entries, idx = 0, mgt_agt_addr, ret, i;
> +	int num_luns, num_entries, idx = 0, mgt_agt_addr, ret;
>  	u32 *data;
> +	struct rb_node *node;
>  
>  	if (tport->unit_directory.data) {
>  		fw_core_remove_descriptor(&tport->unit_directory);
> @@ -2017,14 +2013,11 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
>  	data[idx++] = 0x8d000000 | (num_luns + 1);
>  
>  	spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		struct se_lun *se_lun = tport->tpg->se_tpg.tpg_lun_list[i];
> +	for (node = rb_first(&tport->tpg->se_tpg.rb_tpg_lun_list); node; node = rb_next(node)) {
> +		struct se_lun *se_lun = container_of(node, struct se_lun, rb_node);
>  		struct se_device *dev;
>  		int type;
>  
> -		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
> -			continue;
> -
>  		spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
>  
>  		dev = se_lun->lun_se_dev;
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index a18724b..f2e1415 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1117,22 +1117,17 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
>  	return 0;
>  }
>  
> -struct se_lun *core_dev_add_lun(
> +int core_dev_add_lun(
>  	struct se_portal_group *tpg,
>  	struct se_device *dev,
> -	u32 unpacked_lun)
> +	struct se_lun *lun)
>  {
> -	struct se_lun *lun;
>  	int rc;
>  
> -	lun = core_tpg_alloc_lun(tpg, unpacked_lun);
> -	if (IS_ERR(lun))
> -		return lun;
> -
>  	rc = core_tpg_add_lun(tpg, lun,
>  				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
>  	if (rc < 0)
> -		return ERR_PTR(rc);
> +		return rc;
>  
>  	pr_debug("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
>  		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
> @@ -1157,7 +1152,7 @@ struct se_lun *core_dev_add_lun(
>  		spin_unlock_irq(&tpg->acl_node_lock);
>  	}
>  
> -	return lun;
> +	return rc;
>  }
>  
>  /*      core_dev_del_lun():
> @@ -1178,68 +1173,6 @@ void core_dev_del_lun(
>  	core_tpg_free_lun(tpg, lun);
>  }
>  
> -struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
> -{
> -	struct se_lun *lun;
> -
> -	spin_lock(&tpg->tpg_lun_lock);
> -	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
> -		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
> -			"_PER_TPG-1: %u for Target Portal Group: %hu\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
> -			TRANSPORT_MAX_LUNS_PER_TPG-1,
> -			tpg->se_tpg_tfo->tpg_get_tag(tpg));
> -		spin_unlock(&tpg->tpg_lun_lock);
> -		return NULL;
> -	}
> -	lun = tpg->tpg_lun_list[unpacked_lun];
> -
> -	if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
> -		pr_err("%s Logical Unit Number: %u is not free on"
> -			" Target Portal Group: %hu, ignoring request.\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
> -			tpg->se_tpg_tfo->tpg_get_tag(tpg));
> -		spin_unlock(&tpg->tpg_lun_lock);
> -		return NULL;
> -	}
> -	spin_unlock(&tpg->tpg_lun_lock);
> -
> -	return lun;
> -}
> -
> -/*      core_dev_get_lun():
> - *
> - *
> - */
> -static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked_lun)
> -{
> -	struct se_lun *lun;
> -
> -	spin_lock(&tpg->tpg_lun_lock);
> -	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
> -		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
> -			"_TPG-1: %u for Target Portal Group: %hu\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
> -			TRANSPORT_MAX_LUNS_PER_TPG-1,
> -			tpg->se_tpg_tfo->tpg_get_tag(tpg));
> -		spin_unlock(&tpg->tpg_lun_lock);
> -		return NULL;
> -	}
> -	lun = tpg->tpg_lun_list[unpacked_lun];
> -
> -	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
> -		pr_err("%s Logical Unit Number: %u is not active on"
> -			" Target Portal Group: %hu, ignoring request.\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
> -			tpg->se_tpg_tfo->tpg_get_tag(tpg));
> -		spin_unlock(&tpg->tpg_lun_lock);
> -		return NULL;
> -	}
> -	spin_unlock(&tpg->tpg_lun_lock);
> -
> -	return lun;
> -}
> -
>  struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
>  	struct se_portal_group *tpg,
>  	struct se_node_acl *nacl,
> @@ -1279,7 +1212,9 @@ int core_dev_add_initiator_node_lun_acl(
>  	struct se_lun *lun;
>  	struct se_node_acl *nacl;
>  
> -	lun = core_dev_get_lun(tpg, unpacked_lun);
> +	spin_lock(&tpg->tpg_lun_lock);
> +	lun = core_search_lun(tpg, unpacked_lun);
> +	spin_unlock(&tpg->tpg_lun_lock);
>  	if (!lun) {
>  		pr_err("%s Logical Unit Number: %u is not active on"
>  			" Target Portal Group: %hu, ignoring request.\n",
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index eaaed43..1a31b46 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -756,7 +756,6 @@ static int target_fabric_port_link(
>  	struct config_item *tpg_ci;
>  	struct se_lun *lun = container_of(to_config_group(lun_ci),
>  				struct se_lun, lun_group);
> -	struct se_lun *lun_p;
>  	struct se_portal_group *se_tpg;
>  	struct se_device *dev =
>  		container_of(to_config_group(se_dev_ci), struct se_device, dev_group);
> @@ -784,11 +783,10 @@ static int target_fabric_port_link(
>  		return -EEXIST;
>  	}
>  
> -	lun_p = core_dev_add_lun(se_tpg, dev, lun->unpacked_lun);
> -	if (IS_ERR(lun_p)) {
> +	ret = core_dev_add_lun(se_tpg, dev, lun);
> +	if (ret < 0) {
>  		pr_err("core_dev_add_lun() failed\n");
> -		ret = PTR_ERR(lun_p);
> -		goto out;
> +		return ret;
>  	}
>  
>  	if (tf->tf_ops.fabric_post_link) {
> @@ -801,8 +799,6 @@ static int target_fabric_port_link(
>  	}
>  
>  	return 0;
> -out:
> -	return ret;
>  }
>  
>  static int target_fabric_port_unlink(
> @@ -888,15 +884,16 @@ static struct config_group *target_fabric_make_lun(
>  	if (unpacked_lun > UINT_MAX)
>  		return ERR_PTR(-EINVAL);
>  
> -	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
> -	if (!lun)
> -		return ERR_PTR(-EINVAL);
> +	lun = core_tpg_alloc_lun(se_tpg, unpacked_lun);
> +	if (IS_ERR(lun))
> +		return ERR_CAST(lun);
>  
>  	lun_cg = &lun->lun_group;
>  	lun_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
>  				GFP_KERNEL);
>  	if (!lun_cg->default_groups) {
>  		pr_err("Unable to allocate lun_cg->default_groups\n");
> +		core_tpg_free_lun(se_tpg, lun);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -912,16 +909,14 @@ static struct config_group *target_fabric_make_lun(
>  				GFP_KERNEL);
>  	if (!port_stat_grp->default_groups) {
>  		pr_err("Unable to allocate port_stat_grp->default_groups\n");
> -		errno = -ENOMEM;
> -		goto out;
> +		kfree(lun_cg->default_groups);
> +		core_tpg_free_lun(se_tpg, lun);
> +		return ERR_PTR(-ENOMEM);
>  	}
> +
>  	target_stat_setup_port_default_groups(lun);
>  
>  	return &lun->lun_group;
> -out:
> -	if (lun_cg)
> -		kfree(lun_cg->default_groups);
> -	return ERR_PTR(errno);
>  }
>  
>  static void target_fabric_drop_lun(
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 3803dd8..ed4d514 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -45,9 +45,8 @@ int	se_dev_set_max_sectors(struct se_device *, u32);
>  int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
>  int	se_dev_set_optimal_sectors(struct se_device *, u32);
>  int	se_dev_set_block_size(struct se_device *, u32);
> -struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
> +int	core_dev_add_lun(struct se_portal_group *, struct se_device *, struct se_lun *);
>  void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
> -struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
>  struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
>  		struct se_node_acl *, u32, int *);
>  int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
> @@ -94,6 +93,8 @@ int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
>  		u32, struct se_device *);
>  void core_tpg_free_lun(struct se_portal_group *, struct se_lun *);
>  void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
> +bool core_insert_lun(struct se_portal_group *tpg, struct se_lun *lun);
> +struct se_lun *core_search_lun(struct se_portal_group *tpg, u32 mapped_lun);
>  
>  static inline void release_deve(struct kref *kref)
>  {
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 3efa7c1..0467ad8 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -109,6 +109,50 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
>  }
>  EXPORT_SYMBOL(core_tpg_get_initiator_node_acl);
>  
> +bool core_insert_lun(struct se_portal_group *tpg, struct se_lun *lun)
> +{
> +	struct rb_root *root = &tpg->rb_tpg_lun_list;
> +	struct rb_node **new = &(root->rb_node), *parent = NULL;
> +
> +	/* Figure out where to put new node */
> +	while (*new) {
> +		struct se_lun *this = rb_entry(*new, struct se_lun, rb_node);
> +
> +		parent = *new;
> +		if (lun->unpacked_lun < this->unpacked_lun)
> +			new = &((*new)->rb_left);
> +		else if (lun->unpacked_lun > this->unpacked_lun)
> +			new = &((*new)->rb_right);
> +		else
> +			return false;
> +	}
> +
> +	/* Add new node and rebalance tree. */
> +	rb_link_node(&lun->rb_node, parent, new);
> +	rb_insert_color(&lun->rb_node, root);
> +
> +	return true;
> +}
> +
> +struct se_lun *core_search_lun(struct se_portal_group *tpg, u32 unpacked_lun)
> +{
> +	struct rb_root *root = &tpg->rb_tpg_lun_list;
> +	struct rb_node *node = root->rb_node;
> +
> +	while (node) {
> +		struct se_lun *lun = rb_entry(node, struct se_lun, rb_node);
> +
> +		if (unpacked_lun < lun->unpacked_lun)
> +			node = node->rb_left;
> +		else if (unpacked_lun > lun->unpacked_lun)
> +			node = node->rb_right;
> +		else
> +			return lun;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL(core_search_lun);
> +
>  /*	core_tpg_add_node_to_devs():
>   *
>   *
> @@ -117,16 +161,13 @@ void core_tpg_add_node_to_devs(
>  	struct se_node_acl *acl,
>  	struct se_portal_group *tpg)
>  {
> -	int i = 0;
>  	u32 lun_access = 0;
> -	struct se_lun *lun;
>  	struct se_device *dev;
> +	struct rb_node *node;
>  
>  	spin_lock(&tpg->tpg_lun_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		lun = tpg->tpg_lun_list[i];
> -		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
> -			continue;
> +	for (node = rb_first(&tpg->rb_tpg_lun_list); node; node = rb_next(node)) {
> +		struct se_lun *lun = rb_entry(node, struct se_lun, rb_node);
>  
>  		spin_unlock(&tpg->tpg_lun_lock);
>  
> @@ -180,35 +221,6 @@ static int core_set_queue_depth_for_node(
>  	return 0;
>  }
>  
> -void array_free(void *array, int n)
> -{
> -	void **a = array;
> -	int i;
> -
> -	for (i = 0; i < n; i++)
> -		kfree(a[i]);
> -	kfree(a);
> -}
> -
> -static void *array_zalloc(int n, size_t size, gfp_t flags)
> -{
> -	void **a;
> -	int i;
> -
> -	a = kzalloc(n * sizeof(void*), flags);
> -	if (!a)
> -		return NULL;
> -	for (i = 0; i < n; i++) {
> -		a[i] = kzalloc(size, flags);
> -		if (!a[i]) {
> -			array_free(a, n);
> -			return NULL;
> -		}
> -	}
> -	return a;
> -}
> -
> -
>  /*	core_tpg_check_initiator_node_acl()
>   *
>   *
> @@ -284,15 +296,13 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
>  
>  void core_tpg_clear_object_luns(struct se_portal_group *tpg)
>  {
> -	int i;
> -	struct se_lun *lun;
> +	struct rb_node *node;
>  
>  	spin_lock(&tpg->tpg_lun_lock);
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		lun = tpg->tpg_lun_list[i];
> +	for (node = rb_first(&tpg->rb_tpg_lun_list); node; node = rb_next(node)) {
> +		struct se_lun *lun = rb_entry(node, struct se_lun, rb_node);
>  
> -		if ((lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) ||
> -		    (lun->lun_se_dev == NULL))
> +		if (!lun->lun_se_dev)
>  			continue;
>  
>  		spin_unlock(&tpg->tpg_lun_lock);
> @@ -607,7 +617,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
>  	int ret;
>  
>  	lun->unpacked_lun = 0;
> -	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> +	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
>  	atomic_set(&lun->lun_acl_count, 0);
>  	init_completion(&lun->lun_shutdown_comp);
>  	INIT_LIST_HEAD(&lun->lun_acl_list);
> @@ -638,30 +648,6 @@ int core_tpg_register(
>  	void *tpg_fabric_ptr,
>  	int se_tpg_type)
>  {
> -	struct se_lun *lun;
> -	u32 i;
> -
> -	se_tpg->tpg_lun_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
> -			sizeof(struct se_lun), GFP_KERNEL);
> -	if (!se_tpg->tpg_lun_list) {
> -		pr_err("Unable to allocate struct se_portal_group->"
> -				"tpg_lun_list\n");
> -		return -ENOMEM;
> -	}
> -
> -	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> -		lun = se_tpg->tpg_lun_list[i];
> -		lun->unpacked_lun = i;
> -		lun->lun_link_magic = SE_LUN_LINK_MAGIC;
> -		lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> -		atomic_set(&lun->lun_acl_count, 0);
> -		init_completion(&lun->lun_shutdown_comp);
> -		INIT_LIST_HEAD(&lun->lun_acl_list);
> -		spin_lock_init(&lun->lun_acl_lock);
> -		spin_lock_init(&lun->lun_sep_lock);
> -		init_completion(&lun->lun_ref_comp);
> -	}
> -
>  	se_tpg->se_tpg_type = se_tpg_type;
>  	se_tpg->se_tpg_fabric_ptr = tpg_fabric_ptr;
>  	se_tpg->se_tpg_tfo = tfo;
> @@ -673,13 +659,11 @@ int core_tpg_register(
>  	spin_lock_init(&se_tpg->acl_node_lock);
>  	spin_lock_init(&se_tpg->session_lock);
>  	spin_lock_init(&se_tpg->tpg_lun_lock);
> +	se_tpg->rb_tpg_lun_list = RB_ROOT;
>  
>  	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
> -		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
> -			array_free(se_tpg->tpg_lun_list,
> -				   TRANSPORT_MAX_LUNS_PER_TPG);
> +		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
>  			return -ENOMEM;
> -		}
>  	}
>  
>  	spin_lock_bh(&tpg_lock);
> @@ -737,7 +721,10 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
>  		core_tpg_release_virtual_lun0(se_tpg);
>  
>  	se_tpg->se_tpg_fabric_ptr = NULL;
> -	array_free(se_tpg->tpg_lun_list, TRANSPORT_MAX_LUNS_PER_TPG);
> +
> +	/* Shouldn't be able to release tpg if luns present */
> +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&se_tpg->rb_tpg_lun_list));
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(core_tpg_deregister);
> @@ -757,15 +744,28 @@ struct se_lun *core_tpg_alloc_lun(
>  		return ERR_PTR(-EOVERFLOW);
>  	}
>  
> +	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
> +	if (!lun)
> +		return ERR_PTR(-ENOMEM);
> +
> +	lun->unpacked_lun = unpacked_lun;
> +	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
> +	atomic_set(&lun->lun_acl_count, 0);
> +	init_completion(&lun->lun_shutdown_comp);
> +	INIT_LIST_HEAD(&lun->lun_acl_list);
> +	spin_lock_init(&lun->lun_acl_lock);
> +	spin_lock_init(&lun->lun_sep_lock);
> +	init_completion(&lun->lun_ref_comp);
> +
>  	spin_lock(&tpg->tpg_lun_lock);
> -	lun = tpg->tpg_lun_list[unpacked_lun];
> -	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
> -		pr_err("TPG Logical Unit Number: %u is already active"
> -			" on %s Target Portal Group: %u, ignoring request.\n",
> -			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
> +	if (!core_insert_lun(tpg, lun)) {
> +		pr_err("%s Logical Unit Number: %u is not free on"
> +			" Target Portal Group: %hu, ignoring request.\n",
> +			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
>  			tpg->se_tpg_tfo->tpg_get_tag(tpg));
>  		spin_unlock(&tpg->tpg_lun_lock);
> -		return ERR_PTR(-EINVAL);
> +		kfree(lun);
> +		return ERR_PTR(-EEXIST);
>  	}
>  	spin_unlock(&tpg->tpg_lun_lock);
>  
> @@ -792,7 +792,6 @@ int core_tpg_add_lun(
>  
>  	spin_lock(&tpg->tpg_lun_lock);
>  	lun->lun_access = lun_access;
> -	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
>  	spin_unlock(&tpg->tpg_lun_lock);
>  
>  	return 0;
> @@ -812,16 +811,11 @@ void core_tpg_free_lun(
>  		return;
>  	}
>  
> +	WARN_ON_ONCE(!list_empty(&lun->lun_acl_list));
> +
>  	spin_lock(&tpg->tpg_lun_lock);
> -	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
> -		pr_err("%s Logical Unit Number: %u is not active on"
> -			" Target Portal Group: %u, ignoring request.\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), lun->unpacked_lun,
> -			tpg->se_tpg_tfo->tpg_get_tag(tpg));
> -		spin_unlock(&tpg->tpg_lun_lock);
> -		return;
> -	}
> -	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> +	rb_erase(&lun->rb_node, &tpg->rb_tpg_lun_list);
> +	kfree(lun);
>  	spin_unlock(&tpg->tpg_lun_lock);
>  }
>  
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 3f54fee..06f9bea 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -122,12 +122,6 @@ enum hba_flags_table {
>  	HBA_FLAGS_PSCSI_MODE	= 0x02,
>  };
>  
> -/* struct se_lun->lun_status */
> -enum transport_lun_status_table {
> -	TRANSPORT_LUN_STATUS_FREE = 0,
> -	TRANSPORT_LUN_STATUS_ACTIVE = 1,
> -};
> -
>  /* struct se_portal_group->se_tpg_type */
>  enum transport_tpg_type_table {
>  	TRANSPORT_TPG_TYPE_NORMAL = 0,
> @@ -634,10 +628,9 @@ struct se_port_stat_grps {
>  };
>  
>  struct se_lun {
> +	struct rb_node		rb_node;
>  #define SE_LUN_LINK_MAGIC			0xffff7771
>  	u32			lun_link_magic;
> -	/* See transport_lun_status_table */
> -	enum transport_lun_status_table lun_status;
>  	u32			lun_access;
>  	u32			lun_flags;
>  	u32			unpacked_lun;
> @@ -804,7 +797,7 @@ struct se_portal_group {
>  	struct list_head	se_tpg_node;
>  	/* linked list for initiator ACL list */
>  	struct list_head	acl_node_list;
> -	struct se_lun		**tpg_lun_list;
> +	struct rb_root		rb_tpg_lun_list;
>  	struct se_lun		tpg_virt_lun0;
>  	/* List of TCM sessions associated wth this TPG */
>  	struct list_head	tpg_sess_list;
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 4cf4fda..0267780 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -154,6 +154,9 @@ int	core_tpg_register(struct target_core_fabric_ops *, struct se_wwn *,
>  		struct se_portal_group *, void *, int);
>  int	core_tpg_deregister(struct se_portal_group *);
>  
> +/* SBP needs this. TODO: fix */
> +struct se_lun *core_search_lun(struct se_portal_group *tpg, u32 unpacked_lun);
> +
>  /* SAS helpers */
>  u8	sas_get_fabric_proto_ident(struct se_portal_group *);
>  u32	sas_get_pr_transport_id(struct se_portal_group *, struct se_node_acl *,


