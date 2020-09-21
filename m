Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D61C43466
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 14:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B97E21D95
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 14:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgIUO0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 10:26:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33776 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbgIUO0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 10:26:11 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2C6AA2AC8C39EDCA7888;
        Mon, 21 Sep 2020 22:25:56 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 21 Sep 2020
 22:25:48 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <skashyap@marvell.com>, <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: bnx2fc: move declaration of 'bnx2fc_percpu' to bnx2fc.h
Date:   Mon, 21 Sep 2020 22:26:58 +0800
Message-ID: <20200921142658.874807-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following sparse warning:

drivers/scsi/bnx2fc/bnx2fc_fcoe.c:23:1: warning: symbol
'__pcpu_scope_bnx2fc_percpu' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h     | 2 ++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b6e8ed757252..41b99a74613a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -175,6 +175,8 @@ struct bnx2fc_percpu_s {
 	spinlock_t fp_work_lock;
 };
 
+DECLARE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
+
 struct bnx2fc_fw_stats {
 	u64	fc_crc_cnt;
 	u64	fcoe_tx_pkt_cnt;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 08992095ce7a..cee66fcf8dec 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -15,8 +15,6 @@
 
 #include "bnx2fc.h"
 
-DECLARE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
-
 static void bnx2fc_fastpath_notification(struct bnx2fc_hba *hba,
 					struct fcoe_kcqe *new_cqe_kcqe);
 static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
-- 
2.25.4

