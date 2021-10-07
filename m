Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1DBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 742E2610C7
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbhJGIOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44056 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240591AbhJGIOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211007081205epoutp02c71bb47c750cfb42b14b6524fa8e13b5~rsWJdwGkW0346603466epoutp02O
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211007081205epoutp02c71bb47c750cfb42b14b6524fa8e13b5~rsWJdwGkW0346603466epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594325;
        bh=sv3iKFzctSYPpRBYgsGGdvX+jiz+7NEpAZErUWFqi6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yw7k6C4hF4ogHHLlA0wPcOx4FGKQjy3vngDtxWZ2WREJSzPwBVigNzXnR3oymPvR0
         9922GOEosSbl0R+BUT35yLkmsjqNDMeY6Pdcc54TZFPztweYmbVWPWwoC/jYEDlUg5
         D8hF+ZRQZDtxAp/izAKx2Nu4SFs0CHR06m47KHRQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081148epcas2p2df63962d58ea3dcbb2b44f042d5edf62~rsV5THOb53104231042epcas2p2m;
        Thu,  7 Oct 2021 08:11:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.88]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HQ3v56VPyz4x9Qd; Thu,  7 Oct
        2021 08:11:45 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.A8.09816.CBBAE516; Thu,  7 Oct 2021 17:11:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epcas2p37b429e366099fd28e517d3d354a848b8~rsVtczRVO1824618246epcas2p3R;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081135epsmtrp29373393cc4a63052d8572bd78361659f~rsVtZLlRz2686626866epsmtrp2C;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-14-615eabbcec3e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.63.09091.7BBAE516; Thu,  7 Oct 2021 17:11:35 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epsmtip28f26d26551b9dc3ac32fa55fecd11431~rsVtGcZ1k0802008020epsmtip2D;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
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
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v4 16/16] dt-bindings: ufs: exynos-ufs: add exynosautov9
 compatible
