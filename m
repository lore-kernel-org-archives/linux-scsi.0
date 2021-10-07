Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4B0C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 584FB610CC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbhJGIOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46033 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240670AbhJGIOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:04 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211007081209epoutp040c3523b7e445a9d9b34ee81d7dcb25fa~rsWNGhZCb0375003750epoutp04U
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211007081209epoutp040c3523b7e445a9d9b34ee81d7dcb25fa~rsWNGhZCb0375003750epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594329;
        bh=XFsbgEomLxkf5rB35VPJvqcJfhMtI2p3kGpG2oQ2VVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXOt+ndfFAfsv2rUtCRobQa3F2nPOYoX+FQ3vGeI3TfF6ED64pe6okxwxpFT0kGQQ
         0T+QNV6JjsRrwuphuU9O15t3y0/6TPN65JgNYKb1OQzQ/rIiMfHoNIvPVrcwGd9FW5
         iTNPHx/Dhco8Rw0EswD0fnES3j2ma3QWzhe75dxk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081153epcas2p2de6c7150d1f5aac06b719f7c3df481c5~rsV_PTU1E3113331133epcas2p2u;
        Thu,  7 Oct 2021 08:11:53 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HQ3vC42sSz4x9TZ; Thu,  7 Oct
        2021 08:11:51 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.D5.09749.4CBAE516; Thu,  7 Oct 2021 17:11:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690~rsVtC6UCB2940629406epcas2p2B;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081135epsmtrp257bf964df916b385ba9d666fe97f34d5~rsVs_s_Pf2686726867epsmtrp2_;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-6f-615eabc4e2e8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.63.09091.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epsmtip20db6c3e68c5bce6feddc0cb647079fa7~rsVsu8SKr0802008020epsmtip2C;
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
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 13/16] dt-bindings: ufs: exynos-ufs: add io-coherency
 property
