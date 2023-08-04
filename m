Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88011EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 02:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjHDCaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Aug 2023 22:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjHDC37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2023 22:29:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE963C16
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 19:29:58 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RH8jP0htdztR4c;
        Fri,  4 Aug 2023 10:26:33 +0800 (CST)
Received: from hulk-vt.huawei.com (10.67.174.111) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 10:29:56 +0800
From:   Xiang Yang <xiangyang3@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <xiangyang3@huawei.com>
Subject: [PATCH -next] scsi: arcmsr: Add __init and __exit for arcmsr_module_{init,exit}
Date:   Fri, 4 Aug 2023 10:29:13 +0800
Message-ID: <20230804022913.1917023-1-xiangyang3@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add __init and __exit for arcmsr_module_{init,exit}

Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 2cd12c7f06c6..a66221c3b72f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1715,14 +1715,14 @@ static void arcmsr_shutdown(struct pci_dev *pdev)
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
2.34.1

