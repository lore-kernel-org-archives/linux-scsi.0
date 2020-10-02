Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88235C4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A05A206DB
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbgJBOev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387807AbgJBOet (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:49 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BE27AC187D8BCC325D76;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 7/7] scsi: hisi_sas: Recover phys state according to the status before reset
Date:   Fri, 2 Oct 2020 22:30:38 +0800
Message-ID: <1601649038-25534-8-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
References: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently the phys stat is recovered according to the status of phys after
reset which is invalid, as the phys are already re-initialized before here.
Actually need to recover phys state according to the state of phys before
reset, so fix it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index ef3922ad70c0..5b7357a5620d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1551,7 +1551,6 @@ EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_prepare);
 void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 {
 	struct Scsi_Host *shost = hisi_hba->shost;
-	u32 state;
 
 	/* Init and wait for PHYs to come up and all libsas event finished. */
 	hisi_hba->hw->phys_init(hisi_hba);
@@ -1566,8 +1565,7 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	scsi_unblock_requests(shost);
 	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
 
-	state = hisi_hba->hw->get_phys_state(hisi_hba);
-	hisi_sas_rescan_topology(hisi_hba, state);
+	hisi_sas_rescan_topology(hisi_hba, hisi_hba->phy_state);
 }
 EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 
-- 
2.26.2

