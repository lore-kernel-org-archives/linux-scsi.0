Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C9CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 15:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 631B52074F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 15:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgKIP7l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 10:59:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7198 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIP7l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 10:59:41 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CVFzw2NvlzkhV0;
        Mon,  9 Nov 2020 23:59:24 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 23:59:32 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: pm80xx: Fix error return in pm8001_pci_probe
Date:   Tue, 10 Nov 2020 00:03:22 +0800
Message-ID: <20201109160322.1938811-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Forget to set error code when pm8001_configure_phy_settings failed.
We fixed it by using rc to store return value of
pm8001_configure_phy_settings.

Fixes: 279094079a442 ("[SCSI] pm80xx: Phy settings support for motherboard controller.")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index fb471ad3720a..89397e5351ff 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1131,7 +1131,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	pm8001_init_sas_add(pm8001_ha);
 	/* phy setting support for motherboard controller */
-	if (pm8001_configure_phy_settings(pm8001_ha))
+	rc = pm8001_configure_phy_settings(pm8001_ha);
+	if (rc)
 		goto err_out_shost;
 
 	pm8001_post_sas_ha_init(shost, chip);
-- 
2.25.4

