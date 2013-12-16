From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 06/32] target: Convert lu_gp_ref_cnt to kref
Date: Mon, 16 Dec 2013 12:52:37 -0800
Message-ID: <1387227157.20247.203.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-7-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56615 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3LPUvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 15:51:44 -0500
In-Reply-To: <1386979160-6928-7-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Use kref to handle reference counting
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_alua.c |   37 ++++++++++++++++++++-----------------
>  include/target/target_core_base.h |    2 +-
>  2 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 2ac2f11..8c01ade 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -54,6 +54,16 @@ static LIST_HEAD(lu_gps_list);
>  
>  struct t10_alua_lu_gp *default_lu_gp;
>  
> +static void release_alua_lu_gp(struct kref *ref)
> +{
> +	struct t10_alua_lu_gp *lu_gp = container_of(ref, struct t10_alua_lu_gp, refcount);
> +
> +	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
> +}
> +
> +#define get_alua_lu_gp(x) kref_get(&x->refcount)
> +#define put_alua_lu_gp(x) kref_put(&x->refcount, release_alua_lu_gp)
> +
>  /*
>   * REPORT_TARGET_PORT_GROUPS
>   *
> @@ -898,8 +908,7 @@ int core_alua_do_port_transition(
>  	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
>  	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
>  	lu_gp = local_lu_gp_mem->lu_gp;
> -	atomic_inc(&lu_gp->lu_gp_ref_cnt);
> -	smp_mb__after_atomic_inc();
> +	get_alua_lu_gp(lu_gp);
>  	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
>  	/*
>  	 * For storage objects that are members of the 'default_lu_gp',
> @@ -913,8 +922,8 @@ int core_alua_do_port_transition(
>  		 */
>  		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
>  					md_buf, new_state, explicit);
> -		atomic_dec(&lu_gp->lu_gp_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +
> +		put_alua_lu_gp(lu_gp);
>  		kfree(md_buf);
>  		return 0;
>  	}
> @@ -985,8 +994,7 @@ int core_alua_do_port_transition(
>  		l_tg_pt_gp->tg_pt_gp_id, (explicit) ? "explicit" : "implicit",
>  		core_alua_dump_state(new_state));
>  
> -	atomic_dec(&lu_gp->lu_gp_ref_cnt);
> -	smp_mb__after_atomic_dec();
> +	put_alua_lu_gp(lu_gp);
>  	kfree(md_buf);
>  	return 0;
>  }
> @@ -1107,7 +1115,8 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
>  	INIT_LIST_HEAD(&lu_gp->lu_gp_node);
>  	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
>  	spin_lock_init(&lu_gp->lu_gp_lock);
> -	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
> +
> +	kref_init(&lu_gp->refcount);
>  
>  	if (def_group) {
>  		lu_gp->lu_gp_id = alua_lu_gps_counter++;
> @@ -1200,13 +1209,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
>  	list_del(&lu_gp->lu_gp_node);
>  	alua_lu_gps_count--;
>  	spin_unlock(&lu_gps_lock);
> -	/*
> -	 * Allow struct t10_alua_lu_gp * referenced by core_alua_get_lu_gp_by_name()
> -	 * in target_core_configfs.c:target_core_store_alua_lu_gp() to be
> -	 * released with core_alua_put_lu_gp_from_name()
> -	 */
> -	while (atomic_read(&lu_gp->lu_gp_ref_cnt))
> -		cpu_relax();
> +
>  	/*
>  	 * Release reference to struct t10_alua_lu_gp * from all associated
>  	 * struct se_device.
> @@ -1241,7 +1244,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
>  	}
>  	spin_unlock(&lu_gp->lu_gp_lock);
>  
> -	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
> +	put_alua_lu_gp(lu_gp);
>  }
>  

The assumption that it's safe to 'Release reference to struct
t10_alua_lu_gp * from all associated struct device' below the original
cpu_relax(), while there are still other process contexts doing their
respective put_alua_lu_gp() is totally wrong.

Furthermore, allowing a configfs_group_ops->drop_item() to return while
there are still active references from other process contexts means that
the parent struct config_group is no longer referenced counted (eg:
configfs child is removed), and introduces a whole host of potential
bugs.

So that said, NAK on this patch.

--nab

