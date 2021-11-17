Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F8CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05F861B73
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhKQCxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:13 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:27217 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbhKQCxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:09 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hv6n63vsYz8vR0;
        Wed, 17 Nov 2021 10:48:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:09 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>
Subject: [PATCH 02/15] Revert "scsi: hisi_sas: Filter out new PHY up events during suspend"
Date:   Wed, 17 Nov 2021 10:44:55 +0800
Message-ID: <1637117108-230103-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

This reverts commit b14a37e011d829404c29a5ae17849d7efb034893.

In that commit, we had to filter out phy-up events during suspend, as it
work cause a deadlock between processing the phyup event and the resume
HA function try to drain the HA event workqueue to complete the resume
process.

Now that we no longer try to drain the HA event queue during the HA
resume processor, the deadlock would not occur, so remove the special
handling for it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f206c433de32..305d6282845a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -619,12 +619,6 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no,
 	if (!phy->phy_attached)
 		return;
 
-	if (test_bit(HISI_SAS_PM_BIT, &hisi_hba->flags) &&
-	    !sas_phy->suspended) {
-		dev_warn(hisi_hba->dev, "phy%d during suspend filtered out\n", phy_no);
-		return;
-	}
-
 	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
-- 
2.33.0

