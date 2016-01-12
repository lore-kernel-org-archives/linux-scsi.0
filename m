From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 3/4] target: Fix change depth se_session reference
	usage
Date: Tue, 12 Jan 2016 16:07:07 +0100
Message-ID: <20160112150707.GB2058@lst.de>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com> <1452457724-10629-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452457724-10629-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> -static int core_set_queue_depth_for_node(
> -	struct se_portal_group *tpg,
> -	struct se_node_acl *acl)
> +static void
> +target_set_nacl_queue_depth(struct se_portal_group *tpg,
> +			    struct se_node_acl *acl, u32 queue_depth)
>  {
> +	acl->queue_depth = queue_depth;
> +
>  	if (!acl->queue_depth) {
> -		pr_err("Queue depth for %s Initiator Node: %s is 0,"
> +		pr_warn("Queue depth for %s Initiator Node: %s is 0,"
>  			"defaulting to 1.\n", tpg->se_tpg_tfo->get_fabric_name(),
>  			acl->initiatorname);
>  		acl->queue_depth = 1;
>  	}
> -
> -	return 0;
>  }

These changes seem unrelated to the rest, care to explain them or
preferably split them out?

>  int core_tpg_set_initiator_node_queue_depth(
>  	struct se_portal_group *tpg,
> -	unsigned char *initiatorname,
> +	struct se_node_acl *acl,
>  	u32 queue_depth,
>  	int force)

please drop th force parameter as it's always 1.

>  {
> +	LIST_HEAD(sess_list);
> +	struct se_session *sess, *sess_tmp;
>  	unsigned long flags;
> +	int rc;
>  
> +	/*
> +	 * User has requested to change the queue depth for a Initiator Node.
> +	 * Change the value in the Node's struct se_node_acl, and call
> +	 * target_set_nacl_queue_depth() to set the new queue depth.
> +	 */
> +	target_set_nacl_queue_depth(tpg, acl, queue_depth);
>  
> +	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
> +	list_for_each_entry_safe(sess, sess_tmp, &acl->acl_sess_list,
> +				 sess_acl_list) {
> +		if (sess->sess_tearing_down != 0)
>  			continue;
>  
>  		if (!force) {
> @@ -401,71 +387,36 @@ int core_tpg_set_initiator_node_queue_depth(
>  				" operational.  To forcefully change the queue"
>  				" depth and force session reinstatement"
>  				" use the \"force=1\" parameter.\n",
> +				tpg->se_tpg_tfo->get_fabric_name(),
> +				acl->initiatorname);
> +			spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
>  			return -EEXIST;
>  		}
> +		if (!target_get_session(sess))
>  			continue;
> +		spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
>  
> +		 * Finally call tpg->se_tpg_tfo->close_session() to force session
> +		 * reinstatement to occur if there is an active session for the
> +		 * $FABRIC_MOD Initiator Node in question.
>  		 */
> +		rc = tpg->se_tpg_tfo->shutdown_session(sess);
> +		target_put_session(sess);
> +		if (!rc) {
> +			spin_lock_irqsave(&acl->nacl_sess_lock, flags);
> +			continue;
> +		}
> +		target_put_session(sess);
> +		spin_lock_irqsave(&acl->nacl_sess_lock, flags);
>  	}
> +	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);

It seems at thus point there is no need for ->shutdown_session, it
could be folded into ->close_session in a follow on patch.

> -void target_get_session(struct se_session *se_sess)
> +int target_get_session(struct se_session *se_sess)
>  {
> -	kref_get(&se_sess->sess_kref);
> +	return kref_get_unless_zero(&se_sess->sess_kref);
>  }
>  EXPORT_SYMBOL(target_get_session);

I'd be much happier to have a separate prep patch for this..