Date:   Thu,  7 Oct 2021 17:09:34 +0900
Message-Id: <20211007080934.108804-17-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHPffu3r0wrV0XxBOjgFcbRxpgl3hcExCToTtgDJOPqQzhDnvb
        pX3O3qXnWCTxXCQYCGyxcJYmC2Q2HhIgm8u6RlIjFFKEjYO1goK8RFNgwHb3Uvnf53zv7zvf
        8z33HByVTGGBeI7WyBq0jJrEfAUdF3fGhNmajjLS2haEuuw6i1Fjn3dg1O3FYYzqvVEioGrm
        FlHqrvVLITV04Rmq3nlFSJV17aN+rLAglMtqRinLSAdCjSwVCqmW6YcIdXLgO4Qy/daJUWf6
        VhGqwOYUUY96OkXU8qIDSfSnh66m0ua8Exg9VH4Codu+CqUbem4jdGtjCUZXWOyAfmAtxuj5
        m6MCury9EdALrUF0kd2EpD/xqipOyTJy1hDCarN18hytIp5MPZC5LzM6RioLk+2iYskQLaNh
        48mk/elhyTlqd00y5E1GneuW0hmOIyMS4gy6XCMbotRxxniS1cvV+lh9OMdouFytIlzLGp+T
        SaWR0e7BLJXyUkU30I+L3rY0rKJ54BesFPjgkIiC+TfsIg9LiE4AJ2zKUuDr5rsA1jf9LOAX
        fwM4+UWvsBTgXsdPV/byug3AuW6rkHfPAzg2tdfDGBEG2ycmgWfIn5gF0PVXtcizQIl6Afz9
        0nFvnh9xCFZOTqAeFhBPw6Fxl5fFRCIsOe0Q8vsLhs6lEq/u49Z7upsxfmYDvPypS+Bh1D2T
        f64O9QRA4h4OrRdXRLw5CbZNNCA8+8HJvvY1PRAuzNgw3mACsODPR2sfmgAs+XA/z3vgUm27
        tzNK7ITW7gi+/jboHF3LXQ+LvVEeWQyLCyW8cQe0f1sr4HkLNJ1aWKtCw3ND9YA/rCoAG2ay
        KkCI+bE25sfamP/PPQ3QRhDA6jmNguUi9ZH//eBsnaYVeG99aHInqJ6eC3cABAcOAHGU9Bfr
        9mQwErGceedd1qDLNOSqWc4Bot1nXYkGbszWuZ+N1pgpi9oljYqJkcVGRktjyU3iz1afZySE
        gjGyKpbVs4Z/fQjuE5iHMBuq7z1bWDsqKnt/MRVJqS5/8WPLH7bx0OxrXQ3bt3/ydWnLWW38
        +eHCw2MBY0ftB9MG7zdfP6J4K7/0fPixnoTh65UXDvTTWaJaGepab0mpenAHqZlqD5p/JajP
        Ud3nLFseTCyTHiwS0RnOa8eXXt4nE1prDqf1vvYwUvyNn23GVF+xbNXcyvnBb3edPMN3dgtn
        QQ71Xz2ylPfe1m1TT50cmJ2+dTPYdKfLJDyzVSEzaSY248LgQfmACk9THnsBGFIWy2jVfePK
        6wk4KZGA/Des65ICdRHEDvsHw6rdoMi1eV1uKNHWXPVS8kd1AUWb+mmjznxqRf3kyMbE71cL
        fo0jBZySkYWiBo75B649ZyB+BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSvO721XGJBgtui1icfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9ti/pFzrBY9O50tTk9YxGTxZP0sZotFN7YxWdz4
        1cZqsfHtDyaLGef3MVl0X9/BZrH8+D8mi9a9R9gt/u/ZwW7x++chJgcRj8tXvD1mNfSyeVzu
        62Xy2LxCy2PxnpdMHptWdbJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAJ4oLpuU
        1JzMstQifbsEroyjE3YxFjxjr1i0+B9zA+Mlti5GDg4JAROJM+ccuxi5OIQEdjNKrP19mbmL
        kRMoLivx7N0OdghbWOJ+yxFWiKL3jBKbVl9kBUmwCehKbHn+ihHEFhH4yCgx55sWSBGzwFoW
        iRlbroB1CwsESzQsWA5mswioSlx+9gRsA6+Ag0TngkOsEBvkJY786gSLcwLF9+xaC3adkIC9
        RNffSIhyQYmTM5+wgNjMQOXNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc
        4tK8dL3k/NxNjOCo1NLcwbh91Qe9Q4xMHIyHGCU4mJVEePPtYxOFeFMSK6tSi/Lji0pzUosP
        MUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYPKXCKgquXI87cpq7e3toSEd92uPL/c+
        EK5+727s2vlfSj1/3BYMFLjt03rosccr48oA5jYDFZ1TJ5zWLotq4r0R6ns31HDO4xptzbIO
        ZY6AEzoGZzymVwizuXlek68M1ZJq7d5eaPVY3XDa/vNL3m6zYJt+MymaK/2EQln1NWeBXzpO
        r1M+O5qse3fp58tKqYbIYIblKo9+HvJ4O61WteNtkvAJHuGZcW030sMWd8e2iPscnzR/19E7
        IR/kr/devjJJXDtM07u5xTxktqOPVDaP+/n/jXs5X/XoTr4+d8O7+ZM7m3aLnvozfceJY8/0
        qpTfC314atnRcrZgW4bCBdvN2rPcrtvnTuyMOvZDXImlOCPRUIu5qDgRAIrZgGE5AwAA
X-CMS-MailID: 20211007081135epcas2p37b429e366099fd28e517d3d354a848b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p37b429e366099fd28e517d3d354a848b8
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p37b429e366099fd28e517d3d354a848b8@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Below two compatibles can be used for exynosautov9 SoC UFS controller.

- samsung,exynosautov9-ufs: ExynosAutov9 UFS Physical Host
- samsung,exynosautov9-ufs-vh: ExynosAutov9 UFS Virtual Host

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index d9b7535b872f..d5cfd99f4337 100644
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

