From: John Garry <john.garry@huawei.com>
Subject: [PATCH 19/25] scsi: hisi_sas: add bcast interrupt handler
Date: Mon, 12 Oct 2015 23:20:31 +0800
Message-ID: <1444663237-238302-20-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:11911 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbJLPFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:05:37 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

This is for expander broadcast event.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2de54a7..2ad2ffa 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1370,6 +1370,35 @@ end:
 	return res;
 }
 
+static irqreturn_t int_bcast_v1_hw(int irq, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	u32 irq_value;
+	irqreturn_t res = IRQ_HANDLED;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int phy_no = sas_phy->id;
+	struct sas_ha_struct *sha = &hisi_hba->sha;
+	struct device *dev = &hisi_hba->pdev->dev;
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
+			CHL_INT2_SL_RX_BC_ACK_MSK);
+
+	return res;
+}
+
 static irqreturn_t int_abnormal_v1_hw(int irq, void *p)
 {
 	struct hisi_sas_phy *phy = p;
@@ -1478,6 +1507,7 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 }
 
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
+	{"Bcast"},
 	{"Phy Up"},
 	{"Abnormal"},
 };
@@ -1485,6 +1515,7 @@ static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 static const char cq_int_name[32] = "cq";
 
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
+	int_bcast_v1_hw,
 	int_phyup_v1_hw,
 	int_abnormal_v1_hw
 };
-- 
1.9.1

