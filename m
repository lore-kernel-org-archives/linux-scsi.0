Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD56BC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B491A6112D
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhENT5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhENT5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BEEC061763
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:13 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 22so115179pfv.11
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VSMJvuXeP+yY40uik9Sg3O1hscebf5uPAwYSBPysMxg=;
        b=KxUFZZqa75sXv42Te0XS+ZI4bdpNK9lzEdd4DnO5dA8O6Zr9U6Xn5tm2jHdWc7zSvI
         /WevKQymvZIWegZmI0wOR+4/IFdny3hb4wpWrymQi6QGITof4XGj13hMGuSWmDL8/tYR
         FfXGUMtNq85TDXfr4PQDeWcu/hHHuMCqlKBLk2VE1GlE6zuYODUGEO+d4TiY8y1Rmy/H
         /h0uRna/lhP0vdmQNywFj0B6FqBv2/SLOvizl+2AP94b7MEvCN9l6rC4Na/khS1/LIN/
         cx5VHXwmAaIpV3x244P2httPDus5dAbHsdTJN7LgO2+QJOZOpY+xDZzbbs67aORYRw88
         IloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VSMJvuXeP+yY40uik9Sg3O1hscebf5uPAwYSBPysMxg=;
        b=ahVXtkzmbRE80eVzeq9XM2VvZYaNsCysGW3WxL/cqdI1v5q04SAOm5AkXLrHEriXF9
         wXVX+HDQv7M+TKxwpX0KA0p+R/Rg3ou42NNbFhPVlwFL2puqU+REu6vuXhS44Hz62PJg
         Ul7XDrJRfQNOHWrG3YhlXt3HcFdWzq3fEVuyl5VgW0XGDg6bk5KCq8t6Gv0BNk9pGtJp
         yCQbQjF972aMeHKBa4bWdQWnleZq+o4+Lm7ScHUAUjfmyUMOa+24j8NWsOlOpThbuw9B
         WMjGs2zBmS6pQ09S/8XZgwyL9ePHK501zDNgmoA76Knad+j6/EzT6b7e8mNc6mV8JSvY
         L4VA==
X-Gm-Message-State: AOAM5313tdCtazMqb99QWVNY7OBKEpxbysJQ3nKCUAXYYbzZaHHmNws0
        X1C23nJz4lMQlCwoSEIwVw7wraiWuO0=
X-Google-Smtp-Source: ABdhPJyuNKO66p1CzgpiLMpErieIbwmCAH600s7w+8YkpWZ8Tp2NfmTB5mDo5MWMpeh7iZxNlPbh4A==
X-Received: by 2002:a63:de4e:: with SMTP id y14mr1955558pgi.30.1621022172791;
        Fri, 14 May 2021 12:56:12 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:12 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/11] lpfc: Update lpfc version to 12.8.0.10
Date:   Fri, 14 May 2021 12:55:59 -0700
Message-Id: <20210514195559.119853-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.10

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 4b8e89375644..2d62fd2a9824 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.9"
+#define LPFC_DRIVER_VERSION "12.8.0.10"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

