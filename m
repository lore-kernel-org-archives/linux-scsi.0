From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 02/17] Avoid sign extension of scsi_device.type
Date: Fri, 25 Aug 2017 13:46:28 -0700
Message-ID: <20170825204643.25043-3-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40785 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932578AbdHYUr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:47:58 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that smatch reports the following:

drivers/scsi/scsi_sysfs.c:506 scsi_bus_uevent() warn: argument 3 to %02x specifier has type 'char'
drivers/scsi/scsi_sysfs.c:872 sdev_show_modalias() warn: argument 4 to %02x specifier has type 'char'

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0979a5f3b69a..f054f3f43c75 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -111,7 +111,7 @@ struct scsi_device {
 	unsigned sector_size;	/* size in bytes */
 
 	void *hostdata;		/* available to low-level driver */
-	char type;
+	unsigned char type;
 	char scsi_level;
 	char inq_periph_qual;	/* PQ from INQUIRY data */	
 	struct mutex inquiry_mutex;
-- 
2.14.1
