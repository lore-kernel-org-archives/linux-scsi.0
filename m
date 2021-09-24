Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70095C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 13:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 577736103D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 13:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345422AbhIXN3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 09:29:39 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37366
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344626AbhIXN3N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Sep 2021 09:29:13 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 00F5140816
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632490059;
        bh=9lxNX9SoiwZF5dcOxctnI5jIG4IwRTL7ipvDb0MgSb8=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=J8Hbx7SepeE+AcmOYkNKT+YzE/IJzUXtUFx1N+cMSc41sG6gZnwju729Rusiy6eun
         CcWcQT1Z0YwRQX23lLeThzuPnWPHR1TKhlaKOic/Tpnu2NLPXHOricuLb0JjAXfaE2
         pbZ64YAuMpE2ShTs6ua6+tk8Zfp3UR9pq3e971n0RDA1sOr5vfiDpoPmNhBQquR6vJ
         DWvjr6YJNgm6ohxvmxIrbtwZT2NhebErTpnHMnH16Vh41KaGpp0pT11fHMGxTCLpfW
         ONwclpzBoZApFG84LiZ9RmDjuzkux8yXUuRxcE3XcifFqf1FkAQlJnOlaZuVvjChIz
         plbg36gY+GBWg==
Received: by mail-wr1-f69.google.com with SMTP id j16-20020adfa550000000b0016012acc443so8072955wrb.14
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 06:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9lxNX9SoiwZF5dcOxctnI5jIG4IwRTL7ipvDb0MgSb8=;
        b=DABIFZ/YFpdmcJFt5dKAO/h5Y6+CDN8cyRkkakyxZzz7F4NhVWLoWMO8/ofNVAexyO
         l08rtwIx2OVSIPqmQfvRAuz+hmzIvzrd3OD+2z86BtOXheSwAL1eUoF+guPvEshzJkyC
         1U0lLjsbjjoto4MxyQKZvuE5hnWOm41X4/G6+51rx6K7vWSUHCvVZ4kYbE3s12ZqtPGl
         dfAgzvP5upUN3FfWbSCj2KIxMLmjInKV2FYTddGVtKJp0tAgs1ShJa1E7apq8CceF1Gk
         YGZKHR5PVyAl/PYTxs7yI/cw3E4qcRoVayg0vB8NRfjOKEcAEBWSBsLhXxEenc6cveGB
         9muQ==
X-Gm-Message-State: AOAM5306Q6S5jXJGoBT5+qWzsgfov9eNUteuwAlm+X1KSd+dD53lvyfg
        uH24qlXfEa3EDETOQhVqImtxFOolTNwGX7gQDGbnQmS+8glg6HPVsyYCjsIOyj7llMZOEZCLKSm
        lIk8zJBsUtcBOJI8uZfojAvBMICU6xEj4231NjaE=
X-Received: by 2002:a5d:58cd:: with SMTP id o13mr11753115wrf.416.1632490058476;
        Fri, 24 Sep 2021 06:27:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjGdcj1FCIMyVG6GWQ+ezHpaSa3jvvTO0U6+mzqQ5umN+Qve67heywragH63BpP0dQDzzy9w==
X-Received: by 2002:a5d:58cd:: with SMTP id o13mr11753098wrf.416.1632490058315;
        Fri, 24 Sep 2021 06:27:38 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id s2sm30386wru.3.2021.09.24.06.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 06:27:37 -0700 (PDT)
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
Subject: [PATCH 1/2] phy: samsung: unify naming and describe driver in KConfig
Date:   Fri, 24 Sep 2021 15:26:57 +0200
Message-Id: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use everywhere "Samsung" and "Exynos", not the uppercase versions.
Describe better which driver applies to which SoC, to make configuring
kernel for Samsung SoC easier.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/phy/samsung/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/samsung/Kconfig b/drivers/phy/samsung/Kconfig
index e20d2fcc9fe7..3ccaabf2850a 100644
--- a/drivers/phy/samsung/Kconfig
+++ b/drivers/phy/samsung/Kconfig
@@ -30,16 +30,16 @@ config PHY_EXYNOS_PCIE
 	  This driver provides PHY interface for Exynos PCIe controller.
 
 config PHY_SAMSUNG_UFS
-	tristate "SAMSUNG SoC series UFS PHY driver"
+	tristate "Exynos SoC series UFS PHY driver"
 	depends on OF && (ARCH_EXYNOS || COMPILE_TEST)
 	select GENERIC_PHY
 	help
-	  Enable this to support the Samsung UFS PHY driver for
-	  Samsung SoCs. This driver provides the interface for UFS
-	  host controller to do PHY related programming.
+	  Enable this to support the Samsung Exynos SoC UFS PHY driver for
+	  Samsung Exynos SoCs. This driver provides the interface for UFS host
+	  controller to do PHY related programming.
 
 config PHY_SAMSUNG_USB2
-	tristate "Samsung USB 2.0 PHY driver"
+	tristate "S5P/Exynos SoC series USB 2.0 PHY driver"
 	depends on HAS_IOMEM
 	depends on USB_EHCI_EXYNOS || USB_OHCI_EXYNOS || USB_DWC2 || COMPILE_TEST
 	select GENERIC_PHY
@@ -47,9 +47,9 @@ config PHY_SAMSUNG_USB2
 	default ARCH_EXYNOS
 	help
 	  Enable this to support the Samsung USB 2.0 PHY driver for Samsung
-	  SoCs. This driver provides the interface for USB 2.0 PHY. Support
-	  for particular PHYs will be enabled based on the SoC type in addition
-	  to this driver.
+	  S5Pv210 and Exynos SoCs. This driver provides the interface for USB
+	  2.0 PHY. Support for particular PHYs will be enabled based on the SoC
+	  type in addition to this driver.
 
 config PHY_EXYNOS4210_USB2
 	bool
-- 
2.30.2

