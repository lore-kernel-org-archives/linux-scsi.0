From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 30/32] target: Change nacl's session refcount to use
 existing refcount
Date: Mon, 16 Dec 2013 14:01:02 -0800
Message-ID: <1387231262.20247.256.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-31-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-31-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> core_tpg_del_initiator_node_acl is now safe to call with spinlocks, since
> it no longer potentially sleeps.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_tpg.c       |   10 ----------
>  drivers/target/target_core_transport.c |   17 ++---------------
>  include/target/target_core_base.h      |    2 --
>  include/target/target_core_fabric.h    |    1 -
>  4 files changed, 2 insertions(+), 28 deletions(-)
> 

Ignoring, given the other NAKs.

--nab

> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 1233d04..30af019 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -247,8 +247,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>  
>  	INIT_LIST_HEAD(&acl->acl_node);
>  	INIT_LIST_HEAD(&acl->acl_sess_list);
> -	kref_init(&acl->acl_kref);
> -	init_completion(&acl->acl_free_comp);
>  	spin_lock_init(&acl->device_list_lock);
>  	spin_lock_init(&acl->nacl_sess_lock);
>  	kref_init(&acl->refcount);
> @@ -363,8 +361,6 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
>  
>  	INIT_LIST_HEAD(&acl->acl_node);
>  	INIT_LIST_HEAD(&acl->acl_sess_list);
> -	kref_init(&acl->acl_kref);
> -	init_completion(&acl->acl_free_comp);
>  	spin_lock_init(&acl->device_list_lock);
>  	spin_lock_init(&acl->nacl_sess_lock);
>  	kref_init(&acl->refcount);
> @@ -440,12 +436,6 @@ int core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
>  			continue;
>  		target_put_session(sess);
>  	}
> -	target_put_nacl(acl);
> -	/*
> -	 * Wait for last target_put_nacl() to complete in target_complete_nacl()
> -	 * for active fabric session transport_deregister_session() callbacks.
> -	 */
> -	wait_for_completion(&acl->acl_free_comp);
>  
>  	put_nacl(acl);
>  
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 51e294b..e5e054e 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -311,7 +311,7 @@ void __transport_register_session(
>  					&buf[0], PR_REG_ISID_LEN);
>  			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
>  		}
> -		kref_get(&se_nacl->acl_kref);
> +		get_nacl(se_nacl);
>  
>  		spin_lock_irq(&se_nacl->nacl_sess_lock);
>  		/*
> @@ -372,19 +372,6 @@ void target_put_session(struct se_session *se_sess)
>  }
>  EXPORT_SYMBOL(target_put_session);
>  
> -static void target_complete_nacl(struct kref *kref)
> -{
> -	struct se_node_acl *nacl = container_of(kref,
> -				struct se_node_acl, acl_kref);
> -
> -	complete(&nacl->acl_free_comp);
> -}
> -
> -void target_put_nacl(struct se_node_acl *nacl)
> -{
> -	kref_put(&nacl->acl_kref, target_complete_nacl);
> -}
> -
>  void transport_deregister_session_configfs(struct se_session *se_sess)
>  {
>  	struct se_node_acl *se_nacl;
> @@ -471,7 +458,7 @@ void transport_deregister_session(struct se_session *se_sess)
>  	 * removal context.
>  	 */
>  	if (se_nacl)
> -		target_put_nacl(se_nacl);
> +		put_nacl(se_nacl);
>  
>  	transport_free_session(se_sess);
>  }
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 393bcfd..08ecfed 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -527,8 +527,6 @@ struct se_node_acl {
>  	struct config_group	*acl_default_groups[5];
>  	struct list_head	acl_node;
>  	struct list_head	acl_sess_list;
> -	struct completion	acl_free_comp;
> -	struct kref		acl_kref;
>  };
>  
>  struct se_session {
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 35a77af..c6b9303 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -94,7 +94,6 @@ void	transport_register_session(struct se_portal_group *,
>  void	target_get_session(struct se_session *);
>  void	target_put_session(struct se_session *);
>  void	transport_free_session(struct se_session *);
> -void	target_put_nacl(struct se_node_acl *);
>  void	transport_deregister_session_configfs(struct se_session *);
>  void	transport_deregister_session(struct se_session *);
>  
