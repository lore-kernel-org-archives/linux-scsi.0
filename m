From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/32] target: convert tg_pt_gp_mem_ref_cnt to kref
Date: Mon, 16 Dec 2013 13:08:45 -0800
Message-ID: <1387228125.20247.217.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-10-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-10-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Use kref to handle reference counting.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_alua.c |   23 ++++++++++++++---------
>  include/target/target_core_base.h |    2 +-
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index ba7b3d6..4ee08a2 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -84,6 +84,16 @@ static void release_alua_tg_pt_gp(struct kref *ref)
>  #define get_alua_tg_pt_gp(x) kref_get(&x->refcount)
>  #define put_alua_tg_pt_gp(x) kref_put(&x->refcount, release_alua_tg_pt_gp)
>  
> +static void release_alua_tg_pt_gp_mem(struct kref *ref)
> +{
> +	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem = container_of(ref, struct t10_alua_tg_pt_gp_member, refcount);
> +
> +	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
> +}
> +
> +#define get_alua_tg_pt_gp_mem(x) kref_get(&x->refcount)
> +#define put_alua_tg_pt_gp_mem(x) kref_put(&x->refcount, release_alua_tg_pt_gp_mem)
> +
>  /*
>   * REPORT_TARGET_PORT_GROUPS
>   *
> @@ -834,8 +844,7 @@ static int core_alua_do_transition_tg_pt(
>  		 * every I_T nexus other than the I_T nexus on which the SET
>  		 * TARGET PORT GROUPS command
>  		 */
> -		atomic_inc(&mem->tg_pt_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_inc();
> +		get_alua_tg_pt_gp_mem(mem);
>  		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
>  
>  		spin_lock_bh(&port->sep_alua_lock);
> @@ -861,8 +870,7 @@ static int core_alua_do_transition_tg_pt(
>  		spin_unlock_bh(&port->sep_alua_lock);
>  
>  		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
> -		atomic_dec(&mem->tg_pt_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +		put_alua_tg_pt_gp_mem(mem);
>  	}
>  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
>  	/*
> @@ -1463,7 +1471,7 @@ struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
>  	}
>  	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_node);
>  	spin_lock_init(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
> -	atomic_set(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt, 0);
> +	kref_init(&tg_pt_gp_mem->refcount);
>  
>  	tg_pt_gp_mem->tg_pt = port;
>  	port->sep_alua_tg_pt_gp_mem = tg_pt_gp_mem;
> @@ -1536,9 +1544,6 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
>  	if (!tg_pt_gp_mem)
>  		return;
>  
> -	while (atomic_read(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt))
> -		cpu_relax();
> -
>  	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
>  	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
>  	if (tg_pt_gp) {
> @@ -1553,7 +1558,7 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
>  	}
>  	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
>  
> -	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
> +	put_alua_tg_pt_gp_mem(tg_pt_gp_mem);
>  }

Same issue here between original cpu_relax() location and
put_alua_tg_pt_gp_mem().  It's not safe to drop the
tg_pt_gp_mem->tg_pt_gp association while there are still active
references in other process contexts.

Also, the same problem exists with configfs reference counting here,
where core_alua_free_tg_pt_gp_mem() is called from core_dev_unexport()
-> core_release_port(), where the struct lun could be immediately be
reused, or the struct device be removed before the final
put_alua_tg_pt_gp() is called from the other process contexts.

NAK.

--nab
