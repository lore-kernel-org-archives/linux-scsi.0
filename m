From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 1/2] scsi: fix sparse warning
Date: Mon, 29 Sep 2014 13:32:42 +0300
Message-ID: <1411986763-7389-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaI2KdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2014 06:33:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, merez@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>

This patch fixes newly introduced sparse warning, introduced by
"scis: fixing the "type" for well known LUs".

Sparse warning:
>> drivers/scsi/scsi_scan.c:825: warning: format '%16p' expects type
				'void *', but argument 6 has type 'u64'

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c6c5716..74b28c9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -813,8 +813,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		 */
 		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
 			sdev_printk(KERN_WARNING, sdev,
-				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16phN\n",
-				__func__, sdev->type, sdev->lun);
+				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
+				__func__, sdev->type, (unsigned int)sdev->lun);
 			sdev->type = TYPE_WLUN;
 		}
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

