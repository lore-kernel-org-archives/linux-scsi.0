From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 2/3] scsi: ufs: Fix sending unsupported SCSI command
Date: Tue,  1 Jul 2014 12:22:38 +0300
Message-ID: <1404206559-21445-3-git-send-email-draviv@codeaurora.org>
References: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbaGAJXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 05:23:06 -0400
In-Reply-To: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

UFS 1.1 specification does not support MAINTENANCE IN(0xA3) SCSI
command and hence it doesn't support REPORT SUPPORTED OPERATION CODES
as well.

Change-Id: Ic09c5b46b2511b1c28db478023c32b898ac69e6d
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b533ff8..f189e8a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1992,6 +1992,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* allow SCSI layer to restart the device in case of errors */
 	sdev->allow_restart = 1;
 
+	/* REPORT SUPPORTED OPERATION CODES is not supported */
+	sdev->no_report_opcodes = 1;
+
 	lun_qdepth = ufshcd_read_sdev_qdepth(hba, sdev);
 	if (lun_qdepth <= 0)
 		/* eventually, we can figure out the real queue depth */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


