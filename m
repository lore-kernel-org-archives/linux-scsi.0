From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 22/32] target: Convert percpu_ref to kref
Date: Mon, 16 Dec 2013 13:44:40 -0800
Message-ID: <1387230280.20247.242.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-23-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-23-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Wasn't getting release called when I expected, so punted and went down
> to krefs. Much simpler.
> 

This is not an acceptable reason.

NAK.

--nab

> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c    |    5 ++---
>  drivers/target/target_core_internal.h  |   10 ++++++++++
>  drivers/target/target_core_tpg.c       |   29 ++++-------------------------
>  drivers/target/target_core_transport.c |   29 +----------------------------
>  include/target/target_core_base.h      |    3 +--
>  5 files changed, 18 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index e85a647..753e7ca 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -138,7 +138,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  		se_cmd->orig_fe_lun = unpacked_lun;
>  		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>  
> -		percpu_ref_get(&se_lun->lun_ref);
> +		get_lun(se_lun);
>  		se_cmd->lun_ref_active = true;
>  	}
>  	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
> @@ -168,7 +168,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  		se_cmd->orig_fe_lun = 0;
>  		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>  
> -		percpu_ref_get(&se_lun->lun_ref);
> +		get_lun(se_lun);
>  		se_cmd->lun_ref_active = true;
>  	}
>  
> @@ -1411,7 +1411,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  	INIT_LIST_HEAD(&xcopy_lun->lun_acl_list);
>  	spin_lock_init(&xcopy_lun->lun_acl_lock);
>  	spin_lock_init(&xcopy_lun->lun_sep_lock);
> -	init_completion(&xcopy_lun->lun_ref_comp);
>  
>  	return dev;
>  }
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index ed4d514..4d3b559 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -107,6 +107,16 @@ static inline void release_deve(struct kref *kref)
>  #define get_deve(x) kref_get(&x->refcount)
>  #define put_deve(x) kref_put(&x->refcount, release_deve)
>  
> +static inline void release_lun(struct kref *kref)
> +{
> +	struct se_lun *lun = container_of(kref, struct se_lun, refcount);
> +
> +	core_tpg_free_lun(lun->lun_tpg, lun);
> +}
> +
> +#define get_lun(x) kref_get(&x->refcount)
> +#define put_lun(x) kref_put(&x->refcount, release_lun)
> +
>  /* target_core_transport.c */
>  extern struct kmem_cache *se_tmr_req_cache;
>  
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 977b05c..6b4b0e6 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -601,20 +601,12 @@ int core_tpg_set_initiator_node_tag(
>  }
>  EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
>  
> -static void core_tpg_lun_ref_release(struct percpu_ref *ref)
> -{
> -	struct se_lun *lun = container_of(ref, struct se_lun, lun_ref);
> -
> -	complete(&lun->lun_ref_comp);
> -}
> -
>  static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
>  {
>  	/* Set in core_dev_setup_virtual_lun0() */
>  	struct se_device *dev = g_lun0_dev;
>  	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
>  	u32 lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
> -	int ret;
>  
>  	lun->unpacked_lun = 0;
>  	atomic_set(&lun->lun_acl_count, 0);
> @@ -622,15 +614,8 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
>  	INIT_LIST_HEAD(&lun->lun_acl_list);
>  	spin_lock_init(&lun->lun_acl_lock);
>  	spin_lock_init(&lun->lun_sep_lock);
> -	init_completion(&lun->lun_ref_comp);
> -
> -	ret = core_tpg_add_lun(se_tpg, lun, lun_access, dev);
> -	if (ret < 0) {
> -		percpu_ref_cancel_init(&lun->lun_ref);
> -		return ret;
> -	}
>  
> -	return 0;
> +	return core_tpg_add_lun(se_tpg, lun, lun_access, dev);
>  }
>  
>  static void core_tpg_release_virtual_lun0(struct se_portal_group *se_tpg)
> @@ -753,7 +738,7 @@ struct se_lun *core_tpg_alloc_lun(
>  	INIT_LIST_HEAD(&lun->lun_acl_list);
>  	spin_lock_init(&lun->lun_acl_lock);
>  	spin_lock_init(&lun->lun_sep_lock);
> -	init_completion(&lun->lun_ref_comp);
> +	kref_init(&lun->refcount);
>  
>  	spin_lock(&tpg->tpg_lun_lock);
>  	if (!core_insert_lun(tpg, lun)) {
> @@ -778,15 +763,9 @@ int core_tpg_add_lun(
>  {
>  	int ret;
>  
> -	ret = percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release);
> -	if (ret < 0)
> -		return ret;
> -
>  	ret = core_dev_export(dev, tpg, lun);
> -	if (ret < 0) {
> -		percpu_ref_cancel_init(&lun->lun_ref);
> +	if (ret < 0)
>  		return ret;
> -	}
>  
>  	spin_lock(&tpg->tpg_lun_lock);
>  	lun->lun_access = lun_access;
> @@ -822,6 +801,6 @@ void core_tpg_remove_lun(
>  	struct se_lun *lun)
>  {
>  	core_clear_lun_from_tpg(lun, tpg);
> -	transport_clear_lun_ref(lun);
>  	core_dev_unexport(lun->lun_se_dev, tpg, lun);
> +	put_lun(lun);
>  }
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index accaca5..a6ef32a 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -571,7 +571,7 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
>  	if (!lun || !cmd->lun_ref_active)
>  		return;
>  
> -	percpu_ref_put(&lun->lun_ref);
> +	put_lun(lun);
>  }
>  
>  void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
> @@ -2364,33 +2364,6 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
>  }
>  EXPORT_SYMBOL(target_wait_for_sess_cmds);
>  
> -static int transport_clear_lun_ref_thread(void *p)
> -{
> -	struct se_lun *lun = p;
> -
> -	percpu_ref_kill(&lun->lun_ref);
> -
> -	wait_for_completion(&lun->lun_ref_comp);
> -	complete(&lun->lun_shutdown_comp);
> -
> -	return 0;
> -}
> -
> -int transport_clear_lun_ref(struct se_lun *lun)
> -{
> -	struct task_struct *kt;
> -
> -	kt = kthread_run(transport_clear_lun_ref_thread, lun,
> -			"tcm_cl_%u", lun->unpacked_lun);
> -	if (IS_ERR(kt)) {
> -		pr_err("Unable to start clear_lun thread\n");
> -		return PTR_ERR(kt);
> -	}
> -	wait_for_completion(&lun->lun_shutdown_comp);
> -
> -	return 0;
> -}
> -
>  /**
>   * transport_wait_for_tasks - wait for completion to occur
>   * @cmd:	command to wait
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 2c0a595..6d67c31 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -641,8 +641,7 @@ struct se_lun {
>  	struct se_port		*lun_sep;
>  	struct config_group	lun_group;
>  	struct se_port_stat_grps port_stat_grps;
> -	struct completion	lun_ref_comp;
> -	struct percpu_ref	lun_ref;
> +	struct kref		refcount;
>  };
>  
>  struct se_dev_stat_grps {
