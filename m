Return-Path: <SRS0=GQ+9=BM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B979DC433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA8A2076B
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 11:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHBLPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 07:15:31 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49842 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbgHBLPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 07:15:31 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0U4TCtAZ_1596366927;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4TCtAZ_1596366927)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:28 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     njavali@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, quinn.tran@cavium.com,
        himanshu.madhani@cavium.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianjia.zhang@alibaba.com
Subject: [PATCH] scsi: qla2xxx: Remove redundant variable initialization
Date:   Sun,  2 Aug 2020 19:15:27 +0800
Message-Id: <20200802111527.4928-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The initialization value of `rc` is wrong. It is unnecessary to
initialize `rc` variables, so remove its initialization operation.

Fixes: 84905dfe78d28 ("scsi: qla2xxx: Fix TMF and Multi-Queue config")
Cc: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fbb80a043b4f..c2c0e6049da4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2025,7 +2025,7 @@ static void qlt_do_tmr_work(struct work_struct *work)
 	struct qla_tgt_mgmt_cmd *mcmd =
 		container_of(work, struct qla_tgt_mgmt_cmd, work);
 	struct qla_hw_data *ha = mcmd->vha->hw;
-	int rc = EIO;
+	int rc;
 	uint32_t tag;
 	unsigned long flags;
 
-- 
2.26.2

