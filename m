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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD5AC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65728610CF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhHMXB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbhHMXBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 19:01:54 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0E6C061756
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so18199202pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rll7Qj4dW4CpMS9diLJDYM5fmrrZYHUz76jCCwqBRPw=;
        b=DMFolXv35ipRKcH2nnaANgDZ3WnpSCpe2CDijr5mDh7IHU8qFj9Mz92TbrUB/b+OAh
         291pzuNANL+YsNrCVEKTEM2cGEKtQnmwecjjsbc/3IaZ8vIywtqi6BdquyJ8WtxFewir
         KiW+wpY9DKUStlqTr3je6CB6iMNEMwp4tY3mPf3PEwzzj4aRD6DbaomRTIOjZlVmCRbJ
         7G+v7ZXmb8cUq1vKXJaWlk1jE75AwcUSC8O9E2jaqMEJlkKtxM+om3tkWBuVDmnUmMwJ
         lQ7ByprJd3cbNvrcKy80X8wV9/K/R0Ju8VoBtM9KZr1ZKGlDstIYa8cvVUWyZkBTkbVt
         fX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rll7Qj4dW4CpMS9diLJDYM5fmrrZYHUz76jCCwqBRPw=;
        b=VEZfIsfj5QAb6qPAUz0CUr+4Yl2UmW45UUKXo4xo7Mtq9Tx8zKCw2KfQyxU9nly0rR
         kMijRM3FeQW1SxNYigYwTHnVhftAvmnp1Qk9F+pAs3CCHeLp0L1Vfr0yNeVt/8XoyTG1
         gyKtesWFwTJ2MbU6tiiPyuC5nn1ftzj/Gz7Vvx4TfE8HhGNLeohrzq2s8/Z8XpknTOc7
         kUj8aiC1n+nfilIDzuYZr+P0yACDygJF3RLofK9a/C1egSdlgPxuCSkiBRKmigJ0H2eM
         L/yCIdc8ZbDvTlsrHTBijhcZg3sa9QCdTXTRZsDl3n5NIIqESPw2UAVoT2apdksTuYO9
         KXGw==
X-Gm-Message-State: AOAM531iivyqP3kqqTV7jyv1MSbetd3/gXVgeZlBfIDFeSK4OD7s4NDy
        x+kcgZw8mHIcBiUARvC0xKgWIziL7GU=
X-Google-Smtp-Source: ABdhPJxhZ1+l9Hqk6r6POZMQNt1N7Zkk4QjM+keSp3Q8SlX6Qfc/ltSf6A6edlNQ4H+Ysxc5vIIRCQ==
X-Received: by 2002:a17:90a:458c:: with SMTP id v12mr4889716pjg.50.1628895686456;
        Fri, 13 Aug 2021 16:01:26 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e8sm4001997pgg.31.2021.08.13.16.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:01:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 15/16] lpfc: Update lpfc version to 14.0.0.1
Date:   Fri, 13 Aug 2021 16:00:38 -0700
Message-Id: <20210813230039.110546-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813230039.110546-1-jsmart2021@gmail.com>
References: <20210813230039.110546-1-jsmart2021@gmail.com>
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

