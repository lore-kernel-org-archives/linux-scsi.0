Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7CDC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA02C60FD8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhHPQaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhHPQaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:30:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A87C061764
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u15so5875502plg.13
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rll7Qj4dW4CpMS9diLJDYM5fmrrZYHUz76jCCwqBRPw=;
        b=UGRSsEEFZVzsdBqiR1F++Jht7BwAk1LSPQ918Ef9MyDaiwRTz3JEj/GNnjvBaiYNHO
         xLes9YvnsmSpgMxWZ3mtQXvA/xhif24xR0F2GVq78t+4Ezmrwu+PmmZ044GNtW2wbiOW
         U8uUglDUxvt06oEDqG6ZU2/jebig8SVpu7KBZlOhHe7LrgFgwqk3uFaZuGeUp/mF+3mn
         8fGqRqjiXb12WQf4fJ6DCXuXquYHKXltNv5zrQBJo6g/DPQu1dSrBx2PCxUKWLrLQWDl
         JVyGAH3mZ0hbYatH4xK8HrVS//tXVnNYMFPaqtF92SWDyqzJZ/K7+8DLRav3a+2ULNUe
         c6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rll7Qj4dW4CpMS9diLJDYM5fmrrZYHUz76jCCwqBRPw=;
        b=cq8NuRxU+PnlGBKfYc17OWtGg/YD7SOUestXZIidjTlsBKaRGo7pHvqXcktBtX5DKz
         w39gsX7WUkWvuxHCPryEU+p7aSEVXHNzF6iRSuV23t1GmwE/Fzqi0i4ltlgpEodwzfAQ
         SSwsaEb96sYtW9GIMGaN+omKKTEJeOuw679okPMHCuvkAP66JjRN12hn5aebQZL6DPw3
         yALOxg1b1rPq3Glgw5yYK3RKHmAH2xhHubpkHI/iN6b2lb96AP+unBrImQlpAu4QfXv4
         WA9VZOPNpuwQPE0a/0GnZwDUcEfDQR0JyQijvdoRqfZLcLPJ/c1nkMUPh3ZPfPtlTjqN
         N8ZQ==
X-Gm-Message-State: AOAM532b9JM638m5gGaYUlCcqwDP/lxzC8Edl1kYuj+W2yqRPfNpTVvf
        2dJZ1SIm2r5XJ0C6DNObkEs/5TkTHws=
X-Google-Smtp-Source: ABdhPJz3LdprmhMLzvcz7zVjtg+7DAF8XPE3Owph2lhFJDrNmq9PrbZX2DDmLBs4itZUyddwD9sDQw==
X-Received: by 2002:a17:902:d48e:b0:12d:7aa5:de2e with SMTP id c14-20020a170902d48e00b0012d7aa5de2emr13748684plg.34.1629131388423;
        Mon, 16 Aug 2021 09:29:48 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 15/16] lpfc: Update lpfc version to 14.0.0.1
Date:   Mon, 16 Aug 2021 09:29:00 -0700
Message-Id: <20210816162901.121235-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
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

