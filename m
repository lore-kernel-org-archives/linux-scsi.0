From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for se_dev_entry->pr_reg
 reservation check
Date: Fri, 22 May 2015 12:12:23 +0200
Message-ID: <555F0107.6030102@sandisk.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
 <1432275071-28882-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432275071-28882-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/15 08:11, Nicholas A. Bellinger wrote:
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index e2c0eaf..def5bc8 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -638,7 +638,6 @@ struct se_lun_acl {
>   };
>
>   struct se_dev_entry {
> -	bool			def_pr_registered;
>   	/* See transport_lunflags_table */
>   	u32			lun_flags;
>   	u32			mapped_lun;
> @@ -655,7 +654,8 @@ struct se_dev_entry {
>   	struct se_node_acl	*se_node_acl;
>   	struct se_lun_acl __rcu	*se_lun_acl;
>   	spinlock_t		ua_lock;
> -	struct se_lun		*se_lun;
> +	struct se_lun __rcu	*se_lun;
> +	unsigned long		pr_reg;
>   	struct list_head	alua_port_list;
>   	struct list_head	ua_list;
>   	struct hlist_node	link;

Hello Nic,

This change causes the "se_lun = deve->se_lun" assignment in 
transport_lookup_cmd_lun() to assign an RCU pointer to a non-RCU 
pointer. Shouldn't such an assignment be protected via rcu_dereference() ?

Thanks,

Bart.
