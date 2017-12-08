From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/19] scsi: hisi_sas: relocate clearing ITCT and freeing device
Date: Sat, 9 Dec 2017 01:16:34 +0800
Message-ID: <1512753410-50924-4-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

In certain scenarios we may just want to clear the ITCT for
a device, and not free other resources like the SATA bitmap
using in v2 hw.

To facilitate this, this patch relocates the code of clearing
ITCT from free_device() to an new hw interface clear_itct().
Then for some hw, we should not realise free_device() if there's
nothing left to do for it.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  7 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 16 +++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 ++--
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 83357b03..b2534ca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -205,8 +205,9 @@ struct hisi_sas_hw {
 	void (*phy_set_linkrate)(struct hisi_hba *hisi_hba, int phy_no,
 			struct sas_phy_linkrates *linkrates);
 	enum sas_linkrate (*phy_get_max_linkrate)(void);
-	void (*free_device)(struct hisi_hba *hisi_hba,
+	void (*clear_itct)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
+	void (*free_device)(struct hisi_sas_device *sas_dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
 	void (*dereg_device)(struct hisi_hba *hisi_hba,
 				struct domain_device *device);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d842530..6446ce2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -743,7 +743,10 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 
 	hisi_sas_dereg_device(hisi_hba, device);
 
-	hisi_hba->hw->free_device(hisi_hba, sas_dev);
+	hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
+	if (hisi_hba->hw->free_device)
+		hisi_hba->hw->free_device(sas_dev);
+
 	device->lldd_dev = NULL;
 	memset(sas_dev, 0, sizeof(*sas_dev));
 	sas_dev->dev_type = SAS_PHY_UNUSED;
@@ -1001,7 +1004,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba,
 				|| !device || (device->port != sas_port))
 			continue;
 
-		hisi_hba->hw->free_device(hisi_hba, sas_dev);
+		hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
 
 		/* Update linkrate of directly attached device. */
 		if (!device->parent)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index dc6eca8..8cb9061 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -544,7 +544,7 @@ static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 				(0xff00ULL << ITCT_HDR_REJ_OPEN_TL_OFF));
 }
 
-static void free_device_v1_hw(struct hisi_hba *hisi_hba,
+static void clear_itct_v1_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
 {
 	u64 dev_id = sas_dev->device_id;
@@ -1850,7 +1850,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	.hw_init = hisi_sas_v1_init,
 	.setup_itct = setup_itct_v1_hw,
 	.sl_notify = sl_notify_v1_hw,
-	.free_device = free_device_v1_hw,
+	.clear_itct = clear_itct_v1_hw,
 	.prep_smp = prep_smp_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
 	.get_free_slot = get_free_slot_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 5d3467f..cd9cd84 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -952,7 +952,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 					(0x1ULL << ITCT_HDR_RTOLT_OFF));
 }
 
-static void free_device_v2_hw(struct hisi_hba *hisi_hba,
+static void clear_itct_v2_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
 {
 	DECLARE_COMPLETION_ONSTACK(completion);
@@ -963,10 +963,6 @@ static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 
 	sas_dev->completion = &completion;
 
-	/* SoC bug workaround */
-	if (dev_is_sata(sas_dev->sas_device))
-		clear_bit(sas_dev->sata_idx, hisi_hba->sata_dev_bitmap);
-
 	/* clear the itct interrupt state */
 	if (ENT_INT_SRC3_ITC_INT_MSK & reg_val)
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
@@ -981,6 +977,15 @@ static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 	}
 }
 
+static void free_device_v2_hw(struct hisi_sas_device *sas_dev)
+{
+	struct hisi_hba *hisi_hba = sas_dev->hisi_hba;
+
+	/* SoC bug workaround */
+	if (dev_is_sata(sas_dev->sas_device))
+		clear_bit(sas_dev->sata_idx, hisi_hba->sata_dev_bitmap);
+}
+
 static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
 {
 	int i, reset_val;
@@ -3415,6 +3420,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 	.alloc_dev = alloc_dev_quirk_v2_hw,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
+	.clear_itct = clear_itct_v2_hw,
 	.free_device = free_device_v2_hw,
 	.prep_smp = prep_smp_v2_hw,
 	.prep_ssp = prep_ssp_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 19b1f2f..44f07bc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -588,7 +588,7 @@ static void setup_itct_v3_hw(struct hisi_hba *hisi_hba,
 					(0x1ULL << ITCT_HDR_RTOLT_OFF));
 }
 
-static void free_device_v3_hw(struct hisi_hba *hisi_hba,
+static void clear_itct_v3_hw(struct hisi_hba *hisi_hba,
 			      struct hisi_sas_device *sas_dev)
 {
 	DECLARE_COMPLETION_ONSTACK(completion);
@@ -1951,7 +1951,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V3_HW,
 	.get_wideport_bitmap = get_wideport_bitmap_v3_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
-	.free_device = free_device_v3_hw,
+	.clear_itct = clear_itct_v3_hw,
 	.sl_notify = sl_notify_v3_hw,
 	.prep_ssp = prep_ssp_v3_hw,
 	.prep_smp = prep_smp_v3_hw,
-- 
1.9.1
