Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1EFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E11E20659
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uzEqmuQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgENAw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:52:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45922 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgENAw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:52:56 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200514005252epoutp02238086e9c69202bebcb27834657173e3~OvtyLiDCF1745417454epoutp029
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:52:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200514005252epoutp02238086e9c69202bebcb27834657173e3~OvtyLiDCF1745417454epoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417572;
        bh=GhMRsS1h/gD9h5aE/zmh63UKJ+NWU3Qir1xA7Z3zSwY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=uzEqmuQXjutqfckyyXJzN7DP+tG/y6AaXKCQvvaxinL+AGN/vjONY+dARfQR4h1Rf
         mKbLiWArUKpASFX+T7Is8m3CL9cTsDzorIpIxaqRzWZIcf7YGqzcyhOOjd4e/lV8Ht
         S0vh5ekZOFnPLk8iVFa5g68yl4+q00n3PV4RundM=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200514005252epcas5p47992066d410ead3bcfbfb70f7dad3000~OvtxqEXLj1638216382epcas5p4k;
        Thu, 14 May 2020 00:52:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.45.10010.4669CBE5; Thu, 14 May 2020 09:52:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200514005251epcas5p39ff05e1b6f4f8735f1516fbb670d6810~OvtxN7VTu1578415784epcas5p3a;
        Thu, 14 May 2020 00:52:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200514005251epsmtrp289194194f5f358b119e5dd00d2367c7a~OvtxNChb91517815178epsmtrp2L;
        Thu, 14 May 2020 00:52:51 +0000 (GMT)
X-AuditID: b6c32a49-71fff7000000271a-e8-5ebc9664b9b9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.C3.18461.3669CBE5; Thu, 14 May 2020 09:52:51 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005249epsmtip247c895e5b14e5827c766988a33db237b~OvtvTC5tu2487624876epsmtip2j;
        Thu, 14 May 2020 00:52:49 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 00/10] exynos-ufs: Add support for UFS HCI
Date:   Thu, 14 May 2020 06:09:04 +0530
Message-Id: <20200514003914.26052-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsWy7bCmlm7KtD1xBodPCVk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujIO9bxgLWmQqPrRvZW5gPCbaxcjJISFgIvHp3mmWLkYuDiGB3YwSW9+9h3I+
        MUrsm/EcyvnGKPHm9XY2mJbPz9ugEnsZJRp+vmeGcFqYJLo/3WQHqWIT0Ja4O30LE4gtIiAs
        ceRbGyOIzSxwg0niwUoXEFtYwFZizpupLCA2i4CqxL9Pr5lBbF4BG4nHx09CbZOXWL3hAFRc
        UOLkzCcsEHPkJZq3zgZbLCEwl0Ni2tkPLBANLhInp/yDahaWeHV8CzuELSXx+d1eoDgHkJ0t
        0bPLGCJcI7F03jGoVnuJA1fmsICUMAtoSqzfpQ+xik+i9/cTJohOXomONiGIalWJ5ndXoTql
        JSZ2d7NClHhIrLkODl0hgViJvX/Wsk5glJuF5P5ZSO6fhbBrASPzKkbJ1ILi3PTUYtMCw7zU
        cr3ixNzi0rx0veT83E2M4KSk5bmD8e6DD3qHGJk4GA8xSnAwK4nw+q3fHSfEm5JYWZValB9f
        VJqTWnyIUZqDRUmc93TaljghgfTEktTs1NSC1CKYLBMHp1QDk8aZC1/a3TkV593UdLFf+Xdn
        41+fHFl73R/+m/SZ89y/6vlUi6bFaelbLLjSWStemZpqFLTzwHSpSnfnUxuXhr9r75FZmSSW
        FqxTHjjttcPryb7Fnl+S+bY9e9H9raHxfnDKwf+9LxtXbe22qb1v1xVhfbBl8xL2u3qfj/Oy
        cbryFNn3tVyusS514dASFo9O/TtX+8O7zQVz76wve/aNv2Buy+GrblM2TF22W0jldPmWVWcj
        cw9+KhKVCMwriGQ/Zp7aG70lu9zo5rGXf/Ivrpv9cZ0fn9FXO6kjX+y9fnxY27LOuvyqWE/z
        45f918OWr8mzeDHnf2TfrPMvpI8sL5mpnG38dWlX/KyKpxlHlFiKMxINtZiLihMBXukWdbkD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSvG7ytD1xBqsmG1o8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujIO9bxgLWmQqPrRvZW5gPCbaxcjJISFgIvH5eRtLFyMXh5DAbkaJh183sEAk
        pCWub5zADmELS6z895wdoqiJSeJZyzc2kASbgLbE3elbmEBsEaCiI9/aGEFsZoFnTBKnHpaC
        2MICthJz3kwFG8oioCrx79NrZhCbV8BG4vHxk2wQC+QlVm84ABUXlDg58wlQPQfQHHWJ9fOE
        IEbKSzRvnc08gZF/FpKqWQhVs5BULWBkXsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJ
        ERwrWpo7GLev+qB3iJGJg/EQowQHs5IIr9/63XFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW8U
        LowTEkhPLEnNTk0tSC2CyTJxcEo1MLHamJ7/8Fgq/ejxH+7vtt+OUnPaG3BBoi3nnYdWw6wL
        +Z/V370/um25id+s9I/dSXvUj0xszon3bIhY2Lxv17zEf5qrP0ZN3MNv+j3p1I17Bje081bt
        jN91dJpA/8M/ekqflPdrTHdKTp5VU31rt8b2NHVZV47oNtaHCkZ7TDhbrnT9LbsbEL+nz8hw
        RfrWxbMbMqo97Fjc5j5zvpI5OZOP+1DHHIYT5l7h4VenXOP8n630sHjGs1ef3zBuOKLa/7Wb
        6b1a0sZIk3erHLlijGczPnrtxqt1lPvw3k922SvktrfU73PepO/qXrfAW/6ED+/d+348CopL
        UtbGpgntFb1VPjNvxuEyRiXmn186uJVYijMSDbWYi4oTAb6u2sEEAwAA
X-CMS-MailID: 20200514005251epcas5p39ff05e1b6f4f8735f1516fbb670d6810
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005251epcas5p39ff05e1b6f4f8735f1516fbb670d6810
References: <CGME20200514005251epcas5p39ff05e1b6f4f8735f1516fbb670d6810@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

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
  dt-bindings: ufs: Add DT binding documentation for ufs
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

Kiwoong Kim (1):
  scsi: ufs: add quirk to fix abnormal ocs fatal error

 .../bindings/phy/samsung,ufs-phy.yaml         |   75 +
 .../bindings/ufs/samsung,exynos-ufs.yaml      |   91 ++
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
 16 files changed, 2598 insertions(+), 14 deletions(-)
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

