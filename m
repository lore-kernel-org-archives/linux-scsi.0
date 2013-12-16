From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 12/32] target: Convert t10_pr_registration to kref
Date: Mon, 16 Dec 2013 13:20:52 -0800
Message-ID: <1387228852.20247.226.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-13-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38509 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3LPVUB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:20:01 -0500
In-Reply-To: <1386979160-6928-13-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Free struct when kref becomes 0.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_pr.c   |   99 +++++++++++++++---------------------
>  include/target/target_core_base.h |    2 +-
>  2 files changed, 42 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 9155df0..17a4c3b 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -75,6 +75,17 @@ enum preempt_type {
>  	PREEMPT_AND_ABORT,
>  };
>  
> +static void release_pr_reg(struct kref *kref)
> +{
> +	struct t10_pr_registration *pr_reg = container_of(kref,
> +							  struct t10_pr_registration, refcount);
> +
> +	kmem_cache_free(t10_pr_reg_cache, pr_reg);
> +}
> +
> +#define get_pr_reg(x) kref_get(&x->refcount)
> +#define put_pr_reg(x) kref_put(&x->refcount, release_pr_reg)
> +
>  static void __core_scsi3_complete_pro_release(struct se_device *, struct se_node_acl *,
>  			struct t10_pr_registration *, int);
>  
> @@ -109,7 +120,6 @@ target_scsi2_reservation_check(struct se_cmd *cmd)
>  
>  static struct t10_pr_registration *core_scsi3_locate_pr_reg(struct se_device *,
>  					struct se_node_acl *, struct se_session *);
> -static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
>  
>  static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
>  {
> @@ -144,17 +154,17 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
>  		 * as defined in SPC-2.
>  		 */
>  		if (pr_reg->pr_res_holder) {
> -			core_scsi3_put_pr_reg(pr_reg);
> +			put_pr_reg(pr_reg);
>  			return 1;
>  		}
>  		if ((pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY) ||
>  		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY) ||
>  		    (pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
>  		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
> -			core_scsi3_put_pr_reg(pr_reg);
> +			put_pr_reg(pr_reg);
>  			return 1;
>  		}
> -		core_scsi3_put_pr_reg(pr_reg);
> +		put_pr_reg(pr_reg);
>  		conflict = 1;
>  	} else {
>  		/*
> @@ -611,7 +621,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
>  	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
>  	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_list);
>  	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
> -	atomic_set(&pr_reg->pr_res_holders, 0);
> +	kref_init(&pr_reg->refcount);
>  	pr_reg->pr_reg_nacl = nacl;
>  	pr_reg->pr_reg_deve = deve;
>  	pr_reg->pr_res_mapped_lun = deve->mapped_lun;
> @@ -795,7 +805,7 @@ int core_scsi3_alloc_aptpl_registration(
>  	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
>  	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_list);
>  	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
> -	atomic_set(&pr_reg->pr_res_holders, 0);
> +	kref_init(&pr_reg->refcount);
>  	pr_reg->pr_reg_nacl = NULL;
>  	pr_reg->pr_reg_deve = NULL;
>  	pr_reg->pr_res_mapped_lun = mapped_lun;
> @@ -1102,8 +1112,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>  				if (dev->dev_attrib.enforce_pr_isids)
>  					continue;
>  			}
> -			atomic_inc(&pr_reg->pr_res_holders);
> -			smp_mb__after_atomic_inc();
> +			get_pr_reg(pr_reg);
>  			spin_unlock(&pr_tmpl->registration_lock);
>  			return pr_reg;
>  		}
> @@ -1117,8 +1126,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>  		if (strcmp(isid, pr_reg->pr_reg_isid))
>  			continue;
>  
> -		atomic_inc(&pr_reg->pr_res_holders);
> -		smp_mb__after_atomic_inc();
> +		get_pr_reg(pr_reg);
>  		spin_unlock(&pr_tmpl->registration_lock);
>  		return pr_reg;
>  	}
> @@ -1145,12 +1153,6 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
>  	return __core_scsi3_locate_pr_reg(dev, nacl, isid_ptr);
>  }
>  
> -static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
> -{
> -	atomic_dec(&pr_reg->pr_res_holders);
> -	smp_mb__after_atomic_dec();
> -}
> -
>  static int core_scsi3_check_implicit_release(
>  	struct se_device *dev,
>  	struct t10_pr_registration *pr_reg)
> @@ -1213,7 +1215,6 @@ static void __core_scsi3_free_registration(
>  {
>  	struct target_core_fabric_ops *tfo =
>  			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
> -	struct t10_reservation *pr_tmpl = &dev->t10_pr;
>  	char i_buf[PR_REG_ISID_ID_LEN];
>  
>  	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
> @@ -1227,20 +1228,7 @@ static void __core_scsi3_free_registration(
>  	 * so call core_scsi3_put_pr_reg() to decrement our reference.
>  	 */
>  	if (dec_holders)
> -		core_scsi3_put_pr_reg(pr_reg);
> -	/*
> -	 * Wait until all reference from any other I_T nexuses for this
> -	 * *pr_reg have been released.  Because list_del() is called above,
> -	 * the last core_scsi3_put_pr_reg(pr_reg) will release this reference
> -	 * count back to zero, and we release *pr_reg.
> -	 */
> -	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
> -		spin_unlock(&pr_tmpl->registration_lock);
> -		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
> -				tfo->get_fabric_name());
> -		cpu_relax();
> -		spin_lock(&pr_tmpl->registration_lock);
> -	}
> +		put_pr_reg(pr_reg);
>  
>  	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
>  		" Node: %s%s\n", tfo->get_fabric_name(),
> @@ -1254,17 +1242,14 @@ static void __core_scsi3_free_registration(
>  		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
>  		pr_reg->pr_res_generation);
>  
> -	if (!preempt_and_abort_list) {
> -		pr_reg->pr_reg_deve = NULL;
> -		pr_reg->pr_reg_nacl = NULL;
> -		kmem_cache_free(t10_pr_reg_cache, pr_reg);
> -		return;
> -	}
>  	/*
>  	 * For PREEMPT_AND_ABORT, the list of *pr_reg in preempt_and_abort_list
>  	 * are released once the ABORT_TASK_SET has completed..
>  	 */
> -	list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
> +	if (preempt_and_abort_list)
> +		list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
> +	else
> +		put_pr_reg(pr_reg);
>  }

Same issue again.  It's not safe to add pr_reg->pr_reg_abort_list while
there are still active references from other process contexts.

Also, given that core_scsi3_free_pr_reg_from_nacl() is called during
se_node_acl removal, and core_scsi3_free_all_registrations() called
during se_device removal, returning here before ensuring that all
references have completed is completely broken.

NAK.

--nab

