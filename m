From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 0/4] Fix zone revalidation memory allocation
 failures
Date: Mon,  1 Jul 2019 14:09:14 +0900
Message-ID: <20190701050918.27511-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

This series addresses a reccuring problem with zone revalidation
failures observed during extensive testing with memory constrained
system and device hot-plugging.

The problem source is failure to allocate large memory areas with
alloc_pages() or kmalloc() in blk_revalidate_disk_zones() to store the
disk array of zones (struct blk_zone) or in sd_zbc_report_zones() for
the report zones command reply buffer.

The solution proposed here is to:
1) limit the number of zones to be reported with a single report zones
command execution, and
2) Use vmalloc to allocate large-ish arrays and buffers in place of
alloc_pages() or kmalloc().

With these changes, tests do not show any zone revalidation failures
while not impacting the time taken for a disk zone inspection during
device scan and revalidation.

Changes from v5:
* Remove the gfp_t argument from blkdev_report_zones() function and
  device report zones method, relying instead on
  memalloc_noio_save/restore() where GFP_NOIO was used.

Changes from v4:
* bio_copy_kern does not use the vmalloc buffer for IO so does not
  need flush/invalidate_kernel_vmap_range() of the buffer.

Changes from v3:
* Reworked use of flush_kernel_vmap_range() and
  invalidate_kernel_vmap_range() to contain the calls within bio.c,
  transparently to the user of bio_map_kern().
* Add similar support to bio_copy_kern().

Changes from v2:
* Move invalidate_kernel_vmap_range() of vmalloc-ed buffer to sd_zbc.c
  in patch 2, after completion of scsi_execute_req().
* In patch 2, add flush_kernel_vmap_range() before scsi_execute_req().

Changes from V1:
* Added call to invalidate_kernel_vmap_range() for vmalloc-ed buffers
  in patch 1.
* Fixed patch 2 compilation error with Sparc64 (kbuild robot)

Damien Le Moal (4):
  block: Allow mapping of vmalloc-ed buffers
  block: Kill gfp_t argument of blkdev_report_zones()
  sd_zbc: Fix report zones buffer allocation
  block: Limit zone array allocation size

 block/bio.c                    |  28 ++++++++-
 block/blk-zoned.c              |  67 +++++++++++---------
 drivers/block/null_blk.h       |   3 +-
 drivers/block/null_blk_zoned.c |   3 +-
 drivers/md/dm-flakey.c         |   5 +-
 drivers/md/dm-linear.c         |   5 +-
 drivers/md/dm-zoned-metadata.c |  16 +++--
 drivers/md/dm.c                |   6 +-
 drivers/scsi/sd.h              |   3 +-
 drivers/scsi/sd_zbc.c          | 108 +++++++++++++++++++++++----------
 fs/f2fs/super.c                |   4 +-
 include/linux/blkdev.h         |  10 ++-
 include/linux/device-mapper.h  |   3 +-
 13 files changed, 172 insertions(+), 89 deletions(-)

-- 
2.21.0
