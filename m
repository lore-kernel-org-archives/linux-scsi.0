From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 0/3] Fix panic when a SES device is attached to a hpsa logical volume.
Date: Mon, 15 Aug 2016 17:12:21 +0200
Message-ID: <cover.1471273623.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

The first patch provides stub implementations for scsi_is_sas_phy()
and sas_get_address() for the case that CONFIG_SCSI_SAS_ATTRS is not
defined.

The second patch implements the actual fix in ses.c by changing the
is_sas_attached() call to scsi_is_sas_rphy().

The third and last patch removes is_sas_attached() as it doesn't have
any more consumers left.

Johannes Thumshirn (3):
  sas: provide stub implementations for scsi_is_sas_phy and
    sas_get_address
  ses: use scsi_is_sas_rphy instead of is_sas_attached
  sas: remove is_sas_attached()

 drivers/scsi/scsi_transport_sas.c | 16 ----------------
 drivers/scsi/ses.c                |  2 +-
 include/scsi/scsi_transport_sas.h | 12 ++++++++----
 3 files changed, 9 insertions(+), 21 deletions(-)

-- 
1.8.5.6
