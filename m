Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14200C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD13600AA
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhIQG44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:56:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41801 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbhIQG4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:50 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp0320b30eba27f1abcd08f997e728a392a8~liZgLgRGQ0483304833epoutp03q
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210917065526epoutp0320b30eba27f1abcd08f997e728a392a8~liZgLgRGQ0483304833epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=ap+yuWyfl67dRUQsKZ/Oj0RoVKze2lfX+0XLDDz/qRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0gwicquT1SYcTP+JmnxVDcDPTnkdGUOtN0SlcbpXXVWhlbst4oLVH6/qi4EsE+ZJ
         Czfu8DZvqCZPcR2LWQH7YQA/1bDW4sYCQ73yY5wl2G6LKm2PW/DMAmH4E2XH0OMK6e
         018JdT98iWXr438VLBwhBa2bPkpkna2LMZ5PeqOk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p3413cb125d963e12fd8b7158107f53f75~liZfZplkf1851718517epcas2p3d;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4H9l8D0mPdz4x9Qf; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        8B.ED.09749.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10~liZdenXbC2819628196epcas2p4Q;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp22cdec2b6cb2696da9f12777a7931d41b~liZddlrYZ1371513715epsmtrp2Q;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-ad-61443bdbf8b7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.10.09091.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip229baf36f4c88114e65be6a2a0b524922~liZdO41fK0630106301epsmtip2k;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
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
Subject: [PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Date:   Fri, 17 Sep 2021 15:54:25 +0900
Message-Id: <20210917065436.145629-7-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJsWRmVeSWpSXmKPExsWy7bCmhe5ta5dEg31vjSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEnY17fbOaCKzwVPxtnMTUwPuPqYuTkkBAw
        kbiwfQVrFyMXh5DADkaJl49us4AkhAQ+MUp0/OKFSHxjlHh1ro8VrmPzUaiOvYwSl28dY4dw
        PjJKTHlxD6yKTUBXYsvzV4wgCRGB94wSTx5PAatiFpjFLHH862QmkCphgVCJ1z29zCA2i4Cq
        xJqu+2BxXgF7iZ1z1kPtk5c48qsTrIZTwEHi1q7/jBA1ghInZz4BO5YZqKZ562xmkAUSAjc4
        JHbe3sAO0ewi8bZpCQuELSzx6vgWqLiUxOd3e9kgGroZJVof/YdKrGaU6Gz0gbDtJX5N3wJ0
        BQfQBk2J9bv0QUwJAWWJI7eg9vJJdBz+yw4R5pXoaBOCaFSXOLB9OtRWWYnuOZ9ZIUo8JO6e
        TYME1mRGidsX17FPYFSYheSbWUi+mYWwdwEj8ypGsdSC4tz01GKjAmPkKN7ECE7kWu47GGe8
        /aB3iJGJg/EQowQHs5II74Uax0Qh3pTEyqrUovz4otKc1OJDjKbAsJ7ILCWanA/MJXkl8Yam
        RmZmBpamFqZmRhZK4rxz/zklCgmkJ5akZqemFqQWwfQxcXBKNTAts2jkmRmR9/64G6fI81dS
        bWtX8531uBRyakbpv8X8F0pPa98u+JH0ZkcEQxWTp/uDlyIxz9rMIxT43mlm+367JXPT8OOt
        LKOjF0+0RhY5im0Oe/YhyOZ3Fzcz8+XmXF3PmsIjFVWHfbc/y3dOXfF5q8FD3jUnLlTP5HS7
        +1W6dsmq70syVdZ63Nn3KWJKkEDm4f3fOObbdIjNnhl6c2eL7G9bph+1MrM0HktaT5mu3P/n
        gnD2ad8zd/89nuwalKWgsE6t7uMmsS27Y6r42xraXFearPiXWll1ctN5u2OTxQo8Tsya9cgj
        ZCtzt3VtrbH5igt3Fj9/OSF8ntTyc8wvLV8xVk1Q74hO3vfn8WpNJZbijERDLeai4kQAzm8h
        tW0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg1ntbBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyWLj2x9MFje3
        HGWxmHF+H5NF9/UdbBbLj/9jchDwuHzF22NWQy+bx+W+XiaPzSu0PBbvecnksWlVJ5vHhEUH
        GD2+r+9g8/j49BaLR9+WVYwenzfJebQf6GYK4InisklJzcksSy3St0vgypjXN5u54ApPxc/G
        WUwNjM+4uhg5OSQETCQubD7K2sXIxSEksJtRYmlrAwtEQlbi2bsd7BC2sMT9liNQRe8ZJb40
        bWAESbAJ6Epsef4KzBYR+MgoMeebFkgRs8ASZonGA/OYQBLCAsESfVtPsILYLAKqEmu67oPF
        eQXsJXbOWc8KsUFe4sivTmYQm1PAQeLWrv9gQ4WAaiZOXsQIUS8ocXLmE7DrmIHqm7fOZp7A
        KDALSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBEaeluYNx+6oPeocY
        mTgYDzFKcDArifBeqHFMFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFq
        EUyWiYNTqoEpSGO/i+C+FD0/geAVO7Prl7/5rXfqlIKjfu3BZ+EL208c+aPVEH7lid1BGR+3
        8OJZYcxrfk6OCIk5187mbmmzSstQbnZQ9crmt+Evp85ds9b6pvu+f8/EZCQWbBLd0L7wVH/Z
        rPYZrCoKOc923eo+Xc5jm+HZr7q6M0F4tuuyjvUbsgsXSl2/fWuXi+6f6ScEPjArNNdk3vqW
        pHRE4vXkDc9nc1ecO6q8sU7+1/33p5de2mSxyKpF3OXBdcNdx/v9T6zrmMjZcIrbs0XJjNng
        X5HiqY9dD9IkshKXdf1KkxDc8/lcZ2L0jOniHFduT5qo27jq0dyuME5Wt3LVJRH5XAzubLMn
        Jk+0iOuVS3FXYinOSDTUYi4qTgQAA55B8CcDAAA=
X-CMS-MailID: 20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS_EMBD sharability register of fsys block provides "sharability"
setting of ufs-exynos. It can be set via syscon and regmap.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 5 +++++
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 8a17ba32a721..f7a1b99c823b 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 
@@ -906,6 +907,10 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 		goto out;
 	}
 
+	ufs->sysreg = syscon_regmap_lookup_by_phandle(np, "sysreg");
+	if (IS_ERR(ufs->sysreg))
+		ufs->sysreg = NULL;
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 2e72aabaa673..4f93db893ce8 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -191,6 +191,7 @@ struct exynos_ufs {
 	struct ufs_phy_time_cfg t_cfg;
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
+	struct regmap *sysreg;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.33.0

