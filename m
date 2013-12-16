From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/32] target: Convert struct alua_lu_gp_member to kref
Date: Mon, 16 Dec 2013 12:56:42 -0800
Message-ID: <1387227402.20247.207.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-8-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34845 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3LPUzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 15:55:49 -0500
In-Reply-To: <1386979160-6928-8-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_alua.c |   24 +++++++++++++++---------
>  include/target/target_core_base.h |    2 +-
>  2 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 8c01ade..fe2eada 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -64,6 +64,16 @@ static void release_alua_lu_gp(struct kref *ref)
>  #define get_alua_lu_gp(x) kref_get(&x->refcount)
>  #define put_alua_lu_gp(x) kref_put(&x->refcount, release_alua_lu_gp)
>  
> +static void release_alua_lu_gp_mem(struct kref *ref)
> +{
> +	struct t10_alua_lu_gp_member *lu_gp_mem = container_of(ref, struct t10_alua_lu_gp_member, refcount);
> +
> +	kmem_cache_free(t10_alua_lu_gp_mem_cache, lu_gp_mem);
> +}
> +
> +#define get_alua_lu_gp_mem(x) kref_get(&x->refcount)
> +#define put_alua_lu_gp_mem(x) kref_put(&x->refcount, release_alua_lu_gp_mem)
> +
>  /*
>   * REPORT_TARGET_PORT_GROUPS
>   *
> @@ -937,8 +947,7 @@ int core_alua_do_port_transition(
>  				lu_gp_mem_node) {
>  
>  		dev = lu_gp_mem->lu_gp_mem_dev;
> -		atomic_inc(&lu_gp_mem->lu_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_inc();
> +		get_alua_lu_gp_mem(lu_gp_mem);
>  		spin_unlock(&lu_gp->lu_gp_lock);
>  
>  		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> @@ -983,8 +992,7 @@ int core_alua_do_port_transition(
>  		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  
>  		spin_lock(&lu_gp->lu_gp_lock);
> -		atomic_dec(&lu_gp_mem->lu_gp_mem_ref_cnt);
> -		smp_mb__after_atomic_dec();
> +		put_alua_lu_gp_mem(lu_gp_mem);
>  	}
>  	spin_unlock(&lu_gp->lu_gp_lock);
>  
> @@ -1186,7 +1194,8 @@ core_alua_allocate_lu_gp_mem(struct se_device *dev)
>  	}
>  	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_node);
>  	spin_lock_init(&lu_gp_mem->lu_gp_mem_lock);
> -	atomic_set(&lu_gp_mem->lu_gp_mem_ref_cnt, 0);
> +
> +	kref_init(&lu_gp_mem->refcount);
>  
>  	lu_gp_mem->lu_gp_mem_dev = dev;
>  	dev->dev_alua_lu_gp_mem = lu_gp_mem;
> @@ -1256,9 +1265,6 @@ void core_alua_free_lu_gp_mem(struct se_device *dev)
>  	if (!lu_gp_mem)
>  		return;
>  
> -	while (atomic_read(&lu_gp_mem->lu_gp_mem_ref_cnt))
> -		cpu_relax();
> -
>  	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
>  	lu_gp = lu_gp_mem->lu_gp;
>  	if (lu_gp) {
> @@ -1273,7 +1279,7 @@ void core_alua_free_lu_gp_mem(struct se_device *dev)
>  	}
>  	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
>  
> -	kmem_cache_free(t10_alua_lu_gp_mem_cache, lu_gp_mem);
> +	put_alua_lu_gp_mem(lu_gp_mem);
>  }
>  

Same problem on this one as well.  Assuming that it's safe to clear the
lu_gp_mem->lu_gp association while there are still active references is
wrong.

Also, considering that core_alua_free_lu_gp_mem() is called from
target_free_device(), it absolutely needs to wait until the reference
drops before target_free_device() completes.

So that being the case, NAK.

--nab

