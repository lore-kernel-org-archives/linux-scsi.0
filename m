Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C46CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E11B613DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhKQCxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:14 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15830 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhKQCxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:09 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hv6pk2MxXz915f;
        Wed, 17 Nov 2021 10:49:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:10 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 08/15] scsi: hisi_sas: Add more prink for runtime suspend/resume
Date:   Wed, 17 Nov 2021 10:45:01 +0800
Message-ID: <1637117108-230103-9-git-send-email-chenxiang66@hisilicon.com>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

Add some prink at the beginning and end of suspend/resume.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 5a83373ac0b1..4e9dfdb69757 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4896,6 +4896,8 @@ static int _suspend_v3_hw(struct device *device)
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
 		return -1;
 
+	dev_warn(dev, "entering suspend state\n");
+
 	scsi_block_requests(shost);
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 	flush_workqueue(hisi_hba->wq);
@@ -4911,11 +4913,11 @@ static int _suspend_v3_hw(struct device *device)
 
 	hisi_sas_init_mem(hisi_hba);
 
-	dev_warn(dev, "entering suspend state\n");
-
 	hisi_sas_release_tasks(hisi_hba);
 
 	sas_suspend_ha(sha);
+
+	dev_warn(dev, "end of suspending controller\n");
 	return 0;
 }
 
@@ -4953,6 +4955,8 @@ static int _resume_v3_hw(struct device *device)
 	sas_resume_ha_no_sync(sha);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
+	dev_warn(dev, "end of resuming controller\n");
+
 	return 0;
 }
 
-- 
2.33.0

