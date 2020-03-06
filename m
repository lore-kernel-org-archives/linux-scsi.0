Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81B6C10F00
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB9D208CD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AS4v03cV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCFPKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:10:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63800 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgCFPKY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2020 10:10:24 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200306151022epoutp0363e46d3d486e92d138b01e9f6159b6a7~5v5xM0xHU2732727327epoutp03H
        for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2020 15:10:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200306151022epoutp0363e46d3d486e92d138b01e9f6159b6a7~5v5xM0xHU2732727327epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583507422;
        bh=uZZ7YMGvTZRCBfymZO5uf3+qMA26KxVB4cbQ7MD8XTg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=AS4v03cVWcDphXY14tyErq6uvPBGCMMp2CK6d2AiaboboDrf9mrC+OKooIh7BCbJR
         Ju5XuUufSKL8iJ5gZwtxMjoE8yXhS90MaHtBB+i1ae7LI61oWSB3R+N2KGkHG53XwG
         Ct1hXU2rMRKre6093xB9MsyyG19DCg9ghaSSHFXY=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200306151020epcas5p1cdeebb64c416abba4b23f683038e8ccd~5v5wDi3aw1616316163epcas5p1f;
        Fri,  6 Mar 2020 15:10:20 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.C5.19726.CD7626E5; Sat,  7 Mar 2020 00:10:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d~5v5vBr7Rx2723827238epcas5p1F;
        Fri,  6 Mar 2020 15:10:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200306151019epsmtrp109305974815c97b2cb5e26fe1ba7341c~5v5vA9Qx60147001470epsmtrp1i;
        Fri,  6 Mar 2020 15:10:19 +0000 (GMT)
X-AuditID: b6c32a49-7c1ff70000014d0e-cf-5e6267dcd801
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.22.10238.BD7626E5; Sat,  7 Mar 2020 00:10:19 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200306151018epsmtip1e24f5bd6ebac6381e4c212d4e39d5cf1~5v5tkT_EC0257102571epsmtip1D;
        Fri,  6 Mar 2020 15:10:17 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 0/5] exynos-ufs: Add support for UFS HCI
Date:   Fri,  6 Mar 2020 20:35:24 +0530
Message-Id: <20200306150529.3370-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWy7bCmhu6d9KQ4g1OHdCwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsei+voPNYvnxf0wWrXuPsFss3XqT0YHL43JfL5PHplWd
        bB4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFsEdx2aSk5mSWpRbp2yVwZTxb9oSxYKJQxYUP
        F5gaGJ/zdjFyckgImEgs6F3A2MXIxSEksJtR4uu1n8wgCSGBT4wSUx5DJb4xSiyY8ooRpmPj
        hKPMEIm9jBIf19xjg+hoYZL4/UsVxGYT0Ja4O30LE4gtIhAgcen9QTaQBmaBrYwSrdeWsIMk
        hAUsJH7PeMcCYrMIqEpcaD4CNohXwFpiXvdlFoht8hKrNxxghrDXsEm8P2ECYbtIrHzUBHWR
        sMSr41vYIWwpiZf9bUA2B5CdLdGzyxgiXCOxdN4xqJH2EgeuzGEBKWEW0JRYv0sfJMwswCfR
        +/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u1khbA+Jo6+/QcMqVmLlnBOMExhlZiEMXcDIuIpR
        MrWgODc9tdi0wDAvtVyvODG3uDQvXS85P3cTIzgZaHnuYJx1zucQowAHoxIPr4N1UpwQa2JZ
        cWXuIUYJDmYlEV5h0/g4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4ryTWK/GCAmkJ5akZqemFqQW
        wWSZODilGhhXSN30KmdyjVnYUuPJsdBHJnbS8Rg/d+08z+3WP0QDfi1+v3XHWrMTMkF9Yddr
        DCfmzOWRb5+vfdnG4AbX1TXHZzofkVk/f375xodr5ne3nmifwtXPJanRuF3sUOUrxQc19+7k
        /FFmeX0m1YkxP3nTv4N1Cr9FeRM6WJ1SpEK2TDxu+9PuwHYlluKMREMt5qLiRAA++41xAgMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsWy7bCSnO7t9KQ4g2WLVS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsei+voPNYvnxf0wWrXuPsFss3XqT0YHL43JfL5PHplWd
        bB4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFsEdx2aSk5mSWpRbp2yVwZTxb9oSxYKJQxYUP
        F5gaGJ/zdjFyckgImEhsnHCUuYuRi0NIYDejRN+UX0wQCWmJ6xsnsEPYwhIr/z1nhyhqYpK4
        t/4VC0iCTUBb4u70LWANIgJBEvfWrGUFKWIW2MsosfnoMVaQhLCAhcTvGe/AGlgEVCUuNB9h
        A7F5Bawl5nVfZoHYIC+xesMB5gmMPAsYGVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+du
        YgSHnpbmDsbLS+IPMQpwMCrx8M6wTYoTYk0sK67MPcQowcGsJMIrbBofJ8SbklhZlVqUH19U
        mpNafIhRmoNFSZz3ad6xSCGB9MSS1OzU1ILUIpgsEwenVAOjulWA3fR1+2WYteL3SN3jjz3y
        qyRsptuV+uVHc0PX37g45ecqtdvuGvGCeXusRO2u5/kqVcn+r5KcslLekDMuw4eFMYbTOPTq
        rTO9HFV7Z589a/GtcqL09/ZtFd6TPv+O7WGvtbmyxCtSkn/5ZRGh6omm55bslj/ZEjk1Uapa
        UCYgyvpiV7sSS3FGoqEWc1FxIgAusmt4OQIAAA==
X-CMS-MailID: 20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d
References: <CGME20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

patch 1/5: define devicetree bindings for UFS PHY
patch 2/5: Adds UFS PHY driver
patch 3/5: define devicetree bindings for UFS HCI 
patch 4/5: Adds Samsung UFS HCI driver
patch 5/5: Enabled UFS on exynos7 platform

Note: This series is based on Linux-5.6-rc2 
      In past there was couple of attempt to upstream this driver, but
      it didn't went upstream for some or other reason.

Alim Akhtar (5):
  dt-bindings: phy: Document Samsung UFS PHY bindings
  phy: samsung-ufs: add UFS PHY driver for samsung SoC
  Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
    controller
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

 .../bindings/phy/samsung,ufs-phy.yaml         |   60 +
 .../devicetree/bindings/ufs/ufs-exynos.txt    |  104 ++
 .../boot/dts/exynos/exynos7-espresso.dts      |   16 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi       |   56 +-
 drivers/phy/samsung/Kconfig                   |    9 +
 drivers/phy/samsung/Makefile                  |    1 +
 drivers/phy/samsung/phy-exynos7-ufs.h         |   85 +
 drivers/phy/samsung/phy-samsung-ufs.c         |  311 ++++
 drivers/phy/samsung/phy-samsung-ufs.h         |  100 ++
 drivers/scsi/ufs/Kconfig                      |   12 +
 drivers/scsi/ufs/Makefile                     |    1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 1399 +++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                 |  268 ++++
 drivers/scsi/ufs/unipro.h                     |   41 +
 include/linux/phy/phy-samsung-ufs.h           |   70 +
 15 files changed, 2531 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
 create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h
 create mode 100644 include/linux/phy/phy-samsung-ufs.h

-- 
2.17.1

