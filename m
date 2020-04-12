Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE03AC2BB85
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8040120708
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QdStt1rP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDLHly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 03:41:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30953 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgDLHly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 03:41:54 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200412074151epoutp0486df3f96d23bed664b12b5bf57e47bcc~FApu6qxNa2483624836epoutp04Z
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 07:41:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200412074151epoutp0486df3f96d23bed664b12b5bf57e47bcc~FApu6qxNa2483624836epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586677311;
        bh=N5C9PGRvGrEXxYHl+c9/OzalapqkBFidqKsfpVmYo0g=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QdStt1rPaK0BKs6TlsWiZQ82+ACBOMFtKimFOeIckeqcDPUI9Kx0awlW53mMfqCR4
         B01czJ2uEu5cXMyiM0m+nZaItEwrdsMkYpC0+GN85UluNwg8Sic+RGzLDgC/y933KB
         ymsuR+Z9/e6RsCuhQWSbzQSJ41JJ8B5lr90h+jsM=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200412074150epcas5p45cb87935223642ec4163598b32dfe43c~FApuTuPtv1693016930epcas5p4v;
        Sun, 12 Apr 2020 07:41:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.91.04736.E36C29E5; Sun, 12 Apr 2020 16:41:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200412074149epcas5p1084ed98b4e0651cd4f671bbe61147073~FApsjEF5P1951719517epcas5p1o;
        Sun, 12 Apr 2020 07:41:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200412074148epsmtrp1805fc83c051cec88b430e4c957b42315~FApsfo4ob1966119661epsmtrp1s;
        Sun, 12 Apr 2020 07:41:48 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-9a-5e92c63eec37
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.3E.04024.C36C29E5; Sun, 12 Apr 2020 16:41:48 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200412074146epsmtip1a1a2b0e09a826752211e1325f88bf1b9~FApqeREfW0407304073epsmtip1E;
        Sun, 12 Apr 2020 07:41:46 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 0/5] exynos-ufs: Add support for UFS HCI
Date:   Sun, 12 Apr 2020 13:01:54 +0530
Message-Id: <20200412073159.37747-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRzGec9tR/PEaSq9ahgMJFTSwowDmYkUnFDIvohkXkYeVObm2Lwj
        Zmne5t0P5QUTyTQ1tDnNptVp3r84yFvTQstFWaGkZV7K0p1Jfvv9n//z8PxfeElUrMOdyXhF
        EqdSSBMkhC3WM+DuftJ/uDLylGbGl1mo7yGYpc0pglnteIgz9wfHccZo7BQxJt0QxmgXp3Fm
        Ql9HMPeMLxBGM9NLMM0jOwjzt79XxDR1m0AAxU6UliCstrWQYLse3GRzx15i7PePsxhbqmsF
        7JrWlc3nNUgIec3WL4ZLiE/hVN7+0bZxmrVmVFnmmMbP9+DZoJEuAjYkpM/At9nP8CJgS4rp
        PgDXs7dEwrAKoGGnChWGdQD7f8xi+5Ha5Tqr6zmAX/s0VlcuAucrTMiei6A94bu7Ogs70EFw
        hTdaSlC6HoGNH4otC3v6HMwZbxftMUa7wYUZs4Up2g+OlM4Doe44bOvkUUE/AseqzZYz0F09
        p7vW0gzpNQI+qrhFCIGLsHBj1cr28MuITiSwM1wqy9tlcpdlsFjvI8iZsKl+2Pq0C5CfrMP2
        LCjtDjv03kLVYViybUaEJAUL8sSC2w3mLE9Zky6wQqPBBQsL56osFjEdAVc6TEg5cK05cH/N
        gftr/nc1ALQVOHFKtTyWU/sqfRRcqpdaKlcnK2K9biTKtcDylzyCeoF2PNgAaBJI7Ch+uiJS
        jEtT1OlyA4AkKnGgzKm7EhUjTc/gVIlRquQETm0ALiQmOUpV4lPXxXSsNImTcZySU+1vEdLG
        ORscqq46FrCl5Hm//EDfridvapx2OmaMoU/vpPQwl2Tn+ZXFNHm4/fR7WUuCgjLU3978nfor
        enhDMRDW4BueHBg2Ohf1qpXVf/vp1P36T8jnTM8s086VT3bB1GDi5Yzy0bYssSMd4Tdklmw/
        btFONqVMnGgvV1wrkMY3XI0LPbvhKMHUcdLTHqhKLf0HHisu60cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSnK7NsUlxBvv3G1s8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujO7Py5kL+kUrDtzfxtrAuEigi5GTQ0LARGL2uznsXYxcHEICuxklLp86zASR
        kJa4vnECO4QtLLHy33OooiYmiZbnH8ESbALaEnenbwFrEBHwl/jz/RhYEbPAKiaJzt6zjCAJ
        YQFrieZza8AaWARUJR5cfwJm8wrYSBzvu88IsUFeYvWGA8wQcUGJkzOfsHQxcgANUpdYP08I
        JMwMVNK8dTbzBEb+WUiqZiFUzUJStYCReRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4m
        RnC0aGnuYLy8JP4QowAHoxIP74FrE+OEWBPLiitzDzFKcDArifA+KQcK8aYkVlalFuXHF5Xm
        pBYfYpTmYFES532adyxSSCA9sSQ1OzW1ILUIJsvEwSnVwKibKW9wqN21KXOGTfWuHpPj/BNz
        PN3UVkYW+NbGmO3hknPacKJ229siG8vSs3d8mhJUwtkv9HtuFjnx9PLUT08n7nU/ZdaQpO26
        MEP0u9MZ7UdpHFNcGVveNc+d9kAsOX5ZxYc1JkFy2U+X5rn8nrJ8oZdF4LGT0qatPil1YjEM
        65Yw7/VYocRSnJFoqMVcVJwIANUTaqGSAgAA
X-CMS-MailID: 20200412074149epcas5p1084ed98b4e0651cd4f671bbe61147073
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200412074149epcas5p1084ed98b4e0651cd4f671bbe61147073
References: <CGME20200412074149epcas5p1084ed98b4e0651cd4f671bbe61147073@epcas5p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

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

 
patch 1/5: define devicetree bindings for UFS PHY
patch 2/5: Adds UFS PHY driver
patch 3/5: define devicetree bindings for UFS HCI 
patch 4/5: Adds Samsung UFS HCI driver
patch 5/5: Enabled UFS on exynos7 platform

Note: This series is based on Linux-5.6 (commit: 7111951b8d49)

Alim Akhtar (5):
  dt-bindings: phy: Document Samsung UFS PHY bindings
  phy: samsung-ufs: add UFS PHY driver for samsung SoC
  dt-bindings: ufs: Add DT binding documentation for ufs
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

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
 drivers/scsi/ufs/ufs-exynos.c                 | 1288 +++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                 |  284 ++++
 drivers/scsi/ufs/unipro.h                     |   36 +
 14 files changed, 2440 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
 create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
 create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h


base-commit: 7111951b8d4973bda27ff663f2cf18b663d15b48
-- 
2.17.1

