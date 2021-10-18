Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED61C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94CAC60EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJRMrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63896 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhJRMrY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:24 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211018124509epoutp041aefb2ec6b1b3a6fa3c4c42b21f49ecf~vIKsyErpC0084700847epoutp04E
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211018124509epoutp041aefb2ec6b1b3a6fa3c4c42b21f49ecf~vIKsyErpC0084700847epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561109;
        bh=xLivwsWbFoOvzAMprtaF5HPMWnZzSR74VzNY3pKyuHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hbl4NkqtM9nHNIOVurZIhxp5ZYeGBV4c6aelzjxchU8Xhwx7JZMnfucCqbuSVmj3k
         Yr63QQmvvMwfWSvisEnHZC+g71fub5oOh6QvpQMhOwJJtqJ7t8t9V8NyqdtpSjY/kW
         fB5OaHAoaWrYlfq48TVmprO/ppumHUAGFr+/l/Co=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211018124508epcas2p489a202c517805dac71e37b39a0deef70~vIKrl-cxS2241122411epcas2p4W;
        Mon, 18 Oct 2021 12:45:08 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.88]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HXxRP6wNSz4x9Pv; Mon, 18 Oct
        2021 12:45:05 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.2C.10014.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p22a463738c9ee028274be7ad06ed97a0d~vIKpChUHj2030920309epcas2p2D;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp165d9e15d896f695d1addfb303bbff9bf~vIKpBmunM1580315803epsmtrp1M;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a47-489ff7000000271e-89-616d6c51f153
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.40.08738.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip2b3872f440f8f73402b96a17cee80a8ff~vIKozFstg0224202242epsmtip2h;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
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
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v5 04/15] scsi: ufs: ufs-exynos: simplify drv_data retrieval
Date:   Mon, 18 Oct 2021 21:42:05 +0900
Message-Id: <20211018124216.153072-5-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzOube9Lc3KLkXmSc0cXrLIY0ALLRyYgBls3k0Smc69EgfXcqWk
        z7QFH9scYmS8QVxEyjYX5hDZJoFRQGU8CgyJUTeqE8hAkcoGatQyH6DI2l62+d/3+53v+36P
        c44Ql4wTUmG23sKa9IyWIkS8tr4QFP62VsfITj6IQUPOHwh07es2As3MXyZQ72QRDx2+O48j
        V1M9Hzm6w1DpqWR0rrIOQ84mK47qRtowNLJQwEfNtx9h6MjFLgyVXOkg0PHBpxh6PG/H1vvR
        jksbaWteGUE7yssw+qeGUPrbzhmMbmksIujKuh5AP2wqJOh7N8Z4dHlrI6DnWlbTn/eUYGnP
        fahZp2aZTNYUyOpVhsxsfVYCtXFLenK6MkYmD5fHoVgqUM/o2AQqJTUt/I1srXsuKjCX0ea4
        U2mM2UxFJq4zGXIsbKDaYLYkUKwxU2uMNUaYGZ05R58VoWct8XKZLErpJmZo1LeOLgLjsN+u
        o2cPEnlg2rcY+AghqYAlfb38YiASSsgOAJ/aDgAucAE43ehaDuYAdN14QhQDoVfSfcbI5U8D
        WHa2UMAF9wAsPzlIeHwJMhy2/jnrVa8g7wDonPrCy8LJHhxOnZrne1j+ZCrstJ33Yh75Mvyl
        vcOrFpNJsHNyDHAdvgT7F4pwD/Yh18PSun6M4/jBoRonz4NxN2e/rRb3FICkUwgnHzkA12sK
        PDwq5Hz84exgq4DDUjhTUSDg+CUAHri+tHzwPYBF+1I5nAQXqlv5Hh+cDIFNpyM5yyDYP7Zc
        1hcW9i0KuLQYFhZIOOFa2NNezePwi7Dkyzk+R6HhiQoNt6tD7pUM1AoqQaD1mWGszwxj/b/u
        NwBvBC+wRrMuizVHGaP/u2GVQdcCvO88dEMHOHL7boQdYEJgB1CIUyvE21/XMRJxJrN7D2sy
        pJtytKzZDpTuVR/EpQEqg/uj6C3pckWcTBETI4+NUspiqZXiuAANIyGzGAurYVkja/pXhwl9
        pHmYYDhEpb6YUfmd6PzMxK9UaVfjzm3Nt3Z/taVK00YOWxsWqyKT/oY3g6X3Hw+5jhVpC9cc
        f996TakpvdDQtiPkQm9nforMVS+69PNUQfdVFxHlG1fbX/1H/B4qCNQmTHQxYS3j/gO5q2aq
        t79SWVGfAS3jqVufd5a/d2csuqq5TJm/17bhxNpPEjflil6bIIIcDVupqr+QgtncHWZXsCmR
        O1dJNr1ja9/mEzNlwj+u+fHcmzevjK68f2ZIl/dZ9FtXax+MTmetGciI3x+buReIflvKGb68
        Otkm+WjXE7Hm4e8Nm/N6PghIHF+q2vdu8CHZSLAKlC0cAzs+zYfo1Zr++OuzeopnVjPyUNxk
        Zv4BjADV93AEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwZ3D/BYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZzDi/j8mi+/oONovlx/8xWfz+eYjJQdDj8hVvj1kNvWwel/t6mTw2r9DyWLznJZPHplWd
        bB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAJ4rLJiU1J7MstUjfLoEr4838v4wF
        lwQr5p+YyNbA+Iyvi5GDQ0LARGL/7oIuRi4OIYEdjBJPp29l7mLkBIrLSjx7t4MdwhaWuN9y
        hBWi6D2jRPvULrAiNgFdiS3PXzGC2CICHxkl5nzTAiliFjjFLLF23SYWkISwgI/Enq1nWUFs
        FgFViWPbd7CB2LwC9hJ7Ht5ihNggL3HkVyfYUE4BB4meRUeYQGwhoJrFL2czQ9QLSpyc+QRs
        JjNQffPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOPK0
        tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeJNfcRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJ
        pCeWpGanphakFsFkmTg4pRqYulVOvWt1UNDslC7gfqXj8nTBm3W6HY0hFy7aiejaGHo9KEuQ
        Klg1k4s7ZJXZHo2pf159mzFlUtr/CjcTdSEftao1hb/fZB96Na9rkflurR8icqc3883r10+K
        WFX994/5SZ+cGMGXSyz6jzzjFG98aT69gzPtl/uzIrXa2v2HE05xKZTF73PziSle+khDbHdv
        Ykyp8u5mmy2HAnlm9t+PqnxawajW/VvJ1OPKxLfS348lu38pr+b5uoovPVrhjODR/ND7qt/0
        c5+XXPnvMWtGcPNy14pkx7TnUl57L/A4/rddxGN1YF6B2YEv1x+9axAUW2j967XcviuxDlMc
        pZlZDimsff1mnpP9khUJnR1KLMUZiYZazEXFiQD9ZT5mKwMAAA==
X-CMS-MailID: 20211018124505epcas2p22a463738c9ee028274be7ad06ed97a0d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p22a463738c9ee028274be7ad06ed97a0d
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p22a463738c9ee028274be7ad06ed97a0d@epcas2p2.samsung.com>
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
index 30d0c1aba0c7..57210114ca0a 100644
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
@@ -1262,7 +1255,6 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
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

