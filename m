From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 00/12] scsi-mq support for ZBC disks
Date: Fri, 15 Sep 2017 19:06:33 +0900
Message-ID: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23903 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdIOKHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 06:07:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

This series implements support for ZBC disks used through the scsi-mq I/O path.

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
conditions and processing. As such extensive changes can only turn into a
maintenance nightmares, a radically different solution is proposed here.

This series proposes implementing scsi-mq support for zoned block devices in
the form of a new "zoned" I/O scheduler based. The zoned I/O scheduler is
based on mq-deadline, with most of the code reused with no modification other
than name changes. Zoned only differs from mq-deadline from the addition of a
per zone write locking mechanism similar to that implemented in sd_zbc.c. The
zoned scheduler zone write locking mechanism is used for the exact same purpose
as the one in the scsi disk driver, that is, to limit writes per zone to at
most one request to avoid reordering. The locking context however changes from
that of scsi-mq and is moved to the dispatch_request method of the scheduler.
Within this context, under a spin lock guaranteeing atomicity against other
dispatch contexts, target zones of write requests can be locked before write
requests removal from the scheduler. In effect, this results in the same
behavior as the legacy scsi path. Sequential write ordering is preserved.

The zoned scheduler is also optimized to not lock conventional zones. To do so,
the new data structure blk_zoned is added to the request queue structure so
that the low level scsi code can pass information such as number of zones and
zone types to the block layer scheduler. This avoids difficulties in accessing
this information from the I/O scheduler initialization method (init_queue()
method) context.

The series patches are as follows:
- The first 2 patches fix exported symbols declaration to allow compiling
  external I/O schedulers as modules. No functional changes are introduced.
- Patch 3 introduces the new blk_zoned data structure added to request queues
- Pathes 4 to 7 reorganize and cleanup the scsi ZBC support
- Path 8 is a bug fix
- Path 9 implements the initialization of the blk_zoned structure for zoned
  block devices
- Patch 10 is an optimization for the legacy scsi path which avoids zone
  locking if a write request targets a conventional zone. 
- Path 11 disables zone write locking for disks accessed through scsi-mq.
- Patch 12 introduces the new zoned blk-mq I/O scheduler.

Comments are as always very much appreciated.

Changes from v2:
* Introduced blk_zoned structure
* Moved I/O scheduler from drivers/scsi to block 

Changes from v1:
* Addressed Bart's comments for the blk-mq patches (declarations files)
* Split (former) patch 4 into multiple patches to facilitate review
* Fixed scsi disk lookup from io scheduler by introducing
  scsi_disk_from_queue()

Damien Le Moal (12):
  block: Fix declaration of blk-mq debugfs functions
  block: Fix declaration of blk-mq scheduler functions
  block: Add zoned block device information to request queue
  scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
  scsi: sd_zbc: Fix comments and indentation
  scsi: sd_zbc: Rearrange code
  scsi: sd_zbc: Use well defined macros
  scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()
  scsi: sd_zbc: Initialize device queue zoned structure
  scsi: sd_zbc: Limit zone write locking to sequential zones
  scsi: sd_zbc: Disable zone write locking with scsi-mq
  block: Introduce zoned I/O scheduler

 Documentation/block/zoned-iosched.txt |  48 ++
 block/Kconfig.iosched                 |  12 +
 block/Makefile                        |   1 +
 block/blk-mq-debugfs.h                |  14 +-
 block/blk-mq-sched.h                  |  11 +-
 block/zoned-iosched.c                 | 925 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c               |   5 +-
 drivers/scsi/sd_zbc.c                 | 267 +++++++---
 include/linux/blk-mq-debugfs.h        |  23 +
 include/linux/blk-mq-sched.h          |  14 +
 include/linux/blkdev.h                |  24 +
 include/scsi/scsi_proto.h             |  45 +-
 12 files changed, 1283 insertions(+), 106 deletions(-)
 create mode 100644 Documentation/block/zoned-iosched.txt
 create mode 100644 block/zoned-iosched.c
 create mode 100644 include/linux/blk-mq-debugfs.h
 create mode 100644 include/linux/blk-mq-sched.h

-- 
2.13.5
