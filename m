From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 11/11] block: Introduce
	blk_revalidate_disk_zones()
Date: Tue, 16 Oct 2018 11:17:58 -0400
Message-ID: <20181016151758.GB26807@redhat.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-12-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181012100850.23316-12-damien.lemoal@wdc.com>
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

On Fri, Oct 12 2018 at  6:08am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> Drivers exposing zoned block devices have to initialize and maintain
> correctness (i.e. revalidate) of the device zone bitmaps attached to
> the device request queue (seq_zones_bitmap and seq_zones_wlock).
> 
> To simplify coding this, introduce a generic helper function
> blk_revalidate_disk_zones() suitable for most (and likely all) cases.
> This new function always update the seq_zones_bitmap and seq_zones_wlock
> bitmaps as well as the queue nr_zones field when called for a disk
> using a request based queue. For a disk using a BIO based queue, only
> the number of zones is updated since these queues do not have
> schedulers and so do not need the zone bitmaps.
> 
> With this change, the zone bitmap initialization code in sd_zbc.c can be
> replaced with a call to this function in sd_zbc_read_zones(), which is
> called from the disk revalidate block operation method.
> 
> A call to blk_revalidate_disk_zones() is also added to the null_blk
> driver for devices created with the zoned mode enabled.
> 
> Finally, to ensure that zoned devices created with dm-linear or
> dm-flakey expose the correct number of zones through sysfs, a call to
> blk_revalidate_disk_zones() is added to dm_table_set_restrictions().
> 
> The zone bitmaps allocated and initialized with
> blk_revalidate_disk_zones() are freed automatically from
> __blk_release_queue() using the block internal function
> blk_queue_free_zone_bitmaps().
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
