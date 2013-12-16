From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 08/32] target: Convert tg_pt_gp_ref_cnt to kref
Date: Mon, 16 Dec 2013 13:00:47 -0800
Message-ID: <1387227647.20247.211.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-9-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42543 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3LPU7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 15:59:54 -0500
In-Reply-To: <1386979160-6928-9-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Use kref to handle reference counting.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_alua.c |   39 +++++++++++++++++-------------------
>  include/target/target_core_base.h |    2 +-
>  2 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index fe2eada..ba7b3d6 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -74,6 +74,16 @@ static void release_alua_lu_gp_mem(struct kref *ref)
>  #define get_alua_lu_gp_mem(x) kref_get(&x->refcount)
>  #define put_alua_lu_gp_mem(x) kref_put(&x->refcount, release_alua_lu_gp_mem)
>  
> +static void release_alua_tg_pt_gp(struct kref *ref)
> +{
> +	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(ref, struct t10_alua_tg_pt_gp, refcount);
> +
> +	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
> +}
> +
> +#define get_alua_tg_pt_gp(x) kref_get(&x->refcount)
> +#define put_alua_tg_pt_gp(x) kref_put(&x->refcount, release_alua_tg_pt_gp)
> +
>  /*
>   * REPORT_TARGET_PORT_GROUPS
>   *
> @@ -327,8 +337,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
>  				if (tg_pt_id != tg_pt_gp->tg_pt_gp_id)
>  					continue;
>  
> -				atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -				smp_mb__after_atomic_inc();
> +				get_alua_tg_pt_gp(tg_pt_gp);
>  
>  				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  
> @@ -338,8 +347,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
>  					found = true;
>  
>  				spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> -				atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -				smp_mb__after_atomic_dec();
> +				put_alua_tg_pt_gp(tg_pt_gp);
>  				break;
>  			}
>  			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
> @@ -975,8 +983,7 @@ int core_alua_do_port_transition(
>  				port = NULL;
>  				nacl = NULL;
>  			}
> -			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -			smp_mb__after_atomic_inc();
> +			get_alua_tg_pt_gp(tg_pt_gp);
>  			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  			/*
>  			 * core_alua_do_transition_tg_pt() will always return
> @@ -986,8 +993,7 @@ int core_alua_do_port_transition(
>  					nacl, md_buf, new_state, explicit);
>  
>  			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> -			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
> -			smp_mb__after_atomic_dec();
> +			put_alua_tg_pt_gp(tg_pt_gp);
>  		}
>  		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  
> @@ -1354,7 +1360,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
>  	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_mem_list);
>  	mutex_init(&tg_pt_gp->tg_pt_gp_md_mutex);
>  	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
> -	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
> +	kref_init(&tg_pt_gp->refcount);
>  	tg_pt_gp->tg_pt_gp_dev = dev;
>  	tg_pt_gp->tg_pt_gp_md_buf_len = ALUA_MD_BUF_LEN;
>  	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
> @@ -1485,15 +1491,6 @@ void core_alua_free_tg_pt_gp(
>  	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  
>  	/*
> -	 * Allow a struct t10_alua_tg_pt_gp_member * referenced by
> -	 * core_alua_get_tg_pt_gp_by_name() in
> -	 * target_core_configfs.c:target_core_store_alua_tg_pt_gp()
> -	 * to be released with core_alua_put_tg_pt_gp_from_name().
> -	 */
> -	while (atomic_read(&tg_pt_gp->tg_pt_gp_ref_cnt))
> -		cpu_relax();
> -
> -	/*
>  	 * Release reference to struct t10_alua_tg_pt_gp from all associated
>  	 * struct se_port.
>  	 */
> @@ -1527,7 +1524,7 @@ void core_alua_free_tg_pt_gp(
>  	}
>  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
>  
> -	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
> +	put_alua_tg_pt_gp(tg_pt_gp);
>  }
>  

Same problem here again.  It's incorrect to assume that it's safe to
'Relase reference to struct t10_alua_tg_pt_gp from all associated struct
se_port', while other process contexts are referencing this memory.

Also same problem with configfs reference counting, where a parent
struct config_group can be removed since it's child struct config_group
has been dropped, but still be referenced elsewhere.

NAK.

--nab

