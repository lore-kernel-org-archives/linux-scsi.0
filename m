From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/14] libata: ZAC support
Date: Mon, 25 Apr 2016 12:45:42 +0200
Message-ID: <1461581156-92581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbcDYKs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 06:48:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset implementing ZAC support for libata.

This is the second part of a larger patchset for ZAC/ZBC support;
it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
the patchset 'libata: SATL update' queued in tj/for-4.7-zac.
The full patchset can be found at:

git.kernel.org/hare/scsi-devel/h/zbc.v6

As usual, comments and reviews are welcome.

Changes to v2:
- Include reviews and fixes from Damien Le Moal
- Include reviews from Shaun Tancheff
- Remove NCQ encapsulation for READ LOG DMA EXT

Changes to v1:
- Include reviews from upstream
- Add NCQ encapsulation for ZAC MANAGEMENT commands
- Update libata-trace to decode ZAC MANAGEMENT commands
- Minor fixes accumulated during testing

Hannes Reinecke (14):
  libata: do not attempt to retrieve sense code twice
  libsas: enable FPDMA SEND/RECEIVE
  libata/libsas: Define ATA_CMD_NCQ_NON_DATA
  libata: Separate out ata_dev_config_ncq_send_recv()
  libata: Add command definitions for NCQ Encapsulation for READ LOG DMA
    EXT
  libata: Check log page directory before accessing pages
  libata-trace: decode subcommands
  libata-scsi: Generate sense code for disabled devices
  libata: fixup ZAC device disabling
  libata: implement ZBC IN translation
  libata: Implement ZBC OUT translation
  libata: NCQ encapsulation for ZAC MANAGEMENT OUT
  libata: support device-managed ZAC devices
  libata: support host-aware and host-managed ZAC devices

 drivers/ata/libata-core.c              | 195 +++++++++++++++++++---
 drivers/ata/libata-eh.c                |   6 +-
 drivers/ata/libata-scsi.c              | 295 +++++++++++++++++++++++++++++++--
 drivers/ata/libata-trace.c             |  72 ++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   3 +
 drivers/scsi/isci/request.c            |   5 +-
 drivers/scsi/libsas/sas_ata.c          |   7 +-
 drivers/scsi/mvsas/mv_sas.c            |   5 +-
 drivers/scsi/pm8001/pm8001_sas.c       |   5 +-
 include/linux/ata.h                    |  54 +++++-
 include/linux/libata.h                 |  34 +++-
 include/trace/events/libata.h          |  10 +-
 12 files changed, 649 insertions(+), 42 deletions(-)

-- 
1.8.5.6

