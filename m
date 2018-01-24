From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/4] Deprecate DAC960 driver
Date: Wed, 24 Jan 2018 09:07:57 +0100
Message-ID: <20180124080801.82630-1-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932514AbeAXIIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 03:08:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

as we're trying to get rid of the remaining request_fn drivers here's
a patchset to move the DAC960 driver to the SCSI stack.
As per request from hch I've split up the driver into two new SCSI
drivers called 'myrb' and 'myrs'.

The 'myrb' driver only supports the earlier (V1) firmware interface, which
doesn't have a SCSI interface for the logical drives; for those I've added
a (pretty rudimentary, admittedly) SCSI translation for them.

The 'myrs' driver supports the newer (V2) firmware interface, which is
SCSI based and doesn't need the translation layer.

And the weird proc interface from DAC960 has been converted to sysfs attributes.

Tested with eXtremeRAID 1100 (for V1 Firmware) and Mylex AcceleRAID 170
(for V2 Firmware).

Changes to v2:
- Move to dma_pool API
- Fixup 0-day build issues
- Add myrb_biosparam
- Dropped patch merged with upstream

Changes to v1:
- Split into two drivers
- Improve scanning for V1 firmware interface

Hannes Reinecke (4):
  raid_class: Add 'JBOD' RAID level
  myrb: Add Mylex RAID controller (block interface)
  myrs: Add Mylex RAID controller (SCSI interface)
  drivers/block: Remove DAC960 driver

 Documentation/blockdev/README.DAC960 |  756 ----
 drivers/block/DAC960.c               | 7244 ----------------------------------
 drivers/block/DAC960.h               | 4415 ---------------------
 drivers/block/Kconfig                |   12 -
 drivers/block/Makefile               |    1 -
 drivers/scsi/Kconfig                 |   30 +
 drivers/scsi/Makefile                |    2 +
 drivers/scsi/myrb.c                  | 3263 +++++++++++++++
 drivers/scsi/myrb.h                  | 1891 +++++++++
 drivers/scsi/myrs.c                  | 2950 ++++++++++++++
 drivers/scsi/myrs.h                  | 2042 ++++++++++
 drivers/scsi/raid_class.c            |    1 +
 include/linux/raid_class.h           |    1 +
 13 files changed, 10180 insertions(+), 12428 deletions(-)
 delete mode 100644 Documentation/blockdev/README.DAC960
 delete mode 100644 drivers/block/DAC960.c
 delete mode 100644 drivers/block/DAC960.h
 create mode 100644 drivers/scsi/myrb.c
 create mode 100644 drivers/scsi/myrb.h
 create mode 100644 drivers/scsi/myrs.c
 create mode 100644 drivers/scsi/myrs.h

-- 
2.12.3
