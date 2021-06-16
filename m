Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE5CC48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 14:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAC1E61159
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 14:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhFPO1a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 10:27:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:20354 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhFPO13 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Jun 2021 10:27:29 -0400
IronPort-SDR: TAL3ZURgS49wlv3u/d+ZJzlojFOHHav0lHDJjUtgjpi7hBVRyMqDhjZ3mdCE8QbJUrrrf2GoQb
 762URkE6hHzg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="186561949"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="186561949"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 07:25:23 -0700
IronPort-SDR: Dw50B+RBcvh+68/pdpsXmiabpAveRyMNJrdPYqB5OV6Dh5yd8hcjYd2CgjnY9T+OIfbVW4/ZV0
 SEp3OQjQYV+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="472043543"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jun 2021 07:25:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 2C69C2AA; Wed, 16 Jun 2021 17:25:42 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: ppa: Switch to use module_parport_driver()
Date:   Wed, 16 Jun 2021 17:25:40 +0300
Message-Id: <20210616142540.45676-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to use module_parport_driver() to reduce boilerplate code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/ppa.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index aa41f7ac91cb..977315fdc254 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -1148,18 +1148,6 @@ static struct parport_driver ppa_driver = {
 	.detach		= ppa_detach,
 	.devmodel	= true,
 };
+module_parport_driver(ppa_driver);
 
-static int __init ppa_driver_init(void)
-{
-	printk(KERN_INFO "ppa: Version %s\n", PPA_VERSION);
-	return parport_register_driver(&ppa_driver);
-}
-
-static void __exit ppa_driver_exit(void)
-{
-	parport_unregister_driver(&ppa_driver);
-}
-
-module_init(ppa_driver_init);
-module_exit(ppa_driver_exit);
 MODULE_LICENSE("GPL");
-- 
2.30.2

