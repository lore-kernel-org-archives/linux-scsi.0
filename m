From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/4] Initial SMR drive support
Date: Mon, 21 Jul 2014 10:27:17 +0200
Message-ID: <1405931241-92015-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaGUI1Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 04:27:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, James Bottomely <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

this is a first stab at implementing SMR support.
The powers that be decided to call the ATA implementation
'ZAC' (zoned access commands), and the SCSI implementation
'ZBC' (zoned block commands).

This is just basic enablement to get ZAC and ZBC drives
handled correctly.
The first three patches update the libata SATL to handle
ZAC devices correctly, and the last patch updates the 'sd'
to work correctly with ZBC devices.
ZBC devices will _not_ be handled with the 'sd' driver
automatically ss of now; however, the sd device can
be bound manually to the device by using the sysfs
'bind' attribute.

None of the specific commands like 'report zones' or
'reset write pointer' have been implemented yet as the
actual format is still not finalized.

This patch is made against the core-for-3.17 tree from hch.

Hannes Reinecke (4):
  libata: consolidate ata_dev_classify()
  libata: Implement ATA_DEV_ZAC
  libata-scsi: Update SATL for ZAC drives
  sd: Handle ZBC drives correctly

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
 drivers/scsi/sd.c                   | 10 +++---
 include/linux/libata.h              |  8 +++--
 include/scsi/libsas.h               | 11 ++-----
 18 files changed, 103 insertions(+), 115 deletions(-)

-- 
1.7.12.4

