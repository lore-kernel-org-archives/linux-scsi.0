From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 5/6] scsi: ufs: fix unloading module while runtime suspended
Date: Sun,  2 Aug 2015 02:19:19 +0900
Message-ID: <1438449560-4106-6-git-send-email-akinobu.mita@gmail.com>
References: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33111 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbHARUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2015 13:20:00 -0400
Received: by padck2 with SMTP id ck2so59214357pad.0
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2015 10:20:00 -0700 (PDT)
In-Reply-To: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>

The ufs driver calls scsi_device_get() in ufshcd_set_dev_pwr_mode()
in order to avoid manual delete of UFS device W-LUN by holding the
reference.

But scsi_device_get() has been changed to fail when the LLD module is
in the process of being unloaded.  So it no longer doesn't work if the
module is unloaded while the device is runtime suspended.
(i.e. driver_detach -> ... pm_runtime_get_sync() ... ->
ufshcd_runtime_resume -> ufshcd_resume -> ufshcd_set_dev_pwr_mode ->
scsi_device_get -> try_module_get -> return -ENXIO)

As the reason for scsi_device_get() is to avoid manual delete of UFS
device W-LUN, this acquires shost->scan_mutex lock instead of
scsi_device_get() to work around the problem.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d425816..d287207 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4792,23 +4792,19 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
+	mutex_lock(&hba->host->scan_mutex);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
-	if (sdp) {
-		ret = scsi_device_get(sdp);
-		if (!ret && !scsi_device_online(sdp)) {
-			ret = -ENODEV;
-			scsi_device_put(sdp);
-		}
-	} else {
+	if (!sdp || !scsi_device_online(sdp))
 		ret = -ENODEV;
-	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	if (ret)
+	if (ret) {
+		mutex_unlock(&hba->host->scan_mutex);
 		return ret;
+	}
 
 	/*
 	 * If scsi commands fail, the scsi mid-layer schedules scsi error-
@@ -4845,7 +4841,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	if (!ret)
 		hba->curr_dev_pwr_mode = pwr_mode;
 out:
-	scsi_device_put(sdp);
+	mutex_unlock(&hba->host->scan_mutex);
 	hba->host->eh_noresume = 0;
 	return ret;
 }
-- 
1.9.1

