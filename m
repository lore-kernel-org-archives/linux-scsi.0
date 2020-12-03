Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2179EC63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 13:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B00BA20758
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 13:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgLCNQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:16:08 -0500
Received: from mail-m972.mail.163.com ([123.126.97.2]:49850 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgLCNQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 08:16:07 -0500
X-Greylist: delayed 4654 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2020 08:16:05 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=GgH58TmNPqh2B4YQNF
        GHe8cIq1p3EuxNRQSc4QcypV0=; b=H2ez7+05h3kZ0ktT3NaWT264ZIdA6VRt//
        fUNEXTyEqUDcBP0aLNIzjzTIBQ6OF1NpJfluIps3VPS4UZuuhMjp83j5baDVidXD
        /IHovSObAsRRe4cOi0hE7jKw/ANPozpcbNfygguJZoZ9j6ehGHwtrCZeKhQ6/2Ek
        bG3M/Iw7M=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp2 (Coremail) with SMTP id GtxpCgCXNbq5zshfqV4QDw--.9527S4;
        Thu, 03 Dec 2020 19:40:49 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhang Xiaohui <ruc_zhangxiaohui@163.com>
Subject: [PATCH 1/1] target: Make sure no zero value in the buffer
Date:   Thu,  3 Dec 2020 19:40:40 +0800
Message-Id: <20201203114040.12656-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: GtxpCgCXNbq5zshfqV4QDw--.9527S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFy5Zw47Kr17Jw1fXFWUArb_yoW3uwc_Gw
        4kJr18Ww1F9w4Fyr1UC3sxury2yw1ruFn29F4IyF43KryUuas8twn2qF1DC3yDZ3ykXr95
        uaySqwsxCF45KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUU0PfJUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/xtbBRQHvMFPAIneHYQAAs7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

The fix makes sure no zero value in the buffer, by comparing the
strlen() of the original buffer with the size variable.

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/target/target_core_iblock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index f2bd2e207..b23e92449 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -537,6 +537,8 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 	int ret = 0, token;
 	unsigned long tmp_readonly;
 
+	if (strlen(page) < count)
+		return -EOVERFLOW;
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
 		return -ENOMEM;
-- 
2.17.1

