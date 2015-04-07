From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libsas: Fixup transport protocol definition in sas_get_ata_info()
Date: Tue,  7 Apr 2015 10:45:07 +0200
Message-ID: <1428396307-87607-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbbDGIpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 04:45:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

'tproto' specifies the transport protocol, not the device type.
So use the correct definitions here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 drivers/scsi/sd.c             | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 9c706d8..83b182a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -279,7 +279,7 @@ int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
 	if (phy->attached_tproto & SAS_PROTOCOL_STP)
 		dev->tproto = phy->attached_tproto;
 	if (phy->attached_sata_dev)
-		dev->tproto |= SAS_SATA_DEV;
+		dev->tproto |= SAS_PROTOCOL_SATA;
 
 	if (phy->attached_dev_type == SAS_SATA_PENDING)
 		dev->dev_type = SAS_SATA_PENDING;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ec512b8..19e6154 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2127,6 +2127,13 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == UNIT_ATTENTION &&
+			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
+				/* Device reset might occur several times,
+				 * give it one more chance */
+				if (--reset_retries > 0)
+					continue;
 		}
 		retries--;
 
-- 
1.8.5.2

