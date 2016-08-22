From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 0/4] Integrate bio/request ZBC ops with zone cache
Date: Sun, 21 Aug 2016 23:31:12 -0500
Message-ID: <20160822043116.21168-1-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

As per Christoph's request this patch incorporates Hannes' cache of zone
information.

This approach is to have REQ_OP_ZONE_REPORT return data in the same
format regardless of the availability of the zone cache. So if the
is kernel being built with or without BLK_DEV_ZONED [and SCSI_ZBC]
users of blkdev_issue_zone_report() and/or REQ_OP_ZONE_REPORT bio's
will have a consistent data format to digest.

Additionally it seems reasonable to allow the REQ_OP_ZONE_* to
be able to indicate if the command *must* be delivered to the
device [and update the zone cache] accordingly. Here REQ_META is
being used as REQ_FUA can be dropped causing sd_done to be skipped.
Rather than special case the current code I chose to pick an otherwise
non-applicable flag.

This series is based off of Linus's v4.8-rc2 and builds on top of the
previous series of block layer support:
    Add ioctl to issue ZBC/ZAC commands via block layer
    Add bio/request flags to issue ZBC/ZAC commands
as well as the series posted by Hannes
    sd_zbc: Fix handling of ZBC read after write pointer
    sd: Limit messages for ZBC disks capacity change
    sd: Implement support for ZBC devices
    sd: Implement new RESET_WP provisioning mode
    sd: configure ZBC devices
...

Patches for util-linux can be found here:
    git@github.com:stancheff/util-linux.git v2.28.1+biof

    https://github.com/stancheff/util-linux/tree/v2.28.1%2Bbiof

This patch is available here:
    https://github.com/stancheff/linux/tree/v4.8-rc2%2Bbiof.v9

    git@github.com:stancheff/linux.git v4.8-rc2+biof.v9

v2:
 - Fully integrated bio <-> zone cache [<-> device]
 - Added discard -> write same for conventional zones.
 - Merged disparate constants into a canonical set.

Shaun Tancheff (4):
  Enable support for Seagate HostAware drives (testing).
  On Discard either do Reset WP or Write Same
  Merge ZBC constants
  Integrate ZBC command requests with zone cache.

 block/blk-lib.c                   |  16 -
 drivers/scsi/sd.c                 | 111 +++--
 drivers/scsi/sd.h                 |  49 ++-
 drivers/scsi/sd_zbc.c             | 904 ++++++++++++++++++++++++++++++++++----
 include/linux/blkdev.h            |  22 +-
 include/scsi/scsi_proto.h         |  17 -
 include/uapi/linux/blkzoned_api.h | 167 ++++---
 7 files changed, 1032 insertions(+), 254 deletions(-)

-- 
2.9.3

