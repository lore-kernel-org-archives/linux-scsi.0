From: Rob Evers <revers@redhat.com>
Subject: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Fri, 12 Aug 2011 17:01:16 -0400
Message-ID: <1313182877-31377-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1HLVBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 17:01:17 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p7CL1H9d019809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 17:01:17 -0400
Received: from localhost (dhcp-100-19-182.bos.redhat.com [10.16.19.182])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p7CL1HX8017839
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 17:01:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

replace numeric messages with string error messages when blk_execute_rq
fails.  Also add printing of sense info.

Mike Christie suggested adding printing of sense info here

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6fec9fe..58fdf64 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -24,6 +24,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_dbg.h>
 
 #define ALUA_DH_NAME "alua"
 #define ALUA_DH_VER "1.3"
@@ -153,9 +154,12 @@ static int submit_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: std inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+		sdev_printk(KERN_INFO, sdev, "%s: std inquiry failed\n",
+			    ALUA_DH_NAME);
+		scsi_show_result(rq->errors);
+		if (driver_byte(rq->errors) && DRIVER_SENSE)
+			__scsi_print_sense("alua std_inquiry", rq->sense,
+					   rq->sense_len);
 		h->senselen = rq->sense_len;
 		err = SCSI_DH_IO;
 	}
@@ -190,9 +194,12 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: evpd inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+		sdev_printk(KERN_INFO, sdev, "%s: evpd inquiry failed\n",
+			    ALUA_DH_NAME);
+		scsi_show_result(rq->errors);
+		if (driver_byte(rq->errors) && DRIVER_SENSE)
+			__scsi_print_sense("alua vpd_inquiry", rq->sense,
+					   rq->sense_len);
 		h->senselen = rq->sense_len;
 		err = SCSI_DH_IO;
 	}
@@ -229,9 +236,11 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed\n", ALUA_DH_NAME);
+		scsi_show_result(rq->errors);
+		if (driver_byte(rq->errors) && DRIVER_SENSE)
+			__scsi_print_sense("alua submit_rtpg", rq->sense,
+					   rq->sense_len);
 		h->senselen = rq->sense_len;
 		err = SCSI_DH_IO;
 	}
-- 
1.7.1

