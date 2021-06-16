Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAC2C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 14:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 509F661164
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 14:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhFPO0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 10:26:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:46980 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhFPO0U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Jun 2021 10:26:20 -0400
IronPort-SDR: +FKlEgZRjkjoqb9VjcW13lhQfkIvdX8/+y/J7SLozvtkFzHq6NoibriNDdvOtnJlbE/lEgcfvU
 7W9PbjqakorA==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="270033736"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="270033736"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 07:24:12 -0700
IronPort-SDR: fXH+GD69Um10AQilDOktZtEBAffOWaqUlnxrfgy0RupAjUYs253/wy0M3XNMR/DizrOzdlCGMb
 vNmIEg3MHMVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="637469424"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2021 07:24:10 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6F0872AA; Wed, 16 Jun 2021 17:24:35 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: imm: Switch to use module_parport_driver()
Date:   Wed, 16 Jun 2021 17:24:29 +0300
Message-Id: <20210616142429.45373-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to use module_parport_driver() to reduce boilerplate code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/imm.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 862d35a098cf..943c9102a7eb 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1283,19 +1283,6 @@ static struct parport_driver imm_driver = {
 	.detach		= imm_detach,
 	.devmodel	= true,
 };
-
-static int __init imm_driver_init(void)
-{
-	printk("imm: Version %s\n", IMM_VERSION);
-	return parport_register_driver(&imm_driver);
-}
-
-static void __exit imm_driver_exit(void)
-{
-	parport_unregister_driver(&imm_driver);
-}
-
-module_init(imm_driver_init);
-module_exit(imm_driver_exit);
+module_parport_driver(imm_driver);
 
 MODULE_LICENSE("GPL");
-- 
2.30.2

