Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9D9C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A4D61038
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhHMCJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbhHMCJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50205C0617AE
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:59 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n12so9234369plf.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rll7Qj4dW4CpMS9diLJDYM5fmrrZYHUz76jCCwqBRPw=;
        b=Kqn8ZTlpZWgm0ueAKjWxqkINdR92aNcFH3bRAV0PqIiRZNAulQOsiPzKhuNu5n3sRj
         onrQaDJSy4/RNDiijsx2BKM+MPWrKPIXtgBGXbr18qXmuXTT7atIguK+NT5gZqC+EDVo
         LFb75rjAovYqQ9VvFTTpDKcDiuI9jNbEZ9SMGLxYINZ3qCKTYRb8wBTKld3iewoF6Mmf
         syTatu1QrjiB8KvRcMwnhPRLvv58ey8ifmsT+aodJqGSUAcxQVgQf9EDNvg34bsFU8Db
         wC2oSkkjZ3P5kukljAS8lwqgAUDBWM/3dcDWD/423DPK7bGKq4VenZAHuvIHg2dpPECT
         qBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rll7Qj4dW4CpMS9diLJDYM5fmrrZYHUz76jCCwqBRPw=;
        b=Mfp4KxF+83hm31Y/lxwu7JRBgPLOHUu95uT9TA1D1/zd7bRaQ4ksyAo93jkm74ayR4
         GmxVo7vqPoSVwKgt6KUTumpfRlMDmP8swTPu6BpGdsrWAuRUtrIDmSNwFAq57iQqE0XI
         c/YmhXVC1k38W8KfttEs4k0r7z/YtPwbR+qFX+1GQU8IXwA2cMMa3wPLf7NH3jmkgz3S
         uwfyIGyUlsXuFhgYI59BRTwo3hkded99k8evdSJSmNNCK2wNGzlV/+2/muZ9+85laJbH
         TM7II8vPsnlxiQmhr07Ppbr9Srn8JhL/n0zaFE7Um6tjY2Pg4HuEH3VAV+jxypojDhbQ
         tvfQ==
X-Gm-Message-State: AOAM530CX8Oo1s5tHwfYUTQOnmQcAoZelQvZh8wSGMx3AXlP1Kdo0HzX
        SGt8qMVX2LHhV473raIiZB2eQK41znY=
X-Google-Smtp-Source: ABdhPJw69lkx/jKpkmACxNkFGyrR7j4aoLLI96zieERZi4PvYlQr4lwtA+6DcXt3OYslS6HAkKc/IA==
X-Received: by 2002:a17:90a:4285:: with SMTP id p5mr93900pjg.162.1628820538883;
        Thu, 12 Aug 2021 19:08:58 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:58 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 15/16] lpfc: Update lpfc version to 14.0.0.1
Date:   Thu, 12 Aug 2021 19:08:11 -0700
Message-Id: <20210813020812.99014-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813020812.99014-1-jsmart2021@gmail.com>
References: <20210813020812.99014-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.0.0.1

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 73a5b3bbdacd..a7aba7833425 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.0.0.0"
+#define LPFC_DRIVER_VERSION "14.0.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

