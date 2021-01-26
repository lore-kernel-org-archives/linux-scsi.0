Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E87FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CD1E20637
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405096AbhAZMNR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:13:17 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11881 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404904AbhAZLJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 06:09:18 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ3pw2Y5sz7Zpw;
        Tue, 26 Jan 2021 19:07:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 19:08:24 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 1/5] scsi: hisi_sas: Remove deferred probe check in hisi_sas_v2_probe()
Date:   Tue, 26 Jan 2021 19:04:24 +0800
Message-ID: <1611659068-131975-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
References: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The platform_get_irq() check for -EPROBE_DEFER was to ensure that all
the steps to add the SCSI host are not done and then only to realise that
the probe needs to be deferred.

However, since there is now an earlier check for this in
hisi_sas_interrupt_preinit(), this check is superfluous and may be removed.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 502ad3e4f7cd..46f60fc2a069 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3627,18 +3627,6 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 
 static int hisi_sas_v2_probe(struct platform_device *pdev)
 {
-	/*
-	 * Check if we should defer the probe before we probe the
-	 * upper layer, as it's hard to defer later on.
-	 */
-	int ret = platform_get_irq(pdev, 0);
-
-	if (ret < 0) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "cannot obtain irq\n");
-		return ret;
-	}
-
 	return hisi_sas_probe(pdev, &hisi_sas_v2_hw);
 }
 
-- 
2.26.2

