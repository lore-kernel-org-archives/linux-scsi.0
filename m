Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F48BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C7660EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhJRMra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63932 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhJRMrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:25 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211018124510epoutp0409eaa0416f23a5b3b46705a10c9045e2~vIKt21Hlc3149131491epoutp04j
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211018124510epoutp0409eaa0416f23a5b3b46705a10c9045e2~vIKt21Hlc3149131491epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561110;
        bh=RKDtrWmtrFbQksXqytLSdBXwPaXj33CRuk264jtjH4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BX1NrgYTDCYQyx7wav+NSqxiazgH72pfAqnI4UL2ibH1Uyw8vx810/wBlS49zFxAe
         y9UkKqI+Jj8TivWG32/P5t/n8PlqkPgdKsE7eRVS/HpZfvicpuZsUeero2coL36wtc
         iJEzxTUiY4FL/oTsdobuQ+SRghU055dNB4PB7XwQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211018124509epcas2p226ff376902bf76dc9dc2430f5ddadbdd~vIKtNoNW_2030920309epcas2p2G;
        Mon, 18 Oct 2021 12:45:09 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.101]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXxRQ2QKVz4x9Q6; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.2C.10014.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p2c68234b4e04cd3149eb21c987d474755~vIKpUP7yg2095320953epcas2p2E;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp1d90e76cdfb460fea5134262175194e90~vIKpTYLHP1588315883epsmtrp1C;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a47-473ff7000000271e-8c-616d6c5297af
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.40.08738.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip203ad1cbcc315333af9067da70c58d033~vIKpD5Liy0235402354epsmtip2s;
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
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 07/15] scsi: ufs: ufs-exynos: support custom version of
 ufs_hba_variant_ops
Date:   Mon, 18 Oct 2021 21:42:08 +0900
Message-Id: <20211018124216.153072-8-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsWy7bCmhW5QTm6iwaEZbBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8Udk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkusDA0MjEyBChOyM349mclYsI63Yl1LA3sD
        4ybuLkZODgkBE4kdV2awdTFycQgJ7GCU+HP+GCuE84lR4uTOfUwgVUICnxkl2p/rdjFygHV8
        WaQJEd7FKHF3LTdE/UdGiR+HL7GBJNgEdCW2PH/FCJIQEXjPKPHk8RR2EIdZ4CmzxLwfvWBV
        wgIJElMu3GIEsVkEVCUu3v/PArKBV8Be4tRGZojz5CWO/OoEszkFHCR6Fh0BO4hXQFDi5Mwn
        LCA2M1BN89bZzCDzJQRecEj8uf+OCaLZReJe/y0WCFtY4tXxLewQtpTEy/42doiGbkaJ1kf/
        oRKrGSU6G30gbHuJX9O3sIIcxCygKbF+lz7E98oSR25B7eWT6Dj8lx0izCvR0SYE0agucWD7
        dKitshLdcz6zQtgeEutXnmeGBNxkRonzy5InMCrMQvLNLCTfzELYu4CReRWjWGpBcW56arFR
        gTE8fpPzczcxgpO6lvsOxhlvP+gdYmTiYDzEKMHBrCTCm+SamyjEm5JYWZValB9fVJqTWnyI
        0RQY1BOZpUST84F5Ja8k3tDE0sDEzMzQ3MjUwFxJnNdSNDtRSCA9sSQ1OzW1ILUIpo+Jg1Oq
        gSlcyujZoYXnWAPra0V9RFU5mo+3Li2TeLXdn/Hu43lSQb6e/89HXTtsMMl2Ze00xQPHXIKP
        /djzRyyrek6f95xASd38Tm8Fpm0Hs7jPNc1q42LfoVo5jWHT+dPmZTb53XVHvnRP+tg7y5E/
        OOfPTHH3awlndk1y0fzoL+SgdoUtVG1zS7fO/u9hW/r8+bI2lGi0HHBmTVC+c/9w0RS137Nr
        smvLmRgtV6lGOfJq5avGultbiUTYVB5r2Gh5d4nFe1d5aZZjOzNKd/ZXFm065/bNL/fm3R/u
        Ghb32n5aVp3LCp42+YfUV6eSHxNrfzc8e830TTf3ru/HQ1b7f3/wkdp+Na830b+5W85vSuNj
        JZbijERDLeai4kQAzdL93HMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwfeHihYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        v57MZCxYx1uxrqWBvYFxE3cXIweHhICJxJdFml2MXBxCAjsYJRbvmMrexcgJFJeVePZuB5Qt
        LHG/5QgrRNF7Rom3//czgiTYBHQltjx/BWaLCHxklJjzTQukiFngI7PEnZVLWEASwgJxElN+
        nAKzWQRUJS7e/88CsplXwF7i1EZmiAXyEkd+dYLZnAIOEj2LjjCB2EJAJYtfzgaL8woISpyc
        +QRsDDNQffPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMj
        OAK1tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeJNfcRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pO
        xgsJpCeWpGanphakFsFkmTg4pRqYPB3e5/ks+xR1YP6E0kfLDnD3VM388LJcf/UM1xma6bcc
        f19+ccsk9pfHZOHTrYE5prU5m5u7j+s8nP009vVzCTPVU5dYT4Rc1tq+csn3tDqnSb0u0acq
        Ew3Pn1Qt3Co4xWvF1+VLeNSqcouM/V8Y+k7/rl871a/wg9GWkJbXETx7OE9yeqb/6uAztHjO
        X/k7+ubva4EfD9zne5U0I+4cu7uVlUlQ2vqy6lsiGQ4/nvjVHWRauye7tClkv8DprTW2TYXt
        svPFngi/mZmTdJ/zeWP79tkbdqyYJpe3//SPxIJZ33vvzrHhakm+0X/kgXLaPtXD309GXlvC
        pBDe464Qlpb1WPq4whavPcWnmO3jlViKMxINtZiLihMBa1iHnC8DAAA=
X-CMS-MailID: 20211018124505epcas2p2c68234b4e04cd3149eb21c987d474755
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p2c68234b4e04cd3149eb21c987d474755
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p2c68234b4e04cd3149eb21c987d474755@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, ufs_hba_exynos_ops will be used but this patch supports to
use custom version of ufs_hba_variant_ops because some variants of
exynos-ufs will use only few callbacks.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 226e7e64fad4..5536b104794a 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1237,8 +1237,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
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
index 2e72aabaa673..74f556d8a003 100644
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

