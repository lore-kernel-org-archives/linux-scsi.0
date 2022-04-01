Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67ABC3526F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 15:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbiDAPEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 11:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349843AbiDAO6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 10:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1BB1621BF;
        Fri,  1 Apr 2022 07:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA8D60AD8;
        Fri,  1 Apr 2022 14:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA301C340EE;
        Fri,  1 Apr 2022 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824306;
        bh=uUA72+igaDNOOgoBqTpVKGKUknstBhB3jf8FRnZA+Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDwyCtLkBZtVOIKJUi/bPxngos7Rc5v1eso5ocynv7eUceRFhdVpSCMX5PH1lX1K1
         HDxkXgJy9ibTFH4uANSy5xpT8KxgUWx5f5RArFSUat4Bfp0OE8VBSXvqjRgMK6mFcs
         EbsLe3bvAfSzfAqB7V0uPMRVst+VqjnBtm7RAGwKNRurOuz96cmps9gp6oSd8xqFv0
         XNhkHNicpwFmwd29YHeYHAA4xBdP/2v4P7nOcQbIItf1FbAbMX/J1CvBfnQyyduUUQ
         ZtvyrDIBiMSpG/U5nllFXlA2WhEleAd0WFRh8w/3r7A7OevwvaI+SbRFwuwVSy9AZd
         TDwy5/SGdIDnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org, yanaijie@huawei.com,
        himanshu.madhani@oracle.com, thunder.leizhen@huawei.com,
        yuyufen@huawei.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/37] scsi: mvsas: Replace snprintf() with sysfs_emit()
Date:   Fri,  1 Apr 2022 10:44:16 -0400
Message-Id: <20220401144446.1954694-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit 0ad3867b0f13e45cfee5a1298bfd40eef096116c ]

coccinelle report:
./drivers/scsi/mvsas/mv_init.c:699:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/mvsas/mv_init.c:747:8-16:
WARNING: use scnprintf or sprintf

Use sysfs_emit() instead of scnprintf() or sprintf().

Link: https://lore.kernel.org/r/c1711f7cf251730a8ceb5bdfc313bf85662b3395.1643182948.git.yang.guang5@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 52405ce58ade..c16d7fb0fdcb 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -697,7 +697,7 @@ static ssize_t
 mvs_show_driver_version(struct device *cdev,
 		struct device_attribute *attr,  char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buffer, "%s\n", DRV_VERSION);
 }
 
 static DEVICE_ATTR(driver_version,
@@ -749,7 +749,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 static ssize_t mvs_show_interrupt_coalescing(struct device *cdev,
 			struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+	return sysfs_emit(buffer, "%d\n", interrupt_coalescing);
 }
 
 static DEVICE_ATTR(interrupt_coalescing,
-- 
2.34.1

