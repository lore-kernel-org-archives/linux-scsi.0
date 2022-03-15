Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA87C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 01:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344233AbiCOBy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 21:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiCOBy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 21:54:57 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9875F5D;
        Mon, 14 Mar 2022 18:53:45 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 15 Mar
 2022 09:53:44 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 15 Mar
 2022 09:53:43 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH] scsi: fnic: remove redundant NULL check
Date:   Tue, 15 Mar 2022 09:53:39 +0800
Message-ID: <1647309219-12772-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings reported by coccicheck:
drivers/scsi/fnic/fnic_debugfs.c:90:2-7: WARNING: NULL check before some freeing functions is not needed.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index e732650..866b4c9 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -86,8 +86,7 @@ void fnic_debugfs_terminate(void)
 	debugfs_remove(fnic_trace_debugfs_root);
 	fnic_trace_debugfs_root = NULL;
 
-	if (fc_trc_flag)
-		vfree(fc_trc_flag);
+	vfree(fc_trc_flag);
 }
 
 /*
-- 
2.7.4

