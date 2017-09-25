From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 00/14] scsi-mq support for ZBC disks
Date: Mon, 25 Sep 2017 15:14:40 +0900
Message-ID: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18498 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932086AbdIYGO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 02:14:56 -0400
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

This series proposes implementing scsi-mq support for zoned block devices at
the I/O scheduler level with simple modifications of the mq-deadline scheduler.
the modifications are the addition of a per zone write locking mechanism
similar to that implemented in sd_zbc.c for the legacy scsi path. The zone
write locking mechanism is used for the exact same purpose, that is, to limit
writes per zone to at most one request to avoid reordering. The locking context
however changes from that of scsi-sq and is moved to the dispatch_request
method of the scheduler. Within this context, under a spin lock guaranteeing
atomicity against other dispatch contexts, target zones of write requests can
be locked before write requests removal from the scheduler. In effect, this
results in the same behavior as the legacy scsi path. Sequential write ordering
is preserved.

The changes to mq-deadline do not affect regular disks: the same scheduling
behavior is maintained for these. The modification are also optimized to not
lock conventional zones. To do so, additional data is introduced in the
request queue structure so that the low level scsi code can pass upward
information such as the total number of zones and zone types of the device.
The availability of this new data avoids difficulties in accessing this
information from the I/O scheduler initialization method (init_queue() method)
context.

Of note is that the last patch of this series removes setting mq-deadline as the
default scheduler for block devices with a single hardware queue. The reason for
this is that setting the default scheduler is done very early in the device
initialization sequence, when the disk characteristics are not yet known. This
results in mq-deadline not correctly setting the default zones write locking
behavior nased on the device zoning model. Setting of a default I/O scheduler
can be done easily with udev rules later in the system initialization process,
leading to correct default settings for zoned block devices.

Comments are as always very much appreciated.

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

Damien Le Moal (14):
  scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
  scsi: sd_zbc: Fix comments and indentation
  scsi: sd_zbc: Rearrange code
  scsi: sd_zbc: Use well defined macros
  scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()
  block: Add zoned block device information to request queue
  scsi: sd_zbc: Initialize device request queue zoned data
  scsi: sd_zbc: Limit zone write locking to sequential zones
  scsi: sd_zbc: Disable zone write locking with scsi-mq
  block: mq-deadline: Add zoned block device data
  blokc: mq-deadline: Introduce dispatch helpers
  block: mq-deadline: Introduce zone locking support
  block: mq-deadline: Limit write request dispatch for zoned block
    devices
  block: do not set mq default scheduler

 block/elevator.c          |  17 +--
 block/mq-deadline.c       | 265 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/scsi_lib.c   |   5 +-
 drivers/scsi/sd_zbc.c     | 340 +++++++++++++++++++++++++++++++++++-----------
 include/linux/blkdev.h    |  53 ++++++++
 include/scsi/scsi_proto.h |  45 ++++--
 6 files changed, 612 insertions(+), 113 deletions(-)

-- 
2.13.5
