Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7573C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1747600AA
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhIQG5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29100 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbhIQG4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:53 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210917065527epoutp04d0f15d590a2c09af4673c83f5793d806~liZhxlpM83211432114epoutp04G
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210917065527epoutp04d0f15d590a2c09af4673c83f5793d806~liZhxlpM83211432114epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861727;
        bh=EfDdgInvRVQk1SxsILiW23pixQaWv3kVKpzIW5Bh8JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Og++8p6GdMIWXVBWRDBenIVoL7Dw69MszqRGx1DtLvJaPqXxR1kwO61EwyKalen6f
         qg6YoLnmRETN5zXjybGeJc8IpjH4WyP/3yhrfo5g29X/00d1KUBJJ+g0Mxk8C6gMZR
         vPEj5NSWNF7qA8gqQHfPBsUk/gOvgblpM7eGAkEk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210917065527epcas2p2ba4cbff02799c73d15ce1185a2a5c2fd~liZhLYchH0686706867epcas2p2p;
        Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8F1H3lz4x9Q0; Fri, 17 Sep
        2021 06:55:25 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.ED.09749.DDB34416; Fri, 17 Sep 2021 15:55:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065524epcas2p455b2900227b6a20994bec4816248f2bf~liZefvRuU1208812088epcas2p4f;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065524epsmtrp1c922e4181ebf1a591e99ca92446cd5e9~liZeetuVO1045910459epsmtrp1E;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-b7-61443bdc5715
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.91.08750.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2031752cbba97db9c812130b2ba136a7f~liZeKePuq2164221642epsmtip2h;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 17/17] dt-bindings: ufs: exynos-ufs: add exynosautov9
 compatible
