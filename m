From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 0/2] Change zone cache format to use less memory
Date: Sun, 21 Aug 2016 23:34:00 -0500
Message-ID: <20160822043402.8855-1-shaun@tancheff.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Ming Lei <ming.lei@canonical.com>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Currently the RB-Tree zone cache is fast and flexible. It does
use a rather largish amount of ram. This model reduces the ram
required from 120 bytes per zone to 16 bytes per zone with a
moderate transformation of the blk_zone_lookup() api.

This model is predicated on the belief that most variations
on zoned media will follow a pattern of using collections of same
sized zones on a single device. Similar to the pattern of erase
blocks on flash devices being progressivly larger 16K, 64K, ...

The goal is to be able to build a descriptor which is both memory
efficient, performant, and flexible.

Shaun Tancheff (2):
  Move ZBC core setup to sd_zbc
  Migrate zone cache from RB-Tree to arrays of descriptors

 block/blk-core.c       |    2 +-
 block/blk-sysfs.c      |   31 +-
 block/blk-zoned.c      |  103 +++--
 drivers/scsi/sd.c      |   66 +--
 drivers/scsi/sd.h      |   20 +-
 drivers/scsi/sd_zbc.c  | 1037 +++++++++++++++++++++++++++++-------------------
 include/linux/blkdev.h |   82 +++-
 7 files changed, 759 insertions(+), 582 deletions(-)

-- 
2.9.3
