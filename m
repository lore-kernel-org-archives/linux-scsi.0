Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A474C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19B522078E
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NU2bYzBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFMDEm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:04:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42694 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgFMDEl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:41 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200613030439epoutp0450724bb38b65a917f96278f8abb0d5b1~X_3ZaynRP2440824408epoutp04d
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200613030439epoutp0450724bb38b65a917f96278f8abb0d5b1~X_3ZaynRP2440824408epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017479;
        bh=EJQ586JopX9Nh+Jh0icLV762x4EESw3HLRqH83Yavmg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=NU2bYzBpdPun7FHMTrrwx7KlyL5qSUMLxe1BbkzRa03zb+qgd070b4tbXwh30RBGB
         dsAeeG7GZ9oXNlTMXfzQ51UITvKZOI6PlO3NSo/sPdD6FGoHufT2s2SnnTcK+iuiT7
         tMNLHAkCJdKdAHEE8eSmPd6AtP4Ogogc1c9mqx54=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200613030438epcas5p1818b0bde3976ae3c606df922f2bc7175~X_3YfchpN1950619506epcas5p13;
        Sat, 13 Jun 2020 03:04:38 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.43.09475.54244EE5; Sat, 13 Jun 2020 12:04:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200613030436epcas5p38137bcaddd80ec5eed746a80a1fe31f5~X_3XNRevZ2268422684epcas5p3F;
        Sat, 13 Jun 2020 03:04:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030436epsmtrp2ecb3e27c31e5bbb1c2b9027b1d2ca687~X_3XJ0SBz2362123621epsmtrp2r;
        Sat, 13 Jun 2020 03:04:36 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-b1-5ee4424564ef
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.B4.08303.44244EE5; Sat, 13 Jun 2020 12:04:36 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030434epsmtip20bce7376305d84be447eda83dd85cdeb~X_3VMoJKF0568705687epsmtip2S;
        Sat, 13 Jun 2020 03:04:34 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Sat, 13 Jun 2020 08:16:56 +0530
Message-Id: <20200613024706.27975-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsWy7bCmhq6r05M4g0cTLC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mr4fqeLseCvTMW5K89ZGxgXi3UxcnBICJhIvL3u18XIxSEk
        sJtR4tj9xYwQzidGiYNLjjJDOJ8ZJS6d/MEG03F5jgFEfBejxIPvz6CKWpgk5nesAmrn5GAT
        0Ja4O30LE4gtIiAsceRbG1icWeAlk8SuRwUgtrCAq8T5U6vYQWwWAVWJ46+Ogdm8AjYSs5a+
        ZwaxJQTkJVZvOMAMEReUODnzCQvEHHmJ5q2zoWq2cEjMvlwNYbtIXDo3jRHCFpZ4dXwLO4Qt
        JfH53V6oB7IlenYZQ4RrJJbOO8YCYdtLHLgyhwWkhFlAU2L9Ln2ITXwSvb+fMEF08kp0tAlB
        VKtKNL+7CtUpLTGxu5sVosRD4t1eCZCwkECsxJfN39kmMMrNQnL+LCTnz0LYtYCReRWjZGpB
        cW56arFpgXFearlecWJucWleul5yfu4mRnCK0vLewfjowQe9Q4xMHIyHGCU4mJVEeAXFH8YJ
        8aYkVlalFuXHF5XmpBYfYpTmYFES51X6cSZOSCA9sSQ1OzW1ILUIJsvEwSnVwLQ/aa3DdhGb
        dn3zeLb5pyxtZFt6rdfduujVkct0JXjiUpk3EbcWFKzY+vjiya3ib4XyOu+df2Kl5jlV1ubq
        k88qy9zmxIXq9d1c8C60e9k25tmT6x+yMBXcP1QZ+uFPkIXiEWl5nhi9/xOirwhpJbLauj37
        c8hZYYfIvueiDt0hV/p2z7F+XPpupwe7htUTvodSs6L6VsyUjLjZ0ambWyF5+gjPo3TF1yUK
        AZcDfK4Kf7LYytP0MrmgTvai5ZH5E9RCDusfcbQ5Ym7Cx8S9dV7izDcRtrn3+40yetlDn/Lx
        +DYKxAglb/JRkV3J+fpI/uX1bIH8qn9Y/vZXzDZNn8d+dRGveHqCTGemiN01JZbijERDLeai
        4kQAXrwTrsADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSvK6L05M4gxVz5SwezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mr4fqeLseCvTMW5K89ZGxgXi3UxcnBICJhIXJ5j0MXIxSEk
        sINR4u3CFcxdjJxAcWmJ6xsnsEPYwhIr/z0Hs4UEmpgknswKALHZBLQl7k7fwgRiiwDVHPnW
        xggyiFngO5PEgQkTwAYJC7hKnD+1CqyZRUBV4virY2A2r4CNxKyl76GWyUus3nCAGSIuKHFy
        5hMWkOOYBdQl1s8TAgkzA5U0b53NPIGRfxaSqlkIVbOQVC1gZF7FKJlaUJybnltsWGCUl1qu
        V5yYW1yal66XnJ+7iREcPVpaOxj3rPqgd4iRiYPxEKMEB7OSCK+g+MM4Id6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rxfZy2MExJITyxJzU5NLUgtgskycXBKNTApBkwQPRxQqcDI8rZN4NhPFy0r
        i6ub41TXL911y/XvtNSDG7/tnGVnJ7Yqu3CDx9tZU7sm3pjK9XDVJd3G9PVRJ2pW115jmu6z
        dfmuE2wxnlIetnNOt/3XXrvx08cDm859nnvV9or3bGP+tZs1AiO+uy7zaAjxzNT/4uLvqfTu
        bv9Hw6nKlssWGQa7h6yK2LK9vuG//W1duT6e2K1PWkucS5nXBEetWVmVenHtN94deRy82jcU
        kj97Nzw1mZR2zZLB+pPTpvTblycGvfW99XXfpuyJKxbd5j/3OKNV0f3nuoPrmg8e1Fze6aas
        +2r6/6hbr+RljSb27LarlJp4aXZIVlX99FCO5V1mLSvsp/z8rsRSnJFoqMVcVJwIAHomHfcN
        AwAA
