Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B52CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 07:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471AE221FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 07:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgKLH7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 02:59:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8069 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKLH7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 02:59:14 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CWvBB1dSxzLx83;
        Thu, 12 Nov 2020 15:58:58 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Nov 2020 15:59:01 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <Mahesh.Rajashekhara@pmcs.com>,
        <JBottomley@Odin.com>, <thenzl@redhat.com>,
        <Karthikeya.Sunkesula@pmcs.com>, <Murthy.Bhat@pmcs.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] scsi: aacraid: Correct goto target in aac_resume()
Date:   Thu, 12 Nov 2020 16:03:51 +0800
Message-ID: <20201112080351.174338-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In current code, it jumps to call pci_disable_device() when
pci_enable_device() failes to initialize device. Add a label
'fail_enable' to fix it.

Fixes: de665f28f788 ("aacraid: Add Power Management support")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/aacraid/linit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a3aee146537b..13323aaaa707 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1943,7 +1943,7 @@ static int aac_resume(struct pci_dev *pdev)
 	r = pci_enable_device(pdev);
 
 	if (r)
-		goto fail_device;
+		goto fail_enable;
 
 	pci_set_master(pdev);
 	if (aac_acquire_resources(aac))
@@ -1958,9 +1958,10 @@ static int aac_resume(struct pci_dev *pdev)
 	return 0;
 
 fail_device:
+	pci_disable_device(pdev);
+fail_enable:
 	printk(KERN_INFO "%s%d: resume failed.\n", aac->name, aac->id);
 	scsi_host_put(shost);
-	pci_disable_device(pdev);
 	return -ENODEV;
 }
 #endif
-- 
2.17.1

