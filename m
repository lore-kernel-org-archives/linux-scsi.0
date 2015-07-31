From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/8] ZBC host-managed device support
Date: Fri, 31 Jul 2015 15:36:12 +0200
Message-ID: <1438349780-116429-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi all,

Here is a first stab at supporting ZBC host-managed devices.
For the uninitiated: ZBC host-managed devices (aka shingled or SMR drives)
have partitioned the drive into several zones, most of which require
sequential writes.
To handle this the patchset implements a rbtree for the zone information,
which will be filled out during device detection.
The rbtree is hooked to the request queue, as it's envisioned that other
layers might want to access it, too.
(Like the device-mapper target I'm working at :-).

Additionally the devices have the habit of spewing out read errors for
uninitialized areas, making working with those devices awkward as the
libata error handling takes ages to recover. To handle that I've implemented
a new BLKPREP return value 'BLKPREP_DONE', allowing for short-circuit
those commands (as they won't return any value anyway).

Oh, this patchset is based on my earlier patchset
'libata: ZAC host-aware device support'.
The entire patchset(s) can be found at

git.kernel.org:/pub/scm/linux/kernel/git/hare/scsi-devel branch zbc.v1

As usual, comments and reviews are welcome.

Hannes Reinecke (8):
  blk-sysfs: Add 'chunk_sectors' to sysfs attributes
  block: update chunk_sectors in blk_stack_limits()
  sd: Set chunk_sectors to zone size
  sd: Implement new RESET_WP provisioning mode
  block: Implement support for zoned block devices
  block: Add 'zoned' sysfs queue attribute
  block: Introduce BLKPREP_DONE
  sd: Implement support for ZBC devices

 block/Kconfig           |   9 ++
 block/Makefile          |   1 +
 block/blk-core.c        |  13 ++
 block/blk-settings.c    |   3 +
 block/blk-sysfs.c       |  74 +++++++++
 block/blk-zoned.c       |  70 +++++++++
 drivers/scsi/Kconfig    |   8 +
 drivers/scsi/Makefile   |   1 +
 drivers/scsi/scsi_lib.c |   3 +-
 drivers/scsi/sd.c       | 245 ++++++++++++++++++++++++++++--
 drivers/scsi/sd.h       |  36 +++++
 drivers/scsi/sd_zbc.c   | 390 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h  |  48 ++++++
 13 files changed, 886 insertions(+), 15 deletions(-)
 create mode 100644 block/blk-zoned.c
 create mode 100644 drivers/scsi/sd_zbc.c

-- 
1.8.5.2
