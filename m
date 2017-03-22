From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/23] scsi: hisi_sas: move PHY init to hisi_sas_scan_start()
Date: Thu, 23 Mar 2017 01:25:19 +0800
Message-ID: <1490203539-228029-4-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Relocate the PHY init code from LLDD hw init path
to hisi_sas_scan_start().

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 9 +++------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 3 +--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 3 +--
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fd76a02..2135de9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -167,6 +167,7 @@ struct hisi_sas_hw {
 			  int device_id, int abort_flag, int tag_to_abort);
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_slot *slot, int abort);
+	void (*phys_init)(struct hisi_hba *hisi_hba);
 	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_hard_reset)(struct hisi_hba *hisi_hba, int phy_no);
@@ -195,7 +196,6 @@ struct hisi_hba {
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	int n_phy;
-	int scan_finished;
 	spinlock_t lock;
 
 	struct timer_list timer;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index cbaef90..b86a228 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -493,12 +493,8 @@ static int hisi_sas_slave_configure(struct scsi_device *sdev)
 static void hisi_sas_scan_start(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
-	int i;
-
-	for (i = 0; i < hisi_hba->n_phy; ++i)
-		hisi_sas_bytes_dmaed(hisi_hba, i);
 
-	hisi_hba->scan_finished = 1;
+	hisi_hba->hw->phys_init(hisi_hba);
 }
 
 static int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
@@ -506,7 +502,8 @@ static int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct sas_ha_struct *sha = &hisi_hba->sha;
 
-	if (hisi_hba->scan_finished == 0)
+	/* Wait for PHY up interrupt to occur */
+	if (time < HZ)
 		return 0;
 
 	sas_drain_work(sha);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 022ad10..43988eb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1847,8 +1847,6 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	if (rc)
 		return rc;
 
-	phys_init_v1_hw(hisi_hba);
-
 	return 0;
 }
 
@@ -1862,6 +1860,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	.get_free_slot = get_free_slot_v1_hw,
 	.start_delivery = start_delivery_v1_hw,
 	.slot_complete = slot_complete_v1_hw,
+	.phys_init = phys_init_v1_hw,
 	.phy_enable = enable_phy_v1_hw,
 	.phy_disable = disable_phy_v1_hw,
 	.phy_hard_reset = phy_hard_reset_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 53651cf..73e4f66 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2864,8 +2864,6 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 	if (rc)
 		return rc;
 
-	phys_init_v2_hw(hisi_hba);
-
 	return 0;
 }
 
@@ -2965,6 +2963,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 	.get_free_slot = get_free_slot_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
 	.slot_complete = slot_complete_v2_hw,
+	.phys_init = phys_init_v2_hw,
 	.phy_enable = enable_phy_v2_hw,
 	.phy_disable = disable_phy_v2_hw,
 	.phy_hard_reset = phy_hard_reset_v2_hw,
-- 
1.9.1
