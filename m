Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932D8C38A2D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73EE622202
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="f/vmilsA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbgDQSKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56313 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730371AbgDQSKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:12 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200417181007epoutp04cafb7bad4785e68a8815a3f73c9803f1~Grctw3sBA1493614936epoutp041
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200417181007epoutp04cafb7bad4785e68a8815a3f73c9803f1~Grctw3sBA1493614936epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147008;
        bh=oiCEJmK0tACS8TZgl1ceI/I0bD1xx/OZpcpK1o4POBw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=f/vmilsALfKTCaQC9Ng6B7YsbyLV1D3rZ6SzLkYM/V+Tlxt++QwKrkGLjJyVVryYT
         kI6VInjd4SIjMq7coaX6IOTKVSPZFmKUZvDizkeX0mPyd3SAN/QuO9W60qVqZPFWhu
         NV3GWfiPO3F2ReHWM+uRmL5dvHKsL1vEfQmJ8OKE=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200417181006epcas5p24f52712e1e973832095adc673595b5fc~GrcsqvLgV0105401054epcas5p2l;
        Fri, 17 Apr 2020 18:10:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.16.04778.EF0F99E5; Sat, 18 Apr 2020 03:10:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364~Grcr_R6fc0105401054epcas5p2i;
        Fri, 17 Apr 2020 18:10:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200417181006epsmtrp13c850803575bf2e50771d3d72ad4fbef~Grcr9T4P60669906699epsmtrp1D;
        Fri, 17 Apr 2020 18:10:06 +0000 (GMT)
X-AuditID: b6c32a4a-353ff700000012aa-07-5e99f0fe34f7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.D0.04024.DF0F99E5; Sat, 18 Apr 2020 03:10:05 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181004epsmtip1781ed587c91bb31ddc46c8aecb30bdca~GrcqI7GJd2094920949epsmtip1E;
        Fri, 17 Apr 2020 18:10:03 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Date:   Fri, 17 Apr 2020 23:29:34 +0530
Message-Id: <20200417175944.47189-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7bCmuu6/DzPjDH7e1rF4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGbtPHGAsaJSsuPZ9CXMD41ThLkYODgkBE4kPDxm7GLk4hAR2M0p8X38WyvnE
        KNG88CwrhPONUaLn2y+mLkZOsI4XH+6A2UICexklPi/ghihqYZLYeewjM0iCTUBb4u70LWBF
        IgLCEke+tTGC2MwCN5gkHqx0AbGFBWwktq7ezQJiswioSvzuPARWzwsU72tvZoVYJi+xesMB
        Zoi4oMTJmU9YIObISzRvnc0MslhC4DObxLL3p5khGlwktq/+B2ULS7w6voUdwpaSeNnfxg7x
        c7ZEzy5jiHCNxNJ5x1ggbHuJA1fmsICUMAtoSqzfpQ+xik+i9/cTJohOXomONiGIalWJ5ndX
        oTqlJSZ2d7NClHhIvJ6eDAmdWInXC2+yTWCUm4Xk/llI7p+FsGsBI/MqRsnUguLc9NRi0wKj
        vNRyveLE3OLSvHS95PzcTYzghKTltYNx2TmfQ4wCHIxKPLwdfTPjhFgTy4orcw8xSnAwK4nw
        HnQDCvGmJFZWpRblxxeV5qQWH2KU5mBREuedxHo1RkggPbEkNTs1tSC1CCbLxMEp1cDosML2
        gelk/SMLq1f+F0jWO6LG+HJ+zLe81TZpOYa7a1lWzOSpM5xg47oinOf6zctbD7W37lz0a63a
        sXCNr2nLX89N3Ps0IHBb5FP/p3mdVXllap1LdPpOLZnVsDPMz5+7YLnRIVV9O72Xvgdapq/s
        E8i7vnUZe+mOo9krOJomv35z6FKJJlecEktxRqKhFnNRcSIAQEhZCUQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWy7bCSnO7fDzPjDLa8tLR4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGbtPHGAsaJSsuPZ9CXMD41ThLkZODgkBE4kXH+4wdTFycQgJ7GaUWH5nCzNE
        Qlri+sYJ7BC2sMTKf8/ZIYqamCTanq5jBUmwCWhL3J2+hQnEFgEqOvKtjRHEZhZ4xiRx6mEp
        iC0sYCOxdfVuFhCbRUBV4nfnIbB6XqB4X3szK8QCeYnVGw4wQ8QFJU7OfAJUzwE0R11i/Twh
        iJHyEs1bZzNPYOSfhaRqFkLVLCRVCxiZVzFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525i
        BMeKluYOxstL4g8xCnAwKvHwGvTMjBNiTSwrrsw9xCjBwawkwnvQDSjEm5JYWZValB9fVJqT
        WnyIUZqDRUmc92nesUghgfTEktTs1NSC1CKYLBMHp1QDo2dZ7N5ZrxMmfZ+8YFP+P+PiDy2T
        bKZaO9ZFb1n/8Jzd+ZerTF93Pysrdqxj3jg/wq5RuuxXYHvm8wnTLjY7dBXfzP04X8vzbtGm
        9KNagk+Zt0zO4WBW0ZDzcZ731ubFhl+PZH1jLq/MOD1Ln/ne52Y1t9lfGmybjtuXaR1pa+vx
        PzkvtejKBSWW4oxEQy3mouJEAK8j1oSRAgAA
