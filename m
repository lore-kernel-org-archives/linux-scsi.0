From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 00/12] Block support for zoned drives
Date: Mon,  4 Apr 2016 12:06:04 +0700
Message-ID: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

As Host Aware drives are becoming available we would like to be able 
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

The following series is hopefully a reasonable start at adding such 
support.

ZAC/ZBC drives add new commands. Some of this support is already in
progress by Hannes Reinecke <hare@suse.de>. This patch finishes up a
couple of scsi <-> ata translations. These patches will be re-worked 
or dropped in favor of Hannes' next release.

With the ZAC support in place adding some additional flags to struct bio 
to identify the new drive requests (Report zones, Open/Close/Reset zones).

With the bio support in place there are two new users added. The first 
user is an ioctl the second user is a device mapper target.
The user space tools for the ioctl is intended to be acceptable for
inclusion by util-linux. Initial patches for 2.20.1 and 2.21.1
can be found here:
https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util-linux

Please consider the new device mapper target, as an RFC.

Patch "Limit bio_endio recursion" is based on an older patch that was 
not picked up. It is not strictly necessary but it does reduce stack 
usage, especially for badly behaved DM targets that return
DM_MAPIO_REQUEUE too frequently.

Patch "Use PID to seed Stream Id" depends on:
https://lkml.kernel.org/r/1457107853-8689-1-git-send-email-axboe@fb.com

Patch "Block Zoned Control for Userspace" is a hold over for user space
tools that have not been updated to use the new block ioctl. The patch
will be dropped when zdm-tools is updated and sd-tools is replaced
with util-linux.

This series is based on Linus v4.5 kernel.

Code is also available on github here:
https://github.com/Seagate/ZDM-Device-Mapper

And a fork of Linus kernel with ZDM branches is available here:
https://github.com/stancheff/linux

Shaun Tancheff (12):
  Add ZBC <-> ZAC xlat support for report, open, close, reset, finish
  ata-scsi: Translate ReportZones result to big endian
  BUG: Losing bits on request.cmd_flags
  Add bio/request flags for using ZBC/ZAC commands
  Add ioctl to issue ZBC/ZAC commands via block layer
  Add ata pass-through path for ZAC commands.
  ZDM: New DM target 'zoned'
  RAID 4/5/6: Indicate parity blocks as 'META'
  RAID 4/5/6: Fine-grained TRIM enable for ZDM
  Limit bio_endio recursion
  Stream Id: Use PID to seed Stream Id construction.
  Block Zoned Control for Userspace

 Documentation/device-mapper/zoned.txt |   75 +
 MAINTAINERS                           |   16 +
 block/Kconfig                         |   12 +
 block/Makefile                        |    1 +
 block/bio.c                           |   57 +-
 block/blk-core.c                      |   17 +-
 block/blk-lib.c                       |  120 +
 block/blk-merge.c                     |    2 +-
 block/blk-mq.c                        |    2 +-
 block/blk-settings.c                  |    1 +
 block/blk-sysfs.c                     |   11 +
 block/blk-zoned-ctrl.c                |  642 +++
 block/cfq-iosched.c                   |    2 +-
 block/elevator.c                      |    4 +-
 block/ioctl.c                         |  142 +
 block/scsi_ioctl.c                    |    6 +
 drivers/ata/libata-eh.c               |    2 +
 drivers/ata/libata-scsi.c             |  238 ++
 drivers/md/Kconfig                    |   11 +
 drivers/md/Makefile                   |    1 +
 drivers/md/dm-zoned.c                 | 2549 ++++++++++++
 drivers/md/dm-zoned.h                 |  715 ++++
 drivers/md/libzoned.c                 | 7149 +++++++++++++++++++++++++++++++++
 drivers/md/raid5.c                    |    6 +-
 drivers/scsi/sd.c                     |  186 +-
 drivers/scsi/sd.h                     |    1 +
 fs/ext4/file.c                        |    1 +
 fs/xfs/xfs_aops.c                     |    2 +-
 fs/xfs/xfs_file.c                     |    1 +
 include/linux/ata.h                   |   18 +
 include/linux/blk-zoned-ctrl.h        |   51 +
 include/linux/blk_types.h             |   23 +-
 include/linux/blkdev.h                |   22 +-
 include/linux/blkzoned_api.h          |   25 +
 include/linux/elevator.h              |    4 +-
 include/linux/fs.h                    |   10 +-
 include/scsi/scsi_device.h            |    1 +
 include/scsi/scsi_proto.h             |   14 +
 include/trace/events/libata.h         |    2 +
 include/uapi/linux/Kbuild             |    2 +
 include/uapi/linux/blk-zoned-ctrl.h   |   70 +
 include/uapi/linux/blkzoned_api.h     |  221 +
 include/uapi/linux/fs.h               |    1 +
 43 files changed, 12405 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/device-mapper/zoned.txt
 create mode 100644 block/blk-zoned-ctrl.c
 create mode 100644 drivers/md/dm-zoned.c
 create mode 100644 drivers/md/dm-zoned.h
 create mode 100644 drivers/md/libzoned.c
 create mode 100644 include/linux/blk-zoned-ctrl.h
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blk-zoned-ctrl.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
1.9.1

