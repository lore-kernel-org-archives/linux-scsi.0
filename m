Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC50C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 13:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D61D224B1
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 13:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgLXNZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:25:52 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10362 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgLXNZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 08:25:51 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D1rQF5Dljz7J5w;
        Thu, 24 Dec 2020 21:24:21 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 24 Dec 2020 21:24:59 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <martin.petersen@oracle.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 -next] scsi: target: iscsi: use DEFINE_MUTEX() for mutex lock
Date:   Thu, 24 Dec 2020 21:25:36 +0800
Message-ID: <20201224132536.31613-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 518fac4864cf..b33726229f94 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -50,7 +50,7 @@ static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
 DEFINE_IDA(sess_ida);
-struct mutex auth_id_lock;
+DEFINE_MUTEX(auth_id_lock);
 
 struct iscsit_global *iscsit_global;
 
@@ -690,7 +690,6 @@ static int __init iscsi_target_init_module(void)
 		return -1;
 
 	spin_lock_init(&iscsit_global->ts_bitmap_lock);
-	mutex_init(&auth_id_lock);
 	idr_init(&tiqn_idr);
 
 	ret = target_register_template(&iscsi_ops);
-- 
2.22.0

