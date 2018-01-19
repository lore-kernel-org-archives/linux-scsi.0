From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/5] Deprecate DAC960 driver
Date: Fri, 19 Jan 2018 16:11:08 +0100
Message-ID: <20180119151113.80768-1-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755360AbeASPLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 10:11:18 -0500
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

Changes to v1:
- Split into two drivers
- Improve scanning for V1 firmware interface

Hannes Reinecke (5):
  raid_class: Add 'JBOD' RAID level
  scsi: Add VENDOR_SPECIFIC sense code definitions
  myrb: Add Mylex RAID controller (block interface)
  myrs: Add Mylex RAID controller (SCSI interface)
  drivers/block: Remove DAC960 driver

 Documentation/blockdev/README.DAC960 |  756 ----
 drivers/block/DAC960.c               | 7244 ----------------------------------
 drivers/block/DAC960.h               | 4415 ---------------------
 drivers/block/Kconfig                |   12 -
 drivers/block/Makefile               |    1 -
 drivers/scsi/Kconfig                 |   28 +
 drivers/scsi/Makefile                |    2 +
 drivers/scsi/myrb.c                  | 3249 +++++++++++++++
 drivers/scsi/myrb.h                  | 1891 +++++++++
 drivers/scsi/myrs.c                  | 2947 ++++++++++++++
 drivers/scsi/myrs.h                  | 2042 ++++++++++
 drivers/scsi/raid_class.c            |    1 +
 include/linux/raid_class.h           |    1 +
 include/scsi/scsi_proto.h            |    1 +
 14 files changed, 10162 insertions(+), 12428 deletions(-)
 delete mode 100644 Documentation/blockdev/README.DAC960
 delete mode 100644 drivers/block/DAC960.c
 delete mode 100644 drivers/block/DAC960.h
 create mode 100644 drivers/scsi/myrb.c
 create mode 100644 drivers/scsi/myrb.h
 create mode 100644 drivers/scsi/myrs.c
 create mode 100644 drivers/scsi/myrs.h

-- 
2.12.3
