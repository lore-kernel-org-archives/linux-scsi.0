From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/23] scsi_dh_alua: use unique device id
Date: Tue, 1 Sep 2015 12:25:32 +0200
Message-ID: <20150901102532.GE9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34638 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbbIAKZe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:25:34 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-18-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

> +		 * Internal error: TPGS supported by no
> +		 * device identifcation found.
> +		 * Disable ALUA support.

s/by/but/

Also I think the comment could fit into two lines if you try :)

> +	spin_lock(&port_group_lock);
> +	list_for_each_entry(tmp_pg, &port_group_list, node) {
> +		if (tmp_pg->group_id != group_id)
> +			continue;
> +		if (tmp_pg->device_id_size != device_id_size)
> +			continue;
> +		if (strncmp(tmp_pg->device_id_str, device_id_str,
> +			    device_id_size))
> +			continue;
> +		h->pg = tmp_pg;
> +		kref_get(&tmp_pg->kref);
> +		break;
> +	}
> +	spin_unlock(&port_group_lock);

This exact code appears twice in this patch, please factor it into
a helper.

> +	if (device_id_size)
> +		strncpy(pg->device_id_str, device_id_str, 256);
> +	else
> +		pg->device_id_str[0] = '\0';
> +

How could we end up with a zero device ID length?  Shouldn't
have error out earlier on that?

> +	 * Re-check list again to catch
> +	 * concurrent updates
> +	 */

Could fit onto one line..
