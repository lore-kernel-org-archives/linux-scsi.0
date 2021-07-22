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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873A9C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74AB360EB1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhGVVhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhGVVhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:37:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57291C0613C1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id hg12-20020a17090b300cb02901736d9d2218so1262154pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F5uXE3+CkG81nvwpQcmJn83Lv9JeHBQN+QfpopGs3tc=;
        b=uMaxKxA650Oyxs/8s4MSTQ5Yzrnsti+SdktR9h3uU84ZD/S/tg6XvB6C4c40RKG6LK
         hNrvLqwU4NEg+VONp0DS4NUwk1jJqV72DHW02S4YmzwBU9355ZIUARUY67+54NisnOHy
         5KSAteU7fodjM6rZDx8TqbJZ7yM/1KzLJJsT0qoid7N+K7lkp+6Adfe+bo4POnD7B+U7
         qAbv85ibkvM00S/wp+ASPr5ZQsNu19/EHDJBGTrOodKbHi0uMRwRQxWj+vjYBs+oIfqZ
         KcU0aKV/yjOSqEOpItRz2iTj/+uaHF+mK3NwSrZrjN21EQB10tyjRNEDnAtVsx2isslN
         6MNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F5uXE3+CkG81nvwpQcmJn83Lv9JeHBQN+QfpopGs3tc=;
        b=ieQ2z8Lfkd8GP59w7iDF31AZdqn/BsP/rRuv2P0zdZJ/KQErdKDABK9H4DhrrX8+Zu
         Azk3nJpFdQbqqukTWf+ldrrodxVg9ok0HzwU9X9K8t1TwY6RBx4Abv5yVxDuk3tEe9Zq
         w2o12cFPK+17ppoVYmzBrE2NWt9ihUeab+sY1/Lu30Rbr9MAcyIu0iWaKuLwyZ5+SY/y
         qv5bs6u3jSnNk8PNiwDJ4yIoW7Y3woWignnr3DvdseKBLA8v/k0cWMHzGpCuMdyY3e5w
         CrAWwdbndCaPSMCbuRTN+Yw2CcsOZHedmcg/+/hbZZAX5X7wrh0J4GzKtXqDWW5xSk9s
         dKgw==
X-Gm-Message-State: AOAM5325E/cBXJsOlxvSiuw9QkKGuBygqKjoyGroRV+0/AZYf9LsFf4H
        kNJEkfRn95+mqUi5qfKwI7r8CI0E1JE=
X-Google-Smtp-Source: ABdhPJwPZQ3rIbBIvwpjI3i6IuHnCHJBvT2Wodvbwc6LklxZRw15a6cx1tlzxtckosXq7a+bLPLeKA==
X-Received: by 2002:a65:6111:: with SMTP id z17mr1983091pgu.335.1626992262880;
        Thu, 22 Jul 2021 15:17:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5/6] lpfc: Update lpfc version to 14.0.0.0
Date:   Thu, 22 Jul 2021 15:17:20 -0700
Message-Id: <20210722221721.74388-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.0.0.0

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 63b2690ab49f..73a5b3bbdacd 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.11"
+#define LPFC_DRIVER_VERSION "14.0.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

