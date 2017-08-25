From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 12/17] libsas: Remove a set-but-not-used variable
Date: Fri, 25 Aug 2017 13:46:38 -0700
Message-ID: <20170825204643.25043-13-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15512 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932800AbdHYUs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:48:59 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

This was detected by building with W=1.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/libsas/sas_scsi_host.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 87e5079d816b..fc90b8c65860 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -855,7 +855,6 @@ int sas_target_alloc(struct scsi_target *starget)
 int sas_slave_configure(struct scsi_device *scsi_dev)
 {
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-	struct sas_ha_struct *sas_ha;
 
 	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
 
@@ -864,8 +863,6 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 		return 0;
 	}
 
-	sas_ha = dev->port->ha;
-
 	sas_read_port_mode_page(scsi_dev);
 
 	if (scsi_dev->tagged_supported) {
-- 
2.14.1
