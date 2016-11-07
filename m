From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/11] hisi_sas: add PHY set linkrate support for v1 and v2 hw
Date: Mon, 7 Nov 2016 20:48:40 +0800
Message-ID: <1478522920-108145-12-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add the function to set PHY min and max linkrate through
sysfs interface.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 12 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 45 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 45 ++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 8b5ecc6..c0cd505 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -168,6 +168,9 @@ struct hisi_sas_hw {
 	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_hard_reset)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*phy_set_linkrate)(struct hisi_hba *hisi_hba, int phy_no,
+			struct sas_phy_linkrates *linkrates);
+	enum sas_linkrate (*phy_get_max_linkrate)(void);
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 18e2194..6d6f150 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -369,9 +369,14 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 		struct sas_phy *sphy = sas_phy->phy;
 
 		sphy->negotiated_linkrate = sas_phy->linkrate;
-		sphy->minimum_linkrate = phy->minimum_linkrate;
 		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-		sphy->maximum_linkrate = phy->maximum_linkrate;
+		sphy->maximum_linkrate_hw =
+			hisi_hba->hw->phy_get_max_linkrate();
+		if (sphy->minimum_linkrate == SAS_LINK_RATE_UNKNOWN)
+			sphy->minimum_linkrate = phy->minimum_linkrate;
+
+		if (sphy->maximum_linkrate == SAS_LINK_RATE_UNKNOWN)
+			sphy->maximum_linkrate = phy->maximum_linkrate;
 	}
 
 	if (phy->phy_type & PORT_TYPE_SAS) {
@@ -645,6 +650,9 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 
 	case PHY_FUNC_SET_LINK_RATE:
+		hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, funcdata);
+		break;
+
 	case PHY_FUNC_RELEASE_SPINUP_HOLD:
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 05177fc..8a1be0b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -843,6 +843,49 @@ static void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+static enum sas_linkrate phy_get_max_linkrate_v1_hw(void)
+{
+	return SAS_LINK_RATE_6_0_GBPS;
+}
+
+static void phy_set_linkrate_v1_hw(struct hisi_hba *hisi_hba, int phy_no,
+		struct sas_phy_linkrates *r)
+{
+	u32 prog_phy_link_rate =
+		hisi_sas_phy_read32(hisi_hba, phy_no, PROG_PHY_LINK_RATE);
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int i;
+	enum sas_linkrate min, max;
+	u32 rate_mask = 0;
+
+	if (r->maximum_linkrate == SAS_LINK_RATE_UNKNOWN) {
+		max = sas_phy->phy->maximum_linkrate;
+		min = r->minimum_linkrate;
+	} else if (r->minimum_linkrate == SAS_LINK_RATE_UNKNOWN) {
+		max = r->maximum_linkrate;
+		min = sas_phy->phy->minimum_linkrate;
+	} else
+		return;
+
+	sas_phy->phy->maximum_linkrate = max;
+	sas_phy->phy->minimum_linkrate = min;
+
+	min -= SAS_LINK_RATE_1_5_GBPS;
+	max -= SAS_LINK_RATE_1_5_GBPS;
+
+	for (i = 0; i <= max; i++)
+		rate_mask |= 1 << (i * 2);
+
+	prog_phy_link_rate &= ~0xff;
+	prog_phy_link_rate |= rate_mask;
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, PROG_PHY_LINK_RATE,
+			prog_phy_link_rate);
+
+	phy_hard_reset_v1_hw(hisi_hba, phy_no);
+}
+
 static int get_wideport_bitmap_v1_hw(struct hisi_hba *hisi_hba, int port_id)
 {
 	int i, bitmap = 0;
@@ -1818,6 +1861,8 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	.phy_enable = enable_phy_v1_hw,
 	.phy_disable = disable_phy_v1_hw,
 	.phy_hard_reset = phy_hard_reset_v1_hw,
+	.phy_set_linkrate = phy_set_linkrate_v1_hw,
+	.phy_get_max_linkrate = phy_get_max_linkrate_v1_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v1_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V1_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e88113a..15487f2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1060,6 +1060,49 @@ static void sl_notify_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+static enum sas_linkrate phy_get_max_linkrate_v2_hw(void)
+{
+	return SAS_LINK_RATE_12_0_GBPS;
+}
+
+static void phy_set_linkrate_v2_hw(struct hisi_hba *hisi_hba, int phy_no,
+		struct sas_phy_linkrates *r)
+{
+	u32 prog_phy_link_rate =
+		hisi_sas_phy_read32(hisi_hba, phy_no, PROG_PHY_LINK_RATE);
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int i;
+	enum sas_linkrate min, max;
+	u32 rate_mask = 0;
+
+	if (r->maximum_linkrate == SAS_LINK_RATE_UNKNOWN) {
+		max = sas_phy->phy->maximum_linkrate;
+		min = r->minimum_linkrate;
+	} else if (r->minimum_linkrate == SAS_LINK_RATE_UNKNOWN) {
+		max = r->maximum_linkrate;
+		min = sas_phy->phy->minimum_linkrate;
+	} else
+		return;
+
+	sas_phy->phy->maximum_linkrate = max;
+	sas_phy->phy->minimum_linkrate = min;
+
+	min -= SAS_LINK_RATE_1_5_GBPS;
+	max -= SAS_LINK_RATE_1_5_GBPS;
+
+	for (i = 0; i <= max; i++)
+		rate_mask |= 1 << (i * 2);
+
+	prog_phy_link_rate &= ~0xff;
+	prog_phy_link_rate |= rate_mask;
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, PROG_PHY_LINK_RATE,
+			prog_phy_link_rate);
+
+	phy_hard_reset_v2_hw(hisi_hba, phy_no);
+}
+
 static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
 {
 	int i, bitmap = 0;
@@ -2739,6 +2782,8 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 	.phy_enable = enable_phy_v2_hw,
 	.phy_disable = disable_phy_v2_hw,
 	.phy_hard_reset = phy_hard_reset_v2_hw,
+	.phy_set_linkrate = phy_set_linkrate_v2_hw,
+	.phy_get_max_linkrate = phy_get_max_linkrate_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 };
-- 
1.9.1
