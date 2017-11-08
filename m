From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V7 0/8] blk-mq support for ZBC disks
Date: Wed,  8 Nov 2017 17:11:10 +0900
Message-ID: <20171108081118.7632-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34635 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdKHILU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 03:11:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

This series, formerly titled "scsi-mq support for ZBC disks", implements
support for ZBC disks for system using the scsi-mq I/O path.

The current scsi level support of ZBC disks guarantees write request ordering
using a per-zone write lock which prevents issuing simultaneously multiple
write commands to a zone, doing so avoid reordering of sequential writes to
sequential zones. This method is however ineffective when scsi-mq is used with
zoned block devices. This is due to the different execution model of blk-mq
which passes a request to the scsi layer for dispatching after the request has
been removed from the I/O scheduler queue. That is, when the scsi layer tries
to lock the target zone of the request, the request may already be out of
order and zone write locking fails to prevent that.

Various approaches have been tried to solve this problem directly from the core
code of blk-mq. All of them had the serious disadvantage of cluttering blk-mq
code with zoned block device specific conditions and processing, making
maintenance and testing difficult.

This series adds blk-mq support for zoned block devices at the I/O scheduler
level with simple modifications of the mq-deadline scheduler. Implementation
is done with reusable helpers defined in the zoned block device support file
(blk-zoned.c). These helpers provide per zone write locking control functions
similar to what was implemented directly in the SCSI layer in sd_zbc.c.
The zone write locking mechanism is used by mq-deadline for the exact same
purpose, that is, to limit writes per zone to at most one request to avoid
reordering.

The changes to mq-deadline do not affect its operation with regular disks. The
same scheduling behavior is maintained for these devices. Compared to the SCSI
layer zone locking implementation, this series optimizes avoids locking
conventional zones which result in a use of these zone that is comparable to a
regular disk.

This series also implements changes to the legacy deadline-iosched. Doing so,
the zone locking code at the SCSI layer in sd.c and sd_zbc.c can be removed.
This results in a significant simplification of the sd driver command handling.

Patch 1 to 5 introduce the zone locking helpers in the block layer and modify
the deadline and mq-deadline schedulers. They equally apply on top of the block
tree branch for-4.15/block and on top of the scsi tree branch 4.15/scsi-queue.
Patch 6 to 8 remove the SCSI layer zone locking and initialize the device
request queue zone information. They apply to the scsi tree branch
4.15/scsi-queue. To cleanly apply these last 3 patches to the block tree branch
for-4.15/block, the following patches from the scsi tree must first be applied:

aa8a845662 "scsi: sd_zbc: Move ZBC declarations to scsi_proto.h"
e98f42bcad "scsi: sd_zbc: Fix comments and indentation"
5eed92d173 "scsi: sd_zbc: Rearrange code"
e8c77ec483 "scsi: sd_zbc: Use well defined macros"
4a109032e3 "scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()"

Of note is that this series imposes the use of the deadline and mq-deadline
schedulers with zoned block devices. A system can trivialy enforce this using
a udev rule such as:

ACTION=="add|change", KERNEL=="sd[a-z]", ATTRS{queue/zoned}=="host-managed", \
ATTR{queue/scheduler}="deadline"

This rules applies equally for the legacy SCSI path as well as the scsi-mq path
thanks to "mq-deadline" being aliased to "deadline".

Comments are as always very much appreciated.

Changes from v6:
* Implement zone write locking helpers in the block layer
* Also modify legacy path deadline scheduler to remove all zone write locking
  code from the scsi layer

Changes from v5:
* Refactor patches to introduce the zone_lock spinlock only when needed
* Addressed Bart's comments (in particular explanations of the zone_lock
  spinlock use)

Changes from v4:
* Various fixes and improvements (From Christoph's comments)
* Dropped zones_wlock scheduler tunable attribute

Changes from v3:
* Integrated support directly into mq-deadline instead of creating a new I/O
  scheduler.
* Disable setting of default mq scheduler for single queue devices

Changes from v2:
* Introduced blk_zoned structure
* Moved I/O scheduler from drivers/scsi to block

Changes from v1:
* Addressed Bart's comments for the blk-mq patches (declarations files)
* Split (former) patch 4 into multiple patches to facilitate review
* Fixed scsi disk lookup from io scheduler by introducing
  scsi_disk_from_queue()

Christoph Hellwig (1):
  block: introduce zoned block devices zone write locking

Damien Le Moal (7):
  blokc: mq-deadline: Introduce dispatch helpers
  block: mq-deadline: Introduce zone locking support
  block: deadline-iosched: Introduce dispatch helpers
  block: deadline-iosched: Introduce zone locking support
  scsi: sd_zbc: Initialize device request queue zoned data
  scsi: sd: Remove zone write locking
  scsi: sd_zbc: Fix zone information initialization

 block/blk-core.c         |   1 +
 block/blk-zoned.c        |  41 +++++++++
 block/deadline-iosched.c | 114 ++++++++++++++++++++---
 block/mq-deadline.c      | 130 ++++++++++++++++++++++++--
 drivers/scsi/sd.c        |  41 +--------
 drivers/scsi/sd.h        |  11 ---
 drivers/scsi/sd_zbc.c    | 235 +++++++++++++++++++++++++++++------------------
 include/linux/blkdev.h   | 110 ++++++++++++++++++++++
 include/scsi/scsi_cmnd.h |   3 +-
 9 files changed, 526 insertions(+), 160 deletions(-)

-- 
2.13.6
