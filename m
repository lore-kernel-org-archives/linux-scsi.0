Return-Path: <SRS0=GQ+9=BM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EA6C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03B8207DF
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgHBLPi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 07:15:38 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:35906 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728132AbgHBLPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 07:15:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0U4TpvXJ_1596366931;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4TpvXJ_1596366931)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:32 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        tianjia.zhang@linux.alibaba.com, arkadiusz@drabczyk.org,
        praveenm@chelsio.com, davem@davemloft.net
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@alibaba.com
Subject: [PATCH] scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()
Date:   Sun,  2 Aug 2020 19:15:31 +0800
Message-Id: <20200802111531.5065-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: f40e74ffa3de4 ("csiostor:firmware upgrade fix")
Cc: Praveen Madhavan <praveenm@chelsio.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/scsi/csiostor/csio_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 950f9cdf0577..5d0f42031d12 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -2384,7 +2384,7 @@ static int csio_hw_prep_fw(struct csio_hw *hw, struct fw_info *fw_info,
 			FW_HDR_FW_VER_MICRO_G(c), FW_HDR_FW_VER_BUILD_G(c),
 			FW_HDR_FW_VER_MAJOR_G(k), FW_HDR_FW_VER_MINOR_G(k),
 			FW_HDR_FW_VER_MICRO_G(k), FW_HDR_FW_VER_BUILD_G(k));
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto bye;
 	}
 
-- 
2.26.2

