Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77657C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 10:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbiDUK2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 06:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388531AbiDUK1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 06:27:48 -0400
Received: from mail.meizu.com (edge01.meizu.com [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79461116;
        Thu, 21 Apr 2022 03:24:58 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 21 Apr
 2022 18:25:00 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 21 Apr
 2022 18:24:56 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: qedf: Remove useless code
Date:   Thu, 21 Apr 2022 18:24:53 +0800
Message-ID: <1650536693-13089-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

buf msg only memset but no use at all, so we drop it.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/scsi/qedf/qedf_attr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index fdc66d294813..8d8c760eee43 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -131,7 +131,6 @@ qedf_sysfs_write_grcdump(struct file *filep, struct kobject *kobj,
 	struct qedf_ctx *qedf = NULL;
 	long reading;
 	int ret = 0;
-	char msg[40];
 
 	if (off != 0)
 		return ret;
@@ -148,7 +147,6 @@ qedf_sysfs_write_grcdump(struct file *filep, struct kobject *kobj,
 		return ret;
 	}
 
-	memset(msg, 0, sizeof(msg));
 	switch (reading) {
 	case 0:
 		memset(qedf->grcdump, 0, qedf->grcdump_size);
-- 
2.7.4

