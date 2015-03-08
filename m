From: Christophe Vu-Brugier <cvubrugier@fastmail.fm>
Subject: Re: [PATCH 1/3] target: Add target_show_dynamic_sessions attribute
 helper
Date: Sun, 8 Mar 2015 21:38:58 +0100
Message-ID: <20150308213858.652137bb@trantor>
References: <1425706029-2436-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1425706029-2436-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas,

On Sat,  7 Mar 2015 05:27:07 +0000, Nicholas A. Bellinger wrote :
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new helper function that can be used by fabric
> driver TPG attributes for dumping the list of active sessions with a
> dynamically generated se_node_acl. (generate_node_acl=1).
> 
> It prints one se_node_acl->initiatorname per line, up to PAGE_SIZE
> which is due to the current limitiation of single page attribute
                                   ^
                              limitation

> output within sysfs and configfs code.
> 
> Note that if a session is referencing a explicit NodeACL, the
> InitiatorName will not appear within dynamic_sessions output.
> 
> Reported-by: Andy Grover <agrover@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_transport.c       | 24
> ++++++++++++++++++++++++ include/target/target_core_fabric.h
> |  1 + include/target/target_core_fabric_configfs.h |  5 +++++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/drivers/target/target_core_transport.c
> b/drivers/target/target_core_transport.c index 0adc0f6..e06c136 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -404,6 +404,30 @@ void target_put_session(struct se_session
> *se_sess) }
>  EXPORT_SYMBOL(target_put_session);
>  
> +ssize_t target_show_dynamic_sessions(struct se_portal_group *se_tpg,
> char *page) +{
> +	struct se_session *se_sess;
> +	ssize_t len = 0;
> +
> +	spin_lock_bh(&se_tpg->session_lock);
> +	list_for_each_entry(se_sess, &se_tpg->tpg_sess_list,
> sess_list) {
> +		if (!se_sess->se_node_acl)
> +			continue;
> +		if (!se_sess->se_node_acl->dynamic_node_acl)
> +			continue;
> +		if (strlen(se_sess->se_node_acl->initiatorname) + 1
> + len > PAGE_SIZE)
> +			break;
> +
> +		len += snprintf(page + len, PAGE_SIZE - len, "%s\n",
> +				se_sess->se_node_acl->initiatorname);
> +		len += 1; /* Include NULL terminator */

I don't understand why a NUL character is needed to separate the
initiator names. Maybe you want to put a NUL character at the end of
the string but I am not sure it is necessary (for instance
lio_target_nacl_show_info() does not do that).

With best regards,

> +	}
> +	spin_unlock_bh(&se_tpg->session_lock);
> +
> +	return len;
> +}
> +EXPORT_SYMBOL(target_show_dynamic_sessions);
> +
>  static void target_complete_nacl(struct kref *kref)
>  {
>  	struct se_node_acl *nacl = container_of(kref,
> diff --git a/include/target/target_core_fabric.h
> b/include/target/target_core_fabric.h index 22a4e98e..2f4a250 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -95,6 +95,7 @@ void	transport_register_session(struct
> se_portal_group *, struct se_node_acl *, struct se_session *, void *);
>  void	target_get_session(struct se_session *);
>  void	target_put_session(struct se_session *);
> +ssize_t	target_show_dynamic_sessions(struct se_portal_group
> *, char *); void	transport_free_session(struct se_session *);
>  void	target_put_nacl(struct se_node_acl *);
>  void	transport_deregister_session_configfs(struct se_session
> *); diff --git a/include/target/target_core_fabric_configfs.h
> b/include/target/target_core_fabric_configfs.h index b32a149..7a0649c
> 100644 --- a/include/target/target_core_fabric_configfs.h
> +++ b/include/target/target_core_fabric_configfs.h
> @@ -90,6 +90,11 @@ static struct target_fabric_tpg_attribute
> _fabric##_tpg_##_name =	\ _fabric##_tpg_store_##_name);
>  
>  
> +#define TF_TPG_BASE_ATTR_RO(_fabric,
> _name)				\ +static struct
> target_fabric_tpg_attribute _fabric##_tpg_##_name =	\
> +
> __CONFIGFS_EATTR_RO(_name,					\
> +	_fabric##_tpg_show_##_name);
> +
>  CONFIGFS_EATTR_STRUCT(target_fabric_wwn, target_fabric_configfs);
>  #define TF_WWN_ATTR(_fabric, _name,
> _mode)				\ static struct
> target_fabric_wwn_attribute _fabric##_wwn_##_name =	\


-- 
Christophe Vu-Brugier
