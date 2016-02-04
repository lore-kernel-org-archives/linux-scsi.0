From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v3 06/14] ib_srpt: Convert to target_alloc_session usage
Date: Thu, 4 Feb 2016 14:14:52 -0800
Message-ID: <56B3CD5C.1050905@sandisk.com>
References: <1454137558-30396-1-git-send-email-nab@daterainc.com>
 <1454137558-30396-7-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454137558-30396-7-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 01/29/2016 11:05 PM, Nicholas A. Bellinger wrote:
>   try_again:
> -	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, p);
> -	if (!se_acl) {
> +	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
> +					TARGET_PROT_NORMAL, p, ch, NULL);
> +	if (IS_ERR(ch->sess)) {
>   		pr_info("Rejected login because no ACL has been"
> -			" configured yet for initiator %s.\n", ch->sess_name);
> +			" configured yet for initiator %s.\n", p);
>   		/*
>   		 * XXX: Hack to retry of ch->i_port_id without leading '0x'
>   		 */
> @@ -2426,14 +2418,11 @@ try_again:
>   			p += 2;
>   			goto try_again;
>   		}
> -		rej->reason = cpu_to_be32(
> +		rej->reason = cpu_to_be32((PTR_ERR(ch->sess) == -ENOMEM) ?
> +				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES :
>   				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);

Hello Nic,

The "no ACL has been configured yet" error message will be printed for 
initator ACLs that do not start with "0x" even if the second lookup 
succeeds. This will confuse users. Otherwise this patch looks fine to me.

Bart.
