From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 07/16] scsi_dh_alua: Use separate alua_port_group structure
Date: Fri, 14 Feb 2014 12:56:15 +0100
Message-ID: <52FE045F.8050603@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:58831 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749AbaBNL4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 06:56:20 -0500
In-Reply-To: <1391160600-19652-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> +static void release_port_group(struct kref *kref)
> +{
> +	struct alua_port_group *pg;
> +
> +	pg = container_of(kref, struct alua_port_group, kref);
> +	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id);
> +	spin_lock(&port_group_lock);
> +	list_del(&pg->node);
> +	spin_unlock(&port_group_lock);
> +	if (pg->buff && pg->inq != pg->buff)
> +		kfree(pg->buff);
> +	kfree(pg);
> +}

Does that message really need level "WARNING" ?

> +	sdev_printk(KERN_INFO, sdev,
> +		    "%s: port group %02x rel port %02x\n",
> +		    ALUA_DH_NAME, group_id, h->rel_port);
> +	spin_lock(&port_group_lock);
> +	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
> +	if (!pg) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "%s: kzalloc port group failed\n",
> +			    ALUA_DH_NAME);
> +		/* Temporary failure, bypass */
> +		spin_unlock(&port_group_lock);
> +		err = SCSI_DH_DEV_TEMP_BUSY;
> +		goto out;
> +	}
> +	pg->group_id = group_id;
> +	pg->buff = pg->inq;
> +	pg->bufflen = ALUA_INQUIRY_SIZE;
> +	pg->tpgs = h->tpgs;
> +	pg->state = TPGS_STATE_OPTIMIZED;
> +	pg->flags = h->flags;
> +	kref_init(&pg->kref);
> +	list_add(&pg->node, &port_group_list);
> +	h->pg = pg;
> +	spin_unlock(&port_group_lock);
> +	err = SCSI_DH_OK;

A GFP_KERNEL allocation with a spin lock held ?? Please move that
allocation outside the critical section and also the code for
initializing *pg. What's not clear to me is why no uniqueness check is
performed before invoking list_add() ? Does that mean that information
for the same port group ID can end up multiple times in the
port_group_list ? Such a uniqueness check can only be performed if a
storage array identification is available so patches 07 and 08 may have
to be swapped.

Bart.
