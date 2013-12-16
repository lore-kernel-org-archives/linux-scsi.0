From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 18/32] target: More core_dev_del cleanups
Date: Mon, 16 Dec 2013 13:35:25 -0800
Message-ID: <1387229725.20247.233.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-19-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35731 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3LPVec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:34:32 -0500
In-Reply-To: <1386979160-6928-19-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> core_dev_del_lun needs no return value. Also change it to take a se_lun*
> instead of the unpacked lun.
> 
> Rename core_tpg_pre_dellun to core_tpg_free_lun, and post_dellun to
> remove_lun. Swap the order they are called, and hold off on setting
> lun_status to STATUS_FREE until the end of free_lun.
> 

The swapping of the order makes no sense here..

Why should the checks now happen after everything released to the se_lun
has been released, and yet still ignore the return value.  !?

NAK.

--nab

> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c          |   16 ++++---------
>  drivers/target/target_core_fabric_configfs.c |    2 +-
>  drivers/target/target_core_internal.h        |    6 ++--
>  drivers/target/target_core_tpg.c             |   32 +++++++++-----------------
>  4 files changed, 20 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index faa17a4..af12456 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1140,24 +1140,18 @@ struct se_lun *core_dev_add_lun(
>   *
>   *
>   */
> -int core_dev_del_lun(
> +void core_dev_del_lun(
>  	struct se_portal_group *tpg,
> -	u32 unpacked_lun)
> +	struct se_lun *lun)
>  {
> -	struct se_lun *lun;
> -
> -	lun = core_tpg_pre_dellun(tpg, unpacked_lun);
> -	if (IS_ERR(lun))
> -		return PTR_ERR(lun);
> -
> -	core_tpg_post_dellun(tpg, lun);
> +	core_tpg_remove_lun(tpg, lun);
>  
>  	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivated %s Logical Unit from"
>  		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
> -		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun,
> +		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
>  		tpg->se_tpg_tfo->get_fabric_name());
>  
> -	return 0;
> +	core_tpg_free_lun(tpg, lun);
>  }
>  
>  struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 7de9f04..64cc4dc 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -821,7 +821,7 @@ static int target_fabric_port_unlink(
>  		tf->tf_ops.fabric_pre_unlink(se_tpg, lun);
>  	}
>  
> -	core_dev_del_lun(se_tpg, lun->unpacked_lun);
> +	core_dev_del_lun(se_tpg, lun);
>  	return 0;
>  }
>  
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index aabb730..5d1e4ec 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -44,7 +44,7 @@ int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
>  int	se_dev_set_optimal_sectors(struct se_device *, u32);
>  int	se_dev_set_block_size(struct se_device *, u32);
>  struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
> -int	core_dev_del_lun(struct se_portal_group *, u32);
> +void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
>  struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
>  struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
>  		struct se_node_acl *, u32, int *);
> @@ -90,8 +90,8 @@ void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
>  struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
>  int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
>  		u32, struct se_device *);
> -struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
> -int	core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
> +void core_tpg_free_lun(struct se_portal_group *, struct se_lun *);
> +void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
>  
>  static inline void release_deve(struct kref *kref)
>  {
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index da7febb..e6f9dfb 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -336,7 +336,7 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
>  			continue;
>  
>  		spin_unlock(&tpg->tpg_lun_lock);
> -		core_dev_del_lun(tpg, lun->unpacked_lun);
> +		core_dev_del_lun(tpg, lun);
>  		spin_lock(&tpg->tpg_lun_lock);
>  	}
>  	spin_unlock(&tpg->tpg_lun_lock);
> @@ -671,7 +671,7 @@ static void core_tpg_release_virtual_lun0(struct se_portal_group *se_tpg)
>  {
>  	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
>  
> -	core_tpg_post_dellun(se_tpg, lun);
> +	core_tpg_remove_lun(se_tpg, lun);
>  }
>  
>  int core_tpg_register(
> @@ -841,48 +841,38 @@ int core_tpg_add_lun(
>  	return 0;
>  }
>  
> -struct se_lun *core_tpg_pre_dellun(
> +void core_tpg_free_lun(
>  	struct se_portal_group *tpg,
> -	u32 unpacked_lun)
> +	struct se_lun *lun)
>  {
> -	struct se_lun *lun;
>  
> -	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
> +	if (lun->unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
>  		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
>  			"-1: %u for Target Portal Group: %u\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
> +			tpg->se_tpg_tfo->get_fabric_name(), lun->unpacked_lun,
>  			TRANSPORT_MAX_LUNS_PER_TPG-1,
>  			tpg->se_tpg_tfo->tpg_get_tag(tpg));
> -		return ERR_PTR(-EOVERFLOW);
> +		return;
>  	}
>  
>  	spin_lock(&tpg->tpg_lun_lock);
> -	lun = tpg->tpg_lun_list[unpacked_lun];
>  	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
>  		pr_err("%s Logical Unit Number: %u is not active on"
>  			" Target Portal Group: %u, ignoring request.\n",
> -			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
> +			tpg->se_tpg_tfo->get_fabric_name(), lun->unpacked_lun,
>  			tpg->se_tpg_tfo->tpg_get_tag(tpg));
>  		spin_unlock(&tpg->tpg_lun_lock);
> -		return ERR_PTR(-ENODEV);
> +		return;
>  	}
> +	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
>  	spin_unlock(&tpg->tpg_lun_lock);
> -
> -	return lun;
>  }
>  
> -int core_tpg_post_dellun(
> +void core_tpg_remove_lun(
>  	struct se_portal_group *tpg,
>  	struct se_lun *lun)
>  {
>  	core_clear_lun_from_tpg(lun, tpg);
>  	transport_clear_lun_ref(lun);
> -
>  	core_dev_unexport(lun->lun_se_dev, tpg, lun);
> -
> -	spin_lock(&tpg->tpg_lun_lock);
> -	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> -	spin_unlock(&tpg->tpg_lun_lock);
> -
> -	return 0;
>  }


