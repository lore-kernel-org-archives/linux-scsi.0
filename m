From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] target: Send UA when changing LUN inventory
Date: Fri, 19 Jun 2015 15:07:34 +0200
Message-ID: <20150619130733.GC7783@lst.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60730 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbbFSNHf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 09:07:35 -0400
Content-Disposition: inline
In-Reply-To: <1434009689-112909-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

> +		hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
> +			if (tmp == new)
> +				continue;
> +			core_scsi3_ua_allocate(tmp, 0x3F,
> +				ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
> +		}
> +		rcu_read_unlock();
> +

> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
> +		if (tmp == new)
> +			continue;
> +		core_scsi3_ua_allocate(tmp, 0x3F,
> +			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
> +	}
> +	rcu_read_unlock();

> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link)
> +		core_scsi3_ua_allocate(tmp, 0x3F,
> +			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
> +	rcu_read_unlock();

Please add a helper instead of duplicating this three times.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
