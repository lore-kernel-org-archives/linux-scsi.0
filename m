From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/7] scsi: hisi_sas: workaround v2 hw SATA IO timeout issue
Date: Fri, 20 Jan 2017 20:45:18 +0800
Message-ID: <1484916324-211630-2-git-send-email-john.garry@huawei.com>
References: <1484916324-211630-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:10726 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdATMOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 07:14:52 -0500
In-Reply-To: <1484916324-211630-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

The v2 SAS controller needs more time to detect channel idle
and send setup link request than SATA disk does, so it is
difficult for the SAS controller to setup an STP link. Therefore
it may cause some IO timeouts.

We need to periodically configure the SAS controller so it
doesn't receive STP setup requests from SATA disks for a while,
so IO can be sent during this period.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 75 +++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 69b0f06..6c787eb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -215,6 +215,7 @@
 #define RX_IDAF_DWORD5			(PORT_BASE + 0xd8)
 #define RX_IDAF_DWORD6			(PORT_BASE + 0xdc)
 #define RXOP_CHECK_CFG_H		(PORT_BASE + 0xfc)
+#define CON_CONTROL			(PORT_BASE + 0x118)
 #define DONE_RECEIVED_TIME		(PORT_BASE + 0x11c)
 #define CHL_INT0			(PORT_BASE + 0x1b4)
 #define CHL_INT0_HOTPLUG_TOUT_OFF	0
@@ -526,6 +527,8 @@ enum {
 #define SATA_PROTOCOL_FPDMA		0x8
 #define SATA_PROTOCOL_ATAPI		0x10
 
+static void hisi_sas_link_timeout_disable_link(unsigned long data);
+
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -978,6 +981,50 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 			 upper_32_bits(hisi_hba->initial_fis_dma));
 }
 
+static void hisi_sas_link_timeout_enable_link(unsigned long data)
+{
+	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
+	int i, reg_val;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		reg_val = hisi_sas_phy_read32(hisi_hba, i, CON_CONTROL);
+		if (!(reg_val & BIT(0))) {
+			hisi_sas_phy_write32(hisi_hba, i,
+					CON_CONTROL, 0x7);
+			break;
+		}
+	}
+
+	hisi_hba->timer.function = hisi_sas_link_timeout_disable_link;
+	mod_timer(&hisi_hba->timer, jiffies + msecs_to_jiffies(900));
+}
+
+static void hisi_sas_link_timeout_disable_link(unsigned long data)
+{
+	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
+	int i, reg_val;
+
+	reg_val = hisi_sas_read32(hisi_hba, PHY_STATE);
+	for (i = 0; i < hisi_hba->n_phy && reg_val; i++) {
+		if (reg_val & BIT(i)) {
+			hisi_sas_phy_write32(hisi_hba, i,
+					CON_CONTROL, 0x6);
+			break;
+		}
+	}
+
+	hisi_hba->timer.function = hisi_sas_link_timeout_enable_link;
+	mod_timer(&hisi_hba->timer, jiffies + msecs_to_jiffies(100));
+}
+
+static void set_link_timer_quirk(struct hisi_hba *hisi_hba)
+{
+	hisi_hba->timer.data = (unsigned long)hisi_hba;
+	hisi_hba->timer.function = hisi_sas_link_timeout_disable_link;
+	hisi_hba->timer.expires = jiffies + msecs_to_jiffies(1000);
+	add_timer(&hisi_hba->timer);
+}
+
 static int hw_init_v2_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
@@ -2020,9 +2067,12 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	if (phy->identify.device_type == SAS_END_DEVICE)
 		phy->identify.target_port_protocols =
 			SAS_PROTOCOL_SSP;
-	else if (phy->identify.device_type != SAS_PHY_UNUSED)
+	else if (phy->identify.device_type != SAS_PHY_UNUSED) {
 		phy->identify.target_port_protocols =
 			SAS_PROTOCOL_SMP;
+		if (!timer_pending(&hisi_hba->timer))
+			set_link_timer_quirk(hisi_hba);
+	}
 	queue_work(hisi_hba->wq, &phy->phyup_ws);
 
 end:
@@ -2033,10 +2083,23 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	return res;
 }
 
+static bool check_any_wideports_v2_hw(struct hisi_hba *hisi_hba)
+{
+	u32 port_state;
+
+	port_state = hisi_sas_read32(hisi_hba, PORT_STATE);
+	if (port_state & 0x1ff)
+		return true;
+
+	return false;
+}
+
 static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int res = 0;
 	u32 phy_state, sl_ctrl, txid_auto;
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct hisi_sas_port *port = phy->port;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
 
@@ -2046,6 +2109,10 @@ static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	sl_ctrl = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
 			     sl_ctrl & ~SL_CONTROL_CTA_MSK);
+	if (port && !get_wideport_bitmap_v2_hw(hisi_hba, port->id))
+		if (!check_any_wideports_v2_hw(hisi_hba) &&
+				timer_pending(&hisi_hba->timer))
+			del_timer(&hisi_hba->timer);
 
 	txid_auto = hisi_sas_phy_read32(hisi_hba, phy_no, TXID_AUTO);
 	hisi_sas_phy_write32(hisi_hba, phy_no, TXID_AUTO,
@@ -2821,6 +2888,12 @@ static int hisi_sas_v2_probe(struct platform_device *pdev)
 
 static int hisi_sas_v2_remove(struct platform_device *pdev)
 {
+	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+
+	if (timer_pending(&hisi_hba->timer))
+		del_timer(&hisi_hba->timer);
+
 	return hisi_sas_remove(pdev);
 }
 
-- 
1.9.1

