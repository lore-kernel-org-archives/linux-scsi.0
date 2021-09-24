Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B8DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 13:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB4861038
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 13:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346343AbhIXN3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 09:29:49 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37410
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345989AbhIXN3N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Sep 2021 09:29:13 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 243BE4081F
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632490060;
        bh=Yduh3EuPKF8pEjpWRTy33G3o5bhDuVyJYzIS4FssiFw=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ceck0YRo9yrTB1m86Phc3zWHRXquEMKT5qXI7OckV7hOJ+wf2n71K7xtm5PTzT914
         oRmuSx1Jyu2rTkp9Od8+8/VR3lMQML5bKoMD8423nfnmFMh82spjyegc2neqBvQku5
         iHjeCTckh6uxgCOFHJFPtnPHiKk7FSqJRiqd/OQSoukI3Rojj+DhTq+sP+N1RZN1Hq
         oI609QlNdocvCl265+/7fnU4MzCrwqcksiWlQUgv/4c5Ibrk1cmlBrH2bqKfTstWC4
         0UQH4VlnPVXwxf0mAtAUMWQbd/KYHkwLemW6gvTfE3MreJch0c6dXiOssgTgB/HlfR
         j8s3xmfF/07mA==
Received: by mail-wr1-f72.google.com with SMTP id e1-20020adfa741000000b0015e424fdd01so8090809wrd.11
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 06:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yduh3EuPKF8pEjpWRTy33G3o5bhDuVyJYzIS4FssiFw=;
        b=NvwP6J5RBsFxK8wbPgx5nhelqe6roCcwV+dm516OlvpbM83RquBuGu3xMhKDo/CVLs
         apEYkqvG6Qi26FwqFC5hfmA4oirazNyJB23jaZrLwALeKZuyNAj+n1EseduCAd1tuWk7
         +cWTf+xu0fomQ+CuysdF0H0FPLjDIMUF+w8kW5l+tL/XuOTDXMG1Hgv/O+0wgAFCmDCr
         b+3RuDgghpPP2ztcIDaKD7rRLi8poezaS/A4uSz9wb4eQf+yYx+G73moPS/zPDP6DPJD
         3oxgRZ0KqNIBBxdnp+ounFURng/Dabwi7uBlHzOtJ2iGObgypAiuuHXhlqfMyw6lBX4l
         8Xlw==
X-Gm-Message-State: AOAM533nDLDEbLDNJ0gwD1Ek//tWKew9NG7p1pMIFJEZqr2Ou1haJBSl
        TVNbajLb4nDoyklH58DoWcZ+Mr6X8OCCeywZkPaWDgRPwCNs+tbvnNG2lFpk0413kqDMJbBQ4sg
        RpYEHhI+Pvottq8q3p5sbWPGt1VPj5o/LTOtdoaI=
X-Received: by 2002:a5d:6545:: with SMTP id z5mr11455574wrv.51.1632490059711;
        Fri, 24 Sep 2021 06:27:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5S/UeS56vFgo1ZCJhSJ4phgoKPfDX2Y+OA8xv8ibUzmyYGx+lfLXUHLOGyC+XxWzMQL4icA==
X-Received: by 2002:a5d:6545:: with SMTP id z5mr11455561wrv.51.1632490059558;
        Fri, 24 Sep 2021 06:27:39 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id s2sm30386wru.3.2021.09.24.06.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 06:27:39 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 2/2] scsi: ufs: exynos: unify naming
Date:   Fri, 24 Sep 2021 15:26:58 +0200
Message-Id: <20210924132658.109814-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
References: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use everywhere "Samsung" and "Exynos", not the uppercase versions.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/scsi/ufs/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 565e8aa6319d..af66cb3634a8 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -165,14 +165,14 @@ config SCSI_UFS_BSG
 	  If unsure, say N.
 
 config SCSI_UFS_EXYNOS
-	tristate "EXYNOS specific hooks to UFS controller platform driver"
+	tristate "Exynos specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
 	help
-	  This selects the EXYNOS specific additions to UFSHCD platform driver.
-	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with
-	  UFS-PHY driver.
+	  This selects the Samsung Exynos SoC specific additions to UFSHCD
+	  platform driver.  UFS host on Samsung Exynos SoC includes HCI and
+	  UNIPRO layer, and associates with UFS-PHY driver.
 
-	  Select this if you have UFS host controller on EXYNOS chipset.
+	  Select this if you have UFS host controller on Samsung Exynos SoC.
 	  If unsure, say N.
 
 config SCSI_UFS_CRYPTO
-- 
2.30.2

