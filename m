Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E1DC54E8B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F7B5206D9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:13:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SNQkpwmA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgEKCNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:13:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36167 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgEKCNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:13:52 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200511021348epoutp0194511ceb1a17eb2b11d81c9e5c712238~N14l3Sc4_2361723617epoutp01o
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:13:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200511021348epoutp0194511ceb1a17eb2b11d81c9e5c712238~N14l3Sc4_2361723617epoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163228;
        bh=59ChBBALtCV0OHCYik7G7Vhyml1OCuFRXmuIWrOExQs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=SNQkpwmA8V++2sFwgeiwUYAplzrpWGDeh3FQtrQ95hDh445591WF3QPQUlKAws0gw
         APYRp8yiyD6S2QsOGQFfw2jllf/95y2mLsKOf2jWF75Z1GavwWc2Vt1ixo0W6mPjec
         AH21QUntro08jLyciqFbwMMEnlngfVmzwzlVkOeY=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200511021348epcas5p23c5901997f4574164ff2f0a649e77a70~N14lXY3EI1832818328epcas5p2i;
        Mon, 11 May 2020 02:13:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.9E.23569.CD4B8BE5; Mon, 11 May 2020 11:13:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021347epcas5p2ebef1a4c4aecac26dde73c5d0cc88455~N14kil1wW1832818328epcas5p2f;
        Mon, 11 May 2020 02:13:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511021347epsmtrp2d1aac297e091258d60438fd021f27dda~N14khJ4Ej1467414674epsmtrp2L;
        Mon, 11 May 2020 02:13:47 +0000 (GMT)
X-AuditID: b6c32a4a-3c7ff70000005c11-dd-5eb8b4dc08b0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.E6.18461.BD4B8BE5; Mon, 11 May 2020 11:13:47 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021345epsmtip26537285c1e7c299a73d8e33304b6657d~N14if_74I3210532105epsmtip2i;
        Mon, 11 May 2020 02:13:45 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 00/10] exynos-ufs: Add support for UFS HCI
