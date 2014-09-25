From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V6 02/18] scsi: sysfs: don't add scsi_device if its already added
Date: Thu, 25 Sep 2014 15:32:20 +0300
Message-ID: <1411648356-3883-3-git-send-email-draviv@codeaurora.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:52607 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaIYMc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 08:32:57 -0400
In-Reply-To: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

If LLD has added scsi device (by calling scsi_add_device) before scheduling
async scsi_scan_host then scsi_finish_async_scan() will end up calling
scsi_sysfs_add_sdev for scsi device which was already added by LLD.
This patch fixes this issue by skipping the call to scsi_sysfs_add_sdev()
if it's already visible to rest of the kernel.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1095d5a..c6c5716 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1746,6 +1746,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 		/* target removed before the device could be added */
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
+		/* If device is already visible, skip adding it to sysfs */
+		if (sdev->is_visible)
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

