From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/4] Initial SMR drive support
Date: Tue, 29 Jul 2014 16:45:13 +0200
Message-ID: <1406645117-53088-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hsh@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

This is a first stab at implementing SMR support.
The powers that be decided to call the ATA implementation
'ZAC' (zoned access commands), and the SCSI implementation
'ZBC' (zoned block commands).

This is just basic enablement to get ZAC and ZBC drives
handled correctly.
The first three patches update the libata SATL to handle
ZAC devices correctly, and the last patch updates the 'sd'
to work correctly with ZBC devices.
The 'sd' driver will not automatically bind to ZBC
devices; for testing purposes I have added a
module parameter 'attach_zbc' to the 'sd' driver.
This allows for easy testing of ZBC devices.

None of the specific commands like 'report zones' or
'reset write pointer' have been implemented yet as the
actual format is still not finalized.

This patch is made against the core-for-3.17 tree from hch.

Hannes Reinecke (4):
  libata: consolidate ata_dev_classify()
  libata: Implement ATA_DEV_ZAC
  libata-scsi: Update SATL for ZAC drives
  sd: Optionally attach to ZBC devices

 drivers/ata/libahci.c               | 11 +++----
 drivers/ata/libata-core.c           | 34 +++++++++++++-------
 drivers/ata/libata-eh.c             |  7 +++--
 drivers/ata/libata-scsi.c           | 34 +++++++++++++++++---
 drivers/ata/libata-sff.c            |  2 +-
 drivers/ata/libata-transport.c      |  1 +
 drivers/ata/sata_fsl.c              | 11 +++----
 drivers/ata/sata_inic162x.c         |  2 +-
 drivers/ata/sata_sil24.c            |  2 +-
 drivers/scsi/aic94xx/aic94xx_task.c | 10 +++---
 drivers/scsi/isci/request.c         |  4 +--
 drivers/scsi/libsas/sas_ata.c       | 63 +++++--------------------------------
 drivers/scsi/mvsas/mv_sas.c         |  4 +--
 drivers/scsi/pm8001/pm8001_hwi.c    |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c    |  2 +-
 drivers/scsi/sd.c                   | 25 +++++++++++----
 include/linux/libata.h              |  8 +++--
 include/scsi/libsas.h               | 11 ++-----
 18 files changed, 117 insertions(+), 116 deletions(-)

-- 
1.7.12.4

