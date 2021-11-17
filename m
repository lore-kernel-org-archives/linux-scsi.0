Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BEEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3EA361B73
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhKQCxW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:22 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31878 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhKQCxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:11 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hv6jS6px9zcbLB;
        Wed, 17 Nov 2021 10:45:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:11 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 13/15] scsi: hisi_sas: Keep controller active between ISR of phyup and the event being processed
Date:   Wed, 17 Nov 2021 10:45:06 +0800
Message-ID: <1637117108-230103-14-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

It is possible that controller may be suspended between ISR of phyup
and the event being processed, then it can't ensure controller is
active when processing the phyup event which will cause issues.
To avoid the issue, add pm_runtime_get_noresume() in ISR of phyup
and pm_runtime_put_sync() in the work handler exit of a new event
HISI_PHYE_PHY_UP_PM which is called in v3 hw as runtime PM is
only supported for v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Acked-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 22 ++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 ++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2213a91923a5..8269703b978d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -154,6 +154,7 @@ enum hisi_sas_bit_err_type {
 enum hisi_sas_phy_event {
 	HISI_PHYE_PHY_UP   = 0U,
 	HISI_PHYE_LINK_RESET,
+	HISI_PHYE_PHY_UP_PM,
 	HISI_PHYES_NUM,
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 44c888e0afd7..9255790a8568 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -854,10 +854,11 @@ int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_scan_finished);
 
-static void hisi_sas_phyup_work(struct work_struct *work)
+static void hisi_sas_phyup_work_common(struct work_struct *work,
+		enum hisi_sas_phy_event event)
 {
 	struct hisi_sas_phy *phy =
-		container_of(work, typeof(*phy), works[HISI_PHYE_PHY_UP]);
+		container_of(work, typeof(*phy), works[event]);
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	int phy_no = sas_phy->id;
@@ -868,6 +869,11 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 	hisi_sas_bytes_dmaed(hisi_hba, phy_no, GFP_KERNEL);
 }
 
+static void hisi_sas_phyup_work(struct work_struct *work)
+{
+	hisi_sas_phyup_work_common(work, HISI_PHYE_PHY_UP);
+}
+
 static void hisi_sas_linkreset_work(struct work_struct *work)
 {
 	struct hisi_sas_phy *phy =
@@ -877,9 +883,21 @@ static void hisi_sas_linkreset_work(struct work_struct *work)
 	hisi_sas_control_phy(sas_phy, PHY_FUNC_LINK_RESET, NULL);
 }
 
+static void hisi_sas_phyup_pm_work(struct work_struct *work)
+{
+	struct hisi_sas_phy *phy =
+		container_of(work, typeof(*phy), works[HISI_PHYE_PHY_UP_PM]);
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = hisi_hba->dev;
+
+	hisi_sas_phyup_work_common(work, HISI_PHYE_PHY_UP_PM);
+	pm_runtime_put_sync(dev);
+}
+
 static const work_func_t hisi_sas_phye_fns[HISI_PHYES_NUM] = {
 	[HISI_PHYE_PHY_UP] = hisi_sas_phyup_work,
 	[HISI_PHYE_LINK_RESET] = hisi_sas_linkreset_work,
+	[HISI_PHYE_PHY_UP_PM] = hisi_sas_phyup_pm_work,
 };
 
 bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4e9dfdb69757..a5695ae8b73b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1561,7 +1561,10 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy->port_id = port_id;
 	phy->phy_attached = 1;
-	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP);
+
+	/* Call pm_runtime_put_sync() with pairs in hisi_sas_phyup_pm_work() */
+	pm_runtime_get_noresume(dev);
+	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP_PM);
 	res = IRQ_HANDLED;
 end:
 	if (phy->reset_completion)
-- 
2.33.0

