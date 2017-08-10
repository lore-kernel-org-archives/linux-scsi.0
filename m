From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/19] scsi: hisi_sas: service interrupt ITCT_CLR interrupt in v2 hw
Date: Fri, 11 Aug 2017 00:09:33 +0800
Message-ID: <1502381384-219889-9-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This patch is a fix related to free'ing a device in
v2 hw driver.

Before, we polled to ITCT CLR interrupt to check if
a device is free.

This was error prone, as if the interrupt doesn't occur
in 10us, we miss processing it.

To avoid this situation, service this interrupt and
sync the event with a completion.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 40 ++++++++++++++++------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index ad6b2d1..23a22dc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -141,6 +141,7 @@ struct hisi_sas_dq {
 struct hisi_sas_device {
 	struct hisi_hba		*hisi_hba;
 	struct domain_device	*sas_device;
+	struct completion *completion;
 	struct hisi_sas_dq	*dq;
 	struct list_head	list;
 	u64 attached_phy;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9eea0b4..0e3634e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -974,12 +974,14 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
 {
+	DECLARE_COMPLETION_ONSTACK(completion);
 	u64 dev_id = sas_dev->device_id;
-	struct device *dev = hisi_hba->dev;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
 	u32 reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
 	int i;
 
+	sas_dev->completion = &completion;
+
 	/* SoC bug workaround */
 	if (dev_is_sata(sas_dev->sas_device))
 		clear_bit(sas_dev->sata_idx, hisi_hba->sata_dev_bitmap);
@@ -989,28 +991,12 @@ static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 				 ENT_INT_SRC3_ITC_INT_MSK);
 
-	/* clear the itct int*/
 	for (i = 0; i < 2; i++) {
-		/* clear the itct table*/
-		reg_val = hisi_sas_read32(hisi_hba, ITCT_CLR);
-		reg_val |= ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
+		reg_val = ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
 		hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
+		wait_for_completion(sas_dev->completion);
 
-		udelay(10);
-		reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
-		if (ENT_INT_SRC3_ITC_INT_MSK & reg_val) {
-			dev_dbg(dev, "got clear ITCT done interrupt\n");
-
-			/* invalid the itct state*/
-			memset(itct, 0, sizeof(struct hisi_sas_itct));
-			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
-					 ENT_INT_SRC3_ITC_INT_MSK);
-
-			/* clear the itct */
-			hisi_sas_write32(hisi_hba, ITCT_CLR, 0);
-			dev_dbg(dev, "clear ITCT ok\n");
-			break;
-		}
+		memset(itct, 0, sizeof(struct hisi_sas_itct));
 	}
 }
 
@@ -1191,7 +1177,7 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC3, 0xffffffff);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0x7efefefe);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0x7efefefe);
-	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0x7ffffffe);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0x7ffe20fe);
 	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0xfff00c30);
 	for (i = 0; i < hisi_hba->queue_count; i++)
 		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK+0x4*i, 0);
@@ -3092,8 +3078,20 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 			      irq_value);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
+
+		if (irq_value & BIT(ENT_INT_SRC3_ITC_INT_OFF)) {
+			u32 reg_val = hisi_sas_read32(hisi_hba, ITCT_CLR);
+			u32 dev_id = reg_val & ITCT_DEV_MSK;
+			struct hisi_sas_device *sas_dev =
+					&hisi_hba->devices[dev_id];
+
+			hisi_sas_write32(hisi_hba, ITCT_CLR, 0);
+			dev_dbg(dev, "clear ITCT ok\n");
+			complete(sas_dev->completion);
+		}
 	}
 
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC3, irq_value);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, irq_msk);
 
 	return IRQ_HANDLED;
-- 
1.9.1
