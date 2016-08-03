From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 0/2] Bio flags use zone cache when available.
Date: Wed,  3 Aug 2016 14:06:43 -0500
Message-ID: <1470251205-4916-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Josh Bingaman <josh.bingaman@seagate.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

As per Christoph's request this patch incorporates Hannes' cache of zone
information.

The approach is to provide the same blkreport format as would be done 
when BLK_DEV_ZONED is not enabled via an ioctl.
Reset WP, Open, and Close zone will update the zone cache.

Using blkdev_issue_zone_report() from within the kernel the report
will still come directly from the media. I am considering an option
for the ioctl to force pulling the zone report from the media when
BLK_DEV_ZONED is enabled and using the resulting information to
refresh the zone cache. It is not clear that this is useful so I
have not included that in this patch.

The follow-on patch just enables the zone cache to be populated
using a Seagate's HostAware drive.

This series is based off of Linus current tip post (f38d2e5313f0af..)
and builds on top of the previous series of block layer support:
    Add ioctl to issue ZBC/ZAC commands via block layer
    Add bio/request flags to issue ZBC/ZAC commands

as well as the series post by Hannes'
    sd_zbc: Fix handling of ZBC read after write pointer
    sd: Limit messages for ZBC disks capacity change
    sd: Implement support for ZBC devices
    sd: Implement new RESET_WP provisioning mode
    sd: configure ZBC devices
...    

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@hgst.com>

Shaun Tancheff (2):
  bio/zbc support for zone cache
  Enable support for Seagate HostAware drives (testing).

 block/blk-lib.c        |   3 +-
 block/blk-zoned.c      | 190 +++++++++++++++++++++++++++++++++++++++++++++++++
 block/ioctl.c          |  39 +++++++---
 drivers/scsi/sd.c      |  22 +++---
 drivers/scsi/sd.h      |  20 ++++--
 drivers/scsi/sd_zbc.c  | 150 ++++++++++++++++++++++++++++++++------
 include/linux/blkdev.h |  14 +++-
 7 files changed, 389 insertions(+), 49 deletions(-)

-- 
2.8.1




    sd_zbc: Fix handling of ZBC read after write pointer
    sd: Limit messages for ZBC disks capacity change
    sd: Implement support for ZBC devices
    sd: Implement new RESET_WP provisioning mode
    sd: configure ZBC devices
    block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
    block: Introduce BLKPREP_DONE
    block: Add 'zoned' sysfs queue attribute
    block: Implement support for zoned block devices
    block: update chunk_sectors in blk_stack_limits()
    blk-sysfs: Add 'chunk_sectors' to sysfs attributes
    sd: configure ZBC devices
    block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
    block: Introduce BLKPREP_DONE
    block: Add 'zoned' sysfs queue attribute
    block: Implement support for zoned block devices
    block: update chunk_sectors in blk_stack_limits()
    blk-sysfs: Add 'chunk_sectors' to sysfs attributes
