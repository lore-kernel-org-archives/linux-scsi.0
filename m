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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D039DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3DB6112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbhIQG5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53796 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp01992b20c60cfd1207915154796ca9b438~liZgSTCK10654606546epoutp01k
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210917065526epoutp01992b20c60cfd1207915154796ca9b438~liZgSTCK10654606546epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=kDPUu0crvjpJeXBJprcRYTsG7RPKldzeF7DRZzQcczY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1+O3BtY0ej1urAGLbZHUSZW5CC7lWgyoxyOcN51x5zIN9gvac3MIyJZeqbnyeI0v
         eEfSvxSwe3LOzWaM3EJ2pgo3gyf+xDCziwY1b5Dko2Eyite+/Ue+QHoOzoGftHRjdk
         ILAzFFQEBIeZvoZKPjv6O3xfpSPeQ0uiA/xmYuU8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210917065524epcas2p1c5c9ddd011b647c801fea4b70b2dd950~liZfJElRW0789407894epcas2p1I;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4H9l8C4djvz4x9Q9; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.ED.09749.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epcas2p23066a1bd5e39ac1931d7e38064fe23dd~liZdRbJCQ3234832348epcas2p2y;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065522epsmtrp14974d9d3257d9518b8210895f7fab11f~liZdQddmF1077210772epsmtrp1o;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-ac-61443bdb4b73
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.91.08750.ADB34416; Fri, 17 Sep 2021 15:55:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip2955dcd33c243ca12f27a90463dbd3842~liZdCqE5x0630106301epsmtip2j;
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
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v3 04/17] scsi: ufs: ufs-exynos: simplify drv_data retrieval
Date:   Fri, 17 Sep 2021 15:54:23 +0900
Message-Id: <20210917065436.145629-5-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJsWRmVeSWpSXmKPExsWy7bCmue5ta5dEg8OtShYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyWLj2x9MFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
        lhbmSgp5ibmptkouPgG6bpk5QN8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoM
        DQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMpZ+3stYcEmwYsG5g0wNjM/4uhg5OSQETCTOHP/P
        2MXIxSEksINR4lrfR1YI5xOjxIbOF+wQzmdGiXWHG1hgWiacfA7VsotR4su0b0wQzkdGiVvT
        DzCBVLEJ6Epsef4KrEpE4D2jxJPHU8BmMQt8ZZLYffA7G0iVsICPxPw1y5hBbBYBVYnfL56y
        g9i8AvYS136eYYTYJy9x5FcnWA2ngIPErV3/GSFqBCVOznwCdhMzUE3z1tnMIAskBC5wSKyc
        eIwdotlF4vehC0wQtrDEq+NboOJSEi/729ghGroZJVof/YdKrGaU6Gz0gbDtJX5N3wIMDw6g
        DZoS63fpg5gSAsoSR25B7eWT6Dj8lx0izCvR0SYE0agucWD7dGhwyUp0z/nMCmF7SKx63MUG
        Ca3JjBJ7Oy4yT2BUmIXknVlI3pmFsHgBI/MqRrHUguLc9NRiowJj5EjexAhO4VruOxhnvP2g
        d4iRiYPxEKMEB7OSCO+FGsdEId6UxMqq1KL8+KLSnNTiQ4ymwMCeyCwlmpwPzCJ5JfGGpkZm
        ZgaWphamZkYWSuK8c/85JQoJpCeWpGanphakFsH0MXFwSjUwtcle6vMR4gnxv/HTzH7jkc/r
        H15qyPeel3ojawpLW1D99eNrArhmlHifeD/lk9O7B9eZNj90kP7U9nWRodkezoja8taL/5Pe
        aGfumqSZNFNl+dHSrLDunNwXjUUf53K2NqpsnvYs4VDH/RmMOuzOZmmCbukuGrOCLOoWz2tP
        PG9n4aL66DGnl0dLKGNItMBM1VXP1XlNLtaY+q8tu7EsyOVXqts2MfWomxGZbXpM/5625LKy
        HXe3+S8VpreyzHiryYe66GNXjb82nVqjuvNH5gRGvr72SYIC0j8OTb6buzF09/R/h4Me/Pr6
        dTXX9Y+b7cVCi3bJNOTqnjl19M/FW2HlEft7An/fit8qe1hLiaU4I9FQi7moOBEAfIYi+WoE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXveWtUuiwfm7JhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyWLj2x9MFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBlLP+9lLLgkWLHg3EGmBsZn
        fF2MnBwSAiYSE04+Z+xi5OIQEtjBKHHyzlkmiISsxLN3O9ghbGGJ+y1HWEFsIYH3jBJH+1JA
        bDYBXYktz18xgtgiAh8ZJeZ80wIZxCzwl0mitXUD2CBhAR+J+WuWMYPYLAKqEr9fPAUbyitg
        L3Ht5xlGiAXyEkd+dYLVcAo4SNza9Z8RYpm9xMTJixgh6gUlTs58wgJiMwPVN2+dzTyBUWAW
        ktQsJKkFjEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCo0xLawfjnlUf9A4xMnEw
        HmKU4GBWEuG9UOOYKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgs
        EwenVAMTJ9u5Z7KN1xeHqfQGH5NV0fRvO1P23cKne9vH4/mTZyck3Xmg/mjuRuWktYeTrH0a
        VsZGX8veLL1eX+aPYaaLp31y4kap3qkVNsZyjyuOtXclXFf+8dgieZvycR5mTfYF/PaxpUeN
        La/Kpv28eXhemZvw8ft5BX3st81WXtpksPCls0DdhGlivXuL06v/cHWrMglf1G//tnnR7adl
        D3c5tYe9/+7+QuxIRqvMdC39NXvZVi5N6v4jGvPKf21T9Cl5Di1/Pv2zKxOPOelEHdgV/e+p
        dsGbfintWo4DYudiP9ZMEetcLlItEVgta5bU5ujMcSbiiUzMlRNB1XIyKkez5ZdePCP5/GzJ
        NeP/P5VYijMSDbWYi4oTAQh+WOAhAwAA
