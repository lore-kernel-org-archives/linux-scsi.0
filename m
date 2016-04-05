From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 0/3] Block BIO support for zoned devices
Date: Wed,  6 Apr 2016 02:29:25 +0700
Message-ID: <1459884568-12091-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

The following series is hopefully a reasonable start at adding such
support.

ZAC/ZBC drives add new commands. Most of this support is queued for 4.7.
The first patch is a minor tweak to include open and close zone support
for compatibility with devices following the Host Managed specification.

With the ZAC support in place adding some additional flags to struct bio
to identify the new drive requests (Report zones, Open/Close/Reset zones).

With the bio support in place there are two new users added. The first
user is an ioctl included here.

The second user is a new device mapper target to follow in a separate
series.

Changes since v1:
 * Updated to v4.6-rc2
 
 * Re based on  separate operations from flags in the bio/request structs
    https://lkml.kernel.org/r/1456343292-14535-1-git-send-email-mchristi@redhat.com
 
 * Re based on libata: SATL update: 
    https://lkml.kernel.org/r/1459763047-125551-1-git-send-email-hare@suse.de
     
 * Re based on libata: ZAC support: 
    https://lkml.kernel.org/r/1459763271-125856-1-git-send-email-hare@suse.de
 
 * Re based on Update version of write stream ID patchset
    https://lkml.kernel.org/r/1457107853-8689-1-git-send-email-axboe@fb.com

  * Patches covered by the above series have been dropped and the series is
    split into 2 parts: Block support patches and Device Mapper RFC.

And a fork of Linus kernel with branches off v4.6-rc2 is available here:
https://github.com/stancheff/linux
  branch: v4.6-rc2+op
  branch: v4.6-rc2+op+zbc
  branch: v4.6-rc2+op+zbc+sid
  branch: v4.6-rc2+op+zbc+sid+zdm

ZDM code and user space is also available on github here:
https://github.com/Seagate/ZDM-Device-Mapper

Shaun Tancheff (3):
  Add ZBC <-> ZAC xlat support for report, open, close, reset, finish
  Add bio/request flags for using ZBC/ZAC commands
  Add ioctl to issue ZBC/ZAC commands via block layer

 MAINTAINERS                       |   9 ++
 block/blk-lib.c                   | 125 +++++++++++++++++++++
 block/ioctl.c                     | 113 +++++++++++++++++++
 drivers/ata/libata-scsi.c         |   5 +-
 drivers/scsi/sd.c                 | 107 ++++++++++++++++++
 drivers/scsi/sd.h                 |   1 +
 include/linux/blk_types.h         |  17 ++-
 include/linux/blkzoned_api.h      |  25 +++++
 include/scsi/scsi_device.h        |   1 +
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 221 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h           |   1 +
 12 files changed, 623 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
1.9.1

