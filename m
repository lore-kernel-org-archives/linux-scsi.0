Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07921EE14C3
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 00:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244451AbjIGAyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Sep 2023 20:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjIGAyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Sep 2023 20:54:20 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FC5173B;
        Wed,  6 Sep 2023 17:54:16 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VrV82ym_1694048053;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VrV82ym_1694048053)
          by smtp.aliyun-inc.com;
          Thu, 07 Sep 2023 08:54:14 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] scsi: ufs: core: Simplify bool conversion
Date:   Thu,  7 Sep 2023 08:54:13 +0800
Message-Id: <20230907005413.100804-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

./drivers/ufs/core/ufshcd.c:2307:26-31: WARNING: conversion to bool not needed here

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..04bbe38ffd87 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2304,7 +2304,7 @@ static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 	int ret = read_poll_timeout(ufshcd_readl, val, val & UIC_COMMAND_READY,
 				    500, UIC_CMD_TIMEOUT * 1000, false, hba,
 				    REG_CONTROLLER_STATUS);
-	return ret == 0 ? true : false;
+	return ret == 0;
 }
 
 /**
-- 
2.20.1.7.g153144c

