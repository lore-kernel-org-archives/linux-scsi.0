Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64DEC11F67
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C15E461260
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhGIHAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50491 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhGIHAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:36 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065751epoutp03f263a54270cf53b35e76333cc1eab964~QDRom_5N82653826538epoutp03G
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065751epoutp03f263a54270cf53b35e76333cc1eab964~QDRom_5N82653826538epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813871;
        bh=TzqmxWLzJw7YUlq6RtqJwNn05f8F68Wk3f4J2IILl0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lc5ynpU0asqw3AoBomly4kvDFxqUyBvYWf3BM6MRpOgy2vFVBRaKc0MMQbq525zMc
         6tI8ZtfqZa1D3TWC7aUBHmetvapf92nASWifOx6takOZV16FQbpZPVNcRl2GB/9qCa
         sHtvw43tcESL8boW4KnfzK1cthD3870P/t9MEzq8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210709065750epcas2p25da6afe8f8845a7f9098f925258a66e8~QDRoBhuGU1003510035epcas2p2K;
        Fri,  9 Jul 2021 06:57:50 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GLkWK3Lrkz4x9Pw; Fri,  9 Jul
        2021 06:57:49 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.CF.09541.C63F7E06; Fri,  9 Jul 2021 15:57:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p35975dfa47363d0ea792988047f83a0ae~QDRkYkXFR2002520025epcas2p3-;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp1db81e12a71d20945ee59c3848750f3af~QDRkXt-7M3220632206epsmtrp1V;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a47-5f3ff70000002545-14-60e7f36c99a6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2152a7ab400b2a5f98ac5a1a7f7cd2e6a~QDRkLgBkF3134631346epsmtip2y;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
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
Subject: [PATCH 09/15] scsi: ufs: ufs-exynos: support custom version of
 ufs_hba_variant_ops
Date:   Fri,  9 Jul 2021 15:57:05 +0900
Message-Id: <20210709065711.25195-10-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmhW7O5+cJBp9fMFucfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORmzJ99iLHjJXbFkx3vGBsZGri5GDg4JAROJacszuhi5OIQEdjBK3Dnc
        xAThfGKUuN7azwLhfGOUuNH/hw2m4/7iAIj4XkaJ/wsXskE4Hxkl1q+dwNjFyMnBJqArseX5
        K0aQhIhAP6PE8v1zwUYxC5xklji94CA7SJWwQKzE3jlNzCA2i4CqxK/Vq1hAbF4Be4kHCxaD
        xSUE5CVOLTvIBGJzAsXn/ZjABFEjKHFy5hOwemagmuats5lBFkgInOCQWHpnIjvErS4SL3+p
        QswRlnh1fAs7hC0l8bK/jR2ivptRovXRf6jEakaJzkYfCNte4tf0Lawgc5gFNCXW79KHGKks
        ceQW1Fo+iY7Df6E28Up0tAlBNKpLHNg+nQXClpXonvOZFcL2kFj1CcQGBdYkRom5024xT2BU
        mIXkm1lIvpmFsHgBI/MqRrHUguLc9NRiowJj5BjexAhO01ruOxhnvP2gd4iRiYPxEKMEB7OS
        CK/RjGcJQrwpiZVVqUX58UWlOanFhxhNgWE9kVlKNDkfmCnySuINTY3MzAwsTS1MzYwslMR5
        OdgPJQgJpCeWpGanphakFsH0MXFwSjUwLdhmnDOn+HlYcZGX0Kowock3w1teGlget3j+MpFp
        dfR1HoZzrZnxDzwfPHiVzhfdXZz1dQV7ondQQPvijGV2SeKT31ULRew1qpBdbBlwM3FewO13
        zvXObvOXSNgea9XYuCjqwPEA9iDvnv0rOzIU13vHf3+46sA+Bb/lciW9e9MkNSIazvv9XXGJ
        I1ZjuXFl4XYn5R23nj3eoPv3+vbgzowndz1jgn5fdXyS+0IyI+2QiDvn6X7jHyckUmqePHzG
        zP3mxQa7Aja29fM+HL4dYieaKpy4ySfw478Xq99nBh7Jv3H6odXRVLnl7YG1k6ZHXK559EA3
        4hHzHa4kgeytYi6rZZoXlstbM0gXPtdWYinOSDTUYi4qTgQA+kA2S1wEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEgwPvDS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfG7Mm3GAteclcs2fGesYGxkauLkYNDQsBE4v7i
        gC5GLg4hgd2MEk1NJ1m7GDmB4rISz97tYIewhSXutxxhhSh6zyhx+P9+sCI2AV2JLc9fMYLY
        IgITGSWW3BMDKWIWuMws8W3aFWaQhLBAtMS/VRdZQGwWAVWJX6tXgdm8AvYSDxYsZobYIC9x
        atlBJhCbEyg+78cEMFtIwE7i3oZ97BD1ghInZz4B62UGqm/eOpt5AqPALCSpWUhSCxiZVjFK
        phYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeTluYOxu2rPugdYmTiYDzEKMHBrCTCazTj
        WYIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTJ0lvZ82
        t11Q3nC+8GHdtu73+aULDsrPlEq6aVT7NTH8eF/QfINPmc9T/yQd3DJndyr72byMp0u+BM2Y
        LK4Zvzrf68Ein8N7nyx8nxJ7br/E1MvcZdO2ZAb+WZEXwiFYMbda/+dMp+/++xI2KXHsFt6u
        yRhXvSDtEk/ytLS1v6cldta1Lvtdvntm/TVF7bu+jRsDU38uyvP9nnInt8ckVfSjQ25qjkTI
        je3CxTtvLN1UszVgx++qLx2f52u+yWSTa4yfskPJdMnCpDMLr9mXej3TPGLR+7t2KnvzHIHW
        pDNtizeK5XC77LOcHhnosj4v8Qxr5IxIUWPDmqIDR0s36Gt9kFqxckPx+b3Z6pc+r1FiKc5I
        NNRiLipOBACKxgtCFgMAAA==
X-CMS-MailID: 20210709065746epcas2p35975dfa47363d0ea792988047f83a0ae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p35975dfa47363d0ea792988047f83a0ae
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p35975dfa47363d0ea792988047f83a0ae@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, ufs_hba_exynos_ops will be used but this patch supports to
use custom version of ufs_hba_variant_ops because some variants of
exynos-ufs will use only few callbacks.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 60edd420095f..90c0d7c85a13 100644
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
index a46f30639f38..0938bd82763f 100644
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
2.32.0

