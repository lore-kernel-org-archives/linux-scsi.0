From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/6] block: Introduce copy offload library function
Date: Mon, 02 Jun 2014 13:40:46 -0700
Message-ID: <1401741646.32085.3.camel@haakon3.risingtidesystems.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	 <1401335565-29865-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48633 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaFBUkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:40:47 -0400
In-Reply-To: <1401335565-29865-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 23:52 -0400, Martin K. Petersen wrote:
> blkdev_issue_copy() is a library function that filesystems can use to
> clone block ranges between devices that support copy offloading. Both
> source and target device must have max_copy_sectors > 0 in the queue
> limits.
> 
> blkdev_issue_copy() will iterate over the blocks in the source range and
> issue copy offload requests using the granularity preferred by source
> and target.
> 
> There is no guarantee that a copy offload operation will be successful
> even if both devices are offload-capable. Filesystems must be prepared
> to manually copy or punt to userland if the operation fails.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/blk-lib.c        | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h |  2 ++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 97a733cf3d5f..5a0afc6e933e 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -305,3 +305,88 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
>  }
>  EXPORT_SYMBOL(blkdev_issue_zeroout);
> +
> +/**
> + * blkdev_issue_copy - queue a copy same operation
> + * @src_bdev:	source blockdev
> + * @src_sector:	source sector
> + * @dst_bdev:	destination blockdev
> + * @dst_sector: destination sector
> + * @nr_sects:	number of sectors to copy
> + * @gfp_mask:	memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *    Copy a block range from source device to target device.
> + */
> +int blkdev_issue_copy(struct block_device *src_bdev, sector_t src_sector,
> +		      struct block_device *dst_bdev, sector_t dst_sector,
> +		      unsigned int nr_sects, gfp_t gfp_mask)
> +{
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct request_queue *sq = bdev_get_queue(src_bdev);
> +	struct request_queue *dq = bdev_get_queue(dst_bdev);
> +	unsigned int max_copy_sectors;
> +	struct bio_batch bb;
> +	int ret = 0;
> +
> +	if (!sq || !dq)
> +		return -ENXIO;
> +
> +	max_copy_sectors = min(sq->limits.max_copy_sectors,
> +			       dq->limits.max_copy_sectors);
> +
> +	if (max_copy_sectors == 0)
> +		return -EOPNOTSUPP;
> +
> +	atomic_set(&bb.done, 1);
> +	bb.flags = 1 << BIO_UPTODATE;
> +	bb.wait = &wait;
> +
> +	while (nr_sects) {
> +		struct bio *bio;
> +		struct bio_copy *bc;
> +		unsigned int chunk;
> +
> +		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
> +		if (!bc) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		bio = bio_alloc(gfp_mask, 1);
> +		if (!bio) {
> +			kfree(bc);
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		chunk = min(nr_sects, max_copy_sectors);
> +
> +		bio->bi_iter.bi_sector = dst_sector;
> +		bio->bi_iter.bi_size = chunk << 9;
> +		bio->bi_end_io = bio_batch_end_io;
> +		bio->bi_bdev = dst_bdev;
> +		bio->bi_private = &bb;
> +		bio->bi_special.copy = bc;
> +
> +		bc->bic_bdev = src_bdev;
> +		bc->bic_sector = src_sector;
> +
> +		atomic_inc(&bb.done);
> +		submit_bio(REQ_WRITE | REQ_COPY, bio);
> +
> +		src_sector += chunk;
> +		dst_sector += chunk;
> +		nr_sects -= chunk;
> +	}
> +
> +	/* Wait for bios in-flight */
> +	if (!atomic_dec_and_test(&bb.done))
> +		wait_for_completion_io(&wait);
> +
> +	if (!test_bit(BIO_UPTODATE, &bb.flags))
> +		ret = -ENOTSUPP;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(blkdev_issue_copy);

Mmmm, where does *bc memory get released in the normal bio completion
path..?

--nab