Date:   Fri, 17 Sep 2021 15:54:36 +0900
Message-Id: <20210917065436.145629-18-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxjPufdyWxq7XSrIGcmkqdkUFrBlaz0ICBMy79QNNseW7BF2A1dK
        6Ms+fCwEcAgDOhS2CfLQsSq6wDLCu6vD8ehUpmEgkhImG6wFBCWiDAdkw7XcmvHf7/u+3+/7
        ne875/Bx0QQZxM/QGFm9hlFJSAHR3hsiDxuLSmCkAys46nN9R6Lxc+0kmlkeJlH3RBGByueX
        cfSo8aIPGvrpJfS1vd8Hff5DPLpRasGQq7EKR5aRdgw1zS1h6MyvVzBkdlhJdOnaKobyO+28
        OD966PY+uiq3hKSHTpZgdMu3ofT5H2cwurm+iKRLLV2A/ruxkKQfTo4S9MnWekAvNG+mP+sy
        Y0kb3ldFK1kmjdWLWU2qNi1Dkx4j2XcgJT5FrpDKwmSRaIdErGHUbIwkYX9S2GsZKvdcEvFh
        RmVyp5IYg0GyfVe0XmsysmKl1mCMkbC6NJVOJtOFGxi1waRJD0/VqnfKpNIIuZv5sUq51FRN
        6jp5RwvvlZG54HuyGPjyIfUKnKs8B4qBgC+irACaW+sxLngE4GzFPW9lAcAxm5P3VNI9WOll
        2QC0D3QRXPAQQGcJ15ikwmDr9Oya3J96AKDL+RXPE+BUGw5LyoeBh7WRSob5g1O4BxPUC7Ci
        8dM1tZCKg79PdWOcXzC0rxStcXzd+VHbE8Bx/GBfpYvwYNzNyWurxj0GkBrnw8tLEz6cOAFe
        XHzsbbQRzl5r9Q4RBGdOFfA4gRnA/D+feAsNABYd38/hWLhS0epuxHc7hMBG23YPhNQWaB/1
        +j4DC3v/5XFpISwsEHHCrbCro4Lg8PPQXLPgPQ0NLS1N3p1+CeDkTC8oBeKqdeNUrRun6n/j
        WoDXg02szqBOZw0RupfXX3IzWHvroXus4MzcfHgPwPigB0A+LvEXDmS9yoiEacyxT1i9NkVv
        UrGGHiB3L7sMDwpI1bo/i8aYIpNHKBTSSDmSKyKQJFB4dnU3I6LSGSObybI6Vv9Uh/F9g3Ix
        /cqJ08NDAVE7eMpdpw5OPbDGfhGBHTz9bvbONN5i5gbBFsvWzcrDvo6ViQPllf29848V74QG
        WNGRjpjBFLG003Eo8dnswLptbctvNf8VDQghCpTOvs3KyWxd/x8123JjkjXJI7UNdkJ8pyjn
        ws/VIl3g9Wn51TcOjVL+UUfvOz8MvpGzPDdodXQ7GmJhybFbJ7DI41RB6Zj6t1/uflQs3S29
        UzPe9mKd3/XgTWbrlfOJq3dtZzvedO11CV63Z+U4+67avqmbKzMJsxJFeSE9rP0DvyOmvf7v
        2W/+03kfTV4wVerab48sBmY+5+jJHb8kbLnpvBxfe2s6L7+3LC6YEORLCIOSkYXiegPzH8Sc
        kdJ0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWy7bCSvO4da5dEg+bJ7BYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17aYf+Qcq0XPTmeL0xMWMVk8WT+L2WLRjW1MFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsmjde4TdQdDj8hVvj1kNvWwel/t6mTw2r9DyWLznJZPHplWd
        bB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAJ4rLJiU1J7MstUjfLoEr48fG2WwF
        e9krOl5PZGtgXMfWxcjJISFgInHw4kwmEFtIYAejRHsbD0RcVuLZux3sELawxP2WI6xdjFxA
        Ne8ZJZa3bwJrZhPQldjy/BUjiC0i8JFRYs43LZAiZoH9zBL/Wm8CTeXgEBYIlrj6zhWkhkVA
        VWL6+iawXl4BB4l7zw4yQSyQlzjyq5MZxOYEit/a9Z8R4iB7iYmTFzFC1AtKnJz5hAXEZgaq
        b946m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEx52W1g7G
        Pas+6B1iZOJgPMQowcGsJMJ7ocYxUYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6Ykl
        qdmpqQWpRTBZJg5OqQamdfnPzcWuCsnJdGrLzr13Ua5/WniPlmXjuYPGrytnKOV82/I2W4Xn
        58/m36qPvioeXmJ8uXvNhOUz3i+KcPFY8n5SwaNKhigV1rUPVzp/e7yV7/N1A2dl7XVtMeJ/
        Qx7cTPF9M235vfV7BXcrs4dHqQiKhAl8rf46TdUgfo6Nfcn+A1utHi7YJJuSfPF55/Ol54LZ
        Nf9+/Np53K094NV7G/Z2A6lJS6Supeetz/MyEhCs87Jz2+iqZ/a0l+dW24V8vbanzNMk53jt
        CgqKjLof37fk3+WL96tk17P9Otx2Vtz5X5Cka4BW8cpzvxsDtv+3u9XNYrKA8Xunlyv/qn/H
        LduP99/ulpvXeVJ9smyAEktxRqKhFnNRcSIAmKsqWyoDAAA=
X-CMS-MailID: 20210917065524epcas2p455b2900227b6a20994bec4816248f2bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065524epcas2p455b2900227b6a20994bec4816248f2bf
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065524epcas2p455b2900227b6a20994bec4816248f2bf@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Below two compatibles can be used for exynosautov9 SoC UFS controller.

- samsung,exynosautov9-ufs: ExynosAutov9 UFS Physical Host
- samsung,exynosautov9-ufs-vh: ExynosAutov9 UFS Virtual Host

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index c3f14f81d4b7..832f0770433e 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -20,6 +20,8 @@ properties:
   compatible:
     enum:
       - samsung,exynos7-ufs
+      - samsung,exynosautov9-ufs
+      - samsung,exynosautov9-ufs-vh
 
   reg:
     items:
-- 
2.33.0

