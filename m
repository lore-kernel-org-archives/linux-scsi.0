Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FE8C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 07:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD028206E6
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 07:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIQHJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:09:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59270 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726109AbgIQHJG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 03:09:06 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4C3EFF1F76C25FDA1F18;
        Thu, 17 Sep 2020 14:48:20 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 14:48:10 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        "Jamie Lenehan" <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <dc395x@twibble.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] scsi: dc395x: use module_pci_driver to simplify the code
Date:   Thu, 17 Sep 2020 15:10:44 +0800
Message-ID: <20200917071044.1909268-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the module_pci_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/scsi/dc395x.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 0c251a3b99b7..fa16894d8758 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4721,30 +4721,7 @@ static struct pci_driver dc395x_driver = {
 	.probe          = dc395x_init_one,
 	.remove         = dc395x_remove_one,
 };
-
-
-/**
- * dc395x_module_init - Module initialization function
- *
- * Used by both module and built-in driver to initialise this driver.
- **/
-static int __init dc395x_module_init(void)
-{
-	return pci_register_driver(&dc395x_driver);
-}
-
-
-/**
- * dc395x_module_exit - Module cleanup function.
- **/
-static void __exit dc395x_module_exit(void)
-{
-	pci_unregister_driver(&dc395x_driver);
-}
-
-
-module_init(dc395x_module_init);
-module_exit(dc395x_module_exit);
+module_pci_driver(dc395x_driver);
 
 MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
 MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
-- 
2.25.1

