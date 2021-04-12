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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB6CC43617
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8BBD61027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhDLBcd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbhDLBc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:26 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0603C06138F
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g35so8131363pgg.9
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stCELdhIiUZlBosPWqbAjPD6ANC0oLuk4sX+u/mfYVE=;
        b=Z1RUYCWOzaVDvywJTAtYIBJcVEKYyAKOl6g7xsicfcjhlLYtulmK87Z/U1/3xt3iC/
         6Tir12qvGLYrC7QBC0Pix1eL0XGRcm03uRp1SQ+zitPNBucMWDjC+R80RppW1oPN1M1r
         8UeFLpo6exI+4oPdmDsWbjsYlcXkXhXVzmPObYV1UbKtZ9sWObKHr0dLoDnN68/FN5jY
         8ymuEOZfg828A4M8E+FEk9SuCr3WWNrkzQfq7//kHSjC2UjSZG2VLK0YlH18Bs3pSwgE
         MYv6usetctci2Tbj5OZ3CYL77MPd4ig0FmZbVx7bivY5T/+Uq20V+tGNPC6KXWgv3z7a
         4lqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stCELdhIiUZlBosPWqbAjPD6ANC0oLuk4sX+u/mfYVE=;
        b=bx0q13x1tcnkiZqI09IwkaM14PpOt1YKsKZHh5ZswAZ2vPH09G8AZwT1BcdXctc/zl
         8e7Yx4JYrvtCrwUyteG9++Qat7O6/R8LV5E220S0PHcyDZWhdLIru835UsRKf/KB5Fko
         pSPCHy2TKDiKmfhRoVeHT0tp1B1t/xk4y4y2e1/Pb0YNQRkbMVqZ1ecBoFgEnUyShUl2
         r3IPh8Uu5luMJWzDQ2ZLggcYOJ32pl3Qb2CAauM/1D/+5UY5pC4zLYw0wN6eX5Rv0jqu
         mYribKzYy0A3eQf3a1m4CUhhE1/frW7v7DLKRnxSOUaL5w3bTXNiBAxXdgU5xXeCPYVG
         YGVQ==
X-Gm-Message-State: AOAM53093JlNZwID6WYzzTFgOh4SZs8z5p64vZDIBqHkgO+3LV4Utk6+
        31PIj95Z2opkwFjJ2wmd1ETMEYhZ9VA=
X-Google-Smtp-Source: ABdhPJzGIvmt4/xViQYH3zRuqlpXLTAbCXzplDCImMOJEJPLgULuLhQ5rrYa4+UMznk1yLITIuVTAg==
X-Received: by 2002:a63:a42:: with SMTP id z2mr24242845pgk.52.1618191129202;
        Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 15/16] lpfc: Update lpfc version to 12.8.0.9
Date:   Sun, 11 Apr 2021 18:31:26 -0700
Message-Id: <20210412013127.2387-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
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

