From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] change scsi_cmd_ioctl to take a gendisk instead of a queue
Date: Sun, 1 Feb 2004 21:33:34 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201213334.A17988@infradead.org>
References: <20040201124803.A18050@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:44556 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265635AbUBAVdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 16:33:39 -0500
Content-Disposition: inline
In-Reply-To: <20040201124803.A18050@beaverton.ibm.com>; from patmans@us.ibm.com on Sun, Feb 01, 2004 at 12:48:03PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Sun, Feb 01, 2004 at 12:48:03PM -0800, Patrick Mansfield wrote:
> Jens or others, any comments?
> 
> This patch against a recent bk 2.6 changes scsi_cmd_ioctl to take a
> gendisk as an argument instead of a request_queue_t. This allows scsi char
> devices to use the scsi_cmd_ioctl interface.

Heh, I had pretty much the same patch in 2.5.  I don't rember why
I dropped it but you're looks at least as nice.

> If the scsi upper level scsi_cmd_ioctl usage were consolidated in
> scsi_prep_fn, we could pass a request_queue_t instead of a gendisk to
> scsi_cmd_ioctl.

I don't parse that.  You mean taking REQ_PC handling from upper drivers
to the scsi core?

> +int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
> +		 unsigned int offset)
> +{
> +	return __bio_add_page(bdev_get_queue(bio->bi_bdev), bio, page,
> +			      len, offset);
> +}

Maybe worth inlining in a header? 

