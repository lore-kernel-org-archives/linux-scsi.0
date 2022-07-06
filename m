Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5679FCCA47B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 02:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiGFCFs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 22:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGFCFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 22:05:46 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECC018351
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 19:05:44 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220706020542epoutp04c260892f8b916486fd63e8463f86be5b~-Gz5EjWsf2675326753epoutp04j
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 02:05:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220706020542epoutp04c260892f8b916486fd63e8463f86be5b~-Gz5EjWsf2675326753epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657073142;
        bh=9i/7uIINk7h19B61IlxH9j7oMZ1qse+Kwf0O6YUL1+U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=hlOS1YBk6e75ngJnzMzui7ov/2L0B1hXt/CVYDKql0k6ntISLu6+nKoGIeROrWeCm
         OA28MaDAKXJGdDOmjOsvD0/QloQ3nu1YRXxPwk2PMPk7TyMIT1UYDNR7ugLKl9/rwL
         ZyL6QnS4Y1HBunZyWCJC4wK6T+jKF0dmejr8MeRo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20220706020541epcas2p29a430bb26e66725b0c59b3448219a72f~-Gz4pj9NQ2896328963epcas2p2E;
        Wed,  6 Jul 2022 02:05:41 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.97]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Ld2v91N6Kz4x9QB; Wed,  6 Jul
        2022 02:05:41 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.C8.09642.5FDE4C26; Wed,  6 Jul 2022 11:05:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f~-Gz3wo2_l2943729437epcas2p38;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220706020540epsmtrp2cd4c7ce6ed8737711695d791710cb99c~-Gz3vzB6-3159231592epsmtrp26;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
