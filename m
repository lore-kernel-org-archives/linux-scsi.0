From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/9] block/scsi: Implement SMR drive support
Date: Mon,  4 Apr 2016 12:00:11 +0200
Message-ID: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbcDDKAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset implementing SMR (shingled magnetic recording)
device support for the block and SCSI layer.

There are two main parts to it:
- mapping the 'RESET WRITE POINTER' command to the 'discard' functionality.
  The 'RESET WRITE POINTER' operation is pretty close to the existing
  'discard' functionality with the 'discard_zeroes_blocks' bit set.
  So I've added a new 'reset_wp' provisioning mode for this.
- Adding a 'zone' pointer to the request queue. This pointer holds an
  RB-tree with the zone information, which can be used by other layers
  to access the write pointer.

This is the third part of a larger patchset for ZAC/ZBC support;
it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
the patchsets 'libata: SATL update' and 'libata: ZAC support' I've
posted earlier.
The full patchset can be found at:

git.kernel.org/hare/scsi-devel/h/zbc.v3

As usual, comments and reviews are welcome.

Hannes Reinecke (9):
  blk-sysfs: Add 'chunk_sectors' to sysfs attributes
  block: update chunk_sectors in blk_stack_limits()
  sd: configure ZBC devices
  sd: Implement new RESET_WP provisioning mode
  block: Implement support for zoned block devices
  block: Add 'zoned' sysfs queue attribute
  block: Introduce BLKPREP_DONE
  block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
  sd: Implement support for ZBC devices

 block/Kconfig           |   9 ++
 block/Makefile          |   1 +
 block/blk-core.c        |  11 +-
 block/blk-mq.c          |   1 +
 block/blk-settings.c    |   3 +
 block/blk-sysfs.c       |  74 +++++++++
 block/blk-zoned.c       |  70 +++++++++
 drivers/scsi/Kconfig    |   8 +
 drivers/scsi/Makefile   |   1 +
 drivers/scsi/scsi_lib.c |   4 +
 drivers/scsi/sd.c       | 267 ++++++++++++++++++++++++++++---
 drivers/scsi/sd.h       |  44 ++++++
 drivers/scsi/sd_zbc.c   | 411 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h  |   1 +
 include/linux/blkdev.h  |  48 ++++++
 15 files changed, 933 insertions(+), 20 deletions(-)
 create mode 100644 block/blk-zoned.c
 create mode 100644 drivers/scsi/sd_zbc.c

-- 
1.8.5.6

