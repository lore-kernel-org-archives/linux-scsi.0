From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 12/12] scsi/ufs: qcom: Don't free resource-managed kmalloc element
Date: Sun, 30 Oct 2016 01:52:14 +0530
Message-ID: <1477772534-14170-13-git-send-email-vivek.gautam@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Host is allocated by managed kmalloc (devm_kmalloc). The
memory allocated with this function is automatically
freed on driver detach.
So, no need to make an exclusive free call over it.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---

New patch added in v3 of this cleanup series.

 drivers/scsi/ufs/ufs-qcom.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9590df5..60a38b1 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1263,7 +1263,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 out_unregister_bus:
 	phy_exit(host->generic_phy);
 out_host_free:
-	devm_kfree(dev, host);
 	ufshcd_set_variant(hba, NULL);
 out:
 	return err;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
