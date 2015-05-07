From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 10/17] scsi_dh_alua: Use separate alua_port_group structure
Date: Thu, 7 May 2015 14:34:32 +0200
Message-ID: <554B5BD8.2090605@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0070.outbound.protection.outlook.com ([207.46.100.70]:59949
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750876AbbEGMej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 08:34:39 -0400
In-Reply-To: <1430743343-47174-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> +static void release_port_group(struct kref *kref)
> +{
> +	struct alua_port_group *pg;
> +
> +	pg = container_of(kref, struct alua_port_group, kref);
> +	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id);

Does this really need to be a warning ?

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
> +	pg->group_id = group_id;
> +	pg->buff = pg->inq;
> +	pg->bufflen = ALUA_INQUIRY_SIZE;
> +	pg->tpgs = h->tpgs;
> +	pg->state = TPGS_STATE_OPTIMIZED;
> +	kref_init(&pg->kref);
> +	list_add(&pg->node, &port_group_list);
> +	h->pg = pg;
> +	spin_unlock(&port_group_lock);

Sorry but it's not clear to me why the kzalloc() statement happens under 
port_group_lock. Please consider to perform only the list_add() 
statement under port_group_lock, to perform all other assignments 
without holding that lock and to change GFP_ATOMIC into GFP_KERNEL.

> -	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
> -		(h->buff[2] << 8) + h->buff[3] + 4;
> +	len = (pg->buff[0] << 24) + (pg->buff[1] << 16) +
> +		(pg->buff[2] << 8) + pg->buff[3] + 4;

Has it been considered to use get_unaligned_be32() instead ?

Bart.
