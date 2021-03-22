Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B16C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 10:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1E9E619A4
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 10:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCVK0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhCVK0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 06:26:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F12356198F;
        Mon, 22 Mar 2021 10:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616408760;
        bh=dGYeYvd2IMaLpz/92eRucjW7Pn+8zXubyKFXkBRPJx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/vUGanAwOcKNRssfNrcu4aAsR6Uh3CmHH5vt6+NvCJ41TcVXv6d03BziSNlKkS2k
         vGFBq9Vwa6rgnVH5ldgdMuTAn+MR5uBUJVpvt1NUT6aHcnvnQNeyq3h2Vq/4XHu5US
         VNJOekwzS400wV68ckC75qM09oG5vWYfc1t7T9b0ZA7j2UoGSH5Hc1f4SQXAILSswC
         S6c29vkpctkYdyptFIHDCsCjsRMYeQSFT8LgjY5Yinv3fliPPfGlfLLY84ltw2Q9g6
         IfVYp4gNm8QwzLLGqqY68iWEUq2zjQnA9d8rcRaKadPp6MwLI/EDIvVNGKz6QiDQOT
         cnw96gQpU8eVw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: message: fusion: avoid -Wempty-body warnings
Date:   Mon, 22 Mar 2021 11:25:44 +0100
Message-Id: <20210322102549.278661-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322102549.278661-1-arnd@kernel.org>
References: <20210322102549.278661-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are a couple of warnings in this driver when building with W=1:

drivers/message/fusion/mptbase.c: In function 'PrimeIocFifos':
drivers/message/fusion/mptbase.c:4608:65: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
 4608 |                     "restoring 64 bit addressing\n", ioc->name));
      |                                                                 ^
drivers/message/fusion/mptbase.c:4633:65: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
 4633 |                     "restoring 64 bit addressing\n", ioc->name));

The macros are slightly suboptimal since are not proper statements.
Change both versions to the usual "do { ... } while (0)" style to
make them more robust and avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/message/fusion/mptdebug.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptdebug.h b/drivers/message/fusion/mptdebug.h
index 2205dcab0adb..c281b1359419 100644
--- a/drivers/message/fusion/mptdebug.h
+++ b/drivers/message/fusion/mptdebug.h
@@ -67,12 +67,13 @@
 
 #ifdef CONFIG_FUSION_LOGGING
 #define MPT_CHECK_LOGGING(IOC, CMD, BITS)			\
-{								\
+do {								\
 	if (IOC->debug_level & BITS)				\
 		CMD;						\
-}
+} while (0)
 #else
-#define MPT_CHECK_LOGGING(IOC, CMD, BITS)
+#define MPT_CHECK_LOGGING(IOC, CMD, BITS)			\
+do { } while (0)
 #endif
 
 
-- 
2.29.2

