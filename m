Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2746FC43217
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 12:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiKVM4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 07:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiKVMzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 07:55:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4C061BA8
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 04:55:53 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NGkkX2fvhzHw0q;
        Tue, 22 Nov 2022 20:55:16 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 22 Nov
 2022 20:55:52 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: qla2xxx: Fix a typo in qla2x00_probe_one
Date:   Tue, 22 Nov 2022 20:52:46 +0800
Message-ID: <20221122125246.45065-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

What's the point unmapping ha->nx_pcibase when it does not exist.
In fact, the original judgement causes ha->nx_pcibase to NOT be unmapped
during error handling.

Fixes: 0a63ad12e3ef ("[SCSI] qla2xxx: Dont clear drv active on iospace config failure.")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c85f3cce726..6dc370671470 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3625,7 +3625,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 iospace_config_failed:
 	if (IS_P3P_TYPE(ha)) {
-		if (!ha->nx_pcibase)
+		if (ha->nx_pcibase)
 			iounmap((device_reg_t *)ha->nx_pcibase);
 		if (!ql2xdbwr)
 			iounmap((device_reg_t *)ha->nxdb_wr_ptr);
-- 
2.17.1

