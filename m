From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 10/11] block: add a report_zones method
Date: Wed, 10 Oct 2018 10:15:19 -0400
Message-ID: <20181010141518.GA9454@redhat.com>
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

I like that this patch removes the need for endio from dm-linear, etc.
Very welcomed.

> ---
>  block/blk-core.c               |   1 -
>  block/blk-mq-debugfs.c         |   1 -
>  block/blk-zoned.c              | 164 ++++++++++-----------------------
>  drivers/block/null_blk.h       |  11 ++-
>  drivers/block/null_blk_main.c  |  23 +----
>  drivers/block/null_blk_zoned.c |  57 +++---------
>  drivers/md/dm-flakey.c         |  28 ++++--
>  drivers/md/dm-linear.c         |  31 ++++---
>  drivers/md/dm.c                | 150 ++++++++++++++++--------------

<snip>

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 20f7e4ef5342..e9fb3c706ef6 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1156,79 +1203,48 @@ EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
>  
>  /*
>   * The zone descriptors obtained with a zone report indicate
> - * zone positions within the target device. The zone descriptors
> - * must be remapped to match their position within the dm device.
> - * A target may call dm_remap_zone_report after completion of a
> - * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
> - * from the target device mapping to the dm device.
> + * zone positions within the underlying device of the target. The zone
> + * descriptors must be remapped to match their position within the dm device.
> + * The caller target should obtain the zones information using
> + * blkdev_report_zones() to ensure that remapping for partition offset is
> + * already handled.
>   */
> -void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
> +void dm_remap_zone_report(struct dm_target *ti, sector_t start,
> +			  struct blk_zone *zones, unsigned int *nr_zones)
>  {
>  #ifdef CONFIG_BLK_DEV_ZONED
> -	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
> -	struct bio *report_bio = tio->io->orig_bio;
> -	struct blk_zone_report_hdr *hdr = NULL;
>  	struct blk_zone *zone;
> -	unsigned int nr_rep = 0;
> -	unsigned int ofst;
> -	struct bio_vec bvec;
> -	struct bvec_iter iter;
> -	void *addr;
> -
> -	if (bio->bi_status)
> -		return;
> +	unsigned int nrz = *nr_zones;
> +	int i;
>  
>  	/*
> -	 * Remap the start sector of the reported zones. For sequential zones,
> -	 * also remap the write pointer position.
> +	 * Remap the start sector and write pointer position of the zones in
> +	 * the array. Since we may have obtained from the target underlying
> +	 * device more zones that the target size, also adjust the number
> +	 * of zones.
>  	 */
> -	bio_for_each_segment(bvec, report_bio, iter) {
> -		addr = kmap_atomic(bvec.bv_page);
> -
> -		/* Remember the report header in the first page */
> -		if (!hdr) {
> -			hdr = addr;
> -			ofst = sizeof(struct blk_zone_report_hdr);
> -		} else
> -			ofst = 0;
> -
> -		/* Set zones start sector */
> -		while (hdr->nr_zones && ofst < bvec.bv_len) {
> -			zone = addr + ofst;
> -			if (zone->start >= start + ti->len) {
> -				hdr->nr_zones = 0;
> -				break;
> -			}
> -			zone->start = zone->start + ti->begin - start;
> -			if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
> -				if (zone->cond == BLK_ZONE_COND_FULL)
> -					zone->wp = zone->start + zone->len;
> -				else if (zone->cond == BLK_ZONE_COND_EMPTY)
> -					zone->wp = zone->start;
> -				else
> -					zone->wp = zone->wp + ti->begin - start;
> -			}
> -			ofst += sizeof(struct blk_zone);
> -			hdr->nr_zones--;
> -			nr_rep++;
> +	for (i = 0; i < nrz; i++) {
> +		zone = zones + i;
> +		if (zone->start >= start + ti->len) {
> +			memset(zone, 0, sizeof(struct blk_zone) * (nrz - i));
> +			break;
>  		}
>  
> -		if (addr != hdr)
> -			kunmap_atomic(addr);
> -
> -		if (!hdr->nr_zones)
> -			break;
> -	}
> +		zone->start = zone->start + ti->begin - start;
> +		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
> +			continue;
>  
> -	if (hdr) {
> -		hdr->nr_zones = nr_rep;
> -		kunmap_atomic(hdr);
> +		if (zone->cond == BLK_ZONE_COND_FULL)
> +			zone->wp = zone->start + zone->len;
> +		else if (zone->cond == BLK_ZONE_COND_EMPTY)
> +			zone->wp = zone->start;
> +		else
> +			zone->wp = zone->wp + ti->begin - start;
>  	}
>  
> -	bio_advance(report_bio, report_bio->bi_iter.bi_size);
> -
> +	*nr_zones = i;
>  #else /* !CONFIG_BLK_DEV_ZONED */
> -	bio->bi_status = BLK_STS_NOTSUPP;
> +	*nr_zones = 0;
>  #endif
>  }
>  EXPORT_SYMBOL_GPL(dm_remap_zone_report);

Doesn't this hunk need to get rebased given your latest <= 4.19 stable@
fix?  I've also tweaked that fix slightly to avoid line wrapping, I'm
more relaxed about that aspect of code-style if it helps readability.
Please rebase ontop of:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.19&id=9864cd5dc54cade89fd4b0954c2e522841aa247c

I'll be sending this to gregkh in the last dm pull for 4.19 final today
or tomorrow.

Thanks,
Mike
