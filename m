Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B91CC07E9D
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 01:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiIXBAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiIXBAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 21:00:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37BD2CDEE
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 18:00:03 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MZ9Y22FqkzHtg7;
        Sat, 24 Sep 2022 08:55:18 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 09:00:02 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <xiujianfeng@huawei.com>
Subject: [PATCH] scsi: arcmsr: Add __init/__exit annotations to module init/exit funcs
Date:   Sat, 24 Sep 2022 08:56:21 +0800
Message-ID: <20220924005621.186635-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missing __init/__exit annotations to module init/exit funcs.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d3fb8a9c1c39..dcc0b93050fa 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1720,14 +1720,14 @@ static void arcmsr_shutdown(struct pci_dev *pdev)
 	arcmsr_flush_adapter_cache(acb);
 }
 
-static int arcmsr_module_init(void)
+static int __init arcmsr_module_init(void)
 {
 	int error = 0;
 	error = pci_register_driver(&arcmsr_pci_driver);
 	return error;
 }
 
-static void arcmsr_module_exit(void)
+static void __exit arcmsr_module_exit(void)
 {
 	pci_unregister_driver(&arcmsr_pci_driver);
 }
-- 
2.17.1

