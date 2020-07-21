Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA7FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 17:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928DC20792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 17:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="J8tZUgfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgGURnP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:43:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21492 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgGURnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 13:43:13 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200721174311epoutp026e24d98ad5b6999f0906105bfedd4bbc~j1XUBYLo10033500335epoutp02t
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 17:43:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200721174311epoutp026e24d98ad5b6999f0906105bfedd4bbc~j1XUBYLo10033500335epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595353391;
        bh=ZwShZO+a014PmzFpaNLdKgRd8zKHz3dFayyZSE6/gEY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=J8tZUgfPdN9+uvSNrzLtVKBtSYRj2KjJn3va4Xh5GY51MuCYn91VGAmyOsXRT1f13
         gn5TcsOB4s1qcLyD7gkxSKwPtQYP5LSc5pDQbC1FxQYPze4+OBO5rE0PLlQvWOLL0w
         KxXTPYWc4oV8Tu8QRXz3v8C6B4Urs741QrDuJBa8=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200721174310epcas5p335ed36a6c3d8824f09eed1e504140cef~j1XTascMm2150421504epcas5p3J;
        Tue, 21 Jul 2020 17:43:10 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.AE.09475.E29271F5; Wed, 22 Jul 2020 02:43:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d~j1XS6wqD00695306953epcas5p2X;
        Tue, 21 Jul 2020 17:43:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721174310epsmtrp28e2598294da7cb61cade478620ec7117~j1XS6InEC1645216452epsmtrp2S;
        Tue, 21 Jul 2020 17:43:10 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-cb-5f17292e4e1e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.0F.08303.E29271F5; Wed, 22 Jul 2020 02:43:10 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200721174309epsmtip1a926f9aacd2120d4a58cfd5150322e5f~j1XR9CuGi1048510485epsmtip1E;
        Tue, 21 Jul 2020 17:43:09 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     martin.petersen@oracle.com
Cc:     rdunlap@infradead.org, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, sfr@canb.auug.org.au,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config
 warning
Date:   Tue, 21 Jul 2020 22:50:21 +0530
Message-Id: <20200721172021.28922-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWy7bCmlq6epni8wafzehYP5m1js3j58yqb
        Rff1HWwWy4//Y7J4e2c6i8XWvVfZHdg8Gm/cYPPYvELL4+PTWywefVtWMXp83iTn0X6gmymA
        LYrLJiU1J7MstUjfLoEr4+70TraCA5wV/04dZm5g/MnexcjJISFgInH87ku2LkYuDiGB3YwS
        Z9dvYoVwPjFKdJx/ww7hfGaUuLtgGlzL2vaPzBCJXYwSJ8/+h+pvYZJYtbmPEaSKTUBb4u70
        LUwgtoiAnMSk19+YQIqYBToZJR593wxWJCwQJNF+/hobiM0ioCrx+PFuVhCbV8BG4vOtHawQ
        6+QlVm84ALZOQmAVu8TBBaeZIBIuEtvObICyhSVeHd8CdZ+UxOd3e4GGcgDZ2RI9u4whwjUS
        S+cdY4Gw7SUOXJnDAlLCLKApsX6XPkiYWYBPovf3EyaITl6JjjYhiGpVieZ3V6E6pSUmdndD
        XeYhMWPbSbDrhQRiJT59u8s6gVFmFsLQBYyMqxglUwuKc9NTi00LjPNSy/WKE3OLS/PS9ZLz
        czcxguNby3sH46MHH/QOMTJxMB5ilOBgVhLh1WEUjxfiTUmsrEotyo8vKs1JLT7EKM3BoiTO
        q/TjTJyQQHpiSWp2ampBahFMlomDU6qBScRL4khzOyuvX9FSrRrtNE6uE2ZlOy1m7ioS7bPk
        W/byX3FX6L+WhgnRT6SdP/fvXOzMdViUdXO29M+Tm+q3vfUvWBj6ziHg7r6TLP72bSKbj0x5
        wCCXK1GzcpV61YJejSqWE78W1Tl+k5Y+nXpr9+Kcr9U7s/le7NgbzTtb+mvEvX9H3GWj7009
        MGPKlil9Ey+U2zTfmvR1dftHL8f4qwGnvWJtsxvaTHa73pDccvneAsm0xYueLknpOuFXzWjC
        vf7Tsuh3lstWHReOjN54fLNCkMu5lWJn/25hZf564KeWonD7h4tCjYwrnt/K9z4v0aJ9wuHg
        +rJTmfIF5S+rjgdkW2/VuHR0atXJ4PI355VYijMSDbWYi4oTAQwcLGBeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsWy7bCSnK6epni8weS3AhYP5m1js3j58yqb
        Rff1HWwWy4//Y7J4e2c6i8XWvVfZHdg8Gm/cYPPYvELL4+PTWywefVtWMXp83iTn0X6gmymA
        LYrLJiU1J7MstUjfLoEr4+70TraCA5wV/04dZm5g/MnexcjJISFgIrG2/SMziC0ksINRYvFt
        XYi4tMT1jROgaoQlVv57DmRzAdU0MUlcv7McrIFNQFvi7vQtTCC2iICcxKTX35hAipgF+hkl
        Hq7/D9YtLBAg8eLaF7AiFgFVicePd7OC2LwCNhKfb+1ghdggL7F6wwHmCYw8CxgZVjFKphYU
        56bnFhsWGOWllusVJ+YWl+al6yXn525iBAeRltYOxj2rPugdYmTiYDzEKMHBrCTCq8MoHi/E
        m5JYWZValB9fVJqTWnyIUZqDRUmc9+ushXFCAumJJanZqakFqUUwWSYOTqkGJuaEhuPMCl7l
        p/+y2x/Qe8QT0cn1bbPac85SneeW8XzpEv+5+SU3tO/Yk/v72APZtl+Mk2e37joW3nnt3BXl
        P3bCqckXD1ltuKdWLaI6ceJP5YfVWabnPWxtnLuu5q6Y7XpGTHP+PanOdUGPOnsMFOo1P0+I
        8ymoNTDxl0liSZ9h993uRIio9vvZrG3n49UYToVH26tN1fxiFWMaeUXh0YQuowuVy9y4N+wW
        iI+Z37D4dJhG+QRv43e3jztzhn1y1ZwpoHPMWfOc+IwSbtXcr+Uvlon+LPwxszFG4b2/7LOI
        uQJNfHfKFY9+n2HtaOzA9+TUW8fJxoxLy1JTE7pkkmrcv39VM1iYWXYhzFqJpTgj0VCLuag4
        EQAJPADCkQIAAA==
X-CMS-MailID: 20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With !CONFIG_OF and SCSI_UFS_EXYNOS selected, the below
warning is given:

WARNING: unmet direct dependencies detected for PHY_SAMSUNG_UFS
  Depends on [n]: OF [=n] && (ARCH_EXYNOS || COMPILE_TEST [=y])
  Selected by [y]:
  - SCSI_UFS_EXYNOS [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_UFSHCD_PLATFORM [=y] && (ARCH_EXYNOS || COMPILE_TEST [=y])

Fix it by removing PHY_SAMSUNG_UFS dependency.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 46a4542f37eb..590768758fc6 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -164,7 +164,6 @@ config SCSI_UFS_BSG
 config SCSI_UFS_EXYNOS
 	tristate "EXYNOS specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
-	select PHY_SAMSUNG_UFS
 	help
 	  This selects the EXYNOS specific additions to UFSHCD platform driver.
 	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with

base-commit: ab8be66e724ecf4bffb2895c9c91bbd44fa687c7
-- 
2.17.1

