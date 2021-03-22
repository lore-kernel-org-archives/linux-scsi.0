Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE37DC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 10:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E50661992
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 10:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhCVK0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhCVKZx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 06:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5348B6198E;
        Mon, 22 Mar 2021 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616408753;
        bh=Y2Gm2lzUjPtqdTmpCFTNGu0eofrp3F1qO7+4yRpZXeI=;
        h=From:To:Cc:Subject:Date:From;
        b=PDkoQjr9uWfM7vXiOzcPbJhDtAC3bxlW2FN3rapr2A8Q5I88fO1JfUvfY0B3Vb0th
         092SvZRmqTAFbTFvpNrCcT0OV/1vbMQn4DHlteY5RetAWN1dvX6LdSvz1/KWXOrG7n
         e5YJWcF8U11Igi1E5Boo0EIHronSBCm76+uhmHtDJhnodRdsE7xZNz7DeIPR6dRZ6W
         54KrcM8zRjoVKNy1dvka4f4bOqr+TJwR4Kh3cklaU43x+6thXjsEvyHneLudKqjQPw
         F5g0CFmM6Z768LK1XK8jl7/nvlk1vsWOfPjojesMP8PiYzMYGilXrlE+E6MwvuVK33
         h3YxdbKwgbKUw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, YueHaibing <yuehaibing@huawei.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] aic94xx: avoid -Wempty-body warning
Date:   Mon, 22 Mar 2021 11:25:43 +0100
Message-Id: <20210322102549.278661-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building with 'make W=1' shows a harmless -Wempty-body warning:

drivers/scsi/aic94xx/aic94xx_init.c: In function 'asd_free_queues':
drivers/scsi/aic94xx/aic94xx_init.c:858:62: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  858 |                 ASD_DPRINTK("Uh-oh! Pending is not empty!\n");

Change the empty ASD_DPRINTK() macro to no_printk(), which avoids this
warning and adds format string checking.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aic94xx/aic94xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 98978bc199ff..8f24180646c2 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -33,7 +33,7 @@
 #ifdef ASD_DEBUG
 #define ASD_DPRINTK asd_printk
 #else
-#define ASD_DPRINTK(fmt, ...)
+#define ASD_DPRINTK(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 /* 2*ITNL timeout + 1 second */
-- 
2.29.2