X-CMS-MailID: 20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364
References: <CGME20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

- Changes since v5:
* re-introduce various quicks which was removed because of no driver
* consumer of those quirks, initial 4 patches does the same.
* Added Reviewed-by tags
* rebased on top of v5.7-rc1
* included Kiwoong's patch in this series, which this driver needs

- Changes since v4:
* Addressed review comments from Avir and Rob 
* Minor improvment on the ufs phy and ufshc drivers
* Added Tested-by from Pawel
* Change UFS binding to DT schema format


- Changes since v3:
* Addressed Kishon's and Avir's review comments
* fixed make dt_binding_check error as pointed by Rob 

- Changes since v2:
* fixed build warning by kbuild test robot 
* Added Reported-by tags

- Changes since v1:
* fixed make dt_binding_check error as pointed by Rob
* Addressed Krzysztof's review comments
* Added Reviewed-by tags

Note: This series is based on Linux-5.7-rc1 (commit: 8f3d9f354286)

Alim Akhtar (9):
  scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr
  scsi: ufs: add quirk to disallow reset of interrupt aggregation
  scsi: ufs: add quirk to enable host controller without hce
  scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
  dt-bindings: phy: Document Samsung UFS PHY bindings
  phy: samsung-ufs: add UFS PHY driver for samsung SoC
  dt-bindings: ufs: Add DT binding documentation for ufs
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

Kiwoong Kim (1):
  scsi: ufs: add quirk to fix abnormal ocs fatal error

 .../bindings/phy/samsung,ufs-phy.yaml         |   74 +
 .../bindings/ufs/samsung,exynos-ufs.yaml      |   93 ++
 .../boot/dts/exynos/exynos7-espresso.dts      |    4 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi       |   44 +-
 drivers/phy/samsung/Kconfig                   |    9 +
 drivers/phy/samsung/Makefile                  |    1 +
 drivers/phy/samsung/phy-exynos7-ufs.h         |   85 ++
 drivers/phy/samsung/phy-samsung-ufs.c         |  369 +++++
 drivers/phy/samsung/phy-samsung-ufs.h         |  142 ++
 drivers/scsi/ufs/Kconfig                      |   12 +
 drivers/scsi/ufs/Makefile                     |    1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 1289 +++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                 |  284 ++++
 drivers/scsi/ufs/ufshcd.c                     |  126 +-
 drivers/scsi/ufs/ufshcd.h                     |   29 +
 drivers/scsi/ufs/unipro.h                     |   36 +
 16 files changed, 2584 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
 create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h


base-commit: 8f3d9f354286745c751374f5f1fcafee6b3f3136
-- 
2.17.1

