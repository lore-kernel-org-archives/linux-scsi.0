Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96460C11F6B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4BE613AB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhGNHPB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31132 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbhGNHO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714071202epoutp043ecc5546af0087fbacb7269df8047662~RlscK6hti0784107841epoutp04N
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714071202epoutp043ecc5546af0087fbacb7269df8047662~RlscK6hti0784107841epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246722;
        bh=M6jwd/uFVXCcVX//Z5fosy/+SrI/tUr8RN1jeMDDCDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvGHPaCY5prbULd1W5gcNS0DMZUA0HMdAmPLtVHso6REUtrn+m1hiPADkLnT9RWwp
         6Y5bjBH0y8kXqZHeZFSAcSqSq2kn0dK/C/yTPDPAv851SDb6L2lKX1mNf1uCSdTPv5
         nwQawMT5ykJn8nyQhYPPbibMQNqGiHEEla/c3xk0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210714071201epcas2p1c1ffde96c530964287da9c0912bcb486~Rlsbbcred0871808718epcas2p1p;
        Wed, 14 Jul 2021 07:12:01 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbM6b8yz4x9QH; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.3B.09541.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p36dc12e150a84ef4fa2516bc98169725b~RlsZYKZnP2179721797epcas2p3N;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp1e9b1dcf299604ae2ad5f6c9f92568a0d~RlsZXHRFu1252112521epsmtrp1G;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a47-609ff70000002545-90-60ee8e3f0e1d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.43.08394.E3E8EE06; Wed, 14 Jul 2021 16:11:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epsmtip2cbab984d24c9777bc93844ceb8516dcb~RlsZEHu_Y2375923759epsmtip2_;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 03/15] scsi: ufs: ufs-exynos: change pclk available max
 value