X-AuditID: b6c32a47-5e1ff700000025aa-b3-62c4edf50a53
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.5B.08802.4FDE4C26; Wed,  6 Jul 2022 11:05:40 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220706020540epsmtip27c133ad13e1d669b35ce5235c8c9c897~-Gz3b5I5K1055210552epsmtip2D;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 0/3] change exynos ufs phy control
Date:   Wed,  6 Jul 2022 11:02:52 +0900
Message-Id: <20220706020255.151177-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmqe7Xt0eSDF5tZbN4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGZdtkpCam
        pBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2spFCWmFMKFApI
        LC5W0rezKcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO6Fi/g63g
        G2fFmYeTmRoYP7F3MXJySAiYSJxZeJq5i5GLQ0hgB6PE/Tm7GCGcT4wS71a+YoVwPjNKfL30
        lA2m5VHTZKiqXYwSKw5Oher/yCgx728/E0gVm4CuxJbnr8CqRAR2MEncapnIAuIwC2xmlGi/
        uhNoFgeHsICpxIU1RiANLAKqEjNa3jKC2LwC9hJb1/xjhFgnL7Hh4HYWiLigxMmZT8BsZqB4
        89bZYJslBHo5JO4/WAbV4CLxddE1VghbWOLV8S1Qr0pJfH63F+qHYomlsz4xQTQ3MEpc3vYL
        KmEsMetZOyPIccwCmhLrd+mDmBICyhJHbkHt5ZPoOPyXHSLMK9HRJgTRqC5xYPt0FghbVqJ7
        zmdWiBIPiTfL7UHCQgKxEnO+HmefwCg/C8kzs5A8Mwth7QJG5lWMYqkFxbnpqcVGBcbwWE3O
        z93ECE60Wu47GGe8/aB3iJGJg/EQowQHs5II76pJB5OEeFMSK6tSi/Lji0pzUosPMZoCg3ci
        s5Rocj4w1eeVxBuaWBqYmJkZmhuZGpgrifN6pWxIFBJITyxJzU5NLUgtgulj4uCUamASyF6W
        lvJW3HXbEXafB5sF+dP9unpeMx39lttzcb9sM5/exdd/KpxP/EnaZ/Jq+p6jrX+brXfM1T+8
        9pbiWpNtXl/Y2vdMsdwydZ1+gutGr9S8OU8rOV8+v+z1P+OiedbPLULNz8ND9ZJ2WjKtFK7S
        Xu5dHd10YKKVXfeCakFnE7MJil5HRL9z3VFdxRBqwZr8VehJ3aX2yYfjk35et9f5Kp0s3HPF
        gOFg4b7Hpw9LqG2ZHvTI1F16EaPBq9e+ixnPnbabxK068/S8O7UbF6Za3SqqmH317vE9/rNK
        ze6sW/+gKTBSWKK2Yv0p/kXFpwr8hXdPl95y4lTKlzankqtrF728IfFyx9tLdQd/dJtaKLEU
        ZyQaajEXFScCAIq8cqk9BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSvO6Xt0eSDC7PVrV4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGcdmkpOZk
        lqUW6dslcGV0rN/BVvCNs+LMw8lMDYyf2LsYOTkkBEwkHjVNZuxi5OIQEtjBKHGh4ztUQlbi
        2bsdULawxP2WI6wQRe8ZJaZ8PMgEkmAT0JXY8vwVWLeIwB4miS/zNrCAOMwC24Gq3l4Hcjg4
        hAVMJS6sMQJpYBFQlZjR8pYRxOYVsJfYuuYfI8QGeYkNB7ezQMQFJU7OfAJmMwPFm7fOZp7A
        yDcLSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBwa+ltYNxz6oPeocY
        mTgYDzFKcDArifCumnQwSYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWp
        RTBZJg5OqQamgJec4oEzp/HOmfXxz+FHxxbwT0kPTArr+5K5Q1a1/sC7e6U/46dZVEi8+P+y
        N8SG8Y+NWkKp2mv1fD1zO3v+/U3RSh5uGcsKjlUnTJW6Yqr+9c3H89feHvx29ONplQuP1+Ss
        XWHrXnLxfEyCclFRjtasOyLLBTqr5A0LGqWSjzd1Rh4RWxUsFjlZQnzFjw+/G45b97y6ZHDT
        T0ZWdsJZSX7XyJPHvD/7HfrotnWX+T2H6tBJnM/Erh0I/vl/brm15LJ5czis4ruaCq5ovZun
        9u5k86mXV1OFrod+Ocn5zCRo7YGgX3Hf+JXqDzxdMvPj8c55H+JvdXQeWVGgkyH6ueEl/74J
        x+a8OHv2XMofHSWW4oxEQy3mouJEAKzGSN/tAgAA
X-CMS-MailID: 20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f
References: <CGME20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is called
before phy_init"), below warning has been reported.

phy_power_on was called before phy_init

To address this, we need to remove phy_power_on from
exynos_ufs_phy_init.

The first patch is for changing phy clocks manipulation from controlling
each symbol/ref clocks to clk_bulk APIs. The second patch is for making
power on/off sequences between pmu isolation and clk control.
Finally, the third patch changes the phy on/off and init sequences from
ufs-exynos host driver.

Changes since v1:
- Add Krzysztof's R-B tags for #1 / #2 patches
- Get back the error check of phy_power_on

Chanho Park (3):
  phy: samsung-ufs: convert phy clk usage to clk_bulk API
  phy: samsung-ufs: ufs: change phy on/off control
  ufs: ufs-exynos: change ufs phy control sequence

 drivers/phy/samsung/phy-exynos7-ufs.c      |   7 +-
 drivers/phy/samsung/phy-exynosautov9-ufs.c |   7 +-
 drivers/phy/samsung/phy-fsd-ufs.c          |   7 +-
 drivers/phy/samsung/phy-samsung-ufs.c      | 121 ++++++---------------
 drivers/phy/samsung/phy-samsung-ufs.h      |  10 +-
 drivers/ufs/host/ufs-exynos.c              |  17 +--
 6 files changed, 66 insertions(+), 103 deletions(-)

-- 
2.37.0

