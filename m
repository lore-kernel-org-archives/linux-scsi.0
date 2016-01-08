From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/23] hisi_sas: add v2 phy init code
Date: Fri, 8 Jan 2016 22:15:30 +0800
Message-ID: <1452262542-64589-12-git-send-email-john.garry@huawei.com>
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
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 49 ++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 6ab0503..325b287 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -288,6 +288,15 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	return readl(regs);
 }
 
+static void config_phy_opt_mode_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg &= ~PHY_CFG_DC_OPT_MSK;
+	cfg |= 1 << PHY_CFG_DC_OPT_OFF;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
 static void config_id_frame_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct sas_identify_frame identify_frame;
@@ -562,6 +571,44 @@ static int hw_init_v2_hw(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
+static void enable_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	cfg |= PHY_CFG_ENA_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
+}
+
+static void start_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	config_id_frame_v2_hw(hisi_hba, phy_no);
+	config_phy_opt_mode_v2_hw(hisi_hba, phy_no);
+	enable_phy_v2_hw(hisi_hba, phy_no);
+}
+
+static void start_phys_v2_hw(unsigned long data)
+{
+	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		start_phy_v2_hw(hisi_hba, i);
+}
+
+static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+	struct timer_list *timer = &hisi_hba->timer;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0x6a);
+		hisi_sas_phy_read32(hisi_hba, i, CHL_INT2_MSK);
+	}
+
+	setup_timer(timer, start_phys_v2_hw, (unsigned long)hisi_hba);
+	mod_timer(timer, jiffies + HZ);
+}
+
 static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 {
 	int rc;
@@ -570,6 +617,8 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 	if (rc)
 		return rc;
 
+	phys_init_v2_hw(hisi_hba);
+
 	return 0;
 }
 
-- 
1.9.1
