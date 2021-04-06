Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E27C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5D5613B7
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbhDFLxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:53:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16363 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343530AbhDFLw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 07:52:57 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FF5SY3sbYz94Cp;
        Tue,  6 Apr 2021 19:50:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 19:52:38 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.orgc>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        Yihang Li <liyihang6@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5/6] scsi: hisi_sas: Warn in v3 hw channel interrupt handler when status reg cleared
Date:   Tue, 6 Apr 2021 19:48:30 +0800
Message-ID: <1617709711-195853-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
References: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

If a channel interrupt occurs without any status bit set, the handler will
return directly. However, if such redundant interrupts are received, it's
better to check what happen, so add logs for this.

Signed-off-by: Yihang Li <liyihang6@hisilicon.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0927b0b30b29..499c770d405c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1718,8 +1718,11 @@ static void handle_chl_int1_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	int i;
 
 	irq_value &= ~irq_msk;
-	if (!irq_value)
+	if (!irq_value) {
+		dev_warn(dev, "phy%d channel int 1 received with status bits cleared\n",
+			 phy_no);
 		return;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(port_axi_error); i++) {
 		const struct hisi_sas_hw_error *error = &port_axi_error[i];
@@ -1780,8 +1783,11 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 			BIT(CHL_INT2_RX_INVLD_DW_OFF);
 
 	irq_value &= ~irq_msk;
-	if (!irq_value)
+	if (!irq_value) {
+		dev_warn(dev, "phy%d channel int 2 received with status bits cleared\n",
+			 phy_no);
 		return;
+	}
 
 	if (irq_value & BIT(CHL_INT2_SL_IDAF_TOUT_CONF_OFF)) {
 		dev_warn(dev, "phy%d identify timeout\n", phy_no);
-- 
2.26.2

