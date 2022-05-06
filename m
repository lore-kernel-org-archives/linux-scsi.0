Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA94C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 12:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392027AbiEFMfY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 08:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391982AbiEFMfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 08:35:19 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C792C5DA27;
        Fri,  6 May 2022 05:31:36 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KvqZH43Gfz6H7kT;
        Fri,  6 May 2022 20:27:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 14:31:34 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 13:31:32 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Undo RPM resume for failed notify phy event for v3 HW
Date:   Fri, 6 May 2022 20:25:39 +0800
Message-ID: <1651839939-101188-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If we fail to notify the phy up event then undo the RPM resume, as the
phy up notify event handling pairs with that RPM resume.

Tested-by: Yihang Li <liyihang6@hisilicon.com>
Reported-by: Yihang Li <liyihang6@hisilicon.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
Please consider for 5.19, thanks!

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 79f87d7c3e68..7d819fc0395e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1563,9 +1563,15 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy->port_id = port_id;
 
-	/* Call pm_runtime_put_sync() with pairs in hisi_sas_phyup_pm_work() */
+	/*
+	 * Call pm_runtime_get_noresume() which pairs with
+	 * hisi_sas_phyup_pm_work() -> pm_runtime_put_sync().
+	 * For failure call pm_runtime_put() as we are in a hardirq context.
+	 */
 	pm_runtime_get_noresume(dev);
-	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP_PM);
+	res = hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP_PM);
+	if (!res)
+		pm_runtime_put(dev);
 
 	res = IRQ_HANDLED;
 
-- 
2.26.2

