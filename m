From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] Initial SMR drive support
Date: Mon,  2 Jun 2014 09:01:15 +0200
Message-ID: <1401692478-23557-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaFBHBW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2014 03:01:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is a first stab at implementing SMR support.
The powers that be decided to call the ATA implementation
'ZAC' (zoned access commands), and the SCSI implementation
'ZBC' (zoned block commands).

This is just basic enablement to get ZAC and ZBC drives
detected as such. None of the specific commands like
'report zones' or 'reset write pointer' have been
implemented yet. Reasoning here is that the format
of the 'report zones' command is still not finalized.
Currently the formats for the ZAC log page and
the ZBZ 'report zones' command are not identical,
so one would need some translation logic here.
But I was given to understand that both should be
made identical for the final standard.

Hannes Reinecke (3):
  libata: consolidate ata_dev_classify()
  libata: Implement ATA_DEV_ZAC
  scsi: Implement 'ZBC' device type

 drivers/ata/libahci.c               | 11 +++----
 drivers/ata/libata-core.c           | 34 +++++++++++++-------
 drivers/ata/libata-eh.c             |  7 +++--
 drivers/ata/libata-scsi.c           | 13 ++++++--
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
 drivers/scsi/scsi.c                 |  2 ++
 drivers/scsi/scsi_scan.c            |  1 +
 drivers/scsi/sd.c                   | 16 ++++++----
 include/linux/libata.h              |  8 +++--
 include/scsi/libsas.h               |  2 +-
 include/scsi/scsi.h                 |  1 +
 21 files changed, 90 insertions(+), 108 deletions(-)

-- 
1.7.12.4

