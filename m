Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F82BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E231C64E39
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBCBiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:38:17 -0500
Received: from m12-16.163.com ([220.181.12.16]:51542 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhBCBiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 20:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=8Msi8
        Mfq+aHnr/S6jW5dXRcexeYW6cPEy+8OpTlWRlw=; b=GFUuyzKypjHIVttXuP9SI
        KvedZwovwBmhhlga6Nws3lowHFwWh2HuKqTVbU4mXOYYBUNEVRztV+HNYhHz/Tei
        4htwAHq62Y4dbE6q0cq0ZXv98g9oW9LejFp/iaUVKxR0sbGgHCQXGwoFBGsB0E6z
        ATDcEUI1+m/D+Evagcwa2c=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowAB3O2kJ_hlg+v3gaA--.4629S2;
        Wed, 03 Feb 2021 09:36:13 +0800 (CST)
From:   dingsenjie@163.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] drivers/scsi: convert to use module_platform_driver in sgiwd93.c
Date:   Wed,  3 Feb 2021 09:35:43 +0800
Message-Id: <20210203013543.34316-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAB3O2kJ_hlg+v3gaA--.4629S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw47KFW3KF47uw47CrW8tFb_yoWDWrXEkr
        W0q3Z7Wr1qga9Fkan8Ja13Z34IvFW09rnYk3W0qFZ09wnxXw4rAw1UZrW7XayUXF4FyFyq
        yrZrGr1Syr13WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeN4S7UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiTgAtyFUDHlmcVwABsw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Simplify the code by using module_platform_driver macro for sgiwd93.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/scsi/sgiwd93.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index cf1030c..7e99a53 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -305,18 +305,7 @@ static int sgiwd93_remove(struct platform_device *pdev)
 	}
 };
 
-static int __init sgiwd93_module_init(void)
-{
-	return platform_driver_register(&sgiwd93_driver);
-}
-
-static void __exit sgiwd93_module_exit(void)
-{
-	return platform_driver_unregister(&sgiwd93_driver);
-}
-
-module_init(sgiwd93_module_init);
-module_exit(sgiwd93_module_exit);
+module_platform_driver(sgiwd93_driver);
 
 MODULE_DESCRIPTION("SGI WD33C93 driver");
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
-- 
1.9.1


