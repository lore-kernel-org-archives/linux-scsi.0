Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE15C2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC48217F4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgATM04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:26:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9215 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727011AbgATM04 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 07:26:56 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BE73EDACE6526C636755;
        Mon, 20 Jan 2020 20:26:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:26:44 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 3/7] scsi: hisi_sas: Replace magic number when handle channel interrupt
Date:   Mon, 20 Jan 2020 20:22:33 +0800
Message-ID: <1579522957-4393-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
References: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We use magic number as offset and mask when handle channel interrupt, so
use marco to replace it.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 34a3781a2a85..878530f6945f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -495,6 +495,13 @@ struct hisi_sas_err_record_v3 {
 #define BASE_VECTORS_V3_HW  16
 #define MIN_AFFINE_VECTORS_V3_HW  (BASE_VECTORS_V3_HW + 1)
 
+#define CHNL_INT_STS_MSK	0xeeeeeeee
+#define CHNL_INT_STS_PHY_MSK	0xe
+#define CHNL_INT_STS_INT0_MSK BIT(1)
+#define CHNL_INT_STS_INT1_MSK BIT(2)
+#define CHNL_INT_STS_INT2_MSK BIT(3)
+#define CHNL_WIDTH 4
+
 enum {
 	DSM_FUNC_ERR_HANDLE_MSI = 0,
 };
@@ -1819,19 +1826,19 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 	int phy_no = 0;
 
 	irq_msk = hisi_sas_read32(hisi_hba, CHNL_INT_STATUS)
-				& 0xeeeeeeee;
+		  & CHNL_INT_STS_MSK;
 
 	while (irq_msk) {
-		if (irq_msk & (2 << (phy_no * 4)))
+		if (irq_msk & (CHNL_INT_STS_INT0_MSK << (phy_no * CHNL_WIDTH)))
 			handle_chl_int0_v3_hw(hisi_hba, phy_no);
 
-		if (irq_msk & (4 << (phy_no * 4)))
+		if (irq_msk & (CHNL_INT_STS_INT1_MSK << (phy_no * CHNL_WIDTH)))
 			handle_chl_int1_v3_hw(hisi_hba, phy_no);
 
-		if (irq_msk & (8 << (phy_no * 4)))
+		if (irq_msk & (CHNL_INT_STS_INT2_MSK << (phy_no * CHNL_WIDTH)))
 			handle_chl_int2_v3_hw(hisi_hba, phy_no);
 
-		irq_msk &= ~(0xe << (phy_no * 4));
+		irq_msk &= ~(CHNL_INT_STS_PHY_MSK << (phy_no * CHNL_WIDTH));
 		phy_no++;
 	}
 
-- 
2.17.1

