From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 9/9] scsi: ufs: enable FASTAUTO mode during low load condition
Date: Fri,  6 Jul 2018 18:00:36 +0530
Message-ID: <e121bd8d45e6789ee00bd4b11803107cc9330a0b.1530880007.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

We are currently running UFS link in HS-G3 FAST mode during high load
condition for best possible performance and in HS-G2 FAST mode during
low load condition to save power. As we are anyway scaling down from
HS-G3 to HS-G2, we can also change the mode from FAST to FASTAUTO.
So we looked at the performance numbers with HS-G2 FASTAUTO mode and
they are good enough for most of the low bandwidth usecases. But Samsung
UFS memory devices are exception which has really low sequential read
throughput in FAST AUTO mode hence we will only be enabling FAST AUTO mode
for other UFS device vendors.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 50588cf..a6e43f9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1088,6 +1088,10 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 			/* scale down gear */
 			new_pwr_info.gear_tx = UFS_MIN_GEAR_TO_SCALE_DOWN;
 			new_pwr_info.gear_rx = UFS_MIN_GEAR_TO_SCALE_DOWN;
+			if (!(hba->dev_quirks & UFS_DEVICE_NO_FASTAUTO)) {
+				new_pwr_info.pwr_tx = FASTAUTO_MODE;
+				new_pwr_info.pwr_rx = FASTAUTO_MODE;
+			}
 		}
 	}
 
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
