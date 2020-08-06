Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB15C3814C
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E63204FD
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgHFG7G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 02:59:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728294AbgHFG7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Aug 2020 02:59:05 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7799A12F500FF488FFAD;
        Thu,  6 Aug 2020 14:59:00 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 6 Aug 2020 14:58:52 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <vigneshr@ti.com>, <jingxiangfeng@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()
Date:   Thu, 6 Aug 2020 15:01:35 +0800
Message-ID: <20200806070135.67797-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix to return error code PTR_ERR() from the error handling case instead
of 0.

Fixes: 22617e216331 ("scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/ufs/ti-j721e-ufs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index 46bb905b4d6a..eafe0db98d54 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -38,6 +38,7 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
 		dev_err(dev, "Cannot claim MPHY clock.\n");
 		goto clk_err;
 	}
-- 
2.17.1

