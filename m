From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 0/9] ZBC / Zoned block device support
Date: Tue, 20 Sep 2016 06:27:25 +0900
Message-ID: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34625 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbcISV23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 17:28:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Damien Le Moal <damien.lemoal@hgst.com>

This series introduces support for ZBC zoned block devices. It integrates
earlier submissions by Hannes Reinecke and Shaun Tancheff and includes
rewrites and corrections suggested by Christoph Hellwig.

For zoned block devices, a zone information cache implemented as an RB-tree
is attached to the device request queue and maintained from the SCSI disk
driver layer. The cache is used to check read and write commands alignement
to zone position and to the write pointer position within zones.
The generic block layer API defines functions for obtaining zone information
and manipulating zones. Operation on zones are defined as request operations
which triger zone cache changes when processed in the sd driver.

Most of the ZBC specific code is kept out of sd.c and implemented in the
new file sd_zbc.c. Similarly, at the block layer, most of the zoned block
device code is implemented in the new blk-zoned.c.

For host-managed zoned block devices, the sequential write constraint of
write pointer zones is exposed to the user. Users of the disk (applications,
file systems or device mappers) must sequentially write to zones. This means
that for raw block device accesses from applications, buffered writes are
unreliable and direct I/Os must be used (or buffered writes with O_SYNC).
At the SCSI layer, write ordering is maintained at dispatch time for both
the simple queue model and scsi-mq model using a zone write lock. This lock,
implemented as a flag in zone information, prevents issuing multiple writes
to a single zone, in effect, resulting in write queue depth of 1 per zone
while allowing the drive to be operated at high queue depth overall.

Access to zone manipulation operations is also provided to applications
through a set of new ioctls. This allows applications operating on raw
block devices (e.g. mkfs.xxx) to discover a device zone layout and
manipulate zone state.

Damien Le Moal (1):
  block: Add 'zoned' queue limit

Hannes Reinecke (6):
  blk-sysfs: Add 'chunk_sectors' to sysfs attributes
  block: update chunk_sectors in blk_stack_limits()
  block: Implement support for zoned block devices
  block: Add 'BLKPREP_DONE' return value
  block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
  sd: Implement support for ZBC devices

Shaun Tancheff (2):
  block: Define zoned block device operations
  blk-zoned: Add ioctl interface for zone operations

 block/Kconfig                 |    8 +
 block/Makefile                |    1 +
 block/blk-core.c              |   53 +-
 block/blk-merge.c             |   31 +-
 block/blk-mq.c                |    1 +
 block/blk-settings.c          |    5 +
 block/blk-sysfs.c             |   29 ++
 block/blk-zoned.c             |  453 +++++++++++++++++
 block/ioctl.c                 |    8 +
 drivers/scsi/Makefile         |    1 +
 drivers/scsi/scsi_lib.c       |    4 +
 drivers/scsi/sd.c             |  147 +++++-
 drivers/scsi/sd.h             |   68 +++
 drivers/scsi/sd_zbc.c         | 1097 +++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h           |   36 +-
 include/linux/blk-mq.h        |    1 +
 include/linux/blk_types.h     |   27 +-
 include/linux/blkdev.h        |  146 ++++++
 include/scsi/scsi_proto.h     |   17 +
 include/uapi/linux/Kbuild     |    1 +
 include/uapi/linux/blkzoned.h |   91 ++++
 include/uapi/linux/fs.h       |    1 +
 22 files changed, 2170 insertions(+), 56 deletions(-)
 create mode 100644 block/blk-zoned.c
 create mode 100644 drivers/scsi/sd_zbc.c
 create mode 100644 include/uapi/linux/blkzoned.h

-- 
2.7.4

