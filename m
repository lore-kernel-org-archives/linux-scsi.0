From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Wed, 8 Feb 2012 17:50:23 -0500
Message-ID: <20120208225023.GA16401@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab2BHWu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2012 17:50:29 -0500
Content-Disposition: inline
In-Reply-To: <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

On Mon, Jan 30 2012 at  7:31pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> The WRITE SAME command supported on some SCSI devices allows the same
> block to be efficiently replicated throughout a block range. Only a
> single logical block is transferred from the host and the storage device
> writes the same data to all blocks described by the I/O.
> 
> This patch implements support for WRITE SAME in the block layer. The
> blkdev_issue_write_same() function can be used by filesystems and block
> drivers to replicate a buffer across a block range. This can be used to
> efficiently initialize software RAID devices, etc.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

...

> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 2b461b4..19f4754 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -115,6 +115,85 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  EXPORT_SYMBOL(blkdev_issue_discard);
>  
>  /**
> + * blkdev_issue_write_same - queue a write same operation
> + * @bdev:	target blockdev
> + * @sector:	start sector
> + * @nr_sects:	number of sectors to write
> + * @gfp_mask:	memory allocation flags (for bio_alloc)
> + * @buffer:	pointer to buffer containing data to write
> + * @length:	buffer length. Must be equal to bdev logical block size.
> + *
> + * Description:
> + *    Issue a write same request for the sectors in question.
> + */
> +int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
> +			    sector_t nr_sects, gfp_t gfp_mask, void *buffer,
> +			    unsigned int length)
> +{
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	unsigned int max_write_same_sectors;
> +	struct bio_batch bb;
> +	struct bio *bio;
> +	int ret = 0;
> +
> +	if (!q)
> +		return -ENXIO;
> +
> +	max_write_same_sectors = q->limits.max_write_same_sectors;
> +
> +	if (max_write_same_sectors == 0)
> +		return -EOPNOTSUPP;
> +
> +	BUG_ON(length != bdev_logical_block_size(bdev));

Why require @length to be passed in if we can easily determine the only
correct length, via bdev_logical_block_size, locally?

Mike
