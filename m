From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 4/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Wed, 13 Jan 2016 09:15:18 +0100
Message-ID: <20160113081518.GA12642@lst.de>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com> <1452457724-10629-5-git-send-email-nab@daterainc.com> <20160112150941.GC2058@lst.de> <1452672028.27508.40.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452672028.27508.40.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 12:00:28AM -0800, Nicholas A. Bellinger wrote:
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 52ae8ba..62f02ea 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -75,16 +75,9 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
>         unsigned char *initiatorname)
>  {
>         struct se_node_acl *acl;
> -       /*
> -        * Obtain the acl_kref now, which will be dropped upon the
> -        * release of se_sess memory within transport_free_session().
> -        */
> +
>         mutex_lock(&tpg->acl_node_mutex);
>         acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
> -       if (acl) {
> -               if (!kref_get_unless_zero(&acl->acl_kref))
> -                       acl = NULL;
> -       }

nah, please keep the kref_get_unless_zero here, it's needed.  It's
just the misleding comment I was complaining about :)

> @@ -3435,10 +3436,14 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
>  
>                         if ((tpg->tpg_attrib.generate_node_acls == 0) &&
>                             (tpg->tpg_attrib.demo_mode_discovery == 0) &&
> -                           (!core_tpg_get_initiator_node_acl(&tpg->tpg_se_tpg,
> -                               cmd->conn->sess->sess_ops->InitiatorName))) {
> +                           (!(se_acl = core_tpg_get_initiator_node_acl(&tpg->tpg_se_tpg,
> +                               cmd->conn->sess->sess_ops->InitiatorName)))) {
>                                 continue;
>                         }
> +                       if (se_acl) {
> +                               target_put_nacl(se_acl);
> +                               se_acl = NULL;
> +                       }


Seems like with the current code we don't need to keep the ACL,
so a new helper like:

bool target_tpg_has_node_acl(struct se_portal_group *tpg,
	const char *initiatorname)
{
	struct se_node_acl *acl;

	acl = core_tpg_get_initiator_node_acl(tpg, initiatorname);
	if (acl) {
		target_put_nacl(se_acl);
		return true;
	}

	return false;
}

or fully open coded as:

bool target_tpg_has_node_acl(struct se_portal_group *tpg,
		 const char *initiatorname)
{
	struct se_node_acl *acl;
	bool found = false;

	mutex_lock(&tpg->acl_node_mutex);
	list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
		if (!strcmp(acl->initiatorname, initiatorname)) {
			found = true;
			break;
		}
	}
	mutex_unlock(&tpg->acl_node_mutex);

	return found;
}

might be better to keep the code readable.
