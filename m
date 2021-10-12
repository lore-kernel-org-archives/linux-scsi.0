Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FC1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97035610EA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhJLMdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:33:42 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3969 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhJLMdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 08:33:38 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HTFMG10Q0z67Lqc;
        Tue, 12 Oct 2021 20:28:42 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 14:31:35 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 13:31:32 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/4] scsi: hisi_sas: Wait for phyup in hisi_sas_control_phy()
Date:   Tue, 12 Oct 2021 20:26:26 +0800
Message-ID: <1634041588-74824-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
References: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When issuing a hardreset/linkreset/phy_set_linkrate from sysfs, the phy
will be disabled and re-enabled for the directly attached scenario.

It takes some time for the phy to come back up after re-enabling the phy.
If the controller becomes suspended while waiting for the phy to come
back, the phy up may be lost (along with the disk).

To solve the problem, wait for the phy up to occur with a timeout. Indeed
this is already done in hisi_sas_debug_I_T_nexus_reset() for local phys,
so just relocate the functionality to hisi_sas_control_phy().

Since the HA workqueue is drained when suspending the controller, and the
phy control function is called from the same workqueue, we can guarantee
that the controller will not be suspended during this period.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 +++++++++++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 11 ++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 17 ++--------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  9 ++----
 4 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0835ba7c0ac2..5b091388c095 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1146,9 +1146,17 @@ static int hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 				void *funcdata)
 {
+	struct hisi_sas_phy *phy = container_of(sas_phy,
+			struct hisi_sas_phy, sas_phy);
 	struct sas_ha_struct *sas_ha = sas_phy->ha;
 	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
+	struct device *dev = hisi_hba->dev;
+	DECLARE_COMPLETION_ONSTACK(completion);
 	int phy_no = sas_phy->id;
+	u8 sts = phy->phy_attached;
+	int ret = 0;
+
+	phy->reset_completion = &completion;
 
 	switch (func) {
 	case PHY_FUNC_HARD_RESET:
@@ -1163,21 +1171,35 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 
 	case PHY_FUNC_DISABLE:
 		hisi_sas_phy_enable(hisi_hba, phy_no, 0);
-		break;
+		goto out;
 
 	case PHY_FUNC_SET_LINK_RATE:
-		return hisi_sas_phy_set_linkrate(hisi_hba, phy_no, funcdata);
+		ret = hisi_sas_phy_set_linkrate(hisi_hba, phy_no, funcdata);
+		break;
+
 	case PHY_FUNC_GET_EVENTS:
 		if (hisi_hba->hw->get_events) {
 			hisi_hba->hw->get_events(hisi_hba, phy_no);
-			break;
+			goto out;
 		}
 		fallthrough;
 	case PHY_FUNC_RELEASE_SPINUP_HOLD:
 	default:
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
-	return 0;
+
+	if (sts && !wait_for_completion_timeout(&completion, 2 * HZ)) {
+		dev_warn(dev, "phy%d wait phyup timed out for func %d\n",
+			 phy_no, func);
+		if (phy->in_reset)
+			ret = -ETIMEDOUT;
+	}
+
+out:
+	phy->reset_completion = NULL;
+
+	return ret;
 }
 
 static void hisi_sas_task_done(struct sas_task *task)
@@ -1783,7 +1805,6 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
-	DECLARE_COMPLETION_ONSTACK(phyreset);
 	int rc, reset_type;
 
 	if (!local_phy->enabled) {
@@ -1796,8 +1817,11 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 			sas_ha->sas_phy[local_phy->number];
 		struct hisi_sas_phy *phy =
 			container_of(sas_phy, struct hisi_sas_phy, sas_phy);
+		unsigned long flags;
+
+		spin_lock_irqsave(&phy->lock, flags);
 		phy->in_reset = 1;
-		phy->reset_completion = &phyreset;
+		spin_unlock_irqrestore(&phy->lock, flags);
 	}
 
 	reset_type = (sas_dev->dev_status == HISI_SAS_DEV_INIT ||
@@ -1811,17 +1835,14 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 			sas_ha->sas_phy[local_phy->number];
 		struct hisi_sas_phy *phy =
 			container_of(sas_phy, struct hisi_sas_phy, sas_phy);
-		int ret = wait_for_completion_timeout(&phyreset,
-						I_T_NEXUS_RESET_PHYUP_TIMEOUT);
 		unsigned long flags;
 
 		spin_lock_irqsave(&phy->lock, flags);
-		phy->reset_completion = NULL;
 		phy->in_reset = 0;
 		spin_unlock_irqrestore(&phy->lock, flags);
 
 		/* report PHY down if timed out */
-		if (!ret)
+		if (rc == -ETIMEDOUT)
 			hisi_sas_phy_down(hisi_hba, sas_phy->id, 0, GFP_KERNEL);
 	} else if (sas_dev->dev_status != HISI_SAS_DEV_INIT) {
 		/*
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 51e7d12f5053..b4951ff9ca51 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1327,7 +1327,6 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 	u32 *frame_rcvd = (u32 *)sas_phy->frame_rcvd;
 	struct sas_identify_frame *id = (struct sas_identify_frame *)frame_rcvd;
 	irqreturn_t res = IRQ_HANDLED;
-	unsigned long flags;
 
 	irq_value = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2);
 	if (!(irq_value & CHL_INT2_SL_PHY_ENA_MSK)) {
@@ -1380,15 +1379,9 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 		phy->identify.target_port_protocols =
 			SAS_PROTOCOL_SMP;
 	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
-
-	spin_lock_irqsave(&phy->lock, flags);
-	if (phy->reset_completion) {
-		phy->in_reset = 0;
-		complete(phy->reset_completion);
-	}
-	spin_unlock_irqrestore(&phy->lock, flags);
-
 end:
+	if (phy->reset_completion)
+		complete(phy->reset_completion);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
 			     CHL_INT2_SL_PHY_ENA_MSK);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 741a62e6bf77..45eb0b98d00b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2641,7 +2641,6 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	struct device *dev = hisi_hba->dev;
 	u32 *frame_rcvd = (u32 *)sas_phy->frame_rcvd;
 	struct sas_identify_frame *id = (struct sas_identify_frame *)frame_rcvd;
-	unsigned long flags;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 1);
 
@@ -2696,14 +2695,9 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 			set_link_timer_quirk(hisi_hba);
 	}
 	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
-	spin_lock_irqsave(&phy->lock, flags);
-	if (phy->reset_completion) {
-		phy->in_reset = 0;
-		complete(phy->reset_completion);
-	}
-	spin_unlock_irqrestore(&phy->lock, flags);
-
 end:
+	if (phy->reset_completion)
+		complete(phy->reset_completion);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_PHY_ENABLE_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 0);
@@ -3204,7 +3198,6 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	u32 ent_tmp, ent_msk, ent_int, port_id, link_rate, hard_phy_linkrate;
 	irqreturn_t res = IRQ_HANDLED;
 	u8 attached_sas_addr[SAS_ADDR_SIZE] = {0};
-	unsigned long flags;
 	int phy_no, offset;
 
 	del_timer(&phy->timer);
@@ -3280,12 +3273,8 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
 	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
 
-	spin_lock_irqsave(&phy->lock, flags);
-	if (phy->reset_completion) {
-		phy->in_reset = 0;
+	if (phy->reset_completion)
 		complete(phy->reset_completion);
-	}
-	spin_unlock_irqrestore(&phy->lock, flags);
 end:
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC1 + offset, ent_tmp);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1 + offset, ent_msk);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 114a59654525..2082b066aca7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1482,7 +1482,6 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	struct device *dev = hisi_hba->dev;
-	unsigned long flags;
 
 	del_timer(&phy->timer);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 1);
@@ -1564,13 +1563,9 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	phy->phy_attached = 1;
 	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
 	res = IRQ_HANDLED;
-	spin_lock_irqsave(&phy->lock, flags);
-	if (phy->reset_completion) {
-		phy->in_reset = 0;
-		complete(phy->reset_completion);
-	}
-	spin_unlock_irqrestore(&phy->lock, flags);
 end:
+	if (phy->reset_completion)
+		complete(phy->reset_completion);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_PHY_ENABLE_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 0);
-- 
2.26.2

