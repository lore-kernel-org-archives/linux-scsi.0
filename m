From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH 2/2] scsi_scan: introduce a new variable to represent INQUIRY VERSION field
Date: Wed, 22 Jan 2014 16:20:43 +0800
Message-ID: <1390378843-3418-1-git-send-email-handai.szj@taobao.com>
References: <1390378758-3359-1-git-send-email-handai.szj@taobao.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42992 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaAVIVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 03:21:09 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so72249pab.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 00:21:09 -0800 (PST)
In-Reply-To: <1390378758-3359-1-git-send-email-handai.szj@taobao.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, martin.petersen@oracle.com, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

As per Doug Gilbert's suggestion, introduce a new variable to represent
the resp[2] of standard INQUIRY data. For different scsi devices, the
linux scsi_level is computed based on the resp[2] value. This will make
the code more easier to understand.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 drivers/scsi/scsi_scan.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..421d162 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -546,6 +546,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int response_len = 0;
 	int pass, count, result;
 	struct scsi_sense_hdr sshdr;
+	char inquiry_version;
 
 	*bflags = 0;
 
@@ -705,10 +706,16 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
 	 * non-zero LUNs can be scanned.
 	 */
-	sdev->scsi_level = inq_result[2] & 0x07;
-	if (sdev->scsi_level >= 2 ||
-	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
-		sdev->scsi_level++;
+	/* For SCSI devices that equal or after SCSI_2, or is SCSI_1_CCS,
+	 * its scsi_level is (inquiry_version + 1).
+	 */
+	inquiry_version = inq_result[2] & 0x07;
+	if (inquiry_version >= 2 ||
+	    (inquiry_version == 1 && (inq_result[3] & 0x0f) == 1))
+		sdev->scsi_level = inquiry_version + 1;
+	else
+		sdev->scsi_level = inquiry_version;  /* SCSI_1 */
+
 	sdev->sdev_target->scsi_level = sdev->scsi_level;
 
 	return 0;
-- 
1.7.9.5