Date:   Wed, 14 Jul 2021 16:11:19 +0900
Message-Id: <20210714071131.101204-4-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzOube9vZDBrgXnodmjqZgJDmiLhaMRcJbodRjtnMsWko3e0Dsg
        6yu9hczOOLZFJpYhPrJ2DInAhliW8UbAqTxHKjrYmAgICTNsWjJYhUWlTFnpxYz/vt85v+/7
        zvc755C4+BdCQuYYrazFyOhlRLCgtSdKFZNSPKeVl9fHI/f09wSaKm8lkGfxFoG+8i7iaL6u
        WoiGr21BRe1qNFBSiaHpulIcVY62YujiCEKDg/UiNNbcJ0DOwasYst9uI9CF/qfYTooe/i2N
        Hi7+EqObaqLpqh89GN3oKiTokspOQD/4Y1xAFze7AL3Q+DL9Racd0wSn63dks4yOtUhZY6ZJ
        l2PMSpKlvZWhzlAlyBUxim0oUSY1MgY2SZa6TxOzO0fvzyGT5jH6XP+ShuE4WVzyDosp18pK
        s02cNUnGmnV6s0JhjuUYA5drzIrNNBm2K+RypcrfqdVnzzjHBOZe4UdTtwrwfDAqOAGCSEht
        hcXXL4lOgGBSTLUB+LtvHPDFPIBjLdUCvngI4OMJr+gZxbF8l+A3rgA44j0j5IsHAFY9ugNW
        uggqBjbfmwloha8Iu6omA1o45cbhwPmugFYYdRDWf3sjwBBQm+DS/DVsBYdQKfCsw4Pxfq/A
        69VdARxE7YRd9V7A96yD7q+nAzFwf8/nLd/gKwaQukHCmco5IU9Oha4lH87jMDjT37waQgI9
        JwtEPMEO4LG7y6sbtQAWfrqPxynQ52j2C5F+hyhY1xG3AiG1EfaOr/qGwuM9T0T8cgg8XiDm
        ia/CzkuO1Qm/BO1lC6unoeHi43aMn9YZv2vtX0QJkJauiVO6Jk7p/8bnAe4CL7BmzpDFckpz
        /NpLbgSBtx29pw04Z72x3QAjQTeAJC4LD/lOOasVh+iYwzbWYsqw5OpZrhuo/MM+hUvWZ5r8
        n8NozVColAkJ8m0qpEpQItmGEFLUrRVTWYyV/ZBlzazlGQ8jgyT5WEOrU7vlQLjcXtR3p2Ge
        e/eAbmjg5M03K3LiU2c/AOpkydm06gLX0cjnL8s3V9Vtli9PoDTJYM/Sv+lT6TURh9r23N/u
        +zNGFDGhKh/pO/3oiZW5+vTIXhXWvnXXcxQXsfSi2OaKbKn27d8b5mkcPqhLtx3tvBLa0TSg
        lkc12V7LG6D+0ZRKitQNn0y5kgv7Fip2JZ6arPjZ+fFkRGO8pk6Y6y5rV/70w0VNWcVnkV46
        7/VEIkkUJajVuIeqHsJ31g8d/nXjhntM3LFRd1fo/oQj9elveyTv57M17fdrDvUaJtTiDEeY
        9W9M0abMuX1hqP9cR3+4Y06xLvw92+XdHTffkAm4bEYRjVs45j8hoYq9ZAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXteu712CwZpGC4uTT9awWTyYt43N
        4uXPq2wW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVmsvGZhcf78BnaLm1uO
        sljMOL+PyaL7+g42i+XH/zE5CHhcvuLtcbmvl8lj8wotj8V7XjJ5bFrVyeYxYdEBRo+PT2+x
        ePRtWcXo8XmTnEf7gW6mAK4oLpuU1JzMstQifbsEroxXM26yFBxhrXhwtY25gfEGSxcjJ4eE
        gInE9P+P2LoYuTiEBHYzSuzftIcVIiEr8ezdDnYIW1jifssRVoii94wSR6efYANJsAnoSmx5
        /ooRJCEisItR4vCZw+wgDrPAZWaJb9OuMINUCQsESFw5tgPMZhFQlfj9aT8TiM0rYC8xZfpL
        JogV8hKnlh0EszkFHCQObvjACGILAdX827aaDaJeUOLkzCdgdzMD1Tdvnc08gVFgFpLULCSp
        BYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgqNLS3MH4/ZVH/QOMTJxMB5ilOBg
        VhLhXWr0NkGINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkG
        psS+z1YJLw36dBw7Nf5/miQr827P3mSLaJen2of2PdUvTJ94fZ4sy2K7aXcPrVSYwzkrPcv6
        dUyQ2Our/s0O0yIM0kqU7acLz5BKWXH4aybnnz8tRvcn9b1n6jp2b3rL2vvRmZomxRePdbNM
        mG4oYZxqXVWmVMmjWCBgLL1xopvLCo0f/8Marl+qtucrP/DyyvXdjurCR5e8jUlb/fy22O7S
        nKjvhq2zCiKVc8MmR+f8yjH5LRolZs0UsjrpNs/+0iDxpfvi758xkHPYHi984eyPPidL/88d
        fx5YF+fEr7ovzNt2wkmEve3jVWeDK+dDdJ3qjhVa/XZg7po9QzQxcFNQfc1dsb+XWHgnpi9S
        YinOSDTUYi4qTgQA5NeRch0DAAA=
X-CMS-MailID: 20210714071159epcas2p36dc12e150a84ef4fa2516bc98169725b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p36dc12e150a84ef4fa2516bc98169725b
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p36dc12e150a84ef4fa2516bc98169725b@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support 167MHz PCLK, we need to adjust the maximum value.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 67505fe32ebf..475a5adf0f8b 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -99,7 +99,7 @@ struct exynos_ufs;
 #define PA_HIBERN8TIME_VAL	0x20
 
 #define PCLK_AVAIL_MIN	70000000
-#define PCLK_AVAIL_MAX	133000000
+#define PCLK_AVAIL_MAX	167000000
 
 struct exynos_ufs_uic_attr {
 	/* TX Attributes */
-- 
2.32.0

