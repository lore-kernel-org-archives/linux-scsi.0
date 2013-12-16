From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 29/32] target: Simplify params to
 core_tpg_del_initiator_node_acl
Date: Mon, 16 Dec 2013 14:00:28 -0800
Message-ID: <1387231228.20247.255.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-30-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-30-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> 'force' parameter is not used.
> 
> tpg parameter is not needed, since we have acl->se_tpg.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  Documentation/target/tcm_mod_builder.py      |    2 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c        |    2 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    2 +-
>  drivers/target/iscsi/iscsi_target_configfs.c |    5 ++---
>  drivers/target/sbp/sbp_target.c              |    2 +-
>  drivers/target/target_core_tpg.c             |    6 ++----
>  drivers/target/tcm_fc/tfc_conf.c             |    2 +-
>  drivers/usb/gadget/tcm_usb_gadget.c          |    2 +-
>  drivers/vhost/scsi.c                         |    2 +-
>  include/target/target_core_fabric.h          |    3 +--
>  10 files changed, 12 insertions(+), 16 deletions(-)
> 

I'm OK to take this one, but it does not apply without #28.

--nab

> diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
> index c8e0572..bfebc66 100755
> --- a/Documentation/target/tcm_mod_builder.py
> +++ b/Documentation/target/tcm_mod_builder.py
> @@ -284,7 +284,7 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
>  	buf += "{\n"
>  	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
>  	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
> -	buf += "	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"
> +	buf += "	core_tpg_del_initiator_node_acl(se_acl);\n"
>  	buf += "}\n\n"
>  
>  	buf += "static struct se_portal_group *" + fabric_mod_name + "_make_tpg(\n"
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 4995b91..7a23e75 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3644,7 +3644,7 @@ static void srpt_drop_nodeacl(struct se_node_acl *se_nacl)
>  	spin_lock_irq(&sport->port_acl_lock);
>  	list_del(&nacl->list);
>  	spin_unlock_irq(&sport->port_acl_lock);
> -	core_tpg_del_initiator_node_acl(&sport->port_tpg_1, se_nacl, 1);
> +	core_tpg_del_initiator_node_acl(se_nacl);
>  }
>  
>  static ssize_t srpt_tpg_attrib_show_srp_max_rdma_size(
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 4fe684a..05967eb 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -828,7 +828,7 @@ static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
>  
>  static void tcm_qla2xxx_drop_nodeacl(struct se_node_acl *se_acl)
>  {
> -	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> +	core_tpg_del_initiator_node_acl(se_acl);
>  }
>  
>  /* Start items for tcm_qla2xxx_tpg_attrib_cit */
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index bd05ab5..3bc1443 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -915,7 +915,7 @@ static struct se_node_acl *lio_target_make_nodeacl(
>  	if (!stats_cg->default_groups) {
>  		pr_err("Unable to allocate memory for"
>  				" stats_cg->default_groups\n");
> -		core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
> +		core_tpg_del_initiator_node_acl(se_nacl);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -930,7 +930,6 @@ static struct se_node_acl *lio_target_make_nodeacl(
>  static void lio_target_drop_nodeacl(
>  	struct se_node_acl *se_nacl)
>  {
> -	struct se_portal_group *se_tpg = se_nacl->se_tpg;
>  	struct iscsi_node_acl *acl = container_of(se_nacl,
>  			struct iscsi_node_acl, se_node_acl);
>  	struct config_item *df_item;
> @@ -945,7 +944,7 @@ static void lio_target_drop_nodeacl(
>  	}
>  	kfree(stats_cg->default_groups);
>  
> -	core_tpg_del_initiator_node_acl(se_tpg, se_nacl, 1);
> +	core_tpg_del_initiator_node_acl(se_nacl);
>  }
>  
>  /* End items for lio_target_acl_cit */
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 6fabd9c..1078ee6 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -2126,7 +2126,7 @@ static struct se_node_acl *sbp_make_nodeacl(
>  
>  static void sbp_drop_nodeacl(struct se_node_acl *se_acl)
>  {
> -	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> +	core_tpg_del_initiator_node_acl(se_acl);
>  }
>  
>  static int sbp_post_link_lun(
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 6aaf50f..1233d04 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -402,13 +402,11 @@ EXPORT_SYMBOL(core_tpg_add_initiator_node_acl);
>   *
>   *
>   */
> -int core_tpg_del_initiator_node_acl(
> -	struct se_portal_group *tpg,
> -	struct se_node_acl *acl,
> -	int force)
> +int core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
>  {
>  	LIST_HEAD(sess_list);
>  	struct se_session *sess, *sess_tmp;
> +	struct se_portal_group *tpg = acl->se_tpg;
>  	unsigned long flags;
>  	int rc;
>  
> diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
> index 2a44ad6..171950b 100644
> --- a/drivers/target/tcm_fc/tfc_conf.c
> +++ b/drivers/target/tcm_fc/tfc_conf.c
> @@ -238,7 +238,7 @@ static void ft_del_acl(struct se_node_acl *se_acl)
>  	pr_debug("del acl %p se_acl %p tpg %p se_tpg %p\n",
>  		    acl, se_acl, tpg, &tpg->se_tpg);
>  
> -	core_tpg_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
> +	core_tpg_del_initiator_node_acl(se_acl);
>  }
>  
>  struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
> diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
> index 2cedb4b..ffbbed1 100644
> --- a/drivers/usb/gadget/tcm_usb_gadget.c
> +++ b/drivers/usb/gadget/tcm_usb_gadget.c
> @@ -1526,7 +1526,7 @@ static struct se_node_acl *usbg_make_nodeacl(
>  
>  static void usbg_drop_nodeacl(struct se_node_acl *se_acl)
>  {
> -	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> +	core_tpg_del_initiator_node_acl(se_acl);
>  }
>  
>  struct usbg_tpg *the_only_tpg_I_currently_have;
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index a93169b..96171db 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1687,7 +1687,7 @@ tcm_vhost_make_nodeacl(struct se_portal_group *se_tpg,
>  
>  static void tcm_vhost_drop_nodeacl(struct se_node_acl *se_acl)
>  {
> -	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> +	core_tpg_del_initiator_node_acl(se_acl);
>  }
>  
>  static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 0267780..35a77af 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -144,8 +144,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
>  void	core_tpg_clear_object_luns(struct se_portal_group *);
>  struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *,
>  		struct se_node_acl *, const char *, u32);
> -int	core_tpg_del_initiator_node_acl(struct se_portal_group *,
> -		struct se_node_acl *, int);
> +int	core_tpg_del_initiator_node_acl(struct se_node_acl *);
>  int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
>  		unsigned char *, u32, int);
>  int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
