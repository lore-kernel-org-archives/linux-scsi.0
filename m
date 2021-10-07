Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11957C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0720610CC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbhJGIOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30362 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbhJGIOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:11 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211007081217epoutp03302495616b99d527461d0013ae3a7c86~rsWT_FH-Y0809208092epoutp03j
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211007081217epoutp03302495616b99d527461d0013ae3a7c86~rsWT_FH-Y0809208092epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594337;
        bh=RHNEL+uqMVOTrqxwGcB+GdSm7nJo6SpMMQZK9pd61ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UicsZXe5oaLojS0c9xi6ilW6gS6iMgRklducpQs2P3Oi369zmnqqJfar0rBmhatG2
         60TW8jdsvTgsfp3x84/Yw6eB7bYKRLphr7/Aqt7rm9PW6RhBg/wOecuhGWFLU8RfT3
         Wr4fCYqiFoDZ/0SHiXBMPnN9G0q2u5xj8o/B61Kc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211007081158epcas2p1124cc6d82755192cd11f8e901030132f~rsWC_iQUc0386803868epcas2p1p;
        Thu,  7 Oct 2021 08:11:58 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.89]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HQ3vJ3Bqqz4x9Pq; Thu,  7 Oct
        2021 08:11:56 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.F5.09749.8CBAE516; Thu,  7 Oct 2021 17:11:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p2eb19706624f722e96aec7bbdda9f8e4d~rsVsox21p0847508475epcas2p2g;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp182a2f2646e8aa633c53c4d643630533d~rsVsnz2oY2192321923epsmtrp1q;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-7f-615eabc8b9ce
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.B7.08750.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip2dbc8bb689df510ba78e1f3a68697710a~rsVsbJume0566205662epsmtip2_;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
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
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 10/16] scsi: ufs: ufs-exynos: factor out priv data init
Date:   Thu,  7 Oct 2021 17:09:28 +0900
Message-Id: <20211007080934.108804-11-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmqe6J1XGJBo0XtSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCyuLnlKIvFjPP7mCy6r+9gs1h+/B+Txe+fh5gchDwuX/H2mNXQy+Zxua+XyWPzCi2PxXte
        MnlsWtXJ5jFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQJ4orJtMlITU1KLFFLzkvNT
        MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CeU1IoS8wpBQoFJBYXK+nb2RTl
        l5akKmTkF5fYKqUWpOQUmBfoFSfmFpfmpevlpZZYGRoYGJkCFSZkZ7zqWcZW0MFbMXHeV8YG
        xi9cXYycHBICJhLLG7cwdzFycQgJ7GCUuP20A8r5xChxYPpmKOczo8T2zW9YYVoOr13JBJHY
        xShx6vIjVgjnI6PEhAcNYFVsAroSW56/YgRJiAi8Z5R48ngKO4jDLPCUWWLej142kCphAS+J
        xz8vsoPYLAKqEm/mzgCL8wo4SHR3dTJD7JOXOPILwuYEiu/ZtRaqRlDi5MwnLCA2M1BN89bZ
        YMdKCDzhkHh87gzUsS4SU3c8YIOwhSVeHd/CDmFLSbzsb2OHaOhmlGh99B8qsZpRorPRB8K2
        l/g1fQvQIA6gDZoS63fpg5gSAsoSR25B7eWT6Dj8lx0izCvR0SYE0agucWD7dBYIW1aie85n
        qGs8JK6u2Ai2SEhgMqPE5hehExgVZiH5ZhaSb2Yh7F3AyLyKUSy1oDg3PbXYqMAYHsfJ+bmb
        GMHJXct9B+OMtx/0DjEycTAeYpTgYFYS4c23j00U4k1JrKxKLcqPLyrNSS0+xGgKDOuJzFKi
        yfnA/JJXEm9oYmlgYmZmaG5kamCuJM47959TopBAemJJanZqakFqEUwfEwenVAPT1oz9wWn6
        VjlLYzu3ytqv33g80OXGmxjWJ8t/533+8P7OOX3TWRun1v7cr8r9SLR9WtGLMi6bJ85TJHJO
        Lu64s+PhBLtbinLbiuWl5JQfzFbLd5TQLvy47GXg26O2Xg+uLk0PWhMRcrd2Tv/zae2Sa17I
        1bhM+D9R4+jhIzJnRecYtpy7+l/FIzNDR+TOjKc8JlXa7e7H81ak/eedHc8sYN7MbXW07q2p
        4+MIBr5laRdnWf1+Yz7hboyKjrMZY03YynuOV+xPiKbuuyf8Ty82KGPqdrEHOcdeFDJxMqgz
        5Yu+2vy3M9Tb+0hK1eu30lsO1li0L02wfNPdpDP/yfT6ZUY7D1c4RefbfYtzPLVYiaU4I9FQ
        i7moOBEAR+DmJncEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBq2PDCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCyuLnlKIvFjPP7mCy6r+9gs1h+/B+Txe+fh5gchDwuX/H2mNXQy+Zxua+XyWPzCi2PxXte
        MnlsWtXJ5jFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQJ4orhsUlJzMstSi/TtErgy
        XvUsYyvo4K2YOO8rYwPjF64uRk4OCQETicNrVzJ1MXJxCAnsYJRouNjDDJGQlXj2bgc7hC0s
        cb/lCCtE0XtGiRmP17KCJNgEdCW2PH/FCGKLCHxklJjzTQukiFngI7PEnZVLWEASwgJeEo9/
        XgSbxCKgKvFm7gw2EJtXwEGiu6sTapu8xJFfEDYnUHzPrrVANRxA2+wluv5GQpQLSpyc+QRs
        JDNQefPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOAa1
        tHYw7ln1Qe8QIxMH4yFGCQ5mJRHefPvYRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJ
        pCeWpGanphakFsFkmTg4pRqYDPWXcwWuKSjW3xsklNe/ra3B1r34+i0JN4H6NIU+9w2ngvd+
        c86eVhMivvG257nEvnMfS8r1CpSvLp2/isWoW2uDrPeUa40J1z7luJ9e7Sd389veBaz6rjUK
        TBZfMk4/OHkiMDePbbvIvjsSysZqd98WT31rYa6VyFYs5jCrZ8fCaz0hKaqTJJsed8RcNuPq
        U8qzfsq+/4jPz24Wc/OGfbqMG1/miR5onxKl6bTV3CnKRXuLzk9DhebLkXetr0pcnslyJnSl
        8lrnGWJTvy4/IJAfstv9o9qjrt2GUnO9GtuKMyY6B19huvhbfpOFRNXks5yyJTlRFzQuaCof
        zs5dEl0r8U7qbc6xP3c3RCuxFGckGmoxFxUnAgBynXU/MAMAAA==
X-CMS-MailID: 20211007081134epcas2p2eb19706624f722e96aec7bbdda9f8e4d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p2eb19706624f722e96aec7bbdda9f8e4d
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p2eb19706624f722e96aec7bbdda9f8e4d@epcas2p2.samsung.com>
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
index 72ab98d42dc8..2dae90758f8f 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -946,6 +946,18 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
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
@@ -995,13 +1007,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
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

