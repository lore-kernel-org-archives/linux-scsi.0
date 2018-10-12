From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 00/11] Zoned block device support improvements
Date: Fri, 12 Oct 2018 11:30:01 +0900
Message-ID: <20181012023012.29923-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This series improves zoned block device support (reduce overhead) and
introduces many simplifications to the code (overall, there are more deletions
than insertions).

In more details:
* Patches 1 to 3 are SCSI side (sd driver) cleanups and improvements reducing
  the overhead of report zones command execution during disk scan and
  revalidation.
* Patches 4 to 9 improve the useability and user API of zoned block devices.
* Patch 10 is the main part of this series. This patch replaces the
  REQ_OP_ZONE_REPORT BIO/request operation for executing report zones commands
  with a block device file operation, removing the need for the command reply
  payload in-place rewriting in the BIO buffer. This leads to major
  simplification of the code in many places.
* Patch 11 further simplifies the code of low level drivers by providing a
  generic implementation of zoned block device request queue zone bitmaps
  initialization and revalidation.

Please consider the addition of these patches in 4.20.
Comments are as always welcome.

Changes from v2:
* Reworked patch 9 to preserve the declaration of struct request_queue nr_zones
  field being conditional on CONFIG_BLK_DEV_ZONED

Changes from v1:
* Addressed Christoph's and Bart's comments
* Fixed several compilation errors with zoned block device support disabled
* Rebased on latest rc including the most recent dm patches

Christoph Hellwig (1):
  block: add a report_zones method

Damien Le Moal (10):
  scsi: sd_zbc: Rearrange code
  scsi: sd_zbc: Reduce boot device scan and revalidate time
  scsi: sd_zbc: Fix sd_zbc_check_zones() error checks
  block: Introduce blkdev_nr_zones() helper
  block: Limit allocation of zone descriptors for report zones
  block: Introduce BLKGETZONESZ ioctl
  block: Introduce BLKGETNRZONES ioctl
  block: Improve zone reset execution
  block: Expose queue nr_zones in sysfs
  block: Introduce blk_revalidate_disk_zones()

 block/blk-core.c               |   1 -
 block/blk-lib.c                |  13 +-
 block/blk-mq-debugfs.c         |   1 -
 block/blk-sysfs.c              |  13 +
 block/blk-zoned.c              | 359 +++++++++++++++---------
 block/blk.h                    |   8 +
 block/ioctl.c                  |   4 +
 drivers/block/null_blk.h       |  11 +-
 drivers/block/null_blk_main.c  |  30 +-
 drivers/block/null_blk_zoned.c |  57 +---
 drivers/md/dm-flakey.c         |  30 +-
 drivers/md/dm-linear.c         |  35 ++-
 drivers/md/dm-table.c          |  10 +
 drivers/md/dm-zoned-target.c   |   3 +-
 drivers/md/dm.c                | 169 ++++++-----
 drivers/scsi/sd.c              |  15 +-
 drivers/scsi/sd.h              |  15 +-
 drivers/scsi/sd_zbc.c          | 497 +++++++++------------------------
 include/linux/blk_types.h      |   2 -
 include/linux/blkdev.h         |  22 +-
 include/linux/device-mapper.h  |  12 +-
 include/trace/events/f2fs.h    |   1 -
 include/uapi/linux/blkzoned.h  |   3 +
 23 files changed, 591 insertions(+), 720 deletions(-)

-- 
2.17.1


















Christoph Hellwig (1):
  block: add a report_zones method

Damien Le Moal (10):
  scsi: sd_zbc: Rearrange code
  scsi: sd_zbc: Reduce boot device scan and revalidate time
  scsi: sd_zbc: Fix sd_zbc_check_zones() error checks
  block: Introduce blkdev_nr_zones() helper
  block: Limit allocation of zone descriptors for report zones
  block: Introduce BLKGETZONESZ ioctl
  block: Introduce BLKGETNRZONES ioctl
  block: Improve zone reset execution
  block: Expose queue nr_zones in sysfs
  block: Introduce blk_revalidate_disk_zones()

 block/blk-core.c               |   1 -
 block/blk-lib.c                |  13 +-
 block/blk-mq-debugfs.c         |   1 -
 block/blk-sysfs.c              |  13 +
 block/blk-zoned.c              | 359 +++++++++++++++---------
 block/blk.h                    |   8 +
 block/ioctl.c                  |   4 +
 drivers/block/null_blk.h       |  11 +-
 drivers/block/null_blk_main.c  |  30 +-
 drivers/block/null_blk_zoned.c |  57 +---
 drivers/md/dm-flakey.c         |  30 +-
 drivers/md/dm-linear.c         |  35 ++-
 drivers/md/dm-table.c          |  10 +
 drivers/md/dm-zoned-target.c   |   3 +-
 drivers/md/dm.c                | 169 ++++++-----
 drivers/scsi/sd.c              |  15 +-
 drivers/scsi/sd.h              |  15 +-
 drivers/scsi/sd_zbc.c          | 497 +++++++++------------------------
 include/linux/blk_types.h      |   2 -
 include/linux/blkdev.h         |  30 +-
 include/linux/device-mapper.h  |  12 +-
 include/trace/events/f2fs.h    |   1 -
 include/uapi/linux/blkzoned.h  |   3 +
 23 files changed, 600 insertions(+), 719 deletions(-)

-- 
2.17.1
