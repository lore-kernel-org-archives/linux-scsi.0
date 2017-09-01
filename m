From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/8] blk-mq/scsi-mq support for ZBC disks
Date: Fri,  1 Sep 2017 20:36:23 +0900
Message-ID: <20170901113631.12323-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This series implements support for ZBC disks used through the blk-mq/scsi-mq
I/O path.

The current scsi level support of ZBC disks guarantees write request ordering
using a per-zone write lock which prevents issuing simultaneously multiple
write commands to a zone, doing so avoid reordering of sequential writes to
sequential zones. This method is however ineffective when scsi-mq is used with
zoned block devices. This is due to the different execution model of blk-mq
which passes a request to the scsi layer for dispatching after the request has
been removed from the I/O scheduler queue. That is, when the scsi layer tries
to lock the target zone of the request, the request may already be out of
order and zone write locking fails to prevent that.

Various approaches have been tried to solve this problem. All of them had the
serious disadvantage of cluttering blk-mq code with zoned block device specific
conditions and processing. As such extensive changes can only transform into
maintenance nightmares, a radically different solution is proposed here.

This series support implementation is in the form of a new "zoned" I/O
scheduler based on mq-deadline. Zoned is mostly identical to the mq-deadline
scheduler. It only differs from mq-deadline from the addition of a per zone
write locking mechanism similar to that implemented in sd_zbc.c. The zoned
scheduler zone write locking mechanism is used for the exact same purpose as
the one in the scsi disk driver: limit writes per zone to one to avoid
reordering. The locking context however changes and is moved to the
dispatch_request method of the scheduler, that is, target zones of write
requests can be locked before the requests are issued. In effect, this results
in the same behavior as the legacy scsi path. Sequential write ordering is
preserved.

The zoned scheduler is added as part of the scsi code under driver/scsi. This
allows access to information on the disk zones maintained within the device
scsi_disk structure as this information (e.g. zone types) cannot be retreived
from the context of an I/O scheduler initialization method (init_queue()
method).

the series patches are as follows:
- The first 2 patches fix exported symbols declaration to allow compiling an
  I/O scheduler outside of the block/ directory. No functional changes from
  these patches.
- Patch 3 and 4 reorganize and cleanup the scsi ZBC support to facilitate the
  intorduction of the scheduler. No functional changes from these patches.
- Path 5 fixes a bug
- Patch 6 is an optimization for the legacy scsi path which avoids zone
  locking if a write request targets a conventional zone. 
- Path 7 disables zone write locking for disks accessed through scsi-mq.
- Patch 8 introduces the zoned scheduler.

Comments are as always very much appreciated.

Thank you.


Damien Le Moal (8):
  block: Fix declaration of blk-mq debugfs functions
  block: Fix declaration of blk-mq scheduler functions
  scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
  scsi: sd_zbc: Reorganize and cleanup
  scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()
  scsi: sd_zbc: Limit zone write locking to sequential zones
  scsi: sd_zbc: Disable zone write locking with scsi-mq
  scsi: Introduce ZBC disk I/O scheduler

 Documentation/block/zoned-iosched.txt |  48 ++
 block/Kconfig.iosched                 |  12 +
 block/blk-mq-debugfs.h                |  14 -
 block/blk-mq-sched.h                  |   7 -
 drivers/scsi/Makefile                 |   1 +
 drivers/scsi/sd.c                     |   1 +
 drivers/scsi/sd.h                     |  57 +--
 drivers/scsi/sd_zbc.c                 | 236 +++++----
 drivers/scsi/sd_zbc.h                 |  79 +++
 drivers/scsi/sd_zbc_iosched.c         | 934 ++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h                |  30 ++
 include/scsi/scsi_proto.h             |  46 +-
 12 files changed, 1293 insertions(+), 172 deletions(-)
 create mode 100644 Documentation/block/zoned-iosched.txt
 create mode 100644 drivers/scsi/sd_zbc.h
 create mode 100644 drivers/scsi/sd_zbc_iosched.c

-- 
2.13.5
