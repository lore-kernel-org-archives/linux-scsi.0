From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4]  mylex: Replace DAC960 block driver
Date: Wed,  2 Aug 2017 16:13:24 +0200
Message-ID: <1501683208-5240-1-git-send-email-hare@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi all,

as we're trying to get rid of the remaining request_fn drivers here's
a patchset to move the DAC960 driver to the SCSI stack.
The new driver is called 'mylex'.

The Mylex/DAC960 HBA comes in two flavours; the later one (V2) already
has a pretty complete SCSI emulation layer, so we just have to reformat
the command.
For for earlier ones (V1) we don't have a SCSI emulation layer for the
logical drives, so I've added a (pretty rudimentary, admittedly) SCSI
translation for them.
And the weird proc interface has been converted to sysfs attributes.

Tested with eXtremeRAID 1100 (for V1 Firmware) and Mylex AcceleRAID 170
(for V2 Firmware).

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  raid_class: Add 'JBOD' RAID level
  scsi: Add VENDOR_SPECIFIC sense code definitions
  scsi: add Mylex RAID controller
  block: Drop obsolete DAC960 driver

 Documentation/blockdev/README.DAC960 |  756 ----
 drivers/block/DAC960.c               | 7241 ----------------------------------
 drivers/block/DAC960.h               | 4415 ---------------------
 drivers/block/Kconfig                |   12 -
 drivers/block/Makefile               |    1 -
 drivers/scsi/Kconfig                 |   12 +
 drivers/scsi/Makefile                |    1 +
 drivers/scsi/mylex.c                 | 6025 ++++++++++++++++++++++++++++
 drivers/scsi/mylex.h                 | 4029 +++++++++++++++++++
 drivers/scsi/raid_class.c            |    1 +
 include/linux/raid_class.h           |    1 +
 include/scsi/scsi_proto.h            |    1 +
 12 files changed, 10070 insertions(+), 12425 deletions(-)
 delete mode 100644 Documentation/blockdev/README.DAC960
 delete mode 100644 drivers/block/DAC960.c
 delete mode 100644 drivers/block/DAC960.h
 create mode 100644 drivers/scsi/mylex.c
 create mode 100644 drivers/scsi/mylex.h

-- 
1.8.5.6
