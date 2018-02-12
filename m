From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Reduce number of scsi_test_unit_ready() retries
Date: Mon, 12 Feb 2018 10:57:52 -0800
Message-ID: <20180212185752.28093-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58046 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753550AbeBLS5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 13:57:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Make scsi_test_unit_ready() send at most as many TURs as specified
in the 'retries' argument instead of retries * (retries + 1) / 2.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b03cb2d5b733..9c793090dbf1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2607,7 +2607,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, retries, NULL);
+					  timeout, 1, NULL);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-- 
2.16.1
