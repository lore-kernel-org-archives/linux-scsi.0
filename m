Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED9AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A586112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbhIQG4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:56:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41835 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbhIQG4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:50 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp03e7c78c64e6ec52dcbdea1580c1e9d0b2~liZgkdAsV0358503585epoutp03u
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210917065526epoutp03e7c78c64e6ec52dcbdea1580c1e9d0b2~liZgkdAsV0358503585epoutp03u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=SF+TylNwyR/U94tOLtMFIcw7poD6m/7jdfvpy1q2hMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvo1Y2F9OR6HbuxsKsleV53UQox19y0TjUe7P1XRtEuUhUEpcDvRaF+LCgQvQkL0b
         HJN3MQp4rOIZrsD9FyDBLr6OYopH3jxPjWqHoZnQQc87DjGdKlvlY7uH77jbBj1uzx
         KHrAHZXkC8t1qmotrHEMZzYa8WK0XIuTTgnEXMN8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p4d34ef2541e92be5165116c7b357b0a0e~liZfzrddt1927619276epcas2p48;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H9l8D296Fz4x9Qb; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.C4.09717.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p2cb63cd8924be44e6eaa42c7213bd15d4~liZeC0nzu3235032350epcas2p2u;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp1f02db5f0d43ea2d15203efb7f868467a~liZeAyYDN1045910459epsmtrp1C;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-fb-61443bdcc533
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.91.08750.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip29eaa470d0182145e5d0407014d75ed69~liZdxsq0T2196321963epsmtip2q;
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
Subject: [PATCH v3 12/17] scsi: ufs: ufs-exynos: factor out priv data init
Date:   Fri, 17 Sep 2021 15:54:31 +0900
Message-Id: <20210917065436.145629-13-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxTOfa88Hsy6Z2HujmTYvUWdMLDt1vrYYDIt5mWWpRtbwtQFn/As
        hNLWvmJ0mQkqUEqHK8EMrUqwTLexSTNWGAIKQgEBI2TMMDo2fioBg1KQACboWh5m/Pfdc77v
        fOecey+OivqxMDxDZ2KNOkZLYsGC2tZtiqjB95WMpLHtJapz/BeMGi6rxajJpXsYdWvEIqC+
        m1lCqVnn1QCqrymS+ub6bqrb5kCocacdpRx/1SLUr9OLCDXgahNQ53puIpS1vw6jfuh4hsQT
        dN+fe2l7ThFG950pQujffoygKxonEbq60oLRNkczoBecBRjtve8R0GdclYCeqw6nzc1WRL1u
        nzY2nWXSWKOY1aXq0zJ0mjhyb1LK7hS5QiKNksZQO0ixjsli40ilSh21J0PrG4kUH2W02b6Q
        muE4cvsHsUZ9tokVp+s5UxzJGtK0BqnUEM0xWVy2ThOdqs96TyqRyOQ+5kFtetXELoNFeKw7
        rxfNAfPBhSAIh8S78OJ1c0AhCMZFRB2A08tulD/MAlg+5Bb4WSJiDsCJVukLRelPYwKeVA/g
        vPnBqtwL4LnBWeBnYUQUdE1MAX8ilHgM4PjY2UD/ASXsKOyYL0H8rBDiI1h7JRfzYwGxGZ4d
        WfKRcFxIxMPc74283SbofmpB/TjIF/bUP18xEBIbYOf58ZX2UB/ndM0FlOcP4vDBQry/DCSU
        8MZ5JR8OgVMdrkAeh8HJb/NX2oGEFcC80eeriZ8BtJxU8XgnfFrqCvDXQYlt0Fm/nS/5JnR7
        Vl3Xw4LW5UA+LIQF+SJeuBU2/14q4PHr0HpxLoDHNPTcWgD8qkoAXD65iNqA2L5mGPuaYez/
        G5cDtBJsZA1cloblZAbp2vutBisvPCKhDpRMz0S3AAQHLQDiKBkq7P36Q0YkTGOOf8Ua9SnG
        bC3LtQC5b9PFaNgrqXrfF9GZUqRymUIhiZFTcoWMIl8VXnq2ixERGsbEZrKsgTW+0CF4UFgO
        4rgcyfTnKU5UZi5lJAWwTdWF5qq2fVWR5X0PNd7AwnDRFwk9SpXqwOEok0qyObkm5BQTcmzj
        qGdPeM5U58cFSTOn74vWDXQ/kV0aeGQb7rKb27lP0X+9Mm/7tUP2e1/2DHdP3sjcEh05Wawq
        Wu+yLJRgaUNHb1sTX7ZqTmGDZnfTTWf+zKHghr7l0C5mZ/LnivrYz9ovW7F//lbb6Ib85iuP
        3r5bkRi344/p0cYjFbdLTiQ8HtAU944PZdE1KrVz/8PpxFH9G3cPWAzFMdWaC7RF07XYcuSw
        OAUZId9pYLd+0ij1XHvNfkdTdnVTRNnx/WNv5T6ppe44DnZ6DJ700GRSwKUz0gjUyDH/AdZ3
        2K1qBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEgwuTNSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlbHuuVNBJ2/F6dYL
        zA2MX7m6GDk5JARMJKavfMzSxcjFISSwg1Fi1tH3rBAJWYln73awQ9jCEvdbjrBCFL1nlDj5
        /igzSIJNQFdiy/NXjCC2iMBHRok537RAipgFljBLNB6YxwSSEBbwkti2tIUNxGYRUJWY8vAn
        0FQODl4BB4mWJUUQC+QljvzqBJvJCRS+tes/2EwhAXuJiZMXgdm8AoISJ2c+YQGxmYHqm7fO
        Zp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjB0aaltYNxz6oP
        eocYmTgYDzFKcDArifBeqHFMFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZq
        akFqEUyWiYNTqoGJW+TKmyeebRtKbvzrLT61zjZrgg+T/M2kzU/OFXF2attYsZmLnZvU5ris
        YhIjb8Z0nfPi3zr05nLKBOhITb4fFr9Q8Ib1542y05vm/nKbvcsk3fqL+It9Jo0JbhMjYrZ3
        +hz5HRaT1nnT85nsRUFeRrdpri+a2c3nPF3363MsVwXf+eIdTw/a3LjBFjFt5pS6uO0rJ/3d
        4ml8M2Sq3strdax//d41sKpemM5vdqi4g+PUy0SlwxWc5247/e9KXfVg55zt+9hyZ55JO8PR
        HuvlL767ud3iu7oom0tawXXeVM3LE20+Xzx2fOofjgVSJ7f++e/2lHPxA6WP3lv0ebp3y/53
        CxEX5Qyy6Y21bT2gxFKckWioxVxUnAgAx0iLXyUDAAA=
