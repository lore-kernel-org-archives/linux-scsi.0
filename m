Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BA7C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B180613B7
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343537AbhDFLw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:52:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16361 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhDFLw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 07:52:56 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FF5SY3BDjz93fR;
        Tue,  6 Apr 2021 19:50:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 19:52:38 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.orgc>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: Print SATA device SAS address for soft reset failure
Date:   Tue, 6 Apr 2021 19:48:31 +0800
Message-ID: <1617709711-195853-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
References: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Add (pseudo) SAS address for ATA software reset failure log to assist
debugging.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 4c90d91d47f4..5a204074099c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1341,10 +1341,12 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 			rc = hisi_sas_exec_internal_tmf_task(device, fis,
 							     s, NULL);
 			if (rc != TMF_RESP_FUNC_COMPLETE)
-				dev_err(dev, "ata disk de-reset failed\n");
+				dev_err(dev, "ata disk %016llx de-reset failed\n",
+					SAS_ADDR(device->sas_addr));
 		}
 	} else {
-		dev_err(dev, "ata disk reset failed\n");
+		dev_err(dev, "ata disk %016llx reset failed\n",
+			SAS_ADDR(device->sas_addr));
 	}
 
 	if (rc == TMF_RESP_FUNC_COMPLETE)
-- 
2.26.2

