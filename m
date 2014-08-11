From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 3/4] Introduce XEN scsiback module
Date: Mon, 11 Aug 2014 11:14:36 -0700
Message-ID: <20140811181436.GA14313@infradead.org>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>
 <1407484194-31876-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaHKSOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2014 14:14:40 -0400
Content-Disposition: inline
In-Reply-To: <1407484194-31876-4-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com

> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>

What do you need these for?  Normally target drivers shouldn't need
these.

> +struct vscsibk_emulate {
> +	void (*pre_function)(struct vscsibk_pend *, void *);
> +	void (*post_function)(struct vscsibk_pend *, void *);
> +};

This doesn't seem to be used.

> +#define scsiback_get(_b) (atomic_inc(&(_b)->nr_unreplied_reqs))
> +#define scsiback_put(_b)				\
> +	do {						\
> +		if (atomic_dec_and_test(&(_b)->nr_unreplied_reqs))	\
> +			wake_up(&(_b)->waiting_to_free);\
> +	} while (0)

Normal Linux style would be to make these inline functions.

> +static void scsiback_notify_work(struct vscsibk_info *info)
> +{
> +	info->waiting_reqs = 1;
> +	wake_up(&info->wq);
> +}
> +
> +static irqreturn_t scsiback_intr(int irq, void *dev_id)
> +{
> +	scsiback_notify_work((struct vscsibk_info *)dev_id);
> +	return IRQ_HANDLED;
> +}

Seems like this driver should get the same threaded irq treatment as
the initiator side?

> +static void scsiback_disconnect(struct vscsibk_info *info)
> +{
> +	if (info->kthread) {
> +		kthread_stop(info->kthread);
> +		info->kthread = NULL;
> +		wake_up(&info->shutdown_wq);
> +	}
> +
> +	wait_event(info->waiting_to_free,
> +		atomic_read(&info->nr_unreplied_reqs) == 0);
> +
> +	if (info->irq) {
> +		unbind_from_irqhandler(info->irq, info);
> +		info->irq = 0;
> +	}
> +
> +	if (info->ring.sring) {
> +		xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
> +		info->ring.sring = NULL;
> +	}
> +}

Also the same treatment for goto based init failure unwinding.

