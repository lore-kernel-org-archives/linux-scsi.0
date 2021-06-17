Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5660C2B9F4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD75D61369
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhFQLPm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 07:15:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7470 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhFQLPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 07:15:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5K9842QwzZjG0;
        Thu, 17 Jun 2021 19:10:36 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 19:13:32 +0800
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 19:13:32 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <stanley.chu@mediatek.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <matthias.bgg@gmail.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Zou Wei" <zou_wei@huawei.com>
Subject: [PATCH -next] scsi: ufs-mediatek: Add missing of_node_put() in ufs_mtk_probe()
Date:   Thu, 17 Jun 2021 19:32:02 +0800
Message-ID: <1623929522-4389-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function is missing a of_node_put on node, fix this by adding the call
before returning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 1a517c9..d2c2516 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -1120,6 +1120,7 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	if (err)
 		dev_info(dev, "probe failed %d\n", err);
 
+	of_node_put(reset_node);
 	return err;
 }
 
-- 
2.6.2

