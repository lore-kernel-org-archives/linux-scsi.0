From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/14] ZAC support
Date: Tue, 12 Apr 2016 08:47:44 +0200
Message-ID: <1460443678-57934-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi all,

here's a patchset implementing ZAC support for libata.

This is the second part of a larger patchset for ZAC/ZBC support;
it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
the patchset 'libata: SATL update' I've posted earlier.
The full patchset can be found at:

git.kernel.org/hare/scsi-devel/h/zbc.v5

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from upstream
- Add NCQ encapsulation for ZAC MANAGEMENT commands
- Update libata-trace to decode ZAC MANAGEMENT commands
- Minor fixes accumulated during testing

Hannes Reinecke (14):
  libata: do not attempt to retrieve sense code twice
  libsas: enable FPDMA SEND/RECEIVE
  libsas: Define ATA_CMD_NCQ_NON_DATA
  libata: Separate out ata_dev_config_ncq_send_recv()
  libata: NCQ Encapsulation for READ LOG DMA EXT
  libata: Check log page directory before accessing pages
  libata-trace: decode subcommands
  libata-scsi: Generate sense code for disabled devices
  libata: fixup ZAC device disabling
  libata: implement ZBC IN translation
  libata: Implement ZBC OUT translation
  libata: NCQ encapsulation for ZAC MANAGEMENT OUT
  libata: support device-managed ZAC devices
  libata: support host-aware and host-managed ZAC devices

 drivers/ata/libata-core.c              | 172 ++++++++++++++++---
 drivers/ata/libata-eh.c                |  36 +++-
 drivers/ata/libata-scsi.c              | 295 +++++++++++++++++++++++++++++++--
 drivers/ata/libata-trace.c             |  72 ++++++++
 drivers/ata/libata.h                   |   5 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   3 +
 drivers/scsi/isci/request.c            |   5 +-
 drivers/scsi/libsas/sas_ata.c          |   7 +-
 drivers/scsi/mvsas/mv_sas.c            |   5 +-
 drivers/scsi/pm8001/pm8001_sas.c       |   5 +-
 include/linux/ata.h                    |  49 ++++++
 include/linux/libata.h                 |  27 ++-
 include/trace/events/libata.h          |  11 +-
 13 files changed, 642 insertions(+), 50 deletions(-)

-- 
1.8.5.6

