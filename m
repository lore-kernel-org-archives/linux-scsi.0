From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V5 02/17] scsi: sysfs: don't add scsi_device if its already added
Date: Wed, 24 Sep 2014 18:13:58 +0300
Message-ID: <1411571653-22729-3-git-send-email-draviv@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48507 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaIXPOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 11:14:41 -0400
In-Reply-To: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

If LLD has added scsi device (by calling scsi_add_device) before scheduling
async scsi_scan_host then scsi_finish_async_scan() will end up calling
scsi_sysfs_add_sdev for scsi device which was already added by LLD.
This patch fixes this issue by adding a check at the start of
scsi_sysfs_add_sdev() to skip the device add if it's already visible to
rest of the kernel.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 3524b68..00890b3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1027,6 +1027,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	struct request_queue *rq = sdev->request_queue;
 	struct scsi_target *starget = sdev->sdev_target;
 
+	if (sdev->is_visible)
+		return 0;
+
 	error = scsi_device_set_state(sdev, SDEV_RUNNING);
 	if (error)
 		return error;
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

