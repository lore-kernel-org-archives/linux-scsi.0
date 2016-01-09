From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/35] block/fs/drivers: remove rw argument from
 submit_bio
Date: Sat, 9 Jan 2016 05:34:09 -0800
Message-ID: <20160109133409.GA26660@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <1452027218-32303-2-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452027218-32303-2-git-send-email-mchristi@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 05, 2016 at 02:53:04PM -0600, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This has callers of submit_bio/submit_bio_wait set the bio->bi_rw
> instead of passing it in. This makes that use the same as
> generic_make_request and how we set the other bio fields.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  block/bio.c                         |  7 +++----
>  block/blk-core.c                    | 11 ++++-------
>  block/blk-flush.c                   |  3 ++-
>  block/blk-lib.c                     |  9 ++++++---
>  drivers/block/drbd/drbd_actlog.c    |  2 +-
>  drivers/block/drbd/drbd_bitmap.c    |  4 ++--
>  drivers/block/floppy.c              |  3 ++-
>  drivers/block/xen-blkback/blkback.c |  4 +++-
>  drivers/block/xen-blkfront.c        |  4 ++--
>  drivers/md/bcache/debug.c           |  6 ++++--
>  drivers/md/bcache/journal.c         |  2 +-
>  drivers/md/bcache/super.c           |  4 ++--
>  drivers/md/dm-bufio.c               |  3 ++-
>  drivers/md/dm-io.c                  |  3 ++-
>  drivers/md/dm-log-writes.c          |  9 ++++++---
>  drivers/md/dm-thin.c                |  3 ++-
>  drivers/md/md.c                     | 10 +++++++---
>  drivers/md/raid1.c                  |  3 ++-
>  drivers/md/raid10.c                 |  4 +++-
>  drivers/md/raid5-cache.c            |  7 ++++---
>  drivers/target/target_core_iblock.c | 24 +++++++++++++-----------
>  fs/btrfs/check-integrity.c          | 18 ++++++++++--------
>  fs/btrfs/check-integrity.h          |  4 ++--
>  fs/btrfs/disk-io.c                  |  3 ++-
>  fs/btrfs/extent_io.c                |  7 ++++---
>  fs/btrfs/raid56.c                   | 16 +++++++++++-----
>  fs/btrfs/scrub.c                    | 16 +++++++++++-----
>  fs/btrfs/volumes.c                  | 14 +++++++-------
>  fs/buffer.c                         |  3 ++-
>  fs/direct-io.c                      |  3 ++-
>  fs/ext4/crypto.c                    |  3 ++-
>  fs/ext4/page-io.c                   |  3 ++-
>  fs/ext4/readpage.c                  |  9 +++++----
>  fs/f2fs/data.c                      | 13 ++++++++-----
>  fs/f2fs/segment.c                   |  6 ++++--
>  fs/gfs2/lops.c                      |  3 ++-
>  fs/gfs2/meta_io.c                   |  3 ++-
>  fs/gfs2/ops_fstype.c                |  3 ++-
>  fs/hfsplus/wrapper.c                |  3 ++-
>  fs/jfs/jfs_logmgr.c                 |  6 ++++--
>  fs/jfs/jfs_metapage.c               | 10 ++++++----
>  fs/logfs/dev_bdev.c                 | 15 ++++++++++-----
>  fs/mpage.c                          |  3 ++-
>  fs/nfs/blocklayout/blocklayout.c    | 22 ++++++++++++----------
>  fs/nilfs2/segbuf.c                  |  3 ++-
>  fs/ocfs2/cluster/heartbeat.c        | 12 +++++++-----
>  fs/xfs/xfs_aops.c                   |  3 ++-
>  fs/xfs/xfs_buf.c                    |  4 ++--
>  include/linux/bio.h                 |  2 +-
>  include/linux/fs.h                  |  2 +-
>  kernel/power/swap.c                 |  5 +++--
>  mm/page_io.c                        | 10 ++++++----
>  52 files changed, 211 insertions(+), 141 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index dbabd48..921112b 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -859,21 +859,20 @@ static void submit_bio_wait_endio(struct bio *bio)
>  
>  /**
>   * submit_bio_wait - submit a bio, and wait until it completes
> - * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
>   * @bio: The &struct bio which describes the I/O
>   *
>   * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
>   * bio_endio() on failure.
>   */
> -int submit_bio_wait(int rw, struct bio *bio)
> +int submit_bio_wait(struct bio *bio)
>  {
>  	struct submit_bio_ret ret;
>  
> -	rw |= REQ_SYNC;
>  	init_completion(&ret.event);
>  	bio->bi_private = &ret;
>  	bio->bi_end_io = submit_bio_wait_endio;
> -	submit_bio(rw, bio);
> +	bio->bi_rw |= REQ_SYNC;
> +	submit_bio(bio);
>  	wait_for_completion(&ret.event);
>  
>  	return ret.error;
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ab51685..9b887e3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2092,7 +2092,6 @@ EXPORT_SYMBOL(generic_make_request);
>  
>  /**
>   * submit_bio - submit a bio to the block device layer for I/O
> - * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
>   * @bio: The &struct bio which describes the I/O
>   *
>   * submit_bio() is very similar in purpose to generic_make_request(), and
> @@ -2100,10 +2099,8 @@ EXPORT_SYMBOL(generic_make_request);
>   * interfaces; @bio must be presetup and ready for I/O.
>   *
>   */
> -blk_qc_t submit_bio(int rw, struct bio *bio)
> +blk_qc_t submit_bio(struct bio *bio)
>  {
> -	bio->bi_rw |= rw;
> -
>  	/*
>  	 * If it's a regular read/write or a barrier with data attached,
>  	 * go through the normal accounting stuff before submission.
> @@ -2111,12 +2108,12 @@ blk_qc_t submit_bio(int rw, struct bio *bio)
>  	if (bio_has_data(bio)) {
>  		unsigned int count;
>  
> -		if (unlikely(rw & REQ_WRITE_SAME))
> +		if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
>  			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
>  		else
>  			count = bio_sectors(bio);
>  
> -		if (rw & WRITE) {
> +		if (bio->bi_rw & WRITE) {
>  			count_vm_events(PGPGOUT, count);
>  		} else {
>  			task_io_account_read(bio->bi_iter.bi_size);
> @@ -2127,7 +2124,7 @@ blk_qc_t submit_bio(int rw, struct bio *bio)
>  			char b[BDEVNAME_SIZE];
>  			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
>  			current->comm, task_pid_nr(current),
> -				(rw & WRITE) ? "WRITE" : "READ",
> +				(bio->bi_rw & WRITE) ? "WRITE" : "READ",
>  				(unsigned long long)bio->bi_iter.bi_sector,
>  				bdevname(bio->bi_bdev, b),
>  				count);
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 9c423e5..e092e13 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -484,8 +484,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
>  
>  	bio = bio_alloc(gfp_mask, 0);
>  	bio->bi_bdev = bdev;
> +	bio->bi_rw |= WRITE_FLUSH;

Shouldn't the |= be a = here and in many other places?

Otherwise this loks fine to me.
