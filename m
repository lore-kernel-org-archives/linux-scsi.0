From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/12] target: Convert se_portal_group->tpg_lun_list[]
	to RCU hlist
Date: Tue, 19 May 2015 08:46:12 +0200
Message-ID: <20150519064612.GA30172@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-10-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431422736-29125-10-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2015 at 09:25:33AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts the fixed size se_portal_group->tpg_lun_list[]
> to use modern RCU with hlist_head in order to support an arbitary
> number of se_lun ports per target endpoint.
> 
> It includes dropping core_tpg_alloc_lun() from core_dev_add_lun(),
> and calling it directly from target_fabric_make_lun() to allocate
> a new se_lun.
> 
> Also add a new target_fabric_port_release() configfs item callback
> to invoke call_rcu() to release memory during se_lun->lun_group
> shutdown.
> 
> Also now that se_node_acl->lun_entry_hlist is using RCU, convert
> existing tpg_lun_lock to struct mutex so core_tpg_add_node_to_devs()
> can perform RCU updater logic without releasing ->tpg_lun_mutex.

FYI, you can also kill ->lun_status with this as only allocated
se_lun structures will ever be on the list.
