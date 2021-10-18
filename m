Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDB4C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3436660F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhJRMrf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18607 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhJRMr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:26 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211018124513epoutp011afaacedfd4270c7407fd78ed68a141c~vIKwtd_yZ2805928059epoutp01g
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211018124513epoutp011afaacedfd4270c7407fd78ed68a141c~vIKwtd_yZ2805928059epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561113;
        bh=jUxwubpwT/nGdcofq2E+tljanBCbQBC76z/YLM7DkXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nk0Oy+7/o5KuzhvkDzysMi+6KiFEgTnc3gVwIW8CpxMlMktk6NxdHL7wromHvV55X
         4yLA6fjJ2V4+f8nPL3UEbDs5ZUjZzzEmmpicXxFyPG6l+3adiJudnmAnXp82Had/wW
         QNg9PpBKPk1+pSZ3JZLF1Km+JQnID7TJq6jE1RVY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018124510epcas2p1c1fc3787ef7e998326c104adf045f87c~vIKtdWFW93164231642epcas2p1X;
        Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.88]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HXxRR6kPLz4x9Q7; Mon, 18 Oct
        2021 12:45:07 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.D9.09823.35C6D616; Mon, 18 Oct 2021 21:45:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epcas2p190b89643fbb14d99d7ab52f5ab97bf38~vIKqNuDCP2115521155epcas2p1J;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124506epsmtrp1c20143ad1e0eed6a812c8d36d1a2f57e~vIKqMwr6q1580315803epsmtrp1S;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
X-AuditID: b6c32a48-127ff7000000265f-1a-616d6c53861c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.50.08738.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epsmtip2438de5a6d6c37b690f3c099a7ef0cc02~vIKp3oLQD0439304393epsmtip2J;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
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
Subject: [PATCH v5 15/15] dt-bindings: ufs: exynos-ufs: add exynosautov9
 compatible
Date:   Mon, 18 Oct 2021 21:42:16 +0900
Message-Id: <20211018124216.153072-16-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJsWRmVeSWpSXmKPExsWy7bCmhW5wTm6iQf9XfYuTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFpf3a1vMP3KO1aJnp7PF6QmLmCyerJ/FbLHoxjYmixu/
        2lgtNr79wWQx4/w+Jovu6zvYLJYf/8dk0br3CLvF/z072C1+/zzE5CDicfmKt8eshl42j8t9
        vUwem1doeSze85LJY9OqTjaPCYsOMHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVbZOR
        mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9KaSQlliTilQ
        KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8C8QK84Mbe4NC9dLy+1xMrQwMDIFKgwITvjzbOF
        TAXP2CvmndzC0sB4ia2LkZNDQsBE4uiBW0A2F4eQwA5GiT0XNzBBOJ8YJVYvf8UM4XxmlLgw
        5wAjTMv2HV+gErsYJXbOuwPV8pFR4sCb2WBVbAK6Eluev2IESYgIvGeUePJ4CjuIwywwn0Xi
        5tEmdpAqYYFQiXn3NzKB2CwCqhK3jx0C6+YVcJDYeKeXFWKfvMSRX53MIDYnULxn0REmiBpB
        iZMzn7CA2MxANc1bZ4PdJCHwg0Oi/0E3E0Szi8SUu8ugBglLvDq+hR3ClpJ42d/GDtHQzSjR
        +ug/VGI1o0Rnow+EbS/xa/oWoGYOoA2aEut36YOYEgLKEkduQe3lk+g4/JcdIswr0dEmBNGo
        LnFg+3QWCFtWonvOZ6gLPCTu3H8EDe3JjBI/Xk9lmcCoMAvJO7OQvDMLYfECRuZVjGKpBcW5
        6anFRgUm8EhOzs/dxAhO+VoeOxhnv/2gd4iRiYPxEKMEB7OSCG+Sa26iEG9KYmVValF+fFFp
        TmrxIUZTYGBPZJYSTc4HZp28knhDE0sDEzMzQ3MjUwNzJXFeS9HsRCGB9MSS1OzU1ILUIpg+
        Jg5OqQamtt+Tl/Ef8XDt+mDCvHGfobTDTynOFfMX9a5R6tW8maxxNivSMi1ihfW76OX+33+/
        y5UVflJuH2gs+U7S0WIx8yS1UBfV86ZXDvxKVmOf6tax6tYSl/hTvc9fnvkfKjf32I7j9Qe7
        Tvv7u8uft5hsdavDI2PduS+HChd23/Lb/OOiZEVvFU/jTjaNfJ2jOyXuistYzvgalp18N/3U
        OvVnR6LdOo7L+a/YtI7nqn21tEulycvVF+Yse87GP68sqLeu3Kcr85Zzej5Li2Fi6MKbX0Xe
        Rfx/+l/B7ItayM1HMRtL3dm7rmU9+PbSOpo3qF3uwC+euZ6Xi+NjJU+c+P/lavCWibnLq+yF
        xCY3bJqtxFKckWioxVxUnAgACEzlcoIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCSvG5QTm6iwa47MhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17aYf+Qcq0XPTmeL0xMWMVk8WT+L2WLRjW1MFjd+
        tbFabHz7g8lixvl9TBbd13ewWSw//o/JonXvEXaL/3t2sFv8/nmIyUHE4/IVb49ZDb1sHpf7
        epk8Nq/Q8li85yWTx6ZVnWweExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCeKyyYl
        NSezLLVI3y6BK+PNs4VMBc/YK+ad3MLSwHiJrYuRk0NCwERi+44vzF2MXBxCAjsYJT4teMAE
        kZCVePZuBzuELSxxv+UIK0TRe0aJv2dPgSXYBHQltjx/xQhiiwh8ZJSY800LpIhZYC2LxIwt
        V8CKhAWCJRofnwdbxyKgKnH72CGwBl4BB4mNd3pZITbISxz51ckMYnMCxXsWHQG7QkjAXmLx
        y9nMEPWCEidnPmEBsZmB6pu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFRnmp5XrFibnF
        pXnpesn5uZsYwZGppbWDcc+qD3qHGJk4GA8xSnAwK4nwJrnmJgrxpiRWVqUW5ccXleakFh9i
        lOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAtOOrUKxtse2ktRyfg3jklousuPnHac39
        0FfRIt77lHm75uTGfAytq2O4em9pBt9RIyOjVeHsQQ57Vr9Zku3z4m4D00fPAx7Pzj402vX/
        hNMllptO1xuSDmf2eqcW/ti68LnVn9+XE3dV3eQqi7GZ+O8VO5POxdB2y9oz59r7bl+7f/Ov
        /HMb6d1PNsu8/bbg+an3/Ev+rvl9ITL7C5O4WoLpj50G3ntmPsu69XveZB7VmDU5Bn8eLdj3
        lNlw+bav/NtcXDb7+n3UORLMNemGSe5WJdX7upriwWYuO/bM3bvm8vYX2ZVvmvdd51hSsUPm
        f/YeVlGpx3NeenxPFVarPPj2p8x7sRNn2s2CbyhdluxVYinOSDTUYi4qTgQAWM0noTsDAAA=
X-CMS-MailID: 20211018124506epcas2p190b89643fbb14d99d7ab52f5ab97bf38
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124506epcas2p190b89643fbb14d99d7ab52f5ab97bf38
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124506epcas2p190b89643fbb14d99d7ab52f5ab97bf38@epcas2p1.samsung.com>
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
index 691741f9d6c0..95ac1c18334d 100644
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

