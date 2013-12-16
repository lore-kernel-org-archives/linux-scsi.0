From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 28/32] target: Convert acl_pr_ref_count to kref
Date: Mon, 16 Dec 2013 13:58:17 -0800
Message-ID: <1387231097.20247.254.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-29-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38080 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3LPV5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:57:30 -0500
In-Reply-To: <1386979160-6928-29-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> In fabrics' drop_nodeacl function, do not kfree the nacl. We are
> now calling fabrics' tpg_release_fabric_acl later when its refcount
> goes to zero, which will kfree it.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  Documentation/target/tcm_mod_builder.py      |    1 -
>  drivers/infiniband/ulp/srpt/ib_srpt.c        |    1 -
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    7 +----
>  drivers/target/iscsi/iscsi_target_configfs.c |    2 -
>  drivers/target/sbp/sbp_target.c              |    4 ---
>  drivers/target/target_core_internal.h        |   22 ++++++++++++++++-
>  drivers/target/target_core_pr.c              |   24 ++++++------------
>  drivers/target/target_core_tpg.c             |   34 +++++--------------------
>  drivers/target/target_core_transport.c       |   12 ++-------
>  drivers/target/tcm_fc/tfc_conf.c             |    1 -
>  drivers/usb/gadget/tcm_usb_gadget.c          |    3 --
>  drivers/vhost/scsi.c                         |    3 --
>  include/target/target_core_base.h            |    3 +-
>  13 files changed, 41 insertions(+), 76 deletions(-)
> 
> diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
> index 230ce71..c8e0572 100755
> --- a/Documentation/target/tcm_mod_builder.py
> +++ b/Documentation/target/tcm_mod_builder.py
> @@ -285,7 +285,6 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
>  	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
>  	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
>  	buf += "	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"
> -	buf += "	kfree(nacl);\n"
>  	buf += "}\n\n"
>  
>  	buf += "static struct se_portal_group *" + fabric_mod_name + "_make_tpg(\n"
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 520a7e5..4995b91 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3645,7 +3645,6 @@ static void srpt_drop_nodeacl(struct se_node_acl *se_nacl)
>  	list_del(&nacl->list);
>  	spin_unlock_irq(&sport->port_acl_lock);
>  	core_tpg_del_initiator_node_acl(&sport->port_tpg_1, se_nacl, 1);
> -	srpt_release_fabric_acl(NULL, se_nacl);
>  }
>  
>  static ssize_t srpt_tpg_attrib_show_srp_max_rdma_size(
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 7eb19be..4fe684a 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -828,12 +828,7 @@ static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
>  
>  static void tcm_qla2xxx_drop_nodeacl(struct se_node_acl *se_acl)
>  {
> -	struct se_portal_group *se_tpg = se_acl->se_tpg;
> -	struct tcm_qla2xxx_nacl *nacl = container_of(se_acl,
> -				struct tcm_qla2xxx_nacl, se_node_acl);
> -
> -	core_tpg_del_initiator_node_acl(se_tpg, se_acl, 1);
> -	kfree(nacl);
> +	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
>  }
>  
>  /* Start items for tcm_qla2xxx_tpg_attrib_cit */
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index e3318ed..bd05ab5 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -916,7 +916,6 @@ static struct se_node_acl *lio_target_make_nodeacl(
>  		pr_err("Unable to allocate memory for"
>  				" stats_cg->default_groups\n");
>  		core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
> -		kfree(acl);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -947,7 +946,6 @@ static void lio_target_drop_nodeacl(
>  	kfree(stats_cg->default_groups);
>  
>  	core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
> -	kfree(acl);
>  }
>  
>  /* End items for lio_target_acl_cit */
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 103998c..6fabd9c 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -2126,11 +2126,7 @@ static struct se_node_acl *sbp_make_nodeacl(
>  
>  static void sbp_drop_nodeacl(struct se_node_acl *se_acl)
>  {
> -	struct sbp_nacl *nacl =
> -		container_of(se_acl, struct sbp_nacl, se_node_acl);
> -
>  	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> -	kfree(nacl);
>  }
>  
>  static int sbp_post_link_lun(
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 5b232a7..65a4de9 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -82,10 +82,11 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
>  /* target_core_tpg.c */
>  extern struct se_device *g_lun0_dev;
>  
> +void core_clear_initiator_node_from_tpg(struct se_node_acl *,
> +					struct se_portal_group *);
>  struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
>  		const char *);
>  void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
> -void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
>  struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
>  int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
>  		u32, struct se_device *);
> @@ -115,6 +116,25 @@ static inline void release_lun(struct kref *kref)
>  #define get_lun(x) kref_get(&x->refcount)
>  #define put_lun(x) kref_put(&x->refcount, release_lun)
>  
> +static inline void target_release_nacl(struct kref *kref)
> +{
> +	struct se_node_acl *nacl = container_of(kref,
> +						struct se_node_acl, refcount);
> +	struct se_portal_group *tpg = nacl->se_tpg;
> +
> +	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
> +		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
> +		tpg->se_tpg_tfo->tpg_get_tag(tpg), nacl->queue_depth,
> +		tpg->se_tpg_tfo->get_fabric_name(), nacl->initiatorname);
> +
> +	core_clear_initiator_node_from_tpg(nacl, tpg);
> +	core_free_device_list_for_node(nacl, tpg);
> +	tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, nacl);
> +}
> +
> +#define get_nacl(x) kref_get(&x->refcount)
> +#define put_nacl(x) kref_put(&x->refcount, target_release_nacl)
> +
>  /* target_core_transport.c */
>  extern struct kmem_cache *se_tmr_req_cache;
>  
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index e2b656b..835958b 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1354,16 +1354,14 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
>  	struct se_portal_group *tpg = nacl->se_tpg;
>  
>  	if (nacl->dynamic_node_acl) {
> -		atomic_dec(&nacl->acl_pr_ref_count);
> -		smp_mb__after_atomic_dec();
> +		put_nacl(nacl);
>  		return;
>  	}
>  
>  	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
>  			&nacl->acl_group.cg_item);
>  
> -	atomic_dec(&nacl->acl_pr_ref_count);
> -	smp_mb__after_atomic_dec();
> +	put_nacl(nacl);
>  }
>  
>  static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
> @@ -1553,10 +1551,8 @@ core_scsi3_decode_spec_i_port(
>  			spin_lock_irq(&tmp_tpg->acl_node_lock);
>  			dest_node_acl = __core_tpg_get_initiator_node_acl(
>  						tmp_tpg, i_str);
> -			if (dest_node_acl) {
> -				atomic_inc(&dest_node_acl->acl_pr_ref_count);
> -				smp_mb__after_atomic_inc();
> -			}
> +			if (dest_node_acl)
> +				get_nacl(dest_node_acl);
>  			spin_unlock_irq(&tmp_tpg->acl_node_lock);
>  
>  			if (!dest_node_acl) {
> @@ -1568,8 +1564,7 @@ core_scsi3_decode_spec_i_port(
>  			if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
>  				pr_err("configfs_depend_item() failed"
>  					" for dest_node_acl->acl_group\n");
> -				atomic_dec(&dest_node_acl->acl_pr_ref_count);
> -				smp_mb__after_atomic_dec();
> +				put_nacl(dest_node_acl);
>  				core_scsi3_tpg_undepend_item(tmp_tpg);
>  				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  				goto out_unmap;
> @@ -3253,10 +3248,8 @@ after_iport_check:
>  	spin_lock_irq(&dest_se_tpg->acl_node_lock);
>  	dest_node_acl = __core_tpg_get_initiator_node_acl(dest_se_tpg,
>  				initiator_str);
> -	if (dest_node_acl) {
> -		atomic_inc(&dest_node_acl->acl_pr_ref_count);
> -		smp_mb__after_atomic_inc();
> -	}
> +	if (dest_node_acl)
> +		get_nacl(dest_node_acl);
>  	spin_unlock_irq(&dest_se_tpg->acl_node_lock);
>  
>  	if (!dest_node_acl) {
> @@ -3270,8 +3263,7 @@ after_iport_check:
>  	if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
>  		pr_err("core_scsi3_nodeacl_depend_item() for"
>  			" dest_node_acl\n");
> -		atomic_dec(&dest_node_acl->acl_pr_ref_count);
> -		smp_mb__after_atomic_dec();
> +		put_nacl(dest_node_acl);
>  		dest_node_acl = NULL;
>  		ret = TCM_INVALID_PARAMETER_LIST;
>  		goto out;
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 0e30ced..6aaf50f 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -53,7 +53,7 @@ static LIST_HEAD(tpg_list);
>   *
>   *
>   */
> -static void core_clear_initiator_node_from_tpg(
> +void core_clear_initiator_node_from_tpg(
>  	struct se_node_acl *nacl,
>  	struct se_portal_group *tpg)
>  {
> @@ -251,7 +251,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>  	init_completion(&acl->acl_free_comp);
>  	spin_lock_init(&acl->device_list_lock);
>  	spin_lock_init(&acl->nacl_sess_lock);
> -	atomic_set(&acl->acl_pr_ref_count, 0);
> +	kref_init(&acl->refcount);
>  	acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
>  	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
>  	acl->se_tpg = tpg;
> @@ -264,8 +264,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>  	acl->rb_device_list = RB_ROOT;
>  
>  	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
> -		core_free_device_list_for_node(acl, tpg);
> -		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
> +		put_nacl(acl);
>  		return NULL;
>  	}
>  	/*
> @@ -291,12 +290,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>  }
>  EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
>  
> -void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
> -{
> -	while (atomic_read(&nacl->acl_pr_ref_count) != 0)
> -		cpu_relax();
> -}
> -

Same issues here again, although this is the only one of the nine
conversions that that actually pays attention to what should and should
not be released before the final put appears.

However, still returning from configfs_group_operations->drop_item()
before all references have completed is bad, bad, bad.

NAK.

--nab

