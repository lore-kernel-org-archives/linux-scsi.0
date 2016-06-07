From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 0/4] Block layer support ZAC/ZBC commands
Date: Tue,  7 Jun 2016 15:02:28 -0500
Message-ID: <1465329752-9262-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>
List-Id: linux-scsi@vger.kernel.org

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

ZAC/ZBC drives add new commands for discovering and working with Zones.

This extends the ZAC/ZBC support up to the block layer.

Thie first patch in the series is a place-holder for Mike Christi's
separate operations from flags ...
https://lkml.kernel.org/r/1465155145-10812-1-git-send-email-mchristi@redhat.com
Once that work is completed the first patch can be dropped.

Patches for util-linux can be found here:
https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util-linux

Using BIOs to issue ZBC commands allows DM targets (such as ZDM) or
file-systems such as btrfs or nilfs2 to extend their block allocation
schemes and issue discards that are zone aware.

A perhaps non-obvious approach is that a conventional drive will 
returns a descriptor with a single large conventional zone.

This patch is also at
https://github.com/stancheff/linux.git
git@github.com:stancheff/linux.git
branch: v4.7-rc2+bio.zbc.v2

V2:
 - Changed bi_rw to op_flags clarify sepeartion of bio op from flags.
 - Fixed memory leak in blkdev_issue_zone_report failing to put_bio().
 - Documented opt in blkdev_issue_zone_report.
 - Moved include/uapi/linux/fs.h changes to patch 3
 - Fixed commit message for first patch in series.

Shaun Tancheff (4):
  Losing bits on request.cmd_flags
  Add bio/request flags for using ZBC/ZAC commands
  Add ioctl to issue ZBC/ZAC commands via block layer
  Add ata pass-through path for ZAC commands.

 MAINTAINERS                       |   9 ++
 block/blk-core.c                  |  17 +--
 block/blk-lib.c                   |  97 +++++++++++++++++
 block/blk-merge.c                 |   2 +-
 block/blk-mq.c                    |   2 +-
 block/cfq-iosched.c               |   2 +-
 block/elevator.c                  |   4 +-
 block/ioctl.c                     | 142 ++++++++++++++++++++++++
 drivers/scsi/sd.c                 | 141 +++++++++++++++++++++++-
 drivers/scsi/sd.h                 |   1 +
 include/linux/ata.h               |  15 +++
 include/linux/blk_types.h         |  19 +++-
 include/linux/blkzoned_api.h      |  25 +++++
 include/linux/elevator.h          |   4 +-
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 221 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h           |   1 +
 17 files changed, 683 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
2.8.1

