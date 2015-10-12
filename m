From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Mon, 12 Oct 2015 23:20:25 +0800
Message-ID: <1444663237-238302-14-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12228 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbJLPGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:06:35 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 55 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 24 +++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 18fd30b..802c000 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -333,4 +333,5 @@ extern int interrupt_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
 extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int phys_init_v1_hw(struct hisi_hba *hisi_hba);
+extern void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 882ff79..72831db 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -27,10 +27,65 @@ void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
 
+
+void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
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
+
+	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+}
+
+
+static void hisi_sas_phyup_work(struct hisi_hba *hisi_hba,
+				      int phy_no)
+{
+	sl_notify_v1_hw(hisi_hba, phy_no); /* This requires a sleep */
+	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+}
+
 void hisi_sas_wq_process(struct work_struct *work)
 {
 	struct hisi_sas_wq *wq =
 		container_of(work, struct hisi_sas_wq, work_struct);
+	struct hisi_hba *hisi_hba = wq->hisi_hba;
+	int event = wq->event;
+	int phy_no = wq->phy_no;
+
+	switch (event) {
+	case PHYUP:
+		hisi_sas_phyup_work(hisi_hba, phy_no);
+		break;
+	}
 
 	kfree(wq);
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 20291b4..df56b3a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -738,6 +738,19 @@ int phys_init_v1_hw(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
+void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
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
@@ -750,6 +763,7 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 	struct sas_identify_frame *id = (struct sas_identify_frame *)frame_rcvd;
 	u32 irq_value, context, port_id, link_rate;
 	int i;
+	struct hisi_sas_wq *wq = NULL;
 	irqreturn_t res = IRQ_HANDLED;
 
 	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2);
@@ -804,6 +818,16 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 		phy->identify.target_port_protocols =
 			SAS_PROTOCOL_SMP;
 
+	wq = kmalloc(sizeof(*wq), GFP_ATOMIC);
+	if (!wq)
+		goto end;
+
+	wq->event = PHYUP;
+	wq->hisi_hba = hisi_hba;
+	wq->phy_no = phy_no;
+
+	INIT_WORK(&wq->work_struct, hisi_sas_wq_process);
+	queue_work(hisi_hba->wq, &wq->work_struct);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
-- 
1.9.1

