Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD547C7C887
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B17542071C
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="U715yx+2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDZRmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28136 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgDZRmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:07 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200426174204epoutp0140b567dc1e8d2e126ce5dee4315bf2d7~Jb3yOfa1F0140101401epoutp01V
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200426174204epoutp0140b567dc1e8d2e126ce5dee4315bf2d7~Jb3yOfa1F0140101401epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922924;
        bh=REDnVcehytGFohWFIdceGOQoq0NYsHqjhqVHZueRjjo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=U715yx+2rDXp2YVrPm/LSLdyYonxAEm5sLOhYkYhhJtvLTObIyKYHxwWfBQkzNnMg
         O9ictBUtA0E79n6tXN+XhXIBS0WEbXyi+S3NG5j4/aLIfCWFh7ZNmvofta7D9UO0vL
         +Obkqwkvg1irqnMgTu2tIvBaYTC3Zwt7J8ASK8nA=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200426174203epcas5p3da9f71dfac05b2c99f1d8827c278c7a4~Jb3xihXZr2887628876epcas5p3z;
        Sun, 26 Apr 2020 17:42:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.DE.04736.BE7C5AE5; Mon, 27 Apr 2020 02:42:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200426174202epcas5p30e4ebe79a1de0138562219ecd7ea2e18~Jb3wuy0jx0554805548epcas5p3E;
        Sun, 26 Apr 2020 17:42:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200426174202epsmtrp108fd8253b838b394d005ab0b9eaba636~Jb3wt-NJb0798907989epsmtrp1P;
        Sun, 26 Apr 2020 17:42:02 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-f5-5ea5c7eb8d06
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.DC.25866.AE7C5AE5; Mon, 27 Apr 2020 02:42:02 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174200epsmtip12b54082fb55a9eba7c9445ad3d12d472~Jb3uytLih2626126261epsmtip1g;
        Sun, 26 Apr 2020 17:42:00 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 00/10] exynos-ufs: Add support for UFS HCI
Date:   Sun, 26 Apr 2020 23:00:14 +0530
Message-Id: <20200426173024.63069-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfyyUcRze9/11Lzl7O1afTtFuo6iokb02KWPr3fSHtVrNuLrlHebn7vxI
        y1LMr0NUS7iw1mVosXN0TqvzI0aiEtJms1walRalLJG7l+W/5/N5nufzPH98aFyiI6V0TEIy
        r0xQxMkoW6K1y33Pgc+9WvlBY6GMnaxqpdiZpRGKnW98QLLV3YMkOzTUJGLH9c8JVjc1SrLD
        Rg3F3hl6irHqMQPF1vauYOzqE4OI1baMo2Nibri4CON09fkU13z/Cpfd94zgvn98T3DF+nrE
        LeicuVyTGgulw2z9I/m4mFRe6RVw3jZ6tNKAJVVJL5oaGkSZqNSxANnQwPjAtewpUQGypSVM
        OwJTzyhmISTMPIKVFSeBWECgbs8nNhzmD5WkQBgRaAsWcWHIxqBjTE1ZVBSzDybK9NZTjowD
        dC/mIAvGmXcYTNYFW7ADcwSKb9+yagjGFeb081avmPGHn2/6SSHNBRqaTLiw3wp95WZCuOMC
        WS2V1mBg7tLw6GsnJhiC4VdN7XpVB5jt1YsELIWZ6zlrmF7DsVBo9BbWl0Fb1bMuPwqmtxrC
        IsEZd2g0eglR9lD0x4wJTjHk5UgEtStkzY2sO52gVK1eb8xBz+AL0iKXMBFg/hFUgpwrNvWv
        2NS/4n9WDcLr0Q4+SRUfxasOJ3kn8GmeKkW8KiUhyvNCYrwOWT/JI8SAdIMnOhFDI5mdmH6s
        lUtIRaoqPb4TAY3LHMXhyffkEnGkIv0Sr0w8p0yJ41WdyIkmZNvFN8iRcAkTpUjmY3k+iVdu
        sBhtI81EeZqbw80lyw/7y4pOTy6dcit/WZmerPbLk0udc+uml+e9Chuq5WMBeOA4RE47DXRh
        LZzjQNvs3LfA/GaRn2Y1JnPE/DduW1PYyVnD2NVPvuYzLZrRtl0Zr1777Pwd0c6GdkSc3W+e
        ytDv9R1ww5tDBgoq0qiJYJvjdva7g7YsfJERqmjFIQ9cqVL8A45nnW1FAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSnO6r40vjDHrfq1o8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujGuzdzAVzJOqOLB6NXsD40SRLkZODgkBE4knj2azdjFycQgJ7GCUeDPpACtE
        Qlri+sYJ7BC2sMTKf8/ZIYqamCQ2v50ClmAT0Ja4O30LE4gtAlR05FsbI4jNLPCMSeLUw1IQ
        W1jAVqJv2hSwGhYBVYl3Wz6xgdi8AjYSXy+dglomL7F6wwFmiLigxMmZT1i6GDmA5qhLrJ8n
        BDFSXqJ562zmCYz8s5BUzUKomoWkagEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxN
        jOBY0dLawbhn1Qe9Q4xMHIyHGCU4mJVEeGNKFsUJ8aYkVlalFuXHF5XmpBYfYpTmYFES5/06
        a2GckEB6YklqdmpqQWoRTJaJg1OqgclnOaPDFrcDgRNmbHKd/8j3xkflb9oXDug0hn5tmmho
        z9UQYme5fhaXZJKg/69OF7eTnHf+ZBzz9rxp+jZ61Y4rLyab9yue8r167PHuItPZsrnbfm6U
        UGDPLhQ4c+rICR0/vZ//Ob7909St8yzkNFOaMPXTB6HJWtk864rUcoKPPrFeNj13c9Ns1sSF
        2ZyiH8onTF0n7qp2UkxMfvPSfoa7/+7FB9QHH2T+VnH9/dUg/npmkfYKj8wFxlYXrAofbAxL
        uNBtLqjn9jj+QO51bqmoFbWpLn16OiEbZpduOP/ZOmDho/2rfzh8dg8r55oamMqlpB+3WkS2
        bE3+C9u+5/cfWl0zNhYKP7al45jwDCWW4oxEQy3mouJEAJpKkS4EAwAA
X-CMS-MailID: 20200426174202epcas5p30e4ebe79a1de0138562219ecd7ea2e18
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174202epcas5p30e4ebe79a1de0138562219ecd7ea2e18
References: <CGME20200426174202epcas5p30e4ebe79a1de0138562219ecd7ea2e18@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

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

Note: This series is based on Linux-5.7-rc1 (commit: 8f3d9f354286)
*** BLURB HERE ***

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
 drivers/scsi/ufs/unipro.h                     |   33 +
 16 files changed, 2581 insertions(+), 14 deletions(-)
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

