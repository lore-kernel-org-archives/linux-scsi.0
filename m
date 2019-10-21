Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DAACA9EB0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC25205ED
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfJUQZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfJUQZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:28 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EBC81B6BD90BF05A997D;
        Tue, 22 Oct 2019 00:25:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:17 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 02/18] scsi: hisi_sas: Set the BIST init value before enabling BIST
Date:   Tue, 22 Oct 2019 00:21:59 +0800
Message-ID: <1571674935-108326-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
References: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If set the BIST init value after enabling BIST, there may be still some
few error bits. According to the process, need to set the BIST init value
before enabling BIST.

Fixes: 97b151e75861 ("scsi: hisi_sas: Add BIST support for phy loopback")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cb8d087762db..cc594937fa8d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3022,11 +3022,6 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		hisi_sas_phy_write32(hisi_hba, phy_id,
 				     SAS_PHY_BIST_CTRL, reg_val);
 
-		mdelay(100);
-		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
-		hisi_sas_phy_write32(hisi_hba, phy_id,
-				     SAS_PHY_BIST_CTRL, reg_val);
-
 		/* set the bist init value */
 		hisi_sas_phy_write32(hisi_hba, phy_id,
 				     SAS_PHY_BIST_CODE,
@@ -3035,6 +3030,11 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 				     SAS_PHY_BIST_CODE1,
 				     SAS_PHY_BIST_CODE1_INIT);
 
+		mdelay(100);
+		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     SAS_PHY_BIST_CTRL, reg_val);
+
 		/* clear error bit */
 		mdelay(100);
 		hisi_sas_phy_read32(hisi_hba, phy_id, SAS_BIST_ERR_CNT);
-- 
2.17.1

