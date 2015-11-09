From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 21/32] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Tue, 10 Nov 2015 00:32:26 +0800
Message-ID: <1447086757-147706-22-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:13361 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbKIQSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 11:18:21 -0500
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 49 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 15 +++++++++++
 3 files changed, 66 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index b236a2f..de40202 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -53,6 +53,7 @@ struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 	struct sas_identify	identify;
 	struct timer_list	timer;
+	struct work_struct	phyup_ws;
 	u64		port_id; /* from hw */
 	u64		dev_sas_addr;
 	u64		phy_type;
@@ -89,6 +90,7 @@ struct hisi_sas_slot {
 
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
+	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
 	int complete_hdr_size;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f98520c..2af09db 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -27,6 +27,53 @@ static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
 
+static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sas_ha;
+
+	if (!phy->phy_attached)
+		return;
+
+	sas_ha = &hisi_hba->sha;
+	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+
+	if (sas_phy->phy) {
+		struct sas_phy *sphy = sas_phy->phy;
+
+		sphy->negotiated_linkrate = sas_phy->linkrate;
+		sphy->minimum_linkrate = phy->minimum_linkrate;
+		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		sphy->maximum_linkrate = phy->maximum_linkrate;
+	}
+
+	if (phy->phy_type & PORT_TYPE_SAS) {
+		struct sas_identify_frame *id;
+
+		id = (struct sas_identify_frame *)phy->frame_rcvd;
+		id->dev_type = phy->identify.device_type;
+		id->initiator_bits = SAS_PROTOCOL_ALL;
+		id->target_bits = phy->identify.target_port_protocols;
+	} else if (phy->phy_type & PORT_TYPE_SATA) {
+		/*Nothing*/
+	}
+
+	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
+	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+}
+
+static void hisi_sas_phyup_work(struct work_struct *work)
+{
+	struct hisi_sas_phy *phy =
+		container_of(work, struct hisi_sas_phy, phyup_ws);
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int phy_no = sas_phy->id;
+
+	hisi_hba->hw->sl_notify(hisi_hba, phy_no); /* This requires a sleep */
+	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+}
 
 static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 {
@@ -49,6 +96,8 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
 	sas_phy->ha = (struct sas_ha_struct *)hisi_hba->shost->hostdata;
 	sas_phy->lldd_phy = phy;
+
+	INIT_WORK(&phy->phyup_ws, hisi_sas_phyup_work);
 }
 
 static struct scsi_transport_template *hisi_sas_stt;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index b595d24..da54925 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -728,6 +728,19 @@ static void phys_init_v1_hw(struct hisi_hba *hisi_hba)
 	mod_timer(timer, jiffies + HZ);
 }
 
+static void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 sl_control;
+
+	sl_control = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
+	sl_control |= SL_CONTROL_NOTIFY_EN_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
+	msleep(1);
+	sl_control = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
+	sl_control &= ~SL_CONTROL_NOTIFY_EN_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
+}
+
 /* Interrupts */
 static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 {
@@ -791,6 +804,7 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols =
 			SAS_PROTOCOL_SMP;
+	queue_work(hisi_hba->wq, &phy->phyup_ws);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
@@ -905,6 +919,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
+	.sl_notify = sl_notify_v1_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
 
-- 
1.9.1

