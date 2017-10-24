From: John Garry <john.garry@huawei.com>
Subject: [PATCH 16/19] scsi: hisi_sas: fix a bug when free device for v3 hw
Date: Tue, 24 Oct 2017 23:51:46 +0800
Message-ID: <1508860309-212397-17-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Use completion to wait on ITCT CLR interrupt finishing before
processing other things when freeing a device.

This is safer than the pre-existing process of polling the
register.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 1f8995b..243fa1d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -393,7 +393,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC3, 0xffffffff);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0xfefefefe);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0xfefefefe);
-	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0xfffe20ff);
 	hisi_sas_write32(hisi_hba, CHNL_PHYUPDOWN_INT_MSK, 0x0);
 	hisi_sas_write32(hisi_hba, CHNL_ENT_INT_MSK, 0x0);
 	hisi_sas_write32(hisi_hba, HGC_COM_INT_MSK, 0x0);
@@ -582,35 +582,24 @@ static void setup_itct_v3_hw(struct hisi_hba *hisi_hba,
 static void free_device_v3_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
 {
+	DECLARE_COMPLETION_ONSTACK(completion);
 	u64 dev_id = sas_dev->device_id;
-	struct device *dev = hisi_hba->dev;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
 	u32 reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
 
+	sas_dev->completion = &completion;
+
 	/* clear the itct interrupt state */
 	if (ENT_INT_SRC3_ITC_INT_MSK & reg_val)
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 				 ENT_INT_SRC3_ITC_INT_MSK);
 
 	/* clear the itct table*/
-	reg_val = hisi_sas_read32(hisi_hba, ITCT_CLR);
-	reg_val |= ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
+	reg_val = ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
 	hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
 
-	udelay(10);
-	reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
-	if (ENT_INT_SRC3_ITC_INT_MSK & reg_val) {
-		dev_dbg(dev, "got clear ITCT done interrupt\n");
-
-		/* invalid the itct state*/
-		memset(itct, 0, sizeof(struct hisi_sas_itct));
-		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
-				 ENT_INT_SRC3_ITC_INT_MSK);
-
-		/* clear the itct */
-		hisi_sas_write32(hisi_hba, ITCT_CLR, 0);
-		dev_dbg(dev, "clear ITCT ok\n");
-	}
+	wait_for_completion(sas_dev->completion);
+	memset(itct, 0, sizeof(struct hisi_sas_itct));
 }
 
 static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
-- 
1.9.1
