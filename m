From: John Garry <john.garry@huawei.com>
Subject: [PATCH v6 21/22] scsi: hisi_sas: add v3 code to fill some more hw function pointers
Date: Wed, 14 Jun 2017 23:33:31 +0800
Message-ID: <1497454412-91194-22-git-send-email-john.garry@huawei.com>
References: <1497454412-91194-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497454412-91194-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add code to fill the interface of phy_hard_reset, phy_get_max_linkrate,
and phy enable/disable.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3cd4b9a..cf1eb47 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -129,6 +129,8 @@
 #define TXID_AUTO				(PORT_BASE + 0xb8)
 #define CT3_OFF		1
 #define CT3_MSK		(0x1 << CT3_OFF)
+#define TX_HARDRST_OFF          2
+#define TX_HARDRST_MSK          (0x1 << TX_HARDRST_OFF)
 #define RX_IDAF_DWORD0			(PORT_BASE + 0xc4)
 #define RXOP_CHECK_CFG_H		(PORT_BASE + 0xfc)
 #define SAS_SSP_CON_TIMER_CFG		(PORT_BASE + 0x134)
@@ -596,6 +598,14 @@ static void enable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg &= ~PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
 static void start_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	config_id_frame_v3_hw(hisi_hba, phy_no);
@@ -603,6 +613,11 @@ static void start_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	enable_phy_v3_hw(hisi_hba, phy_no);
 }
 
+static void stop_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	disable_phy_v3_hw(hisi_hba, phy_no);
+}
+
 static void start_phys_v3_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -611,6 +626,26 @@ static void start_phys_v3_hw(struct hisi_hba *hisi_hba)
 		start_phy_v3_hw(hisi_hba, i);
 }
 
+static void phy_hard_reset_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	u32 txid_auto;
+
+	stop_phy_v3_hw(hisi_hba, phy_no);
+	if (phy->identify.device_type == SAS_END_DEVICE) {
+		txid_auto = hisi_sas_phy_read32(hisi_hba, phy_no, TXID_AUTO);
+		hisi_sas_phy_write32(hisi_hba, phy_no, TXID_AUTO,
+					txid_auto | TX_HARDRST_MSK);
+	}
+	msleep(100);
+	start_phy_v3_hw(hisi_hba, phy_no);
+}
+
+enum sas_linkrate phy_get_max_linkrate_v3_hw(void)
+{
+	return SAS_LINK_RATE_12_0_GBPS;
+}
+
 static void phys_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	start_phys_v3_hw(hisi_hba);
@@ -1574,6 +1609,10 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	.start_delivery = start_delivery_v3_hw,
 	.slot_complete = slot_complete_v3_hw,
 	.phys_init = phys_init_v3_hw,
+	.phy_enable = enable_phy_v3_hw,
+	.phy_disable = disable_phy_v3_hw,
+	.phy_hard_reset = phy_hard_reset_v3_hw,
+	.phy_get_max_linkrate = phy_get_max_linkrate_v3_hw,
 };
 
 static struct Scsi_Host *
-- 
1.9.1
