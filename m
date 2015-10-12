From: John Garry <john.garry@huawei.com>
Subject: [PATCH 17/25] scsi: hisi_sas: add abnormal irq handler
Date: Mon, 12 Oct 2015 23:20:29 +0800
Message-ID: <1444663237-238302-18-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12591 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbbJLPIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:08:31 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add abnormal irq handler. This handler is concerned with
phy down event.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 24 +++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 56 ++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3516d6f..3f61a4a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -354,6 +354,7 @@ void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
 int hisi_sas_dev_found(struct domain_device *dev);
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags);
 void hisi_sas_port_formed(struct asd_sas_phy *sas_phy);
+void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy);
 void hisi_sas_wq_process(struct work_struct *work);
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			struct hisi_sas_slot *slot);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 44cb9085..fbc2cca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -529,3 +529,27 @@ void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 {
 	hisi_sas_port_notify_formed(sas_phy, 1);
 }
+static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
+{
+	phy->phy_attached = 0;
+	phy->phy_type = 0;
+}
+
+void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
+
+	if (rdy) {
+		/* Phy down but ready */
+		hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+		hisi_sas_port_notify_formed(sas_phy, 0);
+	} else {
+		/* Phy down and not ready */
+		sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+		phy->phy_attached = 0;
+		sas_phy_disconnected(sas_phy);
+		hisi_sas_phy_disconnected(phy);
+	}
+}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index e8b9dc3..fadd163 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1342,7 +1342,61 @@ end:
 	return res;
 }
 
+static irqreturn_t int_abnormal_v1_hw(int irq, void *p)
+{
+	struct hisi_sas_phy *phy = p;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	u32 irq_value, irq_mask_old;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int phy_no = sas_phy->id;
 
+	/* mask_int0 */
+	irq_mask_old = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT0_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK, 0x3fffff);
+
+	/* read int0 */
+	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT0);
+
+	if (irq_value & CHL_INT0_PHYCTRL_NOTRDY_MSK) {
+		u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
+
+		hisi_sas_phy_down(hisi_hba,
+			phy_no,
+			(phy_state & 1 << phy_no) ? 1 : 0);
+	}
+
+	if (irq_value & CHL_INT0_ID_TIMEOUT_MSK)
+		dev_dbg(dev, "abnormal: ID_TIMEOUT phy%d identify timeout\n",
+			phy_no);
+
+	if (irq_value & CHL_INT0_DWS_LOST_MSK)
+		dev_dbg(dev, "abnormal: DWS_LOST phy%d dws lost\n", phy_no);
+
+	if (irq_value & CHL_INT0_SN_FAIL_NGR_MSK)
+		dev_dbg(dev, "abnormal: SN_FAIL_NGR phy%d sn fail ngr\n",
+			phy_no);
+
+	if (irq_value & CHL_INT0_SL_IDAF_FAIL_MSK ||
+		irq_value & CHL_INT0_SL_OPAF_FAIL_MSK)
+		dev_dbg(dev, "abnormal: SL_ID/OPAF_FAIL phy%d check adr frm err\n",
+			phy_no);
+
+	if (irq_value & CHL_INT0_SL_PS_FAIL_OFF)
+		dev_dbg(dev, "abnormal: SL_PS_FAIL phy%d fail\n", phy_no);
+
+	/* write to zero */
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, irq_value);
+
+	if (irq_value & CHL_INT0_PHYCTRL_NOTRDY_MSK)
+		hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK,
+				0x3fffff & ~CHL_INT0_MSK_PHYCTRL_NOTRDY_MSK);
+	else
+		hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0_MSK,
+				irq_mask_old);
+
+	return IRQ_HANDLED;
+}
 
 static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 {
@@ -1397,12 +1451,14 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 	{"Phy Up"},
+	{"Abnormal"},
 };
 
 static const char cq_int_name[32] = "cq";
 
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phyup_v1_hw,
+	int_abnormal_v1_hw
 };
 
 int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
-- 
1.9.1

