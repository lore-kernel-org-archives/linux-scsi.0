From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] scsi: replace numeric messages with string error messages when blk_execute_rq fails.  Also add printing of sense info.
Date: Tue, 22 Apr 2014 13:44:16 +0200
Message-ID: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbaDVLoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2014 07:44:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, hch@lst.de

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5248c88..1903ae5 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -25,6 +25,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_dbg.h>
 
 #define ALUA_DH_NAME "alua"
 #define ALUA_DH_VER "1.3"
@@ -163,9 +164,12 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: evpd inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+		sdev_printk(KERN_INFO, sdev, "%s: evpd inquiry failed\n",
+			    ALUA_DH_NAME);
+		scsi_show_result(rq->errors);
+		if (driver_byte(rq->errors) & DRIVER_SENSE)
+			__scsi_print_sense("alua vpd_inquiry", rq->sense,
+					   rq->sense_len);
 		h->senselen = rq->sense_len;
 		err = SCSI_DH_IO;
 	}
@@ -206,9 +210,11 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed\n", ALUA_DH_NAME);
+		scsi_show_result(rq->errors);
+		if (driver_byte(rq->errors) & DRIVER_SENSE)
+			__scsi_print_sense("alua submit_rtpg", rq->sense,
+					   rq->sense_len);
 		h->senselen = rq->sense_len;
 		err = SCSI_DH_IO;
 	}
-- 
Maurizio Lombardi

