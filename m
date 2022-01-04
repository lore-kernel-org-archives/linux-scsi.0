Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BE9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Jan 2022 12:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiADMr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Jan 2022 07:47:27 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17322 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiADMr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2022 07:47:27 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JSsmw0sTTz9s1j;
        Tue,  4 Jan 2022 20:46:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 4 Jan 2022 20:47:25 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <nathan@kernel.org>,
        <colin.i.king@gmail.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: Remove unused variable and check in hisi_sas_send_ata_reset_each_phy()
Date:   Tue, 4 Jan 2022 20:42:06 +0800
Message-ID: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

In commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
asd_sas_port->phy_list"), we use asd_sas_port->phy_mask instead of
accessing asd_sas_port->phy_list, and it is enough to use
asd_sas_port->phy_mask to check the state of phy, so remove the unused
check and variable.

Fixes: 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to asd_sas_port->phy_list")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Colin King <colin.i.king@gmail.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f46f679fe825..a05ec7aece5a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1525,16 +1525,11 @@ static void hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
 	struct device *dev = hisi_hba->dev;
 	int s = sizeof(struct host_to_dev_fis);
 	int rc = TMF_RESP_FUNC_FAILED;
-	struct asd_sas_phy *sas_phy;
 	struct ata_link *link;
 	u8 fis[20] = {0};
-	u32 state;
 	int i;
 
-	state = hisi_hba->hw->get_phys_state(hisi_hba);
 	for (i = 0; i < hisi_hba->n_phy; i++) {
-		if (!(state & BIT(sas_phy->id)))
-			continue;
 		if (!(sas_port->phy_mask & BIT(i)))
 			continue;
 
-- 
2.33.0

