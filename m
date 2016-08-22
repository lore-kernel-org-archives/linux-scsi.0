From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v8 0/2] Block layer support ZAC/ZBC commands
Date: Sun, 21 Aug 2016 23:20:08 -0500
Message-ID: <20160822042010.32416-1-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33294 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbcHVEUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 00:20:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, "David S . Miller" <davem@davemloft.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Ming Lei <ming.lei@canonical.com>, Mike Christie <michaelc@cs.wisc.edu>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

Hi Jens,

This series is based on linus' v4.8-rc2 branch.

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be
suitable for use by Host Managed drives.

ZBC [and ZAC] drives add new commands for discovering and working
with Zones.

Part one of this series expands the bio/request reserved op size from
3 to 4 bits and then adds op codes for each of the ZBC commands:
   Report zones, close zone, finish zone, open zone and reset zone.

Part two of this series deals with integrating these new bio/request
op's with Hannes' zone cache.

This extends the ZBC support up to the block layer allowing direct
control by file systems or device mapper targets. Also by deferring
the zone handling to the authoritative subsystem there is an overall
lower memory usage for holding the active zone information as well
as clarifying responsible party for maintaining the write pointer
for each active zone.

By way of example a DM target may have several writes in progress. To sector
(or lba) for those writes will each depend on the previous write. While the
drive's write pointer will be updated as writes are completed the DM target
will be maintaining both where the next write should be scheduled from and
where the write pointer is based on writes completed w/o errors.

Knowing the drive zone topology enables DM targets and file systems to
extend their block allocation schemes and issue write pointer resets (or
discards) that are zone aligned.

A perhaps non-obvious approach is that a conventional drive will
returns a zone report descriptor with a single large conventional zone.
This is intended to allow a collection of zoned and non-zoned media to
be stitched together to provide a file system with a zoned device with
conventional space mapped to where it is useful.

Patches for util-linux can be found here:
    git@github.com:stancheff/util-linux.git v2.28.1+biof

    https://github.com/stancheff/util-linux/tree/v2.28.1%2Bbiof

This patch is available here:
    https://github.com/stancheff/linux/tree/v4.8-rc2%2Bbiof.v8

    git@github.com:stancheff/linux.git v4.8-rc2+biof.v8

v8:
 - Changed zone report to default to reading from zone cache.
 - Changed ioctl for zone commands to support forcing a query or command
   to be sent to media.
 - Fixed report zones copy to user to work when HARDENED_USERCOPY is enabled
v7:
 - Initial support for Hannes' zone cache.
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
 block/blk-lib.c                   |  94 +++++++++++++++++
 block/ioctl.c                     | 149 +++++++++++++++++++++++++++
 drivers/scsi/sd.c                 | 121 ++++++++++++++++++++++
 drivers/scsi/sd.h                 |   1 +
 include/linux/bio.h               |   8 +-
 include/linux/blk_types.h         |   7 +-
 include/linux/blkdev.h            |   1 +
 include/linux/blkzoned_api.h      |  25 +++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 210 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h           |   1 +
 12 files changed, 625 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
2.9.3

