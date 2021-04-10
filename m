Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D4EC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A137610A4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhDJRbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhDJRbJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4327BC06138C
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so4803684pjv.1
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stCELdhIiUZlBosPWqbAjPD6ANC0oLuk4sX+u/mfYVE=;
        b=Vx+1oGlix6HNA46Hx4is+4V/0KfjrZ7t3CbPdokJ+hE+pspRnG/XxpChNkiL0crEr8
         +9H/YIXOcJE++eeVaWfGArh9b2zNOeoyZw1I0c2ZO5r8hGsyDoLmhl32K1H7/YuJ8q3c
         kCDZg/cJHM/cZmM9W2d0IewIYM6Pwfu2Hg7EFQXV1OsMxS73gU8brkz8Jf9pds/dV1Zj
         1FyvfjWdw0orYGL9E/VF89iMq/y2arSuL32bhbRT2jd9BrDKGl6K0dRr9HCe1HlZoIpA
         LahXrIW3QDxoSSip922AR63c+k57Jwlt75AxTTLQkN9mEJZmJWppCgH8SbZyCnWn8Z6e
         tBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stCELdhIiUZlBosPWqbAjPD6ANC0oLuk4sX+u/mfYVE=;
        b=GhyHhOkzMfDXNPC4HIISckcDy9S8lZ+ueWWx8A1z+ZhKxJ2gFmyN8PThmqGv90869T
         XCVJTYte+zICGGW+ovOHmmmlb/wLRJrsOQSqjgY5pLSSMLd3Nv6U6TNKcfmI/wmLz8Kz
         57PZppFlix1F6dkOY/XUKmFFBivkPAbA+kpJjB+/LGuCjdNK+jpaK3KOj2UMnWj05g4n
         MKdTom12HrhJSvNqTUjpXZPgpO40d2/sTR8Rik22hKgNLiKiARBSxDeZwP4RtxRLC95D
         C5x6UvL5XOEATU8soH1B5V+rEu6Dp32DRZuMLGmAiFR2Sh90uJm6bacOSjB4ntUDDpXy
         sg7w==
X-Gm-Message-State: AOAM531YdAPlvWfxRRuG71dQh1VBcLx2sUEShTCvdVf9ji27ZkRXhEU/
        4u2KdM1MhMUzTdvOBhCqa8TBOIwmEp4=
X-Google-Smtp-Source: ABdhPJzT9Ttc2eFJ7gz8Bwk/l9tdXS75DqzktIonQK7b+QihcuPw/eEGEY8YrQw5HBvVhoEH6yPiVA==
X-Received: by 2002:a17:902:8ec1:b029:e9:998d:91f3 with SMTP id x1-20020a1709028ec1b02900e9998d91f3mr12331881plo.59.1618075853598;
        Sat, 10 Apr 2021 10:30:53 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 15/16] lpfc: Update lpfc version to 12.8.0.9
Date:   Sat, 10 Apr 2021 10:30:33 -0700
Message-Id: <20210410173034.67618-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.9

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index bee74bd3c1d7..4b8e89375644 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.8"
+#define LPFC_DRIVER_VERSION "12.8.0.9"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