X-CMS-MailID: 20210917065523epcas2p2cb63cd8924be44e6eaa42c7213bd15d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p2cb63cd8924be44e6eaa42c7213bd15d4
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p2cb63cd8924be44e6eaa42c7213bd15d4@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be used this assignment code for other variant exynos-ufs driver,
this patch factors out the codes as inline code.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 73833c186ca9..753b22358186 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -951,6 +951,18 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 	return ret;
 }
 
+static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
+					struct exynos_ufs *ufs)
+{
+	ufs->hba = hba;
+	ufs->opts = ufs->drv_data->opts;
+	ufs->rx_sel_idx = PA_MAXDATALANES;
+	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
+		ufs->rx_sel_idx = 0;
+	hba->priv = (void *)ufs;
+	hba->quirks = ufs->drv_data->quirks;
+}
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
@@ -1000,13 +1012,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	if (ret)
 		goto phy_off;
 
-	ufs->hba = hba;
-	ufs->opts = ufs->drv_data->opts;
-	ufs->rx_sel_idx = PA_MAXDATALANES;
-	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
-		ufs->rx_sel_idx = 0;
-	hba->priv = (void *)ufs;
-	hba->quirks = ufs->drv_data->quirks;
+	exynos_ufs_priv_init(hba, ufs);
+
 	if (ufs->drv_data->drv_init) {
 		ret = ufs->drv_data->drv_init(dev, ufs);
 		if (ret) {
-- 
2.33.0

