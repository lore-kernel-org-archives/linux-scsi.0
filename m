From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 10/11] block: add a report_zones method
Date: Wed, 10 Oct 2018 11:34:54 -0400
Message-ID: <20181010153453.GA9724@redhat.com>
References: <20181010015239.24930-1-damien.lemoal@wdc.com>
	<20181010015239.24930-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010015239.24930-11-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 09 2018 at  9:52pm -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> Dispatching a report zones command through the request queue is a major
> pain due to the command reply payload rewriting necessary. Given that
> blkdev_report_zones() is executing everything synchronously, implement
> report zones as a block device file operation instead, allowing major
> simplification of the code in many places.
> 
> sd, null-blk, dm-linear and dm-flakey being the only block device
> drivers supporting exposing zoned block devices, these drivers are
> modified to provide the device side implementation of the
> report_zones() block device file operation.
> 
> For dm-linear and dm-flakey, a new report_zones() target type operation
> is defined so that the upper block layer call can be propagated down to
> the underlying devices of the dm targets.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [Damien]
> * Changed method block_device argument to gendisk
> * Various bug fixes and improvements
> * Added support for null_blk, dm-linear and dm-flakey.
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
...
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c24969b1741b..d183c10872b7 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -396,11 +396,6 @@ struct queue_limits {
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
>  
> -struct blk_zone_report_hdr {
> -	unsigned int	nr_zones;
> -	u8		padding[60];
> -};
> -
>  extern unsigned int blkdev_nr_zones(struct block_device *bdev);
>  extern int blkdev_report_zones(struct block_device *bdev,
>  			       sector_t sector, struct blk_zone *zones,
> @@ -1992,6 +1987,9 @@ struct block_device_operations {
>  	int (*getgeo)(struct block_device *, struct hd_geometry *);
>  	/* this callback is with swap_lock and sometimes page table lock held */
>  	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
> +	int (*report_zones)(struct gendisk *, sector_t sector,
> +			    struct blk_zone *zones, unsigned int *nr_zones,
> +			    gfp_t gfp_mask);
>  	struct module *owner;
>  	const struct pr_ops *pr_ops;
>  };

Should this new 'report_zones' method be wrapped with #ifdef
CONFIG_BLK_DEV_ZONED?

Mike
