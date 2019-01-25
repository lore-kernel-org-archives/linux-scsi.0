From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/13] scsi: hisi_sas: send primitive NOTIFY to SSP situation only
Date: Fri, 25 Jan 2019 22:22:30 +0800
Message-ID: <1548426159-225679-5-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Send primitive NOTIFY to SSP situation only, or it causes underflow issue
when sending IO. And also rename hisi_sas_hw.sl_notify() to hisi_sas_hw.
sl_notify_ssp().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5bb6759..97f0fda 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -246,7 +246,7 @@ struct hisi_sas_hw {
 	int (*slot_index_alloc)(struct hisi_hba *hisi_hba,
 				struct domain_device *device);
 	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
-	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*sl_notify_ssp)(struct hisi_hba *hisi_hba, int phy_no);
 	int (*get_free_slot)(struct hisi_hba *hisi_hba, struct hisi_sas_dq *dq);
 	void (*start_delivery)(struct hisi_sas_dq *dq);
 	void (*prep_ssp)(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c0aacb0..e586660 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -778,7 +778,8 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	int phy_no = sas_phy->id;
 
-	hisi_hba->hw->sl_notify(hisi_hba, phy_no); /* This requires a sleep */
+	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
+		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
 	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 28ab52a..c8f808f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -835,7 +835,7 @@ static void phys_init_v1_hw(struct hisi_hba *hisi_hba)
 	mod_timer(timer, jiffies + HZ);
 }
 
-static void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+static void sl_notify_ssp_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 sl_control;
 
@@ -1826,7 +1826,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
 	.setup_itct = setup_itct_v1_hw,
-	.sl_notify = sl_notify_v1_hw,
+	.sl_notify_ssp = sl_notify_ssp_v1_hw,
 	.clear_itct = clear_itct_v1_hw,
 	.prep_smp = prep_smp_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9506ab1..fc0bcfa 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1589,7 +1589,7 @@ static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void sl_notify_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+static void sl_notify_ssp_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 sl_control;
 
@@ -3625,7 +3625,7 @@ static void debugfs_snapshot_restore_v2_hw(struct hisi_hba *hisi_hba)
 	.setup_itct = setup_itct_v2_hw,
 	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
 	.alloc_dev = alloc_dev_quirk_v2_hw,
-	.sl_notify = sl_notify_v2_hw,
+	.sl_notify_ssp = sl_notify_ssp_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
 	.clear_itct = clear_itct_v2_hw,
 	.free_device = free_device_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b780b52..726ac4bd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -870,7 +870,7 @@ static void phys_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void sl_notify_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+static void sl_notify_ssp_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 sl_control;
 
@@ -2520,7 +2520,7 @@ static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
 	.get_wideport_bitmap = get_wideport_bitmap_v3_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
 	.clear_itct = clear_itct_v3_hw,
-	.sl_notify = sl_notify_v3_hw,
+	.sl_notify_ssp = sl_notify_ssp_v3_hw,
 	.prep_ssp = prep_ssp_v3_hw,
 	.prep_smp = prep_smp_v3_hw,
 	.prep_stp = prep_ata_v3_hw,
-- 
1.9.1
