From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/17] scsi_dh_alua: Use separate alua_port_group
	structure
Date: Mon, 11 May 2015 14:32:35 +0200
Message-ID: <20150511123235.GC5732@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40218 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbbEKMch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 08:32:37 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:16PM +0200, Hannes Reinecke wrote:
> The port group needs to be a separate structure as several
> LUNs might belong to the same group.

The switch to on-stack sense data in alua_rtpg probably should be
a separate patch.

> -static int realloc_buffer(struct alua_dh_data *h, unsigned len)
> +static int realloc_buffer(struct alua_port_group *pg, unsigned len)
>  {

Not directly related to this patch, but what's the reason to have
a buffer hang off the dh_data or now port group?  Seems like a local
allocation in alua_rtpg would be more sensible.

> +	spin_lock(&port_group_lock);
> +	pg = kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
> +	if (!pg) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "%s: kzalloc port group failed\n",
> +			    ALUA_DH_NAME);
> +		/* Temporary failure, bypass */
> +		spin_unlock(&port_group_lock);
> +		return SCSI_DH_DEV_TEMP_BUSY;
> +	}

As bart mentioned it should be simply enough to move the allocation
and initialization outside the spinlock.  
