Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA10C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 08:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F7461058
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 08:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbhIAIxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:53:13 -0400
Received: from mx20.baidu.com ([111.202.115.85]:44186 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241376AbhIAIxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Sep 2021 04:53:12 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id ED7E28EA7C4F09A36F08;
        Wed,  1 Sep 2021 16:52:13 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 1 Sep 2021 16:52:13 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 1 Sep 2021 16:52:13 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: hisi_sas: Make use of the helper function devm_platform_ioremap_resource()
Date:   Wed, 1 Sep 2021 16:52:07 +0800
Message-ID: <20210901085207.31254-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex21.internal.baidu.com (172.31.51.15) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9515c45affa5..0c2309c951ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2649,12 +2649,9 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (IS_ERR(hisi_hba->regs))
 		goto err_out;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		hisi_hba->sgpio_regs = devm_ioremap_resource(dev, res);
-		if (IS_ERR(hisi_hba->sgpio_regs))
-			goto err_out;
-	}
+	hisi_hba->sgpio_regs = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(hisi_hba->sgpio_regs))
+		goto err_out;
 
 	if (hisi_sas_alloc(hisi_hba)) {
 		hisi_sas_free(hisi_hba);
-- 
2.25.1

