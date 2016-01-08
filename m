From: John Garry <john.garry@huawei.com>
Subject: [PATCH 22/23] hisi_sas: add v2 tmf functions
Date: Fri, 8 Jan 2016 22:15:41 +0800
Message-ID: <1452262542-64589-23-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 0d9365b..8a8cf18 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -845,6 +845,14 @@ static void enable_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+static void disable_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg &= ~PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
 static void start_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	config_id_frame_v2_hw(hisi_hba, phy_no);
@@ -852,6 +860,18 @@ static void start_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	enable_phy_v2_hw(hisi_hba, phy_no);
 }
 
+static void stop_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	disable_phy_v2_hw(hisi_hba, phy_no);
+}
+
+static void phy_hard_reset_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	stop_phy_v2_hw(hisi_hba, phy_no);
+	msleep(100);
+	start_phy_v2_hw(hisi_hba, phy_no);
+}
+
 static void start_phys_v2_hw(unsigned long data)
 {
 	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
@@ -2146,6 +2166,9 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.get_free_slot = get_free_slot_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
 	.slot_complete = slot_complete_v2_hw,
+	.phy_enable = enable_phy_v2_hw,
+	.phy_disable = disable_phy_v2_hw,
+	.phy_hard_reset = phy_hard_reset_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 };
-- 
1.9.1
