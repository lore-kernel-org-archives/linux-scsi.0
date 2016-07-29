From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Fri, 29 Jul 2016 14:02:33 -0500
Message-ID: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

This series is based on linus' current tip after the merge of 'for-4.8/core'

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

ZAC/ZBC drives add new commands for discovering and working with Zones.

This extends the ZAC/ZBC support up to the block layer allowing direct control
by file systems or device mapper targets. Also by deferring the zone handling
to the authoritative subsystem there is an overall lower memory usage for
holding the active zone information as well as clarifying responsible party
for maintaining the write pointer for each active zone.
By way of example a DM target may have several writes in progress. To sector
(or lba) for those writes will each depend on the previous write. While the
drive's write pointer will be updated as writes are completed the DM target
will be maintaining both where the next write should be scheduled from and 
where the write pointer is based on writes completed w/o errors.
Knowing the drive's zone topology enables DM targets and file systems to
extend their block allocation schemes and issue write pointer resets (or 
discards) that are zone aligned.
A perhaps non-obvious approach is that a conventional drive will 
returns a zone report descriptor with a single large conventional zone.

Patches for util-linux can be found here:
https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util-linux

This patch is available here:
    https://github.com/stancheff/linux/tree/zbc.bio.v6

    git@github.com:stancheff/linux.git zbc.bio.v6

v6:
 - Fix page alloc to include DMA flag for ioctl.
v5:
 - In sd_setup_zone_action_cmnd, remove unused vars and fix switch indent
 - In blk-lib fix documentation
v4:
 - Rebase on linux-next tag next-20160617.
 - Change bio flags to bio op's
 - Dropped ata16 hackery
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

Shaun Tancheff (2):
  Add bio/request flags to issue ZBC/ZAC commands
  Add ioctl to issue ZBC/ZAC commands via block layer

 MAINTAINERS                       |   9 ++
 block/blk-lib.c                   |  95 ++++++++++++++++
 block/ioctl.c                     | 110 +++++++++++++++++++
 drivers/scsi/sd.c                 | 118 ++++++++++++++++++++
 drivers/scsi/sd.h                 |   1 +
 include/linux/bio.h               |   7 +-
 include/linux/blk_types.h         |   6 +-
 include/linux/blkzoned_api.h      |  25 +++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 220 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h           |   1 +
 11 files changed, 591 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
2.8.1