Date:   Mon, 11 May 2020 07:30:21 +0530
Message-Id: <20200511020031.25730-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsWy7bCmpu6dLTviDFb1CFs8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujFn7DrIWdEhXrG5cxN7A+Fiki5GTQ0LAROL97YusXYxcHEICuxklbncdYIJw
        PjFKXHt5HirzjVHiU+NTJpiW47MnQ1XtZZTonfYJymlhkrh54BQjSBWbgLbE3elbwDpEBIQl
        jnxrA4szC9xgkniw0gXEFhawleg69JUFxGYRUJX4tPc6excjBwevgI1E1y8NiGXyEqs3HGAG
        sXkFBCVOznzCAjFGXqJ562xmkL0SAgs5JF5M+cMO0eAi8eT5WWYIW1ji1fEtUHEpic/v9rKB
        zJcQyJbo2WUMEa6RWDrvGAuEbS9x4MocFpASZgFNifW79CFW8Un0/n7CBNHJK9HRJgRRrSrR
        /O4qVKe0xMTublYI20Ni0vsvYHEhgViJ4xduM09glJuF5IFZSB6YhbBsASPzKkbJ1ILi3PTU
        YtMCo7zUcr3ixNzi0rx0veT83E2M4KSk5bWD8eGDD3qHGJk4GA8xSnAwK4nwLs/dESfEm5JY
        WZValB9fVJqTWnyIUZqDRUmcN6lxS5yQQHpiSWp2ampBahFMlomDU6qBSe6Wxn3nqNiNf934
        eCVP3m+8oq32/fGz5qdqc7MiJ329eXm379n5+Tz/xN98k4tyPlnl7he01fWeoxej3o9PS8L8
        zn74zzLN+e2LNStr7v+Ke/XDWlj8ievjPXo7Wj+KmUQHHXDlKz7l8WPJ97uMORdtRVRn6WWq
        Fu2ffmJjPLd6VK7ZChcBufkHT/k135LOi//Ucrhtmp6QfDQnt+5lMS/V8EB7x/siW981xu1c
        z9RUv6bs1QLzL7zvEzbuOPph4rHUC7oaKf+Ofe2ez/RJZ98r70yzkzMTuysPXY1iEHljd7DG
        +pxYv06e7ZP2bU4t6av3fDTfmn9hOneAEctJHqUMUycDTwlhnl2qGz82KrEUZyQaajEXFScC
        AJ+VZYm5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWy7bCSvO7tLTviDGZPFLd4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGbP2HWQt6JCuWN24iL2B8bFIFyMnh4SAicTx2ZOZuhi5OIQEdjNKLJjzmgUi
        IS1xfeMEdghbWGLlv+fsEEVNTBJ35i0GS7AJaEvcnb6FCcQWASo68q2NEcRmFnjGJHHqYSmI
        LSxgK9F16CvYUBYBVYlPe68D9XJw8ArYSHT90oCYLy+xesMBZhCbV0BQ4uTMJywgJcwC6hLr
        5wlBTJSXaN46m3kCI/8sJFWzEKpmIalawMi8ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/
        dxMjOFK0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHe5bk74oR4UxIrq1KL8uOLSnNSiw8xSnOwKInz
        3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpgspBh0g3f1pf1WfLZ4RgXMWc15TC972nhnxsM74rm
        NDVq5ZakX9H/Zhf6h0Mu/NO+NXl3Fvb/3eBXero1Nd7779eUQ9Vcv/8ZNf2UTiu1OHK5+2L7
        nz37tgkdfVC+wJLfcvkuH+EbhYVasjwnes2nnVrZr9+qsU25e8mEk6FJZ4RPttqVhRjUCqxT
        W7pmRozfPPOVu/demb3rh7rtQ9te2bOCh9x6i3Y92vHl+8tFZqqrDlQ5tR+8tor/9wnOhf+K
        +qWXn+CRfvF8Y5Kt4du/TrELp54QnTIxTnZTqv4bvQlfzpjrfedWPuj099dCm02zOvtZZNtq
        Ps97d/ZIqNt8v8S50hUTUucefl997qzbNCWW4oxEQy3mouJEAN1kQxEDAwAA
X-CMS-MailID: 20200511021347epcas5p2ebef1a4c4aecac26dde73c5d0cc88455
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021347epcas5p2ebef1a4c4aecac26dde73c5d0cc88455
References: <CGME20200511021347epcas5p2ebef1a4c4aecac26dde73c5d0cc88455@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

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
  dt-bindings: ufs: Add DT binding documentation for ufs
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

Kiwoong Kim (1):
  scsi: ufs: add quirk to fix abnormal ocs fatal error

 .../bindings/phy/samsung,ufs-phy.yaml         |   75 +
 .../bindings/ufs/samsung,exynos-ufs.yaml      |   92 ++
 .../boot/dts/exynos/exynos7-espresso.dts      |    4 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi       |   44 +-
 drivers/phy/samsung/Kconfig                   |    9 +
 drivers/phy/samsung/Makefile                  |    1 +
 drivers/phy/samsung/phy-exynos7-ufs.h         |   86 ++
 drivers/phy/samsung/phy-samsung-ufs.c         |  380 +++++
 drivers/phy/samsung/phy-samsung-ufs.h         |  143 ++
 drivers/scsi/ufs/Kconfig                      |   12 +
 drivers/scsi/ufs/Makefile                     |    1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 1300 +++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                 |  284 ++++
 drivers/scsi/ufs/ufshcd.c                     |  126 +-
 drivers/scsi/ufs/ufshcd.h                     |   29 +
 drivers/scsi/ufs/unipro.h                     |   33 +
 16 files changed, 2605 insertions(+), 14 deletions(-)
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

