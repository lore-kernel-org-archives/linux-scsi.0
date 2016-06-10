From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v3 0/3] Block layer support ZAC/ZBC commands
Date: Fri, 10 Jun 2016 02:10:23 -0500
Message-ID: <1465542626-26536-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

This series is on your for-next branch.

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

ZAC/ZBC drives add new commands for discovering and working with Zones.

This extends the ZAC/ZBC support up to the block layer.

Patches for util-linux can be found here:
https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util-linux

Using BIOs to issue ZBC commands allows DM targets (such as ZDM) or
file-systems such as btrfs or nilfs2 to extend their block allocation
schemes and issue discards that are zone aware.

A perhaps non-obvious approach is that a conventional drive will 
returns a descriptor with a single large conventional zone.

The last patch dealing with ata16 passthrough is to workaround HBA SAS 
controllers that don't support ZBC. It will be dropped now that firmware
updates are starting to appear.

V3:
 - Rebase on Mike Cristie's separate bio operations
 - Update blkzoned_api.h to include report zones PARTIAL bit.
 - Use zoned report reserved bit for ata-passthrough flag.

V2:
 - Changed bi_rw to op_flags clarify sepeartion of bio op from flags.
 - Fixed memory leak in blkdev_issue_zone_report failing to put_bio().
 - Documented opt in blkdev_issue_zone_report.
 - Moved include/uapi/linux/fs.h changes to patch 3
 - Fixed commit message for first patch in series.

Shaun Tancheff (3):
  Add bio/request flags for using ZBC/ZAC commands
  Add ioctl to issue ZBC/ZAC commands via block layer
  Add ata pass-through path for ZAC commands.

 MAINTAINERS                       |   9 ++
 block/blk-lib.c                   |  98 +++++++++++++++++
 block/ioctl.c                     | 142 ++++++++++++++++++++++++
 drivers/scsi/sd.c                 | 139 ++++++++++++++++++++++-
 drivers/scsi/sd.h                 |   1 +
 include/linux/ata.h               |  15 +++
 include/linux/bio.h               |   4 +-
 include/linux/blk_types.h         |  16 ++-
 include/linux/blkzoned_api.h      |  25 +++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 224 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h           |   1 +
 12 files changed, 671 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
2.8.1

