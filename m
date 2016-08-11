From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] SAS: use sas_rphy instead of sas_end_device to obtain address.
Date: Thu, 11 Aug 2016 09:59:12 +0200
Message-ID: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

Since commit 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
enclosures') ses_match_to_enclosure() is calling sas_get_address(),
which is coming from commit bcf508c13385 ('scsi_transport_sas: add
function to get SAS endpoint address'). sas_get_address() itself calls
sas_sdev_to_rdev() which BUG_ON()s if a given scsi_device's rphy is
not a SAS_END_DEVICE.

As SAS Enclosure is a SAS expander device, we really shouldn't tie the
lookup of a SAS address to the SAS End Device but the sas_rphy, which
holds the address information.

Fixes: 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS enclosures')
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 3f0ff07..6b6d7b0 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -390,9 +390,9 @@ EXPORT_SYMBOL(sas_remove_host);
  */
 u64 sas_get_address(struct scsi_device *sdev)
 {
-	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
+	struct sas_rphy *rphy = target_to_rphy(sdev->sdev_target);
 
-	return rdev->rphy.identify.sas_address;
+	return rphy->identify.sas_address;
 }
 EXPORT_SYMBOL(sas_get_address);
 
-- 
1.8.5.6
