From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 5/9] target: Convert se_portal_group->tpg_lun_list[]
	to RCU hlist
Date: Fri, 22 May 2015 10:31:13 +0200
Message-ID: <20150522083113.GC24640@lst.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com> <1432275071-28882-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432275071-28882-6-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Chris Boot <bootc@bootc.net>
List-Id: linux-scsi@vger.kernel.org

> This patch converts the fixed size se_portal_group->tpg_lun_list[]
> to use modern RCU with hlist_head in order to support an arbitary
> number of se_lun ports per target endpoint.
> 
> It includes dropping core_tpg_alloc_lun() from core_dev_add_lun(),
> and calling it directly from target_fabric_make_lun() to allocate
> a new se_lun.
> 
> Also add a new target_fabric_port_release() configfs item callback
> to invoke kfree_rcu() to release memory during se_lun->lun_group
> shutdown.
> 
> Also now that se_node_acl->lun_entry_hlist is using RCU, convert
> existing tpg_lun_lock to struct mutex so core_tpg_add_node_to_devs()
> can perform RCU updater logic without releasing ->tpg_lun_mutex.

Still doesn't explain why core_tpg_clear_object_luns also disappears.

> +	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
>  		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
>  			continue;

lun_status will always be active here as that's set and cleared at the
same time as the list addition / removal.  Which means that lun_status
should go away in this patch.
