From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RESEND PATCH v2 13/23] hisi_sas: add v2 phy down handler
Date: Tue, 26 Jan 2016 02:47:13 +0800
Message-ID: <1453747643-61875-14-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 49 ++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a7b83bd..35ce7b6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -628,6 +628,29 @@ static void sl_notify_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
+{
+	int i, bitmap = 0;
+	u32 phy_port_num_ma = hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA);
+	u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
+
+	for (i = 0; i < (hisi_hba->n_phy < 9 ? hisi_hba->n_phy : 8); i++)
+		if (phy_state & 1 << i)
+			if (((phy_port_num_ma >> (i * 4)) & 0xf) == port_id)
+				bitmap |= 1 << i;
+
+	if (hisi_hba->n_phy == 9) {
+		u32 port_state = hisi_sas_read32(hisi_hba, PORT_STATE);
+
+		if (phy_state & 1 << 8)
+			if (((port_state & PORT_STATE_PHY8_PORT_NUM_MSK) >>
+			     PORT_STATE_PHY8_PORT_NUM_OFF) == port_id)
+				bitmap |= 1 << 9;
+	}
+
+	return bitmap;
+}
+
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -705,6 +728,25 @@ end:
 	return res;
 }
 
+static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
+{
+	int res = 0;
+	u32 phy_cfg, phy_state;
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
+
+	phy_cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+
+	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
+
+	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, CHL_INT0_NOT_RDY_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 0);
+
+	return res;
+}
+
 static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 {
 	struct hisi_hba *hisi_hba = p;
@@ -726,6 +768,12 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 					goto end;
 				}
 
+			if (irq_value & CHL_INT0_NOT_RDY_MSK)
+				/* phy down */
+				if (phy_down_v2_hw(phy_no, hisi_hba)) {
+					res = IRQ_NONE;
+					goto end;
+				}
 		}
 		irq_msk >>= 1;
 		phy_no++;
@@ -796,6 +844,7 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.sl_notify = sl_notify_v2_hw,
+	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 };
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
