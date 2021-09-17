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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D206C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 293FC610C8
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbhIQG5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20291 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210917065525epoutp02ffe40d463174143586b7a00e51054976~liZf_yVW13026730267epoutp02C
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210917065525epoutp02ffe40d463174143586b7a00e51054976~liZf_yVW13026730267epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861725;
        bh=KDIybRxTiEr9LwmIIuZauDENiGYCxhEyBm/9vNAIcOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZQQM1fBDam2xrNVwMmzcrboS88J5dQzB2rM/OZF4/ufEhmxWJWhT8YYuPaa+lqMJ
         RCQWFJSMvplGOIY+4H3ZsN4FW2Glu+1HrUHCGRPM04w7T3EHIdtdqly6M5KV1oTO1R
         Mz3+OlzrTWDwy+HlNlr3RVVmJmVRJunrZSsJ+tq0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p1ce75d84e096e7f0aaf6ce509b7b6a5b9~liZfUnbIG0293102931epcas2p1f;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4H9l8C72TTz4x9QH; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7A.43.09816.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p44a9f121c18e0f3a5614f980c9eeffa16~liZdlSsq-0164301643epcas2p4T;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp21426561fe23813c3bd71edce8aea36ae~liZdkPIcN1373513735epsmtrp2C;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-12-61443bdbd09d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.10.09091.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2d95c0b340d93336d01364bcf2ca11972~liZdT6kMH2164221642epsmtip2f;
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
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v3 07/17] scsi: ufs: ufs-exynos: add refclkout_stop control
Date:   Fri, 17 Sep 2021 15:54:26 +0900
Message-Id: <20210917065436.145629-8-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJsWRmVeSWpSXmKPExsWy7bCmue5ta5dEgwuLjC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLGac
        38dk0X19B5vF8uP/mBz4PS5f8faY1dDL5nG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaP7+s7
        2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
        LS3MlRTyEnNTbZVcfAJ03TJzgL5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQY
        GhboFSfmFpfmpesl5+daGRoYGJkCVSbkZPyc+Jy14DB7xd11hQ2Ma9m6GDk5JARMJC7Pvsvc
        xcjFISSwg1Fi9dVLrBDOJ0aJ0wdWQznfGCW+7jkA13Lh2AKolr2MEr/OHWEHSQgJfGSU6Noq
        CGKzCehKbHn+ihGkSETgPaPEk8dT2EEcZoGvTBK7D34HGyUs4C1x/mk7WDeLgKrErGkXWEBs
        XgF7icX3V7JCrJOXOPKrkxnE5hRwkLi16z8jRI2gxMmZT8DqmYFqmrfOBjtJQuACh8SslmYW
        iGYXiddnTjFD2MISr45vYYewpSQ+v9vLBtHQzSjR+ug/VGI1o0Rnow+EbS/xa/oWoCs4gDZo
        SqzfpQ9iSggoSxy5BbWXT6Lj8F92iDCvREebEESjusSB7dOhLpCV6J7zGeoVD4kpCz5CQ24y
        o8T19TOYJzAqzELyziwk78xCWLyAkXkVo1hqQXFuemqxUYERchRvYgSnby23HYxT3n7QO8TI
        xMF4iFGCg1lJhPdCjWOiEG9KYmVValF+fFFpTmrxIUZTYGBPZJYSTc4HZpC8knhDUyMzMwNL
        UwtTMyMLJXHeuf+cEoUE0hNLUrNTUwtSi2D6mDg4pRqYvH/brPapDrqq6PzgXer3i6fcOE49
        UJORXfsr8+qfD+tZhW6fOTqnoatlxbnqedZ3X4esfnbIfDsf+8N7d46YFE3hdori4uCUeehu
        0ujF/bg5THOjKvu3ZXNNlpwv+qcaGn0r3rtL9FO1RuLhm7ql/J1/VQ9MDqttynh3f0mVUJeW
        S8P1BL0k/rY/Bn9Kd7/aJ3P65+onXDycDYfNGt/pLurwE5vHLaexa4WgZlAfU7lDdPwdkaWv
        ZbKeBB6c1nfo3IOMUv9Jmjk5ST+FvqZ/bWLbNE9P55KOzs3ZYtt+/tRSVYtftF74Qlj8vCN/
        jdRPbZlycINdydaf/k3xv26cnKdnnjSjg/d/zNPCLfpflViKMxINtZiLihMBAUbhfWgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJXve2tUuiQddJbouTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFpf3a1v07HS2OD1hEZPFk/WzmC0W3djGZLHx7Q8mixnn
        9zFZdF/fwWax/Pg/Jgd+j8tXvD1mNfSyeVzu62Xy2LxCy2PxnpdMHptWdbJ5TFh0gNHj+/oO
        No+PT2+xePRtWcXo8XmTnEf7gW6mAJ4oLpuU1JzMstQifbsEroyfE5+zFhxmr7i7rrCBcS1b
        FyMnh4SAicSFYwuYQWwhgd2MEhemqULEZSWevdvBDmELS9xvOcLaxcgFVPOeUWL5wc1gDWwC
        uhJbnr9iBLFFBD4ySsz5pgVSxCzwl0mitXUDE0hCWMBb4vzTdrBJLAKqErOmXWABsXkF7CUW
        31/JCrFBXuLIr06woZwCDhK3dv1nhLjIXmLi5EWMEPWCEidnPgHrZQaqb946m3kCo8AsJKlZ
        SFILGJlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEx5iW5g7G7as+6B1iZOJgPMQo
        wcGsJMJ7ocYxUYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5O
        qQYmpctHZFi4e31Cgm8XsMWGSq2e9Hn9nzVH/0SzTq1YIM6qekpB4E+4uPA/kdhrMkEPgwMn
        KTeZ3+yN0vg90fCf/MQ70mfn7j+YKvfZcoLYjC2cu/9O/mH3gW3G+RWRhTEPXqrMjFA1M3hv
        aX3irCpLjOesm+p3TKc9f77rOOuK05P/3AgSXmVzT3PKxPq1334rFFflXndaZtRu+Ygt/WTC
        mZxze7byVkds7b7RN18ujbGZ+/eG6xKXHHk+82dxMtmeXVwk4db2aUXZKVXWl0ornb5qdi3a
        X7A/a+L2LL8vfSHz1hz1cVI9dbz5s1O4nvG3aatkJxXI+dQ8tki/n/I2eeGk53WTmltv3Vmp
        cd0yTomlOCPRUIu5qDgRACKmUbkgAwAA
X-CMS-MailID: 20210917065523epcas2p44a9f121c18e0f3a5614f980c9eeffa16
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p44a9f121c18e0f3a5614f980c9eeffa16
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p44a9f121c18e0f3a5614f980c9eeffa16@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds REFCLKOUT_STOP control to CLK_STOP_MASK. It can
en/disable reference clock out control for UFS device.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index f7a1b99c823b..627edef4fbeb 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -49,10 +49,11 @@
 #define HCI_ERR_EN_T_LAYER	0x84
 #define HCI_ERR_EN_DME_LAYER	0x88
 #define HCI_CLKSTOP_CTRL	0xB0
+#define REFCLKOUT_STOP		BIT(4)
 #define REFCLK_STOP		BIT(2)
 #define UNIPRO_MCLK_STOP	BIT(1)
 #define UNIPRO_PCLK_STOP	BIT(0)
-#define CLK_STOP_MASK		(REFCLK_STOP |\
+#define CLK_STOP_MASK		(REFCLKOUT_STOP | REFCLK_STOP |\
 				 UNIPRO_MCLK_STOP |\
 				 UNIPRO_PCLK_STOP)
 #define HCI_MISC		0xB4
-- 
2.33.0

