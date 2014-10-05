From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH 1/1] ufs: scsi: fix sparse errors in ufshcd_system_suspend
Date: Sun, 5 Oct 2014 15:44:16 -0700
Message-ID: <000301cfe0ed$e5221200$af663600$@codeaurora.org>
References: <1412518207-27135-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1412518207-27135-1-git-send-email-draviv@codeaurora.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com
List-Id: linux-scsi@vger.kernel.org

Looks good, Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dolev Raviv
Sent: Sunday, October 05, 2014 7:10 AM
To: James.Bottomley@HansenPartnership.com; hch@infradead.org
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org;
santoshsy@gmail.com; Dolev Raviv
Subject: [PATCH 1/1] ufs: scsi: fix sparse errors in ufshcd_system_suspend

This patch fixes newly introduced sparse warning in ufshcd_system_suspend,
introduced by UFS power management series.

Sparse warning:
drivers/scsi/ufs/ufshcd.c:5118 ufshcd_system_suspend()
error: we previously assumed 'hba' could be null (see line 5089)

To fix it, we return 0 in case HBA is not initialized or is not powered.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
497c38a..836ea72 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5087,7 +5087,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 
 	if (!hba || !hba->is_powered)
-		goto out;
+		return 0;
 
 	if (pm_runtime_suspended(hba->dev)) {
 		if (hba->rpm_lvl == hba->spm_lvl)
--
1.8.5.2
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
