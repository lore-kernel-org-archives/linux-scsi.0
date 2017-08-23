From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 16/19] scsi_transport_sas, sas_tlr_supported(): Check kzalloc() return value
Date: Wed, 23 Aug 2017 14:40:06 -0700
Message-ID: <20170823214009.15015-17-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57495 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdHWVnd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:43:33 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

Check whether memory allocation succeeded before dereferencing
the pointer to the allocated memory.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index a318c46db7cc..1a0fa79fd49a 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -423,6 +423,9 @@ sas_tlr_supported(struct scsi_device *sdev)
 	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
 	int ret = 0;
 
+	if (!buffer)
+		goto out;
+
 	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
 		goto out;
 
-- 
2.14.0
