Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB34C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E2F23102
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732275AbgFTDIm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:08:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732074AbgFTDIm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jun 2020 23:08:42 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6931AC42FBC65265554C;
        Sat, 20 Jun 2020 11:08:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Sat, 20 Jun 2020 11:08:28 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <achim_leubner@adaptec.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] scsi: gdth: remove unnecessary iounmap()
Date:   Sat, 20 Jun 2020 11:11:50 +0800
Message-ID: <20200620031150.152324-1-jingxiangfeng@huawei.com>
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

When initialization of ioremap() fails, it is not needed to do
iounmap(). Remove this iounmap.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/gdth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index fe03410268e6..8f077d316e8b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -639,7 +639,6 @@ static int gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
         ha->brd = ioremap(pcistr->dpmem, sizeof(gdt6c_dpram_str));
         if (ha->brd == NULL) {
             printk("GDT-PCI: Initialization error (DPMEM remap error)\n");
-            iounmap(ha->brd);
             return 0;
         }
         /* check and reset interface area */
-- 
2.17.1

