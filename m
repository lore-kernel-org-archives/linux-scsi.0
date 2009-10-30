From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: Expose discard granularity
Date: Fri, 30 Oct 2009 01:07:19 -0400
Message-ID: <20091030050719.GD17714@infradead.org>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com> <1256873409-12668-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZJ3FHR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 01:07:17 -0400
Content-Disposition: inline
In-Reply-To: <1256873409-12668-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, Oct 29, 2009 at 11:30:08PM -0400, Martin K. Petersen wrote:
> + * blk_queue_discard_granularity - set minimum size for discard requests
> + * @q:	the request queue for the device
> + * @gran:  the smallest unit the device can discard (in bytes)
> + *
> + * Description:
> + */
> +void blk_queue_discard_granularity(struct request_queue *q, unsigned int gran)
> +{
> +	q->limits.discard_granularity = gran;
> +}
> +EXPORT_SYMBOL(blk_queue_discard_granularity);
> +

> +static inline unsigned int queue_discard_granularity(struct request_queue *q)
> +{
> +	return q->limits.discard_granularity;
> +}
> +
> +static inline unsigned int queue_max_discard_sectors(struct request_queue *q)
> +{
> +	return q->limits.max_discard_sectors;
> +}
> +


Btw, I really hate these wrapper, they make followign the code much
harder.  Already annoyed me for the I/O topology bits.

