Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1B1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339106112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhIQG5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20333 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp0294d3b3b2c0d7b641b6dcd20fc5ff8263~liZga8nIy2960229602epoutp02d
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210917065526epoutp0294d3b3b2c0d7b641b6dcd20fc5ff8263~liZga8nIy2960229602epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=qZ5dppVwVeqasGRuSK4xHCpIcS6Wc0M2jmdax6HE51M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLG5FYAYAYdz7o78GFLK6suktVvMHXOew9XTomGfcc58ntrHgoT5vd88Svdr2Th36
         b5taca2pXdMLyvVjYijLeC9093zT0pCAAcGdU2XVhpBDjNDaiWF1nPgV1vJ3bhRVpC
         xaW5tvadJ+Fv7XrnPeKjcfQBCp+ulp9C4vdUDQPQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p2aa81cb3adde20c7a780412d8ccb4ab2f~liZfsRIg80686706867epcas2p2j;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8D3BZrz4x9QJ; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.DF.09472.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p39e18203beafe9377e9dac819f01b804f~liZd4ZWSG2938329383epcas2p30;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp27265c620a15d204e9118e864ca1b5657~liZdyp9zQ1373513735epsmtrp2E;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-49-61443bdc492a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.91.08750.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip2132c99e7244b83bc10c465444d4cc9da~liZdnXGBK2163221632epsmtip2w;
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
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 10/17] scsi: ufs: ufs-exynos: support custom version of
 ufs_hba_variant_ops
Date:   Fri, 17 Sep 2021 15:54:29 +0900
Message-Id: <20210917065436.145629-11-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmue4da5dEgwMn2S1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEn48TPv+wFv3gqZr97xdTA2MzdxcjJISFg
        ItE0cRtrFyMXh5DADkaJLcua2SCcT4wSux7dh8p8ZpRY0nOBsYuRA6xl2vNqiPguRon7J+cw
        QzgfGSUu7u9gAZnLJqArseX5K0aQhIjAe0aJJ4+nsIM4zAKzmCWOf53MBFIlLJAgsbdvDpjN
        IqAqsamjmxHE5hVwkNh0cDczxIXyEkd+dYLZnEDxW7v+Q9UISpyc+QRsGzNQTfPW2WBnSAjc
        4JBYuHgFC0Szi8TrG+dZIWxhiVfHt7BD2FISn9/tZYNo6GaUaH30HyqxmlGis9EHwraX+DV9
        CyvI08wCmhLrd+lD/K8sceQW1F4+iY7Df9khwrwSHW1CEI3qEge2T4e6QFaie85nqAs8JFZt
        Oc4CCa3JQFtfb2WawKgwC8k7s5C8Mwth8QJG5lWMYqkFxbnpqcVGBSbIcbyJEZzKtTx2MM5+
        +0HvECMTB+MhRgkOZiUR3gs1jolCvCmJlVWpRfnxRaU5qcWHGE2BgT2RWUo0OR+YTfJK4g1N
        jczMDCxNLUzNjCyUxHnn/nNKFBJITyxJzU5NLUgtgulj4uCUamAqNZzx9bENv0fyo7c//yrM
        efEiK3pFEN8WmwlWV7xvSp1apf7j1b53Vh9Fc+ayLQn92HN+h+GtgsgziR8q1355ONfRUWOX
        U/en4uvf3h9R1mQNmvRq//n987p3z1zuYB/8MrPqSEsC55cPsyOXTuATiZ0cxzHlpnfbxKe+
        s6VVS45N/Mdbd01VPWYJv17WtGMV+0Pm6Qht/X2zSM4q0HHdSW+7TZGn/mXfLit/ItqgdET2
        aMiNpS0dO/wTGP9+Dp7bNWeSZUdpr7363bP5bOcNdSb7rZa7smcxp0voG85r/f/0Wnu6Lzd/
        iHq9wFfQJKWw80XC9knZsnvuuvxUX6tp7lr81W639JRY77Ut2498VWIpzkg01GIuKk4EACAb
        hJJuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg/M3ZS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXHi51/2gl88FbPf
        vWJqYGzm7mLk4JAQMJGY9ry6i5GLQ0hgB6PE5R3LmLsYOYHishLP3u1gh7CFJe63HGGFKHrP
        KDGv4wEjSIJNQFdiy/NXYLaIwEdGiTnftECKmAWWMEs0HpjHBLJBWCBO4kCrCUgNi4CqxKaO
        brB6XgEHiU0Hd0Mtk5c48qsTzOYEit/a9R+sRkjAXmLi5EVQ9YISJ2c+YQGxmYHqm7fOZp7A
        KDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjB0aaltYNxz6oPeocY
        mTgYDzFKcDArifBeqHFMFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFq
        EUyWiYNTqoFp8n71X/7r+xKfFnHNLSv6st44lMeYa1fshBfVWnfW6B6OePLRMkPqQ6GD7pTt
        KzdP9NSaVqRqaXF7dnTQP0+Pu7N355oIRQlvlJq/a6L5lcR5xvIT/Ou2b2M0Pls02/V16cn4
        bb/cZrkrMu9ZLsN3S1hK4elegSM39mqqPl/tysYcNs1e2XrdRKtDjEVm14xyHMukfvFu6k7S
        KlF6K+nFIBzDW3nnjsR+tU/1aSL8B4TEI1z94h8ffvBrtm3jo1XO87xWLzphk3R8ka9y7K22
        JXWMjC0SzJ037NeYq7Xx32gVNCoWcarySnwreqwt58He+6/P6Z4IFImzXLfONDj31uxpL587
        y6fvidl5YL4SS3FGoqEWc1FxIgCo9QBnJQMAAA==
X-CMS-MailID: 20210917065523epcas2p39e18203beafe9377e9dac819f01b804f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p39e18203beafe9377e9dac819f01b804f
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p39e18203beafe9377e9dac819f01b804f@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, ufs_hba_exynos_ops will be used but this patch supports to
use custom version of ufs_hba_variant_ops because some variants of
exynos-ufs will use only few callbacks.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index e32f7d09db1a..a3160d9bd234 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1238,8 +1238,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 {
 	int err;
 	struct device *dev = &pdev->dev;
+	const struct ufs_hba_variant_ops *vops = &ufs_hba_exynos_ops;
+	const struct exynos_ufs_drv_data *drv_data =
+		device_get_match_data(dev);
 
-	err = ufshcd_pltfrm_init(pdev, &ufs_hba_exynos_ops);
+	if (drv_data && drv_data->vops)
+		vops = drv_data->vops;
+
+	err = ufshcd_pltfrm_init(pdev, vops);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 4f93db893ce8..bc4b8b0324bd 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -142,6 +142,7 @@ struct exynos_ufs_uic_attr {
 };
 
 struct exynos_ufs_drv_data {
+	const struct ufs_hba_variant_ops *vops;
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
-- 
2.33.0

