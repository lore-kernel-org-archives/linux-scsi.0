From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 0/4] Block layer support ZAC/ZBC commands
Date: Mon,  6 Jun 2016 10:39:27 -0500
Message-ID: <1465227572-27149-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-scsi@vger.kernel.org

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

ZAC/ZBC drives add new commands for discovering and working with Zones.

This extends the ZAC/ZBC support up to the block layer.

Thie first patch in the series is a place-holder for Mike Christi's 
separate operations from flags ...
https://lkml.kernel.org/r/1460716802-2294-1-git-send-email-mchristi@redhat.com
Once that work is completed the first patch can be dropped.

Patches for util-linux can be found here:
https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util-linux

Using BIOs to issue ZBC commands allows DM targets (such as ZDM) or
file-systems such as btrfs or nilfs2 to extend their block allocation 
schemes and issue discards that are zone aware.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>

Shaun Tancheff (4):
  Losing bits on request.cmd_flags
  Add bio/request flags for using ZBC/ZAC commands
  dd ioctl to issue ZBC/ZAC commands via block layer
  Add ata pass-through path for ZAC commands.

 MAINTAINERS                       |   9 ++
 block/blk-core.c                  |  17 +--
 block/blk-lib.c                   |  96 +++++++++++++++++
 block/blk-merge.c                 |   2 +-
 block/blk-mq.c                    |   2 +-
 block/cfq-iosched.c               |   2 +-
 block/elevator.c                  |   4 +-
 block/ioctl.c                     | 142 ++++++++++++++++++++++++
 drivers/scsi/sd.c                 | 142 +++++++++++++++++++++++-
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

