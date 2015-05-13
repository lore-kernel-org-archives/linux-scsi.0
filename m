From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/12] target: Convert transport_lookup_*_lun to RCU
	reader
Date: Wed, 13 May 2015 07:55:50 +0200
Message-ID: <20150513055550.GD20825@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431422736-29125-6-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> +	rcu_read_lock();
> +	deve = target_nacl_find_deve(nacl, unpacked_lun);
> +	if (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> +		/*
> +		 * Make sure that target_enable_device_list_for_node()
> +		 * has not already cleared the RCU protected pointers.
> +		 */
> +		if (!deve->se_lun) {

Just move the hlist_del_rcu in core_disable_device_list_for_node before
clearing se_lun and this check won't be needed.

And if you need ny check here just add it to the if so that there is
no need for the goto.  Same for the TMR path.

As for the locking changes:  I'd rather have the change to a mutex
as a separate patch as that's different from the data structure
changes.