X-CMS-MailID: 20210917065522epcas2p23066a1bd5e39ac1931d7e38064fe23dd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p23066a1bd5e39ac1931d7e38064fe23dd
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p23066a1bd5e39ac1931d7e38064fe23dd@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The compatible field of exynos_ufs_drv_data is not necessary because
of_device_id already has it. Thus, we don't need it anymore and we can
get drv_data by device_get_match_data.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 +---------
 drivers/scsi/ufs/ufs-exynos.h |  3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a14dd8ce56d4..8a17ba32a721 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -893,17 +893,10 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 {
 	struct device_node *np = dev->of_node;
-	struct exynos_ufs_drv_data *drv_data = &exynos_ufs_drvs;
 	struct exynos_ufs_uic_attr *attr;
 	int ret = 0;
 
-	while (drv_data->compatible) {
-		if (of_device_is_compatible(np, drv_data->compatible)) {
-			ufs->drv_data = drv_data;
-			break;
-		}
-		drv_data++;
-	}
+	ufs->drv_data = device_get_match_data(dev);
 
 	if (ufs->drv_data && ufs->drv_data->uic_attr) {
 		attr = ufs->drv_data->uic_attr;
@@ -1258,7 +1251,6 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 };
 
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
-	.compatible		= "samsung,exynos7-ufs",
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
 				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 0a31f77a5f48..2e72aabaa673 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -142,7 +142,6 @@ struct exynos_ufs_uic_attr {
 };
 
 struct exynos_ufs_drv_data {
-	char *compatible;
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
@@ -191,7 +190,7 @@ struct exynos_ufs {
 	struct ufs_pa_layer_attr dev_req_params;
 	struct ufs_phy_time_cfg t_cfg;
 	ktime_t entry_hibern8_t;
-	struct exynos_ufs_drv_data *drv_data;
+	const struct exynos_ufs_drv_data *drv_data;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.33.0

