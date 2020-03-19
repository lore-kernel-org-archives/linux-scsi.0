Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4660FC4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D2DB2173E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BO4064hm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgCSPHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 11:07:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17249 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgCSPHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 11:07:05 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200319150702epoutp012184525d7655e2b8c5246a5a5b8d5f97~9vPlV4rOT2871328713epoutp01i
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 15:07:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200319150702epoutp012184525d7655e2b8c5246a5a5b8d5f97~9vPlV4rOT2871328713epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584630423;
        bh=Db/l7TgRCAf7yPHcvp6MbGe95jhhHvRJO7iIkGmuizw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=BO4064hmg96rirWcXhBXtoVDHKbo6IUWBIxcuIDzcVtQNVJmOcC9ML0L4m3sR0h45
         8lzHbUV320KjBcC8qBmgrd67qBuQ1wW26a+6FUKq9RTabaazFlvB7K234Qyb86b6EL
         1tSNjxrZkeBbqBhT9D2FDtB910XFLTj+UJ9m9PCg=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200319150701epcas5p42416a4ff1ae29c796a0afc955e7eaaf7~9vPkNjo1T0491704917epcas5p4b;
        Thu, 19 Mar 2020 15:07:01 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.26.04778.59A837E5; Fri, 20 Mar 2020 00:07:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec~9vPjwYdmC0723307233epcas5p4O;
        Thu, 19 Mar 2020 15:07:01 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200319150701epsmtrp1c0135e38d868f25a85d3c0bca40f4ee2~9vPjvA-Wv0357603576epsmtrp1a;
        Thu, 19 Mar 2020 15:07:01 +0000 (GMT)
X-AuditID: b6c32a4a-353ff700000012aa-c6-5e738a9599de
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.C7.04158.59A837E5; Fri, 20 Mar 2020 00:07:01 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150659epsmtip2e1b62c49812e77d05a99f98f52c173fb~9vPh9pLdm0607506075epsmtip2F;
        Thu, 19 Mar 2020 15:06:59 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 0/5] exynos-ufs: Add support for UFS HCI
Date:   Thu, 19 Mar 2020 20:30:26 +0530
Message-Id: <20200319150031.11024-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSe0hTURzHOfe162hymUKnGRUDgy18ldI1LSMKLtUfQn8lZV30Nk03x66u
        lEArXel89PbBnCtSlxmaLRmaz1ai+SBNQ5cplYqJyhRMkTTnVfrvw/f7+5zzO3BIVHoLl5Hx
        mmROp2ET5YQYq3+vUPg9zuGjA40TSnrcXE/Q0yuDBL1QU4HTZY5enO7rqxXRw7YPGF33cwin
        BxpMBF3U14zQxq92gq7sWEPorCaHiC5/OwyOS5iB/DyEqavKJpg3z9OZzM4WjHFNjGBMvq0K
        MIt1e5g7rUYkkowSh8dyifF6Thdw7LI4zpKXgWtLvK5/6i7DM4DTMwd4kJAKhv1OlygHiEkp
        1QhgT8uMyF1IqQUAS6ZihGIJwO+FY8i2UTD+AhGKJgCX/4xtGZkIvFkM3UxQB+BooW1T8KYi
        Yf98G+EWUMqMwGc/cjcLLyoMzjxpxNyMUb7Q8M6MullChcOWqixcuG0vfFnbigrsIOCrkasC
        n4RrU7lAYC/4u8MmElgGpwsMG0xucALMbTgkxDdgufkjJnAEbP1iwtwjKKWANQ0B7hilPGHe
        6i9EMCXwrkEqTPvC23ODW6YPvG80bi3GQMfDqa2XX4TNtmnsHthd8v9QCwBVYBen5dUqjg/R
        HtRw1/x5Vs2naFT+MUnqOrD5M5Sn7aCi92w7oEgg3yEpMvDRUpzV86nqdgBJVO4t8VNtRJJY
        NjWN0yVd0qUkcnw78CEx+U7JA3zwgpRSsclcAsdpOd12i5AesgwQl74v7cyQOCy8SPEZOZq9
        aLKMPhp1DdlDrKcC5084iJUuqxMoZ1n1ksmxSgXLKopVR2ZVrE565e/+Adfc4c6sEFcUE61o
        X113Mt+yJ89V98Cg0I6Y4eTQ0ojmJn3/067qzrZl4yS5aNPj3fbXrHLdWprAVk6et3pTFkSO
        8XFskBLV8ew/X9ahZBUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSvO7UruI4g7M72S0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLFr3HmG3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoErY0FvA2vBLOGK02fmszYw3ubrYuTkkBAwkeh/sJIJxBYS2M0ocXu3HkRcWuL6
        xgnsELawxMp/z4FsLqCaJiaJ5YfmMIIk2AS0Je5O3wLWLCIQJHFvzVpWkCJmgVVMEp29Z8GK
        hAWsJV5P280CYrMIqEq07ZnHDGLzCthI7F/VygqxQV5i9YYDzBMYeRYwMqxilEwtKM5Nzy02
        LDDKSy3XK07MLS7NS9dLzs/dxAgOTy2tHYwnTsQfYhTgYFTi4XVoKY4TYk0sK67MPcQowcGs
        JMKrmw4U4k1JrKxKLcqPLyrNSS0+xCjNwaIkziuffyxSSCA9sSQ1OzW1ILUIJsvEwSnVwNhw
        v2ObrklZBSPnraarz5vMC79JK9osfCjjt2v/8R8aBS9nbL0avXdDlnKEql3SNR/7fEWedd9X
        1jysnsaRqd0w0eHpivUyWya8nnVip/DjF28rhYLDF3vGuqX/z2E+tpHx157722TXmKybOr9q
        XezXSY78WpEWlxW+2jMuqzzS9ZHx7eU59/KVWIozEg21mIuKEwHNCXedSwIAAA==
X-CMS-MailID: 20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec
References: <CGME20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

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

Note: This series is based on Linux-5.6-rc6 (commit: fb33c6510d55)


Alim Akhtar (5):
  dt-bindings: phy: Document Samsung UFS PHY bindings
  phy: samsung-ufs: add UFS PHY driver for samsung SoC
  Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
    controller
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

 .../bindings/phy/samsung,ufs-phy.yaml         |   62 +
 .../devicetree/bindings/ufs/ufs-exynos.txt    |  104 ++
 .../boot/dts/exynos/exynos7-espresso.dts      |   16 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi       |   44 +-
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
 15 files changed, 2521 insertions(+), 2 deletions(-)
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

