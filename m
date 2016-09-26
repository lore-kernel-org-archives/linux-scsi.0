From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH v2 0/7] ZBC / Zoned block device support
Date: Mon, 26 Sep 2016 20:14:36 +0900
Message-ID: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

Re-sending due to error in mailing list addresses. My apologies if
you receive multiple copies of the emails.

This series introduces support for zoned block devices. It integrates
earlier submissions by Hannes Reinecke and Shaun Tancheff. Compared to the
previous series version, the code was significantly simplified by limiting
support to zoned devices satisfying the following conditions:
1) All zones of the device are the same size, with the exception of an
   eventual last smaller runt zone.
2) For host-managed disks, reads must be unrestricted (read commands do not
   fail due to zone or write pointer alignement constraints).
Zoned disks that do not satisfy these 2 conditions are ignored.

These 2 conditions allowed dropping the zone information cache implemented
in the previous version. This simplifies the code and also reduces the memory
consumption at run time. Support for zoned devices now only require one bit
per zone (less than 8KB in total). This bit field is used to write-lock
zones and prevent the concurrent execution of multiple write commands in
the same zone. This avoids write ordering problems at dispatch time, for
both the simple queue and scsi-mq settings.

The new operations introduced to suport zone manipulation was reduced to
only the two main ZBC/ZAC defined commands: REPORT ZONES (REQ_OP_ZONE_REPORT)
and RESET WRITE POINTER (REQ_OP_ZONE_RESET). This brings the total number of
operations defined to 8, which fits in the 3 bits (REQ_OP_BITS) reserved for
operation code in bio->bi_opf and req->cmd_flags.

Most of the ZBC specific code is kept out of sd.c and implemented in the
new file sd_zbc.c. Similarly, at the block layer, most of the zoned block
device code is implemented in the new blk-zoned.c.

For host-managed zoned block devices, the sequential write constraint of
write pointer zones is exposed to the user. Users of the disk (applications,
file systems or device mappers) must sequentially write to zones. This means
that for raw block device accesses from applications, buffered writes are
unreliable and direct I/Os must be used (or buffered writes with O_SYNC).

Access to zone manipulation operations is also provided to applications
through a set of new ioctls. This allows applications operating on raw
block devices (e.g. mkfs.xxx) to discover a device zone layout and
manipulate zone state.

Damien Le Moal (1):
  block: Add 'zoned' queue limit

Hannes Reinecke (4):
  blk-sysfs: Add 'chunk_sectors' to sysfs attributes
  block: update chunk_sectors in blk_stack_limits()
  block: Implement support for zoned block devices
  sd: Implement support for ZBC devices

Shaun Tancheff (2):
  block: Define zoned block device operations
  blk-zoned: implement ioctls

 block/Kconfig                 |   8 +
 block/Makefile                |   1 +
 block/blk-core.c              |   4 +
 block/blk-settings.c          |   5 +
 block/blk-sysfs.c             |  29 +++
 block/blk-zoned.c             | 335 ++++++++++++++++++++++++
 block/ioctl.c                 |   4 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/sd.c             |  97 ++++++-
 drivers/scsi/sd.h             |  67 +++++
 drivers/scsi/sd_zbc.c         | 586 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h     |   2 +
 include/linux/blkdev.h        |  99 +++++++
 include/scsi/scsi_proto.h     |  17 ++
 include/uapi/linux/Kbuild     |   1 +
 include/uapi/linux/blkzoned.h | 143 +++++++++++
 include/uapi/linux/fs.h       |   4 +
 17 files changed, 1389 insertions(+), 14 deletions(-)
 create mode 100644 block/blk-zoned.c
 create mode 100644 drivers/scsi/sd_zbc.c
 create mode 100644 include/uapi/linux/blkzoned.h

-- 
2.7.4

