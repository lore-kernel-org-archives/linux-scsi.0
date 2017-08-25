From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 14/17] scsi_transport_sas, sas_tlr_supported(): Check kzalloc() return value
Date: Fri, 25 Aug 2017 13:46:40 -0700
Message-ID: <20170825204643.25043-15-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40785 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932989AbdHYUs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:48:59 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

Check whether memory allocation succeeded before dereferencing
the pointer to the allocated memory.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index c5cde4ecef8e..6c05fd9a0be5 100644
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
2.14.1
