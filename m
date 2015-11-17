From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 26/32] scsi: hisi_sas: add bcast interrupt handler
Date: Wed, 18 Nov 2015 00:50:53 +0800
Message-ID: <1447779059-136143-27-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is for expander broadcast event.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 1723dd4..ad50aed 100644
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
