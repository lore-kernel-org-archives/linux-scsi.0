From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/3] scsi_get_device_flags_keyed(): Always return device flags
Date: Mon,  4 Dec 2017 10:36:31 -0800
Message-ID: <20171204183633.32139-2-bart.vanassche@wdc.com>
References: <20171204183633.32139-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31911 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdLDSgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 13:36:35 -0500
In-Reply-To: <20171204183633.32139-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Since scsi_get_device_flags_keyed() callers do not check whether or
not the returned value is an error code, change that function such
that it returns a flags value even if the 'key' argument is invalid.
Note: since commit 28a0bc4120d3 ("scsi: sd: Implement blacklist
option for WRITE SAME w/ UNMAP") bit 31 is a valid device information
flag so checking whether bit 31 is set in the return value is not
sufficient to tell the difference between an error code and a flags
value.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_devinfo.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 78d4aa8df675..2fed250e87bf 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -599,17 +599,12 @@ blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				int key)
 {
 	struct scsi_dev_info_list *devinfo;
-	int err;
 
 	devinfo = scsi_dev_info_list_find(vendor, model, key);
 	if (!IS_ERR(devinfo))
 		return devinfo->flags;
 
-	err = PTR_ERR(devinfo);
-	if (err != -ENOENT)
-		return err;
-
-	/* nothing found, return nothing */
+	/* key or device not found: return nothing */
 	if (key != SCSI_DEVINFO_GLOBAL)
 		return 0;
 
-- 
2.15.0
