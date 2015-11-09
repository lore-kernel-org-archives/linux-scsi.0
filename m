From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 26/32] scsi: hisi_sas: add bcast interrupt handler
Date: Tue, 10 Nov 2015 00:32:31 +0800
Message-ID: <1447086757-147706-27-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This is for expander broadcast event.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 925c454..8f66d06 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1333,6 +1333,35 @@ end:
 	return res;
 }
 
+static irqreturn_t int_bcast_v1_hw(int irq, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sha = &hisi_hba->sha;
+	struct device *dev = &hisi_hba->pdev->dev;
+	int phy_no = sas_phy->id;
+	u32 irq_value;
+	irqreturn_t res = IRQ_HANDLED;
+
+	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2);
+
+	if (!(irq_value & CHL_INT2_SL_RX_BC_ACK_MSK)) {
+		dev_err(dev, "bcast: irq_value = %x not set enable bit",
+			irq_value);
+		res = IRQ_NONE;
+		goto end;
+	}
+
+	sha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+
+end:
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
+			     CHL_INT2_SL_RX_BC_ACK_MSK);
+
+	return res;
+}
+
 static irqreturn_t int_abnormal_v1_hw(int irq, void *p)
 {
 	struct hisi_sas_phy *phy = p;
@@ -1438,12 +1467,14 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 }
 
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
+	{"Bcast"},
 	{"Phy Up"},
 	{"Abnormal"},
 };
 
 static const char cq_int_name[32] = "cq";
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
+	int_bcast_v1_hw,
 	int_phyup_v1_hw,
 	int_abnormal_v1_hw
 };
-- 
1.9.1
