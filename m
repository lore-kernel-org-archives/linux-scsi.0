Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C0AC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA496128D
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhGIHAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41958 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210709065749epoutp02229d8ce9d48a30cf3082d7587b455f71~QDRnJr24J2763627636epoutp02u
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210709065749epoutp02229d8ce9d48a30cf3082d7587b455f71~QDRnJr24J2763627636epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813869;
        bh=Wu8TqxvPA+Vqp2is3Nyz/sLJwbNinTm0v9TtF+ZsUxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKKmePlgsyb535Dp7Osj8m7a62kpG44wzVOwNivyVfC9NElzzErT9DSkmjq7UmU0v
         MtWVsIm49JA1UNax0esR/mYjOyGzUfyNIbCYQSMtMmwkp4Qtr8Ka/2KkiS2nr5ebxx
         xWkxigHkBNJ+xTBmS3/6Ub5V9+OnPFvqStjE6zd4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210709065748epcas2p2ff79e2b27e4ded879ff9fb6e05cbb1eb~QDRmGb-Jv1001710017epcas2p2D;
        Fri,  9 Jul 2021 06:57:48 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GLkWH2ktRz4x9Q1; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.A3.09921.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p4cd871004fa034dace5046a8acf1d1b96~QDRkDi3XV1603316033epcas2p4h;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp1e0a12f528b44ac09ae54f9bf157a6b05~QDRkCe_Rw3220632206epsmtrp1U;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-95-60e7f36b5cee
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip294c62decd5b2ec324ae045c549781a6f~QDRjy-BDU3134631346epsmtip2w;
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
Subject: [PATCH 05/15] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Date:   Fri,  9 Jul 2021 15:57:01 +0900
Message-Id: <20210709065711.25195-6-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmmW725+cJBjPv8lucfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORnbry9iKjjMXbHw6TfWBsYnnF2MnBwSAiYSDW/6mLsYuTiEBHYwSqzY
        vY8dwvnEKPH752RGCOcbo8SXPT/ZYVquT/rJBJHYyyixd/lxKOcjo8TxO48ZQarYBHQltjx/
        BdYuItDPKLF8/1wWEIdZ4CSzxOkFB4FmcXAICwRJXNwRBNLAIqAqcf/xGjYQm1fATuLKx7XM
        EOvkJU4tO8gEYnMK2EvM+zGBCaJGUOLkzCcsIDYzUE3z1tlgX0gIHOGQeP3sBgtEs4vEoXcX
        WCFsYYlXx7dA/SAl8bK/jR2ioZtRovXRf6jEakaJzkYfCNte4tf0LawghzILaEqs36UPYkoI
        KEscuQW1l0+i4/Bfdogwr0RHmxBEo7rEge3ToS6Qleie8xnqAg+JCzMWQwNrEqPEkuYJbBMY
        FWYheWcWkndmISxewMi8ilEstaA4Nz212KjAEDmONzGCU7WW6w7GyW8/6B1iZOJgPMQowcGs
        JMJrNONZghBvSmJlVWpRfnxRaU5q8SFGU2BgT2SWEk3OB2aLvJJ4Q1MjMzMDS1MLUzMjCyVx
        Xg72QwlCAumJJanZqakFqUUwfUwcnFINTA58MU+3WO+RTxf8vP7E3I0Tlk9Un8L9rsnpn0bA
        gofL30dyes81SdD7v471uqL80p9Wa5lY9399OvO44LkXlT6SqrMCqt4WZUq8LHW5L8jVdshZ
        /+yyazkt2ebtnQdmTXyy6tqfn9srJq/x2Pxg/8z061euGmtFGBoz+F5bdbvGZFmKs7FkxpXU
        moD91jp2f9i3d+j6JC3NYDIvYp/ksURK6NlLO+MLjyRWs+xW4tna0/JY3qvl0Z7q2KjvwT91
        Gna0Oi35l7JPs/7Fy+13ZilO11SusrfxZOguYt4kcY4z/XPut5rw1LbjJhPS+dY84Qt/rHpn
        lVD9TqnC830n41nTbn18mBZ1UW47h0yJvBJLcUaioRZzUXEiACRA3XBeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg8c7JC1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfG9uuLmAoOc1csfPqNtYHxCWcXIyeHhICJxPVJ
        P5m6GLk4hAR2M0ps3/GGHSIhK/Hs3Q4oW1jifssRVoii94wSk74sZAJJsAnoSmx5/ooRxBYR
        mMgoseSeGEgRs8BlZolv064wgySEBQIkfh57DjaJRUBV4v7jNWwgNq+AncSVj2uZITbIS5xa
        dhBsKKeAvcS8HxPAbCGgmnsb9rFD1AtKnJz5hAXEZgaqb946m3kCo8AsJKlZSFILGJlWMUqm
        FhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIER5SW5g7G7as+6B1iZOJgPMQowcGsJMJrNONZ
        ghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MDVOn5a1f
        duX876gJ79aFhu88u5VHTX3m3N+ceZX8VRGqEgwWH1P7tOeqnjfMNfas7O00bZmx4EdUUv+j
        pbp7b8877+mosGPmYeMEr7TM77VzxP91ZRbmCk7eeUDw5J/ZlRPLRb9MLzm8nPmppXP0TLbJ
        +3vqBLvmWRcszYw2PHbDOskk3nMre+bX6vWKWfsZG2aIyR94pfdZQFT/Er9DcMh8Ac7E+v9H
        PdodD36LXVsf+Fmqcbtec6zNZoNYjUihiZdvKQVdmsdv/4Kd59Fft9eHk7f9rp38MWXBNBbf
        Y/a3kiSqNSPXcd96bsHO+eLQDxnXmGUsKUJz952I1xacaXiHb6vvWfFVRSs/VmUosRRnJBpq
        MRcVJwIAwmcKfRcDAAA=
X-CMS-MailID: 20210709065746epcas2p4cd871004fa034dace5046a8acf1d1b96
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p4cd871004fa034dace5046a8acf1d1b96
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p4cd871004fa034dace5046a8acf1d1b96@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS_EMBD sharability register of fsys block provides "sharability"
setting of ufs-exynos. It can be set via syscon and regmap.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 5 +++++
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index db5892901cc0..da02ad3b036c 100644
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
index 7bf2053f6e90..a46f30639f38 100644
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
2.32.0

