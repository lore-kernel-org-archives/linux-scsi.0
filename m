Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE6AC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7A620691
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405444AbhAZMNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:13:53 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11883 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404902AbhAZLJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 06:09:18 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ3pw3Ky8z7bL0;
        Tue, 26 Jan 2021 19:07:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 19:08:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/5] scsi: hisi_sas: Flush workqueue in hisi_sas_v3_remove()
Date:   Tue, 26 Jan 2021 19:04:27 +0800
Message-ID: <1611659068-131975-5-git-send-email-john.garry@huawei.com>
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

From: Luo Jiaxing <luojiaxing@huawei.com>

If the controller reset occurs at the same time as driver removal, it may
be possible that the interrupts have been released prior to the host
softreset, and calling pci_irq_vector() there causes a WARN:

WARNING: CPU: 37 PID: 1542 /pci/msi.c:1275 pci_irq_vector+0xc0/0xd0
Call trace:
pci_irq_vector+0xc0/0xd0
disable_host_v3_hw+0x58/0x5b0 [hisi_sas_v3_hw]
soft_reset_v3_hw+0x40/0xc0 [hisi_sas_v3_hw]
hisi_sas_controller_reset+0x150/0x260 [hisi_sas_main]
hisi_sas_rst_work_handler+0x3c/0x58 [hisi_sas_main]

To fix, flush the driver workqueue prior to releasing the interrupts
to ensure any resets have been completed.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e91df469e36b..4cc344ca121c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4572,6 +4572,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 		del_timer(&hisi_hba->timer);
 
 	sas_unregister_ha(sha);
+	flush_workqueue(hisi_hba->wq);
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
-- 
2.26.2

