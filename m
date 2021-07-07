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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA11C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C6A61CCD
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhGGSrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbhGGSqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9391CC061762
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso2216935pjp.5
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y1Fd06JvSHl4wSEfCiUbzcae9DXL7XG3BQE57xZeIKs=;
        b=KiCDh4yD8L10BF8PIviMc4hIGqVELRQy1rSeIZUcDMm6sF3ZaORHazvbhnAxmviO8F
         HCR6I0iZPrnE/+Zv64ZNfa7Llovar6pRFB0UYjL5gFMZJ08GlPgSWO2sTLjFnxz7WpDb
         hh81xw8OVj7lFSLIXCeePKLTs8qhEGKDDRLgc1nOUWlx1tPAYYIyS4PcLtKI3A1dV2bB
         2muJc0DaJhRsnTketORsNHI/XCOs5awX+NjUE02v4ffUsSxA947/3s47CW8Zkuw6nA2q
         VBPbRt6VA+li8EN0BZkg/jzkWpmChmXgICZZyvxuVDOyzj4XBfCM66TegML2fV7xTITz
         VePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y1Fd06JvSHl4wSEfCiUbzcae9DXL7XG3BQE57xZeIKs=;
        b=HheBUmbLLbpyIgp5HCw3w96OK+SeAyuAkrkmHUPeUBqgF5CBeVkjHXK42QfCm5Wgvc
         ULRwoW6UMu/Vma5epiUINaRmuHRHj2UXehOGF28qbGYpS0reZVShwA++DjhQV9CiaJDh
         u1QQTnTTM6oWP+glPoL9SHCjWkT25GzNxEVEONUa+Ex+zGl9wOshHVAhgrbw0WAr7li3
         eSjkw+vvpS3mNDxqYYD3YqN6Wi2lSKTWWKCH6T2ywi+SsXHU0wDctUQDqNamVF4rayWj
         yKBf5YgHkb587B7/x7lGOwPJJCAP8PQiZm2ykkI2XNIp6maeu/uL4wxfk5OczHJzg7iS
         4qTA==
X-Gm-Message-State: AOAM5316VTAzmDkYCrhu8DqFbnFb4wFC03GNpCCpqnelxPlYFF5OMJDO
        VqOMTcP9Qvx+439+qSi1eDCGUMA1ips=
X-Google-Smtp-Source: ABdhPJwNh2zllbHSxGa7+D9JTN63V+D11SN6U0usirTxXiK0BhxdWghEuwBh+3rD41ApFmyPki1SMA==
X-Received: by 2002:a17:903:2445:b029:129:586e:7d16 with SMTP id l5-20020a1709032445b0290129586e7d16mr22437816pls.54.1625683448092;
        Wed, 07 Jul 2021 11:44:08 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 19/20] lpfc: Update lpfc version to 12.8.0.11
Date:   Wed,  7 Jul 2021 11:43:50 -0700
Message-Id: <20210707184351.67872-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.11

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 2d62fd2a9824..63b2690ab49f 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.10"
+#define LPFC_DRIVER_VERSION "12.8.0.11"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