X-CMS-MailID: 20200613030436epcas5p38137bcaddd80ec5eed746a80a1fe31f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030436epcas5p38137bcaddd80ec5eed746a80a1fe31f5
References: <CGME20200613030436epcas5p38137bcaddd80ec5eed746a80a1fe31f5@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

- Changes since v9
* fixed the review comments by Rob on ufs dt bindings
* Addeded Rob's reviwed-by tag on 08/10 patch

- Changes since v8
* fixed make dt_binding_check error as pointed by Rob
* Addressed review comments from Randy Dunlap

- Changes since v7:
* fixed review comments from Rob and Kishon
* Addeded reviwed-by tags
* rebased on top of v5.7-rc4
 
- Changes since v6:
* Addressed review comments from Avri and Christoph
* Added Reviewed-by tags of Avri and Can on various patches

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

Note: This series is based on Linux-5.7-rc4 (commit: 0e698dfa2822)

Alim Akhtar (9):
  scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr
  scsi: ufs: add quirk to disallow reset of interrupt aggregation
  scsi: ufs: add quirk to enable host controller without hce
  scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
  dt-bindings: phy: Document Samsung UFS PHY bindings
  phy: samsung-ufs: add UFS PHY driver for samsung SoC
  dt-bindings: ufs: Add bindings for Samsung ufs host
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

Kiwoong Kim (1):
  scsi: ufs: add quirk to fix abnormal ocs fatal error

 .../bindings/phy/samsung,ufs-phy.yaml         |   75 +
 .../bindings/ufs/samsung,exynos-ufs.yaml      |   89 ++
 .../boot/dts/exynos/exynos7-espresso.dts      |    4 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi       |   43 +-
 drivers/phy/samsung/Kconfig                   |    9 +
 drivers/phy/samsung/Makefile                  |    1 +
 drivers/phy/samsung/phy-exynos7-ufs.h         |   86 ++
 drivers/phy/samsung/phy-samsung-ufs.c         |  380 +++++
 drivers/phy/samsung/phy-samsung-ufs.h         |  143 ++
 drivers/scsi/ufs/Kconfig                      |   12 +
 drivers/scsi/ufs/Makefile                     |    1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 1292 +++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                 |  287 ++++
 drivers/scsi/ufs/ufshcd.c                     |  126 +-
 drivers/scsi/ufs/ufshcd.h                     |   29 +
 drivers/scsi/ufs/unipro.h                     |   33 +
 16 files changed, 2596 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
 create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h


base-commit: 0e698dfa282211e414076f9dc7e83c1c288314fd
-- 
2.17.1

