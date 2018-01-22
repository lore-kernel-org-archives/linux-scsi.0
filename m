From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Mon, 22 Jan 2018 08:32:42 -0800
Message-ID: <20180122163242.GB23984@infradead.org>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45431 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeAVQco (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 11:32:44 -0500
Content-Disposition: inline
In-Reply-To: <20180122033550.27855-2-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

> -		if (ret == BLK_STS_RESOURCE) {
> +		if ((ret == BLK_STS_RESOURCE) || (ret == BLK_STS_DEV_RESOURCE)) {

No need for the inner braces here.

> +	if ((ret == BLK_STS_RESOURCE) || (ret == BLK_STS_DEV_RESOURCE))

Same here.

> +/*
> + * This status is returned from driver to block layer if device related
> + * resource is run out of, but driver can guarantee that IO dispatch is
> + * triggered in future when the resource is available.
> + */
> +#define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)

We'll need some good explanation on BLK_STS_RESOURCE vs
BLK_STS_DEV_RESOURCE I think.

Except for these nitpicks this looks fine to me.
