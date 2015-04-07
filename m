From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] libsas: Fixup transport protocol definition in sas_get_ata_info()
Date: Tue,  7 Apr 2015 10:49:07 +0200
Message-ID: <1428396547-87814-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbbDGItJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 04:49:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

'tproto' specifies the transport protocol, not the device type.
So use the correct definitions here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.8.5.2