Date:   Thu,  7 Oct 2021 17:09:31 +0900
Message-Id: <20211007080934.108804-14-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1BUVRSe+97btwuJvRaNCzPG+jBTGthd2IVLA/5Axp6DzqxjTGODwhv2
        sRCwu+1blMQmHAaE3bAlCWzRaNYpCRUCEcmgADcQKaLBlJhyTIkfoghuIj8S2uVR+d93zvm+
        891z7r0SXDpGBkjS9WbOpGczadKbaLqyUR3iPLufVfzaE426h86R6PanTSQam/2FRO1/FBOo
        fHIWR4/qvhCh/u9eRVXOXhH64OttqMfmwNBQnR1HjoEmDA3MFYpQ/YMZDJ346VsMWW82k+hM
        1wKGClqdYjQ/24Ft8WX6r8cz9rwSkuk/VoIxF6qDmdMtYxjTUFNMMjZHG2Ce1BWRzNSfgwRz
        rLEGMK6Gl5ijbVZMs+KtjOg0jtVyJhmnTzFo0/W6GDp+T9K2JHWEQhmijEKRtEzPZnExdNxO
        Tcj29Ez3hLTsAJuZ7U5pWJ6n5ZuiTYZsMydLM/DmGJozajONkcZQns3is/W6UD1nfk2pUISp
        3cTkjLRBqxUYS71zmn4sE+eBVokFSCSQUsGbv6dagLdESjUDePvJ92IheASgq9dOCME0gDca
        HZgFeC0pKlxOkVBoBXCgehETgikAxy1ThIdFUiGwceQe8BRWUQ8BHLpbttQYp/IIOD5YBDws
        X2oPXCwZFHkwQb0Mz9uu4R7sQ22BV/+aEAt+gdA5V7yU93LnWy6fJwXOC7D7k6ElN9zNyb9Y
        iXsMIDUqgTV9FkIQx8HxvnogYF94r6txuWkAdE20koLACmDBncXlwlkAi4/sFPBmOFfRKPLs
        Cac2wrrLcmFlQdA5uOy7EhZdeSoW0j6wqFAqCF+BbZcqlk+wBlpPukQCZmCn9SQpbOs4gNOn
        5kU2ILM/M479mXHs/xt/BvAa8CJn5LN0HB9mDP/vjlMMWQ1g6c0Hv94MTjyYDO0AmAR0ACjB
        6VU+hs37WKmPln33EGcyJJmyMzm+A6jdyy7FA1anGNyfRm9OUqqiFKqICGVkmFoRSfv5nFqI
        ZaWUjjVzGRxn5Ez/6jCJV0Aepk2ke2OTGgx0gjQq7mP5ROThD7GVOTvyt/02+vPCxem41vTP
        Gwq3Eqv9Dqqevp3z/t2rcMbWwlE7pvfOD1gmFQNBb+x2FKhr7nuLZNf5qbVDse+F96J32HQ+
        2dl+ZGw2QDP7TepweTXXorGJ+45uWtupKq0NLJrpyy+P2fXcl4e6VC0j2VV+e6UbDsgJfo0/
        1rPguOAq7Sl3rT+jS7Wwb4535j4+XJtcuW9/eDCy5dp2V09E3TfcOJ5w7iuDtjawXZfof7Bp
        vWqXPOe0pfLarVF6xfOFwwnrCE3xuq35P3Tf+Ztr75GPdN+qj5d/5P+wDDi3p0rUuX4bquyP
        hxOpS0E0waexymDcxLP/AH3OFuJ8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBtO3mlmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9ti/pFzrBY9O50tTk9YxGTxZP0sZotFN7YxWdz4
        1cZqsfHtDyaLGef3MVl0X9/BZrH8+D8mi9a9R9gtfv88xOQg7HH5irfHrIZeNo/Lfb1MHptX
        aHks3vOSyWPTqk42jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMATxWWTkpqTWZZa
        pG+XwJVxq7ubsWAiV8W2s1PYGxj3cnQxcnJICJhITP98hBXEFhLYzShxrSsbIi4r8ezdDnYI
        W1jifgtIDRdQzXtGiVlbjzGDJNgEdCW2PH/FCGKLCHxklJjzTQukiFmgh0XiaXcrWEJYIFBi
        57TjLCA2i4CqxNoJp8CaeQUcJE58eQe1QV7iyK9OsDgnUHzPrrVsXYwcQNvsJbr+RkKUC0qc
        nPkEbAwzUHnz1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cT
        IzgWtTR3MG5f9UHvECMTB+MhRgkOZiUR3nz72EQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6
        TsYLCaQnlqRmp6YWpBbBZJk4OKUamC5x9zb8ehP6TznhjfDeG1kPVgbUuKodrZkZqdfib7tr
        v1tnVGdzN8MB1egpM2bfKHNxMIpq5rYqWsMvEHmdzcegxOnaas/gv1Ur760sn38zgDViL9t5
        N/8nGjm2HgKiBfePt6dLbZon+5KNo8I3p1J/l5bqwoMLduhNM5qnH7RF5VSOeMHEjgt9h2tm
        zOcJy09OqhTZE5h1/4//p+m2c7v11wY0sOruzrn08JoL34n4zUXCy6brL9yidLlavk5k/ods
        6cPeRWli0et4XWQEBGeKFv3zORZfUNR5/4Vls1RhFcfLjhubrqVLKWZ6Oc1QvDZTfHGEcrYR
        i4ehtcb/yh3/mZvOJE1+FcbmzavEUpyRaKjFXFScCADIpso8NAMAAA==
X-CMS-MailID: 20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add "samsung,sysreg" regmap and the offset to the ufs shareaibility
register for setting io coherency of the samsung ufs. "dma-coherent"
property is also required because the driver code needs to know.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml   | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b9ca8ef4f2be..d9b7535b872f 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -54,6 +54,17 @@ properties:
   phy-names:
     const: ufs-phy
 
+  samsung,sysreg:
+    $ref: '/schemas/types.yaml#/definitions/phandle'
+    description: phandle for FSYSx sysreg interface, used to control
+                 sysreg register bit for UFS IO Coherency
+
+  samsung,ufs-shareability-reg-offset:
+    $ref: '/schemas/types.yaml#/definitions/uint32'
+    description: Offset to the shareability register for io-coherency
+
+  dma-coherent: true
+
 required:
   - compatible
   - reg
-- 
2.33.0

