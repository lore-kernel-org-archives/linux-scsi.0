From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/4] ib_srpt: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Fri, 8 Jan 2016 09:52:43 +0100
Message-ID: <568F78DB.9090404@sandisk.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
 <1452237348-2277-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:9952
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750794AbcAHIww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jan 2016 03:52:52 -0500
In-Reply-To: <1452237348-2277-5-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 01/08/2016 08:15 AM, Nicholas A. Bellinger wrote:
> @@ -2574,24 +2558,18 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>
>   	pr_debug("registering session %s\n", ch->sess_name);
>
> -	nacl = srpt_lookup_acl(sport, ch->i_port_id);
> -	if (!nacl) {
> +	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name);
> +	if (!se_acl) {
>   		pr_info("Rejected login because no ACL has been"
>   			" configured yet for initiator %s.\n", ch->sess_name);
>   		rej->reason = cpu_to_be32(
> -			      SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
> +				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
> +		transport_free_session(ch->sess);
>   		goto destroy_ib;
>   	}
> +	ch->sess->se_node_acl = se_acl;

This is a backwards-incompatible change. Today the ib_srpt target driver 
accepts initiator port names with and without leading "0x". With this 
change the "0x" prefix becomes mandatory.

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
> index 5faad8ac..bb4fbe2 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -364,11 +364,9 @@ struct srpt_port {
>   	u16			sm_lid;
>   	u16			lid;
>   	union ib_gid		gid;
> -	spinlock_t		port_acl_lock;
>   	struct work_struct	work;
>   	struct se_portal_group	port_tpg_1;
>   	struct se_wwn		port_wwn;
> -	struct list_head	port_acl_list;
>   	struct srpt_port_attrib port_attrib;
>   };

With this patch applied the following srpt_node_acl members are no 
longer read: i_port_id, sport and list. Hence please remove the 
srpt_node_acl structure definition and use struct se_node_acl instead.

Thanks,

Bart.
