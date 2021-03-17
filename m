Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017A3C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 12:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD9C64E61
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 12:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQMUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:20:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14392 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhCQMTh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 08:19:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F0q1P2VBbzkbT5;
        Wed, 17 Mar 2021 20:18:01 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Wed, 17 Mar 2021
 20:19:24 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linfeilong@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH] scsi: Add numbers of lun for scan debug log
Date:   Wed, 17 Mar 2021 20:37:13 +0800
Message-ID: <1615984633-294344-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometimes, want to know the number of LUN in the REPORT LUN or
sequential scan LUN. Adding the numbers of LUN is
convenient for debugging.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/scsi_scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9af50e6..ea679d7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1201,9 +1201,6 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	u64 sparse_lun, lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
-	SCSI_LOG_SCAN_BUS(3, starget_printk(KERN_INFO, starget,
-		"scsi scan: Sequential scan\n"));
-
 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
 	/*
 	 * If this device is known to support sparse multiple units,
@@ -1253,6 +1250,8 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	else
 		max_dev_lun = min(256U, max_dev_lun);
 
+	SCSI_LOG_SCAN_BUS(3, starget_printk(KERN_INFO, starget,
+		"scsi scan: Sequential scan, max LUNs:%u\n", max_dev_lun));
 	/*
 	 * We have already scanned LUN 0, so start at LUN 1. Keep scanning
 	 * until we reach the max, or no LUN is found and we are not
@@ -1413,7 +1412,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	num_luns = (length / sizeof(struct scsi_lun));
 
 	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-		"scsi scan: REPORT LUN scan\n"));
+		"scsi scan: REPORT LUN scan, total LUNs%u\n", num_luns));
 
 	/*
 	 * Scan the luns in lun_data. The entry at offset 0 is really
-- 
1.8.3.1

