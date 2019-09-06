Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B53C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA77C2082C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404945AbfIFM6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6694 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404925AbfIFM6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BD62D6FC6103E3B89F76;
        Fri,  6 Sep 2019 20:58:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:01 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 02/13] scsi: hisi_sas: Use true/false as input parameter of sas_phy_reset()
Date:   Fri, 6 Sep 2019 20:55:26 +0800
Message-ID: <1567774537-20003-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

When calling sas_phy_reset(), we need to specify whether the reset type
is hard reset or link reset - use true/false for clarity.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 03e953862412..47faa283312e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1762,7 +1762,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 	}
 
 	reset_type = (sas_dev->dev_status == HISI_SAS_DEV_INIT ||
-		      !dev_is_sata(device)) ? 1 : 0;
+		      !dev_is_sata(device)) ? true : false;
 
 	rc = sas_phy_reset(local_phy, reset_type);
 	sas_put_local_phy(local_phy);
@@ -1843,7 +1843,7 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 
 		phy = sas_get_local_phy(device);
 
-		rc = sas_phy_reset(phy, 1);
+		rc = sas_phy_reset(phy, true);
 
 		if (rc == 0)
 			hisi_sas_release_task(hisi_hba, device);
-- 
2.17.1

