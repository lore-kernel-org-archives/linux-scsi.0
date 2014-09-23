From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V4 09/17] scsi: ufs: manually add well known logical units
Date: Tue, 23 Sep 2014 10:31:31 +0300
Message-ID: <1411457499-8074-10-git-send-email-draviv@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

According to SELECT REPORT field (of REPORT LUNS command) from SPC-4
(SCSI Primary Commands) specification, device should report all the LUNs
(which support any of the addressing method specified in the description).
Note that UFS W-LUs follow the extended logical unit addressing mothod
hence according to SPC specification all the UFS W-LUs should be reported
when SELECT REPORT field is to 00h.
But it seems UFS specification has modified the meaning of SELECT REPORT
field when its set to 00h. When SELECT REPORT field is cleared, device
should only report LUs which support peripheral device addressing method.
Even UFS Test specification seems to confirm this diversion from the spec.
Hence it's reasonable for the UFS devices adhering to the UFS device
specification to not report the W-LUs when SELECT REPORT is 00h.

scsi_scan_host() would only scan LUs with SELECT REPORT set to 00h hence
this patch manually add the UFS well known logical units.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc89c48..1c5422b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -902,6 +902,17 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 /**
+ * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
+ * @scsi_lun: UPIU W-LUN id
+ *
+ * Returns SCSI W-LUN id
+ */
+static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
+{
+	return (upiu_wlun_id & ~UFS_UPIU_WLUN_ID) | SCSI_W_LUN_BASE;
+}
+
+/**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @cmd: command from SCSI Midlayer
  * @done: call back function
@@ -3415,6 +3426,15 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		if (!hba->is_init_prefetch)
 			ufshcd_init_icc_levels(hba);
 
+		scsi_add_device(hba->host, 0, 0,
+			ufshcd_upiu_wlun_to_scsi_wlun(
+					UFS_UPIU_UFS_DEVICE_WLUN));
+		scsi_add_device(hba->host, 0, 0,
+			ufshcd_upiu_wlun_to_scsi_wlun(
+					UFS_UPIU_BOOT_WLUN));
+		scsi_add_device(hba->host, 0, 0,
+			ufshcd_upiu_wlun_to_scsi_wlun(
+					UFS_UPIU_RPMB_WLUN));
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
