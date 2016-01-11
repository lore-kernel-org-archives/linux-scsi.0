From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v2 2/4] ib_srpt: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Mon, 11 Jan 2016 13:34:46 -0800
Message-ID: <56941FF6.5090003@sandisk.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
 <1452457724-10629-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0091.outbound.protection.outlook.com ([65.55.169.91]:63456
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759729AbcAKVgE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2016 16:36:04 -0500
In-Reply-To: <1452457724-10629-3-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 01/10/2016 12:28 PM, Nicholas A. Bellinger wrote:
> This patch does a simple conversion of ib_srpt code to use
> proper modern core_tpg_get_initiator_node_acl() lookup using
> se_node_acl->acl_kref, and drops the legacy internal list
> usage from srpt_lookup_acl().
> 
> This involves doing transport_init_session() earlier, and
> making sure transport_free_session() is called during
> a se_node_acl lookup failure to drop the last ->acl_kref.
> 
> Also, it adds a minor backwards-compat hack to avoid the
> potential for user-space wrt node-acl WWPN formatting by
> simply stripping off '0x' prefix from ch->sess_name, and
> retrying once if core_tpg_get_initiator_node_acl() fails.
> 
> Finally, go ahead and drop port_acl_list port_acl_lock
> since they are no longer used.

Hello Nic,

I think that you promised last week to remove the srpt_node_acl
structure (see also
http://thread.gmane.org/gmane.linux.scsi/109275/focus=2121617).
However, this patch doesn't remove that structure.

> -	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
> -	if (IS_ERR(ch->sess)) {
> +try_again:
> +	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, p);
> +	if (!se_acl) {
> +		pr_info("Rejected login because no ACL has been"
> +			" configured yet for initiator %s.\n", ch->sess_name);
> +		/*
> +		 * XXX: Hack to retry of ch->i_port_id without leading '0x'
> +		 */
> +		if (p == &ch->sess_name[0]) {
> +			p += 2;
> +			goto try_again;
> +		}
>   		rej->reason = cpu_to_be32(
> -			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
> -		pr_debug("Failed to create session\n");
> -		goto deregister_session;
> +				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
> +		transport_free_session(ch->sess);
> +		goto destroy_ib;
>   	}

The "goto try_again" statement is executed at most once. Since the above loop
can be unfolded with only a very minor code duplication I think it should
be unfolded, e.g. as follows:

	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name);
	if (!se_acl)
		se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name + strlen("0x"));
	if (!se_acl) {
		pr_info("Rejected login because no ACL has been"
			" configured yet for initiator %s.\n",
			ch->sess_name);
		[ ... ]
	}

Bart.
