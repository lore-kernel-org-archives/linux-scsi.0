From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v4 0/2] Block layer support ZAC/ZBC commands
Date: Sun, 19 Jun 2016 13:00:46 -0500
Message-ID: <1466359248-10544-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp78.mediacombb.net ([68.66.77.78]:35037 "EHLO
	dsmdc-mail-smtp.mcomdc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751322AbcFSSCC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2016 14:02:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Hannes Reinecke <hare@suse.de>

Hi Jens,

This series is on linux-next tag next-20160617.

As Host Aware drives are becoming available we would like to be able
to make use of such drives. This series is also intended to be suitable
for use by Host Managed drives.

ZAC/ZBC drives add new commands for discovering and working with Zones.

This extends the ZAC/ZBC support up to the block layer.

Patches for util-linux can be found here:
https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util-linux

Using BIOs to issue ZBC commands allows DM targets (such as ZDM) or
file-systems such as f2fs, btrfs or nilfs2 to extend their block
allocation schemes and/or issue discards that are zone aligned.

A perhaps non-obvious approach is that a conventional drive will 
returns a zone report descriptor with a single large conventional zone.

v4:
 - Rebase on linux-next tag next-20160617.
 - Change bio flags to bio op's
 - Dropped ata16 hackery
V3:
 - Rebase on Mike Cristie's separate bio operations
 - Update blkzoned_api.h to include report zones PARTIAL bit.
 - Use zoned report reserved bit for ata-passthrough flag.

V2:
 - Changed bi_rw to op_flags clarify sepeartion of bio op from flags.
 - Fixed memory leak in blkdev_issue_zone_report failing to put_bio().
 - Documented opt in blkdev_issue_zone_report.
 - Moved include/uapi/linux/fs.h changes to patch 3
 - Fixed commit message for first patch in series.

Shaun Tancheff (2):
  Add bio/request flags for using ZBC/ZAC commands
  Add ioctl to issue ZBC/ZAC commands via block layer

 MAINTAINERS                       |   9 ++
 block/blk-lib.c                   |  97 +++++++++++++++++
 block/ioctl.c                     | 110 +++++++++++++++++++
 drivers/scsi/sd.c                 | 122 +++++++++++++++++++++
 drivers/scsi/sd.h                 |   1 +
 include/linux/bio.h               |   7 +-
 include/linux/blk_types.h         |   6 +-
 include/linux/blkzoned_api.h      |  25 +++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 220 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h           |   1 +
 11 files changed, 597 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

-- 
2.8.1

